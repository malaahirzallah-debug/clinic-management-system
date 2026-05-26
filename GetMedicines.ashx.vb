Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.SessionState

Public Class GetMedicines
    Implements IHttpHandler, IRequiresSessionState

    Dim connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        Dim query As String = context.Request("query")
        Dim clinicId As Integer = 1 ' مثال، يمكن جلبه من الجلسة أو يوزر

        Dim list As New List(Of Object)
        Using con As New SqlConnection(connStr)
            ' كل الأدوية الموجودة للعيادة، لا يوجد TOP
            Dim sql As String = "SELECT Name FROM Medicines WHERE Name LIKE @q + '%'"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                cmd.Parameters.AddWithValue("@q", query)
                con.Open()
                Using rdr = cmd.ExecuteReader()
                    While rdr.Read()
                        list.Add(New With {Key .Name = rdr("Name")})
                    End While
                End Using
            End Using
        End Using

        context.Response.Write(New System.Web.Script.Serialization.JavaScriptSerializer().Serialize(list))
    End Sub

    Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
End Class
