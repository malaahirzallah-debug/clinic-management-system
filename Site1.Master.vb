Imports System.Data.SqlClient

Public Class Site1
    Inherits System.Web.UI.MasterPage

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        CheckSession()
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
        If Not Page.IsPostBack Then
            ApplyPermissions()
        End If
    End Sub
    Private Sub ApplyPermissions()
        If Session("Permissions") Is Nothing Then Exit Sub
        Dim permissions As List(Of String) = CType(Session("Permissions"), List(Of String))

        ' قائمة العناصر التي لها صلاحيات
        Dim controlsWithPermissions As String() = {"chkDashboard",
    "chkPatients",
    "chkNewPatients",
    "chkShowPatients",
    "chkPatientsPayments",
    "chkPatientPaymentsReport",
    "chkPatientsDebtsSubscriptions",
    "chkDaily",
    "chkOpenTreatmentCard",
    "chkDashboardAppointments",
    "chkAppointments",
        "chkDoctors",
    "chkAddDoctor",
    "chkShowAllDoctor",
    "chkDoctorSchedule",
    "chkDoctorReports",
        "chkInsurance",
    "chkAddInsuranceCompany",
    "chkAddInsuranceCard",
    "chkInsuranceReports",
        "chkAccounts",
    "chkSuppliers",
    "chkSuppliersList",
    "chkEmployees",
    "chkEmployeesList",
    "chkWithdrawals",
    "chkAddExpense",
    "chkAddPurchaseInvoice",
    "chkFinancialReports",
    "chkDebtsReports",
        "chkSettings",
    "chkTreatmentsManager",
    "chkClinicSettings",
    "chkPersonalPage",
    "chkSubscriptionPayment",
    "chkContactUs"
}


        For Each ctrlID As String In controlsWithPermissions
            Dim ctrl As Control = Me.FindControl(ctrlID)
            If ctrl IsNot Nothing Then
                ctrl.Visible = permissions.Contains(ctrlID)
            End If
        Next
    End Sub
    Private Sub CheckSession()
        ' إذا المستخدم مسجل دخول
        If Session("UserID") IsNot Nothing AndAlso Session("SessionID") IsNot Nothing Then
            Using conn As New SqlConnection(connStr)
                conn.Open()
                Dim sql As String = "SELECT CurrentSessionID FROM Users WHERE UserID=@userID"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@userID", Session("UserID"))
                    Dim dbSessionID As Object = cmd.ExecuteScalar()
                    If dbSessionID IsNot Nothing Then
                        If dbSessionID.ToString() <> Session("SessionID").ToString() Then
                            ' الجلسة مختلفة → طرد المستخدم
                            Session.Clear()
                            Session.Abandon()
                            Response.Redirect("LoginPage.aspx?msg=loggedoutfromanotherdevice", False)
                        End If
                    End If
                End Using
            End Using
        End If
    End Sub
    Protected Sub LogoutUser(sender As Object, e As EventArgs)
        Try
            If Session("UserID") IsNot Nothing AndAlso Session("SessionID") IsNot Nothing Then
                Using conn As New SqlConnection(connStr)
                    conn.Open()
                    Dim sql As String = "UPDATE Users SET CurrentSessionID=NULL WHERE UserID=@userID AND CurrentSessionID=@sessionID"
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@userID", Session("UserID"))
                        cmd.Parameters.AddWithValue("@sessionID", Session("SessionID"))
                        cmd.ExecuteNonQuery()
                    End Using
                End Using
            End If
        Finally
            Session.Clear()
            Session.Abandon()
            Response.Redirect("LoginPage.aspx", False)
        End Try
    End Sub
End Class
