Imports System.Data
Imports System.IO
Imports ClosedXML.Excel
Imports SelectPdf
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls

Public Class DoctorReports
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim today As DateTime = DateTime.Today
            Dim startOfMonth As New DateTime(today.Year, today.Month, 1)
            Dim endOfMonth As DateTime = startOfMonth.AddMonths(1).AddDays(-1)
            txtFromReport.Text = startOfMonth.ToString("yyyy-MM-dd")
            txtToReport.Text = endOfMonth.ToString("yyyy-MM-dd")

            LoadDoctors()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Private Sub LoadDoctors()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT DoctorID, Name FROM Doctors WHERE Active = 1 AND ClinicID = @ClinicID", conn)
            cmd.Parameters.AddWithValue("@ClinicID", Session("ClinicID"))
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            da.Fill(dt)

            ddlDoctors.DataSource = dt
            ddlDoctors.DataTextField = "Name"
            ddlDoctors.DataValueField = "DoctorID"
            ddlDoctors.DataBind()
            ddlDoctors.Items.Insert(0, New ListItem("كل الأطباء", "0"))
        End Using
    End Sub

    Protected Sub btnShowReport_Click(sender As Object, e As EventArgs) Handles btnShowReport.Click
        Dim dt As DataTable = GetReportData()
        gvReport.DataSource = dt
        gvReport.DataBind()

        ' حساب المجاميع وعرضها
        If dt.Rows.Count > 0 Then
            Dim html As New System.Text.StringBuilder()
            html.Append("<table style='width:100%; border-top:2px solid #27ae60; margin-top:10px;'>")
            html.Append("<tr style='font-weight:bold; background-color:#f2f2f2;'>")

            For Each col As DataColumn In dt.Columns
                If IsNumericColumn(col) Then
                    Dim sum As Decimal = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r(col)), 0D, Convert.ToDecimal(r(col))))
                    html.Append($"<td style='padding:5px; text-align:center;'>{sum}</td>")
                Else
                    html.Append("<td style='padding:5px; text-align:center;'>المجموع</td>")
                End If
            Next

            html.Append("</tr></table>")

            litTotals.Text = html.ToString()
        Else
            litTotals.Text = ""
        End If
    End Sub


    Private Function GetReportData() As DataTable
        Dim dt As New DataTable()
        Dim fromDate As DateTime
        Dim toDate As DateTime
        If Not DateTime.TryParse(txtFromReport.Text, fromDate) Then fromDate = DateTime.Today
        If Not DateTime.TryParse(txtToReport.Text, toDate) Then toDate = DateTime.Today
        Dim doctorID As Integer = Convert.ToInt32(ddlDoctors.SelectedValue)
        Dim reportType As String = ddlReportType.SelectedValue

        Using conn As New SqlConnection(connStr)
            Dim query As String = ""

            Select Case reportType
                Case "جميع المعالجات"
                    query = "SELECT v.VisitID, 
                    p.FullName AS PatientName, 
                    d.Name AS DoctorName, 
                    v.CreatedAt, 
                    v.MedicalReport, 
                    v.VisitAmount " &
                            "FROM Visits v " &
                            "INNER JOIN Patients p ON v.PatientID = p.PatientID " &
                            "INNER JOIN Doctors d ON v.DoctorID = d.DoctorID " &
                            "WHERE v.VisitDate BETWEEN @FromDate AND @ToDate 
                   AND d.ClinicID = @ClinicID"
                Case "الدخل الناتج"
                    query = "SELECT d.Name AS DoctorName, 
                    SUM(v.VisitAmount) AS TotalIncome " &
                            "FROM Visits v " &
                            "INNER JOIN Doctors d ON v.DoctorID = d.DoctorID " &
                            "WHERE v.VisitDate BETWEEN @FromDate AND @ToDate 
                   AND d.ClinicID = @ClinicID " &
                            "GROUP BY d.Name"
                Case "الإجراءات التي تم تنفيذها"
                    query = "SELECT d.Name AS DoctorName, v.MedicalReport, COUNT(*) AS Count " &
                            "FROM Visits v " &
                            "INNER JOIN Doctors d ON v.DoctorID = d.DoctorID " &
                            "WHERE v.VisitDate BETWEEN @FromDate AND @ToDate AND d.ClinicID = @ClinicID " &
                            "GROUP BY d.Name, v.MedicalReport"
                Case "الأدوية الموصوفة"
                    query = "SELECT d.Name AS DoctorName, v.Medicines, COUNT(*) AS Count " &
                            "FROM Visits v " &
                            "INNER JOIN Doctors d ON v.DoctorID = d.DoctorID " &
                            "WHERE v.VisitDate BETWEEN @FromDate AND @ToDate 
                   AND d.ClinicID = @ClinicID 
                   AND v.Medicines IS NOT NULL 
                   AND LTRIM(RTRIM(v.Medicines)) <> '' " &
                            "GROUP BY d.Name, v.Medicines"
                Case "عدد المرضى"
                    query = "SELECT d.Name AS DoctorName, COUNT(DISTINCT v.PatientID) AS PatientCount " &
                            "FROM Visits v " &
                            "INNER JOIN Doctors d ON v.DoctorID = d.DoctorID " &
                            "WHERE v.VisitDate BETWEEN @FromDate AND @ToDate AND d.ClinicID = @ClinicID " &
                            "GROUP BY d.Name"
                Case "جدول الدوام"
                    query = "SELECT d.Name AS DoctorName, s.ScheduleDate, s.IsWorking, s.StartTime, s.EndTime " &
                            "FROM DoctorSchedule s " &
                            "INNER JOIN Doctors d ON s.DoctorID = d.DoctorID " &
                            "WHERE s.ScheduleDate BETWEEN @FromDate AND @ToDate AND d.ClinicID = @ClinicID"
                Case "ملخص يومي"
                    query = "SELECT d.Name AS DoctorName, 
                    COUNT(v.VisitID) AS VisitsCount, 
                    SUM(v.VisitAmount) AS TotalIncome " &
                            "FROM Visits v " &
                            "INNER JOIN Doctors d ON v.DoctorID = d.DoctorID " &
                            "WHERE v.VisitDate BETWEEN @FromDate AND @ToDate 
                   AND d.ClinicID = @ClinicID " &
                            "GROUP BY d.Name"
            End Select

            If doctorID <> 0 Then
                If query.Contains(" v.") Then
                    query &= " AND v.DoctorID = @DoctorID"
                ElseIf query.Contains(" s.") Then
                    query &= " AND s.DoctorID = @DoctorID"
                End If
            End If

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@FromDate", fromDate)
                cmd.Parameters.AddWithValue("@ToDate", toDate)
                cmd.Parameters.AddWithValue("@ClinicID", Session("ClinicID"))
                If doctorID <> 0 Then cmd.Parameters.AddWithValue("@DoctorID", doctorID)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
            End Using
        End Using

        Return dt
    End Function

    Protected Sub btnExportExcel_Click(sender As Object, e As EventArgs) Handles btnExportExcel.Click
        Dim dt As DataTable = GetReportData()
        If dt.Rows.Count = 0 Then Exit Sub

        Using wb As New XLWorkbook()
            Dim ws = wb.Worksheets.Add("تقرير الأطباء")

            ' رؤوس الأعمدة
            For col As Integer = 0 To dt.Columns.Count - 1
                ws.Cell(1, col + 1).Value = dt.Columns(col).ColumnName
            Next

            ' البيانات
            For row As Integer = 0 To dt.Rows.Count - 1
                For col As Integer = 0 To dt.Columns.Count - 1
                    Dim value = dt.Rows(row)(col)
                    If IsDBNull(value) Then
                        ws.Cell(row + 2, col + 1).Value = ""
                    ElseIf TypeOf value Is Integer OrElse TypeOf value Is Decimal OrElse TypeOf value Is Double OrElse TypeOf value Is Single Then
                        ws.Cell(row + 2, col + 1).Value = Convert.ToDouble(value)
                    Else
                        ws.Cell(row + 2, col + 1).Value = value.ToString()
                    End If
                Next
            Next

            ' المجاميع
            Dim totalRow As Integer = dt.Rows.Count + 2
            For col As Integer = 0 To dt.Columns.Count - 1
                If IsNumericColumn(dt.Columns(col)) Then
                    ws.Cell(totalRow, col + 1).FormulaA1 =
                        $"=SUM({ws.Cell(2, col + 1).Address}:{ws.Cell(totalRow - 1, col + 1).Address})"
                    ws.Cell(totalRow, col + 1).Style.Font.Bold = True
                End If
            Next

            Response.Clear()
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            Response.AddHeader("content-disposition", "attachment;filename=DoctorReport.xlsx")
            Using ms As New MemoryStream()
                wb.SaveAs(ms)
                ms.WriteTo(Response.OutputStream)
                Response.Flush()
                Response.End()
            End Using
        End Using
    End Sub

    Protected Sub btnExportPDF_Click(sender As Object, e As EventArgs) Handles btnExportPDF.Click
        Dim dt As DataTable = GetReportData()
        If dt.Rows.Count = 0 Then Exit Sub

        Dim html As New Text.StringBuilder()
        html.Append("<table border='1' cellpadding='5' cellspacing='0' style='border-collapse:collapse;width:100%;'>")
        html.Append("<thead><tr style='background-color:#f2f2f2;'>")
        For Each col As DataColumn In dt.Columns
            html.Append($"<th>{col.ColumnName}</th>")
        Next
        html.Append("</tr></thead><tbody>")

        For Each row As DataRow In dt.Rows
            html.Append("<tr>")
            For Each col As DataColumn In dt.Columns
                html.Append($"<td>{If(IsDBNull(row(col)), "", row(col).ToString())}</td>")
            Next
            html.Append("</tr>")
        Next

        ' المجاميع
        html.Append("<tr style='font-weight:bold;background-color:#d9edf7;'>")
        For Each col As DataColumn In dt.Columns
            If IsNumericColumn(col) Then
                Dim sum As Decimal = dt.AsEnumerable().Sum(Function(r) If(IsDBNull(r(col)), 0D, Convert.ToDecimal(r(col))))
                html.Append($"<td>{sum}</td>")
            Else
                html.Append("<td>المجموع</td>")
            End If
        Next
        html.Append("</tr></tbody></table>")

        Dim pdf As New HtmlToPdf()
        Dim doc As PdfDocument = pdf.ConvertHtmlString(html.ToString())
        Response.Clear()
        Response.ContentType = "application/pdf"
        Response.AddHeader("content-disposition", "attachment;filename=DoctorReport.pdf")
        doc.Save(Response.OutputStream)
        doc.Close()
        Response.End()
    End Sub

    Private Function IsNumericColumn(col As DataColumn) As Boolean
        Return (col.DataType Is GetType(Integer) OrElse
                col.DataType Is GetType(Decimal) OrElse
                col.DataType Is GetType(Double) OrElse
                col.DataType Is GetType(Single))
    End Function

    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)

    End Sub

    Protected Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
        Dim script As String = "<script type='text/javascript'>window.print();</script>"
        ClientScript.RegisterStartupScript(Me.GetType(), "PrintGrid", script)
    End Sub
End Class