Imports System
Imports System.Web
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization

Public Class GetInsurance : Implements IHttpHandler
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        Dim patientID As String = context.Request.QueryString("PatientID")
        Dim result As New Dictionary(Of String, Object)

        If String.IsNullOrEmpty(patientID) Then
            result("success") = False
            result("message") = "PatientID missing"
            context.Response.Write(New JavaScriptSerializer().Serialize(result))
            Return
        End If

        Dim connString As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Using conn As New SqlConnection(connString)
            conn.Open()
            Dim cmd As New SqlCommand("
                SELECT TOP 1 CardNumber, InsuranceCompanyID, CoveragePercentage, CoverageType, ExpiryDate
                FROM InsuranceCards
                WHERE PatientID = @PatientID
                ORDER BY CreatedAt DESC
            ", conn)
            cmd.Parameters.AddWithValue("@PatientID", patientID)
            Dim reader = cmd.ExecuteReader()
            If reader.Read() Then
                Dim expiry As DateTime = reader("ExpiryDate")
                If expiry >= DateTime.Now Then
                    result("success") = True
                    result("CardNumber") = reader("CardNumber")
                    result("InsuranceCompanyID") = reader("InsuranceCompanyID")
                    result("CoveragePercentage") = reader("CoveragePercentage")
                    result("CoverageType") = reader("CoverageType")
                Else
                    result("success") = False
                    result("message") = "Insurance expired"
                End If
            Else
                result("success") = False
                result("message") = "No insurance found"
            End If
        End Using

        context.Response.Write(New JavaScriptSerializer().Serialize(result))
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
