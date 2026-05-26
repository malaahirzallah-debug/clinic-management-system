Imports System.Data.SqlClient

Public Class PatiantsPayments
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtPayDate.Text = DateTime.Now.ToString("yyyy-MM-dd")
            txtPayDate.ReadOnly = True

            ddlPatients.Items.Clear()
            ddlPatients.Items.Add(New ListItem("— اختر نوع الدفعة أولاً —", ""))
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Protected Sub ddlPaymentType_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        ddlPatients.Items.Clear()

        Dim sql As String = "SELECT PatientID, FullName, Balance FROM Patients WHERE ClinicID=@ClinicID"

        Select Case ddlPaymentType.SelectedValue
            Case "debt"
                sql &= " AND Balance < 0"
            Case "subscription"
                sql &= " AND Balance >= 0"
            Case Else
                ddlPatients.Items.Add(New ListItem("— اختر نوع الدفعة أولاً —", ""))
                Return
        End Select

        sql &= " ORDER BY FullName"

        Using con As New SqlConnection(connStr)
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                con.Open()
                Using reader = cmd.ExecuteReader()
                    If reader.HasRows Then
                        ddlPatients.Items.Add(New ListItem("— اختر المريض —", ""))
                        While reader.Read()
                            Dim patientName As String = reader("FullName").ToString()
                            Dim patientID As String = reader("PatientID").ToString()
                            Dim balance As Decimal = Convert.ToDecimal(reader("Balance"))
                            ddlPatients.Items.Add(New ListItem($"{patientName} ({balance:N2} د.أ)", patientID))
                        End While
                    Else
                        ddlPatients.Items.Add(New ListItem("لا يوجد مرضى", ""))
                    End If
                End Using
            End Using
        End Using
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        ' التحقق من صحة المدخلات
        If String.IsNullOrEmpty(ddlPatients.SelectedValue) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('يرجى اختيار المريض ❌');", True)
            Return
        End If

        Dim amount As Decimal
        If Not Decimal.TryParse(txtAmount.Text, amount) OrElse amount <= 0 Then
            ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('يرجى إدخال مبلغ صالح ❌');", True)
            Return
        End If

        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim patientID As Integer = Convert.ToInt32(ddlPatients.SelectedValue)
        Dim paymentType As String = ddlPaymentType.SelectedValue
        Dim payDate As Date = If(String.IsNullOrEmpty(txtPayDate.Text), DateTime.Now, Convert.ToDateTime(txtPayDate.Text))
        Dim notes As String = txtNotes.Text

        Using con As New SqlConnection(connStr)
            con.Open()
            Dim trans As SqlTransaction = con.BeginTransaction()
            Try
                ' 1️⃣ إضافة الدفعة
                Dim insertSql As String = "
                    INSERT INTO Payments (PatientID, ClinicID, PaymentType, PayDate, Amount, Notes)
                    VALUES (@PatientID, @ClinicID, @PaymentType, @PayDate, @Amount, @Notes)"
                Using cmd As New SqlCommand(insertSql, con, trans)
                    cmd.Parameters.AddWithValue("@PatientID", patientID)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                    cmd.Parameters.AddWithValue("@PaymentType", paymentType)
                    cmd.Parameters.AddWithValue("@PayDate", payDate)
                    cmd.Parameters.AddWithValue("@Amount", amount)
                    cmd.Parameters.AddWithValue("@Notes", notes)
                    cmd.ExecuteNonQuery()
                End Using

                ' 2️⃣ تعديل الرصيد للمريض
                Dim updateSql As String = "UPDATE Patients SET Balance = Balance + @Amount WHERE PatientID=@PatientID AND ClinicID=@ClinicID"

                Using cmd As New SqlCommand(updateSql, con, trans)
                    cmd.Parameters.AddWithValue("@Amount", amount)
                    cmd.Parameters.AddWithValue("@PatientID", patientID)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                    cmd.ExecuteNonQuery()
                End Using

                trans.Commit()
                ClientScript.RegisterStartupScript(Me.GetType(), "saved", "alert('تم الحفظ بنجاح ✅'); window.location=window.location.href;", True)

            Catch ex As Exception
                trans.Rollback()
                ClientScript.RegisterStartupScript(Me.GetType(), "error", $"alert('حدث خطأ أثناء الحفظ ❌\n{ex.Message}');", True)
            End Try
        End Using
    End Sub
End Class
