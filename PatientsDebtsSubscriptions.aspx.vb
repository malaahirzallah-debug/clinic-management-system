Imports System.Data
Imports System.Data.SqlClient
Public Class PatientsDebtsSubscriptions
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            rptPatients.DataSource = Nothing
            rptPatients.DataBind()
            noData.Visible = False
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub
    Protected Sub btnLoad_Click(sender As Object, e As EventArgs) Handles btnLoad.Click
        LoadPatients()
    End Sub

    Private Sub LoadPatients()
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim sql As String = "SELECT PatientID, FullName AS PatientName, Balance FROM Patients WHERE ClinicID=@ClinicID"
        Dim parameters As New List(Of SqlParameter) From {
            New SqlParameter("@ClinicID", clinicID)
        }

        Select Case ddlType.SelectedValue
            Case "debt"
                sql &= " AND Balance < 0"
            Case "subscription"
                sql &= " AND Balance > 0"
            Case "all"
                sql &= " AND Balance <> 0"
        End Select

        sql &= " ORDER BY FullName"

        Dim dt As New DataTable()
        Using con As New SqlConnection(connStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddRange(parameters.ToArray())
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        rptPatients.DataSource = dt
        rptPatients.DataBind()

        noData.Visible = (dt.Rows.Count = 0)
    End Sub
End Class