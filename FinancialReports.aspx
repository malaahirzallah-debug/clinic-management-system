<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="FinancialReports.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.FinancialReports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .report-container {
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

            .report-container h2 {
                text-align: center;
                margin-bottom: 25px;
                color: #333;
                font-weight: 600;
            }

        .filters {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
            margin-bottom: 20px;
        }

            .filters .form-control, .filters .btn {
                min-width: 160px;
            }

        .actions {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 14px;
        }

            .table th, .table td {
                padding: 12px 15px;
                border: 1px solid #ddd;
                text-align: center;
            }

            .table th {
                background-color: #007bff;
                color: #fff;
                font-weight: 600;
            }

        .table-striped tbody tr:nth-child(odd) {
            background-color: #f1f3f6;
        }

        .summary {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
            margin-top: 15px;
        }

            .summary .card {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 15px 20px;
                text-align: center;
                min-width: 160px;
                flex: 1 1 150px;
            }

                .summary .card h4 {
                    margin: 0;
                    font-size: 16px;
                    color: #555;
                }

                .summary .card p {
                    margin: 5px 0 0 0;
                    font-size: 18px;
                    font-weight: 600;
                    color: #007bff;
                }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
            color: #fff;
            font-weight: 500;
            transition: 0.3s;
        }

            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #0056b3;
            }

        .filters {
            display: flex;
            align-items: center;
            gap: 10px; /* مسافة بين العناصر */
            flex-wrap: wrap; /* يخليهم ينزلوا لسطر جديد إذا الشاشة صغيرة */
        }

            .filters label {
                margin: 0 5px;
                white-space: nowrap; /* يخلي كلمة "من" و "إلى" ما تنكسر */
            }

            .filters .form-control {
                width: auto; /* يخلي التواريخ والدروب داون ياخدوا حجم مناسب */
                min-width: 150px; /* حد أدنى للطول */
            }
    </style>

    <div class="report-container">
        <h2>التقارير المالية والمحاسبية</h2>

        <!-- الفلاتر -->
        <div class="filters">
            <label for="txtFromDate">من:</label>
            <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>

            <label for="txtToDate">إلى:</label>
            <asp:TextBox ID="txtToDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>

            <asp:DropDownList ID="ddlReportType" runat="server" CssClass="form-control">
                <asp:ListItem Text="الكل" Value="All" />
                <asp:ListItem Text="إيرادات" Value="Income" />
                <asp:ListItem Text="مصروفات" Value="Expenses" />
                <asp:ListItem Text="المشتريات" Value="Purchases" />
                <asp:ListItem Text="السحوبات" Value="Withdrawals" />
                <asp:ListItem Text="الإيرادات حسب الطبيب" Value="IncomeByDoctor" />
                <asp:ListItem Text="الإيرادات حسب نوع الخدمة" Value="IncomeByService" />
                <asp:ListItem Text="المصاريف حسب النوع" Value="ExpensesByType" />
                <asp:ListItem Text="المشتريات حسب البند" Value="PurchasesByItem" />
                <asp:ListItem Text="السحوبات حسب الجهة" Value="WithdrawalsByEntity" />
                <asp:ListItem Text="السحوبات حسب الموظف" Value="WithdrawalsByEmployee" />
                <asp:ListItem Text="السحوبات حسب المورد" Value="WithdrawalsBySupplier" />
            </asp:DropDownList>

            <asp:Button ID="btnGenerate" runat="server" Text="بحث" CssClass="btn btn-primary" OnClick="btnGenerate_Click" />
        </div>

        <!-- أزرار إضافية -->
        <div class="actions">
            <asp:Button ID="btnPrint" runat="server" Text="🖨️ طباعة" CssClass="btn btn-primary" OnClick="btnPrint_Click" />
            <asp:Button ID="btnPdf" runat="server" Text="📄 PDF" CssClass="btn btn-primary" OnClick="btnPdf_Click" />
            <asp:Button ID="btnExcel" runat="server" Text="📊 Excel" CssClass="btn btn-primary" OnClick="btnExcel_Click" />
        </div>

        <!-- الداتا غريد -->
        <asp:GridView ID="gvReport" runat="server" AutoGenerateColumns="true" CssClass="table table-striped table-bordered"></asp:GridView>

        <!-- الملخص -->
        <div class="summary">
            <div class="card">
                <h4>إجمالي الإيرادات</h4>
                <p>
                    <asp:Label ID="lblTotalIncome" runat="server" Text=""></asp:Label></p>
            </div>
            <div class="card">
                <h4>إجمالي المصروفات</h4>
                <p>
                    <asp:Label ID="lblTotalExpenses" runat="server" Text=""></asp:Label></p>
            </div>
            <div class="card">
                <h4>إجمالي المشتريات</h4>
                <p>
                    <asp:Label ID="lblTotalPurchases" runat="server" Text=""></asp:Label></p>
            </div>
            <div class="card">
                <h4>إجمالي السحوبات</h4>
                <p>
                    <asp:Label ID="lblTotalWithdrawals" runat="server" Text=""></asp:Label></p>
            </div>
            <div class="card">
                <h4>صافي الربح</h4>
                <p>
                    <asp:Label ID="lblNetProfit" runat="server" Text=""></asp:Label></p>
            </div>
        </div>
    </div>
</asp:Content>
