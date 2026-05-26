Imports System.Data.SqlClient
Public Class Withdrawals
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtDate.Text = DateTime.Now.ToString("yyyy-MM-dd")
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Protected Sub ddlType_SelectedIndexChanged(sender As Object, e As EventArgs)
        ddlDetails.Items.Clear()
        txtOtherDetails.Visible = False

        If ddlType.SelectedValue = "Supplier" Then
            LoadSuppliers()
        ElseIf ddlType.SelectedValue = "Employee" Then
            LoadEmployees()
        ElseIf ddlType.SelectedValue = "Other" Then
            txtOtherDetails.Visible = True
        End If
    End Sub

    Private Sub LoadSuppliers()
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT SupplierID, CompanyName FROM Suppliers WHERE ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                conn.Open()
                Using reader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlDetails.Items.Add(New ListItem(reader("CompanyName").ToString(), reader("SupplierID").ToString()))
                    End While
                End Using
                conn.Close()
            End Using
        End Using
    End Sub

    Private Sub LoadEmployees()
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT EmployeeID, FullName FROM Employees WHERE ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                conn.Open()
                Using reader = cmd.ExecuteReader()
                    While reader.Read()
                        ddlDetails.Items.Add(New ListItem(reader("FullName").ToString(), reader("EmployeeID").ToString()))
                    End While
                End Using
                conn.Close()
            End Using
        End Using
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim type As String = ddlType.SelectedValue
        Dim details As String = If(type = "Other", txtOtherDetails.Text.Trim(), ddlDetails.SelectedItem.Text)
        Dim amount As Decimal = 0
        Decimal.TryParse(txtAmount.Text.Trim(), amount)

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("
                INSERT INTO Withdrawals (ClinicID, WithdrawalDate, WithdrawalType, Details, Amount, PaymentMethod, Notes)
                VALUES (@ClinicID, @Date, @Type, @Details, @Amount, @PaymentMethod, @Notes)", conn)

                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                cmd.Parameters.AddWithValue("@Date", Convert.ToDateTime(txtDate.Text))
                cmd.Parameters.AddWithValue("@Type", type)
                cmd.Parameters.AddWithValue("@Details", details)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@PaymentMethod", ddlPaymentMethod.SelectedValue)
                cmd.Parameters.AddWithValue("@Notes", txtNotes.Text.Trim())

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('تم حفظ بيانات السحب بنجاح.'); window.location.Withdrawals.aspx;", True)
    End Sub
End Class