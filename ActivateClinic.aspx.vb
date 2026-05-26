''Imports System.Data.SqlClient
''Imports System.Security.Cryptography
''Imports System.Text
''Imports System.Net.Mail

''Public Class ActivateClinic
''    Inherits System.Web.UI.Page

''    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
''    Dim dashboardEmail As String = "hitsclinicdashboard@gmail.com"
''    Dim dashboardPassword As String = "HITS.6541242"

''    ' ------------------ دوال التشفير ------------------
''    Private Function GenerateSalt(Optional length As Integer = 16) As String
''        Dim rng As New RNGCryptoServiceProvider()
''        Dim saltBytes(length - 1) As Byte
''        rng.GetBytes(saltBytes)
''        Return Convert.ToBase64String(saltBytes)
''    End Function

''    Private Function HashPassword(password As String, salt As String) As String
''        Using sha As SHA256 = SHA256.Create()
''            Dim bytes As Byte() = Encoding.UTF8.GetBytes(password & salt)
''            Dim hashBytes As Byte() = sha.ComputeHash(bytes)
''            Return Convert.ToBase64String(hashBytes)
''        End Using
''    End Function

''    ' ------------------ صفحة التحميل ------------------
''    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
''        If Not IsPostBack Then
''            Dim clinicIDStr As String = Request.QueryString("id")
''            Dim clinicID As Integer
''            If Not Integer.TryParse(clinicIDStr, clinicID) Then
''                Response.Redirect("Default.aspx")
''            End If

''            Using conn As New SqlConnection(connStr)
''                conn.Open()

''                Dim cmd As New SqlCommand("SELECT ClinicName, Email FROM Clinics WHERE ClinicID=@clinicID", conn)
''                cmd.Parameters.AddWithValue("@clinicID", clinicID)
''                Dim reader = cmd.ExecuteReader()
''                If reader.Read() Then
''                    Dim clinicName As String = reader("ClinicName")
''                    Dim clinicEmail As String = reader("Email")
''                    reader.Close()

''                    ' تحديث أو إنشاء الاشتراك
''                    Dim subCmd As New SqlCommand(
''                        "UPDATE Subscriptions " &
''                        "SET IsActive = 1, StartDate = GETDATE(), EndDate = DATEADD(day,30,GETDATE()), MaxPatients=10 " &
''                        "WHERE ClinicID=@ClinicID", conn)
''                    subCmd.Parameters.AddWithValue("@ClinicID", clinicID)
''                    Dim rowsAffected As Integer = subCmd.ExecuteNonQuery()

''                    If rowsAffected = 0 Then
''                        Dim insertSub As New SqlCommand(
''                            "INSERT INTO Subscriptions (ClinicID, StartDate, EndDate, MaxPatients, IsActive) " &
''                            "VALUES (@ClinicID, GETDATE(), DATEADD(day,30,GETDATE()), 10, 1)", conn)
''                        insertSub.Parameters.AddWithValue("@ClinicID", clinicID)
''                        insertSub.ExecuteNonQuery()
''                    End If

''                    ' إنشاء 3 حسابات عشوائية
''                    Dim dtUsers As New DataTable()
''                    dtUsers.Columns.Add("UserName")
''                    dtUsers.Columns.Add("Password")

''                    For i As Integer = 1 To 3
''                        Dim username As String = clinicName.Replace(" ", "") & "_User" & i
''                        Dim password As String = GenerateRandomPassword(10)
''                        Dim salt As String = GenerateSalt()
''                        Dim passwordHash As String = HashPassword(password, salt)

''                        Dim insertCmd As New SqlCommand(
''                            "INSERT INTO Users (ClinicID, UserName, PasswordHash, PasswordSalt, IsAdmin, CreatedAt) " &
''                            "VALUES (@ClinicID, @UserName, @PasswordHash, @PasswordSalt, 0, GETDATE())", conn)
''                        insertCmd.Parameters.AddWithValue("@ClinicID", clinicID)
''                        insertCmd.Parameters.AddWithValue("@UserName", username)
''                        insertCmd.Parameters.AddWithValue("@PasswordHash", passwordHash)
''                        insertCmd.Parameters.AddWithValue("@PasswordSalt", salt)
''                        insertCmd.ExecuteNonQuery()

''                        dtUsers.Rows.Add(username, password)
''                    Next

''                    gvUsers.DataSource = dtUsers
''                    gvUsers.DataBind()
''                    gvUsers.Visible = True

''                    lblMessage.Text = "تم تفعيل العيادة وإنشاء الحسابات. الرجاء إرسال بيانات الدخول للعيادة."

''                    ' إرسال إيميل للعيادة مع الحسابات
''                    SendClinicEmail(clinicName, clinicEmail, dtUsers)
''                Else
''                    Response.Redirect("Default.aspx")
''                End If
''            End Using
''        End If
''    End Sub

''    ' ------------------ إرسال الإيميل ------------------
''    Private Sub SendClinicEmail(clinicName As String, clinicEmail As String, dtUsers As DataTable)
''        Try
''            Dim mail As New MailMessage()
''            mail.From = New MailAddress(dashboardEmail)
''            mail.To.Add(clinicEmail)
''            mail.Subject = "تم تفعيل حساب العيادة في الداشبورد"
''            mail.IsBodyHtml = True

''            Dim body As New StringBuilder()
''            body.Append($"<h3>مرحبا {clinicName},</h3>")
''            body.Append("<p>تم تفعيل حساب العيادة بنجاح. إليك بيانات الدخول:</p>")
''            body.Append("<table border='1' cellpadding='5'><tr><th>اسم المستخدم</th><th>كلمة المرور</th></tr>")

''            For Each row As DataRow In dtUsers.Rows
''                body.Append($"<tr><td>{row("UserName")}</td><td>{row("Password")}</td></tr>")
''            Next
''            body.Append("</table>")
''            body.Append("<p>الرجاء تغيير كلمة المرور بعد تسجيل الدخول الأول.</p>")

''            mail.Body = body.ToString()

''            Dim smtp As New SmtpClient("smtp.gmail.com")
''            smtp.Port = 587
''            smtp.Credentials = New System.Net.NetworkCredential(dashboardEmail, dashboardPassword)
''            smtp.EnableSsl = True
''            smtp.Send(mail)
''        Catch ex As Exception
''            lblMessage.Text &= "<br>حدث خطأ أثناء إرسال الإيميل للعيادة: " & ex.Message
''        End Try
''    End Sub

''    ' ------------------ توليد كلمة مرور عشوائية ------------------
''    Private Function GenerateRandomPassword(length As Integer) As String
''        Const chars As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*"
''        Dim sb As New StringBuilder()
''        Dim rng As New RNGCryptoServiceProvider()
''        Dim buffer(3) As Byte
''        For i As Integer = 1 To length
''            rng.GetBytes(buffer)
''            Dim idx As Integer = BitConverter.ToUInt32(buffer, 0) Mod chars.Length
''            sb.Append(chars(idx))
''        Next
''        Return sb.ToString()
''    End Function

''End Class



'Imports System.Data.SqlClient
'Imports System.Security.Cryptography
'Imports System.Text
'Imports System.Net.Mail

'Public Class ActivateClinic
'    Inherits System.Web.UI.Page

'    Dim connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
'    Dim dashboardEmail As String = "yourgmail@gmail.com"
'    Dim dashboardPassword As String = "yourpassword"

'    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
'        If Not IsPostBack Then
'            Dim requestIDStr As String = Request.QueryString("id")
'            Dim requestID As Integer
'            If Not Integer.TryParse(requestIDStr, requestID) Then Response.Redirect("Default.aspx")

'            Using conn As New SqlConnection(connStr)
'                conn.Open()

'                ' جلب بيانات الطلب
'                Dim cmd As New SqlCommand("SELECT ClinicName, Address, Phone, Email, Notes FROM ClinicRequests WHERE RequestID=@RequestID", conn)
'                cmd.Parameters.AddWithValue("@RequestID", requestID)
'                Dim reader = cmd.ExecuteReader()
'                If reader.Read() Then
'                    Dim clinicName As String = reader("ClinicName")
'                    Dim address As String = reader("Address")
'                    Dim phone As String = reader("Phone")
'                    Dim email As String = reader("Email")
'                    Dim notes As String = reader("Notes")
'                    reader.Close()

'                    ' إنشاء سجل في جدول Clinic
'                    Dim clinicCode As String = GenerateClinicCode(5)
'                    Dim insertClinic As New SqlCommand(
'                        "INSERT INTO Clinic (ClinicName, ClinicCode, Address, Phone, Email, Notes, IsActive, CreatedAt) " &
'                        "OUTPUT INSERTED.ClinicID VALUES (@ClinicName,@ClinicCode,@Address,@Phone,@Email,@Notes,1,GETDATE())", conn)
'                    insertClinic.Parameters.AddWithValue("@ClinicName", clinicName)
'                    insertClinic.Parameters.AddWithValue("@ClinicCode", clinicCode)
'                    insertClinic.Parameters.AddWithValue("@Address", address)
'                    insertClinic.Parameters.AddWithValue("@Phone", phone)
'                    insertClinic.Parameters.AddWithValue("@Email", email)
'                    insertClinic.Parameters.AddWithValue("@Notes", notes)
'                    Dim clinicID As Integer = insertClinic.ExecuteScalar()

'                    ' إنشاء اشتراك افتراضي 30 يوم
'                    Dim subCmd As New SqlCommand(
'                        "INSERT INTO Subscriptions (ClinicID, StartDate, EndDate, MaxPatients, IsActive) " &
'                        "VALUES (@ClinicID, GETDATE(), DATEADD(day,30,GETDATE()), 10, 1)", conn)
'                    subCmd.Parameters.AddWithValue("@ClinicID", clinicID)
'                    subCmd.ExecuteNonQuery()

'                    ' إنشاء 3 حسابات عشوائية
'                    Dim dtUsers As New DataTable()
'                    dtUsers.Columns.Add("UserName")
'                    dtUsers.Columns.Add("Password")

'                    For i As Integer = 1 To 3
'                        Dim username As String = CleanName(clinicName) & "_User" & i
'                        Dim password As String = GenerateRandomPassword(10)
'                        Dim salt As String = GenerateSalt()
'                        Dim passwordHash As String = HashPassword(password, salt)

'                        Dim insertUser As New SqlCommand(
'                            "INSERT INTO Users (ClinicID, UserName, PasswordHash, PasswordSalt, IsAdmin, CreatedAt) " &
'                            "VALUES (@ClinicID,@UserName,@PasswordHash,@PasswordSalt,0,GETDATE())", conn)
'                        insertUser.Parameters.AddWithValue("@ClinicID", clinicID)
'                        insertUser.Parameters.AddWithValue("@UserName", username)
'                        insertUser.Parameters.AddWithValue("@PasswordHash", passwordHash)
'                        insertUser.Parameters.AddWithValue("@PasswordSalt", salt)
'                        insertUser.ExecuteNonQuery()

'                        dtUsers.Rows.Add(username, password)
'                    Next

'                    gvUsers.DataSource = dtUsers
'                    gvUsers.DataBind()
'                    gvUsers.Visible = True
'                    lblMessage.Text = "تم تفعيل العيادة وإنشاء الحسابات."

'                    ' إرسال إيميل للعيادة
'                    SendClinicEmail(clinicName, email, dtUsers)
'                Else
'                    Response.Redirect("Default.aspx")
'                End If
'            End Using
'        End If
'    End Sub

'    ' ------------------ دوال مساعدة ------------------
'    Private Function GenerateClinicCode(length As Integer) As String
'        Const chars As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
'        Dim sb As New StringBuilder()
'        Dim rng As New RNGCryptoServiceProvider()
'        Dim buffer(3) As Byte
'        For i As Integer = 1 To length
'            rng.GetBytes(buffer)
'            Dim idx As Integer = BitConverter.ToUInt32(buffer, 0) Mod chars.Length
'            sb.Append(chars(idx))
'        Next
'        Return sb.ToString()
'    End Function

'    Private Function CleanName(name As String) As String
'        Return New String(name.Where(Function(c) Char.IsLetterOrDigit(c)).ToArray())
'    End Function

'    Private Function GenerateSalt(Optional length As Integer = 16) As String
'        Dim rng As New RNGCryptoServiceProvider()
'        Dim saltBytes(length - 1) As Byte
'        rng.GetBytes(saltBytes)
'        Return Convert.ToBase64String(saltBytes)
'    End Function

'    Private Function HashPassword(password As String, salt As String) As String
'        Using sha As SHA256 = SHA256.Create()
'            Dim bytes() As Byte = Encoding.UTF8.GetBytes(password & salt)
'            Dim hashBytes() As Byte = sha.ComputeHash(bytes)
'            Return Convert.ToBase64String(hashBytes)
'        End Using
'    End Function

'    Private Function GenerateRandomPassword(length As Integer) As String
'        Const chars As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*"
'        Dim sb As New StringBuilder()
'        Dim rng As New RNGCryptoServiceProvider()
'        Dim buffer(3) As Byte
'        For i As Integer = 1 To length
'            rng.GetBytes(buffer)
'            sb.Append(chars(BitConverter.ToUInt32(buffer, 0) Mod chars.Length))
'        Next
'        Return sb.ToString()
'    End Function

'    Private Sub SendClinicEmail(clinicName As String, clinicEmail As String, dtUsers As DataTable)
'        Try
'            Dim mail As New MailMessage()
'            mail.From = New MailAddress(dashboardEmail, "HITS Clinic Dashboard")
'            mail.To.Add(clinicEmail)
'            mail.Subject = "تم تفعيل حساب العيادة"
'            mail.IsBodyHtml = True

'            Dim body As New StringBuilder()
'            body.Append($"<h3>مرحبا {clinicName}</h3>")
'            body.Append("<p>تم تفعيل حساب العيادة. بيانات الدخول:</p>")
'            body.Append("<table border='1' cellpadding='5'><tr><th>اسم المستخدم</th><th>كلمة المرور</th></tr>")
'            For Each row As DataRow In dtUsers.Rows
'                body.Append($"<tr><td>{row("UserName")}</td><td>{row("Password")}</td></tr>")
'            Next
'            body.Append("</table>")
'            mail.Body = body.ToString()

'            Dim smtp As New SmtpClient("smtp.gmail.com", 587)
'            smtp.Credentials = New System.Net.NetworkCredential(dashboardEmail, dashboardPassword)
'            smtp.EnableSsl = True
'            smtp.Send(mail)
'        Catch ex As Exception
'            lblMessage.Text &= "<br>خطأ في إرسال البريد للعيادة: " & ex.Message
'        End Try
'    End Sub
'End Class


Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text
Imports System.Net.Mail

Public Class ActivateClinic
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Dim dashboardEmail As String = "yourgmail@gmail.com"
    Dim dashboardPassword As String = "yourpassword"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim requestIDStr As String = Request.QueryString("id")
            Dim requestID As Integer
            If Not Integer.TryParse(requestIDStr, requestID) Then Response.Redirect("Default.aspx")

            Using conn As New SqlConnection(connStr)
                conn.Open()

                ' جلب بيانات الطلب
                Dim cmd As New SqlCommand("SELECT ClinicName, Address, Phone, Email, Notes FROM ClinicRequests WHERE RequestID=@RequestID", conn)
                cmd.Parameters.AddWithValue("@RequestID", requestID)
                Dim reader = cmd.ExecuteReader()
                If reader.Read() Then
                    Dim clinicName As String = reader("ClinicName")
                    Dim address As String = reader("Address")
                    Dim phone As String = reader("Phone")
                    Dim email As String = reader("Email")
                    Dim notes As String = reader("Notes")
                    reader.Close()

                    ' إنشاء سجل في جدول Clinic
                    Dim clinicCode As String = GenerateClinicCode(5)
                    Dim insertClinic As New SqlCommand(
                        "INSERT INTO Clinics (ClinicName, ClinicCode, Address, Phone, Email, Notes, IsActive, CreatedAt) " &
                        "OUTPUT INSERTED.ClinicID VALUES (@ClinicName,@ClinicCode,@Address,@Phone,@Email,@Notes,1,GETDATE())", conn)
                    insertClinic.Parameters.AddWithValue("@ClinicName", clinicName)
                    insertClinic.Parameters.AddWithValue("@ClinicCode", clinicCode)
                    insertClinic.Parameters.AddWithValue("@Address", address)
                    insertClinic.Parameters.AddWithValue("@Phone", phone)
                    insertClinic.Parameters.AddWithValue("@Email", email)
                    insertClinic.Parameters.AddWithValue("@Notes", notes)
                    Dim clinicID As Integer = insertClinic.ExecuteScalar()

                    ' إنشاء اشتراك افتراضي 30 يوم
                    Dim subCmd As New SqlCommand(
                        "INSERT INTO Subscriptions (ClinicID, StartDate, EndDate, MaxPatients, IsActive) " &
                        "VALUES (@ClinicID, GETDATE(), DATEADD(day,30,GETDATE()), 10, 1)", conn)
                    subCmd.Parameters.AddWithValue("@ClinicID", clinicID)
                    subCmd.ExecuteNonQuery()

                    ' إنشاء 3 حسابات عشوائية
                    Dim dtUsers As New DataTable()
                    dtUsers.Columns.Add("UserName")
                    dtUsers.Columns.Add("Password")

                    For i As Integer = 1 To 3
                        Dim username As String = CleanName(clinicName) & "_User" & i
                        Dim password As String = GenerateRandomPassword(10)
                        Dim salt As String = GenerateSalt()
                        Dim passwordHash As String = HashPassword(password, salt)

                        Dim insertUser As New SqlCommand(
                            "INSERT INTO Users (ClinicID, UserName, PasswordHash, PasswordSalt, IsAdmin, CreatedAt) " &
                            "VALUES (@ClinicID,@UserName,@PasswordHash,@PasswordSalt,0,GETDATE())", conn)
                        insertUser.Parameters.AddWithValue("@ClinicID", clinicID)
                        insertUser.Parameters.AddWithValue("@UserName", username)
                        insertUser.Parameters.AddWithValue("@PasswordHash", passwordHash)
                        insertUser.Parameters.AddWithValue("@PasswordSalt", salt)
                        insertUser.ExecuteNonQuery()

                        dtUsers.Rows.Add(username, password)
                    Next

                    gvUsers.DataSource = dtUsers
                    gvUsers.DataBind()
                    gvUsers.Visible = True
                    lblMessage.Text = "تم تفعيل العيادة وإنشاء الحسابات."
                    lblMessage.Text = $"تم تفعيل العيادة بنجاح. كود العيادة هو: <b>{clinicCode}</b>"

                    ' إرسال إيميل للعيادة
                    SendClinicEmail(clinicName, email, dtUsers, clinicCode)
                Else
                    Response.Redirect("Default.aspx")
                End If
            End Using
        End If
    End Sub

    ' ------------------ دوال مساعدة ------------------
    ' ------------------ دوال مساعدة ------------------
    Private Function GenerateClinicCode(length As Integer) As String
        Dim rng As New RNGCryptoServiceProvider()
        Dim code As String = ""
        Dim isUnique As Boolean = False

        Using conn As New SqlConnection(connStr)
            conn.Open()

            While Not isUnique
                ' توليد رقم عشوائي من 5 خانات
                Dim sb As New StringBuilder()
                Dim buffer(3) As Byte
                For i As Integer = 1 To length
                    rng.GetBytes(buffer)
                    Dim digit As Integer = BitConverter.ToUInt32(buffer, 0) Mod 10 ' 0-9 فقط
                    sb.Append(digit)
                Next
                code = sb.ToString()

                ' فحص الكود في قاعدة البيانات
                Dim cmd As New SqlCommand("SELECT COUNT(*) FROM Clinics WHERE ClinicCode=@Code", conn)
                cmd.Parameters.AddWithValue("@Code", code)
                Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                If count = 0 Then
                    isUnique = True ' الكود فريد، خرج من الحلقة
                End If
            End While
        End Using

        Return code
    End Function


    Private Function CleanName(name As String) As String
        Return New String(name.Where(Function(c) Char.IsLetterOrDigit(c)).ToArray())
    End Function

    Private Function GenerateSalt(Optional length As Integer = 16) As String
        Dim rng As New RNGCryptoServiceProvider()
        Dim saltBytes(length - 1) As Byte
        rng.GetBytes(saltBytes)
        Return Convert.ToBase64String(saltBytes)
    End Function

    Private Function HashPassword(password As String, salt As String) As String
        Using sha As SHA256 = SHA256.Create()
            Dim bytes() As Byte = Encoding.UTF8.GetBytes(password & salt)
            Dim hashBytes() As Byte = sha.ComputeHash(bytes)
            Return Convert.ToBase64String(hashBytes)
        End Using
    End Function

    Private Function GenerateRandomPassword(length As Integer) As String
        Const chars As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*"
        Dim sb As New StringBuilder()
        Dim rng As New RNGCryptoServiceProvider()
        Dim buffer(3) As Byte
        For i As Integer = 1 To length
            rng.GetBytes(buffer)
            sb.Append(chars(BitConverter.ToUInt32(buffer, 0) Mod chars.Length))
        Next
        Return sb.ToString()
    End Function

    Dim adminEmail As String = "hits.est.d@gmail.com"
    Private Sub SendClinicEmail(clinicName As String, clinicEmail As String, dtUsers As DataTable, clinicCode As String)
        Using mail As New MailMessage()
            mail.From = New MailAddress("local@localhost", "HITS Clinic Dashboard")
            mail.To.Add(adminEmail)
            mail.Subject = "تم تفعيل حساب العيادة"
            mail.IsBodyHtml = True

            Dim body As New StringBuilder()
            body.Append($"<h3>مرحبا {clinicName}</h3>")
            body.Append($"<p>تم تفعيل حساب العيادة بنجاح. كود العيادة هو: <b>{clinicCode}</b></p>")
            body.Append("<table border='1' cellpadding='5'><tr><th>اسم المستخدم</th><th>كلمة المرور</th></tr>")
            For Each row As DataRow In dtUsers.Rows
                body.Append($"<tr><td>{row("UserName")}</td><td>{row("Password")}</td></tr>")
            Next
            body.Append("</table>")
            mail.Body = body.ToString()

            ' استخدام SMTP محلي
            Using smtp As New SmtpClient("localhost", 25)
                smtp.DeliveryMethod = SmtpDeliveryMethod.SpecifiedPickupDirectory
                smtp.PickupDirectoryLocation = "C:\Emails" ' البريد سيتخزن هنا بدلاً من الإرسال فعلياً
                smtp.Send(mail)
            End Using
        End Using
    End Sub
End Class
