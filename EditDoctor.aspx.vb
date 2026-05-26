Imports System.Data
Imports System.Data.SqlClient

Public Class EditDoctor
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If String.IsNullOrEmpty(Request.QueryString("id")) Then
                Response.Redirect("DoctorsList.aspx")
            End If

            hfDoctorID.Value = Request.QueryString("id")
            LoadDoctorData()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Private Sub LoadDoctorData()
        Dim sql As String = "SELECT * FROM Doctors WHERE DoctorID=@DoctorID AND ClinicID=@ClinicID"
        Using con As New SqlConnection(connStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@DoctorID", hfDoctorID.Value)
                cmd.Parameters.AddWithValue("@ClinicID", Convert.ToInt32(Session("ClinicID")))
                con.Open()
                Using reader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtDoctorName.Text = reader("Name").ToString()
                        txtSpecialty.Text = reader("Specialty").ToString()
                        txtPhone.Text = reader("Phone").ToString()
                        chkActive.Checked = Convert.ToBoolean(reader("Active"))
                        txtCreatedAt.Text = Convert.ToDateTime(reader("CreatedAt")).ToString("yyyy/MM/dd HH:mm")
                    Else
                        Response.Redirect("DoctorsList.aspx")
                    End If
                End Using
            End Using
        End Using
    End Sub


    Protected Sub btnUpdateDoctor_Click(sender As Object, e As EventArgs) Handles btnUpdateDoctor.Click
        Dim sql As String = "UPDATE Doctors SET Name=@Name, Specialty=@Specialty, Phone=@Phone, Active=@Active WHERE DoctorID=@DoctorID AND ClinicID=@ClinicID"
        Using con As New SqlConnection(connStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@Name", txtDoctorName.Text)
                cmd.Parameters.AddWithValue("@Specialty", txtSpecialty.Text)
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text)
                cmd.Parameters.AddWithValue("@Active", chkActive.Checked)
                cmd.Parameters.AddWithValue("@DoctorID", hfDoctorID.Value)
                cmd.Parameters.AddWithValue("@ClinicID", Convert.ToInt32(Session("ClinicID")))
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
        ClientScript.RegisterStartupScript(Me.GetType(), "updated", "alert('تم حفظ التعديلات بنجاح'); window.location='ShowAllDoctor.aspx';", True)
    End Sub

    Protected Sub btnClearDoctor_Click(sender As Object, e As EventArgs) Handles btnClearDoctor.Click
        LoadDoctorData()
    End Sub
End Class
