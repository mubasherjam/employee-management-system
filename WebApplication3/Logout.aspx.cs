using System;
using System.Web;

namespace HRMSApp
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            HttpCookie expired = new HttpCookie("HRMSRememberMe");
            expired.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(expired);

            Response.Redirect("Login.aspx");
        }
    }
}