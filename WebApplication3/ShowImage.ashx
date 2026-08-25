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
            ServeDefaultAvatar(context, null);
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
                ServeDefaultAvatar(context, empId);
            }
        }
    }

    // Redirects to a DiceBear-generated cartoon avatar, biased by the employee's gender
    private void ServeDefaultAvatar(HttpContext context, int? empId)
    {
        string gender = "male"; // fallback if unknown

        if (empId.HasValue)
        {
            string conStr = ConfigurationManager.ConnectionStrings["myDB1"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conStr))
            using (SqlCommand cmd = new SqlCommand("SELECT Gender FROM Employee WHERE EmpID = @EmpID", con))
            {
                cmd.Parameters.AddWithValue("@EmpID", empId.Value);
                con.Open();
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                {
                    gender = result.ToString().Trim().ToLower();
                }
            }
        }

        string seed = empId.HasValue ? "emp" + empId.Value : "guest";

        string genderParams = gender == "female"
            ? "top=longHairStraight,longHairCurly,longHairBun,longHairFro&facialHairProbability=0"
            : "top=shortHairShortFlat,shortHairShortCurly,shortHairShortWaved&facialHairProbability=35";

        string avatarUrl = "https://api.dicebear.com/9.x/avataaars/svg?seed=" +
            Uri.EscapeDataString(seed) + "&" + genderParams + "&backgroundColor=b6e3f4,c0aede,d1d4f9";

        context.Response.Redirect(avatarUrl, false);
        context.ApplicationInstance.CompleteRequest();
    }

    public bool IsReusable => false;
}