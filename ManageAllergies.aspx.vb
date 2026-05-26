Imports System.Data
Imports System.Data.SqlClient

Public Class ManageAllergies
    Inherits System.Web.UI.Page

    ' سلسلة الاتصال الخاصة بقاعدة البيانات
    Private ReadOnly Property ConnString As String
        Get
            Return System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        End Get
    End Property

    ' رقم العيادة من السيشن
    Private ReadOnly Property CurrentClinicID As Integer
        Get
            Return If(Session("ClinicID") IsNot Nothing, CInt(Session("ClinicID")), 0)
        End Get
    End Property

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindAllergies()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    ' تحميل البيانات للـ GridView
    Private Sub BindAllergies()
        Using conn As New SqlConnection(ConnString)
            Using cmd As New SqlCommand("SELECT AllergyID, AllergyName FROM Allergies WHERE ClinicID=@ClinicID ORDER BY AllergyName", conn)
                cmd.Parameters.AddWithValue("@ClinicID", CurrentClinicID)
                Dim dt As New DataTable()
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
                gvAllergies.DataSource = dt
                gvAllergies.DataBind()
            End Using
        End Using
    End Sub

    ' زر حفظ حساسية جديدة
    Protected Sub btnSaveAllergy_Click(sender As Object, e As EventArgs)
        Dim allergyName As String = txtNewAllergy.Text.Trim()
        If allergyName <> "" Then
            Using conn As New SqlConnection(ConnString)
                Using cmd As New SqlCommand("INSERT INTO Allergies (ClinicID, AllergyName) VALUES (@ClinicID, @AllergyName)", conn)
                    cmd.Parameters.AddWithValue("@ClinicID", CurrentClinicID)
                    cmd.Parameters.AddWithValue("@AllergyName", allergyName)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    conn.Close()
                End Using
            End Using
            txtNewAllergy.Text = ""
            BindAllergies()
        End If
    End Sub

    ' زر إغلاق الصفحة
    Protected Sub btnClose_Click(sender As Object, e As EventArgs)
        Response.Redirect("NewPatiants.aspx") ' عدل حسب الصفحة المطلوبة
    End Sub

    ' حذف حساسية من الـ GridView
    Protected Sub gvAllergies_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvAllergies.RowDeleting
        If e.RowIndex >= 0 AndAlso e.RowIndex < gvAllergies.DataKeys.Count Then
            Dim allergyID As Integer = Convert.ToInt32(gvAllergies.DataKeys(e.RowIndex).Value)
            Using conn As New SqlConnection(ConnString)
                Using cmd As New SqlCommand("DELETE FROM Allergies WHERE AllergyID=@AllergyID AND ClinicID=@ClinicID", conn)
                    cmd.Parameters.AddWithValue("@AllergyID", allergyID)
                    cmd.Parameters.AddWithValue("@ClinicID", CurrentClinicID)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    conn.Close()
                End Using
            End Using
            BindAllergies()
        End If
    End Sub

    ' لضمان أن الـ GridView يعرف الـ DataKey
    Protected Sub gvAllergies_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvAllergies.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            gvAllergies.DataKeyNames = New String() {"AllergyID"}
        End If
    End Sub

End Class
