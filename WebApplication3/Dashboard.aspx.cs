using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Globalization;


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
                BindAttendanceChart();
                BindTeamAttendance();
                BindLast7DaysSummary();
                BindStatusBreakdown();
                BindEventHistoryChart();
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

            double circumference = 2 * Math.PI * 40; // matches r=40 in the SVG markup
            StringBuilder listHtml = new StringBuilder();
            int idx = 0;

            foreach (var item in items)
            {
                int remaining = item.Quota - item.Availed;
                if (remaining < 0) remaining = 0;

                double percentRemaining = item.Quota == 0 ? 0 : (remaining * 100.0 / item.Quota);
                double targetOffset = circumference - (percentRemaining / 100.0) * circumference;

                double percentUsed = item.Quota == 0 ? 0 : (item.Availed * 100.0 / item.Quota);
                if (percentUsed > 100) percentUsed = 100;
                if (percentUsed < 0) percentUsed = 0;

                string colorHex = GetLeaveColorHex(item.LeaveType);
                string iconClass = GetLeaveIconClass(item.LeaveType);

                // MD4 grid: 1-up on phones, 2-up on tablets, 3-up (col-md-4) on desktop
                listHtml.Append("<div class='col-sm-6 col-md-4'>");
                listHtml.Append("<div class='leave-ring-card' style='animation-delay:" + (idx * 0.08).ToString("0.00") + "s;'>");
                listHtml.Append("<div class='leave-ring-blob'></div>");

                listHtml.Append("<div class='leave-ring-header'>");
                listHtml.Append("<div class='leave-ring-icon' style='background:" + colorHex + ";'><i class='bi " + iconClass + "'></i></div>");
                listHtml.Append("<div class='leave-ring-title'>" + item.LeaveType + "</div>");
                listHtml.Append("</div>");

                listHtml.Append("<div class='leave-ring-svg-wrap'>");
                listHtml.Append("<svg width='108' height='108' viewBox='0 0 108 108'>");
                listHtml.Append("<circle cx='54' cy='54' r='40' class='leave-ring-track' />");
                listHtml.Append("<circle cx='54' cy='54' r='40' class='leave-ring-progress' stroke='" + colorHex + "' " +
                                                    "stroke-dasharray='" + circumference.ToString("0.0") + "' " +
                    "stroke-dashoffset='" + circumference.ToString("0.0") + "' " +
                    "data-target-offset='" + targetOffset.ToString("0.0") + "' />");
                listHtml.Append("</svg>");
                listHtml.Append("<div class='leave-ring-center'>");
                listHtml.Append("<span class='leave-ring-num'>" + remaining + "</span>");
                listHtml.Append("<span class='leave-ring-sub'>days left</span>");
                listHtml.Append("</div>");
                listHtml.Append("</div>");

                listHtml.Append("<div class='leave-usage-bar-bg'><div class='leave-usage-bar-fill' style='width:" +
                    percentUsed.ToString("0") + "%; background:" + colorHex + ";'></div></div>");

                listHtml.Append("<div class='leave-ring-footer'>");
                listHtml.Append("<span class='leave-ring-stat'><b>" + item.Availed + "</b> used</span>");
                listHtml.Append("<span class='leave-ring-divider'>/</span>");
                listHtml.Append("<span class='leave-ring-stat'><b>" + item.Quota + "</b> total</span>");
                listHtml.Append("</div>");

                listHtml.Append("</div>");
                listHtml.Append("</div>");
                idx++;
            }

            litLeaveList.Text = "<div class='row g-3'>" + listHtml.ToString() + "</div>";
        }

        private string GetLeaveColorHex(string leaveType)
        {
            switch (leaveType.Trim().ToLower())
            {
                case "annual leave": return "#7c5cff";
                case "sick leave": return "#e0392b";
                case "casual leave": return "#2a5cc4";
                case "emergency leave": return "#c22e73";
                default: return "#7c5cff";
            }
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


        // attendace chart starts here

        private void BindAttendanceChart()
        {
            StringBuilder labels = new StringBuilder();
            StringBuilder hours = new StringBuilder();
            StringBuilder barColors = new StringBuilder();
            bool hasData = false;

            int inTimeCount = 0, lateCount = 0, notArrivedCount = 0;

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Attendance_GetChartData", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        hasData = true;
                        string status = dr["Status"].ToString();
                        decimal hoursWorked = Convert.ToDecimal(dr["HoursWorked"]);
                        string dateLabel = dr["DateLabel"].ToString();

                        if (labels.Length > 0) { labels.Append(","); hours.Append(","); barColors.Append(","); }

                        labels.Append("'").Append(dateLabel).Append("'");
                        hours.Append(hoursWorked.ToString("0.00"));

                        string color;
                        switch (status)
                        {
                            case "In time":
                                color = "'#16a34a'";
                                inTimeCount++;
                                break;
                            case "Late":
                                color = "'#f59e0b'";
                                lateCount++;
                                break;
                            default: // Not Arrived
                                color = "'#94a3b8'";
                                notArrivedCount++;
                                break;
                        }
                        barColors.Append(color);
                    }
                }
            }

            litInTimeCount.Text = inTimeCount.ToString();
            litLateCount.Text = lateCount.ToString();
            litNotArrivedCount.Text = notArrivedCount.ToString();

            if (!hasData)
            {
                lblNoAttendance.Visible = true;
                return;
            }

            string script = @"
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var ctx = document.getElementById('attendanceChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: [" + labels + @"],
                        datasets: [{
                            label: 'Hours Worked',
                            data: [" + hours + @"],
                            backgroundColor: [" + barColors + @"],
                            borderRadius: 8,
                            maxBarThickness: 32
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        scales: {
                            y: { beginAtZero: true, max: 10, ticks: { stepSize: 2 } }
                        }
                    }
                });
            });
        </script>";

            ltrAttendanceChartScript.Text = script;
        }

        // attendance chart ends here

        // team attendance starts here
        protected string GetAttendanceRate(object inTimeObj, object totalObj)
        {
            int inTime = Convert.ToInt32(inTimeObj);
            int total = Convert.ToInt32(totalObj);
            if (total == 0) return "0";
            return Math.Round((inTime * 100.0) / total).ToString();
        }

        private void BindTeamAttendance()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_TeamAttendance_GetSummary", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            if (dt.Rows.Count == 0)
            {
                lblNoTeamAttendance.Visible = true;
                return;
            }

            litTeamAttCount.Text = dt.Rows.Count.ToString();

            rptTeamAttendance.DataSource = dt;
            rptTeamAttendance.DataBind();

            StringBuilder labels = new StringBuilder();
            StringBuilder inTimeData = new StringBuilder();
            StringBuilder lateData = new StringBuilder();
            StringBuilder notArrivedData = new StringBuilder();

            foreach (DataRow row in dt.Rows)
            {
                if (labels.Length > 0) { labels.Append(","); inTimeData.Append(","); lateData.Append(","); notArrivedData.Append(","); }
                labels.Append("'").Append(row["EmpName"].ToString().Replace("'", "\\'")).Append("'");
                inTimeData.Append(row["InTimeCount"]);
                lateData.Append(row["LateCount"]);
                notArrivedData.Append(row["NotArrivedCount"]);
            }

            string script = @"
        <script>
        document.addEventListener('DOMContentLoaded', function () {
            var ctx = document.getElementById('teamAttendanceChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: [" + labels + @"],
                    datasets: [
                        { label: 'In Time', data: [" + inTimeData + @"], backgroundColor: '#16a34a', borderRadius: 6, maxBarThickness: 38 },
                        { label: 'Late', data: [" + lateData + @"], backgroundColor: '#f59e0b', borderRadius: 6, maxBarThickness: 38 },
                        { label: 'Not Arrived', data: [" + notArrivedData + @"], backgroundColor: '#94a3b8', borderRadius: 6, maxBarThickness: 38 }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom', labels: { color: '#64748b', usePointStyle: true, padding: 16, font: { size: 11 } } }
                    },
                    scales: {
                        x: { stacked: true, grid: { display: false } },
                        y: { stacked: true, beginAtZero: true, ticks: { stepSize: 1 } }
                    }
                }
            });
        });
        </script>";

            ltrTeamAttendanceScript.Text = script;
        }

        // last 7 days checkin card
        private void BindLast7DaysSummary()
        {
            // Static sample data (no database call)
            litL7AvgCheckIn.Text = "09:05 AM";
            litL7AvgCheckOut.Text = "06:30 PM";
            litL7AvgHours.Text = "8.2";
            litL7TotalAbsents.Text = "5";

            litL7AvgCheckInAlt.Text = litL7AvgCheckIn.Text;
            litL7AvgCheckOutAlt.Text = litL7AvgCheckOut.Text;
            litL7AvgHoursAlt.Text = litL7AvgHours.Text;
            litL7TotalAbsentsAlt.Text = litL7TotalAbsents.Text;

            BindLast7DaysTrendChart();
        }

        // last 7 days trend chart: check-in/check-out window, avg hours and absents per day
        private void BindLast7DaysTrendChart()
        {
            DateTime rangeEnd = DateTime.Today;
            DateTime rangeStart = rangeEnd.AddDays(-6);

            // Static sample data (no database call): averages to check-in 9:05 AM,
            // check-out 6:30 PM, 8.2 hrs/day, and 5 absents across the week.
            int[] checkInMinutes = { 540, 550, 545, 548, 542, 546, 544 };
            int[] checkOutMinutes = { 1105, 1115, 1108, 1112, 1106, 1112, 1112 };
            decimal[] avgHoursPerDay = { 8.0m, 8.4m, 8.1m, 8.3m, 8.0m, 8.5m, 8.1m };
            int[] absentsPerDay = { 1, 0, 1, 1, 0, 1, 1 };

            StringBuilder labels = new StringBuilder();
            StringBuilder checkInMins = new StringBuilder();
            StringBuilder checkOutMins = new StringBuilder();
            StringBuilder hours = new StringBuilder();
            StringBuilder absents = new StringBuilder();

            for (int i = 0; i < 7; i++)
            {
                DateTime day = rangeStart.AddDays(i);
                if (labels.Length > 0) { labels.Append(","); checkInMins.Append(","); checkOutMins.Append(","); hours.Append(","); absents.Append(","); }

                labels.Append("'").Append(day.ToString("ddd MMM dd")).Append("'");
                checkInMins.Append(checkInMinutes[i]);
                checkOutMins.Append(checkOutMinutes[i]);
                hours.Append(avgHoursPerDay[i].ToString("0.00"));
                absents.Append(absentsPerDay[i]);
            }

            litL7Range.Text = rangeStart.ToString("MMM d") + " &ndash; " + rangeEnd.ToString("MMM d");
            litL7RangeAlt.Text = litL7Range.Text;

            string script = @"
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                function fmtTime(minutes) {
                    if (minutes === null || minutes === undefined || isNaN(minutes)) return '--:--';
                    var h = Math.floor(minutes / 60), m = Math.round(minutes % 60);
                    var ap = h >= 12 ? 'PM' : 'AM';
                    var h12 = h % 12; if (h12 === 0) h12 = 12;
                    return h12 + ':' + (m < 10 ? '0' : '') + m + ' ' + ap;
                }

                var dayLabels = [" + labels + @"];

                // One tiny single-metric trend line per KPI tile - deliberately no axes/legend,
                // so each tile reads as ""the number, and whether this week trended up or down"".
                // The y-range is always padded around the data's own min/max (never a fixed 0-based
                // scale), so a near-flat week still reads as a visible line instead of vanishing flat.
                function makeSparkline(canvasId, data, formatter, lineColor, fillColor, tooltipEnabled) {
                    var el = document.getElementById(canvasId);
                    if (!el) return null;
                    var ctx = el.getContext('2d');
                    var fillGrad = ctx.createLinearGradient(0, 0, 0, 46);
                    fillGrad.addColorStop(0, fillColor.replace('ALPHA', '0.35'));
                    fillGrad.addColorStop(1, fillColor.replace('ALPHA', '0.02'));

                    var validVals = data.filter(function (v) { return v !== null && v !== undefined && !isNaN(v); });
                    var lastIdx = -1;
                    for (var i = data.length - 1; i >= 0; i--) {
                        if (data[i] !== null && data[i] !== undefined && !isNaN(data[i])) { lastIdx = i; break; }
                    }
                    var pointRadii = data.map(function (v, i) { return i === lastIdx ? 3.5 : 0; });

                    var min = Math.min.apply(null, validVals);
                    var max = Math.max.apply(null, validVals);
                    var range = max - min;
                    var pad = range === 0 ? (Math.abs(max) * 0.08 || 1) : range * 0.35;

                    return new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: dayLabels,
                            datasets: [{
                                data: data,
                                borderColor: lineColor,
                                backgroundColor: fillGrad,
                                borderWidth: 2.25,
                                fill: true,
                                tension: 0.4,
                                pointRadius: pointRadii,
                                pointHoverRadius: 5,
                                pointBackgroundColor: '#fbbf24',
                                pointBorderColor: '#fbbf24',
                                pointBorderWidth: 0,
                                pointHoverBackgroundColor: '#fbbf24',
                                pointHoverBorderColor: '#fbbf24',
                                pointHoverBorderWidth: 0,
                                spanGaps: true
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            interaction: { intersect: false, mode: 'index' },
                            plugins: {
                                legend: { display: false },
                                tooltip: tooltipEnabled === false ? { enabled: false } : {
                                    backgroundColor: '#1a2332',
                                    displayColors: false,
                                    padding: 8,
                                    cornerRadius: 8,
                                    titleFont: { size: 11, weight: '700' },
                                    bodyFont: { size: 11 },
                                    callbacks: {
                                        title: function (items) { return items[0].label; },
                                        label: function (item) { return formatter(item.raw); }
                                    }
                                }
                            },
                            scales: {
                                x: { display: false },
                                y: { display: false, min: min - pad, max: max + pad }
                            }
                        }
                    });
                }

                var l7SparkCharts = [
                    makeSparkline('l7SparkCheckIn', [" + checkInMins + @"], fmtTime, '#4f8cf7', 'rgba(79,140,247,ALPHA)'),
                    makeSparkline('l7SparkCheckOut', [" + checkOutMins + @"], fmtTime, '#9b7bff', 'rgba(155,123,255,ALPHA)'),
                    makeSparkline('l7SparkHours', [" + hours + @"], function (v) { return v + ' hrs'; }, '#34d399', 'rgba(52,211,153,ALPHA)'),
                    makeSparkline('l7SparkAbsent', [" + absents + @"], function (v) { return v + (v === 1 ? ' absent' : ' absents'); }, '#f472b6', 'rgba(244,114,182,ALPHA)'),
                    makeSparkline('l7vSparkCheckIn', [" + checkInMins + @"], fmtTime, '#4f8cf7', 'rgba(79,140,247,ALPHA)', false),
                    makeSparkline('l7vSparkCheckOut', [" + checkOutMins + @"], fmtTime, '#9b7bff', 'rgba(155,123,255,ALPHA)', false),
                    makeSparkline('l7vSparkHours', [" + hours + @"], function (v) { return v + ' hrs'; }, '#34d399', 'rgba(52,211,153,ALPHA)', false),
                    makeSparkline('l7vSparkAbsent', [" + absents + @"], function (v) { return v + (v === 1 ? ' absent' : ' absents'); }, '#f472b6', 'rgba(244,114,182,ALPHA)', false)
                ];

                // The panel's own entrance animation and grid layout can settle a moment after
                // Chart.js takes its first size reading, which is what left some sparklines
                // measuring the wrong column width. Re-measuring once things are fully laid out
                // fixes that without guessing at a fixed delay that could still race the animation.
                window.addEventListener('load', function () {
                    setTimeout(function () {
                        l7SparkCharts.forEach(function (c) { if (c) c.resize(); });
                    }, 700);
                });
            });
        </script>";

            ltrL7ChartScript.Text = script;
        }

        // compensation history trend: TGC range per event date, for the logged-in employee
        private void BindEventHistoryChart()
        {
            // Shows this specific employee's compensation history to any logged-in user, regardless of role
            int empId = 16; // <-- set this to whichever EmpID has data in EmployeeEventHistory

            var byDate = new SortedDictionary<DateTime, decimal>();

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_EmployeeEventHistory_GetByEmpID", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpID", empId);
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        DateTime eventDate = Convert.ToDateTime(dr["EventDate"]);
                        decimal amount = dr["EntitlementAmount"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["EntitlementAmount"]);
                        byDate[eventDate] = amount;
                    }
                }
            }

            if (byDate.Count == 0)
            {
                lblNoEventHistory.Visible = true;
                return;
            }

            litTgcRange.Text = byDate.Keys.First().ToString("MMM yyyy", CultureInfo.InvariantCulture)
                + " – " + byDate.Keys.Last().ToString("MMM yyyy", CultureInfo.InvariantCulture);

            StringBuilder labels = new StringBuilder();
            StringBuilder values = new StringBuilder();
            foreach (var kv in byDate)
            {
                if (labels.Length > 0) { labels.Append(","); values.Append(","); }
                labels.Append("'").Append(kv.Key.ToString("MMM yy", CultureInfo.InvariantCulture)).Append("'");
                values.Append(kv.Value.ToString("0.###", CultureInfo.InvariantCulture));
            }

            string script = @"
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var canvas = document.getElementById('tgcRangeChart');
                var ctx = canvas.getContext('2d');

                var labels = [" + labels + @"];
                var values = [" + values + @"];
                var lastIdx = values.length - 1;

                // Cool-to-violet stroke gradient and a soft fade-to-transparent fill, so the
                // line reads as a single accent rather than a flat, single-color chart.
                var lineGrad = ctx.createLinearGradient(0, 0, canvas.clientWidth || 400, 0);
                lineGrad.addColorStop(0, '#4f8cf7');
                lineGrad.addColorStop(1, '#7c5cff');

                var fillGrad = ctx.createLinearGradient(0, 0, 0, 260);
                fillGrad.addColorStop(0, 'rgba(79,140,247,0.28)');
                fillGrad.addColorStop(1, 'rgba(79,140,247,0.02)');

                var pointColors = values.map(function (v, i) { return i === lastIdx ? '#f59e0b' : '#4f8cf7'; });
                var pointRadii = values.map(function (v, i) { return i === lastIdx ? 6 : 4; });

                // Draws a small rounded 'chip' with the value above each point, using only
                // the canvas 2D API Chart.js already exposes - no datalabels plugin required,
                // so this file has no extra script tag to bring along into another project.
                var valueChipsPlugin = {
                    id: 'tgcValueChips',
                    afterDatasetsDraw: function (chart) {
                        var chipCtx = chart.ctx;
                        var meta = chart.getDatasetMeta(0);
                        chipCtx.save();
                        chipCtx.font = '700 10.5px Inter, sans-serif';
                        chipCtx.textAlign = 'center';
                        chipCtx.textBaseline = 'middle';
                        meta.data.forEach(function (point, i) {
                            var text = Number(values[i]).toLocaleString('en-US');
                            var padX = 7, padY = 4, textH = 10.5, radius = 6;
                            var chipW = chipCtx.measureText(text).width + padX * 2;
                            var chipH = textH + padY * 2;
                            var cx = point.x;
                            var cy = point.y - 8 - chipH / 2;
                            var x = cx - chipW / 2, y = cy - chipH / 2;

                            chipCtx.beginPath();
                            chipCtx.moveTo(x + radius, y);
                            chipCtx.arcTo(x + chipW, y, x + chipW, y + chipH, radius);
                            chipCtx.arcTo(x + chipW, y + chipH, x, y + chipH, radius);
                            chipCtx.arcTo(x, y + chipH, x, y, radius);
                            chipCtx.arcTo(x, y, x + chipW, y, radius);
                            chipCtx.closePath();
                            chipCtx.fillStyle = i === lastIdx ? '#f59e0b' : '#334463';
                            chipCtx.fill();

                            chipCtx.fillStyle = '#fff';
                            chipCtx.fillText(text, cx, cy + 1);
                        });
                        chipCtx.restore();
                    }
                };

                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'TGC Range',
                            data: values,
                            borderColor: lineGrad,
                            backgroundColor: fillGrad,
                            borderWidth: 3,
                            pointStyle: 'circle',
                            pointRadius: pointRadii,
                            pointHoverRadius: 8,
                            pointBackgroundColor: pointColors,
                            pointBorderColor: '#fff',
                            pointBorderWidth: 2,
                            pointHoverBorderWidth: 3,
                            fill: true,
                            tension: 0.38
                        }]
                    },
                    plugins: [valueChipsPlugin],
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        interaction: { intersect: false, mode: 'index' },
                        animation: { duration: 1400, easing: 'easeOutQuart' },
                        layout: { padding: { top: 30, right: 12 } },
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                backgroundColor: '#1a2332',
                                displayColors: false,
                                padding: 10,
                                cornerRadius: 10,
                                titleFont: { size: 12, weight: '700' },
                                bodyFont: { size: 12 },
                                callbacks: {
                                    title: function (items) { return items[0].label; },
                                    label: function (item) {
                                        var v = item.raw;
                                        var txt = 'Rs. ' + Number(v).toLocaleString('en-US');
                                        var idx = item.dataIndex;
                                        if (idx > 0 && values[idx - 1]) {
                                            var delta = (v - values[idx - 1]) / values[idx - 1] * 100;
                                            txt += ' (' + (delta >= 0 ? '+' : '') + delta.toFixed(1) + '%)';
                                        }
                                        return txt;
                                    }
                                }
                            }
                        },
                        scales: {
                            x: {
                                grid: { display: false },
                                ticks: { color: '#8892a0', font: { size: 11, weight: '600' } }
                            },
                            y: {
                                beginAtZero: true,
                                grid: { color: '#eef0f4' },
                                border: { display: false },
                                ticks: {
                                    color: '#8892a0',
                                    font: { size: 10.5 },
                                    callback: function (value) { return Number(value).toLocaleString('en-US'); }
                                }
                            }
                        }
                    }
                });

                // Growth chip + current-value strip, derived from the same dataset the chart draws.
                var first = values[0], last = values[lastIdx];
                var growthPct = first ? ((last - first) / first * 100) : 0;
                var chip = document.getElementById('tgcGrowthChip');
                var icon = document.getElementById('tgcGrowthIcon');

                if (growthPct < 0) {
                    chip.classList.add('negative');
                    icon.className = 'bi bi-arrow-down-right';
                }
                document.getElementById('tgcGrowthText').textContent = (growthPct >= 0 ? '+' : '') + growthPct.toFixed(1) + '%';
                document.getElementById('tgcCurrentValue').textContent = 'Rs. ' + Number(last).toLocaleString('en-US');
            });
        </script>";

            ltrEventHistoryChartScript.Text = script;
        }



        //team attendance graph card
        private void BindStatusBreakdown()
        {
            // date -> status -> list of names
            var dateStatusNames = new Dictionary<string, Dictionary<string, List<string>>>();
            var orderedDates = new List<string>();

            int totalOnTime = 0, totalLate = 0, totalAbsent = 0;

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_TeamAttendance_TodayStatus", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        string dateLabel = dr["DateLabel"].ToString();
                        string status = dr["Status"].ToString();
                        string name = dr["EmpName"].ToString();

                        // Normalize any unexpected status value into "Not Arrived" instead of crashing
                        if (status != "In time" && status != "Late")
                        {
                            status = "Not Arrived";
                        }

                        if (!dateStatusNames.ContainsKey(dateLabel))
                        {
                            dateStatusNames[dateLabel] = new Dictionary<string, List<string>>
        {
            { "In time", new List<string>() },
            { "Late", new List<string>() },
            { "Not Arrived", new List<string>() }
        };
                            orderedDates.Add(dateLabel);
                        }

                        dateStatusNames[dateLabel][status].Add(name);

                        if (status == "In time") totalOnTime++;
                        else if (status == "Late") totalLate++;
                        else totalAbsent++;
                    }
                }
            }

            int total = totalOnTime + totalLate + totalAbsent;
            litStatusTotalCount.Text = total.ToString();

            if (total == 0)
            {
                lblNoStatus.Visible = true;
                return;
            }

            // Build labels + per-status count arrays, aligned to orderedDates
            StringBuilder labels = new StringBuilder();
            StringBuilder onTimeCounts = new StringBuilder();
            StringBuilder lateCounts = new StringBuilder();
            StringBuilder absentCounts = new StringBuilder();

            // Nested JS structure: namesByDateAndStatus[dateIndex] = { onTime: [...], late: [...], absent: [...] }
            StringBuilder namesJs = new StringBuilder("[");

            for (int i = 0; i < orderedDates.Count; i++)
            {
                string date = orderedDates[i];
                var statusMap = dateStatusNames[date];

                if (labels.Length > 0) { labels.Append(","); onTimeCounts.Append(","); lateCounts.Append(","); absentCounts.Append(","); namesJs.Append(","); }

                labels.Append("'").Append(date).Append("'");
                onTimeCounts.Append(statusMap["In time"].Count);
                lateCounts.Append(statusMap["Late"].Count);
                absentCounts.Append(statusMap["Not Arrived"].Count);

                namesJs.Append("{ onTime:").Append(BuildJsNameArray(statusMap["In time"]))
                       .Append(", late:").Append(BuildJsNameArray(statusMap["Late"]))
                       .Append(", absent:").Append(BuildJsNameArray(statusMap["Not Arrived"]))
                       .Append(" }");
            }
            namesJs.Append("]");

            string script = @"
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var namesByDate = " + namesJs + @";

                var ctx = document.getElementById('statusChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: [" + labels + @"],
                        datasets: [
                            { label: 'On Time', data: [" + onTimeCounts + @"], backgroundColor: '#16a34a', borderRadius: 5, maxBarThickness: 20 },
                            { label: 'Late', data: [" + lateCounts + @"], backgroundColor: '#f59e0b', borderRadius: 5, maxBarThickness: 20 },
                            { label: 'Absent', data: [" + absentCounts + @"], backgroundColor: '#dc2626', borderRadius: 5, maxBarThickness: 20 }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'bottom', labels: { usePointStyle: true, padding: 14, font: { size: 10 } } },
                            tooltip: {
                                backgroundColor: '#1a2332',
                                padding: 10,
                                cornerRadius: 8,
                                titleFont: { size: 12, weight: '700' },
                                bodyFont: { size: 11 },
                                displayColors: false,
                                callbacks: {
                                    title: function (items) {
                                        return items[0].label + ' - ' + items[0].dataset.label + ' (' + items[0].raw + ')';
                                    },
                                    label: function (context) {
                                        var dayNames = namesByDate[context.dataIndex];
                                        var key = context.datasetIndex === 0 ? 'onTime' : (context.datasetIndex === 1 ? 'late' : 'absent');
                                        var names = dayNames[key];
                                        return (names && names.length > 0) ? names.join(', ') : 'None';
                                    }
                                }
                            }
                        },
                        scales: {
                            x: { grid: { display: false }, ticks: { font: { size: 10 } } },
                            y: { beginAtZero: true, ticks: { stepSize: 1, font: { size: 10 } } }
                        }
                    }
                });
            });
        </script>";

            ltrStatusChartScript.Text = script;
        }

        private string BuildJsNameArray(List<string> names)
        {
            if (names.Count == 0) return "[]";
            var escaped = names.Select(n => "'" + n.Replace("'", "\\'") + "'");
            return "[" + string.Join(",", escaped) + "]";
        }
    }
}