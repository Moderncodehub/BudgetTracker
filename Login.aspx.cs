using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Runtime.Remoting.Messaging;

namespace WebApplication5
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }


        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                string query = "SELECT UserID, Name FROM Users WHERE Email = @Email AND Password = @Password";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    Session["UserID"] = reader["UserID"].ToString();
                    Session["UserName"] = reader["Name"].ToString();

                    // ✅ After successful login, redirect to your Dashboard
                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    // If login fails
                    Response.Write("<script>alert('Invalid email or password!');</script>");
                }
            }
        }

    }

}

