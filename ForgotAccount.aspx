<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ForgotAccount.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.ForgotAccount" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>نسيت بيانات الحساب</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #3498db, #8e44ad);
            background-attachment: fixed;
        }

        .wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            width: 400px;
            max-width: 100%;
            background: rgba(255, 255, 255, 0.95);
            padding: 35px 30px;
            border-radius: 15px;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.25);
            text-align: center;
        }

            .container h2 {
                margin-bottom: 20px;
                color: #2c3e50;
                font-size: 22px;
            }

            .container p {
                font-size: 15px;
                color: #555;
                margin-bottom: 20px;
            }

            .container input[type=text],
            .container input[type=submit] {
                width: 100%;
                padding: 14px;
                margin: 10px 0;
                border: 1px solid #ccc;
                border-radius: 8px;
                box-sizing: border-box;
                font-size: 16px;
            }

            .container input[type=submit] {
                background: #27ae60;
                color: white;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
            }

                .container input[type=submit]:hover {
                    background: #219150;
                }

        .back-link {
            display: block;
            margin-top: 15px;
            font-size: 14px;
            text-decoration: none;
            color: #3498db;
        }

            .back-link:hover {
                text-decoration: underline;
            }

        .msg {
            margin-top: 10px;
            font-size: 14px;
            color: #e74c3c;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="wrapper">
            <div class="container">
                <h2>استرجاع بيانات الحساب</h2>
                <p>أدخل بريدك الإلكتروني وسنرسل لك بيانات العيادة والمستخدم ورابط إعادة تعيين كلمة المرور.</p>

                <asp:TextBox ID="txtEmail" runat="server" placeholder="البريد الإلكتروني"></asp:TextBox>
                <asp:Button ID="btnRecover" runat="server" Text="إرسال" OnClick="btnRecover_Click" />
                <asp:Label ID="lblMsg" runat="server" CssClass="msg"></asp:Label>

                <a href="LoginPage.aspx" class="back-link">العودة لتسجيل الدخول</a>
            </div>
        </div>
    </form>
</body>
</html>
