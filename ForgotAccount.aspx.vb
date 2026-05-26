Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text
Imports System.Net.Mail

Public Class ForgotAccount
    Inherits System.Web.UI.Page

    Private connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    ' دالة توليد Hash من Token
    Private Function HashToken(token As String) As String
        Using sha As SHA256 = SHA256.Create()
            Dim bytes() As Byte = Encoding.UTF8.GetBytes(token)
            Dim hash() As Byte = sha.ComputeHash(bytes)
            Return Convert.ToBase64String(hash)
        End Using
    End Function

    ' دالة توليد Token عشوائي
    Private Function GenerateToken() As String
        Return Guid.NewGuid().ToString()
    End Function

    Protected Sub btnRecover_Click(sender As Object, e As EventArgs) Handles btnRecover.Click
        lblMsg.Text = ""
        Dim email As String = txtEmail.Text.Trim().ToLower()

        If String.IsNullOrEmpty(email) Then
            lblMsg.Text = "الرجاء إدخال البريد الإلكتروني."
            Return
        End If

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' جلب المستخدمين الذين لديهم نفس البريد
            Dim userSql As String = "SELECT u.UserID, u.UserName, c.ClinicCode, c.ClinicName
                                     FROM Users u
                                     INNER JOIN Clinics c ON u.ClinicID = c.ClinicID
                                     WHERE u.Email=@Email"

            Dim users As New List(Of Tuple(Of Integer, String, String, String)) ' UserID, UserName, ClinicCode, ClinicName

            Using cmd As New SqlCommand(userSql, conn)
                cmd.Parameters.AddWithValue("@Email", email)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        users.Add(Tuple.Create(
                            Convert.ToInt32(reader("UserID")),
                            reader("UserName").ToString(),
                            reader("ClinicCode").ToString(),
                            reader("ClinicName").ToString()
                        ))
                    End While
                End Using
            End Using

            If users.Count = 0 Then
                ' لا نظهر معلومات حساسة → نقول تم الإرسال بغض النظر
                lblMsg.Text = "تم إرسال رسالة إعادة تعيين كلمة المرور إلى بريدك الإلكتروني إذا كان مسجلاً لدينا."
                Return
            End If

            ' توليد رابط لكل مستخدم وحفظ Token
            Dim smtpHost As String = "smtp.yourserver.com" ' غيّرها للسيرفر الحقيقي
            Dim smtpPort As Integer = 587
            Dim smtpUser As String = "noreply@yourdomain.com"
            Dim smtpPass As String = "password"

            Dim sb As New StringBuilder()
            sb.AppendLine("مرحباً،")
            sb.AppendLine("تم طلب استرجاع بيانات الحساب. التفاصيل:")

            For Each u In users
                Dim token As String = GenerateToken()
                Dim tokenHash As String = HashToken(token)
                Dim expireDate As DateTime = DateTime.Now.AddHours(3)

                ' حفظ Token في جدول PasswordResets
                Dim insertSql As String = "INSERT INTO PasswordResets(UserID, TokenHash, ExpiresAt, IsUsed, CreatedAt)
                                           VALUES(@UserID, @TokenHash, @ExpiresAt, 0, GETDATE())"
                Using insertCmd As New SqlCommand(insertSql, conn)
                    insertCmd.Parameters.AddWithValue("@UserID", u.Item1)
                    insertCmd.Parameters.AddWithValue("@TokenHash", tokenHash)
                    insertCmd.Parameters.AddWithValue("@ExpiresAt", expireDate)
                    insertCmd.ExecuteNonQuery()
                End Using

                ' إضافة بيانات المستخدم إلى نص الإيميل
                sb.AppendLine()
                sb.AppendLine($"اسم المستخدم: {u.Item2}")
                sb.AppendLine($"رقم العيادة: {u.Item3}")
                sb.AppendLine($"اسم العيادة: {u.Item4}")
                sb.AppendLine($"رابط إعادة تعيين كلمة المرور: https://yourdomain.com/ResetPassword.aspx?token={token}")
            Next

            ' إرسال الإيميل
            Try
                Using mail As New MailMessage()
                    mail.From = New MailAddress(smtpUser, "Clinic Dashboard")
                    mail.To.Add(email)
                    mail.Subject = "استرجاع بيانات الحساب"
                    mail.Body = sb.ToString()
                    mail.IsBodyHtml = False

                    Using smtp As New SmtpClient(smtpHost, smtpPort)
                        smtp.Credentials = New System.Net.NetworkCredential(smtpUser, smtpPass)
                        smtp.EnableSsl = True
                        smtp.Send(mail)
                    End Using
                End Using

                lblMsg.Text = "تم إرسال رسالة إعادة تعيين كلمة المرور إلى بريدك الإلكتروني."
            Catch ex As Exception
                lblMsg.Text = "حدث خطأ أثناء إرسال الإيميل. الرجاء المحاولة لاحقاً."
            End Try
        End Using
    End Sub
End Class
