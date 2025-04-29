using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication5
{
    public partial class Dashboard : System.Web.UI.Page
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
                SetWelcomeMessage();
                LoadSummary();
                LoadTransactions();
                LoadUpcomingPayments();
                LoadBudgetOverview();
                GenerateMonthlySpendingChart(); // 🆕
                GenerateCategoryChart(); // 🆕
                GenerateIncomeExpenseChart();
                GenerateSavingsGrowthChart();
            }

        }

        private void SetWelcomeMessage()
        {
            string greeting = GetGreetingByTime();
            string userName = Session["UserName"] != null ? Session["UserName"].ToString() : "User";

            lblWelcome.Text = $"{greeting}, {userName}! 👋";
        }

        private string GetGreetingByTime()
        {
            int hour = DateTime.Now.Hour;

            if (hour >= 5 && hour < 12)
                return "Good Morning";
            else if (hour >= 12 && hour < 17)
                return "Good Afternoon";
            else if (hour >= 17 && hour < 23)
                return "Good Evening";
            else
                return "Good Night";
        }

        private void LoadSummary()
        {
            decimal income = 0, expenses = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetDashboardSummary", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    income = reader["Income"] != DBNull.Value ? Convert.ToDecimal(reader["Income"]) : 0;
                    expenses = reader["Expenses"] != DBNull.Value ? Convert.ToDecimal(reader["Expenses"]) : 0;
                }
            }

            decimal balance = income - expenses;
            decimal savingsRate = income > 0 ? ((income - expenses) / income) * 100 : 0;

            lblTotalBalance.Text = $"${balance:N2}";
            lblMonthlyIncome.Text = $"${income:N2}";
            lblMonthlyExpenses.Text = $"${expenses:N2}";
            lblSavingsRate.Text = $"{savingsRate:N1}%";

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

                // ✅ Bind data to rptTransactions
                rptTransactions.DataSource = dt;
                rptTransactions.DataBind();
            }
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

        private void LoadBudgetOverview()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetBudgetOverview", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    // Add Progress column if not exists
                    if (!dt.Columns.Contains("Progress"))
                        dt.Columns.Add("Progress", typeof(int));

                    decimal totalExpenses = dt.AsEnumerable().Sum(row => row.Field<decimal>("Total"));

                    foreach (DataRow row in dt.Rows)
                    {
                        decimal categoryTotal = Convert.ToDecimal(row["Total"]);
                        int percentage = totalExpenses > 0 ? (int)((categoryTotal / totalExpenses) * 100) : 0;
                        row["Progress"] = percentage;
                    }

                    rptBudgetOverview.DataSource = dt;
                    rptBudgetOverview.DataBind();
                }
            }
        }


        private void GenerateCategoryChart()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetCategoryChartData", conn); // Your Stored Procedure
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                string labels = "";
                string data = "";

                while (dr.Read())
                {
                    labels += $"'{dr["Category"].ToString()}',";
                    data += $"{dr["Total"]},";
                }

                labels = labels.TrimEnd(',');
                data = data.TrimEnd(',');

                string script = $@"
            window.addEventListener('load', function() {{
                const ctx = document.getElementById('categoryChart').getContext('2d');
                new Chart(ctx, {{
                    type: 'doughnut',
                    data: {{
                        labels: [{labels}],
                        datasets: [{{
                            data: [{data}],
                            backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b']
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

                ScriptManager.RegisterStartupScript(this, this.GetType(), "CategoryChart", script, true);
            }
        }

        private void GenerateMonthlySpendingChart()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("usp_GetMonthlySpendingData", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                string labels = "";
                string data = "";

                while (reader.Read())
                {
                    labels += $"'{reader["MonthName"]}',";
                    data += reader["Total"] + ",";
                }

                labels = labels.TrimEnd(',');
                data = data.TrimEnd(',');

                string script = $@"
                    const ctxMonthly = document.getElementById('monthlyChart').getContext('2d');
                    new Chart(ctxMonthly, {{
                        type: 'bar',
                        data: {{
                            labels: [{labels}],
                            datasets: [{{
                                label: 'Total Spending',
                                data: [{data}],
                                backgroundColor: '#111827'
                            }}]
                        }},
                        options: {{
                            responsive: true,
                            plugins: {{ legend: {{ display: false }} }}
                        }}
                    }});
                ";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "monthlyChart", script, true);
            }
        }

        private void GenerateIncomeExpenseChart()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("usp_GetIncomeExpenseChartData", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                string labels = "";
                string incomeData = "";
                string expenseData = "";

                while (reader.Read())
                {
                    labels += $"'{reader["MonthName"]}',";
                    incomeData += reader["Income"] + ",";
                    expenseData += reader["Expense"] + ",";
                }

                labels = labels.TrimEnd(',');
                incomeData = incomeData.TrimEnd(',');
                expenseData = expenseData.TrimEnd(',');

                string script = $@"
                    const ctxIE = document.getElementById('incomeExpenseChart').getContext('2d');
                    new Chart(ctxIE, {{
                        type: 'bar',
                        data: {{
                            labels: [{labels}],
                            datasets: [
                                {{ label: 'Income', data: [{incomeData}], backgroundColor: '#10b981' }},
                                {{ label: 'Expenses', data: [{expenseData}], backgroundColor: '#ef4444' }}
                            ]
                        }},
                        options: {{ responsive: true, plugins: {{ legend: {{ position: 'bottom' }} }} }}
                    }});
                ";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "incomeExpenseChart", script, true);
            }
        }

        private void GenerateSavingsGrowthChart()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("usp_GetSavingsGrowthData", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                string labels = "";
                string data = "";

                while (reader.Read())
                {
                    labels += $"'{reader["MonthName"]}',";
                    data += reader["TotalSavings"] + ",";
                }

                labels = labels.TrimEnd(',');
                data = data.TrimEnd(',');

                string script = $@"
                    const ctxSavings = document.getElementById('savingsChart').getContext('2d');
                    new Chart(ctxSavings, {{
                        type: 'line',
                        data: {{
                            labels: [{labels}],
                            datasets: [{{
                                label: 'Savings Growth',
                                data: [{data}],
                                borderColor: '#6366f1',
                                backgroundColor: 'rgba(99,102,241,0.1)',
                                fill: true,
                                tension: 0.4
                            }}]
                        }},
                        options: {{ responsive: true, plugins: {{ legend: {{ position: 'bottom' }} }} }}
                    }});
                ";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "savingsChart", script, true);
            }
        }
         // calendar 

        private DataTable GetAllActivities()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"SELECT Title, Amount, Type, CreatedAt FROM Expenses WHERE UserID = @UserID", conn);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }
        protected void Calendar1_DayRender(object sender, DayRenderEventArgs e)
        {
            // ✅ DO NOT clear default controls.
            // ✅ Just add extra decoration if needed

            DataTable activities = GetAllActivities();
            var dayActivities = activities.AsEnumerable()
                .Where(row => Convert.ToDateTime(row["CreatedAt"]).Date == e.Day.Date)
                .ToList();

            if (dayActivities.Any())
            {
                // Add a tiny dot to show activity exists
                e.Cell.Controls.Add(new LiteralControl("<br/>"));

                if (dayActivities.Any(a => a["Type"].ToString() == "Income"))
                    e.Cell.Controls.Add(new LiteralControl("<span style='color:green;'>•</span>"));
                if (dayActivities.Any(a => a["Type"].ToString() == "Expense"))
                    e.Cell.Controls.Add(new LiteralControl("<span style='color:red;'>•</span>"));
            }

            // Optionally highlight today
            if (e.Day.IsToday)
                e.Cell.BackColor = System.Drawing.Color.LightYellow;
        }


        protected void Calendar1_SelectionChanged(object sender, EventArgs e)
        {
            lblSelectedDate.Text = Calendar1.SelectedDate.ToString("MMMM dd, yyyy");

            decimal incomeTotal = 0;
            decimal expenseTotal = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT Title, Amount, Type 
            FROM Expenses 
            WHERE UserID = @UserID 
              AND CAST(CreatedAt AS DATE) = @SelectedDate", conn);

                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@SelectedDate", Calendar1.SelectedDate.Date);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // ✅ Bind data to the Repeater
                rptActivities.DataSource = dt;
                rptActivities.DataBind();

                // ✅ Calculate income and expenses
                foreach (DataRow row in dt.Rows)
                {
                    decimal amount = Convert.ToDecimal(row["Amount"]);
                    string type = row["Type"].ToString();

                    if (type == "Income")
                        incomeTotal += amount;
                    else if (type == "Expense")
                        expenseTotal += amount;
                }

                // ✅ Display totals
                lblIncomeTotal.Text = incomeTotal.ToString("C");
                lblExpenseTotal.Text = expenseTotal.ToString("C");
                lblNetTotal.Text = (incomeTotal - expenseTotal).ToString("C");
            }
        }



    }
}
