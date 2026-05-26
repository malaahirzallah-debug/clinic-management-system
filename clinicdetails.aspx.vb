Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports System.Configuration

Public Class clinicdetails
    Inherits System.Web.UI.Page

    Private ReadOnly Property ConnStr As String
        Get
            Return ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        End Get
    End Property

    Private ReadOnly Property GoogleApiKey As String
        Get
            Return ConfigurationManager.AppSettings("GoogleAPIKey") ' احفظ الـ Key في Web.config
        End Get
    End Property

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim clinicId As Integer
            If Integer.TryParse(Request.QueryString("ClinicID"), clinicId) Then
                LoadClinicData(clinicId)
                LoadClinicImages(clinicId)
                LoadSocialLinks(clinicId)
                LoadDoctorProfile(clinicId)
            End If
        End If
    End Sub

    Private Sub LoadClinicData(clinicId As Integer)
        Using con As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand("SELECT TOP 1 * FROM Clinics WHERE ClinicID=@ClinicID", con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                con.Open()
                Using dr As SqlDataReader = cmd.ExecuteReader()
                    If dr.Read() Then
                        lblDoctorName.Text = SafeGetString(dr, "ClinicName")
                        lblAddress.Text = SafeGetString(dr, "Address")
                        lblPhone.Text = SafeGetString(dr, "Phone")
                        lblEmail.Text = SafeGetString(dr, "Email")
                        lblWebsite.Text = SafeGetString(dr, "Website")
                        lblNotes.Text = SafeGetString(dr, "Notes")

                        imgDoctor.ImageUrl = ResolveImagePath(SafeGetString(dr, "DoctorImage"), "~/Images/default-doctor.png")

                        Dim lat As String = SafeGetString(dr, "Latitude")
                        Dim lng As String = SafeGetString(dr, "Longitude")

                        If Not String.IsNullOrEmpty(lat) AndAlso Not String.IsNullOrEmpty(lng) Then
                            ' رابط لفتح الموقع على Google Maps
                            mapLink.HRef = $"https://www.google.com/maps/search/?api=1&query={lat},{lng}"

                            ' iframe مضمون للخريطة بدون أي API Key
                            Dim iframeHtml As String = $"<iframe width='600' height='300' frameborder='0' style='border:0;' " &
                                                       $"src='https://www.google.com/maps?q={lat},{lng}&hl=es;z=15&output=embed' allowfullscreen></iframe>"
                            ltClinicMap.Text = iframeHtml
                        End If

                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadClinicImages(clinicId As Integer)
        Using con As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand("SELECT TOP 1 ImageURL1, ImageURL2, ImageURL3, ImageURL4 FROM ClinicImages WHERE ClinicID=@ClinicID", con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                con.Open()
                Using dr As SqlDataReader = cmd.ExecuteReader()
                    If dr.Read() Then
                        Dim imageUrls As New List(Of String)
                        For i As Integer = 0 To 3
                            Dim url As String = If(dr.IsDBNull(i), "", dr(i).ToString())
                            url = ResolveImagePath(url, "~/Images/default-doctor.png")
                            imageUrls.Add(url)
                        Next

                        Dim html As New StringBuilder()
                        html.AppendLine("<div class='row g-3'>")
                        For Each imgUrl In imageUrls
                            html.AppendLine($"
                                <div class='col-6 col-md-3'>
                                    <div class='random-people__image-wrapper'>
                                        <img src='{imgUrl}' alt='Clinic Image' />
                                    </div>
                                </div>")
                        Next
                        html.AppendLine("</div>")
                        ltClinicImages.Text = html.ToString()
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadSocialLinks(clinicId As Integer)
        Using con As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand("SELECT SocialType, URL FROM ClinicSocialLinks WHERE ClinicID=@ClinicID", con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    If dt.Rows.Count > 0 Then
                        rptSocialLinks.DataSource = dt
                        rptSocialLinks.DataBind()
                    Else
                        rptSocialLinks.Visible = False
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadDoctorProfile(clinicId As Integer)
        Using con As New SqlConnection(ConnStr)
            Using cmd As New SqlCommand("SELECT TOP 1 * FROM ClinicDoctorProfile WHERE ClinicID=@ClinicID", con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                con.Open()
                Using dr As SqlDataReader = cmd.ExecuteReader()
                    If dr.Read() Then
                        Dim html As New StringBuilder()
                        html.AppendLine($"<p class='doctor-profile-text'>{SafeGetString(dr, "Title")}</p>")
                        html.AppendLine($"<p class='doctor-profile-text'>{SafeGetString(dr, "Specialization")}</p>")

                        AppendProfileSection(html, "المؤهلات العلمية", SafeGetString(dr, "Qualifications"))
                        AppendProfileSection(html, "الخبرة", SafeGetString(dr, "Experience"))
                        AppendProfileSection(html, "الخدمات المقدمة", SafeGetString(dr, "Services"))
                        AppendProfileSection(html, "أوقات الدوام", SafeGetString(dr, "WorkingHours"))

                        ltDoctorProfile.Text = html.ToString()
                    End If
                End Using
            End Using
        End Using
    End Sub

    ' ---------------------- HELPER FUNCTIONS ----------------------
    Private Function SafeGetString(dr As SqlDataReader, columnName As String) As String
        If dr.IsDBNull(dr.GetOrdinal(columnName)) Then Return String.Empty
        Return dr(columnName).ToString()
    End Function

    Private Function ResolveImagePath(path As String, defaultPath As String) As String
        If String.IsNullOrEmpty(path) Then Return ResolveUrl(defaultPath)
        If path.StartsWith("~") OrElse path.StartsWith("/") Then Return ResolveUrl(path)
        Return ResolveUrl("~/" & path)
    End Function

    Private Sub AppendProfileSection(html As StringBuilder, title As String, content As String)
        If String.IsNullOrWhiteSpace(content) Then Return
        html.AppendLine($"<p class='doctor-profile-text'><strong>{title}:</strong></p>")
        For Each line In content.Split(New String() {vbCrLf}, StringSplitOptions.RemoveEmptyEntries)
            html.AppendLine($"<p class='doctor-profile-text'>{line}</p>")
        Next
    End Sub
End Class
