Imports System.Web
Imports System.Data.SqlClient
Imports System.Web.Script.Serialization

Public Class GetItems : Implements IHttpHandler

    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "application/json"
        Dim term As String = context.Request("term") & ""

        Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        Dim items As New List(Of Object)

        Using conn As New SqlConnection(connStr)
            ' البحث في جدول PurchaseInvoiceItems
            Dim query As String = "
                SELECT DISTINCT ItemCode, ItemName, UnitPrice, Tax
                FROM PurchaseInvoiceItems
                WHERE ItemCode LIKE @term OR ItemName LIKE @term
                ORDER BY ItemName"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@term", "%" & term & "%")
                conn.Open()
                Using reader = cmd.ExecuteReader()
                    While reader.Read()
                        items.Add(New With {
                            Key .ItemCode = reader("ItemCode").ToString(),
                            Key .ItemName = reader("ItemName").ToString(),
                            Key .UnitPrice = Convert.ToDecimal(reader("UnitPrice")),
                            Key .TaxRate = Convert.ToDecimal(reader("Tax"))
                        })
                    End While
                End Using
            End Using
        End Using

        Dim js As New JavaScriptSerializer()
        context.Response.Write(js.Serialize(items))
    End Sub

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class
