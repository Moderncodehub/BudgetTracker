<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="WebApplication5.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        .sidebar {
            height: 100vh;
            background: #fff;
            border-right: 1px solid #ddd;
        }

        .sidebar a {
            display: block;
            padding: 15px 20px;
            color: #333;
            text-decoration: none;
            font-weight: 500;
        }

        .sidebar a.active {
            background-color: #f1f1f1;
        }

        .content {
            padding: 30px;
        }

        .card {
            border-radius: 10px;
            border: none;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .card h5 {
            font-weight: 600;
        }

        .progress {
            height: 8px;
            background-color: #eee;
        }

        .progress-bar {
            background-color: #333;
        }

        .transaction-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }

        .transaction-item:last-child {
            border-bottom: none;
        }
    </style>

    <div class="d-flex">
        <!-- Sidebar -->
        <div class="sidebar p-3" style="width: 220px;">
            <h4 class="mb-4">BudgetTracker</h4>
            <a href="#" class="active">Dashboard</a>
            <a href="#">Transactions</a>
            <a href="#">Reminders</a>
            <a href="#">Savings</a>
            <a href="#">Reports</a>
            <a href="#">Settings</a>
        </div>

        <!-- Main Content -->
        <div class="content w-100">
            <div class="d-flex justify-content-between mb-4">
                <h2>Dashboard</h2>
                <div>
                    <button class="btn btn-outline-secondary">Export</button>
                    <button class="btn btn-dark">+ Add Expense</button>
                </div>
            </div>

            <!-- Top Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card p-3">
                        <h5>Total Balance</h5>
                        <p>$0.00</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card p-3">
                        <h5>Monthly Income</h5>
                        <p>$0.00</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card p-3">
                        <h5>Monthly Expenses</h5>
                        <p>$0.00</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card p-3">
                        <h5>Savings Rate</h5>
                        <p>0%</p>
                    </div>
                </div>
            </div>

            <!-- Budget Overview -->
            <div class="row mb-4">
                <div class="col-md-8">
                    <div class="card p-3">
                        <h5>Budget Overview</h5>
                        <p class="mb-1">Housing</p>
                        <div class="progress mb-3">
                            <div class="progress-bar" style="width: 0%"></div>
                        </div>
                        <p class="mb-1">Food & Dining</p>
                        <div class="progress mb-3">
                            <div class="progress-bar" style="width: 0%"></div>
                        </div>
                        <p class="mb-1">Transportation</p>
                        <div class="progress mb-3">
                            <div class="progress-bar" style="width: 0%"></div>
                        </div>
                        <p class="mb-1">Entertainment</p>
                        <div class="progress mb-3">
                            <div class="progress-bar" style="width: 0%"></div>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Payments -->
                <div class="col-md-4">
                    <div class="card p-3">
                        <h5>Upcoming Payments</h5>
                        <ul class="list-unstyled">
                            <li class="mb-2">Rent - $0.00</li>
                            <li class="mb-2">Internet - $0.00</li>
                            <li class="mb-2">Phone - $0.00</li>
                            <li>Credit Card - $0.00</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Recent Transactions -->
            <div class="card p-3">
                <h5>Recent Transactions</h5>
                <div class="transaction-item">
                    <span>Grocery Store</span>
                    <span>$0.00</span>
                </div>
                <div class="transaction-item">
                    <span>Rent Payment</span>
                    <span>$0.00</span>
                </div>
                <a href="#" class="mt-3 d-block text-end text-decoration-none">View All Transactions</a>
            </div>
        </div>
    </div>

</asp:Content>
