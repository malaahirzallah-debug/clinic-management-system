<%@ Page Language="vb" AutoEventWireup="false"  MasterPageFile="~/Site1.Master"CodeBehind="AddGroup.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.AddGroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="direction:rtl; max-width:600px; margin:auto; background:#fff; padding:20px; border-radius:10px; box-shadow:0 2px 5px rgba(0,0,0,.1)">
        <h2 style="margin-bottom:15px;">إضافة مجموعة جديدة</h2>

        <div style="margin-bottom:12px;">
            <label>اسم المجموعة:</label><br />
            <asp:TextBox ID="txtGroupName" runat="server" CssClass="form-control" Width="100%" />
        </div>

        <div style="margin-bottom:12px;">
            <label>ملاحظات:</label><br />
            <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" Width="100%" />
        </div>

        <asp:Button ID="btnSave" runat="server" Text="حفظ" CssClass="btn btn-primary" />
        <asp:Button ID="btnCancel" runat="server" Text="إلغاء" CssClass="btn btn-secondary" PostBackUrl="~/TreatmentsManager.aspx" />
    </div>
</asp:Content>
