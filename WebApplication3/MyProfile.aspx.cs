using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace HRMSApp
{
    public partial class MyProfile : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["myDB1"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (Session["EmpID"] == null)
            {
                lblMessage.CssClass = "d-block mb-3 text-warning";
                lblMessage.Text = "Your account isn't linked to an employee record yet. Contact your administrator.";
                btnSaveProfile.Enabled = false;
                return;
            }

            if (!IsPostBack)
            {
                LoadMyData();
            }
        }

        private int MyEmpID => Convert.ToInt32(Session["EmpID"]);

        private void LoadMyData()
        {
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Employee_GetByID", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpID", MyEmpID);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    txtName.Text = dr["EmpName"].ToString();
                    txtEmail.Text = dr["Email"] == DBNull.Value ? "" : dr["Email"].ToString();
                    txtPhone.Text = dr["Phone"] == DBNull.Value ? "" : dr["Phone"].ToString();
                    txtAddress.Text = dr["Address"] == DBNull.Value ? "" : dr["Address"].ToString();
                    txtEmergencyName.Text = dr["EmergencyContactName"] == DBNull.Value ? "" : dr["EmergencyContactName"].ToString();
                    txtEmergencyPhone.Text = dr["EmergencyContactPhone"] == DBNull.Value ? "" : dr["EmergencyContactPhone"].ToString();
                }
            }

            // Separate lookup just for showing the department name read-only
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_Employee_GetAll", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                DataRow[] rows = dt.Select("EmpID = " + MyEmpID);
                if (rows.Length > 0)
                {
                    txtDeptReadOnly.Text = rows[0]["DeptName"].ToString();
                }
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            // Uses the SAME sp_Employee_Update procedure, but only touches self-service fields.
            // We fetch the existing record first so we don't overwrite Department/Salary/etc with blanks.
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand getCmd = new SqlCommand("sp_Employee_GetByID", con))
            {
                getCmd.CommandType = CommandType.StoredProcedure;
                getCmd.Parameters.AddWithValue("@EmpID", MyEmpID);
                con.Open();
                SqlDataReader dr = getCmd.ExecuteReader();

                if (!dr.Read())
                {
                    lblMessage.CssClass = "d-block mb-3 text-danger";
                    lblMessage.Text = "Could not find your employee record.";
                    return;
                }

                // Capture existing values that this page never edits
                int deptId = Convert.ToInt32(dr["DeptID"]);
                string gender = dr["Gender"].ToString();
                DateTime dob = Convert.ToDateTime(dr["DOB"]);
                DateTime joiningDate = Convert.ToDateTime(dr["JoiningDate"]);
                bool isActive = Convert.ToBoolean(dr["IsActive"]);
                decimal basicSalary = dr["BasicSalary"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["BasicSalary"]);
                decimal allowance = dr["Allowance"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["Allowance"]);
                string cnic = dr["CNIC"] == DBNull.Value ? null : dr["CNIC"].ToString();
                string designation = dr["Designation"] == DBNull.Value ? null : dr["Designation"].ToString();
                string maritalStatus = dr["MaritalStatus"] == DBNull.Value ? null : dr["MaritalStatus"].ToString();
                string bloodGroup = dr["BloodGroup"] == DBNull.Value ? null : dr["BloodGroup"].ToString();
                dr.Close();

                using (SqlCommand updCmd = new SqlCommand("sp_Employee_Update", con))
                {
                    updCmd.CommandType = CommandType.StoredProcedure;
                    updCmd.Parameters.AddWithValue("@EmpID", MyEmpID);
                    updCmd.Parameters.AddWithValue("@EmpName", txtName.Text.Trim());
                    updCmd.Parameters.AddWithValue("@DeptID", deptId);
                    updCmd.Parameters.AddWithValue("@Gender", gender);
                    updCmd.Parameters.AddWithValue("@DOB", dob);
                    updCmd.Parameters.AddWithValue("@JoiningDate", joiningDate);
                    updCmd.Parameters.AddWithValue("@IsActive", isActive);
                    updCmd.Parameters.AddWithValue("@ProfilePic", DBNull.Value);
                    updCmd.Parameters.AddWithValue("@ProfilePicName", DBNull.Value);
                    updCmd.Parameters.AddWithValue("@BasicSalary", basicSalary);
                    updCmd.Parameters.AddWithValue("@Allowance", allowance);
                    updCmd.Parameters.AddWithValue("@Email", string.IsNullOrWhiteSpace(txtEmail.Text) ? (object)DBNull.Value : txtEmail.Text.Trim());
                    updCmd.Parameters.AddWithValue("@Phone", string.IsNullOrWhiteSpace(txtPhone.Text) ? (object)DBNull.Value : txtPhone.Text.Trim());
                    updCmd.Parameters.AddWithValue("@Address", string.IsNullOrWhiteSpace(txtAddress.Text) ? (object)DBNull.Value : txtAddress.Text.Trim());
                    updCmd.Parameters.AddWithValue("@CNIC", (object)cnic ?? DBNull.Value);
                    updCmd.Parameters.AddWithValue("@Designation", (object)designation ?? DBNull.Value);
                    updCmd.Parameters.AddWithValue("@MaritalStatus", (object)maritalStatus ?? DBNull.Value);
                    updCmd.Parameters.AddWithValue("@BloodGroup", (object)bloodGroup ?? DBNull.Value);
                    updCmd.Parameters.AddWithValue("@EmergencyContactName", string.IsNullOrWhiteSpace(txtEmergencyName.Text) ? (object)DBNull.Value : txtEmergencyName.Text.Trim());
                    updCmd.Parameters.AddWithValue("@EmergencyContactPhone", string.IsNullOrWhiteSpace(txtEmergencyPhone.Text) ? (object)DBNull.Value : txtEmergencyPhone.Text.Trim());
                    updCmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(Session["UserID"]));

                    updCmd.ExecuteNonQuery();
                }
            }

            lblMessage.CssClass = "d-block mb-3 text-success";
            lblMessage.Text = "Your profile was updated successfully.";
        }
    }
}