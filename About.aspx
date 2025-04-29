<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="WebApplication5.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<main class="py-5" style="background-color: #f9fafb;">

    <div class="container">

        <a href="Default.aspx" style="text-decoration: none; color: #333; display: inline-block; margin-bottom: 20px;">&larr; Back to Home</a>

        <div class="text-center mb-5">
            <h1 class="fw-bold" style="font-size: 38px;">About BudgetTracker</h1>
        </div>

        <!-- Our Mission -->
        <div class="row align-items-center mb-5">
            <div class="col-md-6 mb-4 mb-md-0">
                <h2 class="fw-bold" style="margin-bottom: 20px;">Our Mission</h2>
                <p style="font-size: 18px; color: #555;">At BudgetTracker, we believe that financial freedom starts with understanding your money. Our mission is to empower individuals and families to take control of their finances through simple, intuitive tools that make budgeting and expense tracking accessible to everyone.</p>
                <p style="font-size: 18px; color: #555;">We’re committed to helping our users build better financial habits, reduce stress around money, and achieve their financial goals—whether that's saving for a dream vacation, paying off debt, or planning for retirement.</p>
            </div>
            <div class="col-md-6 text-center">
                <img src="images/about.png" alt="About Us" class="img-fluid rounded-4 shadow-sm" style="max-width: 100%; height: auto;" />
            </div>
        </div>

        <!-- Our Story -->
        <div class="text-center mb-5">
            <h2 class="fw-bold" style="margin-bottom: 20px;">Our Story</h2>
        </div>

        <div class="row justify-content-center mb-5">
            <div class="col-md-10">
                <p style="font-size: 18px; color: #555;">BudgetTracker was founded in 2023 by a team of finance professionals and software engineers who were frustrated with the complexity of existing financial tools. We set out to create a solution that would make budgeting simple, intuitive, and even enjoyable.</p>

                <p style="font-size: 18px; color: #555;">What started as a small project has grown into a platform trusted by thousands of users worldwide. Our team has expanded, but our core values remain the same: simplicity, transparency, and a genuine desire to help people achieve financial wellness.</p>

                <p style="font-size: 18px; color: #555;">Today, we continue to innovate and improve our platform based on user feedback and the latest financial best practices. We're proud to be part of our users' financial journeys and celebrate their successes along the way.</p>
            </div>
        </div>

        <!-- Our Values -->
        <div class="text-center mb-5">
            <h2 class="fw-bold" style="margin-bottom: 20px;">Our Values</h2>
        </div>

        <div class="row g-4 mb-5">

            <div class="col-md-4">
                <div class="bg-white rounded-4 p-4 h-100 shadow-sm hover-up">
                    <h4 class="fw-bold mb-3">Simplicity</h4>
                    <p style="color: #555;">We believe financial tools should be easy to use. We focus on creating intuitive interfaces that make managing money straightforward for everyone, regardless of financial expertise.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="bg-white rounded-4 p-4 h-100 shadow-sm hover-up">
                    <h4 class="fw-bold mb-3">Transparency</h4>
                    <p style="color: #555;">We're committed to being open and honest in everything we do—from our pricing to how we handle your data. No hidden fees, no confusing terms, just straightforward service.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="bg-white rounded-4 p-4 h-100 shadow-sm hover-up">
                    <h4 class="fw-bold mb-3">Empowerment</h4>
                    <p style="color: #555;">Our goal is to give you the tools and knowledge to take control of your financial future. We celebrate your progress and support you through challenges.</p>
                </div>
            </div>

        </div>

        <!-- Join Us -->
        <div class="text-center py-5">
            <h3 class="fw-bold mb-3">Join Us on Our Mission</h3>
            <p class="lead mb-4" style="color: #555;">Ready to take control of your finances? Join thousands of users already achieving their financial goals with BudgetTracker.</p>
            <a href="Login.aspx" class="btn btn-dark btn-lg" style="padding: 12px 30px; border-radius: 50px;">Get Started Today</a>
        </div>

    </div>

</main>

<!-- Minor Animation for Hover on Value Cards -->
<style>
    .hover-up {
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .hover-up:hover {
        transform: translateY(-8px);
        box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
    }
    @media (max-width: 767px) {
        h1 {
            font-size: 30px;
        }
        h2 {
            font-size: 26px;
        }
        h3 {
            font-size: 22px;
        }
        .lead {
            font-size: 18px;
        }
    }
</style>

</asp:Content>
