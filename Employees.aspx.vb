Imports System.Data.SqlClient
Public Class Employees
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtStartDate.Text = Date.Now.ToString("yyyy-MM-dd")
        End If
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
        Dim fullName As String = txtFullName.Text.Trim()
        Dim phone As String = txtPhone.Text.Trim()
        Dim age As Integer? = If(String.IsNullOrEmpty(txtAge.Text), CType(Nothing, Integer?), Convert.ToInt32(txtAge.Text))
        Dim socialStatus As String = If(rdoRegistered.Checked, "مسجل", "غير مسجل")
        Dim socialNumber As String = If(socialStatus = "مسجل", txtSocialNumber.Text.Trim(), Nothing)
        Dim startDate As Date? = If(String.IsNullOrEmpty(txtStartDate.Text), CType(Nothing, Date?), Date.Parse(txtStartDate.Text))
        Dim address As String = txtAddress.Text.Trim()
        Dim notes As String = txtNotes.Text.Trim()

        ' التحقق من القيم المطلوبة
        If String.IsNullOrEmpty(fullName) Then
            lblMessage.Text = "يرجى إدخال اسم الموظف."
            lblMessage.ForeColor = Drawing.Color.Red
            Return
        End If

        ' حفظ البيانات في قاعدة البيانات
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand()
                cmd.Connection = conn
                cmd.CommandType = CommandType.Text
                cmd.CommandText = "
                    INSERT INTO Employees
                    (ClinicID, FullName, Phone, Age, SocialStatus, SocialNumber, StartDate, Address, Notes)
                    VALUES
                    (@ClinicID, @FullName, @Phone, @Age, @SocialStatus, @SocialNumber, @StartDate, @Address, @Notes)
                "

                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                cmd.Parameters.AddWithValue("@FullName", fullName)
                cmd.Parameters.AddWithValue("@Phone", If(String.IsNullOrEmpty(phone), DBNull.Value, phone))
                cmd.Parameters.AddWithValue("@Age", If(age.HasValue, age.Value, DBNull.Value))
                cmd.Parameters.AddWithValue("@SocialStatus", socialStatus)
                cmd.Parameters.AddWithValue("@SocialNumber", If(String.IsNullOrEmpty(socialNumber), DBNull.Value, socialNumber))
                cmd.Parameters.AddWithValue("@StartDate", If(startDate.HasValue, startDate.Value, DBNull.Value))
                cmd.Parameters.AddWithValue("@Address", If(String.IsNullOrEmpty(address), DBNull.Value, address))
                cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrEmpty(notes), DBNull.Value, notes))

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using

        ' إعادة ضبط الحقول بعد الحفظ
        txtFullName.Text = ""
        txtPhone.Text = ""
        txtAge.Text = ""
        rdoRegistered.Checked = False
        rdoUnregistered.Checked = True
        txtSocialNumber.Text = ""
        txtStartDate.Text = Date.Now.ToString("yyyy-MM-dd")
        txtAddress.Text = ""
        txtNotes.Text = ""

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('تم حفظ بيانات الموظف بنجاح.'); window.location.Employees.aspx;", True)
    End Sub
    Protected Sub rdoSocialStatus_CheckedChanged(ByVal sender As Object, ByVal e As EventArgs)
        ' هون بتحط المنطق المطلوب عند تغيير الاختيار
        If rdoRegistered.Checked Then
            ' إذا اختار "مسجل"
            lblMessage.Text = "الموظف مسجل."
        ElseIf rdoUnregistered.Checked Then
            ' إذا اختار "غير مسجل"
            lblMessage.Text = "الموظف غير مسجل."
        End If
    End Sub


    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        txtFullName.Text = ""
        txtPhone.Text = ""
        txtAge.Text = ""
        rdoRegistered.Checked = False
        rdoUnregistered.Checked = True
        txtSocialNumber.Text = ""
        txtStartDate.Text = Date.Now.ToString("yyyy-MM-dd")
        txtAddress.Text = ""
        txtNotes.Text = ""
        lblMessage.Text = ""
    End Sub
End Class