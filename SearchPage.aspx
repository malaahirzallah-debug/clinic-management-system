<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SearchPage.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.SearchPage" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>meddnova Medical</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* تحسين عام لكل النصوص */
        body {
            font-family: 'Lato', 'Cairo', sans-serif; /* Lato + خط عربي جميل */
            font-size: 18px; /* أكبر شوي للقراءة */
            line-height: 1.8; /* تباعد مريح بين الأسطر */
            color: #333; /* لون أغمق شوي من الأسود، أريح للعين */
        }

        /* العناوين الكبيرة */
        h1, .title {
            font-size: 42px;
            font-weight: 700;
            line-height: 1.3;
            color: #222;
            margin-bottom: 20px;
        }

        /* العناوين المتوسطة */
        h2, h3, .blob {
            font-size: 28px;
            font-weight: 600;
            line-height: 1.4;
            color: #2c3e50;
        }

        /* النصوص الصغيرة / الفقرات */
        p, .content, .slug {
            font-size: 18px;
            line-height: 1.8;
            color: #444;
        }

        /* القوائم */
        ul li {
            font-size: 16px;
            line-height: 1.6;
        }





        @import url('https://fonts.googleapis.com/css?family=Lato:300,400,900');

        /* general styling */
        * {
            box-sizing: border-box;
        }

        html, body {
            font-family: 'Lato', sans-serif;
            margin: 0;
            padding: 0;
        }

        a {
            text-decoration: none;
            color: black;
        }

        ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
        }

        /* colors */
        :root {
            --green: #3ed1cc;
            --red: #ec2c82;
            --grey: #999;
        }

        .container {
            width: 100%;
            max-width: 90%;
            margin: 0 auto;
        }

        /* Main Header */
        .main-header {
            position: relative;
            background-image: url('/Images/Gemini_Generated_Image_gumrxxgumrxxgumr.png');
            background-size: cover;
            background-position: center center; /* هي اللي بتخلي الصورة بالنص */
        }

            .main-header .overlay {
                background: rgba(62, 209, 204, 0.3);
                padding-bottom: 80px;
            }

        .container header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 50px 0;
        }

            .container header .logo {
                display: flex;
                align-items: center;
            }

                .container header .logo img {
                    max-width: 100%;
                    width: 100px;
                    margin-right: 10px;
                }

                .container header .logo span {
                    font-size: 40px;
                    color: white;
                }

            .container header .nav a {
                display: inline-block;
                padding: 15px 20px;
                margin-left: 20px;
                color: white;
                text-transform: uppercase;
                font-size: 16px;
                transition: all 0.3s ease; /* السلاسة */
            }

                .container header .nav a:hover {
                    background: rgba(0,0,0,0.3);
                    border-radius: 20px;
                    transform: scale(1.1); /* حركة تكبير بسيطة */
                }

                .container header .nav a.active {
                    background: rgba(0,0,0,0.3);
                    border-radius: 20px;
                }

        /* Content */
        .content .content-wrapper {
            text-align: right; /* يحرك النصوص والـ inline elements لليمين */
            margin-left: auto; /* يدعم محاذاة الـ container نفسه للجانب الأيمن */
            margin-right: 0;
            width: 100%;
            max-width: 500px;
        }

        .content .blob {
            font-size: 50px;
            font-weight: 300;
            text-align: left;
            margin-bottom: 20px;
            color: white;
        }

        .content .button-wrapper {
            margin-top: 50px;
            display: flex;
            justify-content: flex-end; /* يحرك الأزرار لليمين */
            gap: 20px; /* بدل margin-right */
        }

            .content .button-wrapper .button {
                margin-right: 20px;
                padding: 25px 30px;
                background: var(--red);
                color: white;
                text-transform: uppercase;
                border-radius: 50px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 400;
                letter-spacing: 2px;
            }

                .content .button-wrapper .button.ask {
                    background: rgba(0,0,0,0.4);
                }

                .content .button-wrapper .button span {
                    margin-left: 20px;
                }

        /* How it Works */
        #how-it-works {
            padding: 100px 0;
        }

            #how-it-works .intro {
                margin-bottom: 100px;
                font-size: 25px;
                color: var(--grey);
                align-items: center;
                display: flex;
                align-items: center;
                justify-content: flex-end;
                gap: 20px;
                text-align: right;
            }

                #how-it-works .intro span {
                    color: var(--green);
                    display: flex;
                    align-items: center;
                    margin-left: 0;
                    margin-right: 20px;
                    text-transform: uppercase;
                    font-size: 16px;
                    font-weight: 900;
                    margin: 0;
                }

                    #how-it-works .intro span i {
                        font-size: 10px;
                        margin-left: 10px;
                    }

            #how-it-works .slug {
                text-transform: uppercase;
                text-align: center;
                color: var(--grey);
                letter-spacing: 2px;
            }

            #how-it-works .title {
                font-size: 50px;
                letter-spacing: 2px;
                text-align: center;
                margin-bottom: 20px;
            }

            #how-it-works .content {
                max-width: 740px;
                width: 90%;
                margin: 0 auto 0px; /* قللت الفراغ */
                text-align: center;
                font-size: 20px;
                line-height: 1.4;
            }


            #how-it-works .icon-wrapper {
                display: flex;
                justify-content: space-around;
                width: 100%; /* بدل 900px */
                max-width: 900px; /* الحد الأقصى */
                margin: 0 auto;
                flex-wrap: wrap; /* السماح بالانتقال لسطر ثاني إذا الشاشة صغيرة */
            }

                #how-it-works .icon-wrapper .icon {
                    text-align: center;
                }

                    #how-it-works .icon-wrapper .icon i {
                        display: inline-block;
                        width: 75px;
                        height: 75px;
                        margin-bottom: 15px;
                        line-height: 75px;
                        border-radius: 50%;
                        background: white;
                        font-size: 30px;
                        box-shadow: 0 5px 10px 3px rgba(0,0,0,0.2);
                        color: var(--green);
                        cursor: pointer;
                        transition: all 0.3s ease-in-out;
                    }

                        #how-it-works .icon-wrapper .icon i:hover {
                            background: var(--green);
                            color: white;
                        }

                    #how-it-works .icon-wrapper .icon p {
                        text-transform: uppercase;
                        font-size: 12px;
                        font-weight: 700;
                        letter-spacing: 2px;
                    }

        /* Question Section */
        #question {
            background: var(--green);
            padding: 150px 0;
            text-align: center;
            color: white;
        }

            #question .title {
                font-size: 40px;
                font-weight: 300;
                margin-bottom: 20px;
            }

            #question .content,
            #question .form {
                width: 100%;
                max-width: 640px;
                margin: 0 auto;
            }

                #question .form input {
                    width: 100%;
                    padding: 20px 0;
                    border-radius: 5px;
                    border: none;
                    outline: none;
                    text-indent: 20px;
                    box-shadow: 0 2px 3px 5px rgba(0,0,0,0.1);
                }

                #question .form i {
                    position: absolute;
                    top: 50%;
                    right: 20px;
                    transform: translateY(-50%);
                    color: var(--green);
                    font-size: 18px;
                }

        #talk {
            padding: 60px 20px; /* فراغ داخلي عام للقسم */
        }

            #talk .col-wrapper {
                display: flex;
                flex-wrap: wrap;
                justify-content: center; /* يوسّط العناصر أفقياً */
                align-items: center; /* يوسّطها عمودياً */
                gap: 40px; /* مسافة بين النص والصورة */
                max-width: 1200px; /* حد أقصى للعرض */
                margin: 0 auto; /* توسيط داخل الصفحة */
            }

            #talk .col-50:first-child {
                order: 2; /* يحرك النص للجانب الأيمن */
                text-align: right; /* كل النصوص يمين */
            }

            #talk .col-50:last-child {
                order: 1; /* يحرك الصورة للجانب الأيسر */
            }

            #talk .options ul {
                padding: 0;
                margin: 0;
                list-style: none;
            }

            #talk .col-50:nth-child(2) {
                background: url('https://stage.webpsychology.com/sites/default/files/article_images/shutterstock_84259324.jpg') top/cover no-repeat;
            }

            #talk .title {
                font-size: 32px;
                margin-bottom: 20px;
            }

            #talk .content {
                font-size: 18px;
                line-height: 1.6;
                margin-bottom: 20px;
            }

            #talk .options li {
                font-size: 14px;
                font-weight: 700;
                margin-bottom: 10px;
                letter-spacing: 2px;
                text-transform: uppercase;
            }

                #talk .options li span {
                    margin-right: 10px;
                    color: var(--green);
                }

        /* Signup Section */
        #signup {
            padding: 100px 0;
            text-align: center;
        }

            #signup .slug {
                text-transform: uppercase;
                color: var(--grey);
                margin-bottom: 20px;
            }

            #signup .title {
                font-size: 40px;
                margin-bottom: 20px;
            }

            #signup .content {
                max-width: 640px;
                margin: 0 auto 50px;
                line-height: 1.5;
            }

            #signup .button-wrapper button {
                outline: none;
                border: 2px solid var(--green);
                background: white;
                color: var(--green);
                padding: 30px 50px;
                margin: 0 20px;
                border-radius: 50px;
                text-transform: uppercase;
                font-size: 16px;
                font-weight: 700;
                letter-spacing: 2px;
                cursor: pointer;
                transition: all 0.3s ease-in-out;
            }

                #signup .button-wrapper button:hover {
                    background: var(--green);
                    color: white;
                }

        /* Footer */
        .footer {
            padding: 50px 0;
        }

            .footer .col-wrapper {
                display: flex;
                flex-wrap: wrap;
                align-items: flex-start;
            }

            .footer .col-1:first-child {
                order: 1;
                text-align: left; /* الصورة تبقى يسار */
            }

            /* باقي الأعمدة (النصوص) على اليمين */
            .footer .col-1:not(:first-child) {
                order: 2;
                text-align: right;
            }

            /* تحريك قائمة الروابط يمين */
            .footer .col-1 ul {
                padding: 0;
                margin: 0;
                list-style: none;
            }

            .footer .col-1 {
                width: 25%;
            }

                .footer .col-1 .logo {
                    display: flex;
                    align-items: center;
                }

                    .footer .col-1 .logo span {
                        font-size: 40px;
                        margin-left: 15px;
                        color: var(--green);
                    }

                    .footer .col-1 .logo img {
                        max-width: 100%;
                        width: 80px;
                    }

                .footer .col-1 li {
                    margin-bottom: 15px;
                }

                    .footer .col-1 li a {
                        font-size: 14px;
                        font-weight: 900;
                        color: var(--grey);
                        transition: all 0.3s ease-in-out;
                    }

                        .footer .col-1 li a:hover {
                            color: var(--green);
                        }

                        .footer .col-1 li a.header {
                            color: black;
                            font-size: 16px;
                            font-weight: 900;
                            letter-spacing: 2px;
                            text-transform: uppercase;
                        }

        /* Social Media */
        #social-media {
            padding: 30px 0;
        }

            #social-media .social-wrapper {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

                #social-media .social-wrapper .copyright {
                    text-transform: uppercase;
                    font-size: 12px;
                    font-weight: 700;
                    color: var(--grey);
                    letter-spacing: 2px;
                }

                #social-media .social-wrapper .icons i {
                    display: inline-block;
                    width: 40px;
                    height: 40px;
                    text-align: center;
                    border: 1px solid var(--grey);
                    margin: 0 10px;
                    border-radius: 50%;
                    line-height: 40px;
                    font-size: 20px;
                    color: var(--green);
                    cursor: pointer;
                    transition: all 0.3s ease-in-out;
                }

                    #social-media .social-wrapper .icons i:hover {
                        background: var(--green);
                        color: white;
                        border: 1px solid white;
                    }

            #social-media .slug {
                display: flex;
                align-items: center;
            }

                #social-media .slug span {
                    color: var(--grey);
                    text-transform: uppercase;
                    font-size: 12px;
                    font-weight: 900;
                }

                #social-media .slug img {
                    max-width: 100%;
                    width: 20px;
                    margin-left: 15px;
                }

        /* Media Queries */
        @media (max-width: 750px) {
            .main-header .app-icons,
            .main-header .nav {
                display: none;
            }

            #talk .col-50 {
                flex: 1 1 45%; /* كل واحد ياخذ حوالي نصف العرض */
                min-width: 300px; /* حد أدنى حتى ما ينضغطوا */
                text-align: right;
            }

                #talk .col-50 img {
                    width: 100%;
                    max-width: 400px;
                    display: block;
                    margin: 0 auto; /* يوسّط الصورة */
                }

            .main-header .menu {
                display: block;
                font-size: 40px;
                color: white;
                cursor: pointer;
            }

            .container .logo img {
                max-width: 100%;
                width: 40px;
            }

            .container .logo span {
                font-size: 30px;
                margin-left: 10px;
            }

            .content .content-wrapper .blob {
                font-size: 40px;
                text-align: center;
            }

            .content .button-wrapper {
                justify-content: center;
            }

            .footer .col-wrapper {
                display: block;
            }

            .footer .col-1 {
                width: 90%;
                text-align: center;
                margin-bottom: 20px;
            }

                .footer .col-1 .logo {
                    justify-content: center;
                }

            #social-media .social-wrapper {
                display: block;
                text-align: center;
            }

            #how-it-works .icon-wrapper {
                display: block;
                width: 100%;
            }

            #question .form {
                max-width: 360px;
            }

            #talk .col-wrapper {
                display: block;
            }

            #talk .col-50 {
                width: 100%;
                padding: 20px 0;
            }

            #signup .button-wrapper button {
                padding: 20px 20px;
                font-size: 12px;
                margin: 0 5px;
            }
        }
        /* Reset box-sizing */
        * {
            box-sizing: border-box;
            position: relative;
            font-family: 'Open Sans', sans-serif;
        }

        /* body class */
        .no-scroll {
            overflow: hidden;
        }

        /* Staff list */
        .staff {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            list-style: none;
            padding: 0;
            margin: 0 auto;
        }

            /* Default: الكمبيوتر الكبير */
            .staff li {
                flex: 1 1 calc(16.66% - 20px); /* 6 بجانب بعض + مسافة */
                margin: 10px;
                text-align: center;
                cursor: pointer;
                border-radius: 10px;
            }

                .staff li .picture-wrapper {
                    position: relative;
                    width: 80%;
                    margin: 0 auto 20px auto;
                    padding-top: 80%;
                    border-radius: 100%;
                    overflow: hidden;
                }

                    .staff li .picture-wrapper .picture {
                        position: absolute;
                        top: 0;
                        width: 100%;
                        height: 100%;
                        border-radius: 100%;
                        background-size: 150%;
                        background-position: center;
                        transition: background-size 750ms;
                    }

                .staff li .name {
                    font-size: 1.1em;
                    margin-bottom: 3px;
                }

                .staff li:not(.no-hover):hover {
                    background-color: #eee;
                }

                    .staff li:not(.no-hover):hover .picture-wrapper .picture {
                        background-size: 180%;
                    }

                .staff li .title {
                    font-size: 1.3em;
                    margin-bottom: 3px;
                }
        /* Media queries */
        @media screen and (max-width: 1024px) {
            .staff li {
                flex: 1 1 calc(25% - 20px); /* 4 بجانب بعض */
            }
        }

        @media screen and (max-width: 768px) {
            .staff li {
                flex: 1 1 calc(50% - 20px); /* 3 بجانب بعض */
            }
        }

        /* للأجهزة الصغيرة (موبايل) */
        @media screen and (max-width: 500px) {
            .staff li {
                width: 30%; /* تقريبًا 3 عناصر في الصف */
                margin: 1%; /* مسافة بسيطة بين العناصر */
            }
        }


        /* Card popup */
        .card {
            display: none;
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
        }

        .card__exit {
            position: absolute;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
        }

        .card__content {
            position: relative;
            width: 45%;
            min-height: 80vh;
            max-height: 100vh;
            overflow-y: scroll;
            background: white;
            padding: 40px 50px;
            box-sizing: border-box;
            z-index: 10;
            border-radius: 5px;
            box-shadow: 2px 2px 50px rgba(0,0,0,.2);
            transition: width 500ms;
        }

            .card__content .exit {
                position: absolute;
                top: 17px;
                right: 17px;
                cursor: pointer;
                opacity: 0.5;
                transition: opacity 250ms;
            }

                .card__content .exit:hover {
                    opacity: 1;
                }

            .card__content .profile {
                display: flex;
                align-content: center;
            }

            .card__content .profile__picture {
                background-position: center;
                background-size: cover;
                border-radius: 100%;
                height: 80px;
                width: 80px;
                margin-right: 12px;
            }

            .card__content .info {
                display: flex;
                flex-direction: column;
                justify-content: center;
            }

            .card__content .info__name {
                font-weight: bold;
                font-size: 1.2em;
            }

        /* Card responsive */
        @media screen and (max-width: 1100px) {
            .card__content {
                width: 60%;
            }
        }

        @media screen and (max-width: 800px) {
            .card__content {
                width: 80%;
            }
        }

        @media screen and (max-width: 500px) {
            .card__content {
                width: 90%;
            }
        }

        /* Show card */
        .card[aria-hidden="false"] {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Blur effect */
        .blur {
            transition: all 500ms;
        }

        .blur--active {
            filter: blur(10px);
            transform: translateZ(0);
        }
        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            height: 100%;
            background: #f7f7f7;
            padding: 20px;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            z-index: 100;
            overflow-y: auto;
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }

            .sidebar.show {
                transform: translateX(0);
            }

        .sidebar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

            .sidebar-header .close-sidebar {
                cursor: pointer;
                font-size: 1.5em;
            }

        .sidebar-content label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .sidebar-content input,
        .sidebar-content select {
            width: 100%;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        @media screen and (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .wrapper {
                margin-left: 0 !important;
            }
        }

        .hidden {
            display: none !important;
        }
        /* تكست بوكسات البحث */
.filters {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 30px;
}

.filters input[type="text"],
.filters input[type="search"],
.filters input[type="tel"] {
    flex: 1;
    padding: 12px 15px;
    font-size: 16px;
    border: 2px solid #ccc;
    border-radius: 8px;
    outline: none;
    text-align: right; /* النصوص على اليمين */
    direction: rtl; /* يدعم العربية بالكامل */
    transition: all 0.3s ease;
}

.filters input[type="text"]:focus,
.filters input[type="search"]:focus,
.filters input[type="tel"]:focus {
    border-color: var(--green);
    box-shadow: 0 0 8px rgba(62, 209, 204, 0.5);
}

    </style>
</head>
<body>

    <section class="main-header">
        <div class="overlay">
            <div class="container">
                <header>
                    <div class="logo">
                        <img src="Images/Unt1234555itled.png" alt="">
                        <span>meddnova</span>
                    </div>
                    <div class="nav">
                        <a href="home.aspx">Home</a>
                        <a href="AddClinic.aspx">Register</a>
                        <a href="LoginPage.aspx">Login</a>
                        <a href="SearchPage.aspx">Search</a>
                    </div>
                    <%--                    <div class="menu"><i class="fa fa-bars"></i></div>--%>
                </header>
                <div class="content">
                    <div class="content-wrapper">
                        <h2 class="blob">اعثر على أفضل العيادات والأطباء بسهولة وسرعة</h2>
                        <div class="button-wrapper">
                            <div class="button work">كيف يعمل الموقع <span><i class="fa fa-arrow-down"></i></span></div>
                            <div class="button ask">سجل كطبيب للاستفادة من خدماتنا</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <form id="form1" runat="server">
        <div class="container">
            <h1>ابحث عن طبيب أو عيادة</h1>

            <div class="filters">
                <asp:TextBox ID="txtDoctorName" runat="server" placeholder="ابحث باسم الطبيب..." AutoPostBack="true" OnTextChanged="Filters_Changed"></asp:TextBox>

                <asp:TextBox ID="txtLocation" runat="server" placeholder="ابحث بالمدينة أو المنطقة..." AutoPostBack="true" OnTextChanged="Filters_Changed"></asp:TextBox>

                <asp:TextBox ID="txtSpecialization" runat="server" placeholder="ابحث بالتخصص..." AutoPostBack="true" OnTextChanged="Filters_Changed"></asp:TextBox>

                <asp:TextBox ID="txtPhone" runat="server" placeholder="ابحث برقم الهاتف..." AutoPostBack="true" OnTextChanged="Filters_Changed"></asp:TextBox>
            </div>

            <div class="results" id="resultsContainer" runat="server">
            </div>
        </div>

    </form>


    <section class="footer">
        <div class="container">
            <div class="col-wrapper">
                <div class="col-1">
                    <div class="logo">
                        <img src="Images/Unt1234555itled.png" alt="">
                        <span>meddnova</span>
                    </div>
                </div>
                <div class="col-1">
                    <ul>
                        <li><a href="" class="header">للمرضى</a></li>
                        <li><a href="">ابحث عن طبيب</a></li>
                        <li><a href="">حجز موعد</a></li>
                    </ul>
                </div>
                <div class="col-1">
                    <ul>
                        <li><a href="" class="header">للطبيب</a></li>
                        <li><a href="">تسجيل</a></li>
                        <li><a href="">لوحة التحكم</a></li>
                        <li><a href="">صفحة احترافية</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <section id="social-media">
        <div class="container">
            <div class="social-wrapper">
                <div class="copyright">Copyright &copy; 2016f</div>
                <div class="icons">
                    <i class="fa fa-facebook"></i>
                    <i class="fa fa-twitter"></i>
                </div>
                <div class="slug">
                    <span>Made with Love By</span>
                    <img src="Images/Unt1234555itled.png" alt="">
                </div>
            </div>
        </div>
    </section>

</body>

<script>
    'use strict';
    console.clear();
    document.addEventListener('DOMContentLoaded', () => {
        const staffContainer = document.getElementById('resultsContainer');

        staffContainer?.addEventListener('click', (e) => {
            const staffMember = e.target.closest('li');
            if (!staffMember) return;

            const url = staffMember.dataset.url;
            if (url) {
                window.location.href = url; // ينقل مباشرة للصفحة
            }
        });
    });

</script>
</html>
