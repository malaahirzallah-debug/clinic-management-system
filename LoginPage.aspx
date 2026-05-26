<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LoginPage.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.LoginPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Clinic Dashboard - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        /* ===== Body & Base ===== */
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-image: url('/images/logo2.png');
            background-repeat: no-repeat;
            background-position: center center;
            background-size: auto 150%;
            background-attachment: fixed;
        }

        /* ===== Wrapper ===== */
        .login-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        /* ===== Login Container ===== */
        .login-container {
            width: 380px;
            max-width: 100%;
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 30px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.3);
            text-align: center;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

            .login-container h2 {
                margin-bottom: 25px;
                color: #2c3e50;
                font-size: 24px;
            }

            /* ===== Inputs & Buttons ===== */
            .login-container input[type=text],
            .login-container input[type=password],
            .login-container input[type=number],
            .login-container input[type=submit],
            .login-container .btn-secondary {
                width: 100%;
                padding: 14px;
                margin: 12px 0;
                border: 1px solid #ccc;
                border-radius: 8px;
                box-sizing: border-box;
                font-size: 16px;
            }

            .login-container input[type=submit] {
                background: #27ae60;
                color: white;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
            }

                .login-container input[type=submit]:hover {
                    background: #219150;
                }

            .login-container .btn-secondary {
                background: #3498db;
                color: white;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
            }

                .login-container .btn-secondary:hover {
                    background: #2980b9;
                }

        /* ===== Options & Errors ===== */
        .login-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 10px 0;
            font-size: 14px;
            flex-wrap: wrap;
        }

            .login-options label {
                display: flex;
                align-items: center;
                cursor: pointer;
            }

            .login-options input[type=checkbox] {
                margin-right: 5px;
            }

        .login-container .forgot-password {
            display: block;
            margin-top: 5px;
            font-size: 14px;
            text-decoration: none;
            color: #e74c3c;
        }

            .login-container .forgot-password:hover {
                text-decoration: underline;
            }

        .error {
            color: red;
            margin-top: 10px;
            font-size: 14px;
        }

        .show-password {
            display: block;
            margin: 5px 0 15px 0;
            font-size: 14px;
            cursor: pointer;
            color: #555;
        }

        /* ===== Media Queries ===== */
        @media (max-width: 768px) {
            .login-wrapper {
                height: 100vh;
                padding: 0;
            }

            .login-container {
                width: 100%;
                height: 100%;
                padding: 20px;
                border-radius: 0;
                box-shadow: none;
            }

                .login-container h2 {
                    font-size: 22px;
                }

                .login-container input[type=text],
                .login-container input[type=password],
                .login-container input[type=number],
                .login-container input[type=submit],
                .login-container .btn-secondary {
                    font-size: 16px;
                    padding: 12px;
                }
        }

        @media (max-width: 420px) {
            .login-container h2 {
                font-size: 20px;
            }

            .login-container input[type=text],
            .login-container input[type=password],
            .login-container input[type=number],
            .login-container input[type=submit],
            .login-container .btn-secondary {
                font-size: 14px;
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-wrapper">
            <div class="login-container">
                <h2>تسجيل الدخول</h2>

                <asp:TextBox ID="txtUsername" runat="server" placeholder="اسم المستخدم"></asp:TextBox>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="كلمة المرور"></asp:TextBox>
                <span class="show-password" onclick="togglePassword()">عرض / إخفاء كلمة المرور</span>
                <asp:TextBox ID="txtClinicID" runat="server" TextMode="Number" placeholder="رقم العيادة" AutoPostBack="true" OnTextChanged="txtClinicID_TextChanged"></asp:TextBox>

                <div class="login-options">
                    <label>
                        <asp:CheckBox ID="chkRememberMe" runat="server" Text="تذكرني" />
                    </label>
                    <a href="ForgotAccount.aspx" class="forgot-password">نسيت كلمة المرور؟</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="تسجيل الدخول" OnClick="btnLogin_Click" />
                <asp:Button ID="AddClinic" runat="server" Text="طلب فتح حساب" CssClass="btn-secondary" OnClick="AddClinic_Click" />

                <asp:Label ID="lblError" runat="server" CssClass="error"></asp:Label>
            </div>
        </div>
    </form>

    <script>
        function togglePassword() {
            var pwd = document.getElementById('<%= txtPassword.ClientID %>');
            pwd.type = (pwd.type === 'password') ? 'text' : 'password';
        }
    </script>
</body>
</html>
