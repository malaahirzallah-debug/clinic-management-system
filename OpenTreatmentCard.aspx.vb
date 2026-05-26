Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization

Public Class OpenTreatmentCard
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Property TreatmentsJson As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadGroups()
            LoadTreatments()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Private Sub LoadGroups()
        Dim dt As New DataTable
        Dim clinicId As Integer = CInt(Session("ClinicID"))
        Using con As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT GroupID, GroupName FROM TreatmentGroups WHERE ClinicID=@ClinicID", con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        rptGroups.DataSource = dt
        rptGroups.DataBind()
    End Sub

    Private Sub LoadTreatments()
        Dim dt As New DataTable
        Dim clinicId As Integer = CInt(Session("ClinicID"))
        Using con As New SqlConnection(connStr)
                Using cmd As New SqlCommand("SELECT GroupID, TreatmentName, Price FROM Treatments WHERE ClinicID=@ClinicID", con)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        ' تحويل جدول الإجراءات إلى JSON جاهز للجافاسكريبت
        Dim dict As New Dictionary(Of String, List(Of Object))
        For Each row As DataRow In dt.Rows
            Dim groupId As String = row("GroupID").ToString()
            Dim tr As New Dictionary(Of String, Object)
            tr("name") = row("TreatmentName").ToString()
            tr("price") = row("Price")
            If Not dict.ContainsKey(groupId) Then dict(groupId) = New List(Of Object)
            dict(groupId).Add(tr)
        Next

        Dim serializer As New JavaScriptSerializer()
        TreatmentsJson = serializer.Serialize(dict)
    End Sub
End Class
