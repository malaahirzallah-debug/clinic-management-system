<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="clinicdetails.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.clinicdetails" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Clinic Website</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- استدعاء خط Cairo من Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700;900&display=swap" rel="stylesheet">
    <style>
        body, p, span, a, li, div, input, textarea, button {
            font-family: Cairo;
            font-weight: 400;
        }

        html, body {
            overflow-x: hidden;
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: Cairo;
            font-weight: 400;
        }

        strong, b {
            font-weight: 700;
        }

        .btn {
            font-family: Cairo;
            font-weight: 600;
        }

        .hero .hero__content h1 {
            font-family: Cairo;
            font-weight: 500;
        }

        .hero-over-card__content h1 {
            font-family: Cairo;
            font-weight: 500;
        }

        .text-wrapper h1, .text-wrapper p {
            font-family: Cairo;
        }

        strong, b {
            font-weight: 500;
        }

        body {
            overflow-x: hidden;
        }

        button {
            background: none;
            border: none;
            outline: none;
            cursor: pointer;
        }

            button:focus {
                outline: none;
            }

        .btn {
            border: 2px solid;
            border-radius: 2px;
            padding: 5px 20px;
            transition: 300ms ease-in-out;
            color: #515050;
            border-color: #515050;
            background-color: transparent;
            margin: 5px;
            box-shadow: none;
        }

            .btn:focus {
                box-shadow: none;
            }

            .btn:hover {
                background-color: #515050;
                color: #fff;
            }

            .btn:active {
                border-color: #868686;
                background: #868686;
            }

            .btn.btn--filled {
                color: #fff;
                border: #515050;
                background: #515050;
            }

                .btn.btn--filled:hover {
                    border-color: #3f3f40; /* darken #515050 by 20% */
                    background: #3f3f40;
                }

                .btn.btn--filled:active {
                    border-color: #868686;
                    background: #868686;
                }

            .btn.btn--primary {
                color: #1187c5;
                border-color: #1187c5;
                background-color: #fff;
            }

                .btn.btn--primary:hover {
                    background-color: #1187c5;
                    color: #fff;
                }

                .btn.btn--primary:active {
                    border-color: #5ba3d6;
                    background: #5ba3d6;
                }

                .btn.btn--primary.btn--filled {
                    color: #fff;
                    border-color: #1187c5;
                    background: #1187c5;
                }

                    .btn.btn--primary.btn--filled:hover {
                        border-color: #0e6b9f; /* darken #1187c5 by 20% */
                        background: #0e6b9f;
                    }

                    .btn.btn--primary.btn--filled:active {
                        border-color: #5ba3d6;
                        background: #5ba3d6;
                    }

            .btn.btn--accent {
                color: #99a833;
                border-color: #99a833;
                background-color: #fff;
            }

                .btn.btn--accent:hover {
                    background-color: #99a833;
                    color: #fff;
                }

                .btn.btn--accent:active {
                    border-color: #c6d363;
                    background: #c6d363;
                }

                .btn.btn--accent.btn--filled {
                    color: #fff;
                    border: #99a833;
                    background: #99a833;
                }

                    .btn.btn--accent.btn--filled:hover {
                        border: #7a7e29;
                        background: #7a7e29;
                    }

                    .btn.btn--accent.btn--filled:active {
                        border-color: #c6d363;
                        background: #c6d363;
                    }

            .btn.btn--white {
                color: #fff;
                border-color: #fff;
                background-color: transparent;
            }

                .btn.btn--white:hover {
                    background-color: #fff;
                    color: #99a833;
                }

                .btn.btn--white:active {
                    border-color: #c6d363;
                    background: #c6d363;
                }

                .btn.btn--white.btn--filled {
                    color: #fff;
                    border: #99a833;
                    background: #99a833;
                }

                    .btn.btn--white.btn--filled:hover {
                        border: #7a7e29;
                        background: #7a7e29;
                    }

                    .btn.btn--white.btn--filled:active {
                        border-color: #c6d363;
                        background: #c6d363;
                    }

            .btn.btn--block {
                display: block;
                width: 100%;
            }

            .btn.btn--large {
                font-size: 1.2rem;
            }

            .btn.btn--x-large {
                font-size: 1.4rem;
            }

            .btn.btn--small {
                font-size: 0.8rem;
            }

            .btn.btn--icon-left span {
                padding-right: 5px;
                margin-right: 5px;
                position: relative;
            }

                .btn.btn--icon-left span:after {
                    content: "";
                    position: absolute;
                    right: 0;
                    top: 25%;
                    bottom: 25%;
                    border-right: 1px solid;
                    opacity: 0.3;
                }

            .btn.btn--icon-right span {
                padding-left: 5px;
                margin-left: 5px;
                position: relative;
            }

                .btn.btn--icon-right span:after {
                    content: "";
                    position: absolute;
                    left: 0;
                    top: 25%;
                    bottom: 25%;
                    border-left: 1px solid;
                    opacity: 0.3;
                }

            .btn.btn--rounded {
                border-radius: 20px;
            }

        .hero {
            height: 70vh;
            background-position: center center;
            background-repeat: no-repeat;
            background-size: cover;
            position: relative;
            display: flex;
            align-items: center;
            color: #fff;
            position: relative;
            padding-left: 80px; /* مساحة من اليمين */
            justify-content: flex-start; /* يدفع المحتوى للشمال */
            text-align: left; /* يجعل النص محاذي يمين */
            z-index: 0;
        }

            .hero:before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(62, 209, 204, 0.3); /* قللت الشفافية */
                pointer-events: none; /* يسمح بالنقر على الأزرار والنصوص */
                z-index: 0;
            }

            .hero .hero__content {
                height: 100%;
                position: relative;
                max-width: 600px;
                z-index: 10000;
            }

                .hero .hero__content h1 {
                    margin: 0;
                    font-size: 5rem; /* حجم كبير للنص */
                    line-height: 1.1;
                    font-weight: 700;
                }

                .hero .hero__content .lead {
                    font-weight: bold;
                }

                .hero .hero__content .btn {
                    margin-top: 8rem;
                }

        .hero-over-card__section {
            position: relative;
            margin-top: -150px;
            z-index: 10;
        }

            .hero-over-card__section .hero-over-card {
                position: absolute;
                top: 50px;
                left: 300px; /* بدل right خلي left */
                width: 300px;
                height: 300px;
                padding: 20px;
                box-shadow: 15px 30px 90px rgba(0, 0, 0, 0.5);
                text-align: center;
                background: #fff;
                border-radius: 0px;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }

                .hero-over-card__section .hero-over-card .hero-over-card__content h1 {
                    font-size: 2.8rem; /* حجم أكبر */
                    font-weight: 700;
                    margin-bottom: 15px;
                    line-height: 1.2;
                }

                .hero-over-card__section .hero-over-card .hero-over-card__content p {
                    font-size: 1.2rem;
                    margin-bottom: 25px;
                    color: #555;
                }

                .hero-over-card__section .hero-over-card .btn {
                    font-size: 1.2rem;
                    padding: 12px 20px;
                    align-self: center;
                    max-width: 160px;
                }

                .hero-over-card__section .hero-over-card .hero-over-card__content {
                    max-width: 100%;
                }

        .overlap-images img {
            position: absolute;
            box-shadow: 0 5px 30px rgba(0,0,0,0.3);
            object-fit: cover; /* قص الصورة إذا طولها كبير */
            border-radius: 10px;
        }

        .overlap-images {
            position: relative;
            width: 100%;
            max-width: 500px;
            height: 600px;
            margin: auto;
        }

            .overlap-images img:first-child {
                width: 85%;
                box-shadow: 15px 30px 90px rgba(0, 0, 0, 0.5);
                height: 89%;
                top: 3.8%;
                left: 5.8%; /* تعديل الموضع على اليمين */
                z-index: 1;
                border-radius: 0px;
            }

            .overlap-images img:last-child {
                width: 75%;
                height: 85%;
                top: -50%;
                left: -12%;
                z-index: 2;
                box-shadow: 0 12px 40px rgba(0,0,0,0.5);
                border-radius: 0px;
                background-color: #fff;
                /*object-fit: fill;*/
                object-fit: cover;
            }

        .back-dots {
            position: relative;
        }

            .back-dots:before {
                content: '';
                position: absolute;
                display: block;
                width: 100%;
                height: 100%;
                top: 0;
                left: 0;
                z-index: 0;
                background-image: url('https://demo.curlythemes.com/dentist-wp/wp-content/plugins/xtender/assets/front/svg/dots-black.svg');
                background-repeat: repeat;
                background-size: 20px 20px;
                border-radius: 0px;
                right: 0;
                left: auto;
            }

            .back-dots img {
                position: relative;
                z-index: 1;
                width: 100%;
                height: auto;
                display: block;
                border-radius: 10px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.3);
            }

        .random-people__image-wrapper {
            position: relative;
            overflow: hidden;
            border-radius: 0px;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
        }

            .random-people__image-wrapper:before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: #111;
                opacity: 0.3;
                transition: opacity 0.3s ease-in-out;
                z-index: 1;
            }

            .random-people__image-wrapper img {
                width: 100%;
                height: 500px;
                object-fit: cover;
                display: block;
                border-radius: 0px;
                position: relative;
                z-index: 2;
            }

            .random-people__image-wrapper:hover {
                transform: scale(1.1);
                box-shadow: 5px 5px 30px rgba(0,0,0,0.5);
                z-index: 10;
            }

                .random-people__image-wrapper:hover:before {
                    opacity: 0;
                }

        .white-box-1 {
            position: relative;
        }

            .white-box-1:after {
                content: '';
                position: absolute;
                width: 100px;
                height: 100px;
                background: white;
                top: -50px;
                right: 0px;
                z-index: -2;
                box-shadow: 10px 10px 30px 0px #aaa;
            }

        .cool-shadow {
            box-shadow: 10px 10px 30px 0px #aaa;
        }

        img {
            max-width: 100%;
        }

        .layout-2__content {
            position: relative;
        }

        .random-blocks .block-1 {
            position: absolute;
            width: 150px;
            height: 150px;
            box-shadow: 20px 20px 100px 0px #555;
            z-index: -1;
            top: 30%;
            left: 10%;
        }

        .random-blocks .block-2 {
            position: absolute;
            width: 100px;
            height: 100px;
            box-shadow: 20px 20px 100px 0px #555;
            z-index: -1;
            top: 0%;
            right: -10%;
        }

        .random-blocks .block-3 {
            position: absolute;
            width: 100px;
            height: 100px;
            box-shadow: 20px 20px 100px 0px #555;
            z-index: -1;
            bottom: -10%;
            left: -10%;
        }

        .layout-4 {
            position: relative;
        }

        .layout-4__content {
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: center;
            position: relative;
        }

        .content__random-block {
            position: absolute;
            height: 120px;
            width: 120px;
            z-index: -1;
            box-shadow: 20px 20px 100px 0px #999;
            background: #fff;
            top: 0;
            right: 0;
        }

        .layout-4__icons {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-wrap: wrap;
            background-color: #fff;
            padding: 60px 30px;
            box-shadow: 10px 10px 50px 0px #999;
            margin: 100px 0px;
        }

            .layout-4__icons span {
                color: #1187c5;
                width: 25%;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                margin: 10px 0px;
            }

        h1.display-4 {
            font-size: 3rem;
            font-weight: 700;
            line-height: 1.1;
            color: #222;
            margin-bottom: 1rem;
        }

        .display-4 strong {
            font-size: 4.5rem;
            font-weight: 900;
        }

        p.lead {
            font-weight: bold;
            font-size: 1.25rem;
            color: #444;
            margin-bottom: 1rem;
        }

        .custom-container {
            padding-top: 350px;
        }

        .flex-row {
            display: flex;
            gap: 30px;
            align-items: flex-start;
            flex-wrap: wrap;
        }

        .images-wrapper {
            flex: 0 0 750px;
            max-width: 700px;
            position: relative;
            height: 600px;
        }

            .images-wrapper img {
                position: absolute;
                box-shadow: 0 5px 30px rgba(0,0,0,0.3);
                object-fit: cover;
                border-radius: 10px;
            }

                .images-wrapper img:first-child {
                    width: 90%;
                    height: auto;
                    top: 0;
                    left: 0;
                    z-index: 2;
                }

                .images-wrapper img:last-child {
                    width: 75%;
                    height: auto;
                    bottom: 0;
                    right: 0;
                    z-index: 1;
                }

        .text-wrapper {
            flex: 1;
            min-width: 300px; /* عشان ما يصغر كتير */
            text-align: right; /* النص يكون على اليمين */
            margin-left: 0; /* إزالة أي مسافة على اليسار */
            margin-right: 60px; /* لو تحب تبعده شوي عن الحافة اليمنى */
        }

        .container.back-dots {
            padding: 40px;
        }

        @media (max-width: 768px) {
            .flex-row {
                flex-direction: column;
                align-items: center;
            }

            .images-wrapper {
                flex: 0 0 auto;
                max-width: 90vw;
                height: auto;
                position: relative;
                margin-bottom: 20px;
            }

                .images-wrapper img {
                    position: relative;
                    width: 100% !important;
                    height: auto !important;
                    margin-bottom: 10px;
                }

            .text-wrapper {
                min-width: auto;
                text-align: center;
            }

            .overlap-images {
                max-width: 100%;
                height: 450px;
            }

                .overlap-images img:first-child {
                    width: 60%;
                }

                .overlap-images img:last-child {
                    width: 50%;
                    top: 15px;
                    left: 35%;
                }

            h1.display-4 {
                font-size: 2rem;
                text-align: center;
            }

            p.lead, p {
                font-size: 1rem;
                text-align: center;
            }

            .overlap-images {
                max-width: 300px;
                height: 220px;
            }

                .overlap-images img:first-child {
                    width: 75%;
                }

                .overlap-images img:last-child {
                    width: 55%;
                }

            .hero-over-card__section {
                margin-bottom: 30px;
            }

            .hero-over-card__section {
                margin-top: 30px; /* يزيل التراكب */
                z-index: auto;
            }

                .hero-over-card__section .hero-over-card {
                    position: static; /* يخرج من التراكب */
                    width: 90%; /* يعرض بعرض مناسب */
                    height: auto;
                    padding: 30px;
                    margin: 20px auto 0;
                    box-shadow: 10px 10px 50px rgba(0, 0, 0, 0.1);
                    display: block;
                    justify-content: normal;
                }
        }

        .layout-4__icons span {
            width: 50%;
        }

        .layout-5 .layout-5__before-after {
            margin: 0 auto;
        }

        .twentytwenty-before-label:before, .twentytwenty-after-label:before {
            content: '';
        }

        .moving-bg {
            background: #99a833;
            background-size: contain;
            background-repeat: repeat;
            background-position: 0%;
            animation: 20s moveBackground linear infinite;
            color: #fff;
            text-align: center;
            padding: 100px 0px;
        }

        .twentytwenty-container {
            max-width: 700px;
            margin: 50px auto;
        }

        #google-map {
            box-shadow: 20px 20px 100px 0px #555;
        }

        @keyframes moveBackground {
            0% {
                background-position: 0%;
            }

            100% {
                background-position: -100%;
            }
        }

        @media (max-width: 768px) {
            .flex-row.flex-row-reverse {
                flex-direction: column; /* الصورة والنص فوق بعض */
                align-items: flex-start; /* يخلي الصور تلتزم باليمين بدل النص */
            }

            .overlap-images {
                width: 130%;
                height: 500px; /* ارتفاع محدد للصورة الأولى */
                position: relative; /* ضروري للتراكب */
                margin-bottom: 190px; /* مسافة بين الصور والنص */
                margin-top: -370px;

                margin-left: auto; /* يدفع العنصر لليمين */
        margin-right: 0;
            }

                .overlap-images img:last-child {
                    width: 85%; /* عرض محدد كما تحب */
                    height: 500px; /* ارتفاع ثابت */
                    object-fit: fill; /* stretch لتملأ الإطار */
                    top: -50%; /* رفع الصورة الثانية فوق الصورة الأولى */
                    left: -37%; /* محاذاة للصورة */
                    position: relative;
                }

            .back-dots {
                background-position: right !important;
            }

            .text-wrapper {
                text-align: center; /* النص يصبح تحت الصورة ومرتب */
                width: 100%;
                margin: 0;
                margin-bottom: -180px;
            }
        }

        @media (max-width: 768px) {
            .hero-over-card__section .hero-over-card {
                position: static; /* يخرج من الـ absolute */
                margin: 20px auto; /* يجعل العنصر في منتصف الصفحة */
                width: 70%; /* يعرض بشكل مناسب للموبايل */
                height: auto; /* ارتفاع تلقائي حسب المحتوى */
                padding: 30px;
                box-shadow: 10px 10px 50px rgba(0, 0, 0, 0.5);
                display: flex;
                justify-content: center;
                text-align: center;
            }

            .hero-over-card__content h1 {
                font-size: 2rem; /* حجم أصغر للنص */
            }

            .hero-over-card__content p {
                font-size: 1rem;
            }

            .hero-over-card__section {
                margin-top: -100px; /* أو مسافة صغيرة مناسبة */
            }
        }

        @media (max-width: 767px) {
            .main-header .app-icons,
            .main-header .nav {
                display: none;
            }

            .layout-2__content {
                padding: 15px; /* تخفف التزاحم */
                word-wrap: break-word;
            }

            .random-blocks {
                max-width: 100%;
                overflow: hidden;
            }

            .special-back-dots {
                margin-top: 200px;
            }
        }

        .bold-label {
            font-weight: bold;
            font-size: 5.5rem;
            color: #222 !important; /* أسود صريح */
            opacity: 1 !important; /* يلغي أي شفافية */
            line-height: 1.6; /* يوسع الأسطر */
            letter-spacing: 0.5px;
        }

        .doctor-profile-text {
            font-size: 1.3rem; /* حجم أكبر */
            line-height: 1.5; /* مسافة بين الأسطر */
            color: #333 !important;
        }

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

            .container header .nav a {
                display: inline-block;
                padding: 15px 20px;
                margin-left: 20px;
                color: white;
                text-transform: uppercase;
                font-size: 16px;
                transition: all 0.3s ease; /* السلاسة */
                text-decoration: none;
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

        .map-wrapper {
            position: relative;
            display: inline-block;
        }

            .map-wrapper img {
                border-radius: 10px;
            }

            .map-wrapper::after {
                /*content: "اضغط لفتح الخريطة";*/
                position: absolute;
                bottom: 10px;
                left: 50%;
                transform: translateX(-50%);
                background: rgba(0,0,0,0.6);
                color: #fff;
                padding: 5px 10px;
                border-radius: 5px;
                font-size: 0.9rem;
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
                </header>
                <div class="row flex-row-reverse">
                    <div class="col-xl-6 col-lg-8">
                        <div class="hero__content text-end">
                            <p class="lead">مرحباً بك في صفحة الطبيب الشخصية</p>
                            <h1 class="display-1"><span style="color: white;">نحن هنا لخدمتكم</span></h1>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section class="hero-over-card__section">
        <div class="container">
            <div class="row">
                <div class="offset-md-4 col-md-8 offset-lg-6 col-lg-6 offset-xl-6 col-xl-5">
                    <div class="hero-over-card">
                        <div class="hero-over-card__content">
                            <h1 class="display-4">خطط لزيارتك الآن</h1>
                            <p>ابدأ رحلتك نحو صحة أفضل</p>
                            <a href="#" class="btn btn--accent btn--filled btn--large">احجز موعدك</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <div class="custom-container mt-5">
        <div class="flex-row flex-row-reverse">
            <div class="overlap-images back-dots">
                <img src="Images/Gemini_Generated_Image_i1zm7ji1zm7ji1zm.png" alt="image1">
                <asp:Image ID="imgDoctor" runat="server" CssClass="img-fluid" />
            </div>
            <div class="text-wrapper text-end">
                <h1 class="display-4">مرحباً بكم في
                    <asp:Label ID="lblDoctorName" runat="server" CssClass="bold-label"></asp:Label>
                </h1>
                <p class='doctor-profile-text'>
                    <asp:Label ID="lblNotes" runat="server"></asp:Label>
                </p>
                <div class="doctor-profile">
                    <asp:Literal ID="ltDoctorProfile" runat="server"></asp:Literal>
                </div>

                <p class='doctor-profile-text'>
                    <strong>العنوان</strong>
                    <asp:Label ID="lblAddress" runat="server"></asp:Label>
                </p>
                <p class='doctor-profile-text'>
                    <strong>الهاتف</strong>
                    <asp:Label ID="lblPhone" runat="server"></asp:Label>
                </p>

                <p class='doctor-profile-text'>
                    <strong>الايميل</strong>
                    <asp:Label ID="lblEmail" runat="server"></asp:Label>
                </p>

                <p class='doctor-profile-text'>
                    <strong>الموقع الإلكتروني</strong>
                    <asp:HyperLink ID="lblWebsite" runat="server"></asp:HyperLink>
                </p>
                <p class='doctor-profile-text'><a href="#">رابط الحجز الإلكتروني</a></p>


            </div>
        </div>

        <div class="container py-5 back-dots special-back-dots">
            <asp:Literal ID="ltClinicImages" runat="server"></asp:Literal>
        </div>

        <section class="about-our-dentist py-5">
            <div class="container">
                <div class="row">
                    <div class="col-md-6 back-dots">
                        <br />
                        <img class="cool-shadow" src="Images/Gemini_Generated_Image_gorp5jgorp5jgorp.png" alt="" style="width: 96%; height: 95%;">
                    </div>
                    <div class="col-md-6 offset-md-0 col-xl-4 offset-xl-1">
                        <div class="layout-2__content">
                            <div class="random-blocks"><span class="block-1"></span><span class="block-2"></span><span class="block-3"></span></div>
                            <br />
                            <br />
                            <br />
                            <br />
                            <br />
                            <br />
                            <h1 class="display-4"><strong>عن عيادتنا</strong></h1>
                            <hr>
                            <p class="lead">عملاؤنا هم أولويتنا، نحن نقدم خدمات طبية متكاملة بجودة عالية وفريق من الأخصائيين المتخصصين في جميع التخصصات الصحية.</p>
                            <p>نسعى لتقديم أفضل رعاية صحية لكل أفراد الأسرة، مع التركيز على راحة المرضى وتوفير بيئة علاجية حديثة وآمنة.</p>
                            <p>نؤمن بأن الصحة الجيدة تبدأ من العناية الشاملة، ونعمل دائماً على تقديم الحلول الطبية التي تلبي احتياجاتكم وتضمن رضاكم التام.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section class="layout-4 py-5">
            <div class="container">
                <div class="row">
                    <div class="col-lg-5">
                        <div class="layout-4__content">
                            <div class="content__random-block"></div>
                            <h1 class="display-4">اكتشف
                            <br>
                                <strong>عيادتنا الطبية المتكاملة</strong> </h1>
                            <hr>
                            <p class="lead">عملاؤنا هم أولويتنا، نقدم خدمات طبية عالية الجودة لجميع التخصصات الصحية مع فريق متخصص ومؤهل لضمان أفضل رعاية.</p>
                            <button class="btn btn--accent btn--large">احجز موعدك الآن</button>
                        </div>
                    </div>
                    <div class="col-lg-7 back-dots">
                        <div class="map-wrapper">
                            <p class="doctor-profile-text"><strong>موقع العيادة:</strong></p>
                            <a id="mapLink" runat="server" target="_blank">
                                <asp:Literal ID="ltClinicMap" runat="server"></asp:Literal>

                                    AlternateText="اضغط لفتح الخريطة" />
                            </a>
                        </div>
                    </div>

                </div>
            </div>
        </section>
    </div>
    <!-- Footer -->
    <footer class="bg-dark text-center text-white py-4">
        <div class="container">
            <div class="social-icons">
                <asp:Repeater ID="rptSocialLinks" runat="server">
                    <ItemTemplate>
                        <a href='<%# Eval("URL") %>' target="_blank" class="text-white mx-2">
                            <i class="fa fa-<%# Eval("SocialType").ToString().ToLower() %> fa-2x"></i>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </footer>
</body>
</html>


<%--<script>
            function initMap() {
                const clinicLocation = { lat: 31.963158, lng: 35.930359 }; // عمان، الأردن
                const map = new google.maps.Map(document.getElementById("clinicMap"), {
                    zoom: 15,
                    center: clinicLocation
                });
                const marker = new google.maps.Marker({
                    position: clinicLocation,
                    map: map,
                    title: "موقع العيادة"
                });
            }
        </script>
                <script async defer
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBe4uxkSSyfqTwMDHnEV7iTe-_MuYQcSj8&callback=initMap">
        </script>--%>