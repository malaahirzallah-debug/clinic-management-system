Imports System.Data.SqlClient

Public Class EditPatiants
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
            LoadPatientData()
        End If

        Dim target As String = Request("__EVENTTARGET")
        If target = "UndoPatient" Then
            Dim patientID As Integer = Convert.ToInt32(Request("__EVENTARGUMENT"))
            UndoPatient(patientID)
        End If
    End Sub

    Private Sub LoadPatientData()
        Dim patientID As Integer = Convert.ToInt32(Request.QueryString("PatientID"))
        If patientID <= 0 Then Exit Sub

        Using conn As New SqlConnection(connStr)
            conn.Open()
            Using cmd As New SqlCommand("SELECT * FROM Patients WHERE PatientID=@PatientID", conn)
                cmd.Parameters.AddWithValue("@PatientID", patientID)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtName.Text = reader("FullName").ToString()
                        txtNationalNo.Text = reader("NationalNo").ToString()
                        txtAge.Text = If(IsDBNull(reader("Age")), "", reader("Age").ToString())
                        txtDOB.Text = If(IsDBNull(reader("DOB")), "", Convert.ToDateTime(reader("DOB")).ToString("yyyy-MM-dd"))
                        ddlGender.SelectedValue = reader("Gender").ToString()
                        ddlMarital.SelectedItem.Text = reader("MaritalStatus").ToString()
                        ddlNationality.SelectedItem.Text = reader("Nationality").ToString()
                        txtJob.Text = reader("Job").ToString()
                        txtPhone.Text = reader("Phone").ToString()
                        txtAltPhone.Text = reader("AltPhone").ToString()
                        ddlReferral.SelectedItem.Text = reader("Referral").ToString()
                        txtAddress.Text = reader("Address").ToString()
                        txtNotes.Text = reader("Notes").ToString()
                    End If
                End Using
            End Using

            Using cmd As New SqlCommand("SELECT DiseaseID FROM PatientChronicDiseases WHERE PatientID=@PatientID", conn)
                cmd.Parameters.AddWithValue("@PatientID", patientID)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    Dim selectedIds As New List(Of String)
                    While reader.Read()
                        selectedIds.Add(reader("DiseaseID").ToString())
                    End While
                    For Each li As ListItem In chkChronic.Items
                        li.Selected = selectedIds.Contains(li.Value)
                    Next
                End Using
            End Using

            Using cmd As New SqlCommand("SELECT AllergyID FROM PatientAllergies WHERE PatientID=@PatientID", conn)
                cmd.Parameters.AddWithValue("@PatientID", patientID)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    Dim selectedIds As New List(Of String)
                    While reader.Read()
                        selectedIds.Add(reader("AllergyID").ToString())
                    End While
                    For Each li As ListItem In chkAllergy.Items
                        li.Selected = selectedIds.Contains(li.Value)
                    Next
                End Using
            End Using
        End Using
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        Dim patientID As Integer = Convert.ToInt32(Request.QueryString("PatientID"))
        If patientID <= 0 Then Exit Sub
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            conn.Open()

            Using backupCmd As New SqlCommand("
                INSERT INTO PatientBackup (PatientID, FullName, NationalNo, Age, DOB, Gender, MaritalStatus, Nationality, Job, Phone, AltPhone, Referral, Address, Notes)
                SELECT PatientID, FullName, NationalNo, Age, DOB, Gender, MaritalStatus, Nationality, Job, Phone, AltPhone, Referral, Address, Notes
                FROM Patients WHERE PatientID=@PatientID;

                INSERT INTO PatientChronicDiseasesBackup (PatientID, DiseaseID, ClinicID)
SELECT PatientID, DiseaseID, ClinicID FROM PatientChronicDiseases WHERE PatientID=@PatientID;

INSERT INTO PatientAllergiesBackup (PatientID, AllergyID, ClinicID)
SELECT PatientID, AllergyID, ClinicID FROM PatientAllergies WHERE PatientID=@PatientID;

            ", conn)
                backupCmd.Parameters.AddWithValue("@PatientID", patientID)
                backupCmd.ExecuteNonQuery()
            End Using

            Dim sql As String = "
                UPDATE Patients SET
                    FullName=@FullName,
                    NationalNo=@NationalNo,
                    Age=@Age,
                    DOB=@DOB,
                    Gender=@Gender,
                    MaritalStatus=@MaritalStatus,
                    Nationality=@Nationality,
                    Job=@Job,
                    Phone=@Phone,
                    AltPhone=@AltPhone,
                    Referral=@Referral,
                    Address=@Address,
                    Notes=@Notes
                WHERE PatientID=@PatientID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@PatientID", patientID)
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
                cmd.ExecuteNonQuery()
            End Using

            UpdateCheckLists(conn, patientID, clinicID)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "snackbar",
                $"showSnackbar('تم تحديث البيانات بنجاح', function(){{ undoLastSave({patientID}); }});", True)
        End Using
    End Sub

    Private Sub UpdateCheckLists(conn As SqlConnection, patientID As Integer, clinicID As Integer)
        Using delCmd As New SqlCommand("DELETE FROM PatientChronicDiseases WHERE PatientID=@PatientID", conn)
            delCmd.Parameters.AddWithValue("@PatientID", patientID)
            delCmd.ExecuteNonQuery()
        End Using
        For Each item As ListItem In chkChronic.Items
            If item.Selected Then
                Using cmd As New SqlCommand("INSERT INTO PatientChronicDiseases (PatientID, DiseaseID, ClinicID) VALUES (@PatientID,@DiseaseID,@ClinicID)", conn)
                    cmd.Parameters.AddWithValue("@PatientID", patientID)
                    cmd.Parameters.AddWithValue("@DiseaseID", item.Value)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                    cmd.ExecuteNonQuery()
                End Using
            End If
        Next

        Using delCmd As New SqlCommand("DELETE FROM PatientAllergies WHERE PatientID=@PatientID", conn)
            delCmd.Parameters.AddWithValue("@PatientID", patientID)
            delCmd.ExecuteNonQuery()
        End Using
        For Each item As ListItem In chkAllergy.Items
            If item.Selected Then
                Using cmd As New SqlCommand("INSERT INTO PatientAllergies (PatientID, AllergyID, ClinicID) VALUES (@PatientID,@AllergyID,@ClinicID)", conn)
                    cmd.Parameters.AddWithValue("@PatientID", patientID)
                    cmd.Parameters.AddWithValue("@AllergyID", item.Value)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                    cmd.ExecuteNonQuery()
                End Using
            End If
        Next
    End Sub

    Private Sub UndoPatient(patientID As Integer)
        Using conn As New SqlConnection(connStr)
            Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
            conn.Open()

            Using cmd As New SqlCommand("
                UPDATE p SET 
                    p.FullName = b.FullName,
                    p.NationalNo = b.NationalNo,
                    p.Age = b.Age,
                    p.DOB = b.DOB,
                    p.Gender = b.Gender,
                    p.MaritalStatus = b.MaritalStatus,
                    p.Nationality = b.Nationality,
                    p.Job = b.Job,
                    p.Phone = b.Phone,
                    p.AltPhone = b.AltPhone,
                    p.Referral = b.Referral,
                    p.Address = b.Address,
                    p.Notes = b.Notes
                FROM Patients p
                INNER JOIN (SELECT TOP 1 * FROM PatientBackup WHERE PatientID=@PatientID ORDER BY BackupDate DESC) b
                ON p.PatientID = b.PatientID;

                DELETE FROM PatientChronicDiseases WHERE PatientID=@PatientID;
    INSERT INTO PatientChronicDiseases(PatientID, DiseaseID, ClinicID)
    SELECT PatientID, DiseaseID, @ClinicID FROM PatientChronicDiseasesBackup WHERE PatientID=@PatientID;

    DELETE FROM PatientAllergies WHERE PatientID=@PatientID;
    INSERT INTO PatientAllergies(PatientID, AllergyID, ClinicID)
    SELECT PatientID, AllergyID, @ClinicID FROM PatientAllergiesBackup WHERE PatientID=@PatientID;
", conn)
                cmd.Parameters.AddWithValue("@PatientID", patientID)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                cmd.ExecuteNonQuery()
            End Using

            LoadPatientData()
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "snackbar",
                                                $"showSnackbar('تم التراجع عن آخر تعديل بنجاح');", True)
        End Using
    End Sub
    Private Sub BindChronicDiseases()
        chkChronic.Items.Clear()
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Using conn As New SqlConnection(connStr)
            conn.Open()
            Using cmd As New SqlCommand("SELECT DiseaseID, DiseaseName FROM ChronicDiseases WHERE ClinicID=@ClinicID ORDER BY DiseaseName", conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        chkChronic.Items.Add(New ListItem(reader("DiseaseName").ToString(), reader("DiseaseID").ToString()))
                    End While
                End Using
            End Using
        End Using
    End Sub
    Private Sub BindAllergies()
        chkAllergy.Items.Clear()
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Using conn As New SqlConnection(connStr)
            conn.Open()
            Using cmd As New SqlCommand("SELECT AllergyID, AllergyName FROM Allergies WHERE ClinicID=@ClinicID ORDER BY AllergyName", conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        chkAllergy.Items.Add(New ListItem(reader("AllergyName").ToString(), reader("AllergyID").ToString()))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Protected Sub btnAddDisease_Click(sender As Object, e As EventArgs)
        Response.Redirect("ManageChronicDiseases.aspx")
    End Sub

    Protected Sub btnAddAllergy_Click(sender As Object, e As EventArgs)
        Response.Redirect("ManageAllergies.aspx")
    End Sub
    Protected Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Response.Redirect("HomePage.aspx")
    End Sub
End Class
