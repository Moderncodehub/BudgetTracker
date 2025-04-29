<%@ Page Title="Reminders" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="Reminders.aspx.cs" Inherits="WebApplication5.Reminders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #ecf0ff, #f5f7fb);
            background-size: 400% 400%;
            animation: gradientFlow 15s ease infinite;
        }

        @keyframes gradientFlow {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .blob-bg {
            position: absolute;
            top: -100px;
            right: -100px;
            z-index: 0;
            opacity: 0.15;
            width: 400px;
            height: 400px;
            pointer-events: none;
        }

        .main-content {
            position: relative;
            padding: 40px;
            min-height: 100vh;
            z-index: 1;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .btn-add {
            background: linear-gradient(135deg, #4e73df, #6f86ff);
            color: #fff;
            border: none;
            padding: 10px 22px;
            border-radius: 12px;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .btn-add:hover {
            opacity: 0.9;
            transform: scale(1.02);
        }

        .btn-paynow {
            background: #eef1f8;
            border: 1px solid #ccd6ee;
            color: #4e73df;
            padding: 6px 14px;
            border-radius: 8px;
            font-weight: 500;
        }

        .btn-paynow:hover {
            background: #dee4f7;
        }

        .card-box {
            background: #ffffff;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
            transition: 0.3s ease;
        }

        .card-box:hover {
            transform: translateY(-4px);
        }

        .payment-item {
            padding: 20px 0;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .payment-info i {
            font-size: 24px;
            margin-right: 15px;
            color: #4e73df;
        }

        .badge {
            font-size: 12px;
            padding: 6px 14px;
            border-radius: 30px;
        }

        .form-label {
            font-weight: 500;
            color: #3c3c3c;
        }

        .form-control, .form-select {
            border-radius: 12px;
            padding: 10px;
            font-size: 15px;
            background: #f6f9ff;
            border: 1px solid #dce3f2;
        }

        .btn-outline-dark {
            border-radius: 10px;
        }

        .section-title i {
            color: #4e73df;
            margin-right: 8px;
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- BLOB BACKGROUND SVG -->
    <svg class="blob-bg" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
        <path fill="#4e73df" d="M52.3,-59.6C66.5,-50.5,76.6,-33.8,75.4,-18.2C74.2,-2.5,61.7,12,51.2,26.4C40.8,40.8,32.3,55.1,19.9,60.5C7.6,65.9,-8.6,62.5,-24.4,56.7C-40.3,50.9,-55.9,42.7,-61.2,30C-66.6,17.2,-61.7,-0.1,-54.2,-15.7C-46.6,-31.4,-36.4,-45.5,-23.4,-55.5C-10.5,-65.4,5.3,-71.3,20.7,-69.5C36.1,-67.8,51.1,-58.7,52.3,-59.6Z" transform="translate(100 100)" />
    </svg>

    <div class="main-content">
        <div class="topbar">
            <h3 class="fw-bold"><i class="fa-solid fa-bell"></i> Reminders & Recurring Payments</h3>
            <asp:Button ID="btnAddReminder" runat="server" Text="+ Add New" CssClass="btn-add" OnClick="btnAddReminder_Click" />
        </div>

        <div class="btn-group mb-4" role="group">
            <asp:Button ID="btnUpcoming" runat="server" Text="Upcoming Payments" CssClass="btn btn-outline-dark active" />
            <asp:Button ID="btnRecurring" runat="server" Text="Recurring Payments" CssClass="btn btn-outline-dark" />
        </div>

        <asp:Panel ID="pnlAddReminder" runat="server" CssClass="card-box mb-4" Visible="false">
            <div id="addReminderPanel">
                <h5 class="fw-bold section-title"><i class="fa-solid fa-plus-circle"></i> Add New Reminder</h5>
                <div class="row g-4">
                    <div class="col-md-4">
                        <label class="form-label">Title</label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Amount</label>
                        <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Due Date</label>
                        <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Frequency</label>
                        <asp:DropDownList ID="ddlFrequency" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Monthly" />
                            <asp:ListItem Text="Yearly" />
                            <asp:ListItem Text="Weekly" />
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Icon</label>
               <asp:DropDownList ID="ddlIconClass" runat="server" CssClass="form-select">
    <asp:ListItem Text="fa-solid fa-house" />            <%-- Home --%>
    <asp:ListItem Text="fa-solid fa-wifi" />             <%-- Internet --%>
    <asp:ListItem Text="fa-solid fa-mobile" />           <%-- Mobile --%>
    <asp:ListItem Text="fa-solid fa-credit-card" />      <%-- Credit Card --%>
    <asp:ListItem Text="fa-solid fa-car" />              <%-- Auto --%>
    <asp:ListItem Text="fa-solid fa-bolt" />             <%-- Electric Bill --%>
    <asp:ListItem Text="fa-solid fa-cart-shopping" />    <%-- Grocery --%>
    <asp:ListItem Text="fa-solid fa-utensils" />          <%-- Food/Dining --%>
    <asp:ListItem Text="fa-solid fa-cloud-sun" />         <%-- Utility/General Bills --%>
    <asp:ListItem Text="fa-solid fa-store" />             <%-- Vape Shop / Store --%>
    <asp:ListItem Text="fa-solid fa-lightbulb" />         <%-- Electricity/Light Bill --%>
    <asp:ListItem Text="fa-solid fa-gas-pump" />          <%-- Gas for Auto --%>
    <asp:ListItem Text="fa-solid fa-hand-holding-dollar" /> <%-- Loans/Finance --%>
    <asp:ListItem Text="fa-solid fa-briefcase-medical" /> <%-- Medical --%>
    <asp:ListItem Text="fa-solid fa-dumbbell" />          <%-- Gym/Health Membership --%>
    <asp:ListItem Text="fa-solid fa-briefcase" />         <%-- Business/Work Expense --%>
</asp:DropDownList>

                    </div>
                </div>
                <div class="mt-4 d-flex gap-3">
                    <asp:Button ID="Button2" runat="server" Text="Save Reminder" CssClass="btn btn-dark" OnClick="btnAddReminder_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary" OnClick="btnCancel_Click" />
                </div>
            </div>
        </asp:Panel>

        <div class="card-box">
            <h5 class="fw-bold mb-3 section-title"><i class="fa-regular fa-calendar-days"></i> Upcoming Payments</h5>
            <asp:Repeater ID="rptReminders" runat="server" OnItemCommand="rptReminders_ItemCommand" OnItemDataBound="rptReminders_ItemDataBound">
                <ItemTemplate>
                    <div class="payment-item">
                        <div class="payment-info d-flex align-items-center">
                            <i class='<%# Eval("IconClass") %>'></i>
                            <div>
                                <strong><%# Eval("Title") %></strong><br />
                                <small class="text-muted"><%# Eval("Frequency") %></small>
                            </div>
                        </div>
                        <div class="text-end">
                            <strong><%# String.Format("${0:N2}", Eval("Amount")) %></strong><br />
                            <small class="text-muted">Due <%# Eval("DueDate", "{0:MMM d, yyyy}") %></small><br />
                            <asp:Label ID="lblStatus" runat="server" CssClass="badge"></asp:Label><br />
                            <asp:Button ID="btnPayNow" runat="server" Text="Pay Now" CssClass="btn-paynow mt-1" />
                            <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="Edit" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-secondary mt-1 me-1" />
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-danger mt-1" />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="card-box">
            <h5 class="fw-bold mb-3 section-title"><i class="fa-solid fa-gear"></i> Payment Reminders</h5>
            <p class="text-muted">Get notified before payments are due</p>
            <ul class="list-unstyled">
                <li><i class="fa-regular fa-bell me-2"></i>Email Notifications <span class="float-end text-success">Enabled</span></li>
                <li><i class="fa-regular fa-bell me-2"></i>SMS Notifications <span class="float-end text-muted">Disabled</span></li>
                <li><i class="fa-regular fa-calendar-days me-2"></i>Calendar Integration <span class="float-end text-success">Enabled</span></li>
            </ul>
            <asp:Button ID="btnManageNotif" runat="server" Text="Manage Notifications" CssClass="btn btn-outline-dark mt-3" />
        </div>
    </div>
</asp:Content>
