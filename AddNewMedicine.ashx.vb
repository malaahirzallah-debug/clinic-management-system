Imports System.Web
Imports System.Data.SqlClient

Public Class AddNewMedicine
    Implements IHttpHandler

    Private ReadOnly connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        Dim name As String = context.Request("name")?.Trim()
        If String.IsNullOrEmpty(name) Then
            context.Response.Write("{""success"":false}")
            Return
        End If

        Using con As New SqlConnection(connStr)
            con.Open()
            Dim cmd As New SqlCommand("INSERT INTO Medicines (Name, CreatedAt) VALUES (@Name, GETDATE())", con)
            cmd.Parameters.AddWithValue("@Name", name)
            cmd.ExecuteNonQuery()
        End Using

        context.Response.Write("{""success"":true}")
    End Sub

    Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
