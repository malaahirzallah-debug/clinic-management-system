<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Employees.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.Employees" %>

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

        .flex-100 {
            flex: 1 1 100%;
            display: flex;
            flex-direction: column;
        }

        .report-section label {
            margin-bottom: 4px;
            font-weight: 500;
        }

        .report-input, .report-select {
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

        @media (max-width:768px) {
            .flex-50 {
                flex: 1 1 100%;
            }
        }

        .hidden {
            display: none;
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
        <div class="report-title">إضافة موظف جديد</div>

        <asp:Label ID="lblMessage" runat="server" CssClass="text-success mb-2 d-block"></asp:Label>

        <div class="report-section">
            <!-- الاسم والهاتف -->
            <div class="flex-50">
                <label for="txtFullName">اسم الموظف:</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="report-input" MaxLength="150"></asp:TextBox>
            </div>

            <div class="flex-50">
                <label for="txtPhone">الهاتف:</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="report-input" MaxLength="20"></asp:TextBox>
            </div>

            <!-- العمر -->
            <div class="flex-50">
                <label for="txtAge">العمر:</label>
                <asp:TextBox ID="txtAge" runat="server" CssClass="report-input" MaxLength="3"></asp:TextBox>
            </div>

            <!-- الضمان الاجتماعي -->
            <div class="flex-50">
                <label>الضمان الاجتماعي:</label>
                <div>
                    <asp:RadioButton ID="rdoRegistered" runat="server" GroupName="SocialStatus" Text="مسجل" AutoPostBack="True" OnCheckedChanged="rdoSocialStatus_CheckedChanged" />
                    <asp:RadioButton ID="rdoUnregistered" runat="server" GroupName="SocialStatus" Text="غير مسجل" AutoPostBack="True" OnCheckedChanged="rdoSocialStatus_CheckedChanged" />
                </div>

                <div class="flex-50" id="divSocialNumber">
                    <label for="txtSocialNumber">رقم الضمان الاجتماعي:</label>
                    <asp:TextBox ID="txtSocialNumber" runat="server" CssClass="report-input" MaxLength="50"></asp:TextBox>
                </div>
            </div>

            <!-- تاريخ بداية العمل والعنوان -->
            <div class="flex-50">
                <label for="txtStartDate">تاريخ بداية العمل:</label>
                <asp:TextBox ID="txtStartDate" runat="server" CssClass="report-input" TextMode="Date"></asp:TextBox>
            </div>

            <div class="flex-50">
                <label for="txtAddress">العنوان:</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="report-input" MaxLength="250"></asp:TextBox>
            </div>

            <!-- الحالة الوظيفية -->
            <div class="flex-50">
                <label for="ddlJobStatus">الحالة الوظيفية:</label>
                <asp:DropDownList ID="ddlJobStatus" runat="server" CssClass="report-select">
                    <asp:ListItem Text="نشط" Value="Active"></asp:ListItem>
                    <asp:ListItem Text="غير نشط" Value="Inactive"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- الملاحظات -->
            <div class="flex-100">
                <label for="txtNotes">ملاحظات:</label>
                <asp:TextBox ID="txtNotes" runat="server" CssClass="report-input" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>

            <!-- أزرار الحفظ والتفريغ -->
            <div class="report-actions">
                <asp:Button ID="btnSave" runat="server" CssClass="btn-save" Text="حفظ الموظف" OnClick="btnSave_Click" />
                <asp:Button ID="btnClear" runat="server" CssClass="btn-clear" Text="تفريغ الحقول" OnClick="btnClear_Click" />
                <asp:Button ID="btnBack" runat="server" CssClass="btn-back" Text="⬅ رجوع" PostBackUrl="HomePage.aspx" />
            </div>
        </div>

        <!-- جافاسكريبت لتفعيل/إخفاء رقم الضمان الاجتماعي -->
        <script type="text/javascript">
            function toggleSocialNumber() {
                var registered = document.getElementById('<%= rdoRegistered.ClientID %>').checked;
                document.getElementById('divSocialNumber').style.display = registered ? 'block' : 'none';
            }

            window.onload = toggleSocialNumber;
            document.getElementById('<%= rdoRegistered.ClientID %>').addEventListener('change', toggleSocialNumber);
            document.getElementById('<%= rdoUnregistered.ClientID %>').addEventListener('change', toggleSocialNumber);
        </script>
    </div>
</asp:Content>
