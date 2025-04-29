<%@ Page Title="Savings" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="Savings.aspx.cs" Inherits="WebApplication5.Savings" %>

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

        .btn-add {
            background-color: #000;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 8px;
        }

        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
        }

        .tab-button {
            padding: 6px 16px;
            border-radius: 8px;
            border: none;
            background-color: #eee;
            font-weight: 500;
        }

        .tab-button.active {
            background-color: #000;
            color: white;
        }

        .goal-card {
            background-color: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }

        .progress {
            height: 8px;
            background-color: #eee;
        }

        .progress-bar {
            background-color: #333;
        }

        .add-funds-btn {
            background: none;
            border: none;
            color: #000;
            font-weight: 500;
            text-decoration: underline;
            margin-top: 10px;
        }

        .overview-card {
            background-color: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            margin-top: 30px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Sidebar -->
    <div class="sidebar">
        <h4>BudgetTracker</h4>
        <a href="Dashboard.aspx">Dashboard</a>
        <a href="Transaction.aspx">Transactions</a>
        <a href="Reminders.aspx">Reminders</a>
        <a href="Savings.aspx" class="active">Savings</a>
        <a href="Reports.aspx">Reports</a>
        <a href="#">Settings</a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Topbar -->
        <div class="topbar">
            <h3>Savings Goals</h3>
            <button class="btn-add">+ Add Goal</button>
        </div>

        <!-- Tabs -->
        <div class="tabs">
            <button class="tab-button active">Savings Goals</button>
            <button class="tab-button">Savings History</button>
        </div>

        <!-- Goals List -->
        <div class="row">
            <div class="col-md-6">
                <div class="goal-card">
                    <h5>Emergency Fund</h5>
                    <p>Target: $10,000</p>
                    <p>Progress</p>
                    <div class="progress mb-2">
                        <div class="progress-bar" style="width:56%"></div>
                    </div>
                    <div class="d-flex justify-content-between">
                        <small>56% Complete</small>
                        <small>Deadline: Dec 31, 2025</small>
                    </div>
                    <button class="add-funds-btn">Add Funds →</button>
                </div>
            </div>
            <div class="col-md-6">
                <div class="goal-card">
                    <h5>Vacation</h5>
                    <p>Target: $3,000</p>
                    <p>Progress</p>
                    <div class="progress mb-2">
                        <div class="progress-bar" style="width:40%"></div>
                    </div>
                    <div class="d-flex justify-content-between">
                        <small>40% Complete</small>
                        <small>Deadline: Jul 15, 2025</small>
                    </div>
                    <button class="add-funds-btn">Add Funds →</button>
                </div>
            </div>
            <div class="col-md-6">
                <div class="goal-card">
                    <h5>New Laptop</h5>
                    <p>Target: $1,500</p>
                    <p>Progress</p>
                    <div class="progress mb-2">
                        <div class="progress-bar" style="width:60%"></div>
                    </div>
                    <div class="d-flex justify-content-between">
                        <small>60% Complete</small>
                        <small>Deadline: Sep 1, 2025</small>
                    </div>
                    <button class="add-funds-btn">Add Funds →</button>
                </div>
            </div>
            <div class="col-md-6">
                <div class="goal-card">
                    <h5>Home Down Payment</h5>
                    <p>Target: $50,000</p>
                    <p>Progress</p>
                    <div class="progress mb-2">
                        <div class="progress-bar" style="width:25%"></div>
                    </div>
                    <div class="d-flex justify-content-between">
                        <small>25% Complete</small>
                        <small>Deadline: Dec 31, 2027</small>
                    </div>
                    <button class="add-funds-btn">Add Funds →</button>
                </div>
            </div>
        </div>

        <!-- Savings Overview -->
        <div class="overview-card">
            <h5>Savings Overview</h5>
            <p class="text-muted">Your total savings across all goals</p>
            <div class="d-flex justify-content-between">
                <div>
                    <p class="fw-bold mb-1">Total Saved</p>
                    <p>$20,200</p>
                </div>
                <div>
                    <p class="fw-bold mb-1">Total Goals</p>
                    <p>$64,500</p>
                </div>
            </div>
            <div class="progress mt-3">
                <div class="progress-bar" style="width:31%"></div>
            </div>
            <p class="text-muted text-end mt-1">31% of total goals achieved</p>
        </div>

    </div>

</asp:Content>
