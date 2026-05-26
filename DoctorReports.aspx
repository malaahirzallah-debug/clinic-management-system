<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="DoctorReports.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.DoctorReports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="medical-report-container">
        <h2 class="report-title">📊 تقارير الأطباء</h2>

        <div class="form-row mb-3">
            <asp:Label ID="lblFrom" runat="server" Text="من:" CssClass="simple-label"></asp:Label>
            <asp:TextBox ID="txtFromReport" runat="server" TextMode="Date" CssClass="simple-input"></asp:TextBox>

            <asp:Label ID="lblTo" runat="server" Text="إلى:" CssClass="simple-label"></asp:Label>
            <asp:TextBox ID="txtToReport" runat="server" TextMode="Date" CssClass="simple-input"></asp:TextBox>
        </div>

        <div class="form-row mb-3">
            <asp:Label ID="lblDoctor" runat="server" Text="اختر الطبيب:" CssClass="simple-label"></asp:Label>
            <asp:DropDownList ID="ddlDoctors" runat="server" CssClass="simple-input"></asp:DropDownList>
        </div>

        <div class="form-row mb-3">
            <asp:Label ID="lblReportType" runat="server" Text="نوع التقرير:" CssClass="simple-label"></asp:Label>
            <asp:DropDownList ID="ddlReportType" runat="server" CssClass="simple-input">
                <asp:ListItem Text="جميع المعالجات" Value="جميع المعالجات" />
                <asp:ListItem Text="الدخل الناتج" Value="الدخل الناتج" />
                <asp:ListItem Text="الإجراءات التي تم تنفيذها" Value="الإجراءات التي تم تنفيذها" />
                <asp:ListItem Text="الأدوية الموصوفة" Value="الأدوية الموصوفة" />
                <asp:ListItem Text="عدد المرضى" Value="عدد المرضى" />
                <asp:ListItem Text="جدول الدوام" Value="جدول الدوام" />
                <asp:ListItem Text="ملخص يومي" Value="ملخص يومي" />
            </asp:DropDownList>
        </div>

        <div class="form-row mb-3">
            <asp:Button ID="btnShowReport" runat="server" Text="عرض التقرير" CssClass="simple-btn" OnClick="btnShowReport_Click" />
        </div>

        <div class="form-row mb-2" style="gap: 8px;">
            <asp:Button ID="btnPrint" runat="server" Text="🖨️ طباعة" CssClass="simple-btn" OnClick="btnPrint_Click" />
            <asp:Button ID="btnExportExcel" runat="server" Text="📊 Excel" CssClass="simple-btn" OnClick="btnExportExcel_Click" />
            <asp:Button ID="btnExportPDF" runat="server" Text="📄 PDF" CssClass="simple-btn" OnClick="btnExportPDF_Click" />
        </div>

        <asp:GridView ID="gvReport" runat="server" AutoGenerateColumns="True" CssClass="simple-gridview"
    EmptyDataText="لا توجد بيانات لعرضها" GridLines="None" Width="100%">
</asp:GridView>

        <div class="form-row mb-3">
    <asp:Literal ID="litTotals" runat="server"></asp:Literal>
</div>


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

        .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: center;
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
            margin-top: 16px;
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
            .form-row {
                flex-direction: column;
                align-items: stretch;
            }

            .simple-input, .simple-btn {
                width: 100%;
            }
        }
    </style>
</asp:Content>
