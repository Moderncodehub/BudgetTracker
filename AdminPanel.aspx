<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminPanel.aspx.cs" Inherits="WebApplication5.AdminPanel" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <style>
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: #0d1117;
            color: #c9d1d9;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            background: #161b22;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            padding: 30px 15px;
            display: flex;
            flex-direction: column;
            gap: 20px;
            box-shadow: 2px 0 5px rgba(0,0,0,0.5);
        }
        .sidebar h3 {
            font-size: 24px;
            font-weight: bold;
            color: #58a6ff;
            margin-bottom: 30px;
            text-align: center;
        }
        .sidebar a {
            display: flex;
            align-items: center;
            color: #c9d1d9;
            text-decoration: none;
            padding: 12px;
            border-radius: 10px;
            transition: background 0.3s;
            font-weight: 500;
        }
        .sidebar a:hover {
            background: #21262d;
        }

        /* Main Content */
     .main-content {
    margin-left: 250px; /* same as sidebar width */
    padding: 40px;
}

        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .card {
            background: #161b22;
            padding: 30px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            background: #21262d;
        }
        .card h3 {
            font-size: 20px;
            color: #58a6ff;
            margin-bottom: 10px;
        }
        .card p {
            font-size: 28px;
            font-weight: bold;
            color: #8b949e;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .section-header h2 {
            font-size: 24px;
            color: #58a6ff;
        }

        .search-add input {
            padding: 10px;
            width: 250px;
            background: #0d1117;
            border: 1px solid #30363d;
            border-radius: 8px;
            color: #c9d1d9;
        }
        .search-add button {
            padding: 10px 20px;
            background: #238636;
            border: none;
            color: white;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }
        .search-add button:hover {
            background: #2ea043;
        }

        /* User Table */
        .user-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .user-table th, .user-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #30363d;
        }
        .user-table th {
            background: #21262d;
            color: #8b949e;
        }
        .user-table td {
            background: #0d1117;
        }

        /* Modal */
        .modal-popup {
            position: fixed;
            top: 0;
            left: 0;
            background: rgba(0,0,0,0.7);
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 999;
        }
        .modal-content-modern {
            background: #161b22;
            padding: 40px;
            border-radius: 20px;
            width: 400px;
            color: #c9d1d9;
            box-shadow: 0px 8px 24px rgba(0,0,0,0.4);
            text-align: center;
        }
        .modern-textbox {
            width: 100%;
            padding: 12px;
            background: #0d1117;
            border: 1px solid #30363d;
            color: #c9d1d9;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .btn-save {
            background: #238636;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            color: white;
            font-weight: bold;
            margin-right: 10px;
            cursor: pointer;
        }
        .btn-cancel {
            background: #da3633;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

     .container {
    display: flex;
    flex-direction: row;
    padding: 30px;
    gap: 30px;
    margin-left: 250px; /* Add this to match the sidebar width */
}


        .left-panel, .right-panel {
            background: #fff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .left-panel {
            flex: 2;
        }

        .right-panel {
            flex: 1;
        }

        h2 {
            font-size: 20px;
            margin-bottom: 20px;
            color: #111;
        }

        .bar-container {
            margin-bottom: 18px;
        }

        .bar-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 4px;
            font-size: 14px;
            color: #555;
        }

        .progress-bar-bg {
            background: #eee;
            height: 10px;
            border-radius: 10px;
            overflow: hidden;
        }

        .progress-bar-fill {
            height: 100%;
            width: 0%;
            background: #111;
        }

        .upcoming-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }

        .upcoming-item span {
            color: #333;
            font-size: 14px;
        }

        .recent-transactions {
            margin-top: 30px;
        }

        .transaction-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            font-size: 14px;
            color: #444;
        }

        .transaction-row span:last-child {
            font-weight: 600;
        }

    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <!-- Sidebar -->
        <div class="sidebar">
            <h3>BudgetTracker</h3>
            <a href="#"><i class="fas fa-tachometer-alt"></i>&nbsp; Dashboard</a>
            <a href="#"><i class="fas fa-users"></i>&nbsp; Users</a>
            <a href="#"><i class="fas fa-exchange-alt"></i>&nbsp; Transactions</a>
            <a href="#"><i class="fas fa-chart-line"></i>&nbsp; Reports</a>
            <a href="#"><i class="fas fa-cog"></i>&nbsp; Settings</a>
        </div>
        <div class="main-content" style="margin-left: 250px; padding: 40px;">
    <div class="dashboard-header">
        <h1>Dashboard</h1>
        <div>
            <button>Export</button>
            <button>Add Expense</button>
        </div>
    </div>

    <div class="tabs">
        <button>Overview</button>
        <button>Analytics</button>
        <button>Reports</button>
    </div>

    <div class="dashboard-cards">
        <!-- 4 Cards here -->
    </div>
</div>


       <div class="dashboard-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
    <h1 style="font-size: 28px; font-weight: bold;">Dashboard</h1>
    <div style="display: flex; gap: 10px;">
        <button style="padding: 8px 16px; border: 1px solid #ddd; background: white; border-radius: 8px; cursor: pointer;">Export</button>
        <button style="padding: 8px 16px; background: black; color: white; border-radius: 8px; border: none; cursor: pointer;">+ Add Expense</button>
    </div>
</div>

<div class="tabs" style="display: flex; gap: 10px; margin-bottom: 25px;">
    <button style="padding: 8px 20px; background: #f3f4f6; border-radius: 8px; border: none; font-weight: bold;">Overview</button>
    <button style="padding: 8px 20px; background: transparent; border: none; color: #555;">Analytics</button>
    <button style="padding: 8px 20px; background: transparent; border: none; color: #555;">Reports</button>
</div>

<div class="dashboard-cards" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
    <div class="card" style="background: white; padding: 25px; border-radius: 12px; border: 1px solid #eee;">
        <h3 style="font-size: 16px; color: #555;">Total Balance</h3>
        <p style="font-size: 28px; font-weight: bold; margin-top: 10px;">$5,231.89</p>
        <small style="color: #888;">+20.1% from last month</small>
    </div>

    <div class="card" style="background: white; padding: 25px; border-radius: 12px; border: 1px solid #eee;">
        <h3 style="font-size: 16px; color: #555;">Monthly Income</h3>
        <p style="font-size: 28px; font-weight: bold; margin-top: 10px;">$3,456.00</p>
        <small style="color: #2ea043;">+2.5% from last month</small>
    </div>

    <div class="card" style="background: white; padding: 25px; border-radius: 12px; border: 1px solid #eee;">
        <h3 style="font-size: 16px; color: #555;">Monthly Expenses</h3>
        <p style="font-size: 28px; font-weight: bold; margin-top: 10px;">$2,345.00</p>
        <small style="color: #d73a49;">+18.1% from last month</small>
    </div>

    <div class="card" style="background: white; padding: 25px; border-radius: 12px; border: 1px solid #eee;">
        <h3 style="font-size: 16px; color: #555;">Savings Rate</h3>
        <p style="font-size: 28px; font-weight: bold; margin-top: 10px;">32.1%</p>
        <small style="color: #2ea043;">+4.5% from last month</small>
    </div>
</div>

            <div class="section-header">
                <h2>User Management</h2>
                <div class="search-add">
                    <asp:TextBox ID="txtSearchUser" runat="server" placeholder="Search users..." CssClass="modern-textbox" />
                    <asp:Button ID="btnAddUser" runat="server" Text="Add User" CssClass="btn-save" />
                </div>
            </div>

            <asp:GridView ID="GridViewUsers" runat="server" CssClass="user-table" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="Username" HeaderText="User" />
                    <asp:BoundField DataField="Email" HeaderText="Email" />
                    <asp:BoundField DataField="Role" HeaderText="Role" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                    <asp:BoundField DataField="LastActive" HeaderText="Last Active" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- Modal Popup -->
        <asp:Panel ID="pnlAddUser" runat="server" CssClass="modal-popup" Visible="false">
            <div class="modal-content-modern">
                <h2>Add New User</h2>

                <asp:TextBox ID="txtNewUsername" runat="server" placeholder="Username" CssClass="modern-textbox" />
                <asp:TextBox ID="txtNewEmail" runat="server" placeholder="Email" CssClass="modern-textbox" />
                <asp:TextBox ID="txtNewRole" runat="server" placeholder="Role (Admin/User)" CssClass="modern-textbox" />

                <div style="margin-top: 20px;">
                    <asp:Button ID="btnSaveNewUser" runat="server" Text="Save" CssClass="btn-save" />
                    <asp:Button ID="btnCancelNewUser" runat="server" Text="Cancel" CssClass="btn-cancel" />
                </div>
            </div>
        </asp:Panel>

         <div class="container">

            <!-- Left Panel -->
            <div class="left-panel">
                <h2>Budget Overview</h2>

                <div class="bar-container">
                    <div class="bar-label">
                        <span>Housing</span><span>$0 / $0</span>
                    </div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill"></div>
                    </div>
                </div>

                <div class="bar-container">
                    <div class="bar-label">
                        <span>Food & Dining</span><span>$0 / $0</span>
                    </div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill"></div>
                    </div>
                </div>

                <div class="bar-container">
                    <div class="bar-label">
                        <span>Transportation</span><span>$0 / $0</span>
                    </div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill"></div>
                    </div>
                </div>

                <div class="bar-container">
                    <div class="bar-label">
                        <span>Entertainment</span><span>$0 / $0</span>
                    </div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill"></div>
                    </div>
                </div>

                <div class="bar-container">
                    <div class="bar-label">
                        <span>Utilities</span><span>$0 / $0</span>
                    </div>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill"></div>
                    </div>
                </div>

                <div class="recent-transactions">
                    <h2>Recent Transactions</h2>

                    <div class="transaction-row">
                        <span>Grocery Store</span><span>$0.00</span>
                    </div>
                    <div class="transaction-row">
                        <span>Coffee Shop</span><span>$0.00</span>
                    </div>
                    <div class="transaction-row">
                        <span>Salary Deposit</span><span>$0.00</span>
                    </div>
                    <div class="transaction-row">
                        <span>Rent Payment</span><span>$0.00</span>
                    </div>
                </div>
            </div>

            <!-- Right Panel -->
            <div class="right-panel">
                <h2>Upcoming Payments</h2>

                <div class="upcoming-item">
                    <span>Rent</span><span>$0.00</span>
                </div>
                <div class="upcoming-item">
                    <span>Internet</span><span>$0.00</span>
                </div>
                <div class="upcoming-item">
                    <span>Phone Bill</span><span>$0.00</span>
                </div>
                <div class="upcoming-item">
                    <span>Credit Card</span><span>$0.00</span>
                </div>
            </div>
        </div>

    </form>
</body>
</html>
