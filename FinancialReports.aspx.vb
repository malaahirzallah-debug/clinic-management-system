Imports System.Data
Imports System.Data.SqlClient

Public Class FinancialReports
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub
    Protected Sub btnGenerate_Click(sender As Object, e As EventArgs)
        Dim dt As New DataTable
        Dim totalIncome As Decimal = 0
        Dim totalExpenses As Decimal = 0
        Dim totalPurchases As Decimal = 0
        Dim totalWithdrawals As Decimal = 0

        Dim clinicId As Integer = Convert.ToInt32(Session("ClinicID"))

        Dim fromDate As Date
        Dim toDate As Date

        If String.IsNullOrWhiteSpace(txtFromDate.Text) OrElse String.IsNullOrWhiteSpace(txtToDate.Text) Then
            Dim today As Date = Date.Today
            fromDate = New Date(today.Year, today.Month, 1)
            toDate = fromDate.AddMonths(1).AddDays(-1)
        Else
            fromDate = Date.Parse(txtFromDate.Text)
            toDate = Date.Parse(txtToDate.Text)
        End If

        Using conn As New SqlConnection(connStr)
            conn.Open()

            Select Case ddlReportType.SelectedValue
            ' ✅ الإيرادات مع اسم المريض
                Case "All", "Income"
                    Dim cmd As New SqlCommand("
                    SELECT P.PayDate, P.Amount, PT.FullName AS PatientName, P.Notes, P.PaymentType
                    FROM Payments P
                    JOIN Patients PT ON P.PatientID = PT.PatientID
                    WHERE P.ClinicID=@ClinicID AND P.PayDate BETWEEN @d1 AND @d2", conn)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@d1", fromDate)
                    cmd.Parameters.AddWithValue("@d2", toDate)
                    dt.Load(cmd.ExecuteReader())
                    totalIncome = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("Amount")), 0D, Convert.ToDecimal(r("Amount"))))

            ' ✅ المصروفات
                Case "All", "Expenses"
                    Dim cmd As New SqlCommand("
                    SELECT E.ExpenseDate, ET.TypeName AS ExpenseType, E.Amount, E.PaymentMethod, E.Notes
                    FROM Expenses E
                    JOIN ExpenseTypes ET ON E.ExpenseTypeID = ET.ExpenseTypeID
                    WHERE E.ClinicID=@ClinicID AND E.ExpenseDate BETWEEN @d1 AND @d2", conn)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@d1", fromDate)
                    cmd.Parameters.AddWithValue("@d2", toDate)
                    dt.Load(cmd.ExecuteReader())
                    totalExpenses = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("Amount")), 0D, Convert.ToDecimal(r("Amount"))))

            ' ✅ المشتريات مع قيمة الفاتورة، طريقة الدفع والضرائب
                Case "All", "Purchases"
                    ' إعداد الاتصال
                    Dim cmd As New SqlCommand("SELECT PI.InvoiceDate, PI.InvoiceNo, PI.GrandTotal, 
               PI.TotalTax, S.CompanyName AS SupplierName, PI.PaymentMethod, PI.Notes FROM PurchaseInvoices PI
        JOIN Suppliers S ON PI.SupplierID = S.SupplierID WHERE PI.ClinicID=@ClinicID AND PI.InvoiceDate BETWEEN @d1 AND @d2", conn)

                    ' تمرير المعاملات
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@d1", fromDate)
                    cmd.Parameters.AddWithValue("@d2", toDate)

                    ' تنفيذ الاستعلام وتحميل النتائج
                    dt.Load(cmd.ExecuteReader())

                    ' حساب إجمالي المشتريات
                    totalPurchases = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("GrandTotal")), 0D, Convert.ToDecimal(r("GrandTotal"))))

                    ' حساب إجمالي الضرائب
                    'totalTaxes = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalTax")), 0D, Convert.ToDecimal(r("TotalTax"))))

           ' ✅ السحوبات مع اسم الجهة المستفيدة
                Case "All", "Withdrawals"
                    Dim cmd As New SqlCommand("SELECT W.WithdrawalDate, W.Amount, W.Details AS EntityName, 
                         W.PaymentMethod, W.Notes FROM Withdrawals W WHERE W.ClinicID=@ClinicID 
                         AND W.WithdrawalDate BETWEEN @d1 AND @d2", conn)

                    ' تمرير المعاملات
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@d1", fromDate)
                    cmd.Parameters.AddWithValue("@d2", toDate)

                    ' تنفيذ الاستعلام وتحميل النتائج
                    dt.Load(cmd.ExecuteReader())

                    ' حساب إجمالي السحوبات
                    totalWithdrawals = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("Amount")), 0D, Convert.ToDecimal(r("Amount"))))

            ' ✅ الإيرادات حسب الطبيب
                Case "IncomeByDoctor"
                    Dim cmd As New SqlCommand("
                    SELECT D.Name AS DoctorName, SUM(V.PaidAmount) AS TotalIncome
                    FROM Visits V
                    JOIN Doctors D ON V.DoctorID = D.DoctorID
                    WHERE V.ClinicID=@ClinicID AND V.VisitDate BETWEEN @d1 AND @d2
                    GROUP BY D.Name", conn)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@d1", fromDate)
                    cmd.Parameters.AddWithValue("@d2", toDate)
                    dt.Load(cmd.ExecuteReader())
                    totalIncome = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalIncome")), 0D, Convert.ToDecimal(r("TotalIncome"))))

            ' ✅ الإيرادات حسب الخدمة (من جدول Visits)
                Case "IncomeByService"
                    Dim cmd As New SqlCommand("SELECT V.MedicalReport AS ServiceType, COUNT(*) AS ReportsCount, 
               SUM(V.VisitAmount) AS TotalIncome FROM Visits V WHERE V.ClinicID=@ClinicID 
          AND V.VisitDate BETWEEN @d1 AND @d2 GROUP BY V.MedicalReport", conn)

                    ' تمرير المعاملات
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@d1", fromDate)
                    cmd.Parameters.AddWithValue("@d2", toDate)

                    ' تنفيذ الاستعلام وتحميل النتائج
                    dt.Load(cmd.ExecuteReader())

                    ' حساب إجمالي الإيرادات
                    totalIncome = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("TotalIncome")), 0D, Convert.ToDecimal(r("TotalIncome"))))

            ' ✅ السحوبات حسب الموظف (تم تعديل الـ JOIN)
                Case "WithdrawalsByEmployee"
                    Dim cmd As New SqlCommand("
                    SELECT W.WithdrawalDate, W.Amount, E.FullName AS EmployeeName, W.Notes
                    FROM Withdrawals W
                    JOIN Employees E ON W.EmployeeID = E.EmployeeID
                    WHERE W.ClinicID=@ClinicID AND W.WithdrawalDate BETWEEN @d1 AND @d2
                    ORDER BY W.WithdrawalDate DESC", conn)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@d1", fromDate)
                    cmd.Parameters.AddWithValue("@d2", toDate)
                    dt.Load(cmd.ExecuteReader())
                    totalWithdrawals = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("Amount")), 0D, Convert.ToDecimal(r("Amount"))))

            ' ✅ السحوبات حسب المورد (تصحيح الـ JOIN)
                Case "WithdrawalsBySupplier"
                    Dim cmd As New SqlCommand("
                    SELECT W.WithdrawalDate, W.Amount, S.CompanyName AS SupplierName, W.Notes
                    FROM Withdrawals W
                    JOIN Suppliers S ON W.SupplierID = S.SupplierID
                    WHERE W.ClinicID=@ClinicID AND W.WithdrawalDate BETWEEN @d1 AND @d2
                    ORDER BY W.WithdrawalDate DESC", conn)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@d1", fromDate)
                    cmd.Parameters.AddWithValue("@d2", toDate)
                    dt.Load(cmd.ExecuteReader())
                    totalWithdrawals = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r("Amount")), 0D, Convert.ToDecimal(r("Amount"))))
            End Select
        End Using

        gvReport.DataSource = dt
        gvReport.DataBind()

        lblTotalIncome.Text = "إجمالي الإيرادات: " & totalIncome.ToString("N2") & " د.أ"
        lblTotalExpenses.Text = "إجمالي المصروفات: " & totalExpenses.ToString("N2") & " د.أ"
        lblTotalPurchases.Text = "إجمالي المشتريات: " & totalPurchases.ToString("N2") & " د.أ"
        lblTotalWithdrawals.Text = "إجمالي السحوبات: " & totalWithdrawals.ToString("N2") & " د.أ"
        lblNetProfit.Text = "صافي الربح: " & (totalIncome - totalExpenses - totalPurchases - totalWithdrawals).ToString("N2") & " د.أ"
    End Sub

    Protected Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click

    End Sub

    Protected Sub btnPdf_Click(sender As Object, e As EventArgs) Handles btnPdf.Click

    End Sub

    Protected Sub btnExcel_Click(sender As Object, e As EventArgs) Handles btnExcel.Click

    End Sub
End Class