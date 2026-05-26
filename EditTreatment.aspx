<%@ Page Language="vb" AutoEventWireup="false"  MasterPageFile="~/Site1.Master" CodeBehind="EditTreatment.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.EditTreatment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="direction: rtl; max-width: 700px; margin: auto; background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,.1)">
        <h2 style="margin-bottom: 15px;">تعديل الإجراء</h2>

        <asp:HiddenField ID="hfTreatmentID" runat="server" />

        <div style="margin-bottom: 12px;">
            <label>اسم الإجراء:</label><br />
            <asp:TextBox ID="txtTreatmentName" runat="server" CssClass="form-control" Width="100%" />
        </div>

        <div style="margin-bottom: 12px;">
            <label>المجموعة:</label><br />
            <asp:DropDownList ID="ddlGroups" runat="server" CssClass="form-control" Width="100%"></asp:DropDownList>
        </div>

        <div style="margin-bottom: 12px;">
            <label>الوصف المختصر:</label><br />
            <asp:TextBox ID="txtShortDesc" runat="server" CssClass="form-control" Width="100%" />
        </div>

        <div style="margin-bottom: 12px;">
            <label>قيمة الإجراء:</label><br />
            <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" Width="100%" />
        </div>

        <div style="margin-bottom: 12px;">
            <label>المدة (بالدقائق):</label><br />
            <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" Width="100%" />
        </div>

        <div style="margin-bottom: 12px;">
            <label>ملاحظات إضافية:</label><br />
            <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" Width="100%" />
        </div>

        <asp:Button ID="btnUpdate" runat="server" Text="تحديث" CssClass="btn btn-primary" />
        <asp:Button ID="btnCancel" runat="server" Text="إلغاء" CssClass="btn btn-secondary" PostBackUrl="~/TreatmentsManager.aspx" />
    </div>
</asp:Content>
