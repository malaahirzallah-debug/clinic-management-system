Imports System.Data
Imports System.Data.SqlClient
Public Class AddInsuranceCompany
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        ' التحقق من تعبئة الحقول الأساسية
        If String.IsNullOrWhiteSpace(txtCompanyName.Text) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('يرجى تعبئة اسم الشركة.');", True)
            Return
        End If

        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("INSERT INTO InsuranceCompanies (ClinicID, CompanyName, ContactPerson, Phone, Email, Address, SettlementMethod, Notes) " &
                                      "VALUES (@ClinicID, @CompanyName, @ContactPerson, @Phone, @Email, @Address, @SettlementMethod, @Notes)", conn)

            ' رقم العيادة من السيشن مباشرة
            cmd.Parameters.AddWithValue("@ClinicID", Session("ClinicID"))

            ' تمرير القيم من الحقول
            cmd.Parameters.AddWithValue("@CompanyName", txtCompanyName.Text.Trim())
            cmd.Parameters.AddWithValue("@ContactPerson", If(String.IsNullOrWhiteSpace(txtContactPerson.Text), DBNull.Value, txtContactPerson.Text.Trim()))
            cmd.Parameters.AddWithValue("@Phone", If(String.IsNullOrWhiteSpace(txtPhone.Text), DBNull.Value, txtPhone.Text.Trim()))
            cmd.Parameters.AddWithValue("@Email", If(String.IsNullOrWhiteSpace(txtEmail.Text), DBNull.Value, txtEmail.Text.Trim()))
            cmd.Parameters.AddWithValue("@Address", If(String.IsNullOrWhiteSpace(txtAddress.Text), DBNull.Value, txtAddress.Text.Trim()))
            cmd.Parameters.AddWithValue("@SettlementMethod", ddlSettlementMethod.SelectedValue)
            cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrWhiteSpace(txtNotes.Text), DBNull.Value, txtNotes.Text.Trim()))

            Try
                conn.Open()
                cmd.ExecuteNonQuery()

                ' رسالة نجاح
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('تم حفظ الشركة بنجاح.'); window.location='AddInsuranceCompany.aspx';", True)

            Catch ex As Exception
                ' رسالة خطأ
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", $"alert('حدث خطأ أثناء الحفظ: {ex.Message}');", True)
            End Try
        End Using
    End Sub
End Class
