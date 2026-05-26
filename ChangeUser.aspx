<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ChangeUser.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.ChangeUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="change-user-container">
        <div class="form-card">
            <h2>تغيير اسم المستخدم وكلمة المرور</h2>
            <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>

            <div class="form-group">
                <label for="txtCurrentPassword">كلمة المرور الحالية:</label>
                <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-control" AutoComplete="new-password" />
            </div>

            <div class="form-group">
                <label for="txtNewUsername">اسم المستخدم الجديد:</label>
                <asp:TextBox ID="txtNewUsername" runat="server" CssClass="form-control" />
            </div>

            <div class="form-group">
                <label for="txtNewPassword">كلمة المرور الجديدة:</label>
                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control" />
            </div>

            <div class="form-group">
                <label for="txtConfirmPassword">تأكيد كلمة المرور الجديدة:</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" />
            </div>

            <asp:Button ID="btnChange" runat="server" Text="تغيير" OnClick="btnChange_Click" CssClass="btn-change" />
        </div>
    </div>

    <style>
        /* الحاوية العامة */
        .change-user-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 80vh;
            background: #f5f6fa;
            padding: 20px;
        }

        /* البطاقة البيضاء */
        .form-card {
            background: #ffffff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            max-width: 450px;
            width: 100%;
        }

        .form-card h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* رسائل الخطأ/النجاح */
        .message {
    display: block;
    margin-bottom: 15px;
    text-align: center;
    font-weight: bold;
    padding: 10px 15px;
    border-left: 4px solid #e74c3c; /* افتراضي خطأ */
    background-color: #fdecea;
    border-radius: 5px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.message.success {
    border-left-color: #27ae60;
    background-color: #eafaf1;
}


        /* مجموعات الحقول */
        .form-group {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            margin-bottom: 5px;
            font-weight: 600;
            color: #555;
        }

        .form-control {
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            border-color: #3498db;
            outline: none;
        }

        /* زر التغيير */
        .btn-change {
            width: 100%;
            padding: 12px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
        }

        .btn-change:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
        }

        /* متجاوبة */
        @media (max-width: 500px) {
            .form-card {
                padding: 20px;
            }
        }
    </style>

</asp:Content>

