<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="SuppliersList.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.SuppliersList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        body {
            font-family: "Segoe UI", Tahoma, sans-serif;
            background-color: #f9f9f9;
        }

        /* ========== GRIDVIEW للكمبيوتر ========= */
        .table-container {
            max-width: 100%;
            margin: 24px auto;
            padding: 16px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .table th, .table td {
            padding: 10px 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            font-size: 14px;
        }

        .table th {
            background-color: #f4f6f8;
            color: #2c3e50;
        }

        /* ========== بطاقات الموبايل ========== */
        .cards-container {
            display: none; /* مخفية للكمبيوتر */
            grid-template-columns: 1fr;
            gap: 16px;
            margin: 24px;
        }

        .card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            padding: 16px;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.12);
        }

        .card h3 { margin: 0 0 10px; color: #2c3e50; font-size: 18px; }
        .card p { margin: 4px 0; font-size: 14px; color: #555; word-break: break-word; }

        .card .actions { margin-top: 12px; display: flex; gap: 8px; }

        /* الأزرار */
        .btn-action {
            flex: 1;
            padding: 6px 0;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 13px;
            color: #fff;
            transition: 0.3s;
        }

        .btn-view { background-color: #0078d7; }
        .btn-view:hover { background-color: #005fa3; }
        .btn-edit { background-color: #e67e22; }
        .btn-edit:hover { background-color: #cf6c17; }

        .btn-back {
            background-color: #b0b0b0;
            color: #fff;
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            transition: 0.3s;
            margin: 24px;
        }
        .btn-back:hover { background-color: #999999; }

        /* ========== تحسين الموبايل ========== */
        @media (max-width: 768px) {
            .table-container { display: none; } /* إخفاء الجدول */
            .cards-container { display: grid; } /* إظهار البطاقات */
        }
    </style>

    <h2 style="text-align:center; margin-top:20px;">قائمة الموردين</h2>

    <!-- جدول الكمبيوتر -->
    <div class="table-container">
        <asp:GridView ID="gvSuppliers" runat="server" AutoGenerateColumns="False" CssClass="table">
            <Columns>
                <asp:BoundField DataField="SupplierID" HeaderText="رقم المورد" />
                <asp:BoundField DataField="CompanyName" HeaderText="اسم الشركة" />
                <asp:BoundField DataField="AgentName" HeaderText="اسم المندوب" />
                <asp:BoundField DataField="Phone" HeaderText="رقم الهاتف" />
                <asp:BoundField DataField="Email" HeaderText="البريد الإلكتروني" />
                <asp:BoundField DataField="Address" HeaderText="العنوان" />
                <asp:BoundField DataField="Notes" HeaderText="ملاحظات" />

                <asp:TemplateField HeaderText="العمليات">
                    <ItemTemplate>
                        <asp:Button ID="btnViewInvoicesGV" runat="server" Text="عرض الفواتير" CssClass="btn-action btn-view"
                            CommandName="ViewInvoices" CommandArgument='<%# Eval("SupplierID") %>' />
                        <asp:Button ID="btnEditSupplierGV" runat="server" Text="تعديل" CssClass="btn-action btn-edit"
                            CommandName="EditSupplier" CommandArgument='<%# Eval("SupplierID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- بطاقات الموبايل -->
    <div class="cards-container">
        <asp:Repeater ID="rptSuppliers" runat="server">
            <ItemTemplate>
                <div class="card">
                    <h3><%# Eval("CompanyName") %></h3>
                    <p><strong>رقم المورد:</strong> <%# Eval("SupplierID") %></p>
                    <p><strong>اسم المندوب:</strong> <%# Eval("AgentName") %></p>
                    <p><strong>الهاتف:</strong> <%# Eval("Phone") %></p>
                    <p><strong>البريد الإلكتروني:</strong> <%# Eval("Email") %></p>
                    <p><strong>العنوان:</strong> <%# Eval("Address") %></p>
                    <p><strong>ملاحظات:</strong> <%# Eval("Notes") %></p>
                    <div class="actions">
                        <asp:Button ID="btnViewInvoices" runat="server" Text="عرض الفواتير" CssClass="btn-action btn-view"
                            CommandName="ViewInvoices" CommandArgument='<%# Eval("SupplierID") %>' />
                        <asp:Button ID="btnEditSupplier" runat="server" Text="تعديل" CssClass="btn-action btn-edit"
                            CommandName="EditSupplier" CommandArgument='<%# Eval("SupplierID") %>' />
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Button ID="btnBack" runat="server" CssClass="btn-back" Text="⬅ رجوع" PostBackUrl="HomePage.aspx" />

</asp:Content>




