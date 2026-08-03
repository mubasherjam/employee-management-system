using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class Counter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState["count"] = 0;
                CounterOP.Text = "0";
            }
        }
        protected void Add_Click(object sender, EventArgs e)
        {
            int count = (int)ViewState["count"];
            count++;
            ViewState ["count"] = count;
            CounterOP.Text = count.ToString();
        }
    }
}