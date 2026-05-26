Imports System.Data
Imports System.Data.SqlClient
Public Class ShowAllDoctor
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadDoctors()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub
    Private Sub LoadDoctors(Optional filterStatus As String = "all", Optional searchText As String = "")
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim sql As String = "SELECT DoctorID, Name, Specialty, Phone, Active FROM Doctors WHERE ClinicID=@ClinicID"
        Dim parameters As New List(Of SqlParameter) From {
            New SqlParameter("@ClinicID", clinicID)
        }

        ' فلترة الحالة
        Select Case filterStatus
            Case "active"
                sql &= " AND Active=1"
            Case "inactive"
                sql &= " AND Active=0"
        End Select

        ' فلترة البحث
        If Not String.IsNullOrEmpty(searchText) Then
            sql &= " AND (Name LIKE @Search OR Specialty LIKE @Search)"
            parameters.Add(New SqlParameter("@Search", "%" & searchText & "%"))
        End If

        sql &= " ORDER BY Name"

        Dim dt As New DataTable()
        Using con As New SqlConnection(connStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddRange(parameters.ToArray())
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        gvDoctors.DataSource = dt
        gvDoctors.DataBind()
    End Sub

    Protected Sub btnFilter_Click(sender As Object, e As EventArgs) Handles btnFilter.Click
        LoadDoctors(ddlStatus.SelectedValue, txtSearch.Text.Trim())
    End Sub

    Protected Sub btnOnDemand_Click(sender As Object, e As EventArgs) Handles btnOnDemand.Click
        ' يعرض الأطباء غير المفعلين
        LoadDoctors("inactive")
        ddlStatus.SelectedValue = "inactive"
        txtSearch.Text = ""
    End Sub

    Protected Sub gvDoctors_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDoctors.RowCommand
        Dim doctorID As Integer = Convert.ToInt32(e.CommandArgument)

        Select Case e.CommandName
            Case "EditDoctor"
                Response.Redirect("EditDoctor.aspx?id=" & doctorID)

            Case "ToggleActive"
                ToggleDoctorActive(doctorID)
        End Select
    End Sub

    Private Sub ToggleDoctorActive(doctorID As Integer)
        Dim sql As String = "UPDATE Doctors SET Active = CASE WHEN Active=1 THEN 0 ELSE 1 END WHERE DoctorID=@DoctorID"
        Using con As New SqlConnection(connStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@DoctorID", doctorID)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        LoadDoctors(ddlStatus.SelectedValue, txtSearch.Text.Trim())
    End Sub
    Protected Sub gvDoctors_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDoctors.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then

            ' التأكد أولاً من وجود السيشن قبل الاستخدام
            If Session("Permissions") IsNot Nothing Then
                Dim permissions As List(Of String) = TryCast(Session("Permissions"), List(Of String))
                If permissions IsNot Nothing Then

                    ' زر التعديل
                    Dim btnEdit As Button = TryCast(e.Row.FindControl("btnEditDoctor"), Button)
                    If btnEdit IsNot Nothing Then
                        btnEdit.Visible = permissions.Contains("btnEditDoctor")
                    End If

                    ' زر التفعيل/إيقاف
                    Dim btnToggle As Button = TryCast(e.Row.FindControl("btnToggleDoctor"), Button)
                    If btnToggle IsNot Nothing Then
                        btnToggle.Visible = permissions.Contains("btnToggleDoctor")
                    End If

                End If
            Else
                ' إذا السيشن فارغة، نخفي الأزرار
                Dim btnEdit As Button = TryCast(e.Row.FindControl("btnEditDoctor"), Button)
                If btnEdit IsNot Nothing Then btnEdit.Visible = False

                Dim btnToggle As Button = TryCast(e.Row.FindControl("btnToggleDoctor"), Button)
                If btnToggle IsNot Nothing Then btnToggle.Visible = False
            End If

        End If
    End Sub


End Class
