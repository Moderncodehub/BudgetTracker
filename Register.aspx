<%@ Page Title="Register - BudgetTracker" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebApplication5.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            overflow: hidden;
        }

        .split-container {
            display: flex;
            height: 100vh;
        }

        .left-side {
            flex: 1;
            background: linear-gradient(to bottom right, #4f46e5, #3b82f6);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 40px;
            text-align: center;
        }

        .left-side h1 {
            font-size: 48px;
            font-weight: 800;
            margin-bottom: 20px;
        }

        .left-side p {
            font-size: 18px;
            max-width: 400px;
            line-height: 1.5;
        }

        .right-side {
            flex: 1;
            background: #f9fafb;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
        }

        .register-form {
            background: #fff;
            padding: 50px 30px;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        .register-form .icon {
            width: 80px;
            height: 80px;
            background: #4f46e5;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 36px;
            margin: 0 auto 20px auto;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.4);
        }

        .register-form h2 {
            font-weight: 800;
            margin-bottom: 10px;
            color: #333;
        }

        .register-form p {
            color: #777;
            margin-bottom: 30px;
            font-size: 14px;
        }

        .register-form label {
            font-weight: 600;
            margin-bottom: 5px;
            text-align: left;
            display: block;
        }

        .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 15px;
        }

        .btn-dark {
            background-color: #111827;
            border: none;
            transition: background 0.3s ease;
            padding: 12px;
            font-weight: 600;
            letter-spacing: 0.5px;
            font-size: 16px;
            border-radius: 10px;
            margin-top: 10px;
        }

        .btn-dark:hover {
            background-color: #374151;
        }

        .login-link {
            font-size: 14px;
            text-align: center;
            margin-top: 20px;
        }

        .login-link a {
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        @media(max-width: 768px) {
            .split-container {
                flex-direction: column;
            }
            .left-side, .right-side {
                flex: none;
                width: 100%;
                height: 50%;
            }
        }
    </style>

    <div class="split-container">
        <div class="left-side">
            <h1>Join BudgetTracker!</h1>
            <p>Take control of your finances, start your journey with us today!</p>
        </div>

        <div class="right-side">
            <div class="register-form">
                <div class="icon">
                    <i class="fas fa-user-plus"></i>
                </div>

                <h2>Create an Account</h2>
                <p>Sign up to manage your budget easily</p>

                <div class="mb-3 text-start">
    <label for="name">Full Name</label>
    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="John Doe" />
</div>

                <div class="mb-3 text-start">
                    <label for="email">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="name@example.com" />
                </div>

                <div class="mb-3 text-start">
                    <label for="password">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" />
                </div>

                <div class="mb-3 text-start">
                    <label for="confirmPassword">Confirm Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" />
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-dark w-100" OnClick="btnRegister_Click" />

                <div class="login-link">
                    <p>Already have an account? <a href="Login.aspx">Login</a></p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
