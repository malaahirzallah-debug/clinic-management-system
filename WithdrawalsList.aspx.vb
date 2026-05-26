Imports System.Data
Imports System.Data.SqlClient

Public Class WithdrawalsList
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' التحقق من السيشن أولاً
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If

        If Not IsPostBack Then
            Dim employeeId As Integer = Convert.ToInt32(Request.QueryString("EmployeeID"))
            BindWithdrawals(employeeId)
        End If
    End Sub

    Private Sub BindWithdrawals(employeeId As Integer)
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' نجيب اسم الموظف مع رقم العيادة للتأكد
            Dim employeeName As String = ""
            Dim cmdEmp As New SqlCommand("SELECT FullName FROM Employees WHERE EmployeeID = @EmployeeID AND ClinicID=@ClinicID", conn)
            cmdEmp.Parameters.AddWithValue("@EmployeeID", employeeId)
            cmdEmp.Parameters.AddWithValue("@ClinicID", clinicID)
            Dim result = cmdEmp.ExecuteScalar()
            If result IsNot Nothing Then
                employeeName = result.ToString()
            End If

            ' استعلام المسحوبات مقيد برقم العيادة واسم الموظف
            Dim cmd As New SqlCommand("
                SELECT WithdrawalID, ClinicID, WithdrawalDate, WithdrawalType, Details, Amount, PaymentMethod, Notes, CreatedAt
                FROM Withdrawals
                WHERE ClinicID=@ClinicID AND Details LIKE '%' + @EmployeeName + '%'
                ORDER BY WithdrawalDate DESC
            ", conn)
            cmd.Parameters.AddWithValue("@ClinicID", clinicID)
            cmd.Parameters.AddWithValue("@EmployeeName", employeeName)

            Dim dt As New DataTable()
            dt.Load(cmd.ExecuteReader())
            gvWithdrawals.DataSource = dt
            gvWithdrawals.DataBind()
        End Using
    End Sub
End Class
