<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="AddDoctor.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.AddDoctor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="medical-report-container">
        <h2 class="report-title">➕ إضافة طبيب جديد</h2>

        <div class="report-section">
            <label>اسم الطبيب:</label>
            <asp:TextBox ID="txtDoctorName" runat="server" CssClass="report-input" />

            <label>التخصص:</label>
            <asp:TextBox ID="txtSpecialty" runat="server" CssClass="report-input" />

            <label>رقم الهاتف:</label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="report-input" />

            <label>تفعيل الطبيب:</label>
            <asp:CheckBox ID="chkActive" runat="server" Checked="true" />

            <label>تاريخ الإضافة:</label>
            <asp:TextBox ID="txtCreatedAt" runat="server" CssClass="report-input" ReadOnly="true" />
        </div>

        <div class="report-actions">
            <asp:Button ID="btnSaveDoctor" runat="server" CssClass="btn-save" Text="💾 حفظ الطبيب" />
            <asp:Button ID="btnClearDoctor" runat="server" CssClass="btn-clear" Text="🧹 مسح الحقول" />
        </div>
    </div>

    <script>
        // ضبط تاريخ الإضافة تلقائياً عند تحميل الصفحة
        window.addEventListener('DOMContentLoaded', () => {
            const txtCreatedAt = document.getElementById('<%= txtCreatedAt.ClientID %>');
            txtCreatedAt.value = new Date().toLocaleString('ar-JO', { hour12: false });
        });
    </script>

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

            .report-section label {
                flex-basis: 100%;
                margin-bottom: 4px;
            }

        .report-input {
            padding: 10px 14px;
            border-radius: 10px;
            border: 1px solid #ccc;
            flex: 1 1 48%;
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
            .report-input {
                flex: 1 1 100%;
            }
        }
    </style>
</asp:Content>
