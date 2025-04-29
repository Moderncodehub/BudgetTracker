<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="WebApplication5.ManageUsers" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Users</title>
    <style>
        .gridview-style {
            margin: 40px auto;
            width: 80%;
            border-collapse: collapse;
        }
        .gridview-style th, .gridview-style td {
            padding: 10px;
            border: 1px solid #ddd;
        }
        .gridview-style th {
            background-color: #007bff;
            color: white;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h2 style="text-align:center;">Manage Users</h2>
        <asp:GridView ID="GridViewUsers" runat="server" CssClass="gridview-style" AutoGenerateColumns="False">
            <Columns>
                <asp:BoundField DataField="UserID" HeaderText="User ID" />
                <asp:BoundField DataField="Username" HeaderText="Username" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="Role" HeaderText="Role" />
            </Columns>
        </asp:GridView>
    </form>
</body>
</html>