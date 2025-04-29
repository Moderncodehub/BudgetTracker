using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication5
{
    public partial class Reports : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadReportData();
            }
        }

        private void LoadReportData()
        {
            decimal totalSpending = 0;
            decimal totalIncome = 0;
            int totalTransactions = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("usp_GetUserReportSummary", conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        totalSpending = reader["TotalSpending"] != DBNull.Value ? Convert.ToDecimal(reader["TotalSpending"]) : 0;
                    }

                    if (reader.NextResult() && reader.Read())
                    {
                        totalIncome = reader["TotalIncome"] != DBNull.Value ? Convert.ToDecimal(reader["TotalIncome"]) : 0;
                    }

                    if (reader.NextResult() && reader.Read())
                    {
                        totalTransactions = reader["TotalTransactions"] != DBNull.Value ? Convert.ToInt32(reader["TotalTransactions"]) : 0;
                    }
                }
            }

            // Bind results to Labels
            lblTotalSpending.Text = "$" + totalSpending.ToString("N2");
            lblTotalIncome.Text = "$" + totalIncome.ToString("N2");
            lblTotalTransactions.Text = totalTransactions.ToString();

            lblTotalSpending.Text = "$" + totalSpending.ToString("N2");
            lblTotalIncome.Text = "$" + totalIncome.ToString("N2");
            lblTotalTransactions.Text = totalTransactions.ToString();

            // 🆕 Calculate Net Balance
            decimal netBalance = totalIncome - totalSpending;

            // 🆕 Set Net Balance Text
            lblNetBalance.Text = (netBalance >= 0 ? "+" : "-") + "$" + Math.Abs(netBalance).ToString("N2");

            // 🆕 Set Color
            if (netBalance >= 0)
            {
                lblNetBalance.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                lblNetBalance.ForeColor = System.Drawing.Color.Red;
            }

        }
    }
}
