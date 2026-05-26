Imports System.Data
Imports System.Data.SqlClient

Public Class ManageChronicDiseases
    Inherits System.Web.UI.Page

    ' رقم العيادة الحالي
    Private ReadOnly Property CurrentClinicID As Integer
        Get
            Return If(Session("ClinicID") IsNot Nothing, CInt(Session("ClinicID")), 0)
        End Get
    End Property

    ' سلسلة الاتصال
    Private ReadOnly Property ConnString As String
        Get
            Return System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        End Get
    End Property

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindDiseases()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    ' جلب البيانات للـ GridView
    Private Sub BindDiseases()
        Using conn As New SqlConnection(ConnString)
            Using cmd As New SqlCommand("SELECT DiseaseID, DiseaseName FROM ChronicDiseases WHERE ClinicID=@ClinicID ORDER BY DiseaseName", conn)
                cmd.Parameters.AddWithValue("@ClinicID", CurrentClinicID)
                Dim dt As New DataTable()
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
                gvDiseases.DataSource = dt
                gvDiseases.DataBind()
            End Using
        End Using
    End Sub

    ' إضافة مرض جديد
    Protected Sub btnSaveDisease_Click(sender As Object, e As EventArgs)
        Dim diseaseName As String = txtNewDisease.Text.Trim()
        If diseaseName <> "" Then
            Using conn As New SqlConnection(ConnString)
                Using cmd As New SqlCommand("INSERT INTO ChronicDiseases (ClinicID, DiseaseName) VALUES (@ClinicID, @DiseaseName)", conn)
                    cmd.Parameters.AddWithValue("@ClinicID", CurrentClinicID)
                    cmd.Parameters.AddWithValue("@DiseaseName", diseaseName)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    conn.Close()
                End Using
            End Using
            txtNewDisease.Text = ""
            BindDiseases()
        End If
    End Sub

    ' زر إغلاق الصفحة
    Protected Sub btnClose_Click(sender As Object, e As EventArgs)
        Response.Redirect("NewPatiants.aspx")
    End Sub

    ' حذف مرض من الـ GridView
    Protected Sub gvDiseases_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDiseases.RowDeleting
        ' التأكد أن DataKeys موجودة وصالحة
        If gvDiseases.DataKeys.Count > e.RowIndex AndAlso e.RowIndex >= 0 Then
            Dim diseaseID As Integer = Convert.ToInt32(gvDiseases.DataKeys(e.RowIndex).Value)
            Using conn As New SqlConnection(ConnString)
                Using cmd As New SqlCommand("DELETE FROM ChronicDiseases WHERE DiseaseID=@DiseaseID AND ClinicID=@ClinicID", conn)
                    cmd.Parameters.AddWithValue("@DiseaseID", diseaseID)
                    cmd.Parameters.AddWithValue("@ClinicID", CurrentClinicID)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    conn.Close()
                End Using
            End Using
            BindDiseases()
        End If
    End Sub

End Class
