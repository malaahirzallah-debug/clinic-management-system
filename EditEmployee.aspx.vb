Imports System.Data.SqlClient
Public Class EditEmployee
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Dim employeeID As Integer

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If

        If Not IsPostBack Then
            ' جلب EmployeeID من الاستعلام
            If String.IsNullOrEmpty(Request.QueryString("EmployeeID")) Then
                Response.Redirect("EmployeesList.aspx")
                Return
            End If

            employeeID = Convert.ToInt32(Request.QueryString("EmployeeID"))
            LoadEmployee(employeeID)
        End If
    End Sub

    Private Sub LoadEmployee(empID As Integer)
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT * FROM Employees WHERE EmployeeID=@EmployeeID AND ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@EmployeeID", empID)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                conn.Open()
                Using reader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtEmployeeName.Text = reader("FullName").ToString()
                        txtPhone.Text = reader("Phone").ToString()
                        txtAge.Text = reader("Age").ToString()
                        txtAddress.Text = reader("Address").ToString()
                        txtStartDate.Text = If(reader("StartDate") IsNot DBNull.Value, Convert.ToDateTime(reader("StartDate")).ToString("yyyy-MM-dd"), "")
                        txtSocialNumber.Text = reader("SocialNumber").ToString()
                        Dim socialStatus = reader("SocialStatus").ToString()
                        rbSocialRegistered.Checked = (socialStatus = "مسجل")
                        rbSocialUnregistered.Checked = (socialStatus = "غير مسجل")
                        txtSocialNumber.Enabled = rbSocialRegistered.Checked
                    End If
                End Using
                conn.Close()
            End Using
        End Using
    End Sub

    Protected Sub rbSocialStatus_CheckedChanged(sender As Object, e As EventArgs)
        txtSocialNumber.Enabled = rbSocialRegistered.Checked
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("
                UPDATE Employees SET 
                    FullName=@FullName,
                    Phone=@Phone,
                    Age=@Age,
                    SocialStatus=@SocialStatus,
                    SocialNumber=@SocialNumber,
                    StartDate=@StartDate,
                    Address=@Address
                WHERE EmployeeID=@EmployeeID AND ClinicID=@ClinicID", conn)

                cmd.Parameters.AddWithValue("@FullName", txtEmployeeName.Text.Trim())
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim())
                cmd.Parameters.AddWithValue("@Age", If(String.IsNullOrEmpty(txtAge.Text), DBNull.Value, Convert.ToInt32(txtAge.Text)))
                cmd.Parameters.AddWithValue("@SocialStatus", If(rbSocialRegistered.Checked, "مسجل", "غير مسجل"))
                cmd.Parameters.AddWithValue("@SocialNumber", If(rbSocialRegistered.Checked, txtSocialNumber.Text.Trim(), DBNull.Value))
                cmd.Parameters.AddWithValue("@StartDate", If(String.IsNullOrEmpty(txtStartDate.Text), DBNull.Value, Convert.ToDateTime(txtStartDate.Text)))
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim())
                cmd.Parameters.AddWithValue("@EmployeeID", Convert.ToInt32(Request.QueryString("EmployeeID")))
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('تم تحديث بيانات الموظف بنجاح.'); window.location='EmployeesList.aspx';", True)
    End Sub

    Protected Sub btnClear_Click(sender As Object, e As EventArgs)
        LoadEmployee(Convert.ToInt32(Request.QueryString("EmployeeID")))
    End Sub
End Class