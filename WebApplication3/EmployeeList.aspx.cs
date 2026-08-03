using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace HRMSApp
{
    public partial class EmployeeList : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["myDB1"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("MyProfile.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Employee_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvEmployees.DataSource = dt;
                gvEmployees.DataBind();
                lblCount.Text = dt.Rows.Count + " Employee" + (dt.Rows.Count == 1 ? "" : "s");
            }
        }

        // Fires when the pencil icon is clicked on any row
        protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                int empId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect("EmployeeProfile.aspx?EmpID=" + empId);
            }
        }

        protected void btnNewEntry_Click(object sender, EventArgs e)
        {
            Response.Redirect("EmployeeProfile.aspx");
        }

        // Used in the markup to show initials in the avatar circle
        protected string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "?";
            string[] parts = fullName.Trim().Split(' ');
            if (parts.Length == 1) return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }
    }
}