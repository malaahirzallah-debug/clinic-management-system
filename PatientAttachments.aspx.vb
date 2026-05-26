Imports System.Data.SqlClient

Public Class PatientAttachments
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindAttachments()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub
    Protected Sub btnBackToVisits_Click(sender As Object, e As EventArgs)
        Dim patientID As String = Request.QueryString("PatientID")
        If Not String.IsNullOrEmpty(patientID) Then
            Response.Redirect("PatientVisits.aspx?PatientID=" & patientID)
        Else
            Response.Redirect("ShowPatiants.aspx")
        End If
    End Sub

    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("PatientVisits.aspx")
    End Sub
    Private Sub BindAttachments()
        Dim patientID As Integer = 0
        Dim clinicID As Integer = 0

        ' تأكد من الحصول على PatientID و ClinicID
        If Request.QueryString("PatientID") IsNot Nothing Then
            Integer.TryParse(Request.QueryString("PatientID"), patientID)
        End If

        If Session("ClinicID") IsNot Nothing Then
            Integer.TryParse(Session("ClinicID").ToString(), clinicID)
        End If

        If patientID = 0 Or clinicID = 0 Then
            ' لا توجد بيانات
            rptAttachments.DataSource = Nothing
            rptAttachments.DataBind()
            Return
        End If

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT AttachmentID, VisitID, FileURL, CreatedAt FROM VisitAttachments 
                                 WHERE PatientID=@PatientID AND ClinicID=@ClinicID 
                                 ORDER BY CreatedAt DESC"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@PatientID", patientID)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)

                Dim dt As New DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)

                rptAttachments.DataSource = dt
                rptAttachments.DataBind()
            End Using
        End Using
    End Sub
End Class
