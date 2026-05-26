<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Suppliers.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.Suppliers" %>

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

    .report-input {
        padding: 10px 14px;
        border-radius: 10px;
        border: 1px solid #ccc;
        font-size: 14px;
    }

    .report-input[readonly] {
        background-color: #f0f0f0;
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

    .btn-clear {
        background-color: #e67e22;
        color: white;
        padding: 10px 20px;
        border-radius: 10px;
        border: none;
        cursor: pointer;
        transition: 0.3s;
    }

    .btn-clear:hover {
        background-color: #cf6c17;
    }

    .table-container {
        overflow-x: auto;
        margin-top: 20px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }

    table th, table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }

    table th {
        background-color: #f4f4f4;
    }

    @media (max-width:768px) {
        .flex-50 {
            flex: 1 1 100%;
        }
    }
    .btn-back {
        background-color: #b0b0b0; /* لون سكني */
        color: #fff; /* نص أبيض */
        padding: 10px 20px;
        border-radius: 10px;
        border: none;
        cursor: pointer;
        transition: 0.3s;
    }

    .btn-back:hover {
        background-color: #999999; /* ظل أغمق عند المرور */
    }
</style>


    <div class="medical-report-container">
        <div class="report-title">إدارة الموردين</div>

        <asp:Label ID="lblMessage" runat="server" CssClass="text-success mb-2 d-block"></asp:Label>

        <div class="report-section">
            <div class="flex-50">
                <label for="txtCompanyName">اسم الشركة:</label>
                <asp:TextBox ID="txtCompanyName" runat="server" CssClass="report-input" MaxLength="150"></asp:TextBox>
            </div>

            <div class="flex-50">
                <label for="txtAgentName">اسم المندوب:</label>
                <asp:TextBox ID="txtAgentName" runat="server" CssClass="report-input" MaxLength="150"></asp:TextBox>
            </div>

            <div class="flex-50">
                <label for="txtPhone">رقم الهاتف:</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="report-input" MaxLength="20"></asp:TextBox>
            </div>

            <div class="flex-50">
                <label for="txtEmail">البريد الإلكتروني:</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="report-input" MaxLength="100"></asp:TextBox>
            </div>

            <div class="flex-50">
                <label for="txtAddress">العنوان:</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="report-input" MaxLength="250"></asp:TextBox>
            </div>

            <div class="flex-50">
                <label for="txtNotes">ملاحظات:</label>
                <asp:TextBox ID="txtNotes" runat="server" CssClass="report-input" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>
        </div>

        <div class="report-actions">
            <asp:Button ID="btnSave" runat="server" CssClass="btn-save" Text="حفظ المورد" OnClick="btnSave_Click" />
            <asp:Button ID="btnClear" runat="server" CssClass="btn-clear" Text="تفريغ الحقول" OnClick="btnClear_Click" />
             <asp:Button ID="btnBack" runat="server" CssClass="btn-back" Text="⬅ رجوع" PostBackUrl="HomePage.aspx" />
        </div>
    </div>
</asp:Content>
