Imports System.Data
Imports System.Data.SqlClient
Public Class DoctorSchedule
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Dim ClinicID As Integer = 0
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If

        If Not IsPostBack Then
            LoadDoctors()

            txtFrom.Text = DateTime.Today.ToString("yyyy-MM-dd")
            txtTo.Text = DateTime.Today.AddMonths(1).ToString("yyyy-MM-dd")
            txtStartTime.Text = "10:00"
            txtEndTime.Text = "16:00"

            ' قيم افتراضية للحقل "تعديل يومي"
            txtFromEdit.Text = DateTime.Today.ToString("yyyy-MM-dd")
            txtToEdit.Text = DateTime.Today.AddMonths(1).ToString("yyyy-MM-dd")
        End If
    End Sub
    Private Sub LoadDoctors()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT DoctorID, Name FROM Doctors WHERE ClinicID=@ClinicID", conn)
            cmd.Parameters.AddWithValue("@ClinicID", ClinicID)
            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            da.Fill(dt)

            ddlDoctors.DataSource = dt
            ddlDoctors.DataTextField = "Name"
            ddlDoctors.DataValueField = "DoctorID"
            ddlDoctors.DataBind()
        End Using
    End Sub

    Protected Sub btnAddSchedule_Click(sender As Object, e As EventArgs)
        pnlAddSchedule.Visible = True
    End Sub

    Protected Sub btnSaveMultiple_Click(sender As Object, e As EventArgs)
        Dim doctorID As Integer = Convert.ToInt32(ddlDoctors.SelectedValue)
        Dim startDate As Date = Convert.ToDateTime(txtFrom.Text)
        Dim endDate As Date = Convert.ToDateTime(txtTo.Text)
        Dim startTime As TimeSpan = TimeSpan.Parse(txtStartTime.Text)
        Dim endTime As TimeSpan = TimeSpan.Parse(txtEndTime.Text)

        ' جمع الأيام المختارة
        Dim selectedDays As New List(Of Integer)
        For Each item As ListItem In chkDays.Items
            If item.Selected Then selectedDays.Add(Convert.ToInt32(item.Value))
        Next

        Using conn As New SqlConnection(connStr)
            conn.Open()

            Dim d As Date = startDate
            While d <= endDate
                If selectedDays.Contains(CInt(d.DayOfWeek)) Then
                    Using cmd As New SqlCommand("INSERT INTO DoctorSchedule (ClinicID, DoctorID, ScheduleDate, IsWorking, StartTime, EndTime) VALUES (@ClinicID, @DoctorID, @Date, 1, @Start, @End)", conn)
                        cmd.Parameters.AddWithValue("@ClinicID", ClinicID)
                        cmd.Parameters.AddWithValue("@DoctorID", doctorID)
                        cmd.Parameters.AddWithValue("@Date", d)
                        cmd.Parameters.AddWithValue("@Start", startTime)
                        cmd.Parameters.AddWithValue("@End", endTime)

                        Try
                            cmd.ExecuteNonQuery()
                        Catch ex As SqlException
                            ' تجاهل التكرار أو أي خطأ متعلق بالمفتاح الفريد
                        End Try
                    End Using
                End If

                d = d.AddDays(1)
            End While
        End Using

        pnlAddSchedule.Visible = False
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('تم حفظ الدوام بنجاح.');", True)
    End Sub


    Protected Sub btnShowSchedule_Click(sender As Object, e As EventArgs)
        LoadSchaedule()
    End Sub
    Protected Sub gvSchedule_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "SaveDay" Then
            Dim scheduleID As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = CType(CType(e.CommandSource, Button).NamingContainer, GridViewRow)

            Dim chkIsWorking As CheckBox = CType(row.FindControl("chkIsWorking"), CheckBox)
            Dim txtStart As TextBox = CType(row.FindControl("txtStartTimeEdit"), TextBox)
            Dim txtEnd As TextBox = CType(row.FindControl("txtEndTimeEdit"), TextBox)

            Using conn As New SqlConnection(connStr)
                conn.Open()
                Dim cmd As New SqlCommand("UPDATE DoctorSchedule SET IsWorking=@IsWorking, StartTime=@Start, EndTime=@End WHERE ScheduleID=@ScheduleID", conn)
                cmd.Parameters.AddWithValue("@IsWorking", chkIsWorking.Checked)
                cmd.Parameters.AddWithValue("@Start", txtStart.Text)
                cmd.Parameters.AddWithValue("@End", txtEnd.Text)
                cmd.Parameters.AddWithValue("@ScheduleID", scheduleID)

                cmd.ExecuteNonQuery()
            End Using

            LoadSchaedule()
        End If
    End Sub
    Private Sub LoadSchaedule()
        Dim doctorID As Integer = Convert.ToInt32(ddlDoctors.SelectedValue)
        Dim startDate As Date
        Dim endDate As Date

        ' تحقق من إدخال التواريخ
        If String.IsNullOrWhiteSpace(txtFromEdit.Text) OrElse Not Date.TryParse(txtFromEdit.Text, startDate) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('الرجاء إدخال تاريخ صالح للبداية.');", True)
            Return
        End If

        If String.IsNullOrWhiteSpace(txtToEdit.Text) OrElse Not Date.TryParse(txtToEdit.Text, endDate) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('الرجاء إدخال تاريخ صالح للنهاية.');", True)
            Return
        End If

        ' التحقق من أن الفترة صحيحة
        If startDate > endDate Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('تاريخ البداية يجب أن يكون قبل تاريخ النهاية.');", True)
            Return
        End If

        ' الآن التواريخ صالحة ويمكن استخدامها في الاستعلام
        Using conn As New SqlConnection(connStr)
            conn.Open()

            Dim cmd As New SqlCommand("
    SELECT ScheduleID, ScheduleDate, IsWorking, StartTime, EndTime
    FROM DoctorSchedule
    WHERE DoctorID = @DoctorID
      AND ScheduleDate BETWEEN @From AND @To AND ClinicID=@ClinicID 
    ORDER BY ScheduleDate
", conn)
            cmd.Parameters.AddWithValue("@DoctorID", doctorID)
            cmd.Parameters.AddWithValue("@From", startDate)
            cmd.Parameters.AddWithValue("@To", endDate)

            cmd.Parameters.AddWithValue("@ClinicID", ClinicID)

            Dim da As New SqlDataAdapter(cmd)
            Dim dt As New DataTable()
            da.Fill(dt)

            gvSchedule.DataSource = dt
            gvSchedule.DataBind()
        End Using
    End Sub
End Class