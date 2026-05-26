<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="InsuranceReports.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.InsuranceReports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .report-container {
            max-width: 1100px;
            margin: 24px auto;
            padding: 0 16px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            color: #333;
        }

        .report-title {
            text-align: center;
            margin-bottom: 20px;
            font-weight: 700;
            color: #2c3e50;
        }

        .report-filters {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
            align-items: end;
        }

        .filter-item label {
            display: block;
            margin-bottom: 6px;
            font-size: 14px;
            color: #444;
        }

        .report-input, .report-dropdown {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #dcdfe6;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

            .report-input:focus, .report-dropdown:focus {
                border-color: #27ae60;
                box-shadow: 0 0 0 3px rgba(39,174,96,0.12);
            }

        .report-btn {
            background: #27ae60;
            color: #fff;
            border: none;
            padding: 10px 18px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            transition: background .2s, transform .06s;
        }

            .report-btn:hover {
                background: #1f8f4f;
            }

        .report-btn-outline {
            background: #fff;
            color: #444;
            border: 1px solid #cfd6de;
            padding: 10px 18px;
            border-radius: 10px;
            font-size: 14px;
            cursor: pointer;
            transition: background .2s, color .2s;
        }

            .report-btn-outline:hover {
                background: #f4f6f8;
                color: #111;
            }

        .report-grid {
            overflow-x: auto;
            margin-bottom: 12px;
        }

        .report-table {
            width: 100%;
            border-collapse: collapse;
        }

            .report-table th, .report-table td {
                padding: 10px 12px;
                border-bottom: 1px solid #e0e0e0;
                text-align: center;
            }

            .report-table th {
                background: #f9f9f9;
                font-weight: 600;
                color: #2c3e50;
            }

        .report-summary {
            text-align: right;
            margin-bottom: 12px;
            font-size: 16px;
            font-weight: 600;
        }

        .report-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        @media (max-width: 768px) {
            .report-actions, .report-summary {
                text-align: center;
            }
        }
    </style>

    <div class="report-container">
        <h2 class="report-title">تقارير شركات التأمين</h2>

        <div class="report-filters">
            <div class="filter-item">
                <label for="txtFromDate">من تاريخ</label>
                <asp:TextBox ID="txtFromDate" runat="server" CssClass="report-input" TextMode="Date"></asp:TextBox>
            </div>

            <div class="filter-item">
                <label for="txtToDate">إلى تاريخ</label>
                <asp:TextBox ID="txtToDate" runat="server" CssClass="report-input" TextMode="Date"></asp:TextBox>
            </div>

            <div class="filter-item">
                <label for="ddlReport">اختر التقرير</label>
                <asp:DropDownList ID="ddlReport" runat="server" CssClass="report-dropdown">
                    <asp:ListItem Value="1">تفاصيل المرضى وحالة الاشتراك</asp:ListItem>
                    <asp:ListItem Value="2">الزيارات الطبية والتقارير مع مبالغ التأمين والمريض</asp:ListItem>
                    <asp:ListItem Value="3">مبالغ التأمين والمريض لكل زيارة</asp:ListItem>
                    <asp:ListItem Value="4">ملخص الزيارات لكل طبيب</asp:ListItem>
                    <asp:ListItem Value="5">المرضى بتأمين منتهي أو على وشك الانتهاء</asp:ListItem>
                    <asp:ListItem Value="6">مبالغ مستحقة للمرضى حسب التأمين أو كاش</asp:ListItem>
                    <asp:ListItem Value="7">مجموع مبالغ التأمين والمريض حسب شركة التأمين</asp:ListItem>
                    <asp:ListItem Value="8">عدد الزيارات الشهرية لكل شركة تأمين خلال آخر 6 أشهر</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="filter-item">
                <asp:Button ID="btnGenerate" runat="server" Text="توليد التقرير" CssClass="report-btn" />
            </div>
        </div>

        <div class="report-actions">
            <asp:Button ID="btnExportExcel" runat="server" Text="تصدير Excel" CssClass="report-btn-outline" />
            <asp:Button ID="btnExportPdf" runat="server" Text="تصدير PDF" CssClass="report-btn-outline" />
        </div>

        <div class="report-summary" id="reportSummary" runat="server">
            <!-- هنا يظهر الملخص -->
        </div>

        <div class="report-grid">
            <asp:GridView ID="gvReport" runat="server" AutoGenerateColumns="True" CssClass="report-table"></asp:GridView>
        </div>
    </div>

</asp:Content>
