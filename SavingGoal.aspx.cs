using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication5
{
    public partial class SavingGoal : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["BudgetDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            if (!IsPostBack)
            {
                LoadGoals();
                LoadHistory();
            }

            // Handle delete postback
            string eventTarget = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            if (eventTarget == "DeleteGoal" && !string.IsNullOrEmpty(eventArgument))
            {
                int goalId = int.Parse(eventArgument);
                DeleteGoal(goalId);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "showToast", "showDeleteToast();", true);
            }
        }

        private void DeleteGoal(int goalId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("usp_DeleteSavingGoal", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@GoalId", goalId);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.ExecuteNonQuery();
            }

            LoadGoals();
            LoadHistory();
        }

        protected void rptGoals_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddFunds")
            {
                txtGoalId.Text = e.CommandArgument.ToString();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "openModal", "var myModal = new bootstrap.Modal(document.getElementById('addFundsModal')); myModal.show();", true);
            }
       
            else if (e.CommandName == "DeleteGoal")
            {
                int goalId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    // First delete all saving transactions related to this goal (optional if you want)
                    SqlCommand cmd1 = new SqlCommand("DELETE FROM SavingTransactions WHERE GoalId = @GoalId", con);
                    cmd1.Parameters.AddWithValue("@GoalId", goalId);
                    cmd1.ExecuteNonQuery();

                    // Then delete the goal
                    SqlCommand cmd2 = new SqlCommand("DELETE FROM SavingGoals WHERE GoalId = @GoalId", con);
                    cmd2.Parameters.AddWithValue("@GoalId", goalId);
                    cmd2.ExecuteNonQuery();
                }

                LoadGoals();
                LoadHistory();
            }
        }

        protected void btnSubmitFunds_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtAmount.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "errorToast", "showErrorToast();", true);
                return;
            }
            if (int.TryParse(txtGoalId.Text, out int goalId) &&
                decimal.TryParse(txtAmount.Text, out decimal amount))
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("usp_InsertSavingTransaction", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@GoalId", goalId);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                    cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    cmd.ExecuteNonQuery();
                }

                txtAmount.Text = "";
                txtDescription.Text = "";
                txtGoalId.Text = "";

                LoadGoals();
                LoadHistory();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "closeFundsModal", @"
        var modal = bootstrap.Modal.getInstance(document.getElementById('addFundsModal'));
        if(modal){ modal.hide(); }
        showFundsAddedToast();", true);
            }
        }


        protected void btnSubmitGoal_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtGoalName.Text) || string.IsNullOrWhiteSpace(txtTargetAmount.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "errorToast", "showErrorToast();", true);
                return;
            }

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("usp_InsertSavingGoal", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@GoalName", txtGoalName.Text);
                cmd.Parameters.AddWithValue("@TargetAmount", decimal.Parse(txtTargetAmount.Text));
                cmd.Parameters.AddWithValue("@Deadline", string.IsNullOrEmpty(txtDeadline.Text) ? (object)DBNull.Value : DateTime.Parse(txtDeadline.Text));
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.ExecuteNonQuery();
            }

            txtGoalName.Text = "";
            txtTargetAmount.Text = "";

            LoadGoals();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "closeGoalModal", @"
    var modal = bootstrap.Modal.getInstance(document.getElementById('addGoalModal'));
    if(modal){ modal.hide(); }
    showGoalAddedToast();", true);
        }


        protected string GetProgressBarColor(object deadlineObj)
        {
            if (deadlineObj == DBNull.Value || deadlineObj == null)
            {
                return "progress-bar bg-success"; // No deadline, normal green
            }

            DateTime deadline = Convert.ToDateTime(deadlineObj);

            if (deadline < DateTime.Now)
            {
                return "progress-bar bg-danger"; // Past deadline → Red
            }
            else if (deadline <= DateTime.Now.AddDays(7))
            {
                return "progress-bar bg-warning"; // Within 7 days → Orange
            }
            else
            {
                return "progress-bar bg-success"; // Future → Green
            }
        }

        protected string GetProgressBarText(object deadlineObj)
        {
            if (deadlineObj == DBNull.Value || deadlineObj == null)
            {
                return ""; // No deadline
            }

            DateTime deadline = Convert.ToDateTime(deadlineObj);

            if (deadline < DateTime.Now)
            {
                return "Expired ❌";
            }
            else if (deadline <= DateTime.Now.AddDays(7))
            {
                int daysLeft = (deadline - DateTime.Now).Days;
                if (daysLeft == 0)
                    return "Today!";
                return $"{daysLeft} Days Left!";
            }
            else
            {
                return ""; // Future deadlines no extra text
            }
        }

        private void LoadGoals()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("usp_GetSavingGoals", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                rptGoals.DataSource = dt;
                rptGoals.DataBind();
            }
        }


        private void LoadHistory()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("usp_GetSavingHistory", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                gvSavingHistory.DataSource = dt;
                gvSavingHistory.DataBind();
            }
        }

    }
}
