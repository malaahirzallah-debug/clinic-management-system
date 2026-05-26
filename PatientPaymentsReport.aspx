<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="PatientPaymentsReport.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.PatientPaymentsReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="report-container">
        <h2 class="report-title">📊 كشف حساب دفعات المرضى</h2>

        <!-- الفلاتر -->
        <div class="report-filters">
            <div class="filter-item">
                <label>الفترة من:</label>
                <asp:TextBox ID="txtFromDate" runat="server" CssClass="report-input" TextMode="Date"></asp:TextBox>
            </div>
            <div class="filter-item">
                <label>إلى:</label>
                <asp:TextBox ID="txtToDate" runat="server" CssClass="report-input" TextMode="Date"></asp:TextBox>
            </div>
            <div class="filter-item">
                <label>اسم المريض:</label>
                <asp:DropDownList ID="ddlPatients" runat="server" CssClass="report-dropdown">
                    <asp:ListItem Text="الكل" Value="0" />
                </asp:DropDownList>
            </div>
            <div class="filter-item">
                <asp:Button ID="btnSearch" runat="server" CssClass="report-btn" Text="🔍 بحث" />
            </div>
        </div>


        <!-- الجدول -->
        <div class="report-grid">
            <asp:GridView ID="gvPayments" runat="server" AutoGenerateColumns="False" CssClass="report-table" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="TransactionDate" HeaderText="التاريخ" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="PatientName" HeaderText="اسم المريض" />
                    <asp:BoundField DataField="TransactionType" HeaderText="نوع المعاملة" />
                    <asp:BoundField DataField="Notes" HeaderText="ملاحظات" />
                    <asp:BoundField DataField="VisitAmount" HeaderText="الزيارات" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="PaymentAmount" HeaderText="المدفوعات" DataFormatString="{0:N2}" />
                </Columns>
            </asp:GridView>
        </div>

        <div class="summary-cards">
            <div class="card total">
                <h3>المجموع الكلي</h3>
                <p><asp:Label ID="lblTotalAmount" runat="server" Text="0.00"></asp:Label> دينار</p>
            </div>
            <div class="card paid">
                <h3>المدفوع</h3>
                <p><asp:Label ID="lblTotalPaid" runat="server" Text="0.00"></asp:Label> دينار</p>
            </div>
            <div class="card remaining">
                <h3>الرصيد</h3>
                <p><asp:Label ID="lblTotalRemaining" runat="server" Text="0.00"></asp:Label> دينار</p>
            </div>
        </div>

        <!-- الأزرار -->
        <div class="report-actions">
            <asp:Button ID="btnPrint" runat="server" CssClass="report-btn" Text="🖨️ طباعة" />
            <asp:Button ID="btnExportExcel" runat="server" CssClass="report-btn-outline" Text="📄 تصدير Excel" />
            <asp:Button ID="btnExportPDF" runat="server" CssClass="report-btn-outline" Text="📄 تصدير PDF" />
        </div>
    </div>

    <!-- CSS محسن -->
    <style>
        .report-container {
            max-width: 1200px;
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
        .report-btn:hover { background: #1f8f4f; }

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

       .summary-cards {
    display: flex;                  /* خلي الـ parent flex */
    justify-content: center;        /* توسيط البطاقات أفقياً */
    gap: 16px;                      /* مسافة بين البطاقات */
    flex-wrap: wrap;                /* يسمح بالانزلاق للأسفل على الشاشات الصغيرة */
    margin-bottom: 20px;
}

.summary-cards .card {
    flex: 1 1 200px;               /* flex-grow, flex-shrink, flex-basis */
    max-width: 300px;              /* الحد الأقصى للعرض عشان ما يمتد كثير */
    min-width: 180px;
    background: #ecf0f1;
    padding: 16px;
    border-radius: 10px;
    text-align: center;
    font-weight: 600;
    transition: transform 0.2s;
}

.summary-cards .card:hover {
    transform: translateY(-2px);
}

.summary-cards .card.total { background: #3498db; color: white; }
.summary-cards .card.paid { background: #2ecc71; color: white; }
.summary-cards .card.remaining { background: #e74c3c; color: white; }

        .card {
            flex: 1;
            min-width: 180px;
            background: #ecf0f1;
            padding: 16px;
            border-radius: 10px;
            text-align: center;
            font-weight: 600;
            transition: transform 0.2s;
        }
        .card:hover { transform: translateY(-2px); }
        .card.total { background: #3498db; color: white; }
        .card.paid { background: #2ecc71; color: white; }
        .card.remaining { background: #e74c3c; color: white; }

        .report-grid { overflow-x: auto; margin-bottom: 12px; }

        .report-table {
        width: 100% !important;
        border-collapse: collapse !important;
        margin-bottom: 20px !important;
    }
    .report-table th, .report-table td {
        border: 1px solid #ddd !important;
        padding: 10px 12px !important;
        text-align: center !important;
    }
        .report-table th {
        background-color: #2980b9 !important;
        color: white !important;
        font-weight: 600 !important;
    }
    .report-table tr:nth-child(even) {
        background-color: #f4f6f7 !important;
    }

        .report-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }
    </style>
</asp:Content>

