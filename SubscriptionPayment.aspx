<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="SubscriptionPayment.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.SubscriptionPayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="subscription-container">
        <h1 class="title">اختر الباقة المناسبة لك</h1>
        <p class="subtitle">اشترك الآن وتمتع بمزايا حصرية لكل باقة</p>

        <div class="subscription-cards">

    <!-- Basic -->
    <div class="subscription-card basic">
        <h2>Basic</h2>
        <p class="price">100 دينار / السنة</p>
        <ul class="features">
            <li>صفحة شخصية كاملة</li>
            <li>لوحة إدارة (Dashboard)</li>
            <li>الظهور في محرك البحث داخل الموقع</li>
            <li>إمكانية إدارة ملفات المرضى</li>
        </ul>
        <div class="btn-container">
            <asp:Button ID="btnBasic" runat="server" Text="ادفع الآن" CssClass="pay-btn" OnClick="btnBasic_Click" />
        </div>
    </div>

    <!-- VIP -->
    <div class="subscription-card vip">
        <h2>VIP</h2>
        <p class="price">130 دينار / السنة</p>
        <ul class="features">
            <li>كل مميزات Basic</li>
            <li>ظهور في الصفحة الرئيسية</li>
            <li>شاشة إعلان دائم</li>
            <li>مدرج في نتائج البحث والتصفية</li>
        </ul>
        <div class="btn-container">
            <asp:Button ID="btnVIP" runat="server" Text="ادفع الآن" CssClass="pay-btn" OnClick="btnVIP_Click" />
        </div>
    </div>

    <!-- Gold -->
    <div class="subscription-card gold">
        <h2>Gold</h2>
        <p class="price">160 دينار / السنة</p>
        <ul class="features">
            <li>كل مميزات VIP</li>
            <li>الظهور في بداية قائمة الأطباء بالصفحة الرئيسية</li>
            <li>أولوية في نتائج البحث والتصفية</li>
            <li>لوحة إدارة كاملة + داش بورد متقدم</li>
        </ul>
        <div class="btn-container">
            <asp:Button ID="btnGold" runat="server" Text="ادفع الآن" CssClass="pay-btn" OnClick="btnGold_Click" />
        </div>
    </div>

    <!-- ADV/Silver -->
    <div class="subscription-card adv-silver">
        <h2>ADV/Silver</h2>
        <p class="price">60 دينار / السنة</p>
        <ul class="features">
            <li>صفحة شخصية كاملة</li>
            <li>الظهور في الصفحة الرئيسية فقط</li>
            <li>إدارة صفحة شخصية بسيطة</li>
        </ul>
        <div class="btn-container">
            <asp:Button ID="btnSilver" runat="server" Text="ادفع الآن" CssClass="pay-btn" OnClick="btnSilver_Click" />
        </div>
    </div>

    <!-- ADV Gold -->
    <div class="subscription-card adv-gold">
        <h2>ADV/Gold</h2>
        <p class="price">75 دينار / السنة</p>
        <ul class="features">
            <li>ظهور في أعلى الصفحة الرئيسية</li>
            <li>الظهور في نتائج البحث والتصفية</li>
            <li>صفحة شخصية وإدارة كاملة</li>
            <li>أولوية في الترتيب بالموقع</li>
        </ul>
        <div class="btn-container">
            <asp:Button ID="btnPlatinum" runat="server" Text="ادفع الآن" CssClass="pay-btn" OnClick="btnPlatinum_Click" />
        </div>
    </div>

</div>

<style>
    .subscription-cards { display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; }
    .subscription-card { 
        display: flex; 
        flex-direction: column; 
        justify-content: space-between; 
        border: 1px solid #ddd; 
        border-radius: 12px; 
        width: 240px; 
        padding: 20px; 
        box-shadow: 0 4px 10px rgba(0,0,0,0.05); 
        transition: 0.3s; 
    }
    .subscription-card:hover { box-shadow: 0 8px 20px rgba(0,0,0,0.15); transform: translateY(-5px); }
    .subscription-card h2 { margin-bottom: 10px; color: #222; }
    .price { font-size: 20px; font-weight: bold; margin-bottom: 15px; color: #0078d7; }
    .features { text-align: left; list-style: none; padding: 0; margin-bottom: 15px; }
    .features li { margin-bottom: 8px; padding-left: 20px; position: relative; }
    .features li::before { content: "✔"; position: absolute; left: 0; color: green; font-weight: bold; }
    .btn-container { margin-top: auto; }
    .pay-btn { padding: 10px 25px; background-color: #0078d7; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; width: 100%; }
    .pay-btn:hover { background-color: #005a9e; }

    /* ألوان مميزة لكل باقة */
    .basic { background-color: #f0f8ff; }
    .vip { background-color: #fff4e5; }
    .gold { background-color: #fff0f5; }
    .adv-silver { background-color: #f9f9f9; }
    .adv-gold { background-color: #e5f5ff; }
</style>

</asp:Content>

