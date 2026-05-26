Imports System.Data.SqlClient
Public Class EditSuppliers
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If String.IsNullOrEmpty(Request.QueryString("SupplierID")) Then
                lblMessage.Text = "لم يتم تحديد المورد."
                lblMessage.ForeColor = Drawing.Color.Red
                btnSave.Enabled = False
                Return
            End If

            Dim supplierID As Integer = Convert.ToInt32(Request.QueryString("SupplierID"))
            hfSupplierID.Value = supplierID.ToString()

            ' جلب بيانات المورد من قاعدة البيانات
            Using conn As New SqlConnection(connStr)
                Using cmd As New SqlCommand("SELECT CompanyName, AgentName, Phone, Email, Address, Notes FROM Suppliers WHERE SupplierID=@SupplierID", conn)
                    cmd.Parameters.AddWithValue("@SupplierID", supplierID)
                    conn.Open()
                    Using rdr = cmd.ExecuteReader()
                        If rdr.Read() Then
                            txtCompanyName.Text = rdr("CompanyName").ToString()
                            txtAgentName.Text = rdr("AgentName").ToString()
                            txtPhone.Text = If(IsDBNull(rdr("Phone")), "", rdr("Phone").ToString())
                            txtEmail.Text = If(IsDBNull(rdr("Email")), "", rdr("Email").ToString())
                            txtAddress.Text = If(IsDBNull(rdr("Address")), "", rdr("Address").ToString())
                            txtNotes.Text = If(IsDBNull(rdr("Notes")), "", rdr("Notes").ToString())
                        Else
                            lblMessage.Text = "المورد غير موجود."
                            lblMessage.ForeColor = Drawing.Color.Red
                            btnSave.Enabled = False
                        End If
                    End Using
                    conn.Close()
                End Using
            End Using
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If Session("ClinicID") Is Nothing Then
            lblMessage.Text = "رقم العيادة غير موجود في الجلسة."
            lblMessage.ForeColor = Drawing.Color.Red
            Return
        End If

        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim supplierID As Integer = Convert.ToInt32(hfSupplierID.Value)

        Dim companyName As String = txtCompanyName.Text.Trim()
        Dim agentName As String = txtAgentName.Text.Trim()
        Dim phone As String = txtPhone.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim address As String = txtAddress.Text.Trim()
        Dim notes As String = txtNotes.Text.Trim()

        ' التحقق من القيم المطلوبة
        If String.IsNullOrEmpty(companyName) Or String.IsNullOrEmpty(agentName) Then
            lblMessage.Text = "يرجى إدخال اسم الشركة واسم المندوب."
            lblMessage.ForeColor = Drawing.Color.Red
            Return
        End If

        ' تحديث البيانات في قاعدة البيانات
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand()
                cmd.Connection = conn
                cmd.CommandType = CommandType.Text
                cmd.CommandText = "
                    UPDATE Suppliers
                    SET CompanyName=@CompanyName,
                        AgentName=@AgentName,
                        Phone=@Phone,
                        Email=@Email,
                        Address=@Address,
                        Notes=@Notes
                    WHERE SupplierID=@SupplierID AND ClinicID=@ClinicID
                "
                cmd.Parameters.AddWithValue("@CompanyName", companyName)
                cmd.Parameters.AddWithValue("@AgentName", agentName)
                cmd.Parameters.AddWithValue("@Phone", If(String.IsNullOrEmpty(phone), DBNull.Value, phone))
                cmd.Parameters.AddWithValue("@Email", If(String.IsNullOrEmpty(email), DBNull.Value, email))
                cmd.Parameters.AddWithValue("@Address", If(String.IsNullOrEmpty(address), DBNull.Value, address))
                cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrEmpty(notes), DBNull.Value, notes))
                cmd.Parameters.AddWithValue("@SupplierID", supplierID)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)

                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('تم تحديث بيانات المورد بنجاح.'); window.location='SuppliersList.aspx';", True)
    End Sub

    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        txtCompanyName.Text = ""
        txtAgentName.Text = ""
        txtPhone.Text = ""
        txtEmail.Text = ""
        txtAddress.Text = ""
        txtNotes.Text = ""
        lblMessage.Text = ""
    End Sub
End Class