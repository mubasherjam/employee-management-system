using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;

namespace HRMSApp
{
    public partial class Login : System.Web.UI.Page
    {
        string conStr = ConfigurationManager.ConnectionStrings["myDB1"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] != null)
                {
                    Response.Redirect("EmployeeList.aspx");
                    return;
                }

                // Check for a valid "Remember Me" cookie before showing the login form
                TryAutoLoginFromCookie();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string usernameOrEmail = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrWhiteSpace(usernameOrEmail) || string.IsNullOrWhiteSpace(password))
            {
                ShowError("Please enter both username/email and password.");
                return;
            }

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_User_Login", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UsernameOrEmail", usernameOrEmail);
                cmd.Parameters.AddWithValue("@Password", password);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    int userId = Convert.ToInt32(dr["UserID"]);
                    string username = dr["Username"].ToString();
                    string role = dr["Role"].ToString();
                    int? empId = dr["EmpID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["EmpID"]);
                    dr.Close();

                    Session["UserID"] = userId;
                    Session["Username"] = username;
                    Session["Role"] = role;
                    Session["EmpID"] = empId;

                    if (chkRememberMe.Checked)
                    {
                        SetRememberMeCookie(userId);
                    }
                    // Route based on role
                    if (role == "Admin")
                        Response.Redirect("EmployeeList.aspx");
                    else
                        Response.Redirect("MyProfile.aspx");
                   // Response.Redirect("EmployeeList.aspx");
                }
                else
                {
                    ShowError("Invalid username/email or password.");
                }
            }
        }

        // ---------------- Remember Me: create token, hash it, store hash+expiry in DB, plain token in cookie ----------------
        private void SetRememberMeCookie(int userId)
        {
            string rawToken = Guid.NewGuid().ToString("N") + Guid.NewGuid().ToString("N"); // 64-char random token
            byte[] tokenHash = ComputeSha256(rawToken);
            DateTime expiry = DateTime.Now.AddDays(2);

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand(
                "UPDATE Users SET RememberTokenHash = @Hash, RememberTokenExpiry = @Expiry WHERE UserID = @UserID", con))
            {
                cmd.Parameters.AddWithValue("@Hash", tokenHash);
                cmd.Parameters.AddWithValue("@Expiry", expiry);
                cmd.Parameters.AddWithValue("@UserID", userId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            // Cookie holds UserID + the PLAIN token (never the password, never a reusable secret on its own without DB match)
            HttpCookie cookie = new HttpCookie("HRMSRememberMe");
            cookie.Values["uid"] = userId.ToString();
            cookie.Values["token"] = rawToken;
            cookie.Expires = expiry;
            cookie.HttpOnly = true; // JavaScript can't read this cookie - blocks XSS theft
            Response.Cookies.Add(cookie);
        }

        // ---------------- Auto-login check when returning within 2 days ----------------
        private void TryAutoLoginFromCookie()
        {
            HttpCookie cookie = Request.Cookies["HRMSRememberMe"];
            if (cookie == null || cookie.Values["uid"] == null || cookie.Values["token"] == null)
                return;

            int userId;
            if (!int.TryParse(cookie.Values["uid"], out userId))
                return;

            string rawToken = cookie.Values["token"];
            byte[] tokenHash = ComputeSha256(rawToken);

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand(
                @"SELECT Username, Role, EmpID FROM Users 
                  WHERE UserID = @UserID 
                    AND RememberTokenHash = @Hash 
                    AND RememberTokenExpiry > GETDATE()
                    AND IsActive = 1", con))
            {
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@Hash", tokenHash);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    Session["UserID"] = userId;
                    Session["Username"] = dr["Username"].ToString();
                    Session["Role"] = dr["Role"].ToString();
                    Session["EmpID"] = dr["EmpID"] == DBNull.Value ? (int?)null : Convert.ToInt32(dr["EmpID"]);
                    dr.Close();

                    Response.Redirect(Session["Role"].ToString() == "Admin" ? "EmployeeList.aspx" : "MyProfile.aspx");
                }
                else
                {
                    // Token invalid or expired - clear the stale cookie
                    HttpCookie expired = new HttpCookie("HRMSRememberMe");
                    expired.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(expired);
                }
            }
        }

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
            lblError.Style["display"] = "block";
        }
    }
}