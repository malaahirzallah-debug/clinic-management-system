<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AddClinic.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.AddClinic" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="rtl">
<head runat="server">
    <title>إنشاء عيادة جديدة</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('/images/logo2.png');
            background-repeat: no-repeat;
            background-position: center center;
            background-size: auto 100%;
            background-attachment: fixed;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 700px;
            margin: 50px auto;
            background-color: transparent ;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #555;
            text-align: right;
        }
        input[type=text], input[type=email], textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 8px;
            border: 1px solid #ccc;
            box-sizing: border-box;
            font-size: 14px;
            text-align: right;
        }
        textarea {
            resize: vertical;
        }
        .btnSave {
            margin-top: 25px;
            background-color: #28a745;
            color: white;
            border: none;
            padding: 14px 30px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }
        .btnSave:hover {
            background-color: #218838;
        }
        .successMsg {
            margin-top: 25px;
            font-weight: bold;
            text-align: center;
            font-size: 18px;
            color: green;
        }
        .clinicIDMsg {
            margin-top: 20px;
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            color: red;
        }
        #map {
            width: 100%;
            height: 350px;
            margin-top: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>طلب فتح ملف عيادة جديدة</h2>

            <label>اسم العيادة <span style="color:red">*</span></label>
            <asp:TextBox ID="txtClinicName" runat="server" />

            <label>العنوان <span style="color:red">*</span></label>
            <asp:TextBox ID="txtAddress" runat="server" />

            <label>رقم الهاتف <span style="color:red">*</span></label>
            <asp:TextBox ID="txtPhone" runat="server" />

            <label>البريد الإلكتروني <span style="color:red">*</span></label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" />

            <label>ملاحظات إضافية (اختياري)</label>
            <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="4" />

            <asp:Button ID="btnSave" runat="server" Text="إرسال الطلب" CssClass="btnSave" OnClick="btnSave_Click" />

            <asp:Label ID="lblMessage" runat="server" CssClass="successMsg"></asp:Label>
            <asp:Label ID="lblError" runat="server" CssClass="errorMsg"></asp:Label>
        </div>
    </form>
</body>
</html>
