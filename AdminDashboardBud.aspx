<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="AdminDashboardBud.aspx.cs" Inherits="WebApplication5.AdminDashboardBud" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

<style>
    :root {
        --bg-light: #f8f9fa;
        --text-dark: #1f2937;
        --text-muted: #6b7280;
        --accent: #4f46e5;
        --accent-light: #818cf8;
        --success: #22c55e;
        --danger: #ef4444;
        --radius: 12px;
        --shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
        --font: 'Poppins', sans-serif;
    }

    body {
        font-family: var(--font);
        background: var(--bg-light);
        color: var(--text-dark);
        margin: 0;
    }

    .topbar {
        background: var(--accent);
        padding: 16px 32px;
        color: #fff;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: var(--shadow);
    }

    .topbar h4 {
        font-size: 24px;
        font-weight: 700;
        margin: 0;
    }

    .btn {
        font-weight: 600;
        border-radius: 8px;
    }

    .summary-card, .card-box {
        background: #ffffff;
        border-radius: var(--radius);
        box-shadow: var(--shadow);
        padding: 20px;
        transition: transform 0.3s ease;
    }

    .summary-card:hover, .card-box:hover {
        transform: translateY(-5px);
    }

    .summary-card h6 {
        font-size: 14px;
        color: var(--text-muted);
        margin-bottom: 8px;
    }

    .amount {
        font-size: 24px;
        font-weight: 700;
        color: var(--text-dark);
    }

    .activity-card {
        background: #fff;
        padding: 16px;
        border-left: 4px solid var(--accent);
        border-radius: var(--radius);
        box-shadow: var(--shadow);
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;
    }

    .activity-title {
        font-weight: 600;
        font-size: 16px;
        color: var(--text-dark);
    }

    .activity-amount {
        font-size: 18px;
        font-weight: bold;
    }

    .income {
        color: var(--success);
    }

    .expense {
        color: var(--danger);
    }

    .custom-modern-calendar {
        background: #fff;
        border-radius: var(--radius);
        padding: 20px;
        margin-top: 32px;
        box-shadow: var(--shadow);
    }

    .custom-modern-calendar td, .custom-modern-calendar th {
        padding: 12px;
        text-align: center;
        border-radius: 8px;
        transition: all 0.2s ease;
    }

    .custom-modern-calendar td:hover {
        background: var(--accent);
        color: white;
        transform: scale(1.05);
    }

    .custom-modern-calendar .TodayDay {
        background: #fde68a;
        color: #000;
        font-weight: bold;
        border-radius: 50%;
    }

    .custom-modern-calendar .SelectedDay {
        background: var(--accent-light);
        color: #fff;
        font-weight: bold;
        border-radius: 50%;
        transform: scale(1.2);
    }

    .recent-transaction {
        background: #fff;
        padding: 14px 20px;
        border-radius: var(--radius);
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: var(--shadow);
        margin-bottom: 10px;
    }

    .progress-container {
        background: #e5e7eb;
        border-radius: 6px;
        height: 8px;
    }

    .progress-bar-black {
        height: 8px;
        border-radius: 6px;
        background: linear-gradient(to right, #6366f1, #4f46e5);
    }

    .btn-outline-dark {
        border-color: var(--accent);
        color: var(--accent);
    }

    .btn-outline-dark:hover {
        background: var(--accent);
        color: #fff;
    }

    .modal-content {
        border-radius: var(--radius);
        box-shadow: var(--shadow);
    }

    .modal-header {
        background: var(--accent);
        color: white;
        border-top-left-radius: var(--radius);
        border-top-right-radius: var(--radius);
    }

    .dot-income, .dot-expense {
        width: 8px;
        height: 8px;
        display: inline-block;
        border-radius: 50%;
        margin: 2px;
    }

    .dot-income {
        background: var(--success);
    }

    .dot-expense {
        background: var(--danger);
    }

    .hover-container {
        position: relative;
        cursor: pointer;
    }

    .hover-popup {
        position: absolute;
        background: #fff;
        border: 1px solid #ddd;
        padding: 8px;
        font-size: 12px;
        border-radius: 6px;
        white-space: nowrap;
        z-index: 10;
        box-shadow: var(--shadow);
        display: none;
        top: 100%;
        left: 50%;
        transform: translateX(-50%);
    }

    .hover-container:hover .hover-popup {
        display: block;
    }

    .calendar-day-btn:hover {
        background: var(--accent);
        color: white;
        transform: scale(1.2);
    }
</style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div class="topbar">
    <h4>Dashboard</h4>
    <div>
        <button type="button" class="btn btn-light" data-bs-toggle="modal" data-bs-target="#addExpenseModal">+ Add Expense</button>
        <asp:Button ID="btnExport" runat="server" CssClass="btn btn-outline-light ms-2" Text="Export" />
    </div>
</div>

<div class="container py-4">
    <asp:Label ID="lblWelcome" runat="server" Font-Size="X-Large" Font-Bold="true" CssClass="mb-4 d-block" />

    <div class="row g-4">
        <div class="col-md-3 col-6"><div class="summary-card"><h6>Total Balance</h6><div id="lblTotalBalance" class="amount"><asp:Label ID="lblTotalBalance" runat="server" ClientIDMode="Static" /></div></div></div>
        <div class="col-md-3 col-6"><div class="summary-card"><h6>Monthly Income</h6><div id="lblMonthlyIncome" class="amount"><asp:Label ID="lblMonthlyIncome" runat="server" ClientIDMode="Static" /></div></div></div>
        <div class="col-md-3 col-6"><div class="summary-card"><h6>Monthly Expenses</h6><div id="lblMonthlyExpenses" class="amount"><asp:Label ID="lblMonthlyExpenses" runat="server" ClientIDMode="Static" /></div></div></div>
        <div class="col-md-3 col-6"><div class="summary-card"><h6>Savings Rate</h6><div class="amount"><asp:Label ID="lblSavingsRate" runat="server" /></div></div></div>
    </div>

    <div class="row g-4 mt-4">
    <div class="col-md-4"><div class="card-box"><h5>Category Breakdown</h5><canvas id="categoryChart" height="250"></canvas></div></div>
    <div class="col-md-4"><div class="card-box"><h5>Monthly Totals</h5><canvas id="monthlyChart" height="250"></canvas></div></div>
    <div class="col-md-4"><div class="card-box"><h5>Payment Methods</h5><canvas id="paymentChart" height="250"></canvas></div></div>
</div>
    <div class="row g-4 mt-4">
        <div class="col-md-8">
            <div class="card-box">
                <h5>Budget Overview</h5>
                <asp:Repeater ID="rptBudgetOverview" runat="server">
                    <ItemTemplate>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between">
                                <small><%# Eval("Category") %></small>
                                <small><%# String.Format("${0:0.00}", Eval("Total")) %></small>
                            </div>
                            <div class="progress-container">
                                <div class="progress-bar-black" style='width: <%# Eval("Progress") %>%'></div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card-box">
                <h5>Upcoming Payments</h5>
                <asp:Repeater ID="rptUpcomingPayments" runat="server">
                    <ItemTemplate>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div class="d-flex align-items-center gap-2">
                                <i class='<%# Eval("IconClass") %>'></i>
                                <span><%# Eval("Title") %></span>
                            </div>
                            <div class="fw-bold"><%# String.Format("${0:0.00}", Eval("Amount")) %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

     
<asp:Calendar 
    ID="calActivities" 
    runat="server"
    CssClass="custom-modern-calendar"
    OnDayRender="calActivities_DayRender"
    OnSelectionChanged="calActivities_SelectionChanged"
    NextPrevFormat="ShortMonth"
    FirstDayOfWeek="Sunday" />




    <div class="activities-container mt-4">
        <h6 class="mb-3">Activities on <asp:Label ID="lblSelectedDate" runat="server" Text=""></asp:Label>:</h6>
        
        <asp:Repeater ID="rptActivities" runat="server">
            <ItemTemplate>
                <div class="activity-card">
                    <div class="activity-title">
                        <%# Eval("Title") %> 
                        <small class="activity-type">
                            (<%# Eval("Type") %>)
                        </small>
                    </div>
                    <div class="activity-amount" style='<%# Eval("Type").ToString() == "Income" ? "color:#28a745;" : "color:#dc3545;" %>'>
                        <%# Eval("Type").ToString() == "Income" ? "+" : "-" %>$
                        <%# Convert.ToDecimal(Eval("Amount")).ToString("N2") %>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
 
    <div class="mt-5">
        <h5>Recent Transactions</h5>
        <asp:Repeater ID="rptTransactions" runat="server">
            <ItemTemplate>
                <div class="recent-transaction">
                    <span><%# Eval("Title") %></span>
                    <span class='<%# Convert.ToDecimal(Eval("Amount")) < 0 ? "expense" : "income" %>'><%# String.Format("{0:C}", Eval("Amount")) %></span>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <div class="text-center mt-3"><a href="Transaction.aspx" class="btn btn-outline-dark">View All Transactions</a></div>
    </div>
 
<!-- Add Expense Modal -->
<div class="modal fade" id="addExpenseModal" tabindex="-1" aria-labelledby="addExpenseModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addExpenseModalLabel">Add New Expense</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control mb-2" placeholder="Title" />
        <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control mb-2" placeholder="Amount" />
      </div>
      <div class="modal-footer">
        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSave_Click" />
      </div>
    </div>
  </div>
</div>

 
    <script>
        window.addEventListener('load', function () {
            var calendar = document.querySelector('.calendar-wrapper');

            // Smooth sliding effect already added
            var links = document.querySelectorAll('.custom-modern-calendar a');

            links.forEach(function (link) {
                link.addEventListener('click', function () {
                    calendar.classList.add('slide-out');

                    setTimeout(function () {
                        calendar.classList.remove('slide-out');
                        calendar.classList.add('slide-in');

                        setTimeout(function () {
                            calendar.classList.remove('slide-in');
                        }, 500);
                    }, 500);
                });
            });

            // When date is clicked, scroll to activities
            var days = document.querySelectorAll('.hover-container');

            days.forEach(function (day) {
                day.addEventListener('click', function () {
                    var activitiesSection = document.querySelector('.activities-section');
                    if (activitiesSection) {
                        activitiesSection.scrollIntoView({ behavior: 'smooth' });
                    }
                });
            });
        });
    </script>

</asp:Content>