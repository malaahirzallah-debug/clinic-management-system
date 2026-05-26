Imports System.Data.SqlClient
Public Class EmployeesList
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindEmployees()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Private Sub BindEmployees()

        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT EmployeeID, FullName, Phone, Age, SocialStatus, SocialNumber, StartDate, Address FROM Employees WHERE ClinicID=@ClinicID ORDER BY FullName", conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                conn.Open()
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())

                gvEmployees.DataSource = dt
                gvEmployees.DataBind()

                rptEmployees.DataSource = dt
                rptEmployees.DataBind()

                conn.Close()
            End Using
        End Using
    End Sub

    Protected Sub gvEmployees_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvEmployees.RowCommand
        If e.CommandName = "EditEmployee" Then
            ' تحويل المستخدم إلى صفحة تعديل الموظف وتمرير EmployeeID
            Dim employeeID As Integer = Convert.ToInt32(e.CommandArgument)
            Response.Redirect("EditEmployee.aspx?EmployeeID=" & employeeID)
        ElseIf e.CommandName = "ViewWithdrawals" Then
            ' تحويل المستخدم إلى صفحة عرض السحوبات وتمرير EmployeeID
            Dim employeeID As Integer = Convert.ToInt32(e.CommandArgument)
            Response.Redirect("WithdrawalsList.aspx?EmployeeID=" & employeeID)
        End If
    End Sub
    ' في الكود الخلفي
    Protected Sub rptEmployees_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles rptEmployees.ItemCommand
        If e.CommandName = "EditEmployee" Then
            Dim employeeID As Integer = Convert.ToInt32(e.CommandArgument)
            Response.Redirect("EditEmployee.aspx?EmployeeID=" & employeeID)
        ElseIf e.CommandName = "ViewWithdrawals" Then
            Dim employeeID As Integer = Convert.ToInt32(e.CommandArgument)
            Response.Redirect("WithdrawalsList.aspx?EmployeeID=" & employeeID)
        End If
    End Sub
    Protected Sub gvEmployees_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvEmployees.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow AndAlso Session("Permissions") IsNot Nothing Then
            Dim permissions As List(Of String) = TryCast(Session("Permissions"), List(Of String))

            ' زر تعديل الموظف
            Dim btnEdit As Button = TryCast(e.Row.FindControl("btnEditEmployee"), Button)
            If btnEdit IsNot Nothing Then
                btnEdit.Visible = permissions.Contains("EditEmployee")
            End If

            ' زر عرض السحوبات
            Dim btnWithdrawals As Button = TryCast(e.Row.FindControl("btnViewWithdrawals"), Button)
            If btnWithdrawals IsNot Nothing Then
                btnWithdrawals.Visible = permissions.Contains("ViewWithdrawals")
            End If
        End If
    End Sub

    Protected Sub rptEmployees_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptEmployees.ItemDataBound
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            If Session("Permissions") IsNot Nothing Then
                Dim permissions As List(Of String) = TryCast(Session("Permissions"), List(Of String))

                ' زر تعديل الموظف للموبايل
                Dim btnEditMobile As Button = TryCast(e.Item.FindControl("btnEditEmployeeMobile"), Button)
                If btnEditMobile IsNot Nothing Then
                    btnEditMobile.Visible = permissions.Contains("EditEmployee")
                End If

                ' زر عرض السحوبات للموبايل
                Dim btnWithdrawalsMobile As Button = TryCast(e.Item.FindControl("btnViewWithdrawalsMobile"), Button)
                If btnWithdrawalsMobile IsNot Nothing Then
                    btnWithdrawalsMobile.Visible = permissions.Contains("ViewWithdrawals")
                End If
            End If
        End If
    End Sub

End Class