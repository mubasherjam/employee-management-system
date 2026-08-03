<%@ WebHandler Language="C#" Class="ShowImage" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;

public class ShowImage : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string conStr = ConfigurationManager.ConnectionStrings["myDB1"].ConnectionString;

        if (context.Request.QueryString["EmpID"] == null)
        {
            ServeDefaultAvatar(context);
            return;
        }

        int empId = Convert.ToInt32(context.Request.QueryString["EmpID"]);

        using (SqlConnection con = new SqlConnection(conStr))
        using (SqlCommand cmd = new SqlCommand(
            "SELECT ProfilePic FROM Employee WHERE EmpID = @EmpID", con))
        {
            cmd.Parameters.AddWithValue("@EmpID", empId);
            con.Open();
            object result = cmd.ExecuteScalar();

            if (result != null && result != DBNull.Value)
            {
                byte[] imageBytes = (byte[])result;
                context.Response.ContentType = "image/jpeg";
                context.Response.BinaryWrite(imageBytes);
            }
            else
            {
                ServeDefaultAvatar(context);
            }
        }
    }

    // If no photo was uploaded, serve a tiny transparent placeholder instead of breaking the <img> tag
    private void ServeDefaultAvatar(HttpContext context)
    {
        context.Response.ContentType = "image/gif";
        byte[] transparentGif = Convert.FromBase64String(
            "R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBTAA7");
        context.Response.BinaryWrite(transparentGif);
    }

    public bool IsReusable => false;
}