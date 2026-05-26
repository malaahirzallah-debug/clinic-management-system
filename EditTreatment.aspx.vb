Imports System.Data.SqlClient
Imports System.Configuration

Public Class EditTreatment
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadGroups()

            Dim treatmentID As String = Request.QueryString("TreatmentID")
            If String.IsNullOrEmpty(treatmentID) Then
                Response.Redirect("TreatmentsManager.aspx")
            Else
                hfTreatmentID.Value = treatmentID
                LoadTreatmentData(treatmentID)
            End If
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Private Sub LoadGroups()
        Using con As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT GroupID, GroupName FROM TreatmentGroups", con)
            con.Open()
            ddlGroups.DataSource = cmd.ExecuteReader()
            ddlGroups.DataTextField = "GroupName"
            ddlGroups.DataValueField = "GroupID"
            ddlGroups.DataBind()
        End Using
    End Sub

    Private Sub LoadTreatmentData(treatmentID As String)
        Using con As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT TreatmentName, GroupID, ShortDesc, Price, DurationMinutes, Notes 
                                       FROM Treatments WHERE TreatmentID=@TreatmentID", con)
            cmd.Parameters.AddWithValue("@TreatmentID", treatmentID)
            con.Open()
            Dim rdr As SqlDataReader = cmd.ExecuteReader()
            If rdr.Read() Then
                txtTreatmentName.Text = rdr("TreatmentName").ToString()
                ddlGroups.SelectedValue = rdr("GroupID").ToString()
                txtShortDesc.Text = rdr("ShortDesc").ToString()
                txtPrice.Text = rdr("Price").ToString()
                txtDuration.Text = rdr("DurationMinutes").ToString()
                txtNotes.Text = rdr("Notes").ToString()
            End If
        End Using
    End Sub

    Protected Sub btnUpdate_Click(sender As Object, e As EventArgs) Handles btnUpdate.Click
        Using con As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("
                UPDATE Treatments 
                SET TreatmentName=@Name, GroupID=@GroupID, ShortDesc=@Short, Price=@Price, DurationMinutes=@Duration, Notes=@Notes
                WHERE TreatmentID=@TreatmentID", con)

            cmd.Parameters.AddWithValue("@Name", txtTreatmentName.Text.Trim())
            cmd.Parameters.AddWithValue("@GroupID", ddlGroups.SelectedValue)
            cmd.Parameters.AddWithValue("@Short", txtShortDesc.Text.Trim())
            cmd.Parameters.AddWithValue("@Price", txtPrice.Text.Trim())
            cmd.Parameters.AddWithValue("@Duration", txtDuration.Text.Trim())
            cmd.Parameters.AddWithValue("@Notes", txtNotes.Text.Trim())
            cmd.Parameters.AddWithValue("@TreatmentID", hfTreatmentID.Value)

            con.Open()
            cmd.ExecuteNonQuery()
        End Using

        Response.Redirect("TreatmentsManager.aspx")
    End Sub
End Class
