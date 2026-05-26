Imports System.Data.SqlClient
Imports System.Configuration

Public Class TreatmentsManager
    Inherits System.Web.UI.Page

    ' اسم الاتصال
    Private ReadOnly connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    ' كلاس مساعد لتمثيل المجموعات مع الإجراءات
    Public Class TreatmentModel
        Public Property TreatmentID As Integer
        Public Property GroupID As Integer
        Public Property TreatmentName As String
        Public Property ShortDesc As String
        Public Property DurationMinutes As Integer
        Public Property Notes As String
        Public Property Price As Decimal
    End Class

    Public Class GroupModel
        Public Property GroupID As Integer
        Public Property GroupName As String
        Public Property Notes As String
        Public Property Treatments As List(Of TreatmentModel)
    End Class

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindGroupsDropDown()

            ' ربط الحدث قبل الـ DataBind
            AddHandler rptGroups.ItemDataBound, AddressOf rptGroups_ItemDataBound

            BindGroupsRepeater()

            ApplyPermissions() ' للأزرار الثابتة
        End If
    End Sub
    Private Sub ApplyPermissions()
        Dim permissions As List(Of String) = TryCast(Session("Permissions"), List(Of String))

        ' لكل زر نتحقق إذا موجود في الصلاحيات
        btnAddGroup.Visible = (permissions IsNot Nothing AndAlso permissions.Contains("btnAddGroup"))
        btnAddTreatment.Visible = (permissions IsNot Nothing AndAlso permissions.Contains("btnAddTreatment"))
    End Sub

    Protected Sub rptGroups_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim permissions As List(Of String) = TryCast(Session("Permissions"), List(Of String))

            ' أزرار المجموعة
            Dim btnEditGroup As HyperLink = CType(e.Item.FindControl("btnEditGroup"), HyperLink)
            Dim btnDeleteGroup As LinkButton = CType(e.Item.FindControl("btnDeleteGroup"), LinkButton)

            btnEditGroup.Visible = (permissions IsNot Nothing AndAlso permissions.Contains("btnEditGroup"))
            btnDeleteGroup.Visible = (permissions IsNot Nothing AndAlso permissions.Contains("btnDeleteGroup"))

            ' تكرار الإجراءات داخل المجموعة
            Dim rptTreatments As Repeater = CType(e.Item.FindControl("rptTreatments"), Repeater)
            If rptTreatments IsNot Nothing Then
                For Each item As RepeaterItem In rptTreatments.Items
                    If item.ItemType = ListItemType.Item Or item.ItemType = ListItemType.AlternatingItem Then
                        Dim btnEditTreatment As HyperLink = CType(item.FindControl("btnEditTreatment"), HyperLink)
                        Dim btnDeleteTreatment As LinkButton = CType(item.FindControl("btnDeleteTreatment"), LinkButton)

                        btnEditTreatment.Visible = (permissions IsNot Nothing AndAlso permissions.Contains("btnEditTreatment"))
                        btnDeleteTreatment.Visible = (permissions IsNot Nothing AndAlso permissions.Contains("btnDeleteTreatment"))
                    End If
                Next
            End If
        End If
    End Sub




    ' جلب جميع المجموعات الخاصة بالعيادة للفلتر
    Private Sub BindGroupsDropDown()
        Dim clinicId As Integer = CInt(Session("ClinicID"))
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("SELECT GroupID, GroupName FROM TreatmentGroups WHERE ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                conn.Open()
                ddlGroups.DataSource = cmd.ExecuteReader()
                ddlGroups.DataTextField = "GroupName"
                ddlGroups.DataValueField = "GroupID"
                ddlGroups.DataBind()
                ddlGroups.Items.Insert(0, New ListItem("كل المجموعات", ""))
            End Using
        End Using
    End Sub

    ' جلب المجموعات مع الإجراءات
    Private Sub BindGroupsRepeater()
        Dim clinicId As Integer = CInt(Session("ClinicID"))
        Dim groups As New List(Of GroupModel)

        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' جلب المجموعات
            Using cmdGroups As New SqlCommand("SELECT GroupID, GroupName, Notes FROM TreatmentGroups WHERE ClinicID=@ClinicID", conn)
                cmdGroups.Parameters.AddWithValue("@ClinicID", clinicId)
                Using rdr As SqlDataReader = cmdGroups.ExecuteReader()
                    While rdr.Read()
                        groups.Add(New GroupModel With {
                            .GroupID = Convert.ToInt32(rdr("GroupID")),
                            .GroupName = rdr("GroupName").ToString(),
                            .Notes = rdr("Notes").ToString(),
                            .Treatments = New List(Of TreatmentModel)()
                        })
                    End While
                End Using
            End Using

            ' جلب الإجراءات لكل مجموعة
            Using cmdTreatments As New SqlCommand("SELECT TreatmentID, GroupID, TreatmentName, ShortDesc, DurationMinutes, Notes, Price FROM Treatments WHERE ClinicID=@ClinicID", conn)
                cmdTreatments.Parameters.AddWithValue("@ClinicID", clinicId)
                Using rdr As SqlDataReader = cmdTreatments.ExecuteReader()
                    While rdr.Read()
                        Dim t As New TreatmentModel With {
                            .TreatmentID = Convert.ToInt32(rdr("TreatmentID")),
                            .GroupID = Convert.ToInt32(rdr("GroupID")),
                            .TreatmentName = rdr("TreatmentName").ToString(),
                            .ShortDesc = rdr("ShortDesc").ToString(),
                            .DurationMinutes = Convert.ToInt32(rdr("DurationMinutes")),
                            .Notes = rdr("Notes").ToString(),
                            .Price = Convert.ToDecimal(rdr("Price"))
                        }
                        Dim g = groups.FirstOrDefault(Function(x) x.GroupID = t.GroupID)
                        If g IsNot Nothing Then
                            g.Treatments.Add(t)
                        End If
                    End While
                End Using
            End Using
        End Using

        ' تطبيق فلترة إذا هناك نص بحث أو اختيار مجموعة
        Dim filterText As String = txtSearch.Text.Trim().ToLower()
        Dim selectedGroup As String = ddlGroups.SelectedValue

        Dim filtered = groups.Where(Function(g)
                                        Dim matchesGroup = String.IsNullOrEmpty(selectedGroup) OrElse g.GroupID.ToString() = selectedGroup
                                        Dim matchesText = String.IsNullOrEmpty(filterText) OrElse g.GroupName.ToLower().Contains(filterText) OrElse g.Treatments.Any(Function(t) t.TreatmentName.ToLower().Contains(filterText))
                                        Return matchesGroup AndAlso matchesText
                                    End Function).ToList()

        rptGroups.DataSource = filtered
        rptGroups.DataBind()
    End Sub

    ' فلترة عند تغيير النص أو القائمة
    Protected Sub FilterData(sender As Object, e As EventArgs)
        BindGroupsRepeater()
    End Sub

    ' حذف مجموعة (مع كل الإجراءات التابعة)
    Protected Sub btnDeleteGroup_Click(sender As Object, e As EventArgs)
        Dim groupId As Integer = Convert.ToInt32(CType(sender, LinkButton).CommandArgument)
        Dim clinicId As Integer = CInt(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            conn.Open()
            ' حذف الإجراءات أولاً
            Using cmd As New SqlCommand("DELETE FROM Treatments WHERE GroupID=@GroupID AND ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@GroupID", groupId)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                cmd.ExecuteNonQuery()
            End Using
            ' حذف المجموعة
            Using cmd As New SqlCommand("DELETE FROM TreatmentGroups WHERE GroupID=@GroupID AND ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@GroupID", groupId)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        BindGroupsRepeater()
    End Sub

    ' حذف إجراء
    Protected Sub btnDeleteTreatment_Click(sender As Object, e As EventArgs)
        Dim treatmentId As Integer = Convert.ToInt32(CType(sender, LinkButton).CommandArgument)
        Dim clinicId As Integer = CInt(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand("DELETE FROM Treatments WHERE TreatmentID=@TreatmentID AND ClinicID=@ClinicID", conn)
                cmd.Parameters.AddWithValue("@TreatmentID", treatmentId)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        BindGroupsRepeater()
    End Sub
End Class
