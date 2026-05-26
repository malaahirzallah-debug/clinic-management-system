Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text
Imports System.Net.Mail

Public Class AddEmail
    Inherits System.Web.UI.Page

    Private ReadOnly connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub btnSaveEmail_Click(sender As Object, e As EventArgs) Handles btnSaveEmail.Click
        Dim email As String = txtEmail.Text.Trim()

        ' 1) تحقق من الإيميل صالح
        If Not IsValidEmail(email) Then
            lblError.Text = "الرجاء إدخال بريد إلكتروني صحيح."
            Return
        End If

        Dim userId As Integer = Convert.ToInt32(Session("UserID"))
        If userId = 0 Then
            lblError.Text = "انتهت جلستك، الرجاء تسجيل الدخول مرة أخرى."
            Return
        End If

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' 2) تحقق إذا الإيميل مستخدم مسبقًا
            Dim checkEmailCmd As New SqlCommand("SELECT COUNT(*) FROM Users WHERE Email = @Email AND UserID <> @UserID", conn)
            checkEmailCmd.Parameters.AddWithValue("@Email", email)
            checkEmailCmd.Parameters.AddWithValue("@UserID", userId)
            Dim exists As Integer = Convert.ToInt32(checkEmailCmd.ExecuteScalar())

            If exists > 0 Then
                lblError.Text = "هذا البريد الإلكتروني مستخدم بالفعل من قبل مستخدم آخر."
                Return
            End If

            ' 3) تحديث الإيميل للمستخدم الحالي
            Dim updateCmd As New SqlCommand("UPDATE Users SET Email = @Email, EmailVerified = 0 WHERE UserID = @UserID", conn)
            updateCmd.Parameters.AddWithValue("@Email", email)
            updateCmd.Parameters.AddWithValue("@UserID", userId)
            updateCmd.ExecuteNonQuery()

            ' 4) توليد Token وتشفيره
            Dim token As String = Guid.NewGuid().ToString()
            Dim tokenHash As String = ComputeSha256Hash(token)

            ' 5) تخزين التوكين في جدول EmailVerifications
            Dim insertCmd As New SqlCommand("
                INSERT INTO EmailVerifications (UserID, TokenHash, ExpiresAt, IsUsed, CreatedAt) 
                VALUES (@UserID, @TokenHash, DATEADD(HOUR, 1, GETDATE()), 0, GETDATE())", conn)
            insertCmd.Parameters.AddWithValue("@UserID", userId)
            insertCmd.Parameters.AddWithValue("@TokenHash", tokenHash)
            insertCmd.ExecuteNonQuery()

            ' 6) إرسال رابط التحقق
            Dim verifyUrl As String = Request.Url.GetLeftPart(UriPartial.Authority) & "/VerifyEmail.aspx?token=" & token
            SendVerificationEmail(email, verifyUrl)
        End Using

        ' 7) رسالة نجاح وتحويل بعد 3 ثواني
        lblMessage.Text = "تم إرسال رابط التحقق إلى بريدك الإلكتروني."
        ClientScript.RegisterStartupScript(Me.GetType(), "redirect", "setTimeout(function(){ window.location='Login.aspx'; }, 3000);", True)
    End Sub

    Private Function IsValidEmail(email As String) As Boolean
        Try
            Dim addr = New System.Net.Mail.MailAddress(email)
            Return addr.Address = email
        Catch
            Return False
        End Try
    End Function

    Private Function ComputeSha256Hash(rawData As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes As Byte() = sha256.ComputeHash(Encoding.UTF8.GetBytes(rawData))
            Dim builder As New StringBuilder()
            For Each b As Byte In bytes
                builder.Append(b.ToString("x2"))
            Next
            Return builder.ToString()
        End Using
    End Function

    Private Sub SendVerificationEmail(toEmail As String, verifyUrl As String)
        Dim mail As New MailMessage()
        mail.From = New MailAddress("noreply@yourdomain.com", "Clinic Dashboard")
        mail.To.Add(toEmail)
        mail.Subject = "تأكيد البريد الإلكتروني"
        mail.Body = "الرجاء الضغط على الرابط التالي لتأكيد بريدك الإلكتروني: " & verifyUrl
        mail.IsBodyHtml = False

        Dim smtp As New SmtpClient("smtp.yourdomain.com") ' عدل الإعدادات
        smtp.Port = 587
        smtp.Credentials = New System.Net.NetworkCredential("noreply@yourdomain.com", "YourPassword")
        smtp.EnableSsl = True
        smtp.Send(mail)
    End Sub

End Class
