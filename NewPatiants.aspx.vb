Imports System.Data.SqlClient
Public Class NewPatiants
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
        If Not IsPostBack Then
            BindChronicDiseases()
            BindAllergies()
        End If

        Dim undoID As String = Request("__EVENTTARGET")
        If undoID = "UndoPatient" Then
            Dim patientID As Integer = Convert.ToInt32(Request("__EVENTARGUMENT"))
            Using conn As New SqlConnection(connStr)
                conn.Open()

                Using cmdChronic As New SqlCommand("DELETE FROM PatientChronicDiseases WHERE PatientID=@PatientID", conn)
                    cmdChronic.Parameters.AddWithValue("@PatientID", patientID)
                    cmdChronic.ExecuteNonQuery()
                End Using

                Using cmdAllergy As New SqlCommand("DELETE FROM PatientAllergies WHERE PatientID=@PatientID", conn)
                    cmdAllergy.Parameters.AddWithValue("@PatientID", patientID)
                    cmdAllergy.ExecuteNonQuery()
                End Using

                Using cmdPatient As New SqlCommand("DELETE FROM Patients WHERE PatientID=@PatientID", conn)
                    cmdPatient.Parameters.AddWithValue("@PatientID", patientID)
                    cmdPatient.ExecuteNonQuery()
                End Using
            End Using

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "snackbar", "alert('تم التراجع عن العملية وحذف المريض وجميع بياناته المرتبطة');", True)
        End If

    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim maxPatients As Integer = Convert.ToInt32(Session("MaxPatients"))

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' تحقق من عدد المرضى الحالي
            Dim countSql As String = "SELECT COUNT(*) FROM Patients WHERE ClinicID=@ClinicID"
            Dim currentCount As Integer
            Using countCmd As New SqlCommand(countSql, conn)
                countCmd.Parameters.AddWithValue("@ClinicID", clinicID)
                currentCount = Convert.ToInt32(countCmd.ExecuteScalar())
            End Using

            If currentCount >= maxPatients Then
                ClientScript.RegisterStartupScript(Me.GetType(), "limit", "alert('لقد وصلت للحد الأقصى للمرضى (" & maxPatients & "). يرجى تجديد الاشتراك.');", True)
                Exit Sub
            End If

            ' إدخال المريض الجديد مع استرجاع ID
            Dim sql As String = "INSERT INTO Patients (ClinicID, FullName, NationalNo, Age, DOB, Gender, MaritalStatus, Nationality, Job, Phone, AltPhone, Referral, Address, Notes)
                             VALUES (@ClinicID, @FullName, @NationalNo, @Age, @DOB, @Gender, @MaritalStatus, @Nationality, @Job, @Phone, @AltPhone, @Referral, @Address, @Notes);
                             SELECT SCOPE_IDENTITY()"

            Dim newPatientID As Integer
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                cmd.Parameters.AddWithValue("@FullName", txtName.Text.Trim())
                cmd.Parameters.AddWithValue("@NationalNo", txtNationalNo.Text.Trim())
                cmd.Parameters.AddWithValue("@Age", If(String.IsNullOrEmpty(txtAge.Text), DBNull.Value, txtAge.Text))
                cmd.Parameters.AddWithValue("@DOB", If(String.IsNullOrEmpty(txtDOB.Text), DBNull.Value, txtDOB.Text))
                cmd.Parameters.AddWithValue("@Gender", ddlGender.SelectedValue)
                cmd.Parameters.AddWithValue("@MaritalStatus", ddlMarital.SelectedItem.Text)
                cmd.Parameters.AddWithValue("@Nationality", ddlNationality.SelectedItem.Text)
                cmd.Parameters.AddWithValue("@Job", txtJob.Text.Trim())
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim())
                cmd.Parameters.AddWithValue("@AltPhone", txtAltPhone.Text.Trim())
                cmd.Parameters.AddWithValue("@Referral", ddlReferral.SelectedItem.Text)
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim())
                cmd.Parameters.AddWithValue("@Notes", txtNotes.Text.Trim())

                newPatientID = Convert.ToInt32(cmd.ExecuteScalar())
            End Using

            ' حفظ الأمراض المزمنة المختارة
            For Each item As ListItem In chkChronic.Items
                If item.Selected Then
                    Dim chronicSql As String = "INSERT INTO PatientChronicDiseases (PatientID, DiseaseID, ClinicID)
                                            VALUES (@PatientID, @DiseaseID, @ClinicID)"
                    Using chronicCmd As New SqlCommand(chronicSql, conn)
                        chronicCmd.Parameters.AddWithValue("@PatientID", newPatientID)
                        chronicCmd.Parameters.AddWithValue("@DiseaseID", item.Value)
                        chronicCmd.Parameters.AddWithValue("@ClinicID", clinicID)
                        chronicCmd.ExecuteNonQuery()
                    End Using
                End If
            Next

            ' حفظ الحساسية المختارة
            For Each item As ListItem In chkAllergy.Items
                If item.Selected Then
                    Dim allergySql As String = "INSERT INTO PatientAllergies (PatientID, AllergyID, ClinicID)
                                    VALUES (@PatientID, @AllergyID, @ClinicID)"
                    Using allergyCmd As New SqlCommand(allergySql, conn)
                        allergyCmd.Parameters.AddWithValue("@PatientID", newPatientID)
                        allergyCmd.Parameters.AddWithValue("@AllergyID", item.Value)
                        allergyCmd.Parameters.AddWithValue("@ClinicID", clinicID)
                        allergyCmd.ExecuteNonQuery()
                    End Using
                End If
            Next

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "snackbar",
            $"showSnackbar('تم الحفظ بنجاح', function(){{ __doPostBack('UndoPatient','{newPatientID}'); }});", True)

            btnTreatmentPlan.Enabled = True
            btnInsurance.Enabled = True
            btnSave.Enabled = False
        End Using
    End Sub

    Protected Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Response.Redirect("HomePage.aspx")
    End Sub
    Protected Sub btnTreatmentPlan_Click(sender As Object, e As EventArgs)
        ' جلب آخر مريض مسجل في العيادة
        Dim patientID As Integer = 0
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT TOP 1 PatientID FROM Patients WHERE ClinicID=@ClinicID ORDER BY PatientID DESC"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.Add("@ClinicID", SqlDbType.Int).Value = clinicID
                conn.Open()
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing Then
                    patientID = Convert.ToInt32(result)
                End If
            End Using
        End Using

        If patientID <= 0 Then
            ClientScript.RegisterStartupScript(Me.GetType(), "noPatient", "alert('لا يوجد مرضى مسجلين بعد.');", True)
            Return
        End If

        ' جلب أنواع العيادة من السيشن
        Dim clinicTypes As List(Of String) = TryCast(Session("ClinicTypes"), List(Of String))

        Dim targetUrl As String = String.Empty

        If clinicTypes Is Nothing OrElse clinicTypes.Count = 0 Then
            ' السيشن فارغ -> فتح صفحة الخيارات العامة
            targetUrl = "TreatmentPlans.aspx?PatientID=" & patientID
        ElseIf clinicTypes.Count = 1 Then
            ' نوع واحد فقط -> تحديد الصفحة المناسبة
            Select Case clinicTypes(0)
                Case "1" ' أسنان
                    targetUrl = "TreatmentPlan.aspx?PatientID=" & patientID
                Case "2" ' علاج طبيعي
                    targetUrl = "PhysioTreatmentPlan.aspx?PatientID=" & patientID
                Case "3" ' أخرى
                    targetUrl = "PhysioTreatmentPlan.aspx?PatientID=" & patientID
                Case Else
                    targetUrl = "TreatmentPlans.aspx?PatientID=" & patientID
            End Select
        Else
            ' أكثر من نوع -> فتح صفحة الخيارات العامة
            targetUrl = "TreatmentPlans.aspx?PatientID=" & patientID
        End If

        ' فتح الصفحة الجديدة في نافذة/تبويب جديد
        ClientScript.RegisterStartupScript(Me.GetType(), "OpenNewTab", "window.open('" & targetUrl & "', '_blank');", True)
    End Sub

    Protected Sub btnInsurance_Click(sender As Object, e As EventArgs)
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim lastPatientID As Integer = 0

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT TOP 1 PatientID FROM Patients WHERE ClinicID=@ClinicID ORDER BY PatientID DESC"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                conn.Open()
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing Then
                    lastPatientID = Convert.ToInt32(result)
                End If
            End Using
        End Using

        If lastPatientID > 0 Then
            Dim url As String = "AddInsuranceCard.aspx?PatientID=" & lastPatientID
            ClientScript.RegisterStartupScript(Me.GetType(), "OpenNewTab", "window.open('" & url & "', '_blank');", True)
        Else
            ClientScript.RegisterStartupScript(Me.GetType(), "noPatient", "alert('لا يوجد مرضى مسجلين بعد.');", True)
        End If
    End Sub

    Private Sub ClearForm()
        txtName.Text = ""
        txtNationalNo.Text = ""
        txtAge.Text = ""
        txtDOB.Text = ""
        ddlGender.SelectedIndex = 0
        ddlMarital.SelectedIndex = 0
        ddlNationality.SelectedIndex = 0
        txtJob.Text = ""
        txtPhone.Text = ""
        txtAltPhone.Text = ""
        ddlReferral.SelectedIndex = 0
        txtAddress.Text = ""
        txtNotes.Text = ""
        chkChronic.ClearSelection()
        chkAllergy.ClearSelection()
    End Sub
    Private Sub BindChronicDiseases()
        chkChronic.Items.Clear()
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT DiseaseID, DiseaseName FROM ChronicDiseases WHERE ClinicID=@ClinicID ORDER BY DiseaseName"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ' إضافة كل مرض كـ CheckBox
                        Dim li As New ListItem(reader("DiseaseName").ToString(), reader("DiseaseID").ToString())
                        chkChronic.Items.Add(li)
                    End While
                End Using
                conn.Close()
            End Using
        End Using
    End Sub

    Private Sub BindAllergies()
        chkAllergy.Items.Clear()
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT AllergyID, AllergyName FROM Allergies WHERE ClinicID=@ClinicID ORDER BY AllergyName"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim li As New ListItem(reader("AllergyName").ToString(), reader("AllergyID").ToString())
                        chkAllergy.Items.Add(li)
                    End While
                End Using
                conn.Close()
            End Using
        End Using
    End Sub


    Protected Sub btnAddDisease_Click(sender As Object, e As EventArgs)
        Response.Redirect("ManageChronicDiseases.aspx?ClinicID=")
    End Sub

    Protected Sub btnAddAllergy_Click(sender As Object, e As EventArgs)
        Response.Redirect("ManageAllergies.aspx?ClinicID=")
    End Sub

End Class