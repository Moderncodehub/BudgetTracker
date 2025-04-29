<%@ Page Title="Budget Dashboard" Language="C#" MasterPageFile="~/Site.Mobile.Master" AutoEventWireup="true" CodeBehind="BudgetCat.aspx.cs" Inherits="WebApplication5.BudgetCat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        body {
            background: #f9fafb;
            font-family: 'Poppins', sans-serif;
        }

        .card-style {
            background: #fff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
            transition: all 0.3s ease-in-out;
        }

        .month-list {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 25px;
        }

        .month-item {
            font-weight: 500;
            color: #666;
            cursor: pointer;
            transition: 0.3s;
            padding-bottom: 4px;
        }

        .month-item.active, .month-item:hover {
            color: #000;
            border-bottom: 2px solid #000;
        }

        .budget-table th, .budget-table td {
            vertical-align: middle;
            font-size: 15px;
            padding: 12px 8px;
        }

        .progress-bar {
            height: 6px;
            border-radius: 10px;
        }

        .remaining-positive { color: green; font-weight: 600; }
        .remaining-negative { color: red; font-weight: 600; }

        .summary-card {
            background: #fff;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
        }

        .summary-progress {
            height: 8px;
            background-color: #e0e0e0;
            border-radius: 10px;
            margin-top: 8px;
            margin-bottom: 20px;
            overflow: hidden;
        }

        .summary-progress-bar {
            background-color: #007bff;
            height: 100%;
            width: 0%;
            transition: width 0.5s;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

<div class="container py-5">
    <h2 class="mb-4">Budget</h2>

    <!-- Month List -->
<div class="month-list">
    <span class="month-item active" onclick="loadMonthData('January', this)">January</span>
    <span class="month-item" onclick="loadMonthData('February', this)">February</span>
    <span class="month-item" onclick="loadMonthData('March', this)">March</span>
    <span class="month-item" onclick="loadMonthData('April', this)">April</span>
    <span class="month-item" onclick="loadMonthData('May', this)">May</span>
    <span class="month-item" onclick="loadMonthData('June', this)">June</span>
    <span class="month-item" onclick="loadMonthData('July', this)">July</span>
    <span class="month-item" onclick="loadMonthData('August', this)">August</span>
    <span class="month-item" onclick="loadMonthData('September', this)">September</span>
    <span class="month-item" onclick="loadMonthData('October', this)">October</span>
    <span class="month-item" onclick="loadMonthData('November', this)">November</span>
    <span class="month-item" onclick="loadMonthData('December', this)">December</span>
</div>


    <div class="row g-4">
        <!-- Left: Budget Table -->
        <div class="col-lg-8">
            <div class="card-style">
                <table class="table budget-table">
                    <thead>
                        <tr>
                            <th>Category</th>
                            <th>Budgeted</th>
                            <th>Actual</th>
                            <th>Remaining</th>
                        </tr>
                    </thead>
                    <tbody id="budgetTableBody">
                        <asp:Repeater ID="rptBudgetTable" runat="server">
                            <ItemTemplate>
                                <tr>
                          <td>
    <div class="d-flex align-items-center gap-2">
        <i class="<%# GetCategoryIcon(Eval("Category").ToString()) %>"></i>
        <span><%# Eval("Category") %></span>
    </div>
    <div class="progress mt-1" style="height: 6px;">
        <div class="progress-bar bg-success" role="progressbar" style="width: <%# Eval("Progress") %>%"></div>
    </div>
</td>

                                    <td>$<%# Eval("Budgeted", "{0:N2}") %></td>
                                    <td>$<%# Eval("Actual", "{0:N2}") %></td>
                                    <td>
                                        <%# 
                                            (Convert.ToDecimal(Eval("Remaining")) >= 0)
                                            ? "<span class='remaining-positive'>$" + Convert.ToDecimal(Eval("Remaining")).ToString("N2") + "</span>"
                                            : "<span class='remaining-negative'>$" + Convert.ToDecimal(Eval("Remaining")).ToString("N2") + "</span>"
                                        %>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Right: Summary Card -->
        <div class="col-lg-4">
            <div class="summary-card">
                <h5>Summary</h5>
                <div class="d-flex justify-content-between">
                    <span id="spentAmount">$0 spent</span>
                    <span id="spentPercent">0% of budget</span>
                </div>
                <div class="summary-progress">
                    <div id="summaryProgressBar" class="summary-progress-bar"></div>
                </div>

                <div class="mt-3">
                    <div class="d-flex justify-content-between mb-2">
                        <span>➕ Budgeted</span>
                        <span id="budgetedAmount">$0</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>➖ Actual spend</span>
                        <span id="actualAmount">$0</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span>➗ Remaining</span>
                        <span id="remainingAmount">$0</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function loadMonthData(month, element) {
        // Activate the selected month
        document.querySelectorAll('.month-item').forEach(item => item.classList.remove('active'));
        element.classList.add('active');

        // Show loading if you want here

        fetch('BudgetCat.aspx/GetMonthData', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ month: month })
        })
            .then(response => response.json())
            .then(data => {
                var result = JSON.parse(data.d);

                // Update Budget Table
                document.getElementById('budgetTableBody').innerHTML = result.budgetHtml;

                // Update Summary
                document.getElementById('spentAmount').innerText = `$${result.totalActual.toFixed(2)} spent`;
                document.getElementById('spentPercent').innerText = `${result.spentPercent.toFixed(0)}% of budget`;
                document.getElementById('budgetedAmount').innerText = `$${result.totalBudgeted.toFixed(2)}`;
                document.getElementById('actualAmount').innerText = `$${result.totalActual.toFixed(2)}`;
                document.getElementById('remainingAmount').innerText = `$${result.remaining.toFixed(2)}`;

                // Update Progress bar
                document.getElementById('summaryProgressBar').style.width = result.spentPercent + "%";
            })
            .catch(error => console.error('Error:', error));
    }
</script>

</asp:Content>
