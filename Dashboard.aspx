<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebApplication5.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>

        .tab-content > .tab-pane {
    opacity: 0;
    transform: scale(0.98);
    transition: all 0.5s ease;
}

.tab-content > .active {
    opacity: 1;
    transform: scale(1);
}
    .card, .card-box {
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        transition: all 0.3s ease;
    }

    .card:hover, .card-box:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.12);
    }

    .progress {
        background-color: #f1f5f9; /* light background for progress bar */
        border-radius: 20px;
        overflow: hidden;
    }

    .progress-bar {
        transition: width 0.6s ease;
    }

    .recent-transaction {
        padding: 10px 0;
        border-bottom: 1px solid #f1f5f9;
    }

    .recent-transaction:last-child {
        border-bottom: none;
    }

    .btn-outline-dark {
        border-radius: 8px;
    }
</style>
<style>
        .calendar-container {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 20px;
        }

        .calendar-summary {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 20px;
        }

        .activity-card {
            background: #fff;
            border-left: 4px solid #4f46e5;
            border-radius: 8px;
            padding: 10px 15px;
            margin-bottom: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .dot-income {
            background-color: #22c55e;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 4px;
        }

        .dot-expense {
            background-color: #ef4444;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 4px;
        }

        canvas {
    max-height: 160px !important;
}

    </style>


</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hdnActiveTab" runat="server" ClientIDMode="Static" />

<div class="d-flex align-items-center gap-3">
    <asp:Label ID="lblWelcome" runat="server" Font-Size="X-Large" Font-Bold="true" CssClass="mb-2" ClientIDMode="Static" />
    <span id="clock" style="font-size: 18px; color: #64748b;"></span>
</div>
    <!-- Spinner Loader -->
<div id="spinner" style="display:none; text-align:center; padding: 20px;">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<!-- Tabs -->
<ul class="nav nav-tabs mb-4" id="dashboardTabs" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" data-bs-target="#overview" type="button" role="tab" onclick="saveTab('overview')">Overview</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="analytics-tab" data-bs-toggle="tab" data-bs-target="#analytics" type="button" role="tab" onclick="saveTab('analytics')">Analytics</button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="calendar-tab" data-bs-toggle="tab" data-bs-target="#calendar" type="button" role="tab" onclick="saveTab('calendar')">Calendar</button>
    </li>
</ul>


<!-- Tab Content -->
<div class="tab-content" id="dashboardTabContent">

    <!-- OVERVIEW TAB -->
 <div class="tab-pane fade show active" id="overview" role="tabpanel">
    <!-- Cards Top Row: Balance, Income, Expenses, Savings -->
    <div class="row g-4">
        <div class="col-md-3 col-6">
            <div class="card p-3">
                <h6>Total Balance</h6>
                <div class="h4">
                    <asp:Label ID="lblTotalBalance" runat="server" />
                </div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="card p-3">
                <h6>Monthly Income</h6>
                <div class="h4">
                    <asp:Label ID="lblMonthlyIncome" runat="server" />
                </div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="card p-3">
                <h6>Monthly Expenses</h6>
                <div class="h4">
                    <asp:Label ID="lblMonthlyExpenses" runat="server" />
                </div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="card p-3">
                <h6>Savings Rate</h6>
                <div class="h4">
                    <asp:Label ID="lblSavingsRate" runat="server" />
                </div>
            </div>
        </div>
    </div>

    <!-- Upcoming Payments and Budget Overview -->
    <div class="row g-4 mt-4">
        <div class="col-md-6">
            <div class="card p-3">
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

        <div class="col-md-6">
            <div class="card p-3">
                <h5>Budget Overview</h5>
                <asp:Repeater ID="rptBudgetOverview" runat="server">
                    <ItemTemplate>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between">
                                <small><%# Eval("Category") %></small>
                                <small><%# String.Format("${0:0.00}", Eval("Total")) %></small>
                            </div>
                            <div class="progress" style="height: 6px;">
                                <div class="progress-bar bg-success" role="progressbar" style='width:<%# Eval("Progress") %>%'>
                                    <%# Eval("Progress") %>%
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

    <!-- Recent Transactions -->
    <div class="row g-4 mt-4">
        <div class="col-12">
            <div class="card p-3">
                <h5>Recent Transactions</h5>
                <asp:Repeater ID="rptTransactions" runat="server">
                    <ItemTemplate>
                        <div class="recent-transaction d-flex justify-content-between">
                            <span><%# Eval("Title") %></span>
                            <span class='<%# Convert.ToDecimal(Eval("Amount")) < 0 ? "text-danger" : "text-success" %>'>
                                <%# String.Format("{0:C}", Eval("Amount")) %>
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="text-center mt-3">
                    <a href="Transaction.aspx" class="btn btn-outline-dark">View All Transactions</a>
                </div>
            </div>
        </div>
    </div>

</div>

<div class="tab-pane fade" id="analytics" role="tabpanel">
        <div class="row g-4">
            <div class="col-md-8">
                <div class="card p-4">
                    <h5 class="mb-1">Monthly Spending Trends</h5>
                    <p class="text-muted">Your spending patterns over the past 6 months</p>
<canvas id="monthlyChart" style="height: 160px; max-height: 160px;"></canvas>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4">
                    <h5 class="mb-1">Spending by Category</h5>
                    <p class="text-muted">Breakdown of your expenses</p>
<canvas id="categoryChart" style="height: 160px; max-height: 250px;"></canvas>
                </div>
            </div>
        </div>

        <div class="row g-4 mt-2">
            <div class="col-md-6">
                <div class="card p-4">
                    <h5>Income vs. Expenses</h5>
                    <p class="text-muted">Monthly comparison</p>
<canvas id="incomeExpenseChart" style="height: 160px; max-height: 160px;"></canvas>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card p-4">
                    <h5>Savings Growth</h5>
                    <p class="text-muted">Progress towards your goals</p>
<canvas id="savingsChart" style="height: 160px; max-height: 160px;"></canvas>
                </div>
            </div>
        </div>

        <div class="row g-4 mt-2">
            <div class="col-md-12">
                <div class="card p-4">
                    <h5>Spending Insights</h5>
                    <p class="text-muted">Key observations from your data</p>
                    <ul class="list-unstyled">
                        <li><span class="text-success">🡅 Savings rate increased:</span> Your savings rate is up 4.5% from last month</li>
                        <li><span class="text-danger">🍽 Dining expenses:</span> Dining out expenses increased by 12% this month</li>
                        <li><span class="text-primary">🔍 Unusual activity:</span> Large transaction detected in Entertainment category</li>
                    </ul>
                </div>
            </div>
        </div>
</div>


    <!-- CALENDAR TAB -->
<div class="tab-pane fade" id="calendar" role="tabpanel">

         <div class="row g-4">
            <!-- Calendar Column -->
            <div class="col-md-6">
                <div class="calendar-container">
                    <h5>Financial Calendar</h5>
             <asp:Calendar 
    ID="Calendar1" 
    runat="server" 
    OnDayRender="Calendar1_DayRender" 
    OnSelectionChanged="Calendar1_SelectionChanged"
    CssClass="table table-bordered w-100"
    FirstDayOfWeek="Sunday" 
    NextPrevFormat="ShortMonth" />

                    <div class="mt-3">
                        <span class="dot-income"></span> Income
                        <span class="dot-expense ms-3"></span> Expense
                    </div>
                </div>
            </div>

            <!-- Summary Column -->
            <div class="col-md-6">
                <div class="calendar-summary">
                    <h5>Transactions: <asp:Label ID="lblSelectedDate" runat="server" Text="(Click a date)"></asp:Label></h5>
                    <div class="d-flex justify-content-between mt-3">
                        <div><strong>Income:</strong> <span class="text-success"><asp:Label ID="lblIncomeTotal" runat="server" Text="$0.00"></asp:Label></span></div>
                        <div><strong>Expenses:</strong> <span class="text-danger"><asp:Label ID="lblExpenseTotal" runat="server" Text="$0.00"></asp:Label></span></div>
                        <div><strong>Net:</strong> <span class="fw-bold"><asp:Label ID="lblNetTotal" runat="server" Text="$0.00"></asp:Label></span></div>
                    </div>
                    <hr />
                    <asp:Repeater ID="rptActivities" runat="server">
                        <ItemTemplate>
                            <div class="activity-card d-flex justify-content-between">
                                <div>
                                    <%# Eval("Title") %><br />
                                    <small class="text-muted"><%# Eval("Type") %></small>
                                </div>
                                <div class='<%# Eval("Type").ToString() == "Income" ? "text-success" : "text-danger" %>'>
                                    <%# String.Format("{0:C}", Eval("Amount")) %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </div>

</div>
    <script>
document.addEventListener('DOMContentLoaded', function() {
    var tabs = document.querySelectorAll('.nav-link');

    tabs.forEach(function(tab) {
        tab.addEventListener('click', function () {
            // Show the spinner
            document.getElementById('spinner').style.display = 'block';

            // Hide tab-content temporarily
            document.getElementById('dashboardTabContent').style.display = 'none';

            // After a short delay (simulate loading)
            setTimeout(function() {
                document.getElementById('spinner').style.display = 'none';
                document.getElementById('dashboardTabContent').style.display = 'block';
            }, 400); // 400ms delay
        });
    });
});
    </script>
    <script>
        function updateClock() {
            var now = new Date();
            var hours = now.getHours();
            var minutes = now.getMinutes();
            var seconds = now.getSeconds();

            // Format to always show 2 digits
            hours = hours < 10 ? "0" + hours : hours;
            minutes = minutes < 10 ? "0" + minutes : minutes;
            seconds = seconds < 10 ? "0" + seconds : seconds;

            var timeString = hours + ":" + minutes + ":" + seconds;
            document.getElementById('clock').textContent = timeString;
        }

        // Update every 1 second
        setInterval(updateClock, 1000);

        // Initialize clock immediately on page load
        updateClock();
    </script>
    <script>
        function saveTab(tabName) {
            document.getElementById('hdnActiveTab').value = tabName;
        }

        document.addEventListener('DOMContentLoaded', function () {
            var activeTab = document.getElementById('hdnActiveTab').value;
            if (activeTab) {
                var tabButton = document.querySelector('[data-bs-target="#' + activeTab + '"]');
                var tabPane = document.getElementById(activeTab);

                if (tabButton && tabPane) {
                    // Remove active from others
                    document.querySelectorAll('.nav-link').forEach(btn => btn.classList.remove('active'));
                    document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.remove('show', 'active'));

                    // Activate selected
                    tabButton.classList.add('active');
                    tabPane.classList.add('show', 'active');
                }
            }
        });
    </script>

</asp:Content>
