<%@ Page Title="Transactions" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="Transaction.aspx.cs" Inherits="WebApplication5.Transaction" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .main-container { padding: 30px; }
        .amount-income { color: green !important; font-weight: 600; }
        .amount-expense { color: red !important; font-weight: 600; }
        .table-hover tbody tr:hover { background-color: #e3f2fd; transform: scale(1.01); transition: 0.2s; }
        .btn { box-shadow: 0 4px 10px rgba(0,0,0,0.15); transition: 0.3s ease; }
        .btn:hover { transform: translateY(-2px); }
    </style>
</asp:Content>

<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="container-fluid main-container">

    <!-- Heading -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Transactions</h2>
        <asp:Button ID="btnOpenModal" runat="server" Text="Add Transaction" CssClass="btn btn-primary rounded-pill px-4" OnClientClick="openModal(); return false;" />
    </div>

    <!-- Filters -->
    <div class="row mb-4 g-2">
        <div class="col-md-3">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by Title..." />
        </div>
        <div class="col-md-2">
    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-select">
</asp:DropDownList>

        </div>
        <div class="col-md-2 d-flex gap-2">
            <asp:Button ID="btnSearch" runat="server" Text="Filter" CssClass="btn btn-info w-100" OnClick="btnSearch_Click" />
            <asp:Button ID="btnClearFilter" runat="server" Text="Clear" CssClass="btn btn-secondary w-100" OnClick="btnClearFilter_Click" />
        </div>
        <div class="col-md-2">
            <asp:Button ID="btnExport" runat="server" Text="Export" CssClass="btn btn-dark w-100" OnClick="btnExport_Click" />
        </div>
    </div>

    <!-- Table -->
    <div class="card shadow-sm mb-4">
        <div class="card-body p-0">
            <asp:GridView ID="gvTransactions" runat="server" CssClass="table table-hover table-striped mb-0" AutoGenerateColumns="False" AllowPaging="True" PageSize="5" OnPageIndexChanging="gvTransactions_PageIndexChanging" OnRowCommand="gvTransactions_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="Category">
                        <ItemTemplate>
                            <div class="d-flex align-items-center gap-2">
                                <span class="fs-5"><i class='<%# GetCategoryIconClass(Eval("Category")) %>'></i></span>
                                <span class="fw-bold"><%# Eval("Category") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Title" HeaderText="Title" />
                    <asp:BoundField DataField="CreatedAt" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />

                    <asp:TemplateField HeaderText="Payment">
                        <ItemTemplate>
                            <span class="badge bg-primary"><%# Eval("PaymentMethod") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Amount">
                        <ItemTemplate>
                            <%# GetStyledAmount(Eval("Amount"), Eval("Type")) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-warning btn-sm rounded-pill me-2">Edit</asp:LinkButton>
                            <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-danger btn-sm rounded-pill">Delete</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
        </div>
    </div>

    <!-- Totals -->
    <div class="row g-4">
        <div class="col-md-6">
            <div class="card text-white" style="background: linear-gradient(45deg, #4CAF50, #2E7D32);">
                <div class="card-body text-center">
                    <h5>Total Income</h5>
                    <h3>$<span id="incomeCount"></span></h3>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card text-white" style="background: linear-gradient(45deg, #e53935, #b71c1c);">
                <div class="card-body text-center">
                    <h5>Total Expenses</h5>
                    <h3>$<span id="expenseCount"></span></h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts -->
    <div class="row mt-5 g-4">
        <div class="col-md-6">
            <div class="card shadow-sm p-4">
                <h5>Category Spending</h5>
                <canvas id="categoryChart" style="height:300px;"></canvas>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card shadow-sm p-4">
                <h5>Monthly Totals</h5>
                <canvas id="monthlyChart" style="height:300px;"></canvas>
            </div>
        </div>
    </div>

    <!-- Add/Edit Modal -->
    <div class="modal fade" id="transactionModal" tabindex="-1" aria-labelledby="transactionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content p-2">
                <div class="modal-header">
                    <h5 class="modal-title" id="transactionModalLabel">Add Transaction</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="hfEditId" runat="server" />
                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Title" />
                        <label for="txtTitle">Title</label>
                    </div>
                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" placeholder="Amount" />
                        <label for="txtAmount">Amount</label>
                    </div>
                    <div class="mb-3">
                        <label>Category</label>
                        <asp:DropDownList ID="ddlCategoryForm" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="form-floating mb-3">
    <asp:TextBox ID="txtTransactionDate" runat="server" CssClass="form-control" TextMode="Date" placeholder="Date" />
    <label for="txtTransactionDate">Date</label>
</div>

              <div class="mb-3">
    <label>Payment Method</label>
    <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="form-select"></asp:DropDownList>
</div>

                    <div class="mb-3">
                        <label>Type</label>
                        <asp:DropDownList ID="ddlType" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Income" Value="Income" />
                            <asp:ListItem Text="Expense" Value="Expense" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn btn-success rounded-pill px-4" />
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>

</div>

<script>
    // Open Modal
    function openModal() {
        var myModal = new bootstrap.Modal(document.getElementById('transactionModal'));
        myModal.show();

        // Auto-fill today's date in yyyy-MM-dd format
        var today = new Date().toISOString().split('T')[0];
        document.getElementById('<%= txtTransactionDate.ClientID %>').value = today;
    }

    // Animate Total Income/Expenses
    function animateCounter(id, target) {
        const element = document.getElementById(id);
        if (!element) return;

        let current = 0;
        const increment = target / 100; // 100 steps

        function update() {
            current += increment;
            if (current >= target) {
                element.innerText = target.toFixed(2);
                return;
            }
            element.innerText = current.toFixed(2);
            requestAnimationFrame(update);
        }

        update();
    }

    // Chart Enhancements
    Chart.defaults.elements.bar.borderRadius = 10;
    Chart.defaults.plugins.legend.labels.color = "#333";
    Chart.defaults.plugins.tooltip.backgroundColor = "#222";
    Chart.defaults.plugins.tooltip.titleColor = "#fff";
</script>

</asp:Content>
