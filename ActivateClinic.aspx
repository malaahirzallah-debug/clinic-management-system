<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ActivateClinic.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.ActivateClinic" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="rtl">
<head runat="server">
    <title>تفعيل العيادة</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; text-align: center; margin: 50px; }
        .container { background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); max-width: 600px; margin: auto; }
        h2 { color: #333; }
        .successMsg { color: green; font-weight: bold; margin-top: 20px; }
        table { margin: 20px auto; border-collapse: collapse; width: 80%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background: #f0f0f0; }
    </style>
</head>
<body>
   <form id="form1" runat="server">
    <div class="container">
        <h2>تفعيل العيادة</h2>
        <asp:Label ID="lblMessage" runat="server" CssClass="successMsg"></asp:Label>
        
        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" Visible="False">
            <Columns>
                <asp:BoundField DataField="UserName" HeaderText="اسم المستخدم" />
                <asp:BoundField DataField="Password" HeaderText="كلمة المرور" />
            </Columns>
        </asp:GridView>
    </div>
</form>

</body>
</html>
