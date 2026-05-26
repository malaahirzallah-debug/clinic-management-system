<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="DoctorSchedule.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.DoctorSchedule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="medical-report-container">
        <h2 class="report-title">🗓️ أوقات دوام الأطباء</h2>

        <!-- اختيار الطبيب -->
        <div class="filter-section">
            <asp:Label ID="lblDoctor" runat="server" Text="اختر الطبيب:" CssClass="simple-label"></asp:Label>
            <asp:DropDownList ID="ddlDoctors" runat="server" CssClass="simple-input" AutoPostBack="true"></asp:DropDownList>
            <asp:Button ID="btnAddSchedule" runat="server" Text="➕ إضافة أوقات" CssClass="simple-btn" OnClick="btnAddSchedule_Click" />
        </div>

        <!-- إضافة دوام لعدة أيام -->
        <asp:Panel ID="pnlAddSchedule" runat="server" Visible="false" CssClass="panel-schedule p-3 mb-4">
            <h4>إضافة دوام لمدة أيام</h4>
            <div class="form-row">
                <asp:Label ID="lblFrom" runat="server" Text="من:" CssClass="simple-label"></asp:Label>
                <asp:TextBox ID="txtFrom" runat="server" TextMode="Date" CssClass="simple-input"></asp:TextBox>

                <asp:Label ID="lblTo" runat="server" Text="إلى:" CssClass="simple-label"></asp:Label>
                <asp:TextBox ID="txtTo" runat="server" TextMode="Date" CssClass="simple-input"></asp:TextBox>
            </div>

            <div class="form-row mt-2">
                <asp:Label runat="server" Text="أيام العمل:" CssClass="simple-label"></asp:Label>
                <asp:CheckBoxList ID="chkDays" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Text="السبت" Value="6" Selected="true" />
                    <asp:ListItem Text="الأحد" Value="0" Selected="true" />
                    <asp:ListItem Text="الاثنين" Value="1" Selected="true" />
                    <asp:ListItem Text="الثلاثاء" Value="2" Selected="true" />
                    <asp:ListItem Text="الأربعاء" Value="3" Selected="true" />
                    <asp:ListItem Text="الخميس" Value="4" Selected="true" />
                    <asp:ListItem Text="الجمعة" Value="5" Selected="true" />
                </asp:CheckBoxList>
            </div>

            <div class="form-row mt-2">
                <asp:Label ID="lblStart" runat="server" Text="من:" CssClass="simple-label"></asp:Label>
                <asp:TextBox ID="txtStartTime" runat="server" TextMode="Time" CssClass="simple-input"></asp:TextBox>

                <asp:Label ID="lblEnd" runat="server" Text="إلى:" CssClass="simple-label"></asp:Label>
                <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time" CssClass="simple-input"></asp:TextBox>
            </div>

            <asp:Button ID="btnSaveMultiple" runat="server" Text="💾 حفظ" CssClass="simple-btn mt-2" OnClick="btnSaveMultiple_Click" />
        </asp:Panel>

        <!-- تعديل يومي -->
        <h4>عرض وتعديل الدوام</h4>
        <div class="form-row mb-2">
            <asp:Label ID="lblFromEdit" runat="server" Text="من:" CssClass="simple-label"></asp:Label>
            <asp:TextBox ID="txtFromEdit" runat="server" TextMode="Date" CssClass="simple-input"></asp:TextBox>

            <asp:Label ID="lblToEdit" runat="server" Text="إلى:" CssClass="simple-label"></asp:Label>
            <asp:TextBox ID="txtToEdit" runat="server" TextMode="Date" CssClass="simple-input"></asp:TextBox>

            <asp:Button ID="btnShowSchedule" runat="server" Text="عرض" CssClass="simple-btn" OnClick="btnShowSchedule_Click" />
        </div>

        <asp:GridView ID="gvSchedule" runat="server" AutoGenerateColumns="False" CssClass="simple-gridview"
            EmptyDataText="لا توجد بيانات لعرضها" GridLines="None" Width="100%" OnRowCommand="gvSchedule_RowCommand">
            <Columns>
                <asp:BoundField DataField="ScheduleDate" HeaderText="التاريخ" DataFormatString="{0:yyyy-MM-dd}" />
                
                <asp:TemplateField HeaderText="مداوم؟">
                    <ItemTemplate>
                        <asp:CheckBox ID="chkIsWorking" runat="server" Checked='<%# Convert.ToBoolean(Eval("IsWorking")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="من">
                    <ItemTemplate>
                        <asp:TextBox ID="txtStartTimeEdit" runat="server" Text='<%# Eval("StartTime") %>' CssClass="time-input" Width="70px" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="إلى">
                    <ItemTemplate>
                        <asp:TextBox ID="txtEndTimeEdit" runat="server" Text='<%# Eval("EndTime") %>' CssClass="time-input" Width="70px" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="حفظ">
                    <ItemTemplate>
                        <asp:Button ID="btnSaveDay" runat="server" Text="💾" CommandName="SaveDay"
                            CommandArgument='<%# Eval("ScheduleID") %>' CssClass="simple-btn" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
    <style>
        .medical-report-container {
            max-width: 900px;
            margin: 24px auto;
            padding: 20px;
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

        .filter-section, .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: center;
            margin-bottom: 12px;
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

            .simple-btn:hover {
                background: #1f8f4f;
            }

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

            .simple-gridview tr:last-child td {
                border-bottom: none;
            }

        @media (max-width:768px) {
            .filter-section, .form-row {
                flex-direction: column;
                align-items: stretch;
            }

            .simple-input, .simple-btn {
                width: 100%;
            }
        }

        .panel-schedule {
            background: #fafafa;
            border-radius: 10px;
            padding: 16px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.03);
        }

        .simple-label {
            font-weight: 500;
            margin-right: 6px;
            font-size: 14px;
        }
    </style>
</asp:Content>
