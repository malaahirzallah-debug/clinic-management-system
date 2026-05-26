Imports System.Data.SqlClient
Public Class PatientVisits
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim patientID As Integer = 0
            If Not String.IsNullOrEmpty(Request.QueryString("PatientID")) Then
                Integer.TryParse(Request.QueryString("PatientID"), patientID)
            End If

            If patientID > 0 Then
                LoadPatientDetails(patientID)
                LoadPatientVisits(patientID)
            Else
                lblNoVisits.Text = "لم يتم تحديد المريض."
                lblNoVisits.Visible = True
            End If
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
        If Not Page.IsPostBack Then
            ApplyPermissions()
        End If
    End Sub
    Private Sub ApplyPermissions()
        If Session("Permissions") Is Nothing Then Exit Sub
        Dim permissions As List(Of String) = CType(Session("Permissions"), List(Of String))

        ' قائمة العناصر التي لها صلاحيات
        Dim controlsWithPermissions As String() = {"btnLast5Visits", "btnTreatmentPlan", "btnAttachments"}

        For Each ctrlID As String In controlsWithPermissions
            Dim ctrl As Control = FindControlRecursive(Me, ctrlID)
            If ctrl IsNot Nothing Then
                ctrl.Visible = permissions.Contains(ctrlID)
            End If
        Next
    End Sub

    ' دالة FindControl recursive
    Private Function FindControlRecursive(ByVal root As Control, ByVal id As String) As Control
        If root.ID = id Then Return root
        For Each ctrl As Control In root.Controls
            Dim found As Control = FindControlRecursive(ctrl, id)
            If found IsNot Nothing Then Return found
        Next
        Return Nothing
    End Function


    Private Sub LoadPatientDetails(patientID As Integer)
            Using conn As New SqlConnection(connStr)
                Dim cmd As New SqlCommand("SELECT PatientID, FullName, NationalNo, Phone, AltPhone FROM dbo.Patients WHERE PatientID=@id", conn)
                cmd.Parameters.AddWithValue("@id", patientID)
                conn.Open()
                Using reader = cmd.ExecuteReader()
                    If reader.Read() Then
                        lblPatientID.Text = reader("PatientID").ToString()
                        lblName.Text = reader("FullName").ToString()
                        lblNationalID.Text = reader("NationalNo").ToString()
                        lblPhone.Text = reader("Phone").ToString()
                        lblAltPhone.Text = reader("AltPhone").ToString()
                    End If
                End Using
            End Using
        End Sub

        Private Sub LoadPatientVisits(patientID As Integer)
            Using conn As New SqlConnection(connStr)
                Dim sql As String = "
                SELECT v.VisitID,
                       v.PatientID,
                       v.VisitDate,
                       v.MedicalReport,
                       v.Medicines,
                       v.VisitAmount,
                       v.PaymentMethod,
                       ISNULL(SUM(p.Amount), 0) AS PaidAmount
                FROM dbo.Visits v
                LEFT JOIN dbo.Payments p ON v.VisitID = p.VisitID
                WHERE v.PatientID=@id
                GROUP BY v.VisitID, v.PatientID, v.VisitDate, v.MedicalReport, v.Medicines, v.VisitAmount, v.PaymentMethod
                ORDER BY v.VisitDate DESC"

                Dim cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@id", patientID)

                conn.Open()
                Using reader = cmd.ExecuteReader()
                    If reader.HasRows Then
                        visitsRepeater.DataSource = reader
                        visitsRepeater.DataBind()
                        lblNoVisits.Visible = False
                    Else
                        lblNoVisits.Visible = True
                    End If
                End Using
            End Using
        End Sub

    ' زر المرفقات
    Protected Sub btnAttachments_Click(sender As Object, e As EventArgs)
        Dim patientID As Integer = 0
        Integer.TryParse(lblPatientID.Text, patientID)
        If patientID > 0 Then
            Response.Redirect("PatientAttachments.aspx?PatientID=" & patientID)
        Else
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('رقم المريض غير متوفر.');", True)
        End If
    End Sub
    Protected Sub btnBack_Click(sender As Object, e As EventArgs)
        Response.Redirect("ShowPatiants.aspx")
    End Sub
    Protected Sub btnLast5Visits_Click(sender As Object, e As EventArgs)
        Dim patientId As Integer = Convert.ToInt32(lblPatientID.Text)

        Dim query As String = "
        SELECT TOP 5 
               v.VisitDate,
               v.MedicalReport,
               v.Medicines
        FROM dbo.Visits v
        WHERE v.PatientID = @PatientID
        ORDER BY v.VisitDate DESC"

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@PatientID", patientId)
                conn.Open()

                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())

                ' إذا كانت هناك نتائج
                If dt.Rows.Count > 0 Then
                    rptLast5Visits.DataSource = dt
                    rptLast5Visits.DataBind()
                    divLast5Visits.Visible = True
                    btnPrintLast5.Visible = True
                Else
                    divLast5Visits.Visible = False
                    btnPrintLast5.Visible = False
                End If
            End Using
        End Using
    End Sub
    Protected Sub btnTreatmentPlan_Click(sender As Object, e As EventArgs)
        Dim patientID As Integer
        If Not Integer.TryParse(lblPatientID.Text, patientID) OrElse patientID <= 0 Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('رقم المريض غير متوفر لفتح الخطة العلاجية.');", True)
            Return
        End If

        ' جلب أنواع العيادة من السيشن
        Dim clinicTypes As List(Of String) = TryCast(Session("ClinicTypes"), List(Of String))

        If clinicTypes Is Nothing OrElse clinicTypes.Count = 0 Then
            ' السيشن فارغ -> فتح الصفحة الحالية كما هي
            Response.Redirect("TreatmentPlans.aspx?PatientID=" & patientID)
        ElseIf clinicTypes.Count = 1 Then
            ' نوع واحد فقط -> تحويل مباشر
            Select Case clinicTypes(0)
                Case "1" ' أسنان
                    Response.Redirect("TreatmentPlan.aspx?PatientID=" & patientID)
                Case "2" ' علاج طبيعي
                    Response.Redirect("PhysioTreatmentPlan.aspx?PatientID=" & patientID)
                Case "3" ' أخرى
                    Response.Redirect("PhysioTreatmentPlan.aspx?PatientID=" & patientID)
                Case Else
                    Response.Redirect("TreatmentPlans.aspx?PatientID=" & patientID)
            End Select
        Else
            ' أكثر من نوع -> فتح صفحة الخيارات حسب السيشن
            Response.Redirect("TreatmentPlans.aspx?PatientID=" & patientID)
        End If
    End Sub

    Protected Sub visitsRepeater_ItemCommand(source As Object, e As RepeaterCommandEventArgs) Handles visitsRepeater.ItemCommand
        If e.CommandName = "ViewDetails" Then
            Dim args() As String = e.CommandArgument.ToString().Split("|"c)
            Dim visitId As Integer = Convert.ToInt32(args(0))
            Dim patientId As Integer = Convert.ToInt32(args(1))

            Response.Redirect("~/VisitDetails.aspx?VisitID=" & visitId & "&PatientID=" & patientId)
        End If
    End Sub
End Class