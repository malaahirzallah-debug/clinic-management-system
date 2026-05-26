Imports System.Data.SqlClient
Public Class Suppliers
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub
    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        ' التحقق من وجود ClinicID في السيشن
        If Session("ClinicID") Is Nothing Then
            lblMessage.Text = "رقم العيادة غير موجود في الجلسة."
            lblMessage.ForeColor = Drawing.Color.Red
            Return
        End If

        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        ' قراءة القيم من الفورم
        Dim companyName As String = txtCompanyName.Text.Trim()
        Dim agentName As String = txtAgentName.Text.Trim()
        Dim phone As String = txtPhone.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim address As String = txtAddress.Text.Trim()
        Dim notes As String = txtNotes.Text.Trim()

        ' التحقق من القيم المطلوبة
        If String.IsNullOrEmpty(companyName) Or String.IsNullOrEmpty(agentName) Then
            lblMessage.Text = "يرجى إدخال اسم الشركة واسم المندوب."
            lblMessage.ForeColor = Drawing.Color.Red
            Return
        End If

        ' حفظ البيانات في قاعدة البيانات
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand()
                cmd.Connection = conn
                cmd.CommandType = CommandType.Text
                cmd.CommandText = "
                    INSERT INTO Suppliers
                    (ClinicID, CompanyName, AgentName, Phone, Email, Address, Notes)
                    VALUES
                    (@ClinicID, @CompanyName, @AgentName, @Phone, @Email, @Address, @Notes)
                "
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                cmd.Parameters.AddWithValue("@CompanyName", companyName)
                cmd.Parameters.AddWithValue("@AgentName", agentName)
                cmd.Parameters.AddWithValue("@Phone", If(String.IsNullOrEmpty(phone), DBNull.Value, phone))
                cmd.Parameters.AddWithValue("@Email", If(String.IsNullOrEmpty(email), DBNull.Value, email))
                cmd.Parameters.AddWithValue("@Address", If(String.IsNullOrEmpty(address), DBNull.Value, address))
                cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrEmpty(notes), DBNull.Value, notes))

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using

        ' إعادة ضبط الحقول بعد الحفظ
        txtCompanyName.Text = ""
        txtAgentName.Text = ""
        txtPhone.Text = ""
        txtEmail.Text = ""
        txtAddress.Text = ""
        txtNotes.Text = ""

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('تم حفظ بيانات المورد بنجاح.'); window.location='Suppliers.aspx';", True)

    End Sub

    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        txtCompanyName.Text = ""
        txtAgentName.Text = ""
        txtPhone.Text = ""
        txtEmail.Text = ""
        txtAddress.Text = ""
        txtNotes.Text = ""
        lblMessage.Text = ""
    End Sub
End Class