using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace HRMSApp
{
    public partial class ManageUsers : System.Web.UI.Page
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
                BindUsers();
            }
        }

        private void BindUsers()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Users_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }

            // Populate each row's employee dropdown after binding
            PopulateEmployeeDropdowns();
        }

        private void PopulateEmployeeDropdowns()
        {
            DataTable employees;
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Employee_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                employees = new DataTable();
                da.Fill(employees);
            }

            foreach (GridViewRow row in gvUsers.Rows)
            {
                DropDownList ddl = row.FindControl("ddlEmployeeLink") as DropDownList;
                if (ddl != null)
                {
                    ddl.DataSource = employees;
                    ddl.DataTextField = "EmpName";
                    ddl.DataValueField = "EmpID";
                    ddl.DataBind();
                    ddl.Items.Insert(0, new ListItem("-- Select employee --", "0"));
                }
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int userId;

            if (e.CommandName == "LinkEmployee")
            {
                userId = Convert.ToInt32(e.CommandArgument);

                GridViewRow row = ((LinkButton)e.CommandSource).NamingContainer as GridViewRow;
                DropDownList ddl = row.FindControl("ddlEmployeeLink") as DropDownList;
                int selectedEmpId = Convert.ToInt32(ddl.SelectedValue);

                if (selectedEmpId == 0)
                {
                    ShowMessage("Please select an employee from the dropdown first.", "warning");
                    return;
                }

                string currentRole = GetUserRole(userId);
                UpdateUserLink(userId, selectedEmpId, currentRole);
                ShowMessage("User linked to employee record successfully.", "success");
            }
            else if (e.CommandName == "Unlink")
            {
                userId = Convert.ToInt32(e.CommandArgument);
                string currentRole = GetUserRole(userId);
                UpdateUserLink(userId, null, currentRole);
                ShowMessage("User unlinked from employee record.", "success");
            }
            else if (e.CommandName == "ToggleRole")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                userId = Convert.ToInt32(parts[0]);
                string currentRole = parts[1];
                string newRole = currentRole == "Admin" ? "Employee" : "Admin";

                int? currentEmpId = GetUserEmpID(userId);
                UpdateUserLink(userId, currentEmpId, newRole);
                ShowMessage("Role updated to " + newRole + ".", "success");
            }

            BindUsers();
        }

        private string GetUserRole(int userId)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("SELECT Role FROM Users WHERE UserID = @UserID", con))
            {
                cmd.Parameters.AddWithValue("@UserID", userId);
                con.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? result.ToString() : "Employee";
            }
        }

        private int? GetUserEmpID(int userId)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("SELECT EmpID FROM Users WHERE UserID = @UserID", con))
            {
                cmd.Parameters.AddWithValue("@UserID", userId);
                con.Open();
                object result = cmd.ExecuteScalar();
                return (result == null || result == DBNull.Value) ? (int?)null : Convert.ToInt32(result);
            }
        }

        private void UpdateUserLink(int userId, int? empId, string role)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_User_UpdateLink", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@EmpID", (object)empId ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Role", role);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void ShowMessage(string text, string type)
        {
            lblMessage.CssClass = "d-block mb-3 text-" + (type == "success" ? "success" : "warning") + " fw-semibold";
            lblMessage.Text = text;
        }
    }
}