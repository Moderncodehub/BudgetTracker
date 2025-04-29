<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="WebApplication5.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9f9f9;
        }
        .sidebar {
            height: 100vh;
            width: 220px;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #ffffff;
            border-right: 1px solid #ddd;
            padding-top: 20px;
        }
        .sidebar h4 {
            padding-left: 20px;
            font-weight: bold;
            margin-bottom: 30px;
        }
        .sidebar a {
            display: block;
            padding: 12px 20px;
            color: #333;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 8px;
        }
        .sidebar a.active {
            background-color: #f1f1f1;
            border-radius: 8px;
        }
        .main-content {
            margin-left: 220px;
            padding: 30px;
        }
        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .btn-export, .btn-filter {
            background-color: #f1f1f1;
            border: none;
            padding: 8px 15px;
            border-radius: 8px;
            margin-left: 10px;
            font-weight: 500;
        }
        .dropdown-select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: #fff;
            margin-left: 10px;
        }
        .card-report {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .report-title {
            font-size: 16px;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Sidebar -->
    <div class="sidebar">
        <h4>BudgetTracker</h4>
        <a href="AdminDashboardBud.aspx">Dashboard</a>
        <a href="Transactions.aspx">Transactions</a>
        <a href="Reminders.aspx">Reminders</a>
        <a href="Savings.aspx">Savings</a>
        <a href="#" class="active">Reports</a>
        <a href="#">Settings</a>
    </div>

    <!-- Main Content -->
    <div class="main-content">

        <!-- Top Header -->
        <div class="topbar">
            <h3>Financial Reports</h3>
            <div class="d-flex">
                <button class="btn btn-light">Pick a date</button>
                <select class="dropdown-select" id="ddlPeriod" runat="server">
                    <option>This Month</option>
                    <option>Last Month</option>
                    <option>This Year</option>
                    <option>All Time</option>
                </select>
                <button class="btn-export"><i class="fa-solid fa-download"></i> Export</button>
                <button class="btn-filter"><i class="fa-solid fa-filter"></i> Filter Reports</button>
            </div>
        </div>

        <!-- Reports Summary -->
        <div class="row mb-4">
            <div class="col-md-3 col-6">
                <div class="card-report text-center">
                    <div class="report-title">Total Spending</div>
                    <h4><asp:Label ID="lblTotalSpending" runat="server" Text="$0.00"></asp:Label></h4>
                    <small class="text-success">Compared to last month</small>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card-report text-center">
                    <div class="report-title">Total Income</div>
                    <h4><asp:Label ID="lblTotalIncome" runat="server" Text="$0.00"></asp:Label></h4>
                    <small class="text-success">Compared to last month</small>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card-report text-center">
                    <div class="report-title">Total Transactions</div>
                    <h4><asp:Label ID="lblTotalTransactions" runat="server" Text="0"></asp:Label></h4>
                    <small>Transactions recorded</small>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="card-report text-center">
                    <div class="report-title">Net Balance</div>
                    <h4><asp:Label ID="lblNetBalance" runat="server" Text="$0.00"></asp:Label></h4>
                    <small class="text-primary">Income - Expenses</small>
                </div>
            </div>

            <div class="summary-card">
    Net Balance
    <div class="summary-value">
        <asp:Label ID="Label1" runat="server" />
    </div>
</div>

        </div>

        <!-- Chart Cards Placeholder -->
        <div class="row">
            <div class="col-md-6">
                <div class="card-report text-center" style="height:300px;">
                    <h5>Spending by Category</h5>
                    <p class="text-muted">Chart coming soon</p>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card-report text-center" style="height:300px;">
                    <h5>Income Over Time</h5>
                    <p class="text-muted">Chart coming soon</p>
                </div>
            </div>
        </div>

    </div>

</asp:Content>
