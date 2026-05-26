Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web
Imports System.Web.SessionState
Imports System.Web.Script.Serialization

Public Class AddMedicine
    Implements IHttpHandler, IRequiresSessionState

    Private ReadOnly connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"

        Dim query As String = context.Request("query")?.Trim()
        If String.IsNullOrEmpty(query) Then
            context.Response.Write("[]")
            Return
        End If

        Dim medicines As New List(Of Object)()

        Dim sql As String = "
SELECT [MedicineID], [Name], [Notes], [CreatedAt]
FROM Medicines
WHERE Name LIKE @Query
ORDER BY Name"

        Using con As New SqlConnection(connStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@Query", query & "%")
                con.Open()
                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    While rdr.Read()
                        medicines.Add(New With {
                            Key .MedicineID = rdr("MedicineID"),
                            Key .Name = rdr("Name")
                        })
                    End While
                End Using
            End Using
        End Using

        context.Response.Write(New JavaScriptSerializer().Serialize(medicines))
    End Sub

    Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
