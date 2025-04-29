<%@ Page Title="Transactions" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="Transactions.aspx.cs" Inherits="WebApplication5.Transactions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .main-content { padding: 40px; }
        .topbar { display: flex; flex-wrap: wrap; gap: 10px; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .btn-add, .btn-export { padding: 8px 16px; border-radius: 8px; font-weight: 500; }
        .btn-add { background: linear-gradient(135deg, #4e73df, #6f86ff); color: white; border: none; }
        .btn-export { background-color: #e9ecef; }
        .transaction-card { background-color: #fff; border-radius: 16px; padding: 30px; box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05); }
        .transaction-table { width: 100%; margin-top: 20px; border-collapse: collapse; }
        .transaction-table th, .transaction-table td { padding: 14px 12px; border-bottom: 1px solid #eee; text-align: left; }
        .transaction-table th { background-color: #f9fafe; }
        .amount-negative { color: #e74c3c; }
        .amount-positive { color: #27ae60; }
        .form-select, .form-control { border-radius: 10px; padding: 10px; }
        @media (max-width: 768px) {
            .main-content { padding: 20px; }
            .topbar { flex-direction: column; align-items: flex-start; }
            .btn-add, .btn-export, .form-control, .form-select { width: 100% !important; margin-bottom: 10px; }
        }
        .filter-tag { cursor: pointer; }
        .filter-tag.active { background-color: #4e73df !important; color: #fff !important; }
        .amount-negative { color: #e74c3c; } /* Red */
.amount-positive { color: #27ae60; } /* Green */

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server" />

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            $('.filter-tag').click(function () {
                $('.filter-tag').removeClass('active');
                $(this).addClass('active');
                var category = $(this).data('category');
                __doPostBack('FilterByTag', category);
            });
        });
    </script>

    <div class="main-content">
        <div class="topbar">
            <h2><i class="fa-solid fa-wallet me-2"></i>Transactions</h2>
            <div>
                <asp:TextBox ID="txtSearchTitle" runat="server" CssClass="form-control d-inline me-2" Width="200px" placeholder="Search title..." />
                <asp:DropDownList ID="ddlFilterCategory" runat="server" CssClass="form-select d-inline me-2" Width="160px">
                    <asp:ListItem Text="All Categories" Value="" />
                    <asp:ListItem Text="Dining" Value="Dining" />
                    <asp:ListItem Text="Shopping" Value="Shopping" />
                    <asp:ListItem Text="Income" Value="Income" />
                    <asp:ListItem Text="Housing" Value="Housing" />
                    <asp:ListItem Text="Auto" Value="Auto" />
                </asp:DropDownList>
                <asp:Button ID="btnFilter" runat="server" CssClass="btn btn-light me-2" Text="Apply Filter" OnClick="btnFilter_Click" />
                <asp:Button ID="btnExport" runat="server" CssClass="btn-export me-2" Text="Export" OnClick="btnExport_Click" />
                <button type="button" class="btn-add" data-bs-toggle="modal" data-bs-target="#transactionModal">+ Add Transaction</button>
            </div>
        </div>

        <div class="mb-3">
            <span class="badge bg-primary me-1 filter-tag active" data-category="">All</span>
            <span class="badge bg-secondary me-1 filter-tag" data-category="Dining">Dining</span>
            <span class="badge bg-secondary me-1 filter-tag" data-category="Shopping">Shopping</span>
            <span class="badge bg-secondary me-1 filter-tag" data-category="Income">Income</span>
            <span class="badge bg-secondary me-1 filter-tag" data-category="Housing">Housing</span>
            <span class="badge bg-secondary me-1 filter-tag" data-category="Health">Health</span>
            <span class="badge bg-secondary me-1 filter-tag" data-category="Auto">Auto</span>
        </div>

        <div class="transaction-card">
            <h5 class="fw-bold"><i class="fa-solid fa-clock-rotate-left me-2"></i>Transaction History</h5>
            <p class="text-muted mb-3">View and manage all your transactions</p>
            <asp:Literal ID="litMessage" runat="server" />
            <table class="transaction-table">
                <thead>
                    <tr>
                        <th><input type="checkbox" /></th>
                        <th>Transaction</th>
                        <th>Category</th>
                        <th>Date</th>
                        <th>Payment Method</th>
                        <th>Amount</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                    <asp:Repeater ID="rptAllTransactions" runat="server" OnItemCommand="rptAllTransactions_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td><input type="checkbox" /></td>
                                <td><%# Eval("Title") %></td>
                                <td><i class='<%# GetCategoryIcon(Eval("Category").ToString()) %>'></i> <%# Eval("Category") %></td>
                                <td><%# Eval("CreatedAt", "{0:MMM d, yyyy}") %></td>
                                <td><%# Eval("PaymentMethod") %></td>
                                <td class='<%# Convert.ToDecimal(Eval("Amount")) < 0 ? "amount-negative" : "amount-positive" %>'>
    <%# Convert.ToDecimal(Eval("Amount")) >= 0 ? "+" : "" %><%# String.Format("{0:N2}", Eval("Amount")) %>
</td>

                                <td>
                                    <button type="button" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#transactionModal" onclick="__doPostBack('EditTransaction', '<%# Eval("Id") %>')">Edit</button>
                                    <asp:Button ID="btnDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-danger" Text="Delete" />
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
                <tr class="fw-bold">
    <td colspan="5" class="text-end">Income Total:</td>
    <td colspan="2"><asp:Label ID="lblFooterIncome" runat="server" CssClass="text-success" /></td>
</tr>
<tr class="fw-bold">
    <td colspan="5" class="text-end">Expense Total:</td>
    <td colspan="2"><asp:Label ID="lblFooterExpense" runat="server" CssClass="text-danger" /></td>
</tr>
<tr class="fw-bold">
    <td colspan="5" class="text-end">Net Total:</td>
    <td colspan="2"><asp:Label ID="lblFooterNet" runat="server" CssClass="text-dark" /></td>
</tr>

                <asp:Label ID="Label1" runat="server" CssClass="text-success" />
<asp:Label ID="Label2" runat="server" CssClass="text-danger" />
<asp:Label ID="Label3" runat="server" CssClass="text-dark" />

            </table>
        </div>
    </div>

    <!-- Modal for Add/Edit Transaction -->
    <div class="modal fade" id="transactionModal" tabindex="-1" aria-labelledby="transactionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="transactionModalLabel">Add / Edit Transaction</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="hfTransactionId" runat="server" />
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                            <asp:ListItem>Dining</asp:ListItem>
                            <asp:ListItem>Shopping</asp:ListItem>
                            <asp:ListItem>Income</asp:ListItem>
                            <asp:ListItem>Housing</asp:ListItem>
                            <asp:ListItem>Health</asp:ListItem>
                            <asp:ListItem>Auto</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Date</label>
                        <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Payment Method</label>
                        <asp:DropDownList ID="ddlMethod" runat="server" CssClass="form-select">
                            <asp:ListItem>Credit Card</asp:ListItem>
                            <asp:ListItem>Debit Card</asp:ListItem>
                            <asp:ListItem>Bank Transfer</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Amount</label>
                        <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnSave" runat="server" Text="Save Transaction" CssClass="btn btn-dark" OnClick="btnSave_Click" />
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>