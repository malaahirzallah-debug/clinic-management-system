Imports System.Web.Services
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.Script.Services

Public Class DashboardAppointments
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then LoadDoctors()
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub



    Private Sub LoadDoctors()
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT DoctorID, Name FROM dbo.Doctors WHERE Active=1 AND ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@ClinicID", Session("ClinicID"))
                conn.Open()
                Dim dr As SqlDataReader = cmd.ExecuteReader()

                ' املى الدروب داون الأول
                ddlDoctors.DataSource = dr
                ddlDoctors.DataTextField = "Name"
                ddlDoctors.DataValueField = "DoctorID"
                ddlDoctors.DataBind()

                ' إعادة قراءة البيانات للدروب الثاني
                dr.Close()
                cmd.Connection = conn
                Dim dt As New DataTable
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using

                doctorSelect.DataSource = dt
                doctorSelect.DataTextField = "Name"
                doctorSelect.DataValueField = "DoctorID"
                doctorSelect.DataBind()
            End Using
        End Using

        ' اختيار أول طبيب تلقائيًا
        If ddlDoctors.Items.Count > 0 Then
            ddlDoctors.SelectedIndex = 0
            doctorSelect.SelectedValue = ddlDoctors.SelectedValue
        End If
    End Sub


    <WebMethod()> <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GetPatients(clinicId As Integer) As List(Of Object)
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Dim list As New List(Of Object)
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT PatientID, FullName FROM Patients WHERE ClinicID=@ClinicID ORDER BY FullName", conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                conn.Open()
                Using rdr = cmd.ExecuteReader()
                    While rdr.Read()
                        list.Add(New With {Key .PatientID = rdr("PatientID"), Key .FullName = rdr("FullName")})
                    End While
                End Using
            End Using
        End Using
        Return list
    End Function

    '<WebMethod()> <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    'Public Shared Function AddAppointment(doctorId As Integer, patientId As Integer, appointmentDate As String, startTime As Integer, durationInMin As Integer, color As String, tools As String()) As Integer
    '    Try
    '        Dim connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    '        Dim noteText As String = String.Join(", ", tools)
    '        Dim appDate As Date = Date.Parse(appointmentDate)
    '        Dim ts As TimeSpan = TimeSpan.FromMinutes(startTime)
    '        Dim newId As Integer = 0

    '        Using conn As New SqlConnection(connStr)
    '            Using cmd As New SqlCommand("
    '    INSERT INTO Appointments 
    '        (ClinicID, DoctorID, PatientID, DateOfApp, StartTime, DurationInMin, BookingColor, Note, IsConfirmed, BookingType, IsCancelled) 
    '    OUTPUT INSERTED.AppointmentID
    '    VALUES 
    '        (@ClinicID, @DoctorID, @PatientID, @DateOfApp, @StartTime, @DurationInMin, @BookingColor, @Note, 0, 'Normal', 0)", conn)

    '                cmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
    '                cmd.Parameters.AddWithValue("@DoctorID", doctorId)
    '                cmd.Parameters.AddWithValue("@PatientID", patientId)
    '                cmd.Parameters.AddWithValue("@DateOfApp", appDate)
    '                cmd.Parameters.AddWithValue("@StartTime", ts)  ' <-- تأكد من تحويل TimeSpan لـ SQL بشكل صحيح
    '                cmd.Parameters.AddWithValue("@DurationInMin", durationInMin)
    '                cmd.Parameters.AddWithValue("@BookingColor", color)
    '                cmd.Parameters.AddWithValue("@Note", noteText)

    '                conn.Open()
    '                Dim result = cmd.ExecuteScalar()
    '                If result IsNot Nothing Then
    '                    newId = Convert.ToInt32(result)
    '                Else
    '                    newId = -1
    '                End If
    '            End Using
    '        End Using


    '        Return newId
    '    Catch ex As Exception
    '        Return -1
    '    End Try
    'End Function


    <WebMethod()> Public Shared Function MoveAppointment(appointmentId As Integer, newDate As String, newStartTime As String) As Boolean
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("UPDATE Appointments 
                                         SET DateOfApp=@Date, StartTime=@Time 
                                         WHERE AppointmentID=@ID AND ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@Date", newDate)
                cmd.Parameters.AddWithValue("@Time", newStartTime)
                cmd.Parameters.AddWithValue("@ID", appointmentId)
                cmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Return True
    End Function

    <WebMethod()> Public Shared Function CopyAppointment(appointmentId As Integer, newDate As String, newStartTime As String) As Boolean
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("
                INSERT INTO Appointments (ClinicID, DoctorID, PatientID, DateOfApp, StartTime, DurationInMin, Note, IsConfirmed, BookingColor, BookingType)
                SELECT @ClinicID, DoctorID, PatientID, @Date, @Time, DurationInMin, Note, IsConfirmed, BookingColor, BookingType
                FROM Appointments 
                WHERE AppointmentID=@ID AND ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@Date", newDate)
                cmd.Parameters.AddWithValue("@Time", newStartTime)
                cmd.Parameters.AddWithValue("@ID", appointmentId)
                cmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Return True
    End Function

    <WebMethod()> Public Shared Function DeleteAppointment(appointmentId As Integer) As Boolean
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("UPDATE Appointments SET IsCancelled = 1 WHERE AppointmentID=@ID AND ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@ID", appointmentId)
                cmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Return True
    End Function

    <WebMethod()>
    Public Shared Function SaveAppointment(doctorId As Integer,
                                           patientName As String,
                                           appointmentDate As String,
                                           appointmentTime As String,
                                           duration As Integer,
                                           appointmentType As String,
                                           notes As String,
                                           color As String) As Boolean
        Try
            ' جلب رقم العيادة من السيشن
            Dim clinicId As Integer = Convert.ToInt32(HttpContext.Current.Session("ClinicID"))

            Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
            Using conn As New SqlConnection(connStr)
                conn.Open()

                ' الحصول على PatientID بناءً على الاسم + العيادة
                Dim patientId As Integer = 0
                Using cmdP As New SqlCommand("
                    SELECT TOP 1 PatientID 
                    FROM Patients 
                    WHERE FullName=@FullName AND ClinicID=@ClinicID", conn)

                    cmdP.Parameters.AddWithValue("@FullName", patientName)
                    cmdP.Parameters.AddWithValue("@ClinicID", clinicId)

                    Dim result = cmdP.ExecuteScalar()
                    If result IsNot Nothing Then
                        patientId = Convert.ToInt32(result)
                    End If
                End Using
                ' إدخال الموعد
                Using cmd As New SqlCommand("
                    INSERT INTO Appointments 
                    (ClinicID, DoctorID, PatientID, DateOfApp, StartTime, DurationInMin, BookingType, Note, BookingColor, IsConfirmed, IsCancelled) 
                    VALUES (@ClinicID, @DoctorID, @PatientID, @DateOfApp, @StartTime, @DurationInMin, @BookingType, @Note, @BookingColor, 0, 0)", conn)

                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@DoctorID", doctorId)
                    cmd.Parameters.AddWithValue("@PatientID", patientId)
                    cmd.Parameters.AddWithValue("@DateOfApp", appointmentDate)
                    cmd.Parameters.AddWithValue("@StartTime", appointmentTime)
                    cmd.Parameters.AddWithValue("@DurationInMin", duration)
                    cmd.Parameters.AddWithValue("@BookingType", appointmentType)
                    cmd.Parameters.AddWithValue("@Note", notes)
                    cmd.Parameters.AddWithValue("@BookingColor", color)

                    cmd.ExecuteNonQuery()

                End Using
            End Using
            Return True
        Catch ex As Exception
            ' ممكن تعمل لوج للخطأ هنا
            Return False
        End Try
    End Function

    <WebMethod()>
    Public Shared Function GetAppointmentDetails(appointmentId As Integer) As Object
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Dim result As New Dictionary(Of String, Object)

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' استعلام واحد مترابط يجلب كل البيانات ويجمع الأمراض والحساسيات
            Using cmd As New SqlCommand("
            SELECT 
                a.AppointmentID,
                a.DoctorID,
                a.PatientID,
                a.DateOfApp,
                a.StartTime,
                a.DurationInMin,
                a.Note,
                a.BookingType,
                a.IsConfirmed,
                p.FullName AS PatientName,
                p.Phone,
                p.AltPhone,
                p.Age,
                p.LastVisit,
                p.Balance,
                d.Name AS DoctorName,
                -- تجميع الأمراض المزمنة
                ISNULL(STUFF((SELECT ', ' + cd.DiseaseName
                              FROM PatientChronicDiseases pcd
                              LEFT JOIN ChronicDiseases cd ON pcd.DiseaseID = cd.DiseaseID
                              WHERE pcd.PatientID = a.PatientID
                              FOR XML PATH('')), 1, 2, ''), '') AS ChronicDiseases,
                -- تجميع الحساسيات
                ISNULL(STUFF((SELECT ', ' + al.AllergyName
                              FROM PatientAllergies pa
                              LEFT JOIN Allergies al ON pa.AllergyID = al.AllergyID
                              WHERE pa.PatientID = a.PatientID
                              FOR XML PATH('')), 1, 2, ''), '') AS Allergy
            FROM Appointments a
            LEFT JOIN Patients p ON a.PatientID = p.PatientID
            LEFT JOIN Doctors d ON a.DoctorID = d.DoctorID
            WHERE a.AppointmentID=@ID", conn)

                cmd.Parameters.AddWithValue("@ID", appointmentId)

                Using reader = cmd.ExecuteReader()
                    If reader.Read() Then
                        result("AppointmentID") = reader("AppointmentID")
                        result("DoctorName") = If(reader("DoctorName") IsNot DBNull.Value, reader("DoctorName"), "")
                        result("PatientName") = If(reader("PatientName") IsNot DBNull.Value, reader("PatientName"), "")
                        result("PatientID") = reader("PatientID")
                        ' تحويل التاريخ لصيغة YYYY-MM-DD
                        If reader("DateOfApp") IsNot DBNull.Value Then
                            result("DateOfApp") = Convert.ToDateTime(reader("DateOfApp")).ToString("yyyy-MM-dd")
                        Else
                            result("DateOfApp") = ""
                        End If

                        ' تحويل الوقت لصيغة HH:mm
                        If reader("StartTime") IsNot DBNull.Value Then
                            result("StartTime") = TimeSpan.Parse(reader("StartTime").ToString()).ToString("hh\:mm")
                        Else
                            result("StartTime") = ""
                        End If
                        result("DurationInMin") = If(reader("DurationInMin") IsNot DBNull.Value, reader("DurationInMin"), 0)
                        result("Note") = If(reader("Note") IsNot DBNull.Value, reader("Note"), "")
                        result("BookingType") = If(reader("BookingType") IsNot DBNull.Value, reader("BookingType"), "")
                        result("Phone1") = If(reader("Phone") IsNot DBNull.Value, reader("Phone"), "")
                        result("Phone2") = If(reader("AltPhone") IsNot DBNull.Value, reader("AltPhone"), "")
                        result("Age") = If(reader("Age") IsNot DBNull.Value, reader("Age"), "")
                        If reader("LastVisit") IsNot DBNull.Value Then
                            result("LastVisitDate") = Convert.ToDateTime(reader("LastVisit")).ToString("yyyy-MM-dd")
                        Else
                            result("LastVisitDate") = ""
                        End If
                        result("Balance") = If(reader("Balance") IsNot DBNull.Value, reader("Balance"), 0)
                        result("ChronicDiseases") = If(reader("ChronicDiseases") IsNot DBNull.Value, reader("ChronicDiseases"), "")
                        result("Allergy") = If(reader("Allergy") IsNot DBNull.Value, reader("Allergy"), "")
                        result("IsConfirmed") = If(reader("IsConfirmed") IsNot DBNull.Value, Convert.ToBoolean(reader("IsConfirmed")), False)
                    End If
                End Using
            End Using
        End Using

        Return result
    End Function

    <WebMethod()> Public Shared Function GetAppointments(doctorId As Integer, fromDate As String, toDate As String) As List(Of DaySchedule)
        Dim result As New List(Of DaySchedule)
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' جدول دوام الطبيب
            Dim scheduleCmd As New SqlCommand("
                SELECT ScheduleDate, StartTime, EndTime
                FROM dbo.DoctorSchedule
                WHERE DoctorID=@DoctorID 
                AND ClinicID=@ClinicID
                AND ScheduleDate BETWEEN @FromDate AND @ToDate
                AND IsWorking=1
                ORDER BY ScheduleDate", conn)
            scheduleCmd.Parameters.AddWithValue("@DoctorID", doctorId)
            scheduleCmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
            scheduleCmd.Parameters.AddWithValue("@FromDate", fromDate)
            scheduleCmd.Parameters.AddWithValue("@ToDate", toDate)

            Dim reader = scheduleCmd.ExecuteReader()
            Dim days As New List(Of DaySchedule)
            While reader.Read()
                days.Add(New DaySchedule With {
                    .ScheduleDate = Convert.ToDateTime(reader("ScheduleDate")).ToString("yyyy-MM-dd"),
                    .StartHour = CType(reader("StartTime"), TimeSpan).Hours,
                    .EndHour = CType(reader("EndTime"), TimeSpan).Hours - 1
                })
            End While
            reader.Close()

            ' جدول المواعيد
            Dim appointCmd As New SqlCommand("
                SELECT AppointmentID, DateOfApp, StartTime, DurationInMin, BookingColor, P.FullName AS PatientName
                FROM dbo.Appointments A 
                INNER JOIN dbo.Patients P ON A.PatientID=P.PatientID
                WHERE A.DoctorID=@DoctorID 
                AND A.ClinicID=@ClinicID
                AND DateOfApp BETWEEN @FromDate AND @ToDate
                AND A.IsCancelled=0", conn)
            appointCmd.Parameters.AddWithValue("@DoctorID", doctorId)
            appointCmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
            appointCmd.Parameters.AddWithValue("@FromDate", fromDate)
            appointCmd.Parameters.AddWithValue("@ToDate", toDate)

            Dim appointReader = appointCmd.ExecuteReader()
            Dim appointments As New List(Of AppointmentInfo)
            While appointReader.Read()
                appointments.Add(New AppointmentInfo With {
                    .AppointmentID = Convert.ToInt32(appointReader("AppointmentID")),
                    .DateOfApp = Convert.ToDateTime(appointReader("DateOfApp")).ToString("yyyy-MM-dd"),
                    .StartTime = appointReader("StartTime").ToString(),
                    .DurationInMin = Convert.ToInt32(appointReader("DurationInMin")),
                    .PatientName = appointReader("PatientName").ToString(),
                    .BookingColor = If(IsDBNull(appointReader("BookingColor")), "#ffb74d", appointReader("BookingColor").ToString())
                })
            End While
            appointReader.Close()

            ' دمج الأيام مع المواعيد
            For Each d In days
                d.Appointments = appointments.Where(Function(a) a.DateOfApp = d.ScheduleDate).ToList()
                result.Add(d)
            Next
        End Using

        Return result
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Sub ConfirmAppointment(appointmentId As Integer)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            conn.Open()
            Dim query As String = "UPDATE Appointments SET IsConfirmed = 1 WHERE AppointmentID = @AppointmentID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@AppointmentID", appointmentId)
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    <System.Web.Services.WebMethod()>
    Public Shared Function GetTreatments(clinicId As Integer) As List(Of Object)
        Dim treatments As New List(Of Object)()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT TreatmentID, TreatmentName, DurationMinutes 
                                   FROM Treatments 
                                   WHERE ClinicID = @ClinicID", conn)
            cmd.Parameters.AddWithValue("@ClinicID", clinicId)
            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            While reader.Read()
                treatments.Add(New With {
                .TreatmentID = reader("TreatmentID"),
                .TreatmentName = reader("TreatmentName").ToString(),
                .DurationMinutes = If(IsDBNull(reader("DurationMinutes")), 30, Convert.ToInt32(reader("DurationMinutes")))
            })
            End While
        End Using

        Return treatments
    End Function

    <WebMethod()> <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function SearchPatients(clinicId As Integer, query As String) As List(Of Object)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Dim list As New List(Of Object)
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT TOP 20 PatientID, FullName 
                                    FROM Patients 
                                    WHERE ClinicID=@ClinicID AND FullName LIKE @Query 
                                    ORDER BY FullName", conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                cmd.Parameters.AddWithValue("@Query", "%" & query & "%")
                conn.Open()
                Using rdr = cmd.ExecuteReader()
                    While rdr.Read()
                        list.Add(New With {Key .PatientID = rdr("PatientID"), Key .FullName = rdr("FullName")})
                    End While
                End Using
            End Using
        End Using
        Return list
    End Function

    <WebMethod()> Public Shared Function UpdateAppointmentDuration(appointmentId As Integer, newDuration As Integer) As Boolean
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("UPDATE Appointments SET DurationInMin=@Duration 
                                         WHERE AppointmentID=@ID AND ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@Duration", newDuration)
                cmd.Parameters.AddWithValue("@ID", appointmentId)
                cmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Return True
    End Function

    <System.Web.Services.WebMethod()>
    Public Shared Function UpdateAppointmentNotes(appointmentId As Integer, notes As String) As String
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString)
            conn.Open()
            Using cmd As New SqlCommand("UPDATE Appointments SET Note = @Note WHERE AppointmentID = @AppointmentID", conn)
                cmd.Parameters.AddWithValue("@Note", notes)
                cmd.Parameters.AddWithValue("@AppointmentID", appointmentId)
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Return "OK"
    End Function

    ' الكلاسات
    Public Class DaySchedule
        Public Property ScheduleDate As String
        Public Property StartHour As Integer
        Public Property EndHour As Integer
        Public Property Appointments As List(Of AppointmentInfo)
    End Class
    Public Class AppointmentInfo
        Public Property AppointmentID As Integer
        Public Property DateOfApp As String
        Public Property StartTime As String
        Public Property DurationInMin As Integer
        Public Property PatientName As String
        Public Property BookingColor As String
    End Class

End Class
