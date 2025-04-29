
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace WebApplication5
{
    public partial class Transactions : System.Web.UI.Page
    {
        private static int editTransactionId = -1;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAllTransactions();
            }

            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            if (eventTarget == "FilterByTag")
            {
                FilterTransactionsByCategory(eventArgument);
            }
            else if (eventTarget == "EditTransaction")
            {
                int id = int.Parse(eventArgument);
                LoadTransactionToModal(id);
                ScriptManager.RegisterStartupScript(this, GetType(), "ShowModal", "$('#transactionModal').modal('show');", true);
            }
        }

        private void FilterTransactionsByCategory(string category)
        {
            var dt = GetAllTransactions(); // Assume this method returns a DataTable of all transactions
            if (!string.IsNullOrEmpty(category))
            {
                var filtered = dt.AsEnumerable()
                                 .Where(row => row.Field<string>("Category").Equals(category, StringComparison.OrdinalIgnoreCase))
                                 .CopyToDataTable();

                rptAllTransactions.DataSource = filtered;
            }
            else
            {
                rptAllTransactions.DataSource = dt;
            }
            rptAllTransactions.DataBind();
        }

        private void LoadTransactionToModal(int id)
        {
            string query = "SELECT * FROM Transactions WHERE Id = @Id";
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    hfTransactionId.Value = reader["Id"].ToString();
                    txtTitle.Text = reader["Title"].ToString();
                    ddlCategory.SelectedValue = reader["Category"].ToString();
                    ddlMethod.SelectedValue = reader["PaymentMethod"].ToString();
                    txtAmount.Text = reader["Amount"].ToString();
                    txtDate.Text = Convert.ToDateTime(reader["CreatedAt"]).ToString("yyyy-MM-dd");
                }
            }
        }

        protected void btnShowForm_Click(object sender, EventArgs e)
        {
            //pnlAdd.Visible = true;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string query = "";
            bool isUpdate = !string.IsNullOrEmpty(hfTransactionId.Value);

            if (isUpdate)
            {
                query = @"UPDATE Transactions SET Title=@Title, Category=@Category, PaymentMethod=@Method,
                  Amount=@Amount, CreatedAt=@Date WHERE Id=@Id";
            }
            else
            {
                query = @"INSERT INTO Transactions (Title, Category, PaymentMethod, Amount, CreatedAt)
                  VALUES (@Title, @Category, @Method, @Amount, @Date)";
            }

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Method", ddlMethod.SelectedValue);
                cmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtAmount.Text));
                cmd.Parameters.AddWithValue("@Date", Convert.ToDateTime(txtDate.Text));

                if (isUpdate)
                    cmd.Parameters.AddWithValue("@Id", Convert.ToInt32(hfTransactionId.Value));

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            hfTransactionId.Value = "";
            txtTitle.Text = txtAmount.Text = "";
            ddlCategory.ClearSelection();
            ddlMethod.ClearSelection();
            txtDate.Text = "";

            LoadAllTransactions();
        }

        private DataTable GetAllTransactions()
        {
            DataTable dt = new DataTable();
            string connStr = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Expenses ORDER BY CreatedAt DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            return dt;
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            DataTable dt = GetAllTransactions();

            decimal totalIncome = 0;
            decimal totalExpense = 0;

            foreach (DataRow row in dt.Rows)
            {
                if (decimal.TryParse(row["Amount"].ToString(), out decimal amt))
                {
                    if (amt >= 0)
                        totalIncome += amt;
                    else
                        totalExpense += amt;
                }
            }

            // Add a totals row manually
            DataRow totalsRow = dt.NewRow();
            totalsRow["Title"] = "Totals";
            totalsRow["Category"] = "";
            totalsRow["CreatedAt"] = DBNull.Value;
            totalsRow["PaymentMethod"] = "";
            totalsRow["Amount"] = $"Income: {totalIncome:C2}, Expense: {totalExpense:C2}, Net: {(totalIncome + totalExpense):C2}";
            dt.Rows.Add(totalsRow);

            GridView gv = new GridView();
            gv.DataSource = dt;
            gv.DataBind();

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=TransactionsExport.xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";

            using (System.IO.StringWriter sw = new System.IO.StringWriter())
            {
                HtmlTextWriter hw = new HtmlTextWriter(sw);
                gv.RenderControl(hw);
                Response.Output.Write(sw.ToString());
            }

            Response.Flush();
            Response.End();
        }

        protected void gv_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                decimal amount;
                if (decimal.TryParse(DataBinder.Eval(e.Row.DataItem, "Amount").ToString(), out amount))
                {
                    if (amount >= 0)
                        e.Row.Cells[5].Attributes.Add("style", "color:green;");
                    else
                        e.Row.Cells[5].Attributes.Add("style", "color:red;");
                }
            }
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for exporting GridView
        }


        protected void btnFilter_Click(object sender, EventArgs e)
        {
            //LoadAllTransactions(txtSearchTitle.Text, ddlFilterCategory.SelectedValue);
        }


        protected void rptAllTransactions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Delete")
            {
                string connStr = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Expenses WHERE Id=@Id", conn);
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                LoadAllTransactions();
            }
            else if (e.CommandName == "Edit")
            {
                editTransactionId = id;
                string connStr = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM Expenses WHERE Id=@Id", conn);
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        txtTitle.Text = reader["Title"].ToString();
                        ddlCategory.SelectedValue = reader["Category"].ToString();
                        txtDate.Text = Convert.ToDateTime(reader["CreatedAt"]).ToString("yyyy-MM-dd");
                        ddlMethod.SelectedValue = reader["PaymentMethod"].ToString();
                        txtAmount.Text = reader["Amount"].ToString();
                        //pnlAdd.Visible = true;
                    }
                }
            }
        }

        protected void LoadAllTransactions()
        {
            DataTable dt = GetAllTransactions(); // your existing method
            rptAllTransactions.DataSource = dt;
            rptAllTransactions.DataBind();

            decimal totalIncome = 0;
            decimal totalExpense = 0;

            foreach (DataRow row in dt.Rows)
            {
                if (decimal.TryParse(row["Amount"].ToString(), out decimal amount))
                {
                    if (amount >= 0)
                        totalIncome += amount;
                    else
                        totalExpense += amount;
                }
            }

            lblFooterIncome.Text = totalIncome.ToString("C2");
            lblFooterExpense.Text = totalExpense.ToString("C2");
            lblFooterNet.Text = (totalIncome + totalExpense).ToString("C2");

            // Also set ViewState for chart.js rendering
            ViewState["TotalIncome"] = totalIncome;
            ViewState["TotalExpense"] = Math.Abs(totalExpense); // Chart expects positive number
        }

        protected string GetCategoryIcon(string category)
        {
            switch (category.ToLower())
            {
                case "dining": return "fas fa-utensils";
                case "shopping": return "fas fa-shopping-cart";
                case "income": return "fas fa-wallet";
                case "housing": return "fas fa-home";
                case "health": return "fas fa-heartbeat";
                case "auto": return "fas fa-car";
                default: return "fas fa-tag";
            }
        }


        private void ClearForm()
        {
            txtTitle.Text = "";
            ddlCategory.ClearSelection();
            txtDate.Text = "";
            ddlMethod.ClearSelection();
            txtAmount.Text = "";
            //pnlAdd.Visible = false;
            editTransactionId = -1;
        }
    }
}
