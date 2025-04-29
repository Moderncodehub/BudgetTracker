using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication5
{
    public partial class AdminPanel : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnManageUsers_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageUsers.aspx");
        }

        protected void btnViewReports_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewReports.aspx");
        }

        protected void btnSettings_Click(object sender, EventArgs e)
        {
            Response.Redirect("Settings.aspx");
        }

        protected void btnCancelNewUser_Click(object sender, EventArgs e)
        {
         }

        protected void txtSearchUser_TextChanged(object sender, EventArgs e)
        {
         }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
         }

        protected void btnSaveNewUser_Click(object sender, EventArgs e)
        { 
        }

    }
}