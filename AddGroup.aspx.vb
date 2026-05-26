Imports System.Data.SqlClient
Public Class AddGroup
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Dim clinicId As Integer = Convert.ToInt32(Session("ClinicID"))
        Using con As New SqlConnection(connStr)
            con.Open()
            Dim query As String = "INSERT INTO TreatmentGroups (ClinicID, GroupName, Notes) VALUES (@ClinicID, @GroupName, @Notes)"
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                cmd.Parameters.AddWithValue("@GroupName", txtGroupName.Text.Trim())
                cmd.Parameters.AddWithValue("@Notes", txtNotes.Text.Trim())
                cmd.ExecuteNonQuery()
            End Using
        End Using

        ClientScript.RegisterStartupScript(Me.GetType(), "saved", "alert('تمت إضافة المجموعة بنجاح'); window.location='TreatmentsManager.aspx';", True)
    End Sub
End Class