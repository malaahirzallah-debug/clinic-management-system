Imports System.Data.SqlClient
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports System.Web
Public Class PhysioTreatmentPlan
    Inherits System.Web.UI.Page
    Private Shared ReadOnly Property ConnStr As String
        Get
            Return System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString
        End Get
    End Property
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim patientID As Integer
            If Integer.TryParse(Request.QueryString("PatientID"), patientID) AndAlso patientID > 0 Then
                Session("PatientID") = patientID
            Else
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('رقم المريض غير موجود.');", True)
            End If
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub
    <WebMethod()>
    Public Shared Function GetGroups() As String
        Dim results As New List(Of Object)
        Try
            Using conn As New SqlConnection(ConnStr)
                Using cmd As New SqlCommand("SELECT GroupID, GroupName FROM TreatmentGroups WHERE ClinicID=@ClinicID", conn)
                    cmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
                    conn.Open()
                    Using rdr = cmd.ExecuteReader()
                        While rdr.Read()
                            results.Add(New With {
                                .id = rdr("GroupID"),
                                .name = rdr("GroupName").ToString()
                            })
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ' يمكن تسجيل الخطأ هنا
        End Try
        Return New JavaScriptSerializer().Serialize(results)
    End Function

    <WebMethod()>
    Public Shared Function GetTreatments(ByVal groupId As Integer) As String
        Dim results As New List(Of Object)
        Try
            Using conn As New SqlConnection(ConnStr)
                Using cmd As New SqlCommand("SELECT TreatmentID, TreatmentName FROM Treatments WHERE GroupID=@GroupID AND ClinicID=@ClinicID", conn)
                    cmd.Parameters.AddWithValue("@GroupID", groupId)
                    cmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
                    conn.Open()
                    Using rdr = cmd.ExecuteReader()
                        While rdr.Read()
                            results.Add(New With {
                                .id = rdr("TreatmentID"),
                                .name = rdr("TreatmentName").ToString()
                            })
                        End While
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ' يمكن تسجيل الخطأ هنا
        End Try
        Return New JavaScriptSerializer().Serialize(results)
    End Function
End Class



'<WebMethod()>
'    Public Shared Function DeleteTreatment(toothNumber As String, treatmentID As Integer) As String
'        Try
'            Dim patientID As Integer = HttpContext.Current.Session("PatientID")
'            Using conn As New SqlConnection(ConnStr)
'                conn.Open()
'                Using cmd As New SqlCommand("DELETE FROM TreatmentPlan WHERE PatientID=@PatientID AND ToothNumber=@ToothNumber AND TreatmentID=@TreatmentID AND ClinicID=@ClinicID", conn)
'                    cmd.Parameters.AddWithValue("@PatientID", patientID)
'                    cmd.Parameters.AddWithValue("@ToothNumber", Convert.ToInt32(toothNumber))
'                    cmd.Parameters.AddWithValue("@TreatmentID", treatmentID)
'                    cmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
'                    cmd.ExecuteNonQuery()
'                End Using
'            End Using
'            Return "OK"
'        Catch ex As Exception
'            Return "Error: " & ex.Message
'        End Try
'    End Function


'    <WebMethod()>
'    Public Shared Function MarkTreatmentDone(patientID As Integer, toothNumber As String, treatmentID As Integer) As String
'        Try
'            Using conn As New SqlConnection(ConnStr)
'                conn.Open()
'                Using cmd As New SqlCommand("UPDATE TreatmentPlan SET Status='Done', UpdatedAt=GETDATE() WHERE PatientID=@PatientID AND ToothNumber=@ToothNumber AND TreatmentID=@TreatmentID AND ClinicID=@ClinicID", conn)
'                    cmd.Parameters.AddWithValue("@PatientID", patientID)
'                    cmd.Parameters.AddWithValue("@ToothNumber", toothNumber)
'                    cmd.Parameters.AddWithValue("@TreatmentID", treatmentID)
'                    cmd.Parameters.AddWithValue("@ClinicID", HttpContext.Current.Session("ClinicID"))
'                    cmd.ExecuteNonQuery()
'                End Using
'            End Using
'            Return "OK"
'        Catch ex As Exception
'            Return "Error: " & ex.Message
'        End Try
'    End Function

'    <WebMethod()>
'    Public Shared Function GetPatientTreatments(patientID As Integer, clinicID As Integer) As String
'        Dim results As New List(Of Object)
'        Try
'            Using conn As New SqlConnection(ConnStr)
'                Using cmd As New SqlCommand("
'                SELECT tp.ToothNumber, tp.TreatmentID, t.TreatmentName, tp.Notes, tp.Status
'                FROM TreatmentPlan tp
'                INNER JOIN Treatments t ON tp.TreatmentID = t.TreatmentID
'                WHERE tp.PatientID = @PatientID AND tp.ClinicID = @ClinicID", conn)

'                    cmd.Parameters.AddWithValue("@PatientID", patientID)
'                    cmd.Parameters.AddWithValue("@ClinicID", clinicID)

'                    conn.Open()
'                    Using rdr = cmd.ExecuteReader()
'                        While rdr.Read()
'                            results.Add(New With {
'                            .tooth = rdr("ToothNumber").ToString(),
'                            .treatmentID = Convert.ToInt32(rdr("TreatmentID")),
'                            .treatmentName = rdr("TreatmentName").ToString(),
'                            .notes = rdr("Notes").ToString(),
'                            .status = rdr("Status").ToString()
'                        })
'                        End While
'                    End Using
'                End Using
'            End Using
'        Catch ex As Exception
'            ' تسجيل الخطأ إذا أحببت
'        End Try
'        Return New JavaScriptSerializer().Serialize(results)
'    End Function

'    <WebMethod()>
'    Public Shared Function SaveTreatments(treatmentsData As String) As String
'        Try
'            Dim treatments() As String = treatmentsData.Split(";"c)
'            Dim patientID As Integer = HttpContext.Current.Session("PatientID")
'            Dim clinicID As Integer = HttpContext.Current.Session("ClinicID")

'            Using conn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString)
'                conn.Open()
'                For Each t As String In treatments
'                    If String.IsNullOrWhiteSpace(t) Then Continue For
'                    Dim parts() As String = t.Split("|"c)
'                    Dim toothNumber As String = parts(0)
'                    Dim groupID As Integer = Convert.ToInt32(parts(1))
'                    Dim treatmentID As Integer = Convert.ToInt32(parts(2))
'                    Dim notes As String = parts(3)

'                    Dim cmdCheck As New SqlCommand("SELECT COUNT(*) FROM TreatmentPlan WHERE PatientID=@PatientID AND ToothNumber=@ToothNumber AND TreatmentID=@TreatmentID AND ClinicID=@ClinicID", conn)
'                    cmdCheck.Parameters.AddWithValue("@PatientID", patientID)
'                    cmdCheck.Parameters.AddWithValue("@ToothNumber", toothNumber)
'                    cmdCheck.Parameters.AddWithValue("@TreatmentID", treatmentID)
'                    cmdCheck.Parameters.AddWithValue("@ClinicID", clinicID)

'                    Dim count As Integer = Convert.ToInt32(cmdCheck.ExecuteScalar())
'                    If count = 0 Then
'                        Dim cmdInsert As New SqlCommand("INSERT INTO TreatmentPlan (PatientID, ToothNumber, TreatmentID, Notes, CreatedAt, UpdatedAt, Status, ClinicID) VALUES (@PatientID, @ToothNumber, @TreatmentID, @Notes, GETDATE(), GETDATE(), 1, @ClinicID)", conn)
'                        cmdInsert.Parameters.AddWithValue("@PatientID", patientID)
'                        cmdInsert.Parameters.AddWithValue("@ToothNumber", toothNumber)
'                        cmdInsert.Parameters.AddWithValue("@TreatmentID", treatmentID)
'                        cmdInsert.Parameters.AddWithValue("@Notes", notes)
'                        cmdInsert.Parameters.AddWithValue("@ClinicID", clinicID)
'                        cmdInsert.ExecuteNonQuery()
'                    End If
'                Next
'            End Using

'            Return "OK"
'        Catch ex As Exception
'            Return "Error: " & ex.Message
'        End Try
'    End Function
