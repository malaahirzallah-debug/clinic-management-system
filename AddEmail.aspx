<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AddEmail.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.AddEmail" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>إضافة البريد الإلكتروني</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f2f2f2;
            margin: 0;
            padding: 0;
        }

        .email-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .email-container {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            width: 360px;
            max-width: 100%;
            text-align: center;
        }

        .email-container h2 {
            margin-bottom: 20px;
            color: #2c3e50;
        }

        .email-container input[type=text],
        .email-container input[type=email] {
            width: 100%;
            padding: 14px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            box-sizing: border-box;
        }

        .email-container input[type=submit] {
            background: #27ae60;
            color: white;
            padding: 14px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s ease;
            width: 100%;
            margin-top: 10px;
        }

        .email-container input[type=submit]:hover {
            background: #219150;
        }

        .message {
            margin-top: 15px;
            font-size: 14px;
            color: #555;
        }

        .error {
            color: red;
            margin-top: 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="email-wrapper">
            <div class="email-container">
                <h2>إضافة البريد الإلكتروني</h2>
                <asp:TextBox ID="txtEmail" runat="server" placeholder="أدخل بريدك الإلكتروني" TextMode="Email"></asp:TextBox>
                <asp:Button ID="btnSaveEmail" runat="server" Text="إرسال للتحقق" OnClick="btnSaveEmail_Click" />
                <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
                <asp:Label ID="lblError" runat="server" CssClass="error"></asp:Label>
            </div>
        </div>
    </form>
</body>
</html>
