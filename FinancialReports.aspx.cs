using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication5
{
    public partial class FinancialReports : System.Web.UI.Page
    {
        string connStr = WebConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadDropdowns();
                LoadReports();
                LoadTop5();
                LoadMonthlyWeeklySummary();
            }
        }

        protected void gvReports_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvReports.PageIndex = e.NewPageIndex;
            LoadReports();
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=FinancialReports.xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";

            System.IO.StringWriter sw = new System.IO.StringWriter();
            HtmlTextWriter hw = new HtmlTextWriter(sw);

            gvReports.AllowPaging = false;
            LoadReports(); // No paging while exporting
            gvReports.RenderControl(hw);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }

        public override void VerifyRenderingInServerForm(Control control) { }

        private void LoadDropdowns()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                SqlCommand cmdTitles = new SqlCommand("SELECT DISTINCT Title FROM Expenses WHERE UserID = @UserID ORDER BY Title", con);
                cmdTitles.Parameters.AddWithValue("@UserID", Session["UserID"]);
                ddlTitleFilter.DataSource = cmdTitles.ExecuteReader();
                ddlTitleFilter.DataTextField = "Title";
                ddlTitleFilter.DataValueField = "Title";
                ddlTitleFilter.DataBind();
                ddlTitleFilter.Items.Insert(0, new ListItem("Select Title", ""));

                con.Close(); con.Open();

                SqlCommand cmdCategories = new SqlCommand("SELECT DISTINCT Category FROM Expenses WHERE UserID = @UserID ORDER BY Category", con);
                cmdCategories.Parameters.AddWithValue("@UserID", Session["UserID"]);
                ddlCategoryFilter.DataSource = cmdCategories.ExecuteReader();
                ddlCategoryFilter.DataTextField = "Category";
                ddlCategoryFilter.DataValueField = "Category";
                ddlCategoryFilter.DataBind();
                ddlCategoryFilter.Items.Insert(0, new ListItem("Select Category", ""));

                con.Close();
            }
        }

        private void LoadReports()
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetUserExpensesReport", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@Title", string.IsNullOrEmpty(ddlTitleFilter.SelectedValue) ? (object)DBNull.Value : ddlTitleFilter.SelectedValue);
                cmd.Parameters.AddWithValue("@Category", string.IsNullOrEmpty(ddlCategoryFilter.SelectedValue) ? (object)DBNull.Value : ddlCategoryFilter.SelectedValue);
                cmd.Parameters.AddWithValue("@PaymentMethod", string.IsNullOrEmpty(ddlPaymentMethodFilter.SelectedValue) ? (object)DBNull.Value : ddlPaymentMethodFilter.SelectedValue);
                cmd.Parameters.AddWithValue("@Type", string.IsNullOrEmpty(ddlTypeFilter.SelectedValue) ? (object)DBNull.Value : ddlTypeFilter.SelectedValue);
                cmd.Parameters.AddWithValue("@StartDate", string.IsNullOrEmpty(txtStartDate.Text) ? (object)DBNull.Value : Convert.ToDateTime(txtStartDate.Text));
                cmd.Parameters.AddWithValue("@EndDate", string.IsNullOrEmpty(txtEndDate.Text) ? (object)DBNull.Value : Convert.ToDateTime(txtEndDate.Text));

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            gvReports.DataSource = dt;
            gvReports.DataBind();

            decimal income = 0, expense = 0;
            foreach (DataRow row in dt.Rows)
            {
                decimal amount = Convert.ToDecimal(row["Amount"]);
                string type = row["Type"].ToString();
                if (type == "Income")
                    income += amount;
                else if (type == "Expense")
                    expense += amount;
            }

            lblIncome.InnerText = income.ToString("C");
            lblExpense.InnerText = expense.ToString("C");
            lblTotalSavings.InnerText = (income - expense).ToString("C");

            // Pie Chart Script
            ScriptManager.RegisterStartupScript(this, GetType(), "PieChart", $"drawPieChart({income}, {expense});", true);
        }

        private void LoadTop5()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                SqlCommand cmdExpenses = new SqlCommand("usp_GetUserTop5Expenses", con);
                cmdExpenses.CommandType = CommandType.StoredProcedure;
                cmdExpenses.Parameters.AddWithValue("@UserID", Session["UserID"]);
                SqlDataAdapter daExpenses = new SqlDataAdapter(cmdExpenses);
                DataTable dtExpenses = new DataTable();
                daExpenses.Fill(dtExpenses);
                rptTopExpenses.DataSource = dtExpenses;
                rptTopExpenses.DataBind();

                SqlCommand cmdIncomes = new SqlCommand("usp_GetUserTop5Incomes", con);
                cmdIncomes.CommandType = CommandType.StoredProcedure;
                cmdIncomes.Parameters.AddWithValue("@UserID", Session["UserID"]);
                SqlDataAdapter daIncomes = new SqlDataAdapter(cmdIncomes);
                DataTable dtIncomes = new DataTable();
                daIncomes.Fill(dtIncomes);
                rptTopIncomes.DataSource = dtIncomes;
                rptTopIncomes.DataBind();

                con.Close();
            }
        }

        private void LoadMonthlyWeeklySummary()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("usp_GetUserMonthlyWeeklySummary", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    decimal monthlyIncome = reader["MonthlyIncome"] != DBNull.Value ? Convert.ToDecimal(reader["MonthlyIncome"]) : 0;
                    decimal monthlyExpense = reader["MonthlyExpense"] != DBNull.Value ? Convert.ToDecimal(reader["MonthlyExpense"]) : 0;
                    decimal monthlySavings = monthlyIncome - monthlyExpense;

                    if (monthlyIncome == 0 && monthlyExpense == 0)
                    {
                        lblMonthlyIncome.InnerText = "No Activity";
                        lblMonthlyExpense.InnerText = "No Activity";
                        lblMonthlySavings.InnerText = "No Activity";
                    }
                    else
                    {
                        lblMonthlyIncome.InnerText = monthlyIncome.ToString("C");
                        lblMonthlyExpense.InnerText = monthlyExpense.ToString("C");
                        lblMonthlySavings.InnerText = monthlySavings.ToString("C");
                    }
                }

                if (reader.NextResult() && reader.Read())
                {
                    decimal weeklyIncome = reader["WeeklyIncome"] != DBNull.Value ? Convert.ToDecimal(reader["WeeklyIncome"]) : 0;
                    decimal weeklyExpense = reader["WeeklyExpense"] != DBNull.Value ? Convert.ToDecimal(reader["WeeklyExpense"]) : 0;
                    decimal weeklySavings = weeklyIncome - weeklyExpense;

                    if (weeklyIncome == 0 && weeklyExpense == 0)
                    {
                        lblWeeklyIncome.InnerText = "No Activity";
                        lblWeeklyExpense.InnerText = "No Activity";
                        lblWeeklySavings.InnerText = "No Activity";
                    }
                    else
                    {
                        lblWeeklyIncome.InnerText = weeklyIncome.ToString("C");
                        lblWeeklyExpense.InnerText = weeklyExpense.ToString("C");
                        lblWeeklySavings.InnerText = weeklySavings.ToString("C");
                    }
                }
                reader.Close();
            }
        }


        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadReports();
        }

        protected void btnAddTransaction_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Expenses (Title, Amount, CreatedAt, Category, PaymentMethod, Type, UserID) VALUES (@Title, @Amount, GETDATE(), @Category, @PaymentMethod, @Type, @UserID)", con);
                cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                cmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtAmount.Text));
                cmd.Parameters.AddWithValue("@Category", txtCategory.Text);
                cmd.Parameters.AddWithValue("@PaymentMethod", txtPaymentMethod.Text);
                cmd.Parameters.AddWithValue("@Type", ddlType.SelectedValue);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            ClearForm();
            LoadReports();
        }

        private void ClearForm()
        {
            txtTitle.Text = "";
            txtAmount.Text = "";
            txtCategory.Text = "";
            txtPaymentMethod.Text = "";
            ddlType.SelectedIndex = 0;
        }
    }
}
