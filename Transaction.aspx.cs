using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;
using OfficeOpenXml.Style;
using OfficeOpenXml;
 
using System.Drawing;
using OfficeOpenXml.Drawing.Chart;
using System.Web.UI.WebControls; // (for coloring the Excel header row)

namespace WebApplication5
{
    public partial class Transaction : System.Web.UI.Page
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
                LoadTransactions();
                LoadCategories();
                GenerateChartScript();
                GenerateMonthlyChart();
                GeneratePaymentMethodChart();
                 FillPaymentMethods();
                LoadAllTransactions(); // Load everything initially
 
                ddlMonth.Items.Add(new ListItem("All Months", "0"));
                for (int i = 1; i <= 12; i++)
                {
                    ddlMonth.Items.Add(new ListItem(
                        System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(i), i.ToString()
                    ));
                }

                // ✨ Make sure the filters are empty/default
                txtSearch.Text = string.Empty;
                if (ddlMonth.Items.Count > 0)
                {
                    ddlMonth.SelectedIndex = 0; // select first item (e.g., "All Months" or "Select Month")
                }

                // ✨ Now calculate totals immediately
                CalculateTotals();
            
        }
        }

        private void LoadAllTransactions()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Expenses WHERE UserID = @UserID ORDER BY CreatedAt DESC";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();
            }
        }


        private void FillPaymentMethods()
        {
            ddlPaymentMethod.Items.Clear(); // Clear previous items
            ddlPaymentMethod.Items.Add(new ListItem("Select Payment Method", ""));
            ddlPaymentMethod.Items.Add(new ListItem("Credit Card", "Credit Card"));
            ddlPaymentMethod.Items.Add(new ListItem("Debit Card", "Debit Card"));
            ddlPaymentMethod.Items.Add(new ListItem("Bank Transfer", "Bank Transfer"));
            ddlPaymentMethod.Items.Add(new ListItem("Cash", "Cash"));
            ddlPaymentMethod.Items.Add(new ListItem("Check", "Check"));
        }
        protected string GetCategoryIconClass(object category)
        {
            if (category == null) return "fas fa-question-circle";

            string cat = category.ToString().ToLower();
            switch (cat)
            {
                case "groceries":
                    return "fas fa-shopping-basket";
                case "dining":
                    return "fas fa-utensils";
                case "income":
                    return "fas fa-wallet";
                case "housing":
                    return "fas fa-home";
                case "shopping":
                    return "fas fa-shopping-cart";
                case "health":
                    return "fas fa-heartbeat";
                case "vape":
                    return "fas fa-smoking";
                case "food":
                    return "fas fa-pizza-slice";
                default:
                    return "fas fa-receipt"; // default icon
            }
        }

        private void LoadTransactions()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetTransactionsFiltered", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@SearchTitle", string.IsNullOrEmpty(txtSearch.Text.Trim()) ? (object)DBNull.Value : txtSearch.Text.Trim());
                cmd.Parameters.AddWithValue("@MonthFilter", ddlMonth.SelectedValue == "0" ? (object)DBNull.Value : ddlMonth.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();
            }
        }





        protected void btnSearch_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Expenses WHERE UserID = @UserID";
                if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                {
                    query += " AND Title LIKE @Search";
                }
                if (ddlMonth.SelectedValue != "")
                {
                    query += " AND MONTH(CreatedAt) = @Month";
                }

                query += " ORDER BY CreatedAt DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
                }
                if (ddlMonth.SelectedValue != "")
                {
                    cmd.Parameters.AddWithValue("@Month", ddlMonth.SelectedValue);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();
            }
        }


        protected void btnClearFilter_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlMonth.SelectedIndex = 0;
            LoadTransactions();
            GenerateChartScript();
            GenerateMonthlyChart();
            GeneratePaymentMethodChart();
            CalculateTotals();
            LoadAllTransactions(); // Reset to show all

        }



        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT DISTINCT Category FROM Expenses", conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    string category = dr["Category"].ToString();
                    if (!ddlCategoryForm.Items.Contains(new System.Web.UI.WebControls.ListItem(category)))
                        ddlCategoryForm.Items.Add(category);
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (ddlType.SelectedValue == "Income" && Convert.ToDecimal(txtAmount.Text) < 0)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Income amount cannot be negative.');", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd;
                string type = ddlType.SelectedValue;

                // Parse the date from txtTransactionDate
                DateTime transactionDate;
                if (!DateTime.TryParse(txtTransactionDate.Text, out transactionDate))
                {
                    transactionDate = DateTime.Now; // fallback if invalid or empty
                }

                if (string.IsNullOrEmpty(hfEditId.Value))
                {
                    // INSERT
                    cmd = new SqlCommand("usp_InsertTransaction", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                    cmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtAmount.Text));
                    cmd.Parameters.AddWithValue("@Category", ddlCategoryForm.SelectedValue);
                    cmd.Parameters.AddWithValue("@PaymentMethod", ddlPaymentMethod.SelectedValue);
                    cmd.Parameters.AddWithValue("@Type", type);
                    cmd.Parameters.AddWithValue("@CreatedAt", transactionDate);  // 🔥 Add CreatedAt parameter
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                }
                else
                {
                    // UPDATE
                    cmd = new SqlCommand("usp_UpdateTransaction", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Id", hfEditId.Value);
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                    cmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtAmount.Text));
                    cmd.Parameters.AddWithValue("@Category", ddlCategoryForm.SelectedValue);
                    cmd.Parameters.AddWithValue("@PaymentMethod", ddlPaymentMethod.SelectedValue);
                    cmd.Parameters.AddWithValue("@Type", type);
                    cmd.Parameters.AddWithValue("@CreatedAt", transactionDate);  // 🔥 Also update CreatedAt
                }

                cmd.ExecuteNonQuery();
            }

            ClearForm();
            LoadTransactions();
            GenerateChartScript();
            GenerateMonthlyChart();
            GeneratePaymentMethodChart();
        }


        private void CalculateTotals()
        {
            decimal income = 0;
            decimal expense = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_CalculateTotalsFiltered", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@SearchTitle", string.IsNullOrEmpty(txtSearch.Text.Trim()) ? (object)DBNull.Value : txtSearch.Text.Trim());
                cmd.Parameters.AddWithValue("@MonthFilter", ddlMonth.SelectedValue == "0" ? (object)DBNull.Value : ddlMonth.SelectedValue);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    income = dr["TotalIncome"] != DBNull.Value ? Convert.ToDecimal(dr["TotalIncome"]) : 0;
                    expense = dr["TotalExpense"] != DBNull.Value ? Convert.ToDecimal(dr["TotalExpense"]) : 0;
                }
            }

            // ✅ Instead of setting Label.Text, use JavaScript to animate the counters
            ScriptManager.RegisterStartupScript(this, this.GetType(), "updateCounters",
         $"animateCounter('incomeCount', {income}); animateCounter('expenseCount', {expense});", true);

        }





        protected void gvTransactions_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            gvTransactions.PageIndex = e.NewPageIndex;
            LoadTransactions();
        }

        protected void gvTransactions_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            string id = e.CommandArgument.ToString();

            if (e.CommandName == "EditRow")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM Expenses WHERE Id=@Id", conn);
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfEditId.Value = dr["Id"].ToString();
                        txtTitle.Text = dr["Title"].ToString();
                        txtAmount.Text = dr["Amount"].ToString();
                        ddlCategoryForm.SelectedValue = dr["Category"].ToString();
                        ddlPaymentMethod.SelectedValue = dr["PaymentMethod"].ToString();

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModal", "openModal();", true);
                    }
                }
            }

            if (e.CommandName == "DeleteRow")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Expenses WHERE Id=@Id", conn);
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadTransactions();
                GenerateChartScript();
            }
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            // Step 1: Create Excel using EPPlus
            using (var package = new OfficeOpenXml.ExcelPackage())
            {
                var sheet = package.Workbook.Worksheets.Add("Transactions");

                int row = 1;
                int col = 1;

                // Step 2: Add headers
                sheet.Cells[row, col++].Value = "Title";
                sheet.Cells[row, col++].Value = "Category";
                sheet.Cells[row, col++].Value = "Date";
                sheet.Cells[row, col++].Value = "Payment Method";
                sheet.Cells[row, col++].Value = "Amount";
                sheet.Cells[row, col++].Value = "Type";

                sheet.Row(row).Style.Font.Bold = true;
                row++;

                // Step 3: Load transactions
                string connStr = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;
                DataTable dtTransactions = new DataTable();
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("usp_GetTransactionsFiltered", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@SearchTitle", string.IsNullOrEmpty(txtSearch.Text.Trim()) ? (object)DBNull.Value : txtSearch.Text.Trim());
                    cmd.Parameters.AddWithValue("@MonthFilter", ddlMonth.SelectedValue == "0" ? (object)DBNull.Value : ddlMonth.SelectedValue);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dtTransactions);
                }

                // Step 4: Write transactions to Excel
                foreach (DataRow dr in dtTransactions.Rows)
                {
                    int colIndex = 1;
                    sheet.Cells[row, colIndex++].Value = dr["Title"].ToString();
                    sheet.Cells[row, colIndex++].Value = dr["Category"].ToString();
                    sheet.Cells[row, colIndex++].Value = Convert.ToDateTime(dr["CreatedAt"]).ToString("MM/dd/yyyy");
                    sheet.Cells[row, colIndex++].Value = dr["PaymentMethod"].ToString();
                    sheet.Cells[row, colIndex++].Value = Convert.ToDecimal(dr["Amount"]);
                    sheet.Cells[row, colIndex++].Value = dr["Type"].ToString();
                    row++;
                }

                // Step 5: Fetch Total Income and Total Expenses
                decimal totalIncome = 0;
                decimal totalExpense = 0;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(@"
                SELECT 
                    SUM(CASE WHEN Type = 'Income' THEN Amount ELSE 0 END) AS TotalIncome,
                    SUM(CASE WHEN Type = 'Expense' THEN Amount ELSE 0 END) AS TotalExpense
                FROM Expenses
                WHERE UserID = @UserID", conn);

                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        totalIncome = dr["TotalIncome"] != DBNull.Value ? Convert.ToDecimal(dr["TotalIncome"]) : 0;
                        totalExpense = dr["TotalExpense"] != DBNull.Value ? Math.Abs(Convert.ToDecimal(dr["TotalExpense"])) : 0;
                    }
                }

                // Step 6: Show Totals (Income/Expenses)
                row += 2;
                sheet.Cells[row, 1].Value = "Total Income";
                sheet.Cells[row, 2].Value = totalIncome.ToString("C");
                row++;
                sheet.Cells[row, 1].Value = "Total Expenses";
                sheet.Cells[row, 2].Value = totalExpense.ToString("C");

                using (var range = sheet.Cells[row - 1, 1, row, 2])
                {
                    range.Style.Font.Bold = true;
                    range.Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                    range.Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightYellow);
                }

                // Step 7: Add a Pie Chart
                // Step 7: Add a Pie Chart
                var pieChart = sheet.Drawings.AddChart("PieChart", OfficeOpenXml.Drawing.Chart.eChartType.Pie3D) as OfficeOpenXml.Drawing.Chart.ExcelPieChart;
                pieChart.Title.Text = "Income vs Expenses";
                pieChart.SetPosition(row + 2, 0, 0, 0); // row, rowOffsetPixels, column, columnOffsetPixels
                pieChart.SetSize(600, 400);

                // ✅ CORRECT way to bind chart data
                var chartSeries = pieChart.Series.Add(
                    sheet.Cells[row - 1, 2, row, 2], // Y Axis (TotalIncome and TotalExpenses values)
                    sheet.Cells[row - 1, 1, row, 1]  // X Axis (Labels like 'Total Income' and 'Total Expenses')
                );

                pieChart.DataLabel.ShowPercent = true;


                // Step 8: AutoFit
                sheet.Cells.AutoFitColumns();

                // Step 9: Download Excel
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment; filename=TransactionsReport.xlsx");
                Response.BinaryWrite(package.GetAsByteArray());
                Response.End();
            }
        }

        protected string GetCategoryIconHtml(object categoryObj)
        {
            string category = categoryObj?.ToString()?.ToLower() ?? "";
            string iconClass = "fas fa-receipt"; // default

            switch (category)
            {
                case "groceries":
                    iconClass = "fas fa-shopping-cart text-success";
                    break;
                case "dining":
                    iconClass = "fas fa-utensils text-primary";
                    break;
                case "income":
                    iconClass = "fas fa-dollar-sign text-success";
                    break;
                case "housing":
                    iconClass = "fas fa-home text-warning";
                    break;
                case "shopping":
                    iconClass = "fas fa-shopping-bag text-info";
                    break;
                case "health":
                    iconClass = "fas fa-heartbeat text-danger";
                    break;
                case "vape":
                    iconClass = "fas fa-smoking text-secondary";
                    break;
                case "food":
                    iconClass = "fas fa-hamburger text-warning";
                    break;
            }

            return $"<i class='{iconClass}'></i>";
        }




        // Helper method

        private string GetExcelColumnName(int columnNumber)
        {
            int dividend = columnNumber;
            string columnName = String.Empty;
            int modulo;
            while (dividend > 0)
            {
                modulo = (dividend - 1) % 26;
                columnName = Convert.ToChar(65 + modulo).ToString() + columnName;
                dividend = (int)((dividend - modulo) / 26);
            }
            return columnName;
        }



        public override void VerifyRenderingInServerForm(Control control)
        {
        }



        private void ClearForm()
        {
            hfEditId.Value = "";
            txtTitle.Text = "";
            txtAmount.Text = "";
        }

        private void GenerateChartScript()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetCategorySpending", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                string labels = "";
                string data = "";

                while (dr.Read())
                {
                    labels += $"'{dr["Category"]}',";
                    data += $"{dr["Total"]},";
                }

                labels = labels.TrimEnd(',');
                data = data.TrimEnd(',');

                string script = $@"
            const chartData = {{
                labels: [{labels}],
                datasets: [{{
                    label: 'Category Spending',
                    data: [{data}],
                    backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#ff6384', '#8e44ad']
                }}]
            }};
            window.onload = function () {{
                new Chart(document.getElementById('categoryChart'), {{
                    type: 'doughnut',
                    data: chartData,
                    options: {{ responsive: true, plugins: {{ legend: {{ position: 'bottom' }} }} }}
                }});
            }};
        ";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "ChartScript", script, true);
            }
        }

        private void GenerateMonthlyChart()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetMonthlyTotals", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                string labels = "";
                string data = "";

                while (dr.Read())
                {
                    labels += $"'{dr["MonthName"]}',";
                    data += $"{dr["Total"]},";
                }

                labels = labels.TrimEnd(',');
                data = data.TrimEnd(',');

                string script = $@"
            const monthlyData = {{
                labels: [{labels}],
                datasets: [{{
                    label: 'Monthly Totals',
                    data: [{data}],
                    fill: false,
                    borderColor: '#4e73df',
                    tension: 0.1
                }}]
            }};
            new Chart(document.getElementById('monthlyChart'), {{
                type: 'line',
                data: monthlyData,
                options: {{ 
                    responsive: true,
                    maintainAspectRatio: true,
                    aspectRatio: 2,
                    plugins: {{ legend: {{ position: 'bottom' }} }}
                }}
            }});
        ";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "MonthlyChart", script, true);
            }
        }



        private void GeneratePaymentMethodChart()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetPaymentMethodTotals", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                string labels = "";
                string data = "";

                while (dr.Read())
                {
                    labels += $"'{dr["PaymentMethod"]}',";
                    data += $"{dr["Total"]},";
                }

                labels = labels.TrimEnd(',');
                data = data.TrimEnd(',');

                string script = $@"
            const paymentData = {{
                labels: [{labels}],
                datasets: [{{
                    label: 'Spending by Payment Method',
                    data: [{data}],
                    backgroundColor: ['#1abc9c', '#3498db', '#e67e22', '#9b59b6']
                }}]
            }};
            new Chart(document.getElementById('paymentChart'), {{
                type: 'bar',
                data: paymentData,
                options: {{ 
                    responsive: true,
                    maintainAspectRatio: true,
                    aspectRatio: 2,
                    plugins: {{ legend: {{ position: 'bottom' }} }}
                }}
            }});
        ";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "PaymentChart", script, true);
            }
        }


        public string GetStyledAmount(object amountObj, object typeObj)
        {
            decimal amount = Convert.ToDecimal(amountObj);
            string type = typeObj?.ToString(); // Type = "Income" or "Expense"

            if (type == "Income")
            {
                return $"<span class='badge rounded-pill bg-success'>+${amount:N2}</span>";
            }
            else if (type == "Expense")
            {
                return $"<span class='badge rounded-pill bg-danger'>-${amount:N2}</span>";
            }
            else
            {
                return $"<span class='badge bg-secondary'>${amount:N2}</span>";
            }
        }



    }
}


