using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

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
    }
}