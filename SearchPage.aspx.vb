Imports System.Data
Imports System.Data.SqlClient

Public Class SearchPage
    Inherits System.Web.UI.Page

    Private ReadOnly Property ConnStr As String
        Get
            Return System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        End Get
    End Property

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindResults()
        End If
    End Sub

    ' جلب النتائج مع دعم البحث في TextBox الأربعة وترتيب حسب التصنيف
    Private Sub BindResults()
    Dim dt As New DataTable()
    Using conn As New SqlConnection(ConnStr)
        ' SQL ديناميكي حسب المدخلات
        Dim sql As String = "
SELECT 
    d.ProfileID, d.ClinicID, d.Title, d.Specialization AS DoctorSpecialization, 
    d.Qualifications, d.Experience, d.Services, d.WorkingHours,
    c.ClinicName, c.Address, c.Phone, c.Email, c.Website, c.DoctorImage, c.Classification
FROM Clinics c
LEFT JOIN ClinicDoctorProfile d ON d.ClinicID = c.ClinicID
WHERE 1=1
"

        ' شروط البحث
        If Not String.IsNullOrEmpty(txtDoctorName.Text.Trim()) Then
                sql &= " AND c.ClinicName LIKE @doctorName"
            End If
        If Not String.IsNullOrEmpty(txtLocation.Text.Trim()) Then
            sql &= " AND c.Address LIKE @location"
        End If
        If Not String.IsNullOrEmpty(txtSpecialization.Text.Trim()) Then
            sql &= " AND (d.Specialization LIKE @specialization OR c.Specialization LIKE @specialization)"
        End If
        If Not String.IsNullOrEmpty(txtPhone.Text.Trim()) Then
            sql &= " AND c.Phone LIKE @phone"
        End If

            ' ترتيب حسب Classification: 3 (Gold) → 2 (VIP) → 1 (Regular)
            sql &= " ORDER BY c.Classification DESC"

            Using cmd As New SqlCommand(sql, conn)
            If Not String.IsNullOrEmpty(txtDoctorName.Text.Trim()) Then
                cmd.Parameters.Add("@doctorName", SqlDbType.NVarChar, 100).Value = "%" & txtDoctorName.Text.Trim() & "%"
            End If
            If Not String.IsNullOrEmpty(txtLocation.Text.Trim()) Then
                cmd.Parameters.Add("@location", SqlDbType.NVarChar, 100).Value = "%" & txtLocation.Text.Trim() & "%"
            End If
            If Not String.IsNullOrEmpty(txtSpecialization.Text.Trim()) Then
                cmd.Parameters.Add("@specialization", SqlDbType.NVarChar, 100).Value = "%" & txtSpecialization.Text.Trim() & "%"
            End If
            If Not String.IsNullOrEmpty(txtPhone.Text.Trim()) Then
                cmd.Parameters.Add("@phone", SqlDbType.NVarChar, 50).Value = "%" & txtPhone.Text.Trim() & "%"
            End If

            Dim da As New SqlDataAdapter(cmd)
            da.Fill(dt)
        End Using
    End Using

    ' عرض النتائج
    resultsContainer.InnerHtml = "<ul class='staff'>"
    For Each dr As DataRow In dt.Rows
        Dim imageUrl = If(String.IsNullOrEmpty(dr("DoctorImage").ToString()), "Images/default_doctor.png", dr("DoctorImage").ToString())
        Dim doctorTitle = If(IsDBNull(dr("Title")), "لا يوجد", dr("Title").ToString())
        Dim specialization = If(IsDBNull(dr("DoctorSpecialization")), "لا يوجد", dr("DoctorSpecialization").ToString())
        Dim clinicName = If(IsDBNull(dr("ClinicName")), "لا يوجد", dr("ClinicName").ToString())

        resultsContainer.InnerHtml &= $"
<li data-url='clinicdetails.aspx?ClinicID={dr("ClinicID")}' class=''>
    <div class='picture-wrapper'>
        <div class='picture' style='background-image: url({imageUrl});'></div>
    </div>
    <div class='title'>{clinicName}</div>
    <div class='name'>{doctorTitle}</div>
    <div class='clinic'>{specialization}</div>
</li>"
    Next
    resultsContainer.InnerHtml &= "</ul>"
End Sub

    ' إعادة جلب النتائج عند تغيير أي TextBox
    Protected Sub Filters_Changed(sender As Object, e As EventArgs) _
        Handles txtDoctorName.TextChanged, txtLocation.TextChanged, txtSpecialization.TextChanged, txtPhone.TextChanged
        BindResults()
    End Sub
End Class
