<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication5._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<main>

    <!-- Hero Section -->
    <section id="home" style="padding: 80px 20px; display: flex; align-items: center; justify-content: center; background: #ffffff;">
        <div style="max-width: 1200px; width: 100%; display: flex; flex-wrap: wrap; justify-content: space-between; align-items: center;">
            <div style="flex: 1; min-width: 300px;">
                <h1 style="font-size: 48px; font-weight: 700; margin-bottom: 20px;">Take Control of Your Finances</h1>
                <p style="font-size: 18px; color: #666; margin-bottom: 30px;">Track expenses, set budgets, manage recurring payments, and achieve your financial goals with our comprehensive budget tracker.</p>
                <div>
                    <a href="Register.aspx" class="btn btn-dark" style="margin-right: 10px;">Get Started</a>
                    <a href="#contact" class="btn btn-outline-dark">Contact</a>
                </div>
            </div>
            <div style="flex: 1; min-width: 300px; text-align: center; margin-top: 30px;">
                <img src="images/clean-budget-overview.png" alt="Dashboard Screenshot" style="max-width: 100%; height: auto; border-radius: 10px; box-shadow: 0px 8px 20px rgba(0,0,0,0.1);" />
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" style="background: #f9fafb; padding: 80px 20px;">
        <div style="max-width: 1000px; margin: auto; text-align: center;">
            <h2 style="font-size: 36px; font-weight: 700; margin-bottom: 10px;">Key Features</h2>
            <p style="font-size: 18px; color: #666; margin-bottom: 50px;">Everything you need to manage your personal finances effectively</p>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 30px;">
                
                <div style="background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0px 4px 10px rgba(0,0,0,0.05);">
                    <h4>Expense Tracking</h4>
                    <p style="color: #777;">Easily add, categorize, and manage all your expenses in one place.</p>
                </div>

                <div style="background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0px 4px 10px rgba(0,0,0,0.05);">
                    <h4>Bill Reminders</h4>
                    <p style="color: #777;">Never miss a payment with automated reminders for bills and subscriptions.</p>
                </div>

                <div style="background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0px 4px 10px rgba(0,0,0,0.05);">
                    <h4>Savings Goals</h4>
                    <p style="color: #777;">Set and track savings goals to achieve your financial dreams.</p>
                </div>

                <div style="background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0px 4px 10px rgba(0,0,0,0.05);">
                    <h4>Financial Reports</h4>
                    <p style="color: #777;">Visualize your spending patterns with detailed reports and analytics.</p>
                </div>

                <div style="background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0px 4px 10px rgba(0,0,0,0.05);">
                    <h4>Secure Data</h4>
                    <p style="color: #777;">Your financial information is encrypted and protected at all times.</p>
                </div>

                <div style="background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0px 4px 10px rgba(0,0,0,0.05);">
                    <h4>Budget Planning</h4>
                    <p style="color: #777;">Create and manage budgets for different categories of spending.</p>
                </div>

            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 100px 20px; position: relative; overflow: hidden; color: #fff;">
        <div style="position: absolute; top: -50px; left: -50px; width: 200px; height: 200px; background: rgba(255,255,255,0.1); border-radius: 50%; filter: blur(80px);"></div>
        <div style="position: absolute; bottom: -50px; right: -50px; width: 200px; height: 200px; background: rgba(255,255,255,0.1); border-radius: 50%; filter: blur(80px);"></div>
        
        <div style="max-width: 800px; margin: auto; text-align: center; position: relative;">
            <h2 style="font-size: 40px; font-weight: 700; margin-bottom: 20px;">Get in Touch with Modern Code Hub</h2>
            <p style="font-size: 18px; color: #e0e0e0; margin-bottom: 40px;">Questions? Feedback? Need Help? We'd love to hear from you!</p>
            
            <div style="background: rgba(255, 255, 255, 0.1); padding: 40px; border-radius: 15px; display: inline-block; text-align: left; backdrop-filter: blur(10px); box-shadow: 0px 8px 30px rgba(0,0,0,0.2);">
                <p style="font-size: 22px; margin-bottom: 15px;"><span style="font-size: 28px;">📞</span> <strong>Phone:</strong> 657-350-4225</p>
                <p style="font-size: 22px;"><span style="font-size: 28px;">✉️</span> <strong>Email:</strong> <a href="mailto:moderncodehub@gmail.com" style="color: #fff; text-decoration: underline;">moderncodehub@gmail.com</a></p>
            </div>

            <div style="margin-top: 40px;">
                <a href="mailto:moderncodehub@gmail.com" class="btn btn-light" style="padding: 12px 30px; font-size: 18px; font-weight: bold; border-radius: 50px; text-transform: uppercase; box-shadow: 0px 5px 20px rgba(0,0,0,0.2);">Send Us a Message</a>
            </div>
        </div>
    </section>

</main>

<!-- Smooth Scroll Script -->
<script>
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
</script>

</asp:Content>
