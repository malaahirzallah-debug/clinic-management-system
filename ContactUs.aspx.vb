Imports System.Net.Mail

Public Class ContactUs
    Inherits System.Web.UI.Page

    Protected Sub btnSend_Click(sender As Object, e As EventArgs)
        Try
            Dim name As String = txtName.Text.Trim()
            Dim email As String = txtEmail.Text.Trim()
            Dim phone As String = txtPhone.Text.Trim()
            Dim message As String = txtMessage.Text.Trim()

            ' تحقق من الحقول المطلوبة
            If name = "" Or email = "" Or message = "" Then
                lblMessage.Text = "يرجى ملء جميع الحقول المطلوبة."
                lblMessage.ForeColor = Drawing.Color.Red
                Return
            End If

            ' إرسال البريد الإلكتروني
            Dim mail As New MailMessage()
            mail.From = New MailAddress("noreply@clinic.com")
            mail.To.Add("info@clinic.com") ' البريد الذي يستقبل الرسائل
            mail.Subject = "رسالة من صفحة التواصل"
            mail.Body = $"الاسم: {name}" & vbCrLf & $"البريد: {email}" & vbCrLf & $"الهاتف: {phone}" & vbCrLf & $"الرسالة: {message}"

            Dim smtp As New SmtpClient("smtp.yourserver.com") ' استبدل بالسيرفر الفعلي
            smtp.Credentials = New System.Net.NetworkCredential("noreply@clinic.com", "password")
            smtp.EnableSsl = True
            smtp.Send(mail)

            lblMessage.Text = "تم إرسال الرسالة بنجاح!"
            lblMessage.ForeColor = Drawing.Color.Green

            ' مسح الحقول
            txtName.Text = ""
            txtEmail.Text = ""
            txtPhone.Text = ""
            txtMessage.Text = ""

        Catch ex As Exception
            lblMessage.Text = "حدث خطأ أثناء إرسال الرسالة، يرجى المحاولة لاحقًا."
            lblMessage.ForeColor = Drawing.Color.Red
        End Try
    End Sub
End Class
