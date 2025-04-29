using System;
using System.Configuration;
using System.Data.SqlClient;

namespace WebApplication5
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (txtPassword.Text != txtConfirmPassword.Text)
            {
                // Passwords don't match
                Response.Write("<script>alert('Passwords do not match!');</script>");
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // Check if email already exists
                string checkUser = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                SqlCommand cmdCheck = new SqlCommand(checkUser, con);
                cmdCheck.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                int userExists = (int)cmdCheck.ExecuteScalar();
                if (userExists > 0)
                {
                    Response.Write("<script>alert('Email already exists!');</script>");
                    return;
                }

                // Insert with Name
                string query = "INSERT INTO Users (Name, Email, Password, CreatedAt) VALUES (@Name, @Email, @Password, GETDATE())";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim()); // Save Name
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());

                cmd.ExecuteNonQuery();
                Response.Redirect("Login.aspx");
            }
        }

    }
}
