<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="PatientsDebtsSubscriptions.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.PatientsDebtsSubscriptions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="simple-list-container">
        <h2 class="simple-list-title">📋 المرضى ذوي الذمم أو الاشتراكات</h2>

        <div class="filter-section">
            <label>نوع القائمة:</label>
            <asp:DropDownList ID="ddlType" runat="server" CssClass="simple-dropdown">
                <asp:ListItem Text="الكل" Value="all" />
                <asp:ListItem Text="المرضى عليهم ذمم" Value="debt" />
                <asp:ListItem Text="المرضى ذوي الاشتراك" Value="subscription" />
            </asp:DropDownList>
            <asp:Button ID="btnLoad" runat="server" CssClass="simple-btn" Text="عرض" />
        </div>

        <div class="patients-list">
            <asp:Repeater ID="rptPatients" runat="server">
                <ItemTemplate>
                    <div class="patient-item">
                        <span class="patient-name"><%# Eval("PatientName") %></span>
                        <span class="patient-balance" style='color: <%# If(Convert.ToDecimal(Eval("Balance")) < 0, "red", "green") %>'>
                            <%# String.Format("{0:N2}", Eval("Balance")) %>
                        </span>
                    </div>
                </ItemTemplate>
            </asp:Repeater>


            <asp:Panel ID="noData" runat="server" CssClass="no-data" Visible="False">
                لا يوجد بيانات لعرضها
            </asp:Panel>

        </div>
    </div>

    <style>
        .simple-list-container {
            max-width: 800px;
            margin: 24px auto;
            padding: 0 16px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            color: #333;
        }

        .simple-list-title {
            text-align: center;
            margin-bottom: 20px;
            font-weight: 700;
            color: #2c3e50;
        }

        .filter-section {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            align-items: end;
            justify-content: center;
        }

            .filter-section label {
                font-size: 14px;
                color: #444;
            }

        .simple-dropdown {
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

            .simple-btn:hover {
                background: #1f8f4f;
            }

        .patients-list {
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            background: #fff;
            padding: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .patient-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 10px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
        }

            .patient-item:last-child {
                border-bottom: none;
            }

        .patient-name {
            font-weight: 500;
        }

        .patient-balance {
            font-weight: 600;
        }


        .no-data {
            text-align: center;
            color: #777;
            margin-top: 12px;
            font-size: 14px;
        }
    </style>

</asp:Content>
