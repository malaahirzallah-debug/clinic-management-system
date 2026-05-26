Imports System.Data.SqlClient
Public Class AddTreatment
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadGroups()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Private Sub LoadGroups()
        Dim clinicId As Integer = Convert.ToInt32(Session("ClinicID"))

        Using con As New SqlConnection(connStr)
            con.Open()
            Dim query As String = "SELECT GroupID, GroupName FROM TreatmentGroups WHERE ClinicID = @ClinicID"
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                ddlGroups.DataSource = reader
                ddlGroups.DataTextField = "GroupName"
                ddlGroups.DataValueField = "GroupID"
                ddlGroups.DataBind()
            End Using
        End Using
        ddlGroups.Items.Insert(0, New ListItem("-- اختر مجموعة --", ""))
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Dim clinicId As Integer = Convert.ToInt32(Session("ClinicID"))

        Using con As New SqlConnection(connStr)
            con.Open()
            Dim query As String = "INSERT INTO Treatments 
(ClinicID, GroupID, TreatmentName, ShortDesc, DurationMinutes, Price, Notes) 
VALUES (@ClinicID, @GroupID, @TreatmentName, @ShortDesc, @Duration, @Price, @Notes)"

            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                cmd.Parameters.AddWithValue("@GroupID", ddlGroups.SelectedValue)
                cmd.Parameters.AddWithValue("@TreatmentName", txtTreatmentName.Text.Trim())
                cmd.Parameters.AddWithValue("@ShortDesc", txtShortDesc.Text.Trim())
                cmd.Parameters.AddWithValue("@Duration", If(String.IsNullOrEmpty(txtDuration.Text), DBNull.Value, txtDuration.Text))
                cmd.Parameters.AddWithValue("@Price", If(String.IsNullOrEmpty(txtPrice.Text), DBNull.Value, txtPrice.Text))
                cmd.Parameters.AddWithValue("@Notes", txtNotes.Text.Trim())
                cmd.ExecuteNonQuery()
            End Using
        End Using

        ClientScript.RegisterStartupScript(Me.GetType(), "saved", "alert('تمت إضافة الإجراء بنجاح'); window.location='AddTreatment.aspx';", True)
    End Sub
End Class