using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

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
            if (!Page.IsValid) return; // client-side validators already checked required fields/match

            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            // Server-side re-check, never trust client-side alone
            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                ShowError("All fields are required.");
                return;
            }

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_User_Signup", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);

                con.Open();
                object result = cmd.ExecuteScalar(); // stored proc returns single Result column

                int resultCode = Convert.ToInt32(result);

                switch (resultCode)
                {
                    case 1:
                        ShowSuccess("Account created successfully! Redirecting to login...");
                        // simple client-side redirect after a short delay
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