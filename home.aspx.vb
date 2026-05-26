Imports System.Data
Imports System.Data.SqlClient

Partial Class home
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadStaff()
        End If
    End Sub

    Private ReadOnly Property ConnStr As String
        Get
            Return System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        End Get
    End Property

    Private Sub LoadStaff()
        Dim dt As New DataTable
        Using conn As New SqlConnection(ConnStr)
            conn.Open()
            ' جلب جميع العيادات/الأطباء
            Dim cmd As New SqlCommand("SELECT TOP 100 ClinicID, ClinicName, Specialization, Classification, DoctorImage, Phone, Email, Address FROM Clinics", conn)
            Dim adapter As New SqlDataAdapter(cmd)
            adapter.Fill(dt)
        End Using

        ' تقسيم حسب التصنيف
        Dim goldList = dt.AsEnumerable().Where(Function(r) Convert.ToInt32(r("Classification")) = 3).OrderBy(Function(r) Guid.NewGuid()).ToList()
        Dim vipList = dt.AsEnumerable().Where(Function(r) Convert.ToInt32(r("Classification")) = 2).OrderBy(Function(r) Guid.NewGuid()).ToList()
        Dim normalList = dt.AsEnumerable().Where(Function(r) Convert.ToInt32(r("Classification")) = 1).OrderBy(Function(r) Guid.NewGuid()).ToList()

        ' بناء قائمة العرض (حتى 12)
        Dim displayList As New List(Of DataRow)
        If goldList.Count > 0 Then displayList.Add(goldList.First())
        displayList.AddRange(vipList.Take(12 - displayList.Count))
        displayList.AddRange(normalList.Take(12 - displayList.Count))

        ' توليد HTML ديناميكي
        Dim html As String = ""
        For Each row In displayList
            ' تحديد نوع الحدود حسب التصنيف
            Dim border As String = ""
            Select Case Convert.ToInt32(row("Classification"))
                Case 3
                    border = "border: 3px solid gold;"
                Case 2
                    border = "border: 3px solid silver;"
            End Select

            ' صورة افتراضية إذا العمود فارغ أو غير موجود
            Dim imgUrl As String = "https://t3.ftcdn.net/jpg/05/60/26/08/360_F_560260880_O1V3Qm2cNO5HWjN66mBh2NrlPHNHOUxW.jpg" ' صورة افتراضية
            If dt.Columns.Contains("DoctorImage") AndAlso Not IsDBNull(row("DoctorImage")) AndAlso row("DoctorImage").ToString() <> "" Then
                imgUrl = row("DoctorImage").ToString()
            End If

            html &= "<li style='" & border & "' " &
                "data-id='" & row("ClinicID") & "' " &
        "data-name='" & row("ClinicName") & "' " &
        "data-title='" & row("Specialization") & "' " &
        "data-img='" & imgUrl & "' " &
        "data-phone='" & If(dt.Columns.Contains("Phone") AndAlso Not IsDBNull(row("Phone")), row("Phone"), "") & "' " &
        "data-email='" & If(dt.Columns.Contains("Email") AndAlso Not IsDBNull(row("Email")), row("Email"), "") & "' " &
        "data-address='" & If(dt.Columns.Contains("Address") AndAlso Not IsDBNull(row("Address")), row("Address"), "") & "'>" &
        "<div class='picture-wrapper'>" &
        "<div class='picture' style='background-image:url(" & imgUrl & ")'></div>" &
        "</div>" &
        "<div class='name'>" & row("ClinicName") & "</div>" &
        "<div class='title'>" & row("Specialization") & "</div>" &
        "</li>"


        Next

        ' ربط الـ UL في الصفحة
        staffContainer.InnerHtml = html
    End Sub
End Class
