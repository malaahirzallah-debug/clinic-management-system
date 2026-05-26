Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Services

Public Class Appointments
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
            Using cmd As New SqlCommand("SELECT DoctorID, Name FROM dbo.Doctors WHERE Active=1", conn)
                conn.Open()
                ddlDoctors.DataSource = cmd.ExecuteReader()
                ddlDoctors.DataTextField = "Name"
                ddlDoctors.DataValueField = "DoctorID"
                ddlDoctors.DataBind()
            End Using
        End Using
        If ddlDoctors.Items.Count > 0 Then
            ddlDoctors.SelectedIndex = 0
        End If
    End Sub

    ' ==========================================
    ' WebMethods للتعامل مع المواعيد
    ' ==========================================

    <WebMethod()>
    Public Shared Function GetAppointments(doctorId As Integer, fromDate As String, toDate As String) As List(Of DaySchedule)
        Dim result As New List(Of DaySchedule)
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' جلب أيام الدوام مع StartTime و EndTime لكل يوم
            Dim scheduleCmd As New SqlCommand("
                SELECT ScheduleDate, StartTime, EndTime
                FROM dbo.DoctorSchedule
                WHERE DoctorID=@DoctorID AND ScheduleDate BETWEEN @FromDate AND @ToDate
                AND IsWorking=1
                ORDER BY ScheduleDate
            ", conn)
            scheduleCmd.Parameters.AddWithValue("@DoctorID", doctorId)
            scheduleCmd.Parameters.AddWithValue("@FromDate", fromDate)
            scheduleCmd.Parameters.AddWithValue("@ToDate", toDate)

            Dim reader = scheduleCmd.ExecuteReader()
            Dim days As New List(Of DaySchedule)
            While reader.Read()
                days.Add(New DaySchedule With {
                    .ScheduleDate = Convert.ToDateTime(reader("ScheduleDate")).ToString("yyyy-MM-dd"),
                    .StartHour = CType(reader("StartTime"), TimeSpan).Hours,
                    .EndHour = CType(reader("EndTime"), TimeSpan).Hours
                })
            End While
            reader.Close()

            ' جلب المواعيد
            Dim appointCmd As New SqlCommand("
                SELECT AppointmentID, DateOfApp, StartTime, DurationInMin, BookingColor, P.FullName AS PatientName
                FROM dbo.Appointments A 
                INNER JOIN dbo.Patients P ON A.PatientID=P.PatientID
                WHERE DoctorID=@DoctorID AND DateOfApp BETWEEN @FromDate AND @ToDate
            ", conn)
            appointCmd.Parameters.AddWithValue("@DoctorID", doctorId)
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

            ' دمج المواعيد مع الأيام
            For Each d In days
                d.Appointments = appointments.Where(Function(a) a.DateOfApp = d.ScheduleDate).ToList()
                result.Add(d)
            Next
        End Using

        Return result
    End Function

    <WebMethod()>
    Public Shared Function MoveAppointment(appointmentId As Integer, newDate As String, newStartTime As String) As Boolean
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("UPDATE Appointments SET DateOfApp=@Date, StartTime=@Time WHERE AppointmentID=@ID", conn)
                cmd.Parameters.AddWithValue("@Date", newDate)
                cmd.Parameters.AddWithValue("@Time", newStartTime)
                cmd.Parameters.AddWithValue("@ID", appointmentId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Return True
    End Function

    <WebMethod()>
    Public Shared Function UpdateAppointmentDuration(appointmentId As Integer, newDuration As Integer) As Boolean
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("UPDATE Appointments SET DurationInMin=@Duration WHERE AppointmentID=@ID", conn)
                cmd.Parameters.AddWithValue("@Duration", newDuration)
                cmd.Parameters.AddWithValue("@ID", appointmentId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Return True
    End Function

    <WebMethod()>
    Public Shared Function CopyAppointment(appointmentId As Integer, newDate As String, newStartTime As String) As Boolean
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("
                INSERT INTO Appointments (ClinicID, DoctorID, PatientID, DateOfApp, StartTime, DurationInMin, Note, IsConfirmed, BookingColor, BookingType)
                SELECT ClinicID, DoctorID, PatientID, @Date, @Time, DurationInMin, Note, IsConfirmed, BookingColor, BookingType
                FROM Appointments WHERE AppointmentID=@ID
            ", conn)
                cmd.Parameters.AddWithValue("@Date", newDate)
                cmd.Parameters.AddWithValue("@Time", newStartTime)
                cmd.Parameters.AddWithValue("@ID", appointmentId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Return True
    End Function

    <WebMethod()>
    Public Shared Function DeleteAppointment(appointmentId As Integer) As Boolean
        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("DELETE FROM Appointments WHERE AppointmentID=@ID", conn)
                cmd.Parameters.AddWithValue("@ID", appointmentId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        Return True
    End Function

    ' ==========================================
    ' الكلاسات
    ' ==========================================
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
