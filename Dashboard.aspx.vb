Imports System.Data.SqlClient
Imports System.Web.Script.Serialization

    Partial Class Dashboard
        Inherits System.Web.UI.Page

        Dim connString As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtFromDate.Text = New DateTime(Now.Year, Now.Month, 1).ToString("yyyy-MM-dd")
            txtToDate.Text = Now.ToString("yyyy-MM-dd")
            LoadDashboard()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

        Protected Sub btnFilter_Click(sender As Object, e As EventArgs)
            LoadDashboard()
        End Sub

        Private Sub LoadDashboard()
        Dim fromDate As DateTime = DateTime.Parse(txtFromDate.Text).Date ' 00:00:00
        Dim toDate As DateTime = DateTime.Parse(txtToDate.Text).Date.AddDays(1).AddSeconds(-1) ' 23:59:59
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

            Using conn As New SqlConnection(connString)
                conn.Open()

                ' ====== الإحصائيات الرئيسية ======
                lblDailyVisits.Text = ExecuteScalarQuery(conn, "SELECT COUNT(*) FROM Visits WHERE VisitDate BETWEEN @from AND @to AND ClinicID = @clinicID", fromDate, toDate, clinicID)
                lblNewPatients.Text = ExecuteScalarQuery(conn, "SELECT COUNT(*) FROM Patients WHERE CreatedAt BETWEEN @from AND @to AND ClinicID = @clinicID", fromDate, toDate, clinicID)
                lblRevenue.Text = FormatCurrency(ExecuteScalarQueryDecimal(conn, "SELECT ISNULL(SUM(Amount),0) FROM Payments WHERE PayDate BETWEEN @from AND @to AND ClinicID = @clinicID", fromDate, toDate, clinicID))

            ' معدل النمو
            Dim cmdTotalPatients As New SqlCommand("SELECT COUNT(*) FROM Patients WHERE ClinicID = @clinicID", conn)
            cmdTotalPatients.Parameters.AddWithValue("@clinicID", clinicID)
            Dim totalPatients As Integer = CInt(cmdTotalPatients.ExecuteScalar())

            Dim newPatients As Integer = CInt(lblNewPatients.Text)
                lblGrowthRate.Text = If(totalPatients > 0, (newPatients / totalPatients) * 100, 0).ToString("F2") & " %"

                ' ====== البيانات للمخططات ======
                Dim js As New JavaScriptSerializer()

                ' الإيرادات حسب الطبيب
                Dim doctorNames As New List(Of String)()
                Dim doctorRevenue As New List(Of Decimal)()
                Using cmd As New SqlCommand("SELECT d.Name, ISNULL(SUM(p.Amount),0) as Revenue
                                          FROM Payments p
                                          INNER JOIN Visits v ON p.VisitID = v.VisitID
                                          INNER JOIN Doctors d ON v.DoctorID = d.DoctorID
                                          WHERE p.PayDate BETWEEN @from AND @to AND p.ClinicID = @clinicID
                                          GROUP BY d.Name", conn)
                    cmd.Parameters.AddWithValue("@from", fromDate)
                    cmd.Parameters.AddWithValue("@to", toDate)
                    cmd.Parameters.AddWithValue("@clinicID", clinicID)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            doctorNames.Add(reader("Name").ToString())
                            doctorRevenue.Add(Convert.ToDecimal(reader("Revenue")))
                        End While
                    End Using
                End Using
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "RevenueByDoctorChart", $"updateRevenueByDoctorChart({js.Serialize(doctorNames)},{js.Serialize(doctorRevenue)});", True)

                ' عدد الحالات اليومية
                Dim visitDates As New List(Of String)()
                Dim visitCounts As New List(Of Integer)()
                Using cmd As New SqlCommand("SELECT CONVERT(varchar, VisitDate, 23) as VDate, COUNT(*) as CountVisits
                                          FROM Visits
                                          WHERE VisitDate BETWEEN @from AND @to AND ClinicID = @clinicID
                                          GROUP BY CONVERT(varchar, VisitDate, 23)
                                          ORDER BY VDate", conn)
                    cmd.Parameters.AddWithValue("@from", fromDate)
                    cmd.Parameters.AddWithValue("@to", toDate)
                    cmd.Parameters.AddWithValue("@clinicID", clinicID)
                    Using reader = cmd.ExecuteReader()
                        While reader.Read()
                            visitDates.Add(reader("VDate").ToString())
                            visitCounts.Add(Convert.ToInt32(reader("CountVisits")))
                        End While
                    End Using
                End Using
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "DailyVisitsChart", $"updateDailyVisitsChart({js.Serialize(visitDates)},{js.Serialize(visitCounts)});", True)

            '        ' الإجراءات الطبية الأكثر شيوعاً
            ' ===================== الإجراءات الطبية الأكثر شيوعاً =====================
            Dim treatmentNames As New List(Of String)()
            Dim treatmentCounts As New List(Of Integer)()

            ' 1. نجلب كل الزيارات للفترة المطلوبة والعيادة الحالية
            Dim allReports As New List(Of String)()
            Using cmd As New SqlCommand("
    SELECT MedicalReport 
    FROM Visits
    WHERE VisitDate BETWEEN @from AND @to
      AND ClinicID = @clinicID", conn)
                cmd.Parameters.AddWithValue("@from", fromDate)
                cmd.Parameters.AddWithValue("@to", toDate)
                cmd.Parameters.AddWithValue("@clinicID", clinicID)

                Using reader = cmd.ExecuteReader()
                    While reader.Read()
                        If Not IsDBNull(reader("MedicalReport")) Then
                            allReports.Add(reader("MedicalReport").ToString())
                        End If
                    End While
                End Using
            End Using

            ' 2. نجيب كل الإجراءات الرسمية للعيادة الحالية
            Dim allTreatments As New List(Of String)()
            Using cmd As New SqlCommand("
    SELECT TreatmentName
    FROM Treatments
    WHERE ClinicID = @clinicID", conn)
                cmd.Parameters.AddWithValue("@clinicID", clinicID)

                Using reader = cmd.ExecuteReader()
                    While reader.Read()
                        allTreatments.Add(reader("TreatmentName").ToString())
                    End While
                End Using
            End Using

            ' 3. نحسب عدد مرات كل إجراء
            For Each treatment In allTreatments
                Dim count As Integer = 0
                For Each report In allReports
                    Dim lines = report.Split({vbCrLf, vbLf}, StringSplitOptions.RemoveEmptyEntries)
                    For Each line In lines
                        If line.Contains(treatment) Then
                            count += 1
                        End If
                    Next
                Next
                If count > 0 Then
                    treatmentNames.Add(treatment)
                    treatmentCounts.Add(count)
                End If
            Next

            Page.ClientScript.RegisterStartupScript(Me.GetType(), "TreatmentsChart",
    $"updateTreatmentsChart({js.Serialize(treatmentNames)},{js.Serialize(treatmentCounts)});", True)

            Dim totalVisits As Integer = ExecuteScalarQuery(conn, "SELECT COUNT(*) FROM Visits WHERE VisitDate BETWEEN @from AND @to AND ClinicID = @clinicID", fromDate, toDate, clinicID)
                Dim totalAppointments As Integer = ExecuteScalarQuery(conn, "SELECT COUNT(*) FROM Appointments WHERE DateOfApp BETWEEN @from AND @to AND ClinicID = @clinicID", fromDate, toDate, clinicID)
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "AppointmentsChart", $"updateAppointmentsChart({totalVisits},{totalAppointments});", True)

            End Using
        End Sub
    Private Function ExecuteScalarQuery(conn As SqlConnection, query As String, fromDate As DateTime, toDate As DateTime, clinicID As Integer) As Integer
        Using cmd As New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@from", fromDate)
            cmd.Parameters.AddWithValue("@to", toDate)
            cmd.Parameters.AddWithValue("@clinicID", clinicID)
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                Return Convert.ToInt32(result)
            Else
                Return 0
            End If
        End Using
    End Function

    Private Function ExecuteScalarQueryDecimal(conn As SqlConnection, query As String, fromDate As DateTime, toDate As DateTime, clinicID As Integer) As Decimal
        Using cmd As New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@from", fromDate)
            cmd.Parameters.AddWithValue("@to", toDate)
            cmd.Parameters.AddWithValue("@clinicID", clinicID)
            Dim result = cmd.ExecuteScalar()
            If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                Return Convert.ToDecimal(result)
            Else
                Return 0
            End If
        End Using
    End Function


    'Private Sub LoadDashboard()
    '    Dim fromDate As DateTime = DateTime.Parse(txtFromDate.Text)
    '    Dim toDate As DateTime = DateTime.Parse(txtToDate.Text)

    '    Using conn As New SqlConnection(connString)
    '        conn.Open()

    '        ' ====== الإحصائيات الرئيسية ======
    '        lblDailyVisits.Text = ExecuteScalarQuery(conn, "SELECT COUNT(*) FROM Visits WHERE VisitDate BETWEEN @from AND @to", fromDate, toDate)
    '        lblNewPatients.Text = ExecuteScalarQuery(conn, "SELECT COUNT(*) FROM Patients WHERE CreatedAt BETWEEN @from AND @to", fromDate, toDate)
    '        lblRevenue.Text = FormatCurrency(ExecuteScalarQueryDecimal(conn, "SELECT ISNULL(SUM(Amount),0) FROM Payments WHERE PayDate BETWEEN @from AND @to", fromDate, toDate))

    '        ' معدل النمو
    '        Dim totalPatients As Integer = CInt(New SqlCommand("SELECT COUNT(*) FROM Patients", conn).ExecuteScalar())
    '        Dim newPatients As Integer = CInt(lblNewPatients.Text)
    '        lblGrowthRate.Text = If(totalPatients > 0, (newPatients / totalPatients) * 100, 0).ToString("F2") & " %"

    '        ' ====== البيانات للمخططات ======
    '        Dim js As New JavaScriptSerializer()

    '        ' الإيرادات حسب الطبيب
    '        Dim doctorNames As New List(Of String)()
    '        Dim doctorRevenue As New List(Of Decimal)()
    '        Using cmd As New SqlCommand("SELECT d.Name, ISNULL(SUM(p.Amount),0) as Revenue
    '                                      FROM Payments p
    '                                      INNER JOIN Visits v ON p.VisitID = v.VisitID
    '                                      INNER JOIN Doctors d ON v.DoctorID = d.DoctorID
    '                                      WHERE p.PayDate BETWEEN @from AND @to
    '                                      GROUP BY d.Name", conn)
    '            cmd.Parameters.AddWithValue("@from", fromDate)
    '            cmd.Parameters.AddWithValue("@to", toDate)
    '            Using reader = cmd.ExecuteReader()
    '                While reader.Read()
    '                    doctorNames.Add(reader("Name").ToString())
    '                    doctorRevenue.Add(Convert.ToDecimal(reader("Revenue")))
    '                End While
    '            End Using
    '        End Using
    '        Page.ClientScript.RegisterStartupScript(Me.GetType(), "RevenueByDoctorChart", $"updateRevenueByDoctorChart({js.Serialize(doctorNames)},{js.Serialize(doctorRevenue)});", True)

    '        ' عدد الحالات اليومية
    '        Dim visitDates As New List(Of String)()
    '        Dim visitCounts As New List(Of Integer)()
    '        Using cmd As New SqlCommand("SELECT CONVERT(varchar, VisitDate, 23) as VDate, COUNT(*) as CountVisits
    '                                      FROM Visits
    '                                      WHERE VisitDate BETWEEN @from AND @to
    '                                      GROUP BY CONVERT(varchar, VisitDate, 23)
    '                                      ORDER BY VDate", conn)
    '            cmd.Parameters.AddWithValue("@from", fromDate)
    '            cmd.Parameters.AddWithValue("@to", toDate)
    '            Using reader = cmd.ExecuteReader()
    '                While reader.Read()
    '                    visitDates.Add(reader("VDate").ToString())
    '                    visitCounts.Add(Convert.ToInt32(reader("CountVisits")))
    '                End While
    '            End Using
    '        End Using
    '        Page.ClientScript.RegisterStartupScript(Me.GetType(), "DailyVisitsChart", $"updateDailyVisitsChart({js.Serialize(visitDates)},{js.Serialize(visitCounts)});", True)

    '        ' الإجراءات الطبية الأكثر شيوعاً
    '        'Dim treatmentNames As New List(Of String)()
    '        'Dim treatmentCounts As New List(Of Integer)()
    '        'Using cmd As New SqlCommand("SELECT t.Name, COUNT(*) as CountTreatments
    '        '                              FROM Treatments t
    '        '                              INNER JOIN VisitDetails vd ON t.TreatmentID = vd.TreatmentID
    '        '                              INNER JOIN Visits v ON vd.VisitID = v.VisitID
    '        '                              WHERE v.VisitDate BETWEEN @from AND @to
    '        '                              GROUP BY t.Name
    '        '                              ORDER BY CountTreatments DESC", conn)
    '        '    cmd.Parameters.AddWithValue("@from", fromDate)
    '        '    cmd.Parameters.AddWithValue("@to", toDate)
    '        '    Using reader = cmd.ExecuteReader()
    '        '        While reader.Read()
    '        '            treatmentNames.Add(reader("Name").ToString())
    '        '            treatmentCounts.Add(Convert.ToInt32(reader("CountTreatments")))
    '        '        End While
    '        '    End Using
    '        'End Using
    '        'Page.ClientScript.RegisterStartupScript(Me.GetType(), "TreatmentsChart", $"updateTreatmentsChart({js.Serialize(treatmentNames)},{js.Serialize(treatmentCounts)});", True)

    '        ' إجمالي الزيارات والمواعيد
    '        Dim totalVisits As Integer = ExecuteScalarQuery(conn, "SELECT COUNT(*) FROM Visits WHERE VisitDate BETWEEN @from AND @to", fromDate, toDate)
    '        Dim totalAppointments As Integer = ExecuteScalarQuery(conn, "SELECT COUNT(*) FROM Appointments WHERE DateOfApp BETWEEN @from AND @to", fromDate, toDate)
    '        Page.ClientScript.RegisterStartupScript(Me.GetType(), "AppointmentsChart", $"updateAppointmentsChart({totalVisits},{totalAppointments});", True)

    '    End Using
    'End Sub

    '    Private Function ExecuteScalarQuery(conn As SqlConnection, query As String, fromDate As DateTime, toDate As DateTime) As Integer
    '    Using cmd As New SqlCommand(query, conn)
    '        cmd.Parameters.AddWithValue("@from", fromDate)
    '        cmd.Parameters.AddWithValue("@to", toDate)
    '        Dim result = cmd.ExecuteScalar()
    '        If result IsNot Nothing AndAlso Not IsDBNull(result) Then
    '            Return Convert.ToInt32(result)
    '        Else
    '            Return 0
    '        End If
    '    End Using
    'End Function

    'Private Function ExecuteScalarQueryDecimal(conn As SqlConnection, query As String, fromDate As DateTime, toDate As DateTime) As Decimal
    '    Using cmd As New SqlCommand(query, conn)
    '        cmd.Parameters.AddWithValue("@from", fromDate)
    '        cmd.Parameters.AddWithValue("@to", toDate)
    '        Dim result = cmd.ExecuteScalar()
    '        If result IsNot Nothing AndAlso Not IsDBNull(result) Then
    '            Return Convert.ToDecimal(result)
    '        Else
    '            Return 0
    '        End If
    '    End Using
    'End Function

End Class
