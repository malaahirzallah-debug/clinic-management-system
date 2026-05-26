<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ContactUs.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.ContactUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="contact-container">
        <h1 class="title">تواصل معنا</h1>
        <p class="subtitle">نحن هنا لمساعدتك والإجابة على جميع استفساراتك</p>

        <div class="contact-wrapper">
            <!-- نموذج التواصل -->
            <div class="contact-form">
                <asp:Label ID="lblMessage" runat="server" CssClass="message-label" Text=""></asp:Label>
                <asp:TextBox ID="txtName" runat="server" CssClass="input-field" Placeholder="الاسم الكامل"></asp:TextBox>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="input-field" Placeholder="البريد الإلكتروني"></asp:TextBox>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="input-field" Placeholder="رقم الهاتف"></asp:TextBox>
                <asp:TextBox ID="txtMessage" runat="server" CssClass="input-field message-field" TextMode="MultiLine" Placeholder="اكتب رسالتك هنا"></asp:TextBox>
                <asp:Button ID="btnSend" runat="server" CssClass="send-btn" Text="إرسال الرسالة" OnClick="btnSend_Click" />
            </div>

            <!-- بيانات التواصل -->
            <div class="contact-info">
                <h2>بيانات التواصل</h2>
                <p><strong>البريد الإلكتروني:</strong> info@clinic.com</p>
                <p><strong>رقم الهاتف:</strong> 06-1234567</p>
                <p><strong>العنوان:</strong> شارع الملكة رانيا، عمان، الأردن</p>
                <p><strong>ساعات العمل:</strong> الأحد – الخميس: 9 صباحًا – 6 مساءً</p>
            </div>
        </div>
    </div>

    <style>
        /* الحاوية الرئيسية */
        .contact-container {
            max-width: 1100px;
            margin: 40px auto;
            font-family: 'Segoe UI', Arial, sans-serif;
            text-align: center;
        }

        .title {
            font-size: 32px;
            color: #0078d7;
            margin-bottom: 10px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .subtitle {
            font-size: 18px;
            color: #555;
            margin-bottom: 40px;
            font-weight: 400;
        }

        /* ترتيب العمودين */
        .contact-wrapper {
            display: flex;
            flex-wrap: wrap;
            gap: 40px;
            justify-content: center;
            align-items: flex-start;
        }

        /* تصميم الأعمدة */
        .contact-form, .contact-info {
            flex: 1 1 400px;
            background: linear-gradient(145deg, #ffffff, #f0f8ff);
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .contact-form:hover, .contact-info:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        /* الحقول */
        .input-field {
            width: 100%;
            padding: 14px;
            margin-bottom: 15px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .input-field:focus {
            border-color: #0078d7;
            box-shadow: 0 0 6px rgba(0,120,215,0.3);
            outline: none;
        }

        .message-field {
            height: 140px;
            resize: none;
        }

        /* زر الإرسال */
        .send-btn {
            padding: 14px 25px;
            background: linear-gradient(90deg, #0078d7, #005a9e);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            transition: background 0.3s, transform 0.2s;
        }

        .send-btn:hover {
            background: linear-gradient(90deg, #005a9e, #003f70);
            transform: translateY(-2px);
        }

        /* بيانات التواصل */
        .contact-info h2 {
            margin-bottom: 25px;
            color: #0078d7;
        }

        .contact-info p {
            margin-bottom: 12px;
            color: #333;
            font-size: 15px;
            text-align: right;
        }

        /* رسالة النجاح */
        .message-label {
            color: green;
            font-weight: bold;
            margin-bottom: 15px;
            display: block;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .contact-wrapper { flex-direction: column; align-items: center; }
        }
    </style>
</asp:Content>

