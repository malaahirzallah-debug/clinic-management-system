Imports System.Data.SqlClient
Imports System.Configuration

Public Class EditGroup
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim groupId As String = Request.QueryString("GroupID")
            If Not String.IsNullOrEmpty(groupId) Then
                LoadGroupData(groupId)
            End If
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Private Sub LoadGroupData(groupId As String)
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT GroupName, Notes FROM TreatmentGroups WHERE GroupID = @GroupID", conn)
            cmd.Parameters.AddWithValue("@GroupID", groupId)
            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            If reader.Read() Then
                hfGroupID.Value = groupId
                txtGroupName.Text = reader("GroupName").ToString()
                txtNotes.Text = reader("Notes").ToString()
            End If
            conn.Close()
        End Using
    End Sub

    Protected Sub btnUpdate_Click(sender As Object, e As EventArgs) Handles btnUpdate.Click
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("UPDATE TreatmentGroups SET GroupName=@GroupName, Notes=@Notes WHERE GroupID=@GroupID", conn)
            cmd.Parameters.AddWithValue("@GroupName", txtGroupName.Text.Trim())
            cmd.Parameters.AddWithValue("@Notes", txtNotes.Text.Trim())
            cmd.Parameters.AddWithValue("@GroupID", hfGroupID.Value)
            conn.Open()
            cmd.ExecuteNonQuery()
            conn.Close()
        End Using
        Response.Redirect("TreatmentsManager.aspx")
    End Sub
End Class
