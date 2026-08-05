using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace HRMSApp
{
    public partial class signup : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["myDB1"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null && !IsPostBack)
            {
                Response.Redirect("EmployeeList.aspx");
            }
        }

        protected void btnSignup_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                ShowError("All fields are required.");
                return;
            }

            byte[] passwordHash = ComputeSha256(password);

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_User_Signup", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Email", email);

                SqlParameter hashParam = new SqlParameter("@PasswordHash", SqlDbType.VarBinary, 64);
                hashParam.Value = passwordHash;
                cmd.Parameters.Add(hashParam);

                con.Open();
                object result = cmd.ExecuteScalar();
                int resultCode = Convert.ToInt32(result);

                switch (resultCode)
                {
                    case 1:
                        ShowSuccess("Account created successfully! Redirecting to login...");
                        ClientScript.RegisterStartupScript(this.GetType(), "redirect",
                            "setTimeout(function(){ window.location = 'Login.aspx'; }, 1800);", true);
                        break;
                    case -1:
                        ShowError("That username is already taken.");
                        break;
                    case -2:
                        ShowError("That email is already registered.");
                        break;
                    default:
                        ShowError("Something went wrong. Please try again.");
                        break;
                }
            }
        }

        // Same method as Login.aspx.cs - identical encoding, so hashes always match
        private byte[] ComputeSha256(string input)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                return sha256.ComputeHash(Encoding.UTF8.GetBytes(input));
            }
        }

        private void ShowError(string message)
        {
            lblError.Text = message;
            lblError.Style["display"] = "flex";
            lblSuccess.Style["display"] = "none";
        }

        private void ShowSuccess(string message)
        {
            lblSuccess.Text = message;
            lblSuccess.Style["display"] = "flex";
            lblError.Style["display"] = "none";
        }
    }
}