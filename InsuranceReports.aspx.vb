Imports System.Data
Imports System.IO
Imports ClosedXML.Excel
Imports SelectPdf
Imports System.Data.SqlClient
Imports System.Web.UI
Imports System.Web.UI.WebControls
Public Class InsuranceReports
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim firstDay As Date = New Date(Now.Year, Now.Month, 1)
            Dim lastDay As Date = firstDay.AddMonths(1).AddDays(-1)

            txtFromDate.Text = firstDay.ToString("yyyy-MM-dd")
            txtToDate.Text = lastDay.ToString("yyyy-MM-dd")
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Protected Sub btnGenerate_Click(sender As Object, e As EventArgs) Handles btnGenerate.Click
        Dim clinicID As Integer

        If Session("ClinicID") Is Nothing Then
            Return
        End If
        clinicID = Convert.ToInt32(Session("ClinicID"))

        Dim reportType As Integer = Convert.ToInt32(ddlReport.SelectedValue)
        Dim fromDate As Date = Date.Parse(txtFromDate.Text)
        Dim toDate As Date = Date.Parse(txtToDate.Text)

        Dim dt As New DataTable()

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand()
                cmd.Connection = conn
                cmd.CommandType = CommandType.Text

                Select Case reportType
                    Case 1
                        ' تفاصيل المرضى وحالة الاشتراك فقط للمرضى لديهم تأمين
                        cmd.CommandText = "
                        SELECT p.PatientID, p.FullName, p.Phone, ic.CardNumber, ic.ExpiryDate, ic.CoveragePercentage, ic.InsuranceLevel
                        FROM Patients p
                        INNER JOIN InsuranceCards ic ON p.PatientID = ic.PatientID AND ic.ClinicID = @ClinicID
                        WHERE p.ClinicID = @ClinicID
                    "
                    Case 2
                        ' الزيارات الطبية والتقارير مع مبالغ التأمين والمريض (للمرضى المؤمن عليهم فقط)
                        cmd.CommandText = "
                        SELECT v.VisitID, p.FullName AS PatientName, d.Name AS DoctorName, v.VisitDate, v.MedicalReport AS Report,
                               v.PatientAmount, v.InsuranceAmount
                        FROM Visits v
                        INNER JOIN Patients p ON v.PatientID = p.PatientID
                        INNER JOIN Doctors d ON v.DoctorID = d.DoctorID
                        WHERE v.ClinicID = @ClinicID AND v.InsuranceCompanyID IS NOT NULL 
                              AND v.VisitDate BETWEEN @FromDate AND @ToDate
                    "
                    Case 3
                        ' مبالغ التأمين والمريض لكل زيارة فقط للمرضى المؤمن عليهم
                        cmd.CommandText = "
                        SELECT v.VisitID, p.FullName AS PatientName, v.PatientAmount, v.InsuranceAmount
                        FROM Visits v
                        INNER JOIN Patients p ON v.PatientID = p.PatientID
                        WHERE v.ClinicID = @ClinicID AND v.InsuranceCompanyID IS NOT NULL
                              AND v.VisitDate BETWEEN @FromDate AND @ToDate
                    "
                    Case 4
                        ' ملخص الزيارات لكل طبيب للمرضى المؤمن عليهم فقط
                        cmd.CommandText = "
                        SELECT d.Name AS DoctorName, COUNT(v.VisitID) AS TotalVisits,
                               SUM(v.PatientAmount) AS TotalPatientAmount, SUM(v.InsuranceAmount) AS TotalInsuranceAmount
                        FROM Visits v
                        INNER JOIN Doctors d ON v.DoctorID = d.DoctorID
                        WHERE v.ClinicID = @ClinicID AND v.InsuranceCompanyID IS NOT NULL
                              AND v.VisitDate BETWEEN @FromDate AND @ToDate
                        GROUP BY d.Name
                    "
                    Case 5
                        ' المرضى بتأمين منتهي أو على وشك الانتهاء
                        cmd.CommandText = "
                        SELECT p.FullName, ic.CardNumber, ic.ExpiryDate
                        FROM InsuranceCards ic
                        INNER JOIN Patients p ON ic.PatientID = p.PatientID
                        WHERE ic.ClinicID = @ClinicID AND ic.ExpiryDate <= DATEADD(day,30,GETDATE())
                    "
                    Case 6
                        ' مبالغ مستحقة للمرضى حسب التأمين فقط
                        cmd.CommandText = "
                        SELECT p.FullName AS PatientName,
                               SUM(v.PatientAmount) AS PatientTotal,
                               SUM(v.InsuranceAmount) AS InsuranceTotal
                        FROM Visits v
                        INNER JOIN Patients p ON v.PatientID = p.PatientID
                        WHERE v.ClinicID = @ClinicID AND v.InsuranceCompanyID IS NOT NULL
                              AND v.VisitDate BETWEEN @FromDate AND @ToDate
                        GROUP BY p.FullName
                    "
                    Case 7
                        ' مجموع مبالغ التأمين والمريض حسب شركة التأمين فقط
                        cmd.CommandText = "
                        SELECT ic.CompanyName,
                               SUM(v.PatientAmount) AS PatientTotal,
                               SUM(v.InsuranceAmount) AS InsuranceTotal
                        FROM Visits v
                        INNER JOIN InsuranceCompanies ic ON v.InsuranceCompanyID = ic.InsuranceID
                        WHERE v.ClinicID = @ClinicID AND v.InsuranceCompanyID IS NOT NULL
                              AND v.VisitDate BETWEEN @FromDate AND @ToDate
                        GROUP BY ic.CompanyName
                    "
                    Case 8
                        ' عدد الزيارات الشهرية لكل شركة تأمين خلال آخر 6 أشهر فقط للمرضى المؤمن عليهم
                        cmd.CommandText = "
                        SELECT ic.CompanyName,
                               FORMAT(v.VisitDate,'yyyy-MM') AS VisitMonth,
                               COUNT(v.VisitID) AS TotalVisits
                        FROM Visits v
                        INNER JOIN InsuranceCompanies ic ON v.InsuranceCompanyID = ic.InsuranceID
                        WHERE v.ClinicID = @ClinicID AND v.InsuranceCompanyID IS NOT NULL
                              AND v.VisitDate BETWEEN DATEADD(month,-6,GETDATE()) AND GETDATE()
                        GROUP BY ic.CompanyName, FORMAT(v.VisitDate,'yyyy-MM')
                        ORDER BY VisitMonth
                    "
                End Select

                ' إضافة البراميترز
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                cmd.Parameters.AddWithValue("@FromDate", fromDate)
                cmd.Parameters.AddWithValue("@ToDate", toDate)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)
            End Using
        End Using


        Session("InsuranceReportData") = dt

        gvReport.DataSource = dt
        gvReport.DataBind()

        reportSummary.InnerText = "عدد السجلات: " & dt.Rows.Count
    End Sub
    Protected Sub btnExportExcel_Click(sender As Object, e As EventArgs) Handles btnExportExcel.Click
        Dim dt As DataTable = TryCast(Session("InsuranceReportData"), DataTable)
        If dt Is Nothing OrElse dt.Rows.Count = 0 Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('لا توجد بيانات للتصدير');", True)
            Return
        End If

        Using wb As New ClosedXML.Excel.XLWorkbook()
            Dim ws = wb.Worksheets.Add("InsuranceReport")

            ' نسخ عناوين الأعمدة
            For colIndex As Integer = 0 To dt.Columns.Count - 1
                ws.Cell(1, colIndex + 1).Value = dt.Columns(colIndex).ColumnName
            Next

            ' نسخ البيانات مع التحقق من النوع والقيم الفارغة
            For rowIndex As Integer = 0 To dt.Rows.Count - 1
                For colIndex As Integer = 0 To dt.Columns.Count - 1
                    Dim val = dt.Rows(rowIndex)(colIndex)
                    If IsDBNull(val) Then
                        ws.Cell(rowIndex + 2, colIndex + 1).Value = ""
                    Else
                        ' تحويل كل نوع بشكل آمن
                        Select Case dt.Columns(colIndex).DataType.Name
                            Case "String"
                                ws.Cell(rowIndex + 2, colIndex + 1).Value = val.ToString()
                            Case "Decimal", "Double", "Single"
                                ws.Cell(rowIndex + 2, colIndex + 1).Value = Convert.ToDecimal(val)
                            Case "Int32", "Int64", "Int16"
                                ws.Cell(rowIndex + 2, colIndex + 1).Value = Convert.ToInt64(val)
                            Case "DateTime"
                                ws.Cell(rowIndex + 2, colIndex + 1).Value = Convert.ToDateTime(val)
                            Case Else
                                ws.Cell(rowIndex + 2, colIndex + 1).Value = val.ToString()
                        End Select
                    End If
                Next
            Next

            Response.Clear()
            Response.Buffer = True
            Response.Charset = ""
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            Response.AddHeader("content-disposition", "attachment;filename=InsuranceReport.xlsx")

            Using ms As New System.IO.MemoryStream()
                wb.SaveAs(ms)
                ms.WriteTo(Response.OutputStream)
                Response.Flush()
                Response.End()
            End Using
        End Using
    End Sub

    ' ===================== تصدير PDF =====================
    Protected Sub btnExportPdf_Click(sender As Object, e As EventArgs) Handles btnExportPdf.Click
        If gvReport.Rows.Count = 0 Then Return

        ' تحويل GridView إلى HTML
        Dim sw As New StringWriter()
        Dim hw As New HtmlTextWriter(sw)
        gvReport.RenderControl(hw)
        Dim gridHtml As String = sw.ToString()

        ' إعداد PDF باستخدام SelectPdf
        Dim converter As New HtmlToPdf()
        Dim doc As PdfDocument = converter.ConvertHtmlString(gridHtml)

        Response.Clear()
        Response.ContentType = "application/pdf"
        Response.AddHeader("content-disposition", "attachment;filename=InsuranceReport.pdf")
        doc.Save(Response.OutputStream)
        doc.Close()
        Response.End()
    End Sub

    ' مهم للسماح بتصدير GridView إلى HTML
    Public Overrides Sub VerifyRenderingInServerForm(control As Control)
        ' هذا ضروري لتصدير GridView
    End Sub

End Class
