<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="AddInsuranceCompany.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.AddInsuranceCompany" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .form-container {
            max-width: 700px;
            margin: 30px auto;
            background: #f9f9f9;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
            font-family: Tahoma, Arial, sans-serif;
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #2c3e50;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
            color: #34495e;
        }

        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .btn-submit, .btn-cancel {
            display: inline-block;
            width: auto;
            padding: 10px 25px;
            font-size: 14px;
            font-weight: bold;
            border-radius: 6px;
            cursor: pointer;
            transition: 0.3s;
            margin-right: 10px;
        }

        .btn-submit {
            background: #3498db;
            color: white;
            border: none;
        }

        .btn-submit:hover {
            background: #2980b9;
        }

        .btn-cancel {
            background: #e74c3c;
            color: white;
            border: none;
        }

        .btn-cancel:hover {
            background: #c0392b;
        }

        .btn-container {
            text-align: center;
            margin-top: 20px;
        }
    </style>

    <div class="form-container">
        <h2>➕ إضافة شركة تأمين</h2>

        <div class="form-group">
            <label for="txtCompanyName">اسم الشركة</label>
            <asp:TextBox ID="txtCompanyName" runat="server" />
        </div>

        <div class="form-group">
            <label for="txtContactPerson">اسم الشخص المسؤول</label>
            <asp:TextBox ID="txtContactPerson" runat="server" />
        </div>

        <div class="form-group">
            <label for="txtPhone">رقم الهاتف</label>
            <asp:TextBox ID="txtPhone" runat="server" />
        </div>

        <div class="form-group">
            <label for="txtEmail">البريد الإلكتروني</label>
            <asp:TextBox ID="txtEmail" runat="server" />
        </div>

        <div class="form-group">
            <label for="txtAddress">العنوان</label>
            <asp:TextBox ID="txtAddress" runat="server" />
        </div>

        <div class="form-group">
            <label for="ddlSettlementMethod">طريقة التسوية</label>
            <asp:DropDownList ID="ddlSettlementMethod" runat="server">
                <asp:ListItem Text="شهري" Value="Monthly" />
                <asp:ListItem Text="فوري" Value="Immediate" />
                <asp:ListItem Text="نسبة من الفاتورة" Value="Percentage" />
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <label for="txtNotes">ملاحظات</label>
            <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" />
        </div>

        <div class="btn-container">
            <asp:Button ID="btnSave" runat="server" Text="💾 حفظ" CssClass="btn-submit" />
            <asp:Button ID="btnCancel" runat="server" Text="❌ إغلاق" CssClass="btn-cancel" OnClientClick="window.location='HomePage.aspx'; return false;" />
        </div>

    </div>

</asp:Content>

