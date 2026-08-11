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
                BindLeaveSummary();
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
                        litRecentCount.Text = dtRecent.Rows.Count.ToString();
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


        // leave summary method

        private void BindLeaveSummary()
        {
            List<LeaveSummaryItem> items = new List<LeaveSummaryItem>();

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT Leave_Type, Leave_Quota, Quota_Availed FROM Web_Leave_Summary ORDER BY Leave_Quota DESC", con))
            {
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        items.Add(new LeaveSummaryItem
                        {
                            LeaveType = dr["Leave_Type"].ToString(),
                            Quota = Convert.ToInt32(dr["Leave_Quota"]),
                            Availed = Convert.ToInt32(dr["Quota_Availed"])
                        });
                    }
                }
            }

            if (items.Count == 0)
            {
                lblNoLeave.Visible = true;
                return;
            }

            litLeaveTypeCount.Text = items.Count.ToString();
            StringBuilder listHtml = new StringBuilder();
            foreach (var item in items)
            {
                int remaining = item.Quota - item.Availed;
                int percentUsed = item.Quota == 0 ? 0 : (int)Math.Round(item.Availed * 100.0 / item.Quota);
                string colorClass = GetLeaveColorClass(item.LeaveType);

                listHtml.Append("<div class='leave-bar-item'>");
                listHtml.Append("<div class='leave-bar-fill " + colorClass + "' data-target-width='" + percentUsed + "'></div>");
                listHtml.Append("<div class='leave-bar-inner'>");
                listHtml.Append("<div class='leave-bar-chip'>");
                listHtml.Append("<div class='leave-bar-icon'><i class='bi " + GetLeaveIconClass(item.LeaveType) + "'></i><span class='leave-bar-icon-dot " + colorClass + "'></span></div>");
                listHtml.Append("<span class='leave-bar-name'>" + item.LeaveType + "</span>");
                listHtml.Append("</div>");
                listHtml.Append("<div class='leave-bar-badge " + colorClass + "'>" + remaining + " / " + item.Quota + " left</div>");
                listHtml.Append("</div></div>");
            }
            litLeaveList.Text = listHtml.ToString();
            // Chart.js block removed - no longer needed
        }

        private string GetLeaveIconClass(string leaveType)
        {
            switch (leaveType.Trim().ToLower())
            {
                case "annual leave": return "bi-airplane-fill";
                case "sick leave": return "bi-heart-pulse-fill";
                case "casual leave": return "bi-cup-hot-fill";
                case "emergency leave": return "bi-exclamation-octagon-fill";
                default: return "bi-calendar2-week-fill";
            }
        }

        private string GetLeaveColorClass(string leaveType)
        {
            switch (leaveType.Trim().ToLower())
            {
                case "annual leave": return "purple";
                case "sick leave": return "red";
                case "casual leave": return "blue";
                case "emergency leave": return "pink";
                default: return "purple";
            }
        }

        // small helper class, add at the bottom of the Dashboard class or as its own file
        private class LeaveSummaryItem
        {
            public string LeaveType { get; set; }
            public int Quota { get; set; }
            public int Availed { get; set; }
        }

        // leave summary ends here

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
                    int deptCount = 0;
                    while (dr.Read())
                    {
                        deptCount++;
                        hasData = true;
                        if (labels.Length > 0) { labels.Append(","); counts.Append(","); }
                        labels.Append("'").Append(dr["DeptName"].ToString().Replace("'", "\\'")).Append("'");
                        counts.Append(Convert.ToInt32(dr["EmpCount"]));
                    }
                    litDeptChartCount.Text = deptCount.ToString();
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

            foreach (int rootId in trueRootIds)
                ComputeDepth(nodes[rootId], 0, depthMap);

            // ---- who's logged in? ----
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

            // ---- decide what to display, and what to auto-expand ----
            List<OrgNode> displayRoots = new List<OrgNode>();
            HashSet<int> autoExpandIds = new HashSet<int>();

            if (isAdmin)
            {
                foreach (int rootId in trueRootIds)
                {
                    displayRoots.Add(nodes[rootId]);
                    autoExpandIds.Add(rootId); // same as before: only top level auto-opens
                }
            }
            else if (myOrgRoleId.HasValue && nodes.ContainsKey(myOrgRoleId.Value))
            {
                OrgNode myNode = nodes[myOrgRoleId.Value];
                int? parentId = parentMap[myOrgRoleId.Value];

                if (parentId.HasValue && nodes.ContainsKey(parentId.Value))
                {
                    OrgNode mgr = nodes[parentId.Value];

                    // Synthetic "view" of the manager showing ONLY you as a child -
                    // hides your siblings, doesn't touch the real nodes dictionary.
                    OrgNode mgrView = new OrgNode
                    {
                        OrgRoleID = mgr.OrgRoleID,
                        RoleTitle = mgr.RoleTitle,
                        EmpID = mgr.EmpID,
                        EmpName = mgr.EmpName,
                        Designation = mgr.Designation,
                        Children = new List<OrgNode> { myNode }
                    };

                    displayRoots.Add(mgrView);
                    autoExpandIds.Add(mgr.OrgRoleID);       // reveal "you" under your manager
                    autoExpandIds.Add(myOrgRoleId.Value);   // reveal your own direct reports
                }
                else
                {
                    displayRoots.Add(myNode); // you're already at the very top (e.g. CEO)
                    autoExpandIds.Add(myOrgRoleId.Value);
                }
            }
            else
            {
                litOrgChart.Text = "<div class='empty-state'>Your account isn't linked to an organizational role yet. Contact an admin.</div>";
                return;
            }

            StringBuilder html = new StringBuilder();
            html.Append("<div class='tree'><ul>");
            foreach (OrgNode root in displayRoots)
                html.Append(RenderNode(root, depthMap[root.OrgRoleID], autoExpandIds));
            html.Append("</ul></div>");

            litOrgChart.Text = html.ToString();
        }

        private void ComputeDepth(OrgNode node, int depth, Dictionary<int, int> depthMap)
        {
            depthMap[node.OrgRoleID] = depth;
            foreach (var child in node.Children)
                ComputeDepth(child, depth + 1, depthMap);
        }


        private string RenderNode(OrgNode node, int depth, HashSet<int> autoExpandIds)
        {
            string tierClass = depth == 0 ? "org-root"
                              : depth == 1 ? "org-manager"
                              : depth == 2 ? "org-staff"
                              : "org-intern";

            string initials = string.IsNullOrEmpty(node.EmpName) ? "?" : GetInitials(node.EmpName);
            string personName = string.IsNullOrEmpty(node.EmpName) ? "<span class='org-vacant'>Vacant</span>" : node.EmpName;
            string nodeId = "orgnode-" + node.OrgRoleID;
            bool hasChildren = node.Children.Any();
            bool expand = autoExpandIds.Contains(node.OrgRoleID);

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
                string icon = expand ? "bi-chevron-up" : "bi-chevron-down";
                sb.Append("<div class='org-toggle-icon" + (expand ? " rotated" : "") + "'><i class='bi " + icon + "'></i></div>");
            }

            sb.Append("</div>");

            if (hasChildren)
            {
                string childClass = expand ? "org-children-visible" : "org-children-hidden";
                sb.Append("<ul class='" + childClass + "' id='" + nodeId + "-children'>");
                foreach (var child in node.Children)
                    sb.Append(RenderNode(child, depth + 1, autoExpandIds));
                sb.Append("</ul>");
            }

            sb.Append("</li>");
            return sb.ToString();
        }
    }
}