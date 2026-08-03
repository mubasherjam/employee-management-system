using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace HRMSApp
{
    public partial class Navbar : System.Web.UI.UserControl
    {
        string conStr = ConfigurationManager.ConnectionStrings["myDB1"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            bool isLoggedIn = Session["UserID"] != null;
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";

            if (isLoggedIn)
            {
                string username = Session["Username"] != null ? Session["Username"].ToString() : "User";
                litUserBadgeDesktop.Text = "<span class='user-badge'><i class=\"bi bi-person-circle\"></i> " + username + " (" + role + ")</span>";

                lnkAuthDesktop.InnerText = "Logout";
                lnkAuthDesktop.HRef = "Logout.aspx";
                lnkAuthMobile.InnerText = "Logout";
                lnkAuthMobile.HRef = "Logout.aspx";

                bool isAdmin = role == "Admin";

                // Admin-only links
                lnkEmployeesDesktop.Visible = isAdmin;
                lnkEmployeesMobile.Visible = isAdmin;
                lnkNewEntryDesktop.Visible = isAdmin;
                lnkNewEntryMobile.Visible = isAdmin;
                btnEditDeptDesktop.Visible = isAdmin;
                btnEditDeptMobile.Visible = isAdmin;

                // Everyone logged in sees My Profile
                lnkMyProfileDesktop.Visible = true;
                lnkMyProfileMobile.Visible = true;
            }
            else
            {
                lnkEmployeesDesktop.Visible = false;
                lnkNewEntryDesktop.Visible = false;
                lnkEmployeesMobile.Visible = false;
                lnkNewEntryMobile.Visible = false;
                btnEditDeptDesktop.Visible = false;
                btnEditDeptMobile.Visible = false;
                lnkMyProfileDesktop.Visible = false;
                lnkMyProfileMobile.Visible = false;

                lnkAuthDesktop.InnerText = "Login";
                lnkAuthDesktop.HRef = "Login.aspx";
                lnkAuthMobile.InnerText = "Login";
                lnkAuthMobile.HRef = "Login.aspx";
            }

            if (!IsPostBack)
            {
                BindDepartmentsList();
            }
        }

        private int CurrentUserID => Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 1;

        // =====================================================
        // DEPARTMENT MANAGEMENT (modal popup, now shared across all pages)
        // =====================================================

        private void BindDepartmentsList()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Department_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptDepartments.DataSource = dt;
                rptDepartments.DataBind();
            }
        }

        protected void btnDeptSave_Click(object sender, EventArgs e)
        {
            string deptName = txtDeptName.Text.Trim();

            if (string.IsNullOrWhiteSpace(deptName))
            {
                lblDeptMessage.CssClass = "d-block mb-2 dept-msg text-danger";
                lblDeptMessage.Text = "Department name cannot be empty.";
                ReopenDeptModal();
                return;
            }

            int deptId = Convert.ToInt32(hfDeptID.Value);

            if (deptId == 0)
            {
                using (SqlConnection con = new SqlConnection(conStr))
                using (SqlCommand cmd = new SqlCommand("sp_Department_Insert", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DeptName", deptName);
                    cmd.Parameters.AddWithValue("@UserID", CurrentUserID);

                    SqlParameter outId = new SqlParameter("@NewDeptID", SqlDbType.Int);
                    outId.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(outId);

                    con.Open();
                    cmd.ExecuteNonQuery();

                    int newId = (int)outId.Value;
                    if (newId == -1)
                    {
                        lblDeptMessage.CssClass = "d-block mb-2 dept-msg text-warning";
                        lblDeptMessage.Text = "A department with this name already exists.";
                        ReopenDeptModal();
                        return;
                    }
                }

                lblDeptMessage.CssClass = "d-block mb-2 dept-msg text-success";
                lblDeptMessage.Text = "Department added successfully.";
            }
            else
            {
                using (SqlConnection con = new SqlConnection(conStr))
                using (SqlCommand cmd = new SqlCommand("sp_Department_Update", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DeptID", deptId);
                    cmd.Parameters.AddWithValue("@DeptName", deptName);
                    cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                lblDeptMessage.CssClass = "d-block mb-2 dept-msg text-success";
                lblDeptMessage.Text = "Department updated successfully.";
            }

            ResetDeptForm();
            BindDepartmentsList();
            ReopenDeptModal();
        }

        protected void btnDeptProxy_Click(object sender, EventArgs e)
        {
            string action = hfDeptAction.Value;
            int deptId = Convert.ToInt32(hfDeptID.Value);

            if (action == "edit")
            {
                using (SqlConnection con = new SqlConnection(conStr))
                using (SqlCommand cmd = new SqlCommand("sp_Department_GetAll", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    DataRow[] rows = dt.Select("DeptID = " + deptId);
                    if (rows.Length > 0)
                    {
                        txtDeptName.Text = rows[0]["DeptName"].ToString();
                        btnDeptSave.Text = "Update";
                        btnDeptCancelEdit.Visible = true;
                        lblDeptMessage.Text = "";
                    }
                }
            }
            else if (action == "delete")
            {
                using (SqlConnection con = new SqlConnection(conStr))
                using (SqlCommand cmd = new SqlCommand("sp_Department_Delete", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DeptID", deptId);
                    cmd.Parameters.AddWithValue("@UserID", CurrentUserID);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                lblDeptMessage.CssClass = "d-block mb-2 dept-msg text-success";
                lblDeptMessage.Text = "Department removed.";
                BindDepartmentsList();
            }

            ReopenDeptModal();
        }

        protected void btnDeptCancelEdit_Click(object sender, EventArgs e)
        {
            ResetDeptForm();
            ReopenDeptModal();
        }

        private void ResetDeptForm()
        {
            hfDeptID.Value = "0";
            txtDeptName.Text = "";
            btnDeptSave.Text = "Add";
            btnDeptCancelEdit.Visible = false;
        }

        private void ReopenDeptModal()
        {
            ScriptManager.RegisterStartupScript(
                this.Page,
                this.Page.GetType(),
                "reopenDeptModal_" + Guid.NewGuid().ToString("N"),
                "openDeptModalAfterUpdate();",
                true);
        }
    }
}