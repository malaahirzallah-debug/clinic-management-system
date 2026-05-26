<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="AddExpense.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.AddExpense" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .form-container {
            max-width: 700px;
            margin: 30px auto;
            padding: 20px;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            font-family: "Segoe UI", Tahoma, sans-serif;
            direction: rtl;
            text-align: right;
        }
        .form-title {
            text-align: center;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 25px;
            color: #2c3e50;
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            font-weight: 600;
            margin-bottom: 6px;
            display: block;
        }
        .form-control {
            width: 100%;
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        .form-control:focus {
            outline: none;
            border-color: #0078d7;
            box-shadow: 0 0 6px rgba(0,120,215,0.3);
        }
        .form-actions {
            text-align: center;
            margin-top: 20px;
        }
        .btn {
            padding: 10px 22px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            margin: 5px;
            transition: 0.3s;
        }
        .btn-save {
            background-color: #28a745;
            color: #fff;
        }
        .btn-save:hover {
            background-color: #218838;
        }
        .btn-close {
            background-color: #dc3545;
            color: #fff;
        }
        .btn-close:hover {
            background-color: #b52a37;
        }
    </style>

    <div class="form-container">
        <div class="form-title">إضافة مصروف جديد</div>

        <div class="form-group">
            <label for="txtPayDate">تاريخ الدفع:</label>
            <asp:TextBox ID="txtPayDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="ddlExpenseType">نوع الدفع:</label>
            <asp:DropDownList ID="ddlExpenseType" runat="server" CssClass="form-control" AutoPostBack="True"></asp:DropDownList>
            <asp:TextBox ID="txtNewExpenseType" runat="server" CssClass="form-control mt-2" Placeholder="أدخل نوع دفع جديد"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="ddlPaymentMethod">طريقة الدفع:</label>
            <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="form-control">
                <asp:ListItem Text="كاش" Value="Cash"></asp:ListItem>
                <asp:ListItem Text="بطاقة" Value="Card"></asp:ListItem>
                <asp:ListItem Text="تحويل بنكي" Value="Bank"></asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <label for="txtAmount">المبلغ:</label>
            <asp:TextBox ID="txtAmount" runat="server" CssClass="form-control"></asp:TextBox>
        </div>

        <div class="form-group">
            <label for="txtNotes">ملاحظات:</label>
            <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
        </div>

        <div class="form-actions">
            <asp:Button ID="btnSave" runat="server" Text="💾 حفظ" CssClass="btn btn-save" />
            <asp:Button ID="btnClose" runat="server" Text="❌ إغلاق" CssClass="btn btn-close" OnClientClick="window.location='HomePage.aspx'; return false;" />
        </div>
    </div>

</asp:Content>
