<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="feature.aspx.cs" Inherits="WebApplication5.feature" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Features - BudgetTracker</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f9fafb;
            margin: 0;
            padding: 0;
        }
        .section-title {
            font-size: 40px;
            font-weight: 700;
            margin-bottom: 10px;
        }
        .section-subtitle {
            font-size: 18px;
            color: #777;
            margin-bottom: 50px;
        }
        .feature-card {
            background: #fff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.06);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.12);
        }
        .feature-card h4 {
            font-weight: 700;
            margin-bottom: 15px;
            font-size: 22px;
        }
        .feature-card p {
            color: #555;
            font-size: 16px;
            margin-bottom: 15px;
        }
        .feature-card ul {
            padding-left: 20px;
            color: #555;
            font-size: 16px;
        }
        .feature-card ul li {
            margin-bottom: 8px;
        }
        .btn-get-started {
            padding: 15px 30px;
            font-size: 18px;
            font-weight: bold;
            border-radius: 50px;
            margin-top: 30px;
        }
        .back-link {
            margin-bottom: 20px;
            display: inline-block;
            font-size: 16px;
            text-decoration: none;
            color: #333;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        @media (max-width: 767px) {
            .section-title {
                font-size: 30px;
            }
            .section-subtitle {
                font-size: 16px;
            }
            .feature-card h4 {
                font-size: 20px;
            }
            .btn-get-started {
                font-size: 16px;
            }
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="container py-5">

            <a href="Default.aspx" class="back-link">&larr; Back to Home</a>

            <div class="text-center mb-5">
                <h1 class="section-title">Features</h1>
                <p class="section-subtitle">Discover all the powerful features that make BudgetTracker the best choice for managing your finances.</p>
            </div>

            <div class="row g-4">

                <!-- Feature 1 -->
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card h-100">
                        <h4>Expense Tracking</h4>
                        <p>Easily record and categorize all your expenses.</p>
                        <ul>
                            <li>Automatic categorization</li>
                            <li>Receipt scanning</li>
                            <li>Custom tags and filters</li>
                            <li>Recurring expenses</li>
                        </ul>
                    </div>
                </div>

                <!-- Feature 2 -->
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card h-100">
                        <h4>Budget Management</h4>
                        <p>Create custom budgets and track your spending in real-time.</p>
                        <ul>
                            <li>Category-based budgets</li>
                            <li>Monthly, quarterly budgets</li>
                            <li>Visual progress indicators</li>
                            <li>Budget alerts and notifications</li>
                        </ul>
                    </div>
                </div>

                <!-- Feature 3 -->
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card h-100">
                        <h4>Bill Reminders</h4>
                        <p>Never miss a payment with automated reminders.</p>
                        <ul>
                            <li>Email and push notifications</li>
                            <li>Calendar integration</li>
                            <li>Recurring payment tracking</li>
                            <li>Payment confirmation</li>
                        </ul>
                    </div>
                </div>

                <!-- Feature 4 -->
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card h-100">
                        <h4>Financial Reports</h4>
                        <p>Gain insights with detailed financial reports.</p>
                        <ul>
                            <li>Spending by category</li>
                            <li>Income vs. expenses</li>
                            <li>Monthly/yearly comparisons</li>
                            <li>Exportable reports (PDF, CSV)</li>
                        </ul>
                    </div>
                </div>

                <!-- Feature 5 -->
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card h-100">
                        <h4>Savings Goals</h4>
                        <p>Set and track your financial goals visually.</p>
                        <ul>
                            <li>Custom savings targets</li>
                            <li>Progress tracking</li>
                            <li>Goal completion dates</li>
                            <li>Automatic contributions</li>
                        </ul>
                    </div>
                </div>

                <!-- Feature 6 -->
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card h-100">
                        <h4>Secure Data</h4>
                        <p>Bank-level security and encryption for your data.</p>
                        <ul>
                            <li>End-to-end encryption</li>
                            <li>Two-factor authentication</li>
                            <li>Biometric login support</li>
                            <li>Regular security audits</li>
                        </ul>
                    </div>
                </div>

            </div>

            <div class="text-center mt-5">
                <h3 class="fw-bold mb-3">Ready to take control of your finances?</h3>
                <a href="Login.aspx" class="btn btn-dark btn-get-started">Get Started Today</a>
            </div>

        </div>
    </form>
</body>
</html>
