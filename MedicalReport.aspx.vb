Imports System.Web
Imports System.Web.Script.Serialization
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Imaging
Imports System.IO
Imports ImageMagick
Public Class MedicalReport
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindDoctors()
            patientSuggestions.BackColor = System.Drawing.Color.LightGray
            medicineSuggestions.BackColor = System.Drawing.Color.LightGray

            txtExamDate.Text = DateTime.Now.ToString("yyyy-MM-dd")
            txtExamDate.ReadOnly = True
        Else
            Dim newPaidAmount As Decimal = 0
            Decimal.TryParse(hdnNewPaidAmount.Value, newPaidAmount)
            txtPaidAmount.Text = newPaidAmount.ToString("F2")
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub
    Protected Sub btnEditPlan_Click(sender As Object, e As EventArgs)
        Dim patientId As String = hdnPatientID.Value
        If Not String.IsNullOrEmpty(patientId) Then
            ' جلب أنواع العيادة من السيشن
            Dim clinicTypes As List(Of String) = TryCast(Session("ClinicTypes"), List(Of String))

            Dim targetUrl As String = String.Empty

            If clinicTypes Is Nothing OrElse clinicTypes.Count = 0 Then
                ' السيشن فارغ -> فتح صفحة الخيارات العامة
                targetUrl = "TreatmentPlans.aspx?PatientID=" & patientId
            ElseIf clinicTypes.Count = 1 Then
                ' نوع واحد فقط -> تحديد الصفحة المناسبة
                Select Case clinicTypes(0)
                    Case "1" ' أسنان
                        targetUrl = "TreatmentPlan.aspx?PatientID=" & patientId
                    Case "2" ' علاج طبيعي
                        targetUrl = "PhysioTreatmentPlan.aspx?PatientID=" & patientId
                    Case "3" ' أخرى
                        targetUrl = "PhysioTreatmentPlan.aspx?PatientID=" & patientId
                    Case Else
                        targetUrl = "TreatmentPlans.aspx?PatientID=" & patientId
                End Select
            Else
                ' أكثر من نوع -> فتح صفحة الخيارات العامة
                targetUrl = "TreatmentPlans.aspx?PatientID=" & patientId
            End If
            ' فتح الصفحة الجديدة في نافذة/تبويب جديد
            ClientScript.RegisterStartupScript(Me.GetType(), "OpenNewTab", "window.open('" & targetUrl & "', '_blank');", True)
        End If
    End Sub

    Private Sub BindDoctors()
        Dim clinicId As Integer = Convert.ToInt32(Session("ClinicID"))
        Using con As New SqlConnection(connStr)
            Dim query As String = "SELECT DoctorID, Name FROM Doctors WHERE Active=1 AND ClinicID=@ClinicID ORDER BY Name"
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                con.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                ddlDoctor.DataSource = reader
                ddlDoctor.DataTextField = "Name"
                ddlDoctor.DataValueField = "DoctorID"
                ddlDoctor.DataBind()
            End Using
        End Using
    End Sub

    Sub SaveImageAsWebP(img As Image, outputPath As String, quality As Integer)
        Using memStream As New MemoryStream()
            img.Save(memStream, Imaging.ImageFormat.Png) ' حفظ مؤقت كـ PNG
            memStream.Position = 0

            Using webp = New MagickImage(memStream)
                webp.Format = MagickFormat.WebP
                webp.Quality = quality
                webp.Write(outputPath)
            End Using
        End Using
    End Sub
    Protected Sub AddAttachment(con As SqlConnection, tran As SqlTransaction, patientID As Integer)
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim file As HttpPostedFile = fuAttachments.PostedFile
        If file Is Nothing Then Return

        Try
            Dim img As Image = Image.FromStream(file.InputStream)

            ' إنشاء مجلد الحفظ إذا لم يكن موجود
            Dim folderPath As String = Server.MapPath("~/Uploads/Clinics" & clinicID & "/Visits/")
            If Not Directory.Exists(folderPath) Then Directory.CreateDirectory(folderPath)

            Dim userID As Integer = Convert.ToInt32(Session("UserID"))
            Dim visitID As Integer = If(Session("CurrentVisitID") IsNot Nothing, Convert.ToInt32(Session("CurrentVisitID")), 0)
            Dim timestamp As String = DateTime.Now.ToString("yyyyMMddHHmmss")
            Dim fileNameWithoutExt As String = Path.GetFileNameWithoutExtension(file.FileName)
            Dim newFileName As String = $"{clinicID}_{userID}_{visitID}_{timestamp}_{fileNameWithoutExt}.webp"
            Dim newFilePath As String = Path.Combine(folderPath, newFileName)

            ' تحويل الصورة إلى WebP
            SaveImageAsWebP(img, newFilePath, 75)

            ' حفظ بيانات الصورة في قاعدة البيانات ضمن نفس الـ transaction
            Dim insertQuery As String = "
            INSERT INTO VisitAttachments
            (VisitID, FileURL, CreatedAt, PatientID, ClinicID)
            VALUES
            (@VisitID, @FileURL, GETDATE(), @PatientID, @ClinicID)"
            Using cmd As New SqlCommand(insertQuery, con, tran)
                cmd.Parameters.AddWithValue("@VisitID", visitID)
                cmd.Parameters.AddWithValue("@FileURL", "/Uploads/Clinics" & clinicID & "/Visits/" & newFileName)
                cmd.Parameters.AddWithValue("@PatientID", patientID)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                cmd.ExecuteNonQuery()
            End Using
        Catch ex As Exception
            Throw New Exception("فشل رفع الصورة: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Try
            Dim clinicID As Integer = 0
            Integer.TryParse(Session("ClinicID")?.ToString(), clinicID)

            Dim patientID As Integer = 0
            Integer.TryParse(hdnPatientID.Value, patientID)

            Dim doctorID As Integer = 0
            Integer.TryParse(ddlDoctor.SelectedValue, doctorID)

            Dim visitDate As Date = DateTime.Now
            If Not DateTime.TryParse(txtExamDate.Text, visitDate) Then visitDate = DateTime.Now

            Dim visitAmount As Decimal = 0
            Decimal.TryParse(hdnTotal.Value, visitAmount)

            Dim paidAmount As Decimal = 0
            Decimal.TryParse(hdnNewPaidAmount.Value, paidAmount)

            Dim medicines As String = hdnMedicinesList.Value
            Dim discount As Decimal = 0
            Decimal.TryParse(txtDiscount.Text, discount)

            Dim paymentMethod As String = ddlPaymentMethod.SelectedValue

            Dim insuranceCompanyID As Integer = If(String.IsNullOrEmpty(hdnInsuranceCompanyID.Value), 0, Integer.Parse(hdnInsuranceCompanyID.Value))
            Dim insuranceCardID As String = If(String.IsNullOrEmpty(hdnInsuranceCardID.Value), 0, Integer.Parse(hdnInsuranceCardID.Value))

            SaveVisitWithPayments(clinicID, patientID, doctorID, visitDate, txtMedicalReport.Text, medicines,
                                  visitAmount, discount, paidAmount, paymentMethod, insuranceCompanyID, insuranceCardID)
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "error", $"alert('حدث خطأ أثناء الحفظ: {ex.Message}');", True)
        End Try
    End Sub

    Private Sub SaveVisitWithPayments(ClinicID As Integer, PatientID As Integer, DoctorID As Integer,
                                      VisitDate As Date, MedicalReport As String, Medicines As String,
                                      VisitAmount As Decimal, Discount As Decimal, PaidAmount As Decimal,
                                      PaymentMethod As String, InsuranceCompanyID As Double,
                                      InsuranceCardID As Double)

        Using con As New SqlConnection(connStr)
            con.Open()
            Using tran = con.BeginTransaction()
                Try
                    Dim insertVisitQuery As String = "
                        INSERT INTO Visits
                        (ClinicID, PatientID, DoctorID, VisitDate, MedicalReport, Medicines, PaymentMethod,
                         VisitAmount, Discount, CreatedAt, InsuranceAmount, InsuranceCompanyID, InsuranceCardID)
                        VALUES
                        (@ClinicID, @PatientID, @DoctorID, @VisitDate, @MedicalReport, @Medicines, @PaymentMethod,
                         @VisitAmount, @Discount, GETDATE(), @InsuranceAmount, @InsuranceCompanyID, @InsuranceCardID);
                        SELECT SCOPE_IDENTITY();"

                    Using visitCmd As New SqlCommand(insertVisitQuery, con, tran)
                        visitCmd.Parameters.AddWithValue("@ClinicID", ClinicID)
                        visitCmd.Parameters.AddWithValue("@PatientID", PatientID)
                        visitCmd.Parameters.AddWithValue("@DoctorID", DoctorID)
                        visitCmd.Parameters.AddWithValue("@VisitDate", VisitDate)
                        visitCmd.Parameters.AddWithValue("@MedicalReport", MedicalReport)
                        visitCmd.Parameters.AddWithValue("@Medicines", Medicines)
                        visitCmd.Parameters.AddWithValue("@PaymentMethod", PaymentMethod)
                        visitCmd.Parameters.AddWithValue("@VisitAmount", VisitAmount)
                        visitCmd.Parameters.AddWithValue("@Discount", Discount)

                        If PaymentMethod = "insurance" Then

                            visitCmd.Parameters.AddWithValue("@InsuranceAmount", VisitAmount - PaidAmount)
                            visitCmd.Parameters.AddWithValue("@InsuranceCompanyID", InsuranceCompanyID)
                            visitCmd.Parameters.AddWithValue("@InsuranceCardID", InsuranceCardID)
                        Else

                            visitCmd.Parameters.AddWithValue("@InsuranceAmount", 0)
                            visitCmd.Parameters.AddWithValue("@InsuranceCompanyID", 0)
                            visitCmd.Parameters.AddWithValue("@InsuranceCardID", 0)
                        End If
                        Dim newVisitID As Integer = Convert.ToInt32(visitCmd.ExecuteScalar())
                        Session("CurrentVisitID") = newVisitID

                        If PaidAmount > 0 Then
                            Dim insertPaymentQuery As String = "
                                INSERT INTO Payments 
                                (PatientID, ClinicID, PaymentType, PayDate, Amount, Notes, CreatedAt, VisitID)
                                VALUES 
                                (@PatientID, @ClinicID, @PaymentType, @PayDate, @Amount, @Notes, GETDATE(), @VisitID)"

                            Using paymentCmd As New SqlCommand(insertPaymentQuery, con, tran)
                                paymentCmd.Transaction = tran
                                paymentCmd.Parameters.AddWithValue("@PatientID", PatientID)
                                paymentCmd.Parameters.AddWithValue("@ClinicID", ClinicID)
                                paymentCmd.Parameters.AddWithValue("@PaymentType", PaymentMethod)
                                paymentCmd.Parameters.AddWithValue("@PayDate", VisitDate)
                                paymentCmd.Parameters.AddWithValue("@Amount", PaidAmount)
                                paymentCmd.Parameters.AddWithValue("@Notes", "")
                                paymentCmd.Parameters.AddWithValue("@VisitID", newVisitID)
                                paymentCmd.ExecuteNonQuery()
                            End Using
                        End If
                        If PaymentMethod = "debt" Then
                            Using updatePatientCmd As New SqlCommand("UPDATE Patients SET Balance=Balance-@Balance, LastVisit=@LastVisit WHERE PatientID=@PatientID", con, tran)
                                updatePatientCmd.Parameters.AddWithValue("@Balance", VisitAmount - PaidAmount)
                                updatePatientCmd.Parameters.AddWithValue("@LastVisit", VisitDate)
                                updatePatientCmd.Parameters.AddWithValue("@PatientID", PatientID)
                                updatePatientCmd.ExecuteNonQuery()
                            End Using
                        Else
                            Using updatePatientCmd As New SqlCommand("UPDATE Patients SET LastVisit=@LastVisit WHERE PatientID=@PatientID", con, tran)
                                updatePatientCmd.Parameters.AddWithValue("@LastVisit", VisitDate)
                                updatePatientCmd.Parameters.AddWithValue("@PatientID", PatientID)
                                updatePatientCmd.ExecuteNonQuery()
                            End Using
                        End If
                    End Using
                    ' بعد حفظ الزيارة والمدفوعات
                    If fuAttachments.HasFile Then
                        AddAttachment(con, tran, PatientID)
                    End If

                    ' إذا حصل أي خطأ في AddAttachment، سيتم الوصول للـ Catch ويتم Rollback تلقائياً
                    tran.Commit()

                    Dim script As String = $"
                        alert('تم حفظ الزيارة بنجاح!');
                        document.getElementById('{txtPaidAmount.ClientID}').value = '{hdnNewPaidAmount.Value}';
                        document.getElementById('{btnSave.ClientID}').disabled = true;
                        document.getElementById('{btnSave.ClientID}').style.opacity = 0.6;
                        document.getElementById('{btnSave.ClientID}').style.cursor = 'not-allowed';
                        document.getElementById('btnWhatsApp').disabled = false;
                        document.getElementById('btnWhatsApp').style.backgroundColor = '#25D366';
                        document.getElementById('btnPrint').disabled = false;
                        document.getElementById('btnPrint').style.backgroundColor = '#0078d7';
                        if(addAttachments) {{
                            window.open('VisitAttachments.aspx', '_blank');
                        }}
                    "
                    ClientScript.RegisterStartupScript(Me.GetType(), "afterSave", script, True)
                    btnEditPlan.Enabled = True
                Catch ex As Exception
                    tran.Rollback()
                    ClientScript.RegisterStartupScript(Me.GetType(), "error", $"alert('حدث خطأ أثناء الحفظ: {ex.Message}');", True)
                End Try
            End Using
        End Using
    End Sub
End Class
