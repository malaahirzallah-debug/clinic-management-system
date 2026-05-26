Imports System.Data
Imports System.Data.SqlClient

Public Class SuppliersList
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' التأكد من وجود جلسة العيادة
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If

        If Not IsPostBack Then
            BindSuppliers()
        End If
    End Sub

    Private Sub BindSuppliers()
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim dt As New DataTable()

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT SupplierID, CompanyName, AgentName, Phone, Email, Address, Notes FROM Suppliers WHERE ClinicID=@ClinicID ORDER BY SupplierID DESC", conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                Using da As New SqlDataAdapter(cmd)
                    da.Fill(dt)
                End Using
            End Using
        End Using

        ' ربط البيانات بالـ Repeater
        rptSuppliers.DataSource = dt
        rptSuppliers.DataBind()

        gvSuppliers.DataSource = dt
        gvSuppliers.DataBind()
    End Sub

    ' التعامل مع أزرار العمليات داخل الـ Repeater
    Protected Sub rptSuppliers_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptSuppliers.ItemCommand
        Dim supplierID As Integer = Convert.ToInt32(e.CommandArgument)

        Select Case e.CommandName
            Case "ViewInvoices"
                Response.Redirect("SupplierInvoices.aspx?SupplierID=" & supplierID)
            Case "EditSupplier"
                Response.Redirect("EditSuppliers.aspx?SupplierID=" & supplierID)
        End Select
    End Sub
    Protected Sub gvSuppliers_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSuppliers.RowCommand
        Dim supplierID As Integer = Convert.ToInt32(e.CommandArgument)
        Select Case e.CommandName
            Case "ViewInvoices"
                Response.Redirect("SupplierInvoices.aspx?SupplierID=" & supplierID)
            Case "EditSupplier"
                Response.Redirect("EditSuppliers.aspx?SupplierID=" & supplierID)
        End Select
    End Sub

    Protected Sub gvSuppliers_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSuppliers.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow AndAlso Session("Permissions") IsNot Nothing Then
            Dim permissions As List(Of String) = TryCast(Session("Permissions"), List(Of String))

            ' زر عرض الفواتير
            Dim btnView As Button = TryCast(e.Row.FindControl("btnViewInvoicesGV"), Button)
            If btnView IsNot Nothing Then
                btnView.Visible = permissions.Contains("btnViewInvoices")
            End If

            ' زر تعديل المورد
            Dim btnEdit As Button = TryCast(e.Row.FindControl("btnEditSupplierGV"), Button)
            If btnEdit IsNot Nothing Then
                btnEdit.Visible = permissions.Contains("btnEditSupplier")
            End If
        End If
    End Sub

    Protected Sub rptSuppliers_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptSuppliers.ItemDataBound
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            If Session("Permissions") IsNot Nothing Then
                Dim permissions As List(Of String) = TryCast(Session("Permissions"), List(Of String))

                ' زر عرض الفواتير
                Dim btnView As Button = TryCast(e.Item.FindControl("btnViewInvoices"), Button)
                If btnView IsNot Nothing Then
                    btnView.Visible = permissions.Contains("btnViewInvoices")
                End If

                ' زر تعديل المورد
                Dim btnEdit As Button = TryCast(e.Item.FindControl("btnEditSupplier"), Button)
                If btnEdit IsNot Nothing Then
                    btnEdit.Visible = permissions.Contains("btnEditSupplier")
                End If
            End If
        End If
    End Sub
End Class
