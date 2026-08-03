using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace HRMSApp
{
    public partial class EmployeeProfile : System.Web.UI.Page
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
                BindDepartments();

                if (Request.QueryString["EmpID"] != null)
                {
                    int empId = Convert.ToInt32(Request.QueryString["EmpID"]);
                    LoadEmployeeData(empId);
                }
            }
        }

        private int CurrentUserID => Convert.ToInt32(Session["UserID"]);

        private void BindDepartments()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Department_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlDepartment.DataSource = dt;
                ddlDepartment.DataBind();
            }
        }

        private void LoadEmployeeData(int empId)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Employee_GetByID", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpID", empId);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    hfEmpID.Value = empId.ToString();
                    txtName.Text = dr["EmpName"].ToString();
                    ddlDepartment.SelectedValue = dr["DeptID"].ToString();
                    rblGender.SelectedValue = dr["Gender"].ToString();
                    txtDOB.Text = Convert.ToDateTime(dr["DOB"]).ToString("yyyy-MM-dd");
                    txtJoiningDate.Text = Convert.ToDateTime(dr["JoiningDate"]).ToString("yyyy-MM-dd");
                    chkIsActive.Checked = Convert.ToBoolean(dr["IsActive"]);
                    txtBasicSalary.Text = dr["BasicSalary"].ToString();
                    txtAllowance.Text = dr["Allowance"].ToString();

                    txtEmail.Text = dr["Email"] == DBNull.Value ? "" : dr["Email"].ToString();
                    txtPhone.Text = dr["Phone"] == DBNull.Value ? "" : dr["Phone"].ToString();
                    txtAddress.Text = dr["Address"] == DBNull.Value ? "" : dr["Address"].ToString();
                    txtCNIC.Text = dr["CNIC"] == DBNull.Value ? "" : dr["CNIC"].ToString();
                    txtDesignation.Text = dr["Designation"] == DBNull.Value ? "" : dr["Designation"].ToString();

                    lblHeroName.Text = txtName.Text;
                    lblHeroDesignation.Text = string.IsNullOrWhiteSpace(txtDesignation.Text) ? "Designation not set" : txtDesignation.Text;
                    lblHeroDept.Text = ddlDepartment.SelectedItem != null ? ddlDepartment.SelectedItem.Text : "No department";
                    lblHeroEmail.Text = string.IsNullOrWhiteSpace(txtEmail.Text) ? "No email on file" : txtEmail.Text;
                    lblHeroPhone.Text = string.IsNullOrWhiteSpace(txtPhone.Text) ? "No phone on file" : txtPhone.Text;
                    lblHeroJoined.Text = txtJoiningDate.Text;


                    if (dr["MaritalStatus"] != DBNull.Value)
                        ddlMaritalStatus.SelectedValue = dr["MaritalStatus"].ToString();

                    if (dr["BloodGroup"] != DBNull.Value)
                        ddlBloodGroup.SelectedValue = dr["BloodGroup"].ToString();

                    txtEmergencyName.Text = dr["EmergencyContactName"] == DBNull.Value ? "" : dr["EmergencyContactName"].ToString();
                    txtEmergencyPhone.Text = dr["EmergencyContactPhone"] == DBNull.Value ? "" : dr["EmergencyContactPhone"].ToString();

                    lblMessage.CssClass = "d-block mb-3 text-primary fw-semibold";
                    lblMessage.Text = "Editing Employee #" + empId + " — change only what's needed, then click Update.";



                    imgAvatarPreview.Visible = true;
                    imgAvatarPreview.ImageUrl = "ShowImage.ashx?EmpID=" + empId;
                    avatarPlaceholder.Visible = false;
                }

            }

        }

        // ---------------- INSERT ----------------
        protected void btnSave_Click(object sender, EventArgs e)
        {
            byte[] fileBytes = null;
            string fileName = null;

            if (fuProfilePic.HasFile)
            {
                fileBytes = fuProfilePic.FileBytes;
                fileName = Path.GetFileName(fuProfilePic.FileName);
            }

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Employee_Insert", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpName", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@DeptID", Convert.ToInt32(ddlDepartment.SelectedValue));
                cmd.Parameters.AddWithValue("@Gender", rblGender.SelectedValue);
                DateTime dob, joiningDate;

                if (!DateTime.TryParse(txtDOB.Text, out dob))
                {
                    lblMessage.Text = "Please select a valid Date of Birth.";
                    return;
                }

                if (!DateTime.TryParse(txtJoiningDate.Text, out joiningDate))
                {
                    lblMessage.Text = "Please select a valid Joining Date.";
                    return;
                }

                cmd.Parameters.AddWithValue("@DOB", dob);
                cmd.Parameters.AddWithValue("@JoiningDate", joiningDate);
                cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                SqlParameter picParam = new SqlParameter("@ProfilePic", SqlDbType.VarBinary, -1);
                picParam.Value = (object)fileBytes ?? DBNull.Value;
                cmd.Parameters.Add(picParam);

                cmd.Parameters.AddWithValue("@ProfilePicName", (object)fileName ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@BasicSalary", Convert.ToDecimal(txtBasicSalary.Text));
                cmd.Parameters.AddWithValue("@Allowance", Convert.ToDecimal(txtAllowance.Text));

                cmd.Parameters.AddWithValue("@Email", string.IsNullOrWhiteSpace(txtEmail.Text) ? (object)DBNull.Value : txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Phone", string.IsNullOrWhiteSpace(txtPhone.Text) ? (object)DBNull.Value : txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@Address", string.IsNullOrWhiteSpace(txtAddress.Text) ? (object)DBNull.Value : txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@CNIC", string.IsNullOrWhiteSpace(txtCNIC.Text) ? (object)DBNull.Value : txtCNIC.Text.Trim());
                cmd.Parameters.AddWithValue("@Designation", string.IsNullOrWhiteSpace(txtDesignation.Text) ? (object)DBNull.Value : txtDesignation.Text.Trim());
                cmd.Parameters.AddWithValue("@MaritalStatus", (object)ddlMaritalStatus.SelectedValue ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@BloodGroup", (object)ddlBloodGroup.SelectedValue ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@EmergencyContactName", string.IsNullOrWhiteSpace(txtEmergencyName.Text) ? (object)DBNull.Value : txtEmergencyName.Text.Trim());
                cmd.Parameters.AddWithValue("@EmergencyContactPhone", string.IsNullOrWhiteSpace(txtEmergencyPhone.Text) ? (object)DBNull.Value : txtEmergencyPhone.Text.Trim());

                cmd.Parameters.AddWithValue("@UserID", CurrentUserID);

                SqlParameter outId = new SqlParameter("@NewEmpID", SqlDbType.Int);
                outId.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(outId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("EmployeeList.aspx");
        }

        // ---------------- UPDATE ----------------
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int empId = Convert.ToInt32(hfEmpID.Value);
            if (empId == 0)
            {
                lblMessage.CssClass = "d-block mb-3 text-danger";
                lblMessage.Text = "No employee loaded. Go to the list and click the pencil icon first.";
                return;
            }

            byte[] fileBytes = null;
            string fileName = null;
            if (fuProfilePic.HasFile)
            {
                fileBytes = fuProfilePic.FileBytes;
                fileName = Path.GetFileName(fuProfilePic.FileName);
            }

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Employee_Update", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpID", empId);
                cmd.Parameters.AddWithValue("@EmpName", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@DeptID", Convert.ToInt32(ddlDepartment.SelectedValue));
                cmd.Parameters.AddWithValue("@Gender", rblGender.SelectedValue);
                cmd.Parameters.AddWithValue("@DOB", Convert.ToDateTime(txtDOB.Text));
                cmd.Parameters.AddWithValue("@JoiningDate", Convert.ToDateTime(txtJoiningDate.Text));
                cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);

                SqlParameter picParamUpdate = new SqlParameter("@ProfilePic", SqlDbType.VarBinary, -1);
                picParamUpdate.Value = (object)fileBytes ?? DBNull.Value;
                cmd.Parameters.Add(picParamUpdate);

                cmd.Parameters.AddWithValue("@ProfilePicName", (object)fileName ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@BasicSalary", Convert.ToDecimal(txtBasicSalary.Text));
                cmd.Parameters.AddWithValue("@Allowance", Convert.ToDecimal(txtAllowance.Text));

                cmd.Parameters.AddWithValue("@Email", string.IsNullOrWhiteSpace(txtEmail.Text) ? (object)DBNull.Value : txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Phone", string.IsNullOrWhiteSpace(txtPhone.Text) ? (object)DBNull.Value : txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@Address", string.IsNullOrWhiteSpace(txtAddress.Text) ? (object)DBNull.Value : txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@CNIC", string.IsNullOrWhiteSpace(txtCNIC.Text) ? (object)DBNull.Value : txtCNIC.Text.Trim());
                cmd.Parameters.AddWithValue("@Designation", string.IsNullOrWhiteSpace(txtDesignation.Text) ? (object)DBNull.Value : txtDesignation.Text.Trim());
                cmd.Parameters.AddWithValue("@MaritalStatus", (object)ddlMaritalStatus.SelectedValue ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@BloodGroup", (object)ddlBloodGroup.SelectedValue ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@EmergencyContactName", string.IsNullOrWhiteSpace(txtEmergencyName.Text) ? (object)DBNull.Value : txtEmergencyName.Text.Trim());
                cmd.Parameters.AddWithValue("@EmergencyContactPhone", string.IsNullOrWhiteSpace(txtEmergencyPhone.Text) ? (object)DBNull.Value : txtEmergencyPhone.Text.Trim());

                cmd.Parameters.AddWithValue("@UserID", CurrentUserID);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("EmployeeList.aspx");
        }

        // ---------------- DELETE ----------------
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            int empId = Convert.ToInt32(hfEmpID.Value);
            if (empId == 0)
            {
                lblMessage.CssClass = "d-block mb-3 text-danger";
                lblMessage.Text = "No employee loaded. Go to the list and click the pencil icon first.";
                return;
            }

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Employee_Delete", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpID", empId);
                cmd.Parameters.AddWithValue("@UserID", CurrentUserID);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("EmployeeList.aspx");
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hfEmpID.Value = "0";
            txtName.Text = "";
            txtDOB.Text = "";
            txtJoiningDate.Text = "";
            txtBasicSalary.Text = "";
            txtAllowance.Text = "";
            chkIsActive.Checked = true;
            rblGender.SelectedIndex = 0;

            txtEmail.Text = "";
            txtPhone.Text = "";
            txtAddress.Text = "";
            txtCNIC.Text = "";
            txtDesignation.Text = "";
            ddlMaritalStatus.SelectedIndex = 0;
            ddlBloodGroup.SelectedIndex = 0;
            txtEmergencyName.Text = "";
            txtEmergencyPhone.Text = "";

            lblMessage.Text = "";
        }
    }
}