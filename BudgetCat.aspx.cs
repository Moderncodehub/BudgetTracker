using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;
using System.Web.Script.Serialization;

namespace WebApplication5
{
    [System.Web.Script.Services.ScriptService]
    public partial class BudgetCat : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadBudgetData("April");
            }
            GetLatestMonth();
        }

        public static string GetCategoryIcon(string category)
        {
            switch (category.ToLower())
            {
                case "shopping":
                    return "fas fa-shopping-bag"; // Shopping bag icon
                case "groceries":
                    return "fas fa-apple-alt"; // Apple (groceries) icon
                case "transportation":
                    return "fas fa-car"; // Car icon
                case "utilities":
                    return "fas fa-bolt"; // Bolt (electricity) icon
                case "restaurants":
                    return "fas fa-utensils"; // Utensils (food) icon
                case "entertainment":
                    return "fas fa-film"; // Film (movies) icon
                case "salary":
                    return "fas fa-money-bill"; // Money bill
                default:
                    return "fas fa-tags"; // Default icon
            }
        }

        private void LoadBudgetData(string month)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        Category, 
                        SUM(CASE WHEN Type = 'Expense' THEN Amount ELSE 0 END) AS Actual,
                        SUM(CASE WHEN Type = 'Income' THEN Amount ELSE 0 END) AS Budgeted
                    FROM Expenses
                    WHERE DATENAME(MONTH, CreatedAt) = @Month AND UserID = @UserID
                    GROUP BY Category";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Month", month);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Now we add extra columns manually
                dt.Columns.Add("Remaining", typeof(decimal));
                dt.Columns.Add("Progress", typeof(int));

                foreach (DataRow row in dt.Rows)
                {
                    decimal budgeted = Convert.ToDecimal(row["Budgeted"]);
                    decimal actual = Convert.ToDecimal(row["Actual"]);
                    decimal remaining = budgeted - actual;
                    int progress = budgeted > 0 ? (int)((actual / budgeted) * 100) : 0;

                    row["Remaining"] = remaining;
                    row["Progress"] = progress;
                }

                rptBudgetTable.DataSource = dt;
                rptBudgetTable.DataBind();
            }
        }

        [WebMethod]
        public static string GetMonthData(string month)
        {
            string connStr = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;
            var result = new { budgetHtml = "", totalBudgeted = 0M, totalActual = 0M, remaining = 0M, spentPercent = 0M };

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = @"
                    SELECT 
                        Category, 
                        SUM(CASE WHEN Type = 'Expense' THEN Amount ELSE 0 END) AS Actual,
                        SUM(CASE WHEN Type = 'Income' THEN Amount ELSE 0 END) AS Budgeted
                    FROM Expenses
                    WHERE DATENAME(MONTH, CreatedAt) = @Month AND UserID = @UserID
                    GROUP BY Category";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Month", month);
                cmd.Parameters.AddWithValue("@UserID", System.Web.HttpContext.Current.Session["UserID"]);

                SqlDataReader reader = cmd.ExecuteReader();
                decimal totalBudgeted = 0, totalActual = 0;
                string budgetHtml = "";

                while (reader.Read())
                {
                    decimal budgeted = Convert.ToDecimal(reader["Budgeted"]);
                    decimal actual = Convert.ToDecimal(reader["Actual"]);
                    decimal remaining = budgeted - actual;
                    int progress = budgeted > 0 ? (int)((actual / budgeted) * 100) : 0;

                    budgetHtml += $"<tr>" +
                                    $"<td><div>{reader["Category"]}</div><div class='progress mt-1' style='height:6px;'><div class='progress-bar bg-success' style='width:{progress}%'></div></div></td>" +
                                    $"<td>${budgeted:N2}</td>" +
                                    $"<td>${actual:N2}</td>" +
                                    $"<td><span class='{(remaining >= 0 ? "remaining-positive" : "remaining-negative")}'>${remaining:N2}</span></td>" +
                                  $"</tr>";

                    totalBudgeted += budgeted;
                    totalActual += actual;
                }
                reader.Close();

                decimal totalRemaining = totalBudgeted - totalActual;
                decimal spentPercent = totalBudgeted > 0 ? (totalActual / totalBudgeted) * 100 : 0;

                result = new
                {
                    budgetHtml = budgetHtml,
                    totalBudgeted = totalBudgeted,
                    totalActual = totalActual,
                    remaining = totalRemaining,
                    spentPercent = spentPercent
                };
            }

            return new JavaScriptSerializer().Serialize(result);
        }

        private string GetLatestMonth()
        {
            string latestMonth = "";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT TOP 1 DATENAME(MONTH, CreatedAt) AS MonthName
            FROM Expenses
            WHERE UserID = @UserID
            ORDER BY CreatedAt DESC"; // Get the most recent month

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    latestMonth = result.ToString();
                }
            }

            return latestMonth;
        }

    }
}
