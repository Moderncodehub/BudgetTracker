<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="price.aspx.cs" Inherits="WebApplication5.price" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Pricing - BudgetTracker</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f9fafb;
            margin: 0;
            padding: 0;
        }
        .pricing-card {
            background: #fff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06);
            transition: all 0.3s ease-in-out;
        }
        .pricing-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.12);
        }
        .pricing-title {
            font-weight: 700;
            font-size: 28px;
            margin-bottom: 10px;
        }
        .price {
            font-size: 42px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .price span {
            font-size: 18px;
            font-weight: 400;
            color: #777;
        }
        .feature-list {
            list-style: none;
            padding: 0;
            margin-top: 20px;
        }
        .feature-list li {
            margin-bottom: 12px;
            color: #555;
            font-size: 16px;
            line-height: 1.5;
        }
        .feature-list li::before {
            content: "✔️";
            margin-right: 8px;
            color: #2ecc71;
        }
        .btn-get-started {
            padding: 12px 24px;
            font-weight: bold;
            border-radius: 50px;
            margin-top: 30px;
            font-size: 16px;
            width: 100%;
        }
        .most-popular {
            background: #000;
            color: #fff;
            padding: 6px 14px;
            font-size: 14px;
            font-weight: 600;
            border-radius: 50px;
            margin-bottom: 10px;
            display: inline-block;
        }
        .contact-btn {
            border: 2px solid #000;
            background: transparent;
            color: #000;
            padding: 12px 30px;
            font-weight: bold;
            border-radius: 50px;
            transition: background 0.3s, color 0.3s;
        }
        .contact-btn:hover {
            background: #000;
            color: #fff;
        }
        @media (max-width: 767px) {
            .price {
                font-size: 34px;
            }
            .pricing-title {
                font-size: 24px;
            }
            .btn-get-started {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="container py-5">

            <a href="Default.aspx" style="text-decoration: none; color: #333; display: inline-block; margin-bottom: 20px;">&larr; Back to Home</a>

            <div class="text-center mb-5">
                <h1 class="fw-bold" style="font-size: 38px;">Simple, Transparent Pricing</h1>
                <p style="font-size: 18px; color: #666;">Choose the plan that works best for your financial needs. All plans include our core features to help you manage your finances effectively.</p>
            </div>

            <div class="row g-4 justify-content-center">

                <!-- Free Plan -->
                <div class="col-lg-4 col-md-6">
                    <div class="pricing-card h-100 text-center">
                        <div class="pricing-title">Free</div>
                        <div class="price">$0<span>/month</span></div>
                        <p class="mt-2">Perfect for individuals just starting their financial journey.</p>
                        <ul class="feature-list text-start mt-4">
                            <li>Basic expense tracking</li>
                            <li>Up to 3 budgets</li>
                            <li>Monthly reports</li>
                            <li>Basic bill reminders</li>
                            <li>1 savings goal</li>
                        </ul>
                        <a href="Register.aspx" class="btn btn-dark btn-get-started">Get Started</a>
                    </div>
                </div>

                <!-- Premium Plan -->
                <div class="col-lg-4 col-md-6">
                    <div class="pricing-card h-100 text-center border border-dark">
                        <div class="most-popular">Most Popular</div>
                        <div class="pricing-title">Premium</div>
                        <div class="price">$9.99<span>/month</span></div>
                        <p class="mt-2">For individuals serious about managing their finances.</p>
                        <ul class="feature-list text-start mt-4">
                            <li>Advanced expense tracking</li>
                            <li>Unlimited budgets</li>
                            <li>Advanced reports and analytics</li>
                            <li>Advanced bill reminders</li>
                            <li>Unlimited savings goals</li>
                            <li>Data export (CSV, PDF)</li>
                            <li>Priority support</li>
                        </ul>
                        <a href="Register.aspx" class="btn btn-dark btn-get-started">Get Started</a>
                    </div>
                </div>

                <!-- Family Plan -->
                <div class="col-lg-4 col-md-6">
                    <div class="pricing-card h-100 text-center">
                        <div class="pricing-title">Family</div>
                        <div class="price">$19.99<span>/month</span></div>
                        <p class="mt-2">For families who want to manage finances together.</p>
                        <ul class="feature-list text-start mt-4">
                            <li>Everything in Premium</li>
                            <li>Up to 5 user accounts</li>
                            <li>Shared budgets and goals</li>
                            <li>Family spending insights</li>
                            <li>Allowance tracking</li>
                            <li>Dedicated account manager</li>
                        </ul>
                        <a href="Register.aspx" class="btn btn-dark btn-get-started">Get Started</a>
                    </div>
                </div>

            </div>

            <div class="text-center mt-5">
                <h3 class="fw-bold">Need something custom?</h3>
                <p style="color: #666;">We offer custom plans for businesses and organizations with specific needs. Contact us to learn more.</p>
                <a href="Contact.aspx" class="contact-btn mt-3">Contact Sales</a>
            </div>

        </div>

    </form>
</body>
</html>
