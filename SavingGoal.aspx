<%@ Page Title="Saving Goals" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="SavingGoal.aspx.cs" Inherits="WebApplication5.SavingGoal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
 
  <style>
    .progress-bar {
        transition: width 1s ease-in-out;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: white;
    }
</style>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />

<div class="container mt-4">
    <asp:UpdatePanel ID="updGoals" runat="server">
        <ContentTemplate>
<asp:Repeater ID="rptGoals" runat="server" OnItemCommand="rptGoals_ItemCommand">
    <ItemTemplate>
        <div class="card mb-3">
            <div class="card-body">
                <h5 class="card-title"><%# Eval("GoalName") %></h5>

<p class="card-text">
    $<%# Eval("SavedAmount") %> / $<%# Eval("TargetAmount") %><br />

    <%# (Eval("Deadline") == DBNull.Value) 
        ? "No Deadline"
        : (Convert.ToDateTime(Eval("Deadline")) < DateTime.Now
            ? "<span style='color:red;'>Past Deadline ❌ (" + Convert.ToDateTime(Eval("Deadline")).ToString("MMM dd, yyyy") + ")</span>"
            : (Convert.ToDateTime(Eval("Deadline")) <= DateTime.Now.AddDays(7)
                ? "<span style='color:orange;'>⚠️ " + (Convert.ToDateTime(Eval("Deadline")) - DateTime.Now).Days + " Days Left! (" + Convert.ToDateTime(Eval("Deadline")).ToString("MMM dd, yyyy") + ")</span>"
                : "Deadline: " + Convert.ToDateTime(Eval("Deadline")).ToString("MMM dd, yyyy")
              )
          )
    %>
</p>

                <div class="progress mb-3">
   <div class='<%# GetProgressBarColor(Eval("Deadline")) %>' 
         role="progressbar" 
         style='width:<%# Eval("ProgressPercentage") %>%'>
         
         <%# GetProgressBarText(Eval("Deadline")) %> 
    </div>

                </div>
<asp:Button ID="btnAddFunds" runat="server" Text="Add Funds" CssClass="btn btn-success"
    CommandName="AddFunds" CommandArgument='<%# Eval("GoalId") %>' />
   

<asp:Button ID="btnDeleteGoal" runat="server" Text="Delete" CssClass="btn btn-danger ms-2"
    OnClientClick='<%# "confirmDelete(" + Eval("GoalId") + "); return false;" %>' />


                <asp:HiddenField ID="hfGoalId" runat="server" />

            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>


        </ContentTemplate>
    </asp:UpdatePanel>

<asp:Button ID="btnOpenAddGoal" runat="server" Text="Add New Goal" CssClass="btn btn-primary mb-4" OnClientClick="openAddGoalModal(); return false;" />
    <!-- Hidden Fields and Modals -->
    <asp:HiddenField ID="hfGoalId" runat="server" />

    <!-- Add Funds Modal -->
<!-- Add Funds Modal -->
<div class="modal fade" id="addFundsModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add Funds</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <asp:TextBox ID="txtGoalId" runat="server" CssClass="form-control mb-2" Visible="false" />
                <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control mb-2" placeholder="Amount" TextMode="Number" />
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control mb-2" placeholder="Description" />
                <asp:Button ID="btnSubmitFunds" runat="server" Text="Save" CssClass="btn btn-success w-100" UseSubmitBehavior="false" OnClick="btnSubmitFunds_Click" />
            </div>
        </div>
    </div>
</div>



    <!-- Add Goal Modal -->
    <div class="modal fade" id="addGoalModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title">Add New Goal</h5></div>
                <div class="modal-body">
                   <asp:TextBox ID="txtGoalName" runat="server" CssClass="form-control mb-2" placeholder="Goal Name" />

<asp:TextBox ID="txtTargetAmount" runat="server" CssClass="form-control mb-2" placeholder="Target Amount" TextMode="Number" />
                    <div class="mb-3">
    <label>Deadline</label>
    <asp:TextBox ID="txtDeadline" runat="server" CssClass="form-control" TextMode="Date" />
</div>

                    <asp:Button ID="btnSubmitGoal" runat="server" Text="Create Goal" CssClass="btn btn-primary w-100" UseSubmitBehavior="false" OnClick="btnSubmitGoal_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- History -->
    <asp:UpdatePanel ID="updHistory" runat="server">
        <ContentTemplate>
            <h4>Saving History</h4>
            <asp:GridView ID="gvSavingHistory" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered">
                <Columns>
                    <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                    <asp:BoundField DataField="GoalName" HeaderText="Goal" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" />
                    <asp:BoundField DataField="Description" HeaderText="Description" />
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>

<script>
    function openAddFundsModal(goalId) {
        document.getElementById('<%= txtGoalId.ClientID %>').value = goalId;
      var modal = new bootstrap.Modal(document.getElementById('addFundsModal'));
      modal.show();
  }

    function closeAddFundsModal() {
        var modal = bootstrap.Modal.getInstance(document.getElementById('addFundsModal'));
        if (modal) modal.hide();
    }

    function openAddGoalModal() {
        var modal = new bootstrap.Modal(document.getElementById('addGoalModal'));
        modal.show();
    }

    function closeAddGoalModal() {
        var modal = bootstrap.Modal.getInstance(document.getElementById('addGoalModal'));
        if (modal) { modal.hide(); }
    }
</script>

    <script>
        function confirmDelete(goalId) {
            if (confirm("Are you sure you want to delete this goal?")) {
                __doPostBack('DeleteGoal', goalId);
            }
        }
</script>


 
    <!-- Toast -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999">
    <div id="toastDeleted" class="toast align-items-center text-bg-success border-0" role="alert">
        <div class="d-flex">
            <div class="toast-body">
                Goal deleted successfully! 🎯
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<script>
    function showDeleteToast() {
        var toast = new bootstrap.Toast(document.getElementById('toastDeleted'));
        toast.show();
    }
</script>


    <!-- ✅ Goal Added Toast -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999">
    <div id="toastGoalAdded" class="toast align-items-center text-bg-primary border-0" role="alert">
        <div class="d-flex">
            <div class="toast-body">
                🎯 Goal added successfully!
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<!-- ✅ Funds Added Toast -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999">
    <div id="toastFundsAdded" class="toast align-items-center text-bg-success border-0" role="alert">
        <div class="d-flex">
            <div class="toast-body">
                💰 Funds added successfully!
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>
    <script>
        function showGoalAddedToast() {
            var toast = new bootstrap.Toast(document.getElementById('toastGoalAdded'));
            toast.show();
        }

        function showFundsAddedToast() {
            var toast = new bootstrap.Toast(document.getElementById('toastFundsAdded'));
            toast.show();
        }
</script>


    <!-- ❌ Error Toast -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999">
    <div id="toastError" class="toast align-items-center text-bg-danger border-0" role="alert">
        <div class="d-flex">
            <div class="toast-body">
                ❌ Please fill out all fields correctly.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

    <script>
        function showErrorToast() {
            var toast = new bootstrap.Toast(document.getElementById('toastError'));
            toast.show();
        }
</script>


</asp:Content>
