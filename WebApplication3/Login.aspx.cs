using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;

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

            byte[] passwordHash = ComputeSha256(password);

            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("sp_User_Login", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UsernameOrEmail", usernameOrEmail);

                SqlParameter hashParam = new SqlParameter("@PasswordHash", SqlDbType.VarBinary, 64);
                hashParam.Value = passwordHash;
                cmd.Parameters.Add(hashParam);

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

                    Response.Redirect(role == "Admin" ? "EmployeeList.aspx" : "MyProfile.aspx");
                }
                else
                {
                    ShowError("Invalid username/email or password.");
                }
            }
        }

        // ---------------- Remember Me (unchanged logic, still uses its own SHA256 token hash) ----------------
        private void SetRememberMeCookie(int userId)
        {
            string rawToken = Guid.NewGuid().ToString("N") + Guid.NewGuid().ToString("N");
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

            HttpCookie cookie = new HttpCookie("HRMSRememberMe");
            cookie.Values["uid"] = userId.ToString();
            cookie.Values["token"] = rawToken;
            cookie.Expires = expiry;
            cookie.HttpOnly = true;
            Response.Cookies.Add(cookie);
        }

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
                    HttpCookie expired = new HttpCookie("HRMSRememberMe");
                    expired.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(expired);
                }
            }
        }

        // ---------------- The core encryption method, now living in C# ----------------
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