<%@ Page Title="Budget Planning" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="BudgetPlanning.aspx.cs" Inherits="WebApplication5.BudgetPlanning" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f7fa;
            margin: 0;
            padding: 0;
        }
        .container-custom {
            margin-top: 40px;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .header-title {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 25px;
            color: #333;
            text-align: center;
        }
        .form-label {
            font-weight: 600;
        }
        .btn-primary {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            border: none;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
        }
        .gridview {
            margin-top: 40px;
        }
        .gridview th {
            background-color: #4facfe;
            color: white;
            padding: 10px;
        }
        .gridview td {
            padding: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container container-custom">
        <div class="header-title">
            Budget Planning
        </div>

        <!-- Budget Form -->
        <div class="row mb-3">
            <div class="col-md-6">
                <label for="txtTitle" class="form-label">Title</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" Placeholder="Enter Title"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <label for="txtAmount" class="form-label">Amount</label>
                <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" Placeholder="Enter Amount"></asp:TextBox>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="ddlCategory" class="form-label">Category</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                    <asp:ListItem Value="">--Select Category--</asp:ListItem>
                    <asp:ListItem>Housing</asp:ListItem>
                    <asp:ListItem>Transportation</asp:ListItem>
                    <asp:ListItem>Food</asp:ListItem>
                    <asp:ListItem>Entertainment</asp:ListItem>
                    <asp:ListItem>Other</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-6">
                <label for="txtDate" class="form-label">Date</label>
                <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>
        </div>

        <div class="text-center mt-4 mb-4">
            <asp:Button ID="btnSubmit" runat="server" Text="Add Budget" CssClass="btn btn-primary btn-lg" />
        </div>

        <!-- Budget List GridView -->
        <div class="gridview">
            <asp:GridView ID="gvBudget" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered">
                <Columns>
                    <asp:BoundField DataField="Title" HeaderText="Title" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="${0:N2}" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />
                    <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
