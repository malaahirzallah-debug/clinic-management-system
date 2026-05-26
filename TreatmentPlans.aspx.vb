Imports System
Imports System.Web.UI
Imports System.Web.UI.HtmlControls

Public Class TreatmentPlans
    Inherits System.Web.UI.Page

    Public Property PatientID As Integer

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
        If Not IsPostBack Then
            ' جلب رقم المريض
            Dim pidRaw As String = Request.QueryString("PatientID")
            Dim pid As Integer = 0

            If Not String.IsNullOrEmpty(pidRaw) AndAlso Integer.TryParse(pidRaw, pid) Then
                PatientID = pid
                Session("PatientID") = pid
            Else
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('رقم المريض غير متوفر.');", True)
                Return
            End If

            ' جلب أنواع العيادة من السيشن
            Dim clinicTypes As List(Of String) = TryCast(Session("ClinicTypes"), List(Of String))
            If clinicTypes Is Nothing OrElse clinicTypes.Count = 0 Then
                ' إذا السيشن فارغ، أظهر كل الخيارات
                clinicTypes = New List(Of String) From {"1", "2", "3"}
            End If

            ' بناء الصناديق ديناميكيًا
            phTreatmentBoxes.Controls.Clear()

            For Each typeVal In clinicTypes
                Dim divBox As New HtmlGenericControl("div")
                divBox.Attributes("class") = "treatment-box"

                Select Case typeVal
                    Case "1"
                        divBox.Attributes("onclick") = "openPlan('Dental')"
                        divBox.InnerHtml = "<img src='Images/R.jpeg' alt='أسنان' /><h3>عيادة الأسنان</h3>"
                    Case "2"
                        divBox.Attributes("onclick") = "openPlan('Physiotherapy')"
                        divBox.InnerHtml = "<img src='Images/1000_F_966441823_4P2sJye2ehKoSl4pVwIjz65v00TqLT4z.jpg' alt='علاج طبيعي' /><h3>العلاج الطبيعي</h3>"
                    Case "3"
                        divBox.Attributes("onclick") = "openPlan('Other')"
                        divBox.InnerHtml = "<img src='Images/Gemini_Generated_Image_40by9x40by9x40by.png' alt='عيادات أخرى' /><h3>عيادات أخرى</h3>"
                End Select

                phTreatmentBoxes.Controls.Add(divBox)
            Next
        End If
    End Sub
End Class
