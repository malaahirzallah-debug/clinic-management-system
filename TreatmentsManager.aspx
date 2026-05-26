<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="TreatmentsManager.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.TreatmentsManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        :root {
            --accent: #2c7be5;
            --muted: #6b7280;
            --card-bg: #ffffff;
            --surface: #f6f7fb;
            --radius: 10px;
            --gap: 14px;
            --container-max: 1200px;
        }

        .treatments-page {
            direction: rtl;
            font-family: "Segoe UI", Tahoma, Arial, sans-serif;
            color: #22252a;
            padding: 18px;
            box-sizing: border-box;
        }

        .treatments-container {
            max-width: var(--container-max);
            margin: 0 auto;
            background: var(--surface);
            padding: 18px;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }

        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 18px;
        }

        .page-header h1 { margin: 0; font-size: 1.25rem; letter-spacing: 0.2px; }

        .page-actions { display: flex; gap: 8px; align-items: center; }

        .btnn {
            display: inline-block; padding: 8px 12px; border-radius: 8px;
            background: var(--accent); color: white; text-decoration: none;
            cursor: pointer; border: none; font-size: 0.95rem;
            box-shadow: 0 1px 0 rgba(0,0,0,0.04);
        }
        .btnn.secondary { background: transparent; color: var(--accent); border: 1px solid rgba(44,123,229,0.12); }
        .btnn.ghost { background: white; color: var(--accent); border: 1px solid rgba(44,123,229,0.25); }
        .btnn.ghost:hover { background: #f0f6ff; border-color: var(--accent); }

        .groups-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: var(--gap); }
        .group-card {
            background: #f0f6ff; border-radius: var(--radius); padding: 12px;
            box-shadow: 0 1px 3px rgba(16,24,40,0.05);
            display: flex; flex-direction: column; min-height: 160px;
        }
        .group-head { display: flex; justify-content: space-between; align-items: center; gap: 8px; margin-bottom: 8px; }
        .group-title { font-weight: 600; font-size: 1rem; }
        .group-meta { font-size: 0.85rem; color: var(--muted); }

        .treatments-list { margin-top: 6px; display: flex; flex-direction: column; gap: 8px; flex: 1 1 auto; overflow: auto; max-height: 260px; padding-right: 6px; }
        .treatment-item { display: flex; justify-content: space-between; align-items: center; gap: 8px; padding: 8px; border-radius: 8px; background: #f9fafc; border: 1px solid rgba(0,0,0,0.04); font-size: 0.95rem; }
        .treatment-item:hover { background: #eef2f8; }

        .treatment-info { display: flex; flex-direction: column; gap: 3px; }
        .treatment-name { font-weight: 600; }
        .treatment-desc { font-size: 0.82rem; color: var(--muted); }

        .item-actions { display: flex; gap: 6px; align-items: center; }

        .btnn.edit { background: #4CAF50; color: #fff; padding: 6px 12px; border-radius: 6px; cursor: pointer; }
        .btnn.edit:hover { background: #43a047; }
        .btnn.delete { background: #f44336; color: #fff; padding: 6px 12px; border-radius: 6px; cursor: pointer; }
        .btnn.delete:hover { background: #d32f2f; }

        @media (max-width:700px) { .treatments-list { max-height: 180px; } }
        @media (max-width:420px) { .page-actions { flex-direction: column; align-items: stretch; } }
    </style>

    <div class="treatments-page">
        <div class="treatments-container">
            <div class="page-header">
                <h1>إدارة الإجراءات والمجموعات</h1>
                <div class="page-actions">
                    <asp:HyperLink ID="btnAddGroup" runat="server" CssClass="btnn" NavigateUrl="AddGroup.aspx">+ إضافة مجموعة</asp:HyperLink>
                    <asp:HyperLink ID="btnAddTreatment" runat="server" CssClass="btnn secondary" NavigateUrl="AddTreatment.aspx">+ إضافة إجراء</asp:HyperLink>
                </div>
            </div>

            <div style="display: flex; gap: 10px; margin-bottom: 12px;">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" placeholder="ابحث باسم الإجراء أو المجموعة..." AutoPostBack="true" OnTextChanged="FilterData"></asp:TextBox>
                <asp:DropDownList ID="ddlGroups" runat="server" CssClass="group-filter" AutoPostBack="true" OnSelectedIndexChanged="FilterData">
                    <asp:ListItem Text="كل المجموعات" Value=""></asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:Repeater ID="rptGroups" runat="server">
                <ItemTemplate>
                    <div class="group-card">
                        <div class="group-head">
                            <div>
                                <div class="group-title"><%# Eval("GroupName") %></div>
                                <div class="group-meta small">عدد الإجراءات: <%# CType(Eval("Treatments"), List(Of TreatmentModel)).Count %></div>
                            </div>
                            <div class="group-actions">
                                <asp:HyperLink ID="btnEditGroup" runat="server" CssClass="btnn ghost"
                                    NavigateUrl='<%# "EditGroup.aspx?GroupID=" & Eval("GroupID") %>'>تعديل</asp:HyperLink>
                                <asp:LinkButton ID="btnDeleteGroup" runat="server" CommandArgument='<%# Eval("GroupID") %>'
                                    OnClick="btnDeleteGroup_Click" CssClass="btnn ghost"
                                    OnClientClick="return confirm('هل تريد حذف هذه المجموعة مع كل إجراءاتها؟');">حذف</asp:LinkButton>
                            </div>
                        </div>

                        <div class="treatments-list">
                            <asp:Repeater ID="rptTreatments" runat="server" DataSource='<%# Eval("Treatments") %>'>
                                <ItemTemplate>
                                    <div class="treatment-item">
                                        <div class="treatment-info">
                                            <div class="treatment-name"><%# Eval("TreatmentName") %></div>
                                            <div class="treatment-desc">
                                                <%# Eval("ShortDesc") %> • <%# Eval("DurationMinutes") %> د • سعر: <%# Eval("Price") %>
                                            </div>
                                        </div>
                                        <div class="item-actions">
                                            <asp:HyperLink ID="btnEditTreatment" runat="server" CssClass="btnn edit"
                                                NavigateUrl='<%# "EditTreatment.aspx?TreatmentID=" & Eval("TreatmentID") %>'>تعديل</asp:HyperLink>
                                            <asp:LinkButton ID="btnDeleteTreatment" runat="server" CommandArgument='<%# Eval("TreatmentID") %>'
                                                OnClick="btnDeleteTreatment_Click" CssClass="btnn delete"
                                                OnClientClick="return confirm('هل تريد حذف هذا الإجراء؟');">حذف</asp:LinkButton>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </div>
    </div>
</asp:Content>

