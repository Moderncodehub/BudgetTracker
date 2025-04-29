using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication5
{
    public partial class AdminDashboardBud : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                lblWelcome.Text = "Welcome, " + Session["UserName"].ToString() + "!";
            }

            if (!IsPostBack)
            {
                LoadTransactions();
                LoadSummary();
                LoadUpcomingPayments();
                GenerateChartScript();          // 🆕
                GenerateMonthlyChart();         // 🆕
                GeneratePaymentMethodChart();   // 
                LoadBudgetOverview();

            }
        }

        private void GenerateChartScript()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetCategoryChartData", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                string labels = "";
                string data = "";

                while (dr.Read())
                {
                    labels += $"'{dr["Category"].ToString().Replace("'", "\\'")}',";  // Escape single quotes
                    data += $"{dr["Total"]},";
                }

                if (labels.EndsWith(",")) labels = labels.Substring(0, labels.Length - 1);
                if (data.EndsWith(",")) data = data.Substring(0, data.Length - 1);

                string script = $@"
            window.addEventListener('load', function() {{
                const ctx = document.getElementById('categoryChart').getContext('2d');
                new Chart(ctx, {{
                    type: 'doughnut',
                    data: {{
                        labels: [{labels}],
                        datasets: [{{
                            data: [{data}],
                            backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#ff6384', '#8e44ad']
                        }}]
                    }},
                    options: {{
                        responsive: true,
                        plugins: {{
                            legend: {{
                                position: 'bottom'
                            }}
                        }}
                    }}
                }});
            }});";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "CategoryChartScript", script, true);
            }
        }

        private void GeneratePaymentMethodChart()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetPaymentMethodChartData", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                string labels = "";
                string data = "";

                while (dr.Read())
                {
                    labels += $"'{dr["PaymentMethod"].ToString().Replace("'", "\\'")}',";
                    data += $"{dr["Total"]},";
                }

                if (labels.EndsWith(",")) labels = labels.Substring(0, labels.Length - 1);
                if (data.EndsWith(",")) data = data.Substring(0, data.Length - 1);

                string script = $@"
            window.addEventListener('load', function() {{
                const ctx = document.getElementById('paymentChart').getContext('2d');
                new Chart(ctx, {{
                    type: 'bar',
                    data: {{
                        labels: [{labels}],
                        datasets: [{{
                            label: 'Spending by Payment Method',
                            data: [{data}],
                            backgroundColor: ['#1abc9c', '#3498db', '#e67e22', '#9b59b6']
                        }}]
                    }},
                    options: {{
                        responsive: true,
                        plugins: {{
                            legend: {{
                                position: 'bottom'
                            }}
                        }}
                    }}
                }});
            }});";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "PaymentChartScript", script, true);
            }
        }

        private void GenerateMonthlyChart()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetMonthlyChartData", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                string labels = "";
                string data = "";

                while (dr.Read())
                {
                    labels += $"'{dr["MonthName"].ToString().Replace("'", "\\'")}',";
                    data += $"{dr["Total"]},";
                }

                if (labels.EndsWith(",")) labels = labels.Substring(0, labels.Length - 1);
                if (data.EndsWith(",")) data = data.Substring(0, data.Length - 1);

                string script = $@"
            window.addEventListener('load', function() {{
                const ctx = document.getElementById('monthlyChart').getContext('2d');
                new Chart(ctx, {{
                    type: 'line',
                    data: {{
                        labels: [{labels}],
                        datasets: [{{
                            label: 'Monthly Totals',
                            data: [{data}],
                            fill: false,
                            borderColor: '#4e73df',
                            tension: 0.1
                        }}]
                    }},
                    options: {{
                        responsive: true,
                        plugins: {{
                            legend: {{
                                position: 'bottom'
                            }}
                        }}
                    }}
                }});
            }});";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "MonthlyChartScript", script, true);
            }
        }

        private void LoadBudgetOverview()
        {
            string connStr = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // First get total expenses
                decimal totalExpenses = 0;
                SqlCommand totalCmd = new SqlCommand(@"SELECT ISNULL(SUM(Amount), 0) 
            FROM Expenses WHERE Type='Expense' AND UserID=@UserID", conn);
                totalCmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                totalExpenses = Convert.ToDecimal(totalCmd.ExecuteScalar());

                // Now load category wise
                SqlCommand cmd = new SqlCommand("usp_GetBudgetOverview", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                dt.Columns.Add("Progress", typeof(int));
                dt.Columns.Add("ProgressBarClass", typeof(string)); // Add new column for CSS class

                foreach (DataRow row in dt.Rows)
                {
                    decimal categoryTotal = Convert.ToDecimal(row["Total"]);
                    int percentage = totalExpenses > 0 ? (int)((categoryTotal / totalExpenses) * 100) : 0;
                    row["Progress"] = percentage;

                    // Set the color class dynamically based on percentage
                    if (percentage > 70)
                        row["ProgressBarClass"] = "bg-success"; // Green
                    else if (percentage >= 40)
                        row["ProgressBarClass"] = "bg-warning"; // Orange
                    else
                        row["ProgressBarClass"] = "bg-danger"; // Red
                }


                rptBudgetOverview.DataSource = dt;
                rptBudgetOverview.DataBind();
            }
        }

        private void LoadSummary()
        {
            decimal totalIncome = 0, totalExpenses = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetDashboardSummary", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    totalIncome = reader["Income"] != DBNull.Value ? Convert.ToDecimal(reader["Income"]) : 0;
                    totalExpenses = reader["Expenses"] != DBNull.Value ? Math.Abs(Convert.ToDecimal(reader["Expenses"])) : 0;
                }
            }

            decimal balance = totalIncome - totalExpenses;
            decimal savingsRate = totalIncome == 0 ? 0 : ((balance) / totalIncome) * 100;

            lblTotalBalance.Text = $"${balance:N2}";
            lblMonthlyIncome.Text = $"${totalIncome:N2}";
            lblMonthlyExpenses.Text = $"${totalExpenses:N2}";
            lblSavingsRate.Text = $"{savingsRate:N1}%";
        }

        private void LoadUpcomingPayments()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetUpcomingPayments", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptUpcomingPayments.DataSource = dt;
                rptUpcomingPayments.DataBind();
            }
        }

        private void LoadTransactions()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetLatestTransactions", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptTransactions.DataSource = dt;
                rptTransactions.DataBind();
            }
        }

        protected void btnShowForm_Click(object sender, EventArgs e)
        {
            //pnlAddExpense.Visible = true;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            decimal amount;
            if (!Decimal.TryParse(txtAmount.Text, out amount))
            {
                Response.Write("<script>alert('Invalid amount format. Please enter a valid number.');</script>");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_InsertExpense", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                cmd.Parameters.AddWithValue("@Amount", amount);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            txtTitle.Text = "";
            txtAmount.Text = "";
            //pnlAddExpense.Visible = false;

            LoadTransactions();
            LoadSummary();
        }

        private DataTable GetAllActivities()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT Title, Amount, Type, CreatedAt
            FROM Expenses
            WHERE UserID = @UserID", conn);

                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void calActivities_DayRender(object sender, DayRenderEventArgs e)
        {
            e.Cell.Controls.Clear(); // clear default content

            DataTable activities = GetAllActivities();

            var dayActivities = activities.AsEnumerable()
                .Where(row => Convert.ToDateTime(row["CreatedAt"]).Date == e.Day.Date)
                .ToList();

            // Create a clickable LinkButton that triggers selection
            LinkButton lb = new LinkButton();
            lb.Text = e.Day.DayNumberText;
            lb.CommandName = "Select";
            lb.CommandArgument = e.Day.Date.ToShortDateString();
            lb.CssClass = "calendar-day-btn";
            lb.ForeColor = System.Drawing.ColorTranslator.FromHtml("#1e293b");
            lb.Style.Add("text-decoration", "none");
            lb.Style.Add("font-weight", "600");

            e.Cell.Controls.Add(lb);

            // 🛡️ Register for event validation
            ClientScript.RegisterForEventValidation(calActivities.UniqueID, "Select$" + e.Day.Date.ToShortDateString());

            // Add dots if needed
            if (dayActivities.Any())
            {
                string dots = "<div style='display:flex; justify-content:center; margin-top:5px; gap:4px;'>";
                if (dayActivities.Any(a => a["Type"].ToString() == "Income"))
                    dots += "<div class='dot-income'></div>";
                if (dayActivities.Any(a => a["Type"].ToString() == "Expense"))
                    dots += "<div class='dot-expense'></div>";
                dots += "</div>";

                e.Cell.Controls.Add(new LiteralControl(dots));
            }
        }




        protected void calActivities_SelectionChanged(object sender, EventArgs e)
        {
            lblSelectedDate.Text = calActivities.SelectedDate.ToString("MMMM dd, yyyy");

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT Title, Amount, Type
            FROM Expenses
            WHERE UserID = @UserID
            AND CAST(CreatedAt AS DATE) = @SelectedDate", conn);

                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@SelectedDate", calActivities.SelectedDate.Date);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptActivities.DataSource = dt;
                rptActivities.DataBind();
            }
        }

    }
}
