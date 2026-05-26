Imports System.IO
Imports ImageMagick
Imports System.Data.SqlClient

Partial Class PersonalPage
    Inherits System.Web.UI.Page

    Private ReadOnly Property ConnStr As String
        Get
            Return System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        End Get
    End Property

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim clinicId As Integer = 0
            If Session("ClinicID") IsNot Nothing Then
                Integer.TryParse(Session("ClinicID").ToString(), clinicId)
            End If
            If clinicId = 0 Then Exit Sub

            Using conn As New SqlConnection(ConnStr)
                conn.Open()

                ' جلب الصورة الكبيرة (DoctorImage)
                Dim sqlDoctorImg As String = "SELECT DoctorImage FROM dbo.Clinics WHERE ClinicID=@clinicId"
                Using cmd As New SqlCommand(sqlDoctorImg, conn)
                    cmd.Parameters.AddWithValue("@clinicId", clinicId)
                    Dim doctorImg As Object = cmd.ExecuteScalar()
                    If doctorImg IsNot Nothing AndAlso doctorImg IsNot DBNull.Value Then
                        img5.Src = ResolveUrl(doctorImg.ToString())
                    End If
                End Using

                ' جلب الصور 1-4
                Dim sqlImgs As String = "SELECT TOP 1 ImageURL1, ImageURL2, ImageURL3, ImageURL4 FROM dbo.ClinicImages WHERE ClinicID=@clinicId"
                Using cmd As New SqlCommand(sqlImgs, conn)
                    cmd.Parameters.AddWithValue("@clinicId", clinicId)
                    Using rdr As SqlDataReader = cmd.ExecuteReader()
                        If rdr.Read() Then
                            If Not rdr.IsDBNull(0) Then img1.Src = ResolveUrl(rdr.GetString(0))
                            If Not rdr.IsDBNull(1) Then img2.Src = ResolveUrl(rdr.GetString(1))
                            If Not rdr.IsDBNull(2) Then img3.Src = ResolveUrl(rdr.GetString(2))
                            If Not rdr.IsDBNull(3) Then img4.Src = ResolveUrl(rdr.GetString(3))
                        End If
                    End Using
                End Using
                conn.Close()
            End Using
            LoadSocialLinks(clinicId)
        End If
    End Sub

    Protected Sub ShowPage_Click(sender As Object, e As EventArgs)
        Dim clinicId As Integer = 0
        If Session("ClinicID") IsNot Nothing Then
            Integer.TryParse(Session("ClinicID").ToString(), clinicId)
        End If
        Response.Redirect("clinicdetails.aspx?ClinicID=" & clinicId)
    End Sub
    Protected Sub btnSaveImages_Click(sender As Object, e As EventArgs)
        Dim clinicId As Integer = 0
        If Session("ClinicID") IsNot Nothing Then
            Integer.TryParse(Session("ClinicID").ToString(), clinicId)
        End If
        If clinicId = 0 Then Exit Sub

        Dim uploadFolder As String = Server.MapPath("Uploads/Clinics" & clinicId & "/")
        If Not Directory.Exists(uploadFolder) Then Directory.CreateDirectory(uploadFolder)

        Dim uploads As FileUpload() = {FileUpload1, FileUpload2, FileUpload3, FileUpload4}
        Dim imgFields As String() = {"ImageURL1", "ImageURL2", "ImageURL3", "ImageURL4"}
        Dim imgPaths(3) As String

        Using conn As New SqlConnection(ConnStr)
            conn.Open()

            ' جلب الصور الحالية من قاعدة البيانات لحذفها إذا لزم الأمر
            Dim oldImages(3) As String
            Dim sqlOld As String = "SELECT ImageURL1, ImageURL2, ImageURL3, ImageURL4 FROM dbo.ClinicImages WHERE ClinicID=@clinicId"
            Using cmdOld As New SqlCommand(sqlOld, conn)
                cmdOld.Parameters.AddWithValue("@clinicId", clinicId)
                Using rdr As SqlDataReader = cmdOld.ExecuteReader()
                    If rdr.Read() Then
                        For i As Integer = 0 To 3
                            oldImages(i) = If(rdr.IsDBNull(i), Nothing, rdr.GetString(i))
                        Next
                    End If
                End Using
            End Using

            ' معالجة الصور 1-4
            For i As Integer = 0 To 3
                Dim fileUpload As FileUpload = uploads(i)
                If fileUpload IsNot Nothing AndAlso fileUpload.HasFile Then
                    ' حذف الصورة القديمة إذا وجدت
                    If Not String.IsNullOrEmpty(oldImages(i)) Then
                        Dim oldFilePath As String = Server.MapPath(oldImages(i))
                        If File.Exists(oldFilePath) Then File.Delete(oldFilePath)
                    End If

                    Dim newFileName As String = $"Clinic_{clinicId}_img{i + 1}_{DateTime.Now:yyyyMMddHHmmss}.webp"
                    Dim newPath As String = Path.Combine(uploadFolder, newFileName)
                    Using img As New MagickImage(fileUpload.FileBytes)
                        img.Format = MagickFormat.WebP
                        img.Write(newPath)
                    End Using
                    imgPaths(i) = "Uploads/Clinics" & clinicId & "/" & newFileName
                Else
                    imgPaths(i) = Nothing
                End If
            Next

            ' تحقق إذا الصف موجود
            Dim sqlCheck As String = "SELECT COUNT(*) FROM dbo.ClinicImages WHERE ClinicID=@clinicId"
            Dim exists As Boolean
            Using cmdCheck As New SqlCommand(sqlCheck, conn)
                cmdCheck.Parameters.AddWithValue("@clinicId", clinicId)
                exists = CInt(cmdCheck.ExecuteScalar()) > 0
            End Using

            If exists Then
                Dim updateFields As New List(Of String)
                For i As Integer = 0 To 3
                    If Not String.IsNullOrEmpty(imgPaths(i)) Then updateFields.Add($"{imgFields(i)}=@img{i}")
                Next
                If updateFields.Count > 0 Then
                    Dim sqlUpdate As String = $"UPDATE dbo.ClinicImages SET {String.Join(",", updateFields)} WHERE ClinicID=@clinicId"
                    Using cmd As New SqlCommand(sqlUpdate, conn)
                        cmd.Parameters.AddWithValue("@clinicId", clinicId)
                        For i As Integer = 0 To 3
                            If Not String.IsNullOrEmpty(imgPaths(i)) Then cmd.Parameters.AddWithValue($"@img{i}", imgPaths(i))
                        Next
                        cmd.ExecuteNonQuery()
                    End Using
                End If
            Else
                ' Insert جديد
                Dim sqlInsert As String = "INSERT INTO dbo.ClinicImages (ClinicID, ImageURL1, ImageURL2, ImageURL3, ImageURL4) VALUES (@clinicId, @img0, @img1, @img2, @img3)"
                Using cmd As New SqlCommand(sqlInsert, conn)
                    cmd.Parameters.AddWithValue("@clinicId", clinicId)
                    For i As Integer = 0 To 3
                        cmd.Parameters.AddWithValue($"@img{i}", If(imgPaths(i), DBNull.Value))
                    Next
                    cmd.ExecuteNonQuery()
                End Using
            End If

            ' معالجة الصورة 5
            Dim img5Path As String = Nothing
            If FileUpload5 IsNot Nothing AndAlso FileUpload5.HasFile Then
                ' حذف الصورة القديمة إذا وجدت
                Dim sqlOld5 As String = "SELECT DoctorImage FROM dbo.Clinics WHERE ClinicID=@clinicId"
                Using cmdOld5 As New SqlCommand(sqlOld5, conn)
                    cmdOld5.Parameters.AddWithValue("@clinicId", clinicId)
                    Dim oldImg5 As Object = cmdOld5.ExecuteScalar()
                    If oldImg5 IsNot Nothing AndAlso oldImg5 IsNot DBNull.Value Then
                        Dim oldFile5 As String = Server.MapPath(oldImg5.ToString())
                        If File.Exists(oldFile5) Then File.Delete(oldFile5)
                    End If
                End Using

                Dim newFileName As String = $"Clinic_{clinicId}_img5_{DateTime.Now:yyyyMMddHHmmss}.webp"
                Dim newPath As String = Path.Combine(uploadFolder, newFileName)
                Using img As New MagickImage(FileUpload5.FileBytes)
                    img.Format = MagickFormat.WebP
                    img.Write(newPath)
                End Using
                img5Path = "Uploads/Clinics" & clinicId & "/" & newFileName

                ' تحديث قاعدة البيانات
                Dim sql5 As String = "UPDATE dbo.Clinics SET DoctorImage=@img5 WHERE ClinicID=@clinicId"
                Using cmd5 As New SqlCommand(sql5, conn)
                    cmd5.Parameters.AddWithValue("@clinicId", clinicId)
                    cmd5.Parameters.AddWithValue("@img5", img5Path)
                    cmd5.ExecuteNonQuery()
                End Using
            End If

            conn.Close()
        End Using

        SaveOrUpdateLink(clinicId, "facebook", txtFacebook.Text)
        SaveOrUpdateLink(clinicId, "instagram", txtInstagram.Text)
        SaveOrUpdateLink(clinicId, "whatsapp", txtWhatsApp.Text)
        SaveOrUpdateLink(clinicId, "linkedin", txtLinkedIn.Text)
        SaveOrUpdateLink(clinicId, "twitter", txtTwitter.Text)
        SaveOrUpdateLink(clinicId, "youtube", txtYouTube.Text)
        SaveOrUpdateLink(clinicId, "telegram", txtTelegram.Text)
        SaveOrUpdateLink(clinicId, "snapchat", txtSnapchat.Text)

        LoadSocialLinks(clinicId)

        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('تم حفظ الصور بنجاح!');", True)
    End Sub

    Private Sub LoadSocialLinks(ByVal clinicId As Integer)
        Using con As New SqlConnection(ConnStr)
            con.Open()
            Dim cmd As New SqlCommand("SELECT SocialType, URL FROM ClinicSocialLinks WHERE ClinicID=@ClinicID", con)
            cmd.Parameters.AddWithValue("@ClinicID", clinicId)
            Dim rdr As SqlDataReader = cmd.ExecuteReader()

            ' تفريغ النصوص أولاً
            txtFacebook.Text = ""
            txtInstagram.Text = ""
            txtWhatsApp.Text = ""
            txtLinkedIn.Text = ""
            txtTwitter.Text = ""
            txtYouTube.Text = ""
            txtTelegram.Text = ""
            txtSnapchat.Text = ""

            While rdr.Read()
                Dim socialType As String = rdr("SocialType").ToString().ToLower()
                Dim url As String = rdr("URL").ToString()

                Select Case socialType
                    Case "facebook" : txtFacebook.Text = url
                    Case "instagram" : txtInstagram.Text = url
                    Case "whatsapp" : txtWhatsApp.Text = url
                    Case "linkedin" : txtLinkedIn.Text = url
                    Case "twitter", "x-twitter" : txtTwitter.Text = url
                    Case "youtube" : txtYouTube.Text = url
                    Case "telegram" : txtTelegram.Text = url
                    Case "snapchat" : txtSnapchat.Text = url
                End Select
            End While
        End Using

        Using conn As New SqlConnection(ConnStr)
            conn.Open()

            ' ====== جلب بيانات العيادة ======
            Dim sqlClinic As String = "SELECT ClinicName, Address, Phone, Email, Website, Notes FROM dbo.Clinics WHERE ClinicID=@ClinicID"
            Using cmd As New SqlCommand(sqlClinic, conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    If rdr.Read() Then
                        lblClinicName.Text = If(rdr("ClinicName") IsNot DBNull.Value, rdr("ClinicName").ToString(), "")
                        txtAddress.Text = If(rdr("Address") IsNot DBNull.Value, rdr("Address").ToString(), "")
                        txtPhone.Text = If(rdr("Phone") IsNot DBNull.Value, rdr("Phone").ToString(), "")
                        txtEmail.Text = If(rdr("Email") IsNot DBNull.Value, rdr("Email").ToString(), "")
                        txtWebsite.Text = If(rdr("Website") IsNot DBNull.Value, rdr("Website").ToString(), "")
                        lblNote.Text = If(rdr("Notes") IsNot DBNull.Value, rdr("Notes").ToString(), "")
                    End If
                End Using
            End Using

            ' ====== جلب بيانات الطبيب ======
            Dim sqlDoctor As String = "SELECT Title, Specialization, Qualifications, Experience, Services, WorkingHours FROM dbo.ClinicDoctorProfile WHERE ClinicID=@ClinicID"
            Using cmd As New SqlCommand(sqlDoctor, conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    If rdr.Read() Then
                        txtTitle.Text = If(rdr("Title") IsNot DBNull.Value, rdr("Title").ToString(), "")
                        txtSpecialization.Text = If(rdr("Specialization") IsNot DBNull.Value, rdr("Specialization").ToString(), "")
                        txtQualifications.Text = If(rdr("Qualifications") IsNot DBNull.Value, rdr("Qualifications").ToString(), "")
                        txtExperience.Text = If(rdr("Experience") IsNot DBNull.Value, rdr("Experience").ToString(), "")
                        txtServices.Text = If(rdr("Services") IsNot DBNull.Value, rdr("Services").ToString(), "")
                        txtWorkingHours.Text = If(rdr("WorkingHours") IsNot DBNull.Value, rdr("WorkingHours").ToString(), "")
                    End If
                End Using
            End Using
            ' جلب الإحداثيات
            Dim sqlCoords As String = "SELECT Latitude, Longitude FROM dbo.Clinics WHERE ClinicID=@ClinicID"
            Using cmd As New SqlCommand(sqlCoords, conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    If rdr.Read() Then
                        txtLatitude.Text = If(rdr("Latitude") IsNot DBNull.Value, rdr("Latitude").ToString(), "")
                        txtLongitude.Text = If(rdr("Longitude") IsNot DBNull.Value, rdr("Longitude").ToString(), "")
                    End If
                End Using
            End Using
            conn.Close()
        End Using
    End Sub
    Private Sub SaveOrUpdateLink(clinicId As Integer, socialType As String, url As String)
        Using con As New SqlConnection(ConnStr)
            con.Open()

            ' هل الرابط موجود مسبقاً؟
            Dim checkCmd As New SqlCommand("SELECT COUNT(*) FROM ClinicSocialLinks WHERE ClinicID=@ClinicID AND SocialType=@SocialType", con)
            checkCmd.Parameters.AddWithValue("@ClinicID", clinicId)
            checkCmd.Parameters.AddWithValue("@SocialType", socialType)

            Dim exists As Integer = Convert.ToInt32(checkCmd.ExecuteScalar())

            If String.IsNullOrWhiteSpace(url) Then
                ' إذا النص فاضي نحذف الرابط
                Dim delCmd As New SqlCommand("DELETE FROM ClinicSocialLinks WHERE ClinicID=@ClinicID AND SocialType=@SocialType", con)
                delCmd.Parameters.AddWithValue("@ClinicID", clinicId)
                delCmd.Parameters.AddWithValue("@SocialType", socialType)
                delCmd.ExecuteNonQuery()
            ElseIf exists > 0 Then
                ' تعديل الرابط
                Dim updCmd As New SqlCommand("UPDATE ClinicSocialLinks SET URL=@URL WHERE ClinicID=@ClinicID AND SocialType=@SocialType", con)
                updCmd.Parameters.AddWithValue("@URL", url)
                updCmd.Parameters.AddWithValue("@ClinicID", clinicId)
                updCmd.Parameters.AddWithValue("@SocialType", socialType)
                updCmd.ExecuteNonQuery()
            Else
                ' إضافة جديد
                Dim insCmd As New SqlCommand("INSERT INTO ClinicSocialLinks (ClinicID, SocialType, URL, CreatedAt) VALUES (@ClinicID, @SocialType, @URL, GETDATE())", con)
                insCmd.Parameters.AddWithValue("@ClinicID", clinicId)
                insCmd.Parameters.AddWithValue("@SocialType", socialType)
                insCmd.Parameters.AddWithValue("@URL", url)
                insCmd.ExecuteNonQuery()
            End If
        End Using
        Using conn As New SqlConnection(ConnStr)
            conn.Open()

            ' ====== حفظ/تعديل بيانات العيادة ======
            Dim sqlClinicCheck As String = "SELECT COUNT(*) FROM dbo.Clinics WHERE ClinicID=@ClinicID"
            Dim existsClinic As Boolean
            Using cmdCheck As New SqlCommand(sqlClinicCheck, conn)
                cmdCheck.Parameters.AddWithValue("@ClinicID", clinicId)
                existsClinic = CInt(cmdCheck.ExecuteScalar()) > 0
            End Using

            If existsClinic Then
                Dim sqlUpdateClinic As String = "UPDATE dbo.Clinics SET ClinicName=@ClinicName, Address=@Address, Phone=@Phone, Email=@Email, Website=@Website, Notes=@Notes WHERE ClinicID=@ClinicID"
                Using cmd As New SqlCommand(sqlUpdateClinic, conn)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@ClinicName", lblClinicName.Text)
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text)
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text)
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text)
                    cmd.Parameters.AddWithValue("@Website", txtWebsite.Text)
                    cmd.Parameters.AddWithValue("@Notes", lblNote.Text)
                    cmd.ExecuteNonQuery()
                End Using
            Else
                Dim sqlInsertClinic As String = "INSERT INTO dbo.Clinics (ClinicID, ClinicName, Address, Phone, Email, Website, Notes, CreatedAt) VALUES (@ClinicID,@ClinicName,@Address,@Phone,@Email,@Website,@Notes,GETDATE())"
                Using cmd As New SqlCommand(sqlInsertClinic, conn)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@ClinicName", lblClinicName.Text)
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text)
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text)
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text)
                    cmd.Parameters.AddWithValue("@Website", txtWebsite.Text)
                    cmd.Parameters.AddWithValue("@Notes", lblNote.Text)
                    cmd.ExecuteNonQuery()
                End Using
            End If

            ' ====== حفظ/تعديل بيانات الطبيب ======
            Dim sqlDoctorCheck As String = "SELECT COUNT(*) FROM dbo.ClinicDoctorProfile WHERE ClinicID=@ClinicID"
            Dim existsDoctor As Boolean
            Using cmdCheck As New SqlCommand(sqlDoctorCheck, conn)
                cmdCheck.Parameters.AddWithValue("@ClinicID", clinicId)
                existsDoctor = CInt(cmdCheck.ExecuteScalar()) > 0
            End Using

            If existsDoctor Then
                Dim sqlUpdateDoctor As String = "UPDATE dbo.ClinicDoctorProfile SET Title=@Title, Specialization=@Specialization, Qualifications=@Qualifications, Experience=@Experience, Services=@Services, WorkingHours=@WorkingHours WHERE ClinicID=@ClinicID"
                Using cmd As New SqlCommand(sqlUpdateDoctor, conn)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text)
                    cmd.Parameters.AddWithValue("@Specialization", txtSpecialization.Text)
                    cmd.Parameters.AddWithValue("@Qualifications", txtQualifications.Text)
                    cmd.Parameters.AddWithValue("@Experience", txtExperience.Text)
                    cmd.Parameters.AddWithValue("@Services", txtServices.Text)
                    cmd.Parameters.AddWithValue("@WorkingHours", txtWorkingHours.Text)
                    cmd.ExecuteNonQuery()
                End Using
            Else
                Dim sqlInsertDoctor As String = "INSERT INTO dbo.ClinicDoctorProfile (ClinicID, Title, Specialization, Qualifications, Experience, Services, WorkingHours, CreatedAt) VALUES (@ClinicID,@Title,@Specialization,@Qualifications,@Experience,@Services,@WorkingHours,GETDATE())"
                Using cmd As New SqlCommand(sqlInsertDoctor, conn)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text)
                    cmd.Parameters.AddWithValue("@Specialization", txtSpecialization.Text)
                    cmd.Parameters.AddWithValue("@Qualifications", txtQualifications.Text)
                    cmd.Parameters.AddWithValue("@Experience", txtExperience.Text)
                    cmd.Parameters.AddWithValue("@Services", txtServices.Text)
                    cmd.Parameters.AddWithValue("@WorkingHours", txtWorkingHours.Text)
                    cmd.ExecuteNonQuery()
                End Using
            End If

            ' تحديث الإحداثيات في جدول Clinics

            Dim sqlUpdate As String = "UPDATE dbo.Clinics SET Latitude=@Latitude, Longitude=@Longitude WHERE ClinicID=@ClinicID"
            Using cmd As New SqlCommand(sqlUpdate, conn)
                cmd.Parameters.AddWithValue("@Latitude", txtLatitude.Text)
                cmd.Parameters.AddWithValue("@Longitude", txtLongitude.Text)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                cmd.ExecuteNonQuery()
            End Using

            conn.Close()
        End Using
        Response.Redirect(Request.RawUrl)
    End Sub
End Class
