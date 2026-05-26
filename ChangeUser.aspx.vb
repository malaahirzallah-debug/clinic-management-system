Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text
Imports System.Text.RegularExpressions

Public Class ChangeUser
    Inherits System.Web.UI.Page

    Private ReadOnly connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    ' دالة لتوليد هاش من كلمة المرور مع Salt (مثل تسجيل الدخول)
    Private Function HashPassword(password As String, salt As String) As String
        Using sha As SHA256 = SHA256.Create()
            Dim bytes As Byte() = Encoding.UTF8.GetBytes(password & salt)
            Dim hashBytes As Byte() = sha.ComputeHash(bytes)
            Return Convert.ToBase64String(hashBytes)
        End Using
    End Function

    ' دالة لتوليد Salt عشوائي
    Private Function GenerateSalt(length As Integer) As String
        Dim rng As New RNGCryptoServiceProvider()
        Dim saltBytes(length - 1) As Byte
        rng.GetBytes(saltBytes)
        Return Convert.ToBase64String(saltBytes)
    End Function

    Protected Sub btnChange_Click(sender As Object, e As EventArgs)
        lblMessage.Text = ""
        lblMessage.CssClass = "message"

        ' إعداد العداد
        If Session("ChangePassAttempts") Is Nothing Then Session("ChangePassAttempts") = 0
        Dim attempts As Integer = CInt(Session("ChangePassAttempts"))

        Dim currentPass As String = txtCurrentPassword.Text.Trim()
        Dim newUsername As String = txtNewUsername.Text.Trim()
        Dim newPass As String = txtNewPassword.Text.Trim()
        Dim confirmPass As String = txtConfirmPassword.Text.Trim()

        ' التحقق من الحقول
        If String.IsNullOrEmpty(currentPass) OrElse String.IsNullOrEmpty(newUsername) OrElse String.IsNullOrEmpty(newPass) OrElse String.IsNullOrEmpty(confirmPass) Then
            lblMessage.Text = "⚠ يرجى ملء جميع الحقول قبل المتابعة."
            Return
        End If

        ' التحقق من تطابق كلمة المرور الجديدة
        If newPass <> confirmPass Then
            lblMessage.Text = "❌ كلمة المرور الجديدة غير متطابقة."
            Return
        End If

        ' التحقق من قوة كلمة المرور الجديدة
        Dim pattern As String = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).+$"
        If Not Regex.IsMatch(newPass, pattern) Then
            lblMessage.Text = "❗ كلمة المرور يجب أن تحتوي على: حرف كبير واحد على الأقل، حرف صغير واحد على الأقل، ورمز واحد على الأقل."
            Return
        End If

        Dim clinicID As Integer = CInt(Session("ClinicID"))
        Dim userID As Integer = CInt(Session("UserID"))

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' جلب PasswordHash و PasswordSalt الحالي
            Dim getUserSql As String = "SELECT PasswordHash, PasswordSalt FROM Users WHERE UserID=@UserID AND ClinicID=@ClinicID"
            Dim storedHash As String = ""
            Dim salt As String = ""

            Using cmd As New SqlCommand(getUserSql, conn)
                cmd.Parameters.AddWithValue("@UserID", userID)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        storedHash = reader("PasswordHash").ToString()
                        salt = reader("PasswordSalt").ToString()
                    Else
                        lblMessage.Text = "❌ بيانات المستخدم غير موجودة."
                        Return
                    End If
                End Using
            End Using

            ' التحقق من كلمة المرور الحالية
            If HashPassword(currentPass, salt) <> storedHash Then
                attempts += 1
                Session("ChangePassAttempts") = attempts
                If attempts >= 5 Then
                    Session.Abandon()
                    Response.Redirect("~/Logout.aspx")
                Else
                    lblMessage.Text = $"❌ كلمة المرور الحالية غير صحيحة. محاولات متبقية: {5 - attempts}"
                End If
                Return
            End If

            ' كلمة المرور صحيحة → إعادة العداد للصفر
            Session("ChangePassAttempts") = 0

            ' توليد Salt جديد لكلمة المرور الجديدة
            Dim newSalt As String = GenerateSalt(16)
            Dim newHash As String = HashPassword(newPass, newSalt)

            ' تحديث اسم المستخدم وكلمة المرور + Salt الجديد
            Dim updateCmd As New SqlCommand(
                "UPDATE Users SET UserName=@Username, PasswordHash=@PasswordHash, PasswordSalt=@PasswordSalt WHERE UserID=@UserID AND ClinicID=@ClinicID", conn)
            updateCmd.Parameters.AddWithValue("@Username", newUsername)
            updateCmd.Parameters.AddWithValue("@PasswordHash", newHash)
            updateCmd.Parameters.AddWithValue("@PasswordSalt", newSalt)
            updateCmd.Parameters.AddWithValue("@UserID", userID)
            updateCmd.Parameters.AddWithValue("@ClinicID", clinicID)
            updateCmd.ExecuteNonQuery()

            lblMessage.CssClass = "message success"
            lblMessage.Text = "✅ تم تحديث اسم المستخدم وكلمة المرور بنجاح!"
        End Using
    End Sub
End Class
