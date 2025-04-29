<%@ Page Title="Financial Reports" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="FinancialReports.aspx.cs" Inherits="WebApplication5.FinancialReports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .card { margin-bottom: 20px; }
        .amount-income { color: green; }
        .amount-expense { color: red; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Financial Overview Summary (Professional Clean Layout) -->
<div class="card p-4 mb-5 shadow-sm">
    <h3 class="mb-4 text-center">Financial Overview</h3>

    <!-- Monthly Summary -->
    <h5 class="mb-3">This Month</h5>
    <div class="row text-center">
        <div class="col-md-4 mb-3">
            <div class="border rounded p-3 bg-light">
                <h6>Income</h6>
                <h4 class="text-success"><span id="lblMonthlyIncome" runat="server"></span></h4>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="border rounded p-3 bg-light">
                <h6>Expense</h6>
                <h4 class="text-danger"><span id="lblMonthlyExpense" runat="server"></span></h4>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="border rounded p-3 bg-light">
                <h6>Savings</h6>
                <h4 class="text-primary"><span id="lblMonthlySavings" runat="server"></span></h4>
            </div>
        </div>
    </div>

    <hr />

    <!-- Weekly Summary -->
    <h5 class="mb-3">This Week</h5>
    <div class="row text-center">
        <div class="col-md-4 mb-3">
            <div class="border rounded p-3 bg-light">
                <h6>Income</h6>
                <h4 class="text-success"><span id="lblWeeklyIncome" runat="server"></span></h4>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="border rounded p-3 bg-light">
                <h6>Expense</h6>
                <h4 class="text-danger"><span id="lblWeeklyExpense" runat="server"></span></h4>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="border rounded p-3 bg-light">
                <h6>Savings</h6>
                <h4 class="text-primary"><span id="lblWeeklySavings" runat="server"></span></h4>
            </div>
        </div>
    </div>

    <hr />

    <!-- Overall Summary -->
    <h5 class="mb-3">Overall Summary</h5>
    <div class="row text-center">
        <div class="col-md-3 mb-3">
            <div class="border rounded p-3">
                <h6>Total Income</h6>
                <h4 class="text-success"><span id="lblIncome" runat="server"></span></h4>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="border rounded p-3">
                <h6>Total Expenses</h6>
                <h4 class="text-danger"><span id="lblExpense" runat="server"></span></h4>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="border rounded p-3">
                <h6>Total Savings</h6>
                <h4 class="text-primary"><span id="lblTotalSavings" runat="server"></span></h4>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="border rounded p-3">
                <h6>Final Balance</h6>
                <h4 class="text-primary"><span id="lblFinalBalance" runat="server"></span></h4>
            </div>
        </div>
    </div>

    <hr />

    <!-- Average Monthly Savings -->
    <div class="row text-center">
        <div class="col-md-12">
            <div class="border rounded p-3 bg-light">
                <h5>Average Monthly Savings</h5>
                <h3 class="text-primary"><span id="lblAverageSavings" runat="server"></span></h3>
            </div>
        </div>
    </div>

</div>



<div class="container mt-4">
    <h2 class="mb-4 text-center">Financial Reports</h2>

    <!-- New Transaction Form -->
    <div class="card p-4 mb-4">
        <h4>Add New Transaction</h4>
        <div class="row g-3">
            <div class="col-md-4">
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Title"></asp:TextBox>
            </div>
            <div class="col-md-2">
                <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" placeholder="Amount"></asp:TextBox>
            </div>
            <div class="col-md-2">
                <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Income" Value="Income"></asp:ListItem>
                    <asp:ListItem Text="Expense" Value="Expense"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-2">
                <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control" placeholder="Category"></asp:TextBox>
            </div>
            <div class="col-md-2">
                <asp:TextBox ID="txtPaymentMethod" runat="server" CssClass="form-control" placeholder="Payment Method"></asp:TextBox>
            </div>
        </div>
        <div class="mt-3">
            <asp:Button ID="btnAddTransaction" runat="server" Text="Add Transaction" CssClass="btn btn-success" OnClick="btnAddTransaction_Click" />
        </div>
    </div>

    <!-- Filter -->
<!-- Custom Report Filter -->

    <!-- Custom Report Filter (Stylish) -->
<div class="card p-4 mb-5 shadow-sm">
    <h4 class="mb-4 text-center">Custom Report Filter</h4>

    <div class="row g-3 mb-3">
        <div class="col-md-3">
            <label class="form-label fw-bold">Title</label>
            <asp:DropDownList ID="ddlTitleFilter" runat="server" CssClass="form-control">
                <asp:ListItem Text="Select Title" Value="" />
            </asp:DropDownList>
        </div>
        <div class="col-md-3">
            <label class="form-label fw-bold">Category</label>
            <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-control">
                <asp:ListItem Text="Select Category" Value="" />
            </asp:DropDownList>
        </div>
        <div class="col-md-3">
            <label class="form-label fw-bold">Payment Method</label>
            <asp:DropDownList ID="ddlPaymentMethodFilter" runat="server" CssClass="form-control">
                <asp:ListItem Text="All Payment Methods" Value="" />
                <asp:ListItem Text="Debit" Value="Debit" />
                <asp:ListItem Text="Credit Card" Value="Credit Card" />
                <asp:ListItem Text="Cash" Value="Cash" />
            </asp:DropDownList>
        </div>
        <div class="col-md-3">
            <label class="form-label fw-bold">Type</label>
            <asp:DropDownList ID="ddlTypeFilter" runat="server" CssClass="form-control">
                <asp:ListItem Text="All Types" Value="" />
                <asp:ListItem Text="Income" Value="Income" />
                <asp:ListItem Text="Expense" Value="Expense" />
            </asp:DropDownList>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <label class="form-label fw-bold">Start Date</label>
            <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
        </div>
        <div class="col-md-4">
            <label class="form-label fw-bold">End Date</label>
            <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
        </div>
        <div class="col-md-4 d-flex align-items-end">
            <asp:Button ID="btnFilter" runat="server" Text="Apply Filter" CssClass="btn btn-primary w-100" OnClick="btnFilter_Click" />
        </div>
    </div>

    <div class="text-center">
        <asp:Button ID="btnExportExcel" runat="server" Text="Export to Excel" CssClass="btn btn-success px-5" OnClick="btnExportExcel_Click" />
    </div>
</div>

<!-- Top 5 Sections -->
<div class="row mb-4">
    <div class="col-md-6">
        <div class="card p-3">
            <h5>Top 5 Expenses</h5>
            <asp:Repeater ID="rptTopExpenses" runat="server">
                <ItemTemplate>
                    <div><strong><%# Eval("Title") %></strong>: <%# String.Format("{0:C}", Eval("Amount")) %></div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
    <div class="col-md-6"> 
        <div class="card p-3">
            <h5>Top 5 Incomes</h5>
            <asp:Repeater ID="rptTopIncomes" runat="server">
                <ItemTemplate>
                    <div><strong><%# Eval("Title") %></strong>: <%# String.Format("{0:C}", Eval("Amount")) %></div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</div>


    

<!-- Pie Chart (smaller size) -->
<div class="card p-4 mb-4 text-center">
    <div style="max-width: 400px; margin: auto;">
        <canvas id="pieChart"></canvas>
    </div>
</div>


    <!-- Report Table -->
   <asp:GridView ID="gvReports" runat="server" CssClass="table table-bordered"
    AutoGenerateColumns="False" AllowPaging="true" PageSize="10"
    OnPageIndexChanging="gvReports_PageIndexChanging">
    <Columns>
        <asp:BoundField DataField="Title" HeaderText="Title" />
        <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="{0:C}" />
        <asp:BoundField DataField="Type" HeaderText="Type" />
        <asp:BoundField DataField="Category" HeaderText="Category" />
        <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" />
        <asp:BoundField DataField="CreatedAt" HeaderText="Date" DataFormatString="{0:MMM d, yyyy}" />
    </Columns>
</asp:GridView>

</div>

<script>
    function drawPieChart(income, expense) {
        const ctx = document.getElementById('pieChart').getContext('2d');
        const total = income + expense;
        const incomePercent = ((income / total) * 100).toFixed(1);
        const expensePercent = ((expense / total) * 100).toFixed(1);

        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: [`Income ${incomePercent}%`, `Expense ${expensePercent}%`],
                datasets: [{
                    data: [income, expense],
                    backgroundColor: ['green', 'red']
                }]
            },
            options: {
                responsive: true
            }
        });
    }
</script>


</asp:Content>
