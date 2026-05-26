Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text

Public Class LoginPage
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    ' دالة لتوليد هاش من كلمة المرور مع Salt
    Private Function HashPassword(password As String, salt As String) As String
        Dim sha As SHA256 = SHA256.Create()
        Dim bytes As Byte() = Encoding.UTF8.GetBytes(password & salt)
        Dim hashBytes As Byte() = sha.ComputeHash(bytes)
        Return Convert.ToBase64String(hashBytes)
    End Function
    Protected Sub btnLogin_Click(sender As Object, e As EventArgs) Handles btnLogin.Click
        lblError.Text = ""
        Dim username As String = txtUsername.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()
        Dim clinicCode As String = txtClinicID.Text.Trim()
        Dim clinicID As Integer
        Dim currentSessionID As String = Guid.NewGuid().ToString()

        If String.IsNullOrEmpty(clinicCode) Then
            lblError.Text = "الرجاء إدخال رقم العيادة."
            Return
        End If

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' 1. التحقق من وجود رقم العيادة
            Dim clinicSql As String = "SELECT ClinicID FROM Clinics WHERE ClinicCode=@clinicCode AND IsActive=1"
            Using clinicCmd As New SqlCommand(clinicSql, conn)
                clinicCmd.Parameters.AddWithValue("@clinicCode", clinicCode)
                Dim result = clinicCmd.ExecuteScalar()
                If result Is Nothing Then
                    lblError.Text = "رقم العيادة غير موجود أو غير نشط."
                    Return
                End If
                clinicID = Convert.ToInt32(result)
            End Using

            ' 2. التحقق من اسم المستخدم وكلمة المرور ضمن هذا العيادة
            Dim userSql As String = "SELECT UserID, IsAdmin, PasswordHash FROM Users WHERE UserName=@username AND ClinicID=@clinicID"
            Dim userID As Integer
            Dim isAdmin As Boolean
            Dim storedHash As String = ""
            Dim salt As String = ""

            Using userCmd As New SqlCommand(userSql, conn)
                userCmd.Parameters.AddWithValue("@username", username)
                userCmd.Parameters.AddWithValue("@clinicID", clinicID)
                Dim reader As SqlDataReader = userCmd.ExecuteReader()
                If reader.Read() Then
                    userID = reader("UserID")
                    isAdmin = reader("IsAdmin")
                    storedHash = reader("PasswordHash").ToString()
                Else
                    lblError.Text = "اسم المستخدم أو كلمة المرور غير صحيحة."
                    reader.Close()
                    Return
                End If
                reader.Close()
            End Using

            Dim sessionSql As String = "SELECT CurrentSessionID FROM Users WHERE UserID=@userID"
            Dim existingSession As String = ""
            Using sessionCmd As New SqlCommand(sessionSql, conn)
                sessionCmd.Parameters.AddWithValue("@userID", userID)
                Dim obj = sessionCmd.ExecuteScalar()
                If obj IsNot Nothing AndAlso obj IsNot DBNull.Value Then
                    existingSession = obj.ToString()
                End If
            End Using

            Dim updateSessionSql As String = "UPDATE Users SET CurrentSessionID=@sessionID WHERE UserID=@userID"
            Using updateCmd As New SqlCommand(updateSessionSql, conn)
                updateCmd.Parameters.AddWithValue("@sessionID", currentSessionID)
                updateCmd.Parameters.AddWithValue("@userID", userID)
                updateCmd.ExecuteNonQuery()
            End Using

            Session("SessionID") = currentSessionID

            ' تشفير كلمة المرور المدخلة ومقارنتها
            'Dim inputHash As String = HashPassword(password, salt)
            'If inputHash <> storedHash Then
            '    lblError.Text = "اسم المستخدم أو كلمة المرور غير صحيحة."
            '    Return
            'End If

            ' 3. جلب بيانات الاشتراك كما هي
            Dim subSql As String = "SELECT TOP 1 StartDate, EndDate, MaxPatients FROM Subscriptions WHERE ClinicID=@clinicID ORDER BY EndDate DESC"
            Using subCmd As New SqlCommand(subSql, conn)
                subCmd.Parameters.AddWithValue("@clinicID", clinicID)
                Dim subReader As SqlDataReader = subCmd.ExecuteReader()
                If subReader.Read() Then
                    Dim endDate As DateTime = subReader("EndDate")
                    Dim maxPatients As Integer = subReader("MaxPatients")
                    If endDate < DateTime.Now Then maxPatients = 10

                    ' تخزين بيانات الجلسة
                    Session("UserID") = userID
                    Session("IsAdmin") = isAdmin
                    Session("ClinicID") = clinicID
                    Session("SubscriptionEndDate") = endDate
                    Session("MaxPatients") = maxPatients
                Else
                    ' وضع تجريبي إذا ما في اشتراك
                    Session("UserID") = userID
                    Session("IsAdmin") = isAdmin
                    Session("ClinicID") = clinicID
                    Session("SubscriptionEndDate") = DateTime.Now
                    Session("MaxPatients") = 10
                End If
                subReader.Close()
            End Using

            If chkRememberMe.Checked Then
                Dim cookie As New HttpCookie("ClinicID")
                cookie.Value = txtClinicID.Text
                cookie.Expires = DateTime.Now.AddYears(1) ' الكوكيز لمدة سنة
                Response.Cookies.Add(cookie)
            Else
                ' حذف الكوكيز إذا كان موجود
                If Request.Cookies("ClinicID") IsNot Nothing Then
                    Dim cookie As New HttpCookie("ClinicID")
                    cookie.Expires = DateTime.Now.AddDays(-1)
                    Response.Cookies.Add(cookie)
                End If
            End If

            Dim clinicTypes As New List(Of String)()

            Dim typesSql As String = "SELECT TypeValue FROM ClinicSelectedTypes WHERE ClinicID=@ClinicID"
            Using typesCmd As New SqlCommand(typesSql, conn)
                typesCmd.Parameters.AddWithValue("@ClinicID", clinicID)
                Using reader As SqlDataReader = typesCmd.ExecuteReader()
                    While reader.Read()
                        clinicTypes.Add(reader("TypeValue").ToString())
                    End While
                End Using
            End Using

            ' بعد التأكد من بيانات الدخول
            Dim permissions As New List(Of String)

            Dim sql As String = "SELECT PermissionKey FROM UserPermissions WHERE UserID=@UserID AND IsAllowed=1"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@UserID", userID) ' هنا الـ UserID من جدول Users
                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    While rdr.Read()
                        permissions.Add(rdr("PermissionKey").ToString())
                    End While
                End Using
            End Using

            ' نخزنها في Session
            Session("Permissions") = permissions


            ' تخزين الأنواع في السيشن
            Session("ClinicTypes") = clinicTypes

            ' بعد تخزين السيشن والبيرمشنز
            ' نفحص إذا عند المستخدم إيميل ولا لا
            Dim emailCheckSql As String = "SELECT Email, ISNULL(EmailVerified,0) AS EmailVerified FROM Users WHERE UserID=@UserID"
            Dim userEmail As String = ""
            Dim emailVerified As Boolean = False

            Using emailCmd As New SqlCommand(emailCheckSql, conn)
                emailCmd.Parameters.AddWithValue("@UserID", userID)
                Using emailReader As SqlDataReader = emailCmd.ExecuteReader()
                    If emailReader.Read() Then
                        userEmail = emailReader("Email").ToString()
                        emailVerified = Convert.ToBoolean(emailReader("EmailVerified"))
                    End If
                End Using
            End Using

            If String.IsNullOrEmpty(userEmail) OrElse Not emailVerified Then
                ' المستخدم ما عنده إيميل أو لسه مش مفعّل
                Response.Redirect("AddEmail.aspx")
            Else
                ' عنده إيميل مفعّل → يدخل عادي
                Response.Redirect("HomePage.aspx")
            End If

        End Using
    End Sub
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Request.QueryString("msg") = "loggedoutfromanotherdevice" Then
                lblError.Text = "تم تسجيل خروجك لأن حسابك سجل دخول من جهاز آخر."
            End If
            If Request.Cookies("ClinicID") IsNot Nothing Then
                txtClinicID.Text = Request.Cookies("ClinicID").Value
                chkRememberMe.Checked = True
            End If
        End If
    End Sub

    ' دالة توليد Salt عشوائي
    Private Function GenerateSalt(length As Integer) As String
        Dim rng As New RNGCryptoServiceProvider()
        Dim saltBytes(length - 1) As Byte
        rng.GetBytes(saltBytes)
        Return Convert.ToBase64String(saltBytes)
    End Function

    Protected Sub txtClinicID_TextChanged(sender As Object, e As EventArgs)
        If chkRememberMe.Checked Then
            Dim cookie As New HttpCookie("ClinicID")
            cookie.Value = txtClinicID.Text
            cookie.Expires = DateTime.Now.AddYears(1)
            Response.Cookies.Add(cookie)
        End If
    End Sub

    Protected Sub AddClinic_Click(sender As Object, e As EventArgs) Handles AddClinic.Click
        Response.Redirect("AddClinic.aspx")
    End Sub
End Class
