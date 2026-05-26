<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="EmployeesList.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.EmployeesList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .table-container {
            max-width: 1000px;
            margin: 24px auto;
            padding: 16px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            color: #333;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            box-sizing: border-box;
            overflow-x: auto;
        }

        /* جدول الكمبيوتر */
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            min-width: 600px;
        }

        .table th, .table td {
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            font-size: 14px;
        }

        .table th {
            background-color: #f4f6f8;
            color: #2c3e50;
        }

        /* أزرار العمليات */
        .btn-action {
            padding: 6px 14px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 13px;
            color: #fff;
            transition: 0.3s;
            margin: 2px 0;
        }

        .btn-edit { background-color: #e67e22; }
        .btn-edit:hover { background-color: #cf6c17; }

        .btn-withdrawals { background-color: #0078d7; }
        .btn-withdrawals:hover { background-color: #005fa3; }

        /* كروت الموبايل */
        .employee-card {
            display: none;
            background: #fff;
            border-radius: 12px;
            padding: 12px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            font-size: 14px;
        }

        .employee-card p {
            margin: 4px 0;
        }

        .employee-card .btn-action {
            width: 48%;
            display: inline-block;
            margin-right: 2%;
        }

        /* استجابة للشاشات الصغيرة */
        @media (max-width:768px) {
            .table { display: none; } /* إخفاء الجدول على الموبايل */
            .employee-card { display: block; }
            .btn-action { font-size: 12px; padding: 4px 8px; }
        }
    </style>

    <div class="table-container">
        <h2 style="text-align: center; margin-bottom: 20px;">قائمة الموظفين</h2>

        <!-- جدول الكمبيوتر -->
        <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" CssClass="table">
            <Columns>
                <asp:BoundField DataField="EmployeeID" HeaderText="رقم الموظف" ReadOnly="True" />
                <asp:BoundField DataField="FullName" HeaderText="اسم الموظف" />
                <asp:BoundField DataField="Phone" HeaderText="الهاتف" />
                <asp:BoundField DataField="Age" HeaderText="العمر" />
                <asp:BoundField DataField="SocialStatus" HeaderText="الضمان الاجتماعي" />
                <asp:BoundField DataField="SocialNumber" HeaderText="رقم الضمان" />
                <asp:BoundField DataField="StartDate" HeaderText="تاريخ بداية العمل" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="Address" HeaderText="العنوان" />

                <asp:TemplateField HeaderText="العمليات">
                    <ItemTemplate>
                        <asp:Button ID="btnEditEmployee" runat="server" Text="تعديل" CssClass="btn-action btn-edit"
                            CommandName="EditEmployee" CommandArgument='<%# Eval("EmployeeID") %>' />
                        <asp:Button ID="btnViewWithdrawals" runat="server" Text="عرض السحوبات" CssClass="btn-action btn-withdrawals"
                            CommandName="ViewWithdrawals" CommandArgument='<%# Eval("EmployeeID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <!-- كروت الموبايل -->
        <asp:Repeater ID="rptEmployees" runat="server">
            <ItemTemplate>
                <div class="employee-card">
                    <p><strong>رقم الموظف:</strong> <%# Eval("EmployeeID") %></p>
                    <p><strong>الاسم:</strong> <%# Eval("FullName") %></p>
                    <p><strong>الهاتف:</strong> <%# Eval("Phone") %></p>
                    <p><strong>العمر:</strong> <%# Eval("Age") %></p>
                    <p><strong>الضمان الاجتماعي:</strong> <%# Eval("SocialStatus") %></p>
                    <p><strong>رقم الضمان:</strong> <%# Eval("SocialNumber") %></p>
                    <p><strong>تاريخ البداية:</strong> <%# Eval("StartDate", "{0:yyyy-MM-dd}") %></p>
                    <p><strong>العنوان:</strong> <%# Eval("Address") %></p>
                    <asp:Button ID="btnEditEmployeeMobile" runat="server" Text="تعديل" CssClass="btn-action btn-edit"
                        CommandName="EditEmployee" CommandArgument='<%# Eval("EmployeeID") %>' />
                    <asp:Button ID="btnViewWithdrawalsMobile" runat="server" Text="عرض السحوبات" CssClass="btn-action btn-withdrawals"
                        CommandName="ViewWithdrawals" CommandArgument='<%# Eval("EmployeeID") %>' />
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>


