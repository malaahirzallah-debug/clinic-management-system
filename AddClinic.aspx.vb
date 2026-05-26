'Imports System.Data.SqlClient
'Imports System.Net.Mail
'Imports System.Configuration

'Public Class AddClinic
'    Inherits System.Web.UI.Page

'    ' سلسلة الاتصال
'    Dim connString As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

'    ' إيميل الإدارة لإرسال الطلبات
'    Dim adminEmail As String = "hits.est.d@gmail.com"
'    Dim smtpUser As String = "m.alaa.hirzallah@gmail.com"
'    Dim smtpPass As String = "plmdcllmtttpuoyl"

'    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
'        'Try
'        ' قراءة الحقول
'        Dim clinicName As String = txtClinicName.Text.Trim()
'            Dim address As String = txtAddress.Text.Trim()
'            Dim phone As String = txtPhone.Text.Trim()
'            Dim email As String = txtEmail.Text.Trim()
'            Dim notes As String = txtNotes.Text.Trim()

'            ' التحقق من الحقول المطلوبة
'            If clinicName = "" Or address = "" Or phone = "" Or email = "" Then
'                lblError.Text = "الرجاء تعبئة جميع الحقول المطلوبة."
'                Return
'            End If

'            Using conn As New SqlConnection(connString)
'                conn.Open()

'                ' التحقق من البريد أو الهاتف مسبقاً
'                Dim checkCmd As New SqlCommand("SELECT ClinicID FROM Clinic WHERE Email=@Email OR Phone=@Phone", conn)
'                checkCmd.Parameters.AddWithValue("@Email", email)
'                checkCmd.Parameters.AddWithValue("@Phone", phone)
'                Dim exists = checkCmd.ExecuteScalar()
'                If exists IsNot Nothing Then
'                    lblError.Text = "يوجد عيادة بنفس البريد أو رقم الهاتف بالفعل."
'                    Return
'                End If

'                ' إدخال الطلب في جدول ClinicRequests
'                Dim insertCmd As New SqlCommand("INSERT INTO ClinicRequests (ClinicName, Address, Phone, Email, Notes, CreatedAt, Status) " &
'                                                "OUTPUT INSERTED.RequestID VALUES (@ClinicName,@Address,@Phone,@Email,@Notes,GETDATE(),'Pending')", conn)
'                insertCmd.Parameters.AddWithValue("@ClinicName", clinicName)
'                insertCmd.Parameters.AddWithValue("@Address", address)
'                insertCmd.Parameters.AddWithValue("@Phone", phone)
'                insertCmd.Parameters.AddWithValue("@Email", email)
'                insertCmd.Parameters.AddWithValue("@Notes", notes)
'                Dim requestID As Integer = insertCmd.ExecuteScalar()

'                ' توليد رابط التفعيل للإدارة
'                Dim activationLink As String = Request.Url.GetLeftPart(UriPartial.Authority) & "/ActivateClinicRequest.aspx?id=" & requestID

'                ' إرسال إيميل للإدارة
'                SendAdminEmail(clinicName, address, phone, email, notes, activationLink)

'                lblMessage.Text = "تم إرسال طلب فتح العيادة بنجاح. سيتم تفعيله من قبل الإدارة."
'            End Using

'        'Catch ex As Exception
'        '    lblError.Text = "حدث خطأ أثناء إرسال الطلب: " & ex.Message
'        'End Try
'    End Sub

'    Private Sub SendAdminEmail(name As String, address As String, phone As String, email As String, notes As String, link As String)
'        'Try
'        Using mail As New MailMessage()
'                mail.From = New MailAddress(smtpUser, "HITS Clinic Dashboard")
'                mail.To.Add(adminEmail)
'                mail.Subject = "طلب فتح ملف عيادة جديدة"
'                mail.IsBodyHtml = True
'                mail.Body = $"<h3>تم تقديم طلب فتح عيادة جديدة:</h3>
'                             <b>الاسم:</b> {name}<br/>
'                             <b>العنوان:</b> {address}<br/>
'                             <b>الهاتف:</b> {phone}<br/>
'                             <b>البريد:</b> {email}<br/>
'                             <b>ملاحظات:</b> {notes}<br/>
'                             <b>رابط الموافقة:</b> <a href='{link}'>تفعيل الطلب</a>"

'                Using smtp As New SmtpClient("smtp.gmail.com", 587)
'                    smtp.Credentials = New System.Net.NetworkCredential(smtpUser, smtpPass)
'                    smtp.EnableSsl = True
'                    smtp.Timeout = 20000
'                    smtp.Send(mail)
'                End Using
'            End Using
'        'Catch ex As Exception
'        '    lblError.Text &= "<br>خطأ في إرسال إيميل الإدارة: " & ex.Message
'        'End Try
'    End Sub

'End Class



Imports System.Data.SqlClient
Imports System.Net.Mail
Imports System.Configuration

Public Class AddClinic
    Inherits System.Web.UI.Page

    Dim connString As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Dim adminEmail As String = "hits.est.d@gmail.com"

    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Dim clinicName As String = txtClinicName.Text.Trim()
        Dim address As String = txtAddress.Text.Trim()
        Dim phone As String = txtPhone.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim notes As String = txtNotes.Text.Trim()

        If clinicName = "" Or address = "" Or phone = "" Or email = "" Then
            lblError.Text = "الرجاء تعبئة جميع الحقول المطلوبة."
            Return
        End If

        Using conn As New SqlConnection(connString)
            conn.Open()

            Dim checkCmd As New SqlCommand("SELECT ClinicID FROM Clinics WHERE Email=@Email OR Phone=@Phone", conn)
            checkCmd.Parameters.AddWithValue("@Email", email)
            checkCmd.Parameters.AddWithValue("@Phone", phone)
            Dim exists = checkCmd.ExecuteScalar()
            If exists IsNot Nothing Then
                lblError.Text = "يوجد عيادة بنفس البريد أو رقم الهاتف بالفعل."
                Return
            End If

            Dim insertCmd As New SqlCommand("INSERT INTO ClinicRequests (ClinicName, Address, Phone, Email, Notes, CreatedAt, Status) " &
                                            "OUTPUT INSERTED.RequestID VALUES (@ClinicName,@Address,@Phone,@Email,@Notes,GETDATE(),'Pending')", conn)
            insertCmd.Parameters.AddWithValue("@ClinicName", clinicName)
            insertCmd.Parameters.AddWithValue("@Address", address)
            insertCmd.Parameters.AddWithValue("@Phone", phone)
            insertCmd.Parameters.AddWithValue("@Email", email)
            insertCmd.Parameters.AddWithValue("@Notes", notes)
            Dim requestID As Integer = insertCmd.ExecuteScalar()

            Dim activationLink As String = Request.Url.GetLeftPart(UriPartial.Authority) & "/ActivateClinic.aspx?id=" & requestID

            ' إرسال إيميل وهمي عبر SMTP محلي
            SendAdminEmailLocal(clinicName, address, phone, email, notes, activationLink)

            lblMessage.Text = "تم إرسال طلب فتح العيادة بنجاح (محلي)."
            ClientScript.RegisterStartupScript(Me.GetType(), "Redirect", "setTimeout(function(){ window.location='home.aspx'; }, 2000);", True)
        End Using
    End Sub

    Private Sub SendAdminEmailLocal(name As String, address As String, phone As String, email As String, notes As String, link As String)
        Using mail As New MailMessage()
            mail.From = New MailAddress("local@localhost", "HITS Clinic Dashboard")
            mail.To.Add(adminEmail)
            mail.Subject = "طلب فتح ملف عيادة جديدة"
            mail.IsBodyHtml = True
            mail.Body = $"<h3>تم تقديم طلب فتح عيادة جديدة:</h3>
                         <b>الاسم:</b> {name}<br/>
                         <b>العنوان:</b> {address}<br/>
                         <b>الهاتف:</b> {phone}<br/>
                         <b>البريد:</b> {email}<br/>
                         <b>ملاحظات:</b> {notes}<br/>
                         <b>رابط الموافقة:</b> <a href='{link}'>تفعيل الطلب</a>"

            ' استخدام SMTP محلي
            Using smtp As New SmtpClient("localhost", 25)
                smtp.DeliveryMethod = SmtpDeliveryMethod.SpecifiedPickupDirectory
                smtp.PickupDirectoryLocation = "C:\Emails" ' البريد سيتخزن هنا بدلاً من الإرسال فعلياً
                smtp.Send(mail)
            End Using
        End Using
    End Sub
End Class

