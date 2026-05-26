<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Withdrawals.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.Withdrawals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .medical-report-container {
            max-width: 800px;
            margin: 24px auto;
            padding: 16px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            color: #333;
            box-sizing: border-box;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .report-title {
            text-align: center;
            margin-bottom: 24px;
            color: #2c3e50;
            font-size: 22px;
            font-weight: 600;
        }

        .report-section {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 20px;
        }

        .flex-50 {
            flex: 1 1 48%;
            display: flex;
            flex-direction: column;
        }

        .report-section label {
            margin-bottom: 4px;
            font-weight: 500;
        }

        .report-input, .report-select {
            padding: 10px 14px;
            border-radius: 10px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        .report-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: flex-start;
            margin-top: 20px;
        }

        .btn-save {
            background-color: #0078d7;
            color: white;
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-save:hover {
            background-color: #005fa3;
        }

        .btn-close {
            background-color: #e67e22;
            color: white;
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-close:hover {
            background-color: #cf6c17;
        }

        @media (max-width:768px) {
            .flex-50 {
                flex: 1 1 100%;
            }
        }
    .auto-style1 {
        --bs-btn-close-color: #000;
        --bs-btn-close-bg: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23000'%3e%3cpath d='M.293.293a1 1 0 0 1 1.414 0L8 6.586 14.293.293a1 1 0 1 1 1.414 1.414L9.414 8l6.293 6.293a1 1 0 0 1-1.414 1.414L8 9.414l-6.293 6.293a1 1 0 0 1-1.414-1.414L6.586 8 .293 1.707a1 1 0 0 1 0-1.414z'/%3e%3c/svg%3e");
        --bs-btn-close-opacity: 0.5;
        --bs-btn-close-hover-opacity: 0.75;
        --bs-btn-close-focus-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        --bs-btn-close-focus-opacity: 1;
        --bs-btn-close-disabled-opacity: 0.25;
        --bs-btn-close-white-filter: invert(1) grayscale(100%) brightness(200%);
        box-sizing: content-box;
        color: white;
        border-radius: 10px;
        opacity: var(--bs-btn-close-opacity);
        cursor: pointer;
        transition: 0.3s;
        border-style: none;
        border-color: inherit;
        border-width: medium;
        padding: 10px 20px;
        background-color: #e67e22;
    }
    </style>

    <div class="medical-report-container">
        <div class="report-title">إضافة مسحوبات</div>

        <asp:Label ID="lblMessage" runat="server" CssClass="text-success mb-2 d-block"></asp:Label>

        <div class="report-section">
            <div class="flex-50">
                <label for="txtDate">تاريخ السحب:</label>
                <asp:TextBox ID="txtDate" runat="server" CssClass="report-input" TextMode="Date"></asp:TextBox>
            </div>

            <div class="flex-50">
                <label for="ddlType">نوع السحب:</label>
                <asp:DropDownList ID="ddlType" runat="server" CssClass="report-select" AutoPostBack="True" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                    <asp:ListItem Text="اختر" Value="" />
                    <asp:ListItem Text="مورد" Value="Supplier" />
                    <asp:ListItem Text="موظف" Value="Employee" />
                    <asp:ListItem Text="أخرى" Value="Other" />
                </asp:DropDownList>
            </div>

            <div class="flex-50">
                <label for="ddlDetails">تفاصيل السحب:</label>
                <asp:DropDownList ID="ddlDetails" runat="server" CssClass="report-select">
                </asp:DropDownList>
                <asp:TextBox ID="txtOtherDetails" runat="server" CssClass="report-input" Placeholder="أدخل التفاصيل" Visible="False"></asp:TextBox>
            </div>

            <div class="flex-50">
                <label for="txtAmount">المبلغ:</label>
                <asp:TextBox ID="txtAmount" runat="server" CssClass="report-input"></asp:TextBox>
            </div>

            <div class="flex-50">
                <label for="ddlPaymentMethod">طريقة الدفع:</label>
                <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="report-select">
                    <asp:ListItem Text="نقدي" Value="Cash" />
                    <asp:ListItem Text="تحويل بنكي" Value="BankTransfer" />
                    <asp:ListItem Text="شيك" Value="Cheque" />
                </asp:DropDownList>
            </div>

            <div class="flex-50">
                <label for="txtNotes">ملاحظات:</label>
                <asp:TextBox ID="txtNotes" runat="server" CssClass="report-input" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>
        </div>

        <div class="report-actions">
            <asp:Button ID="btnSave" runat="server" CssClass="btn-save" Text="حفظ" OnClick="btnSave_Click" />
            <asp:Button ID="btnClose" runat="server" CssClass="auto-style1" Text="اغلاق" OnClientClick="window.close(); return false;" Width="82px" />
        </div>
    </div>
</asp:Content>
