Imports System.Data.SqlClient
Public Class AddDoctor
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtCreatedAt.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Protected Sub btnSaveDoctor_Click(sender As Object, e As EventArgs) Handles btnSaveDoctor.Click
        ' التحقق من وجود اسم الطبيب
        If String.IsNullOrWhiteSpace(txtDoctorName.Text) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('الرجاء إدخال اسم الطبيب.');", True)
            Return
        End If

        ' استرجاع بيانات الطبيب
        Dim name As String = txtDoctorName.Text.Trim()
        Dim specialty As String = txtSpecialty.Text.Trim()
        Dim phone As String = txtPhone.Text.Trim()
        Dim active As Boolean = chkActive.Checked
        Dim createdAt As DateTime = DateTime.Now

        ' أخذ ClinicID من السيشن
        Dim clinicID As Integer
        If Session("ClinicID") IsNot Nothing Then
            clinicID = Convert.ToInt32(Session("ClinicID"))
        Else
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('لم يتم تحديد رقم العيادة.');", True)
            Return
        End If

        ' الاتصال بقاعدة البيانات
        Using conn As New SqlConnection(connStr)
            Dim query As String = "INSERT INTO Doctors (Name, Specialty, Phone, Active, CreatedAt, ClinicID) " &
                                  "VALUES (@Name, @Specialty, @Phone, @Active, @CreatedAt, @ClinicID)"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Name", name)
                cmd.Parameters.AddWithValue("@Specialty", specialty)
                cmd.Parameters.AddWithValue("@Phone", phone)
                cmd.Parameters.AddWithValue("@Active", active)
                cmd.Parameters.AddWithValue("@CreatedAt", createdAt)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using

        ' رسالة نجاح ومسح الحقول
        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('تم حفظ الطبيب بنجاح.');", True)
        txtDoctorName.Text = ""
        txtSpecialty.Text = ""
        txtPhone.Text = ""
        chkActive.Checked = True
        txtCreatedAt.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
    End Sub

    Protected Sub btnClearDoctor_Click(sender As Object, e As EventArgs) Handles btnClearDoctor.Click
        txtDoctorName.Text = ""
        txtSpecialty.Text = ""
        txtPhone.Text = ""
        chkActive.Checked = True
        txtCreatedAt.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
    End Sub
End Class