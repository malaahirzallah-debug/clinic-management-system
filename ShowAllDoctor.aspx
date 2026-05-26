<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master"  CodeBehind="ShowAllDoctor.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.ShowAllDoctor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="medical-report-container">
        <h2 class="report-title">👨‍⚕️ إدارة الأطباء</h2>

        <div class="filter-section">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="simple-input" Placeholder="بحث باسم الطبيب أو التخصص..." />
            <asp:DropDownList ID="ddlStatus" runat="server" CssClass="simple-input">
                <asp:ListItem Text="الكل" Value="all" />
                <asp:ListItem Text="نشط" Value="active" />
                <asp:ListItem Text="غير مفعل" Value="inactive" />
            </asp:DropDownList>
            <asp:Button ID="btnFilter" runat="server" CssClass="simple-btn" Text="🔍 بحث" />
            <asp:Button ID="btnOnDemand" runat="server" CssClass="simple-btn-clear" Text="🛎️ أطباء على الطلب" />
        </div>

        <asp:GridView ID="gvDoctors" runat="server" AutoGenerateColumns="False" CssClass="simple-gridview"
            EmptyDataText="لا يوجد أطباء لعرضهم" GridLines="None" Width="100%">
            <Columns>
                <asp:BoundField DataField="Name" HeaderText="اسم الطبيب" />
                <asp:BoundField DataField="Specialty" HeaderText="التخصص" />
                <asp:BoundField DataField="Phone" HeaderText="رقم الهاتف" />
               <asp:TemplateField HeaderText="الحالة">
    <ItemTemplate>
        <%# If(Convert.ToBoolean(Eval("Active")), "نشط", "غير مفعل") %>
    </ItemTemplate>
</asp:TemplateField>
                <asp:TemplateField HeaderText="الإجراءات">
                    <ItemTemplate>
                        <asp:Button ID="btnEditDoctor" runat="server" Text="✏️ تعديل" CssClass="simple-btn"
                            CommandName="EditDoctor" CommandArgument='<%# Eval("DoctorID") %>' />
                        <asp:Button ID="btnToggleDoctor" runat="server" Text='<%# If(Convert.ToBoolean(Eval("Active")), "إيقاف", "تفعيل") %>' CssClass="simple-btn-clear"
                            CommandName="ToggleActive" CommandArgument='<%# Eval("DoctorID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <style>
        .medical-report-container {
            max-width: 900px;
            margin: 24px auto;
            padding: 16px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            color: #333;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .report-title {
            text-align: center;
            margin-bottom: 24px;
            font-size: 22px;
            font-weight: 600;
            color: #2c3e50;
        }

        .filter-section {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 20px;
            align-items: center;
            justify-content: flex-start;
        }

        .simple-input {
            padding: 10px 12px;
            border-radius: 8px;
            border: 1px solid #dcdfe6;
            font-size: 14px;
            outline: none;
        }

        .simple-btn {
            background: #27ae60;
            color: #fff;
            border: none;
            padding: 10px 18px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            transition: background .2s;
        }
        .simple-btn:hover { background: #1f8f4f; }

        .simple-btn-clear {
            background: #e67e22;
            color: #fff;
            border: none;
            padding: 10px 18px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            transition: background .2s;
        }
        .simple-btn-clear:hover { background: #cf6c17; }

        .simple-gridview {
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        .simple-gridview th, .simple-gridview td {
            padding: 10px 12px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
            text-align: center;
        }
        .simple-gridview th {
            background-color: #f9f9f9;
            font-weight: 600;
            color: #2c3e50;
        }
        .simple-gridview tr:last-child td { border-bottom: none; }

        @media (max-width:768px) {
            .filter-section { flex-direction: column; align-items: stretch; }
            .simple-input, .simple-btn, .simple-btn-clear { width: 100%; }
        }
    </style>
</asp:Content>
