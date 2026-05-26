<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="HomePage.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.HomePage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* الخلفية تغطي كامل الصفحة */
        body {
            margin: 0;
            padding: 0;
            background-image: url('/images/Gemini_Generated_Image_3oqnxs3oqnxs3oqn.png');
            background-repeat: no-repeat;
            background-position: center center;
            background-size: cover; /* يغطي كامل الشاشة */
            background-attachment: fixed; /* تبقى ثابتة عند التمرير */
        }

        /* محتوى الصفحة يظهر فوق الخلفية */
        .home-content {
            text-align: center;
            padding: 50px;
            color: #2c3e50;
        }

        .home-content h1 {
            margin-bottom: 30px;
        }

        .home-content p {
            margin-top: 20px;
            font-size: 18px;
            color: #fff; /* نص أبيض ليظهر جيدًا على الخلفية */
        }
    </style>

    <div class="home-content">
        <h1>مرحباً بك في نظام إدارة العيادات</h1>
        <p>اختر من القائمة العلوية أو الجانبية للبدء باستخدام النظام</p>
    </div>
</asp:Content>
