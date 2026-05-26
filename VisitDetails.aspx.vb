Imports System.Data.SqlClient
Imports System.Configuration

Public Class VisitDetails
    Inherits System.Web.UI.Page

    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim visitId As Integer
            If Integer.TryParse(Request.QueryString("VisitID"), visitId) Then
                LoadVisitDetails(visitId)
            Else
                lblVisitID.Text = "غير معروف"
            End If
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Private Sub LoadVisitDetails(visitId As Integer)
        Using conn As New SqlConnection(connStr)
            Dim sql As String = "
                SELECT v.VisitID, v.VisitDate, v.MedicalReport, v.Medicines,
                       v.VisitAmount, v.PaymentMethod, p.FullName AS PatientName,
                       ISNULL(SUM(pm.Amount),0) AS PaidAmount
                FROM Visits v
                INNER JOIN Patients p ON v.PatientID = p.PatientID
                LEFT JOIN Payments pm ON v.VisitID = pm.VisitID
                WHERE v.VisitID = @vid
                GROUP BY v.VisitID, v.VisitDate, v.MedicalReport, v.Medicines,
                         v.VisitAmount, v.PaymentMethod, p.FullName"

            Dim cmd As New SqlCommand(sql, conn)
            cmd.Parameters.AddWithValue("@vid", visitId)

            conn.Open()
            Using reader As SqlDataReader = cmd.ExecuteReader()
                If reader.Read() Then
                    lblVisitID.Text = reader("VisitID").ToString()
                    lblVisitDate.Text = Convert.ToDateTime(reader("VisitDate")).ToString("yyyy/MM/dd")
                    lblPatientName.Text = reader("PatientName").ToString()
                    lblMedicalReport.Text = reader("MedicalReport").ToString()
                    lblMedicines.Text = reader("Medicines").ToString()
                    lblVisitAmount.Text = String.Format("{0:0.00}", reader("VisitAmount"))
                    lblPaidAmount.Text = String.Format("{0:0.00}", reader("PaidAmount"))
                    lblPaymentMethod.Text = TranslatePaymentMethod(reader("PaymentMethod").ToString())
                Else
                    lblVisitID.Text = "غير موجودة"
                End If
            End Using
        End Using
    End Sub

    Private Function TranslatePaymentMethod(method As String) As String
        Select Case method.ToLower()
            Case "cash"
                Return "نقدي"
            Case "debt"
                Return "ذمم"
            Case "insurance"
                Return "تأمين"
            Case Else
                Return method
        End Select
    End Function

    Protected Sub btnBack_Click(sender As Object, e As EventArgs) Handles btnBack.Click
        If Not String.IsNullOrEmpty(Request.QueryString("PatientID")) Then
            Response.Redirect("~/PatientVisits.aspx?PatientID=" & Request.QueryString("PatientID"))
        Else
            Response.Redirect("~/PatientVisits.aspx")
        End If
    End Sub


    Protected Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
        ' لاحقاً ممكن نعمل كود للطباعة أو تحويل ل PDF
        ClientScript.RegisterStartupScript(Me.GetType(), "print", "window.print();", True)
    End Sub

End Class
