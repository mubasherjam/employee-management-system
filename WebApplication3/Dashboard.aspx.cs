using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Collections.Generic;
using System.Linq;


namespace HRMSApp
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["myDB1"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboardData();
                RenderOrgChart();
            }
        }

        private void LoadDashboardData()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Dashboard_GetData", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    // ---- Result Set 1: summary stats ----
                    if (dr.Read())
                    {
                        litActiveCount.Text = dr["ActiveEmployees"].ToString();
                        litInactiveCount.Text = dr["InactiveEmployees"].ToString();
                        litDeptCount.Text = dr["TotalDepartments"].ToString();

                        decimal payroll = Convert.ToDecimal(dr["TotalPayroll"]);
                        litTotalPayroll.Text = payroll.ToString("N0"); // e.g. 245,000
                    }

                    // ---- Result Set 2: recent employees ----
                    dr.NextResult();
                    DataTable dtRecent = new DataTable();
                    dtRecent.Load(dr); // loads current result set only

                    if (dtRecent.Rows.Count > 0)
                    {
                        rptRecent.DataSource = dtRecent;
                        rptRecent.DataBind();
                    }
                    else
                    {
                        lblNoRecent.Visible = true;
                    }
                }
            }

            // Second call for result set 3, since DataTable.Load(dr) above
            // consumes the reader up to that point; simplest safe approach
            // is a fresh lightweight call for the chart data.
            BindDepartmentChart();
        }

        private void BindDepartmentChart()
        {
            StringBuilder labels = new StringBuilder();
            StringBuilder counts = new StringBuilder();
            bool hasData = false;

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand(
                @"SELECT d.DeptName, COUNT(e.EmpID) AS EmpCount
                  FROM Department d
                  LEFT JOIN Employee e ON e.DeptID = d.DeptID AND e.IsActive = 1
                  WHERE d.EndDate IS NULL
                  GROUP BY d.DeptName
                  ORDER BY EmpCount DESC", con))
            {
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        hasData = true;
                        if (labels.Length > 0) { labels.Append(","); counts.Append(","); }
                        labels.Append("'").Append(dr["DeptName"].ToString().Replace("'", "\\'")).Append("'");
                        counts.Append(Convert.ToInt32(dr["EmpCount"]));
                    }
                }
            }

            if (!hasData)
            {
                lblNoDepts.Visible = true;
                return;
            }

            string script = @"
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        var ctx = document.getElementById('deptChart').getContext('2d');
                        new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: [" + labels + @"],
                                datasets: [{
                                    label: 'Employees',
                                    data: [" + counts + @"],
                                    backgroundColor: '#7c5cff',
                                    borderRadius: 8,
                                    maxBarThickness: 40
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: { legend: { display: false } },
                                scales: {
                                    y: { beginAtZero: true, ticks: { stepSize: 1 } }
                                }
                            }
                        });
                    });
                </script>";

            ltrChartScript.Text = script;
        }

        // Same helper as EmployeeList.aspx.cs, kept identical for consistency
        protected string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "?";
            string[] parts = fullName.Trim().Split(' ');
            if (parts.Length == 1) return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        // organizational chartview
        private void RenderOrgChart()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_OrgChart_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            Dictionary<int, OrgNode> nodes = new Dictionary<int, OrgNode>();
            Dictionary<int, int?> parentMap = new Dictionary<int, int?>();
            Dictionary<int, int> depthMap = new Dictionary<int, int>();
            List<int> trueRootIds = new List<int>();

            foreach (DataRow row in dt.Rows)
            {
                int roleId = Convert.ToInt32(row["OrgRoleID"]);
                if (!nodes.ContainsKey(roleId))
                {
                    nodes[roleId] = new OrgNode
                    {
                        OrgRoleID = roleId,
                        RoleTitle = row["RoleTitle"].ToString(),
                        EmpID = row["EmpID"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["EmpID"]),
                        EmpName = row["EmpName"] == DBNull.Value ? null : row["EmpName"].ToString(),
                        Designation = row["Designation"] == DBNull.Value ? null : row["Designation"].ToString()
                    };
                    parentMap[roleId] = row["ParentOrgRoleID"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["ParentOrgRoleID"]);
                }
            }

            foreach (var kvp in parentMap)
            {
                if (kvp.Value == null) trueRootIds.Add(kvp.Key);
                else nodes[kvp.Value.Value].Children.Add(nodes[kvp.Key]);
            }

            // True depth from the real root, so tier colors (green/blue/purple/pink)
            // stay correct even when a non-admin's own node is displayed as the top.
            foreach (int rootId in trueRootIds)
                ComputeDepth(nodes[rootId], 0, depthMap);

            // ---- NEW: figure out what this logged-in user is allowed to see ----
            bool isAdmin = false;
            int? myOrgRoleId = null;

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand(
                @"SELECT u.Role, e.OrgRoleID
          FROM Users u
          LEFT JOIN Employee e ON u.EmpID = e.EmpID
          WHERE u.UserID = @UserID", con))
            {
                cmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(Session["UserID"]));
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        isAdmin = dr["Role"] != DBNull.Value && dr["Role"].ToString() == "Admin";
                        myOrgRoleId = dr["OrgRoleID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["OrgRoleID"]);
                    }
                }
            }

            List<int> displayRootIds;

            if (isAdmin)
            {
                displayRootIds = trueRootIds; // full hierarchy
            }
            else if (myOrgRoleId.HasValue && nodes.ContainsKey(myOrgRoleId.Value))
            {
                displayRootIds = new List<int> { myOrgRoleId.Value }; // self + descendants only
            }
            else
            {
                litOrgChart.Text = "<div class='empty-state'>Your account isn't linked to an organizational role yet. Contact an admin.</div>";
                return;
            }

            StringBuilder html = new StringBuilder();
            html.Append("<div class='tree'><ul>");
            foreach (int rootId in displayRootIds)
                html.Append(RenderNode(nodes[rootId], depthMap[rootId])); // true depth = correct tier color
            html.Append("</ul></div>");

            litOrgChart.Text = html.ToString();
        }

        // NEW helper
        private void ComputeDepth(OrgNode node, int depth, Dictionary<int, int> depthMap)
        {
            depthMap[node.OrgRoleID] = depth;
            foreach (var child in node.Children)
                ComputeDepth(child, depth + 1, depthMap);
        }
        private string RenderNode(OrgNode node, int depth)
        {
            string tierClass = depth == 0 ? "org-root"
                              : depth == 1 ? "org-manager"
                              : depth == 2 ? "org-staff"
                              : "org-intern";

            string initials = string.IsNullOrEmpty(node.EmpName) ? "?" : GetInitials(node.EmpName);
            string personName = string.IsNullOrEmpty(node.EmpName) ? "<span class='org-vacant'>Vacant</span>" : node.EmpName;
            string nodeId = "orgnode-" + node.OrgRoleID;
            bool hasChildren = node.Children.Any();

            StringBuilder sb = new StringBuilder();
            sb.Append("<li>");
            sb.Append("<div class='org-card " + tierClass + "' id='" + nodeId + "' " +
                       (hasChildren ? "onclick=\"toggleOrgNode('" + nodeId + "')\" style='cursor:pointer;'" : "") + ">");

            if (node.EmpID.HasValue)
            {
                sb.Append("<div class='org-avatar-photo-wrap'>");
                sb.Append("<img class='org-avatar-photo' src='ShowImage.ashx?EmpID=" + node.EmpID.Value + "' " +
                          "onerror=\"this.style.display='none'; this.nextElementSibling.style.display='flex';\" />");
                sb.Append("<div class='org-avatar' style='display:none;'>" + initials + "</div>");
                sb.Append("</div>");
            }
            else
            {
                sb.Append("<div class='org-avatar-photo-wrap'>");
                sb.Append("<div class='org-avatar'>" + initials + "</div>");
                sb.Append("</div>");
            }

            sb.Append("<div class='org-person'>" + personName + "</div>");
            sb.Append("<div class='org-title'>" + node.RoleTitle + "</div>");

            if (hasChildren)
            {
                sb.Append("<div class='org-toggle-icon'><i class='bi bi-chevron-down'></i></div>");
            }

            sb.Append("</div>");

            if (hasChildren)
            {
                sb.Append("<ul class='org-children-hidden' id='" + nodeId + "-children'>");
                foreach (var child in node.Children)
                    sb.Append(RenderNode(child, depth + 1));
                sb.Append("</ul>");
            }

            sb.Append("</li>");
            return sb.ToString();
        }
    }
}