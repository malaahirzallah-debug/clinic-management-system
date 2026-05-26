Imports System.Data
Imports System.IO
Imports ClosedXML.Excel
Imports SelectPdf
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls

Public Class PatientPaymentsReport
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then LoadPatients()
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Private Sub LoadPatients()
        ddlPatients.Items.Clear()
        ddlPatients.Items.Add(New ListItem("الكل", "0"))

        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using con As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT PatientID, FullName FROM Patients WHERE ClinicID=@ClinicID ORDER BY FullName", con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                con.Open()
                Dim reader = cmd.ExecuteReader()
                While reader.Read()
                    ddlPatients.Items.Add(New ListItem(reader("FullName").ToString(), reader("PatientID").ToString()))
                End While
            End Using
        End Using
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        BindGrid()
    End Sub

    Private Sub BindGrid()
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim patientID As Integer = Convert.ToInt32(ddlPatients.SelectedValue)

        ' جلب الزيارات مع CreatedAt
        Dim visits As New DataTable()
        Using con As New SqlConnection(connStr)
            Dim sqlVisits As String = "
SELECT v.VisitID, v.CreatedAt, v.VisitDate, v.MedicalReport AS Notes, 
       v.VisitAmount, v.PatientID, p.FullName AS PatientName,
       N'زيارة \ ' + 
       CASE v.PaymentMethod
           WHEN 'cash' THEN N'كاش'
           WHEN 'debt' THEN N'ذمم'
           WHEN 'insurance' THEN N'تغطية تأمين'
           ELSE v.PaymentMethod
       END AS TransactionType
FROM Visits v
INNER JOIN Patients p ON v.PatientID = p.PatientID
WHERE v.ClinicID=@ClinicID"

            If Not String.IsNullOrEmpty(txtFromDate.Text) Then sqlVisits &= " AND v.VisitDate >= @FromDate"
            If Not String.IsNullOrEmpty(txtToDate.Text) Then sqlVisits &= " AND v.VisitDate <= @ToDate"
            If patientID <> 0 Then sqlVisits &= " AND v.PatientID=@PatientID"

            sqlVisits &= " ORDER BY v.CreatedAt ASC"

            Using cmd As New SqlCommand(sqlVisits, con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)

                If Not String.IsNullOrEmpty(txtFromDate.Text) Then cmd.Parameters.AddWithValue("@FromDate", Convert.ToDateTime(txtFromDate.Text))
                If Not String.IsNullOrEmpty(txtToDate.Text) Then cmd.Parameters.AddWithValue("@ToDate", Convert.ToDateTime(txtToDate.Text))
                If patientID <> 0 Then cmd.Parameters.AddWithValue("@PatientID", patientID)

                Using da As New SqlDataAdapter(cmd)
                    da.Fill(visits)
                End Using
            End Using
        End Using

        ' جلب الدفعات مع CreatedAt
        Dim payments As New DataTable()
        Using con As New SqlConnection(connStr)
            Dim sqlPayments As String = "
        SELECT pay.CreatedAt, pay.PaymentType, pay.PayDate, pay.Notes, pay.Amount, pay.VisitID, pay.PatientID,
               ISNULL(p.FullName,'') AS PatientName
        FROM Payments pay
        LEFT JOIN Patients p ON p.PatientID = pay.PatientID AND p.ClinicID = @ClinicID
        WHERE pay.ClinicID=@ClinicID"

            ' إضافة شرط التواريخ إذا تم تحديدها
            If Not String.IsNullOrEmpty(txtFromDate.Text) Then sqlPayments &= " AND pay.PayDate >= @FromDate"
            If Not String.IsNullOrEmpty(txtToDate.Text) Then sqlPayments &= " AND pay.PayDate <= @ToDate"
            If patientID <> 0 Then sqlPayments &= " AND pay.PatientID=@PatientID"

            sqlPayments &= " ORDER BY pay.CreatedAt ASC"

            Using cmd As New SqlCommand(sqlPayments, con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                If Not String.IsNullOrEmpty(txtFromDate.Text) Then cmd.Parameters.AddWithValue("@FromDate", Convert.ToDateTime(txtFromDate.Text))
                If Not String.IsNullOrEmpty(txtToDate.Text) Then cmd.Parameters.AddWithValue("@ToDate", Convert.ToDateTime(txtToDate.Text))
                If patientID <> 0 Then cmd.Parameters.AddWithValue("@PatientID", patientID)

                Using da As New SqlDataAdapter(cmd)
                    da.Fill(payments)
                End Using
            End Using
        End Using

        ' إنشاء التقرير النهائي
        Dim report As New DataTable()
        report.Columns.Add("TransactionDate", GetType(Date))
        report.Columns.Add("PatientName", GetType(String))
        report.Columns.Add("TransactionType", GetType(String))
        report.Columns.Add("Notes", GetType(String))
        report.Columns.Add("VisitAmount", GetType(Decimal))
        report.Columns.Add("PaymentAmount", GetType(Decimal))

        ' إضافة الزيارات
        ' إضافة الزيارات مع نوعها بالعربي
        For Each r As DataRow In visits.Rows
            report.Rows.Add(r("CreatedAt"), r("PatientName"), r("TransactionType"), r("Notes"), Convert.ToDecimal(r("VisitAmount")), 0D)
        Next

        ' إضافة الدفعات مع تحويل نوع الدفع
        For Each pRow As DataRow In payments.Rows
            Dim paymentType As String = pRow("PaymentType").ToString().ToLower()
            Dim transactionType As String
            Select Case paymentType
                Case "debt"
                    transactionType = "تسديد ذمم"
                Case "subscription"
                    transactionType = "دفع اشتراك"
                Case "cash"
                    transactionType = "دفعة زيارة"
                Case "insurance"
                    transactionType = "تغطية تأمين"
            End Select
            report.Rows.Add(pRow("CreatedAt"), pRow("PatientName"), transactionType, pRow("Notes"), 0D, Convert.ToDecimal(pRow("Amount")))
        Next

        ' ترتيب التقرير حسب CreatedAt بدقة الوقت
        report.DefaultView.Sort = "TransactionDate ASC"
        report = report.DefaultView.ToTable()

        ' ربط GridView
        gvPayments.DataSource = report
        gvPayments.DataBind()

        ' حساب الإجماليات
        Dim totalVisit As Decimal = 0, totalPayment As Decimal = 0
        For Each row As DataRow In report.Rows
            totalVisit += Convert.ToDecimal(row("VisitAmount"))
            totalPayment += Convert.ToDecimal(row("PaymentAmount"))
        Next
        lblTotalAmount.Text = totalVisit.ToString("N2")
        lblTotalPaid.Text = totalPayment.ToString("N2")
        lblTotalRemaining.Text = (totalPayment - totalVisit).ToString("N2")
    End Sub

    Protected Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
        ClientScript.RegisterStartupScript(Me.GetType(), "print", "window.print();", True)
    End Sub

    Protected Sub btnExportExcel_Click(sender As Object, e As EventArgs) Handles btnExportExcel.Click
        BindGrid()
        Dim dt As New DataTable()
        For Each col As DataControlField In gvPayments.Columns
            dt.Columns.Add(col.HeaderText)
        Next
        For Each gvr As GridViewRow In gvPayments.Rows
            Dim dr As DataRow = dt.NewRow()
            For i As Integer = 0 To gvr.Cells.Count - 1
                dr(i) = gvr.Cells(i).Text.Replace("&nbsp;", "")
            Next
            dt.Rows.Add(dr)
        Next
        Using wb As New XLWorkbook()
            wb.Worksheets.Add(dt, "PatientPayments")
            Response.Clear()
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            Response.AddHeader("content-disposition", "attachment;filename=PatientPaymentsReport.xlsx")
            Using ms As New MemoryStream()
                wb.SaveAs(ms)
                ms.WriteTo(Response.OutputStream)
                Response.Flush()
                Response.End()
            End Using
        End Using
    End Sub

    Protected Sub btnExportPDF_Click(sender As Object, e As EventArgs) Handles btnExportPDF.Click
        BindGrid()
        Dim htmlString As String
        Using sw As New StringWriter()
            gvPayments.RenderControl(New HtmlTextWriter(sw))
            htmlString = sw.ToString()
        End Using
        Dim converter As New HtmlToPdf()
        Dim doc As PdfDocument = converter.ConvertHtmlString(htmlString)
        Response.Clear()
        Response.ContentType = "application/pdf"
        Response.AddHeader("content-disposition", "attachment;filename=PatientPaymentsReport.pdf")
        doc.Save(Response.OutputStream)
        doc.Close()
        Response.End()
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(control As Control)
        ' Required for exporting GridView
    End Sub
End Class
