using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace WebApplication5
{
    public partial class Reminders : System.Web.UI.Page
    {
        private static int editReminderId = -1;
        string connStr = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
                LoadReminders();
        }

        private void LoadReminders()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("usp_GetUserReminders", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptReminders.DataSource = dt;
                rptReminders.DataBind();
            }
        }

        protected void rptReminders_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                string status = row["DueStatus"].ToString();
                Label lblStatus = (Label)e.Item.FindControl("lblStatus");

                if (status == "overdue")
                {
                    lblStatus.Text = "Overdue";
                    lblStatus.CssClass = "badge bg-danger";
                }
                else if (status == "soon")
                {
                    lblStatus.Text = "Due Soon";
                    lblStatus.CssClass = "badge bg-warning text-dark";
                }
                else
                {
                    lblStatus.Text = "Upcoming";
                    lblStatus.CssClass = "badge bg-success";
                }
            }
        }

        protected void rptReminders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Delete")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("usp_DeleteUserReminder", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                LoadReminders();
            }
            else if (e.CommandName == "Edit")
            {
                editReminderId = id;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("usp_GetUserReminderById", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        txtTitle.Text = reader["Title"].ToString();
                        ddlFrequency.SelectedValue = reader["Frequency"].ToString();
                        txtAmount.Text = reader["Amount"].ToString();
                        txtDueDate.Text = Convert.ToDateTime(reader["DueDate"]).ToString("yyyy-MM-dd");

                        // ✅ Updated: Safe check before setting ddlIconClass
                        string iconClass = reader["IconClass"].ToString();
                        if (ddlIconClass.Items.FindByValue(iconClass) != null)
                        {
                            ddlIconClass.SelectedValue = iconClass;
                        }
                        else
                        {
                            ddlIconClass.SelectedIndex = 0;
                        }

                        pnlAddReminder.Visible = true;
                    }
                }
            }
        }

        protected void btnAddReminder_Click(object sender, EventArgs e)
        {
            decimal amount;
            DateTime dueDate;
            pnlAddReminder.Visible = true;

            if (!Decimal.TryParse(txtAmount.Text, out amount))
            {
                Response.Write("<script>alert('Invalid amount. Please enter a number.');</script>");
                return;
            }

            if (!DateTime.TryParse(txtDueDate.Text, out dueDate))
            {
                Response.Write("<script>alert('Invalid date. Please select a due date.');</script>");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd;

                if (editReminderId > 0)
                {
                    cmd = new SqlCommand(@"UPDATE Reminders 
                        SET Title=@Title, Frequency=@Frequency, Amount=@Amount, DueDate=@DueDate, IconClass=@IconClass 
                        WHERE Id=@Id AND UserID=@UserID", conn);
                    cmd.Parameters.AddWithValue("@Id", editReminderId);
                }
                else
                {
                    cmd = new SqlCommand(@"INSERT INTO Reminders (Title, Frequency, Amount, DueDate, IconClass, UserID) 
                        VALUES (@Title, @Frequency, @Amount, @DueDate, @IconClass, @UserID)", conn);
                }

                cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                cmd.Parameters.AddWithValue("@Frequency", ddlFrequency.SelectedValue);
                cmd.Parameters.AddWithValue("@Amount", amount);
                cmd.Parameters.AddWithValue("@DueDate", dueDate);
                cmd.Parameters.AddWithValue("@IconClass", ddlIconClass.SelectedValue);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ClearForm();
            LoadReminders();

            ScriptManager.RegisterStartupScript(this, GetType(), "scrollToPanel", "document.getElementById('addReminderPanel').scrollIntoView({ behavior: 'smooth' });", true);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlAddReminder.Visible = false;
            ClearForm();
        }

        private void ClearForm()
        {
            txtTitle.Text = "";
            txtAmount.Text = "";
            txtDueDate.Text = "";

            // ✅ Instead of ClearSelection, reset to default safe values
            if (ddlFrequency.Items.Count > 0)
                ddlFrequency.SelectedIndex = 0;

            if (ddlIconClass.Items.Count > 0)
                ddlIconClass.SelectedIndex = 0;

            pnlAddReminder.Visible = false;
            editReminderId = -1;
        }
    }
}
