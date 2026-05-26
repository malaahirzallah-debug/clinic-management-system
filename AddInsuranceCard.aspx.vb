Imports System.Data.SqlClient
Public Class AddInsuranceCard
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadPatients()
            LoadInsuranceCompanies()

            Dim queryPatientID As String = Request.QueryString("PatientID")
            If Not String.IsNullOrEmpty(queryPatientID) Then
                ' تحديد المريض تلقائيًا
                Dim item As ListItem = ddlPatient.Items.FindByValue(queryPatientID)
                If item IsNot Nothing Then
                    ddlPatient.ClearSelection()
                    item.Selected = True
                End If
            End If
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    ' تحميل قائمة المرضى
    Private Sub LoadPatients()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT PatientID, FullName FROM Patients WHERE ClinicID=@ClinicID ORDER BY FullName", conn)
            cmd.Parameters.AddWithValue("@ClinicID", Session("ClinicID"))
            conn.Open()
            ddlPatient.DataSource = cmd.ExecuteReader()
            ddlPatient.DataTextField = "FullName"
            ddlPatient.DataValueField = "PatientID"
            ddlPatient.DataBind()
        End Using
        ddlPatient.Items.Insert(0, New ListItem("-- اختر المريض --", "0"))
    End Sub

    ' تحميل قائمة شركات التأمين
    Private Sub LoadInsuranceCompanies()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT InsuranceID, CompanyName FROM InsuranceCompanies WHERE ClinicID=@ClinicID ORDER BY CompanyName", conn)
            cmd.Parameters.AddWithValue("@ClinicID", Session("ClinicID"))
            conn.Open()
            ddlInsuranceCompany.DataSource = cmd.ExecuteReader()
            ddlInsuranceCompany.DataTextField = "CompanyName"
            ddlInsuranceCompany.DataValueField = "InsuranceID"
            ddlInsuranceCompany.DataBind()
        End Using
        ddlInsuranceCompany.Items.Insert(0, New ListItem("-- اختر شركة التأمين --", "0"))
    End Sub

    ' عند الحفظ
    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If ddlPatient.SelectedValue = "0" Or ddlInsuranceCompany.SelectedValue = "0" Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('يرجى اختيار المريض وشركة التأمين.');", True)
            Return
        End If

        ' التحقق من قيمة التغطية
        Dim coverageValue As Decimal
        Dim coverageText As String = txtCoverage.Text.Trim()

        If String.IsNullOrEmpty(coverageText) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('يرجى إدخال قيمة التغطية.');", True)
            Return
        End If

        Try
            If ddlCoverageType.SelectedValue = "Percentage" Then
                ' إزالة علامة % إذا وجدت وتحويل الرقم
                coverageText = coverageText.Replace("%", "")
                coverageValue = CDec(coverageText)
                If coverageValue < 0 Or coverageValue > 100 Then
                    ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('النسبة المئوية يجب أن تكون بين 0 و 100.');", True)
                    Return
                End If
            ElseIf ddlCoverageType.SelectedValue = "Fixed" Then
                coverageValue = CDec(coverageText)
                If coverageValue < 0 Then
                    ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('المبلغ يجب أن يكون رقمًا أكبر من الصفر.');", True)
                    Return
                End If
            Else
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('يرجى اختيار نوع التغطية.');", True)
                Return
            End If
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('القيمة غير صالحة.');", True)
            Return
        End Try

        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("
            INSERT INTO InsuranceCards 
            (ClinicID, PatientID, InsuranceCompanyID, CardNumber, ExpiryDate, CoveragePercentage, InsuranceLevel, Notes, CoverageType) 
            VALUES 
            (@ClinicID, @PatientID, @InsuranceCompanyID, @CardNumber, @ExpiryDate, @CoveragePercentage, @InsuranceLevel, @Notes, @CoverageType)
        ", conn)

            cmd.Parameters.AddWithValue("@ClinicID", Session("ClinicID"))
            cmd.Parameters.AddWithValue("@PatientID", ddlPatient.SelectedValue)
            cmd.Parameters.AddWithValue("@InsuranceCompanyID", ddlInsuranceCompany.SelectedValue)
            cmd.Parameters.AddWithValue("@CardNumber", txtCardNumber.Text.Trim())
            cmd.Parameters.AddWithValue("@ExpiryDate", txtExpiryDate.Text)
            cmd.Parameters.AddWithValue("@CoveragePercentage", coverageValue)
            cmd.Parameters.AddWithValue("@InsuranceLevel", ddlInsuranceLevel.SelectedValue)
            cmd.Parameters.AddWithValue("@Notes", If(String.IsNullOrEmpty(txtNotes.Text), DBNull.Value, txtNotes.Text.Trim()))
            cmd.Parameters.AddWithValue("@CoverageType", ddlCoverageType.SelectedValue)

            conn.Open()
            cmd.ExecuteNonQuery()
        End Using

        ClientScript.RegisterStartupScript(Me.GetType(), "saved", "alert('تم حفظ بطاقة التأمين بنجاح.'); window.location='HomePage.aspx';", True)
    End Sub


    ' زر إغلاق
    Protected Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Response.Redirect("HomePage.aspx")
    End Sub
End Class
