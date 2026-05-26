Imports System.Data.SqlClient

Public Class ShowPatiants
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Private Property PageIndex As Integer
        Get
            Return If(ViewState("PageIndex") IsNot Nothing, CInt(ViewState("PageIndex")), 1)
        End Get
        Set(value As Integer)
            ViewState("PageIndex") = value
        End Set
    End Property

    Private Property PageSize As Integer
        Get
            Return If(ViewState("PageSize") IsNot Nothing, CInt(ViewState("PageSize")), 10)
        End Get
        Set(value As Integer)
            ViewState("PageSize") = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ddlPageSize.SelectedValue = PageSize.ToString()

            txtLastVisitFrom.Text = New DateTime(DateTime.Now.Year, 1, 1).ToString("yyyy-MM-dd")
            txtLastVisitTo.Text = DateTime.Now.ToString("yyyy-MM-dd")

            LoadPatients()
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

        ' ===================== أزرار ثابتة =====================
        Dim staticButtons As String() = {"btnSearch", "btnExportExcel", "btnExportPDF"}
        For Each ctrlID As String In staticButtons
            Dim ctrl As Control = FindControlRecursive(Me, ctrlID)
            If ctrl IsNot Nothing Then ctrl.Visible = permissions.Contains(ctrlID)
        Next
    End Sub

    ' دالة FindControl recursive للبحث داخل كل hierarchy
    Private Function FindControlRecursive(ByVal root As Control, ByVal id As String) As Control
        If root.ID = id Then Return root
        For Each ctrl As Control In root.Controls
            Dim found As Control = FindControlRecursive(ctrl, id)
            If found IsNot Nothing Then Return found
        Next
        Return Nothing
    End Function

    Protected Sub rptPatients_ItemDataBound(sender As Object, e As RepeaterItemEventArgs) Handles rptPatients.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim permissions As List(Of String) = CType(Session("Permissions"), List(Of String))

            Dim btnView As LinkButton = TryCast(e.Item.FindControl("btnVisits"), LinkButton)
            Dim btnEdit As LinkButton = TryCast(e.Item.FindControl("btnEditPatient"), LinkButton)

            If btnView IsNot Nothing Then btnView.Visible = permissions.Contains("btnVisits")
            If btnEdit IsNot Nothing Then btnEdit.Visible = permissions.Contains("btnEditPatient")
        End If
    End Sub

    Private Sub LoadPatients()
        Dim subscriptionEndDate As DateTime = Convert.ToDateTime(Session("SubscriptionEndDate"))
        Dim maxPatients As Integer = Convert.ToInt32(Session("MaxPatients"))
        Dim isActive As Boolean = (subscriptionEndDate >= DateTime.Now)

        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT PatientID, FullName, Age, Phone, LastVisit, ISNULL(Balance,0) AS Balance, ISNULL(PhotoPath,'default-patient.png') AS PhotoPath
        From Patients
                                 WHERE ClinicID=@ClinicID
                                 ORDER BY FullName"

            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                Dim dt As New DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)

                ' تقييد عدد المرضى إذا الاشتراك غير مفعل
                If Not isActive Or maxPatients <= 10 Then
                    If dt.Rows.Count > 0 Then
                        dt = dt.AsEnumerable().Take(maxPatients).CopyToDataTable()
                    Else
                        dt = dt.Clone()
                    End If
                    lblMessage.Text = "⚠️ حسابك مقيد، لا يمكن عرض كل المرضى."
                Else
                    lblMessage.Text = ""
                End If

                BindPagedData(dt)
            End Using
        End Using
    End Sub

    ' ========================== Search Patients ==========================
    Private Sub SearchPatients(search As String, gender As String, ageFrom As Integer, ageTo As Integer,
                               doctor As String, fileNo As String,
                               includeLastVisit As Boolean, lastVisitFrom As Nullable(Of DateTime), lastVisitTo As Nullable(Of DateTime))

        Dim subscriptionEndDate As DateTime = Convert.ToDateTime(Session("SubscriptionEndDate"))
        Dim maxPatients As Integer = Convert.ToInt32(Session("MaxPatients"))
        Dim isActive As Boolean = (subscriptionEndDate >= DateTime.Now)

        If Not isActive OrElse maxPatients <= 10 Then
            lblMessage.Text = "⚠️ حسابك مقيد، لا يمكنك استخدام البحث أو الفلاتر."
            rptPatients.DataSource = Nothing
            rptPatients.DataBind()
            Return
        End If

        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            Dim sql As New Text.StringBuilder()
            sql.AppendLine("SELECT PatientID, FullName, Age, Phone, LastVisit, ISNULL(Balance,0) AS Balance, ISNULL(PhotoPath,'default-patient.png') AS PhotoPath")
            sql.AppendLine("FROM Patients")
            Sql.AppendLine("WHERE ClinicID=@ClinicID")

            ' البحث النصي
            If Not String.IsNullOrEmpty(search) Then
                sql.AppendLine("AND (FullName LIKE @search OR Phone LIKE @search OR NationalNo LIKE @search)")
            End If

            ' الجنس
            If Not String.IsNullOrEmpty(gender) Then
                sql.AppendLine("AND Gender=@gender")
            End If

            ' العمر
            If ageFrom > 0 Then sql.AppendLine("AND Age>=@ageFrom")
            If ageTo > 0 Then sql.AppendLine("AND Age<=@ageTo")

            ' الطبيب
            If Not String.IsNullOrEmpty(doctor) Then
                sql.AppendLine("AND Referral LIKE @doctor")
            End If

            ' رقم الملف
            If Not String.IsNullOrEmpty(fileNo) Then
                sql.AppendLine("AND NationalNo LIKE @fileNo")
            End If

            ' آخر زيارة
            If includeLastVisit Then
                If lastVisitFrom.HasValue Then
                    sql.AppendLine("AND (CAST(LastVisit AS DATE)>=@lastVisitFrom OR LastVisit IS NULL)")
                End If
                If lastVisitTo.HasValue Then
                    sql.AppendLine("AND (CAST(LastVisit AS DATE)<=@lastVisitTo OR LastVisit IS NULL)")
                End If
            End If

            sql.AppendLine("ORDER BY FullName")

            Using cmd As New SqlCommand(sql.ToString(), conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                If Not String.IsNullOrEmpty(search) Then cmd.Parameters.AddWithValue("@search", "%" & search.Trim() & "%")
                If Not String.IsNullOrEmpty(gender) Then cmd.Parameters.AddWithValue("@gender", gender.Trim())
                If ageFrom > 0 Then cmd.Parameters.AddWithValue("@ageFrom", ageFrom)
                If ageTo > 0 Then cmd.Parameters.AddWithValue("@ageTo", ageTo)
                If Not String.IsNullOrEmpty(doctor) Then cmd.Parameters.AddWithValue("@doctor", "%" & doctor.Trim() & "%")
                If Not String.IsNullOrEmpty(fileNo) Then cmd.Parameters.AddWithValue("@fileNo", "%" & fileNo.Trim() & "%")
                If includeLastVisit Then
                    If lastVisitFrom.HasValue Then cmd.Parameters.AddWithValue("@lastVisitFrom", lastVisitFrom.Value.Date)
                    If lastVisitTo.HasValue Then cmd.Parameters.AddWithValue("@lastVisitTo", lastVisitTo.Value.Date)
                End If

                Dim dt As New DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)

                BindPagedData(dt)
            End Using
        End Using
    End Sub

    ' ========================== Bind Paged Data ==========================
    Private Sub BindPagedData(dt As DataTable)
        Dim totalRecords As Integer = dt.Rows.Count
        Dim totalPages As Integer = If(totalRecords > 0, Math.Ceiling(totalRecords / PageSize), 1)

        Dim query = dt.AsEnumerable().Skip((PageIndex - 1) * PageSize).Take(PageSize)
        Dim pagedData As DataTable

        If query.Any() Then
            pagedData = query.CopyToDataTable()
            lblMessage.Text = ""
        Else
            pagedData = dt.Clone()
            lblMessage.Text = "لم يتم العثور على مرضى يطابقون جميع الفلاتر. بعض المرضى قد لا تحتوي سجلاتهم على تاريخ آخر زيارة"
        End If

        rptPatients.DataSource = pagedData
        rptPatients.DataBind()

        ' Pagination
        Dim pages As New DataTable()
        pages.Columns.Add("PageNumber")
        pages.Columns.Add("IsCurrent")
        For i As Integer = 1 To totalPages
            pages.Rows.Add(i, If(i = PageIndex, True, False))
        Next
        rptPagination.DataSource = pages
        rptPagination.DataBind()
    End Sub

    ' ========================== Event Handlers ==========================
    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        PageIndex = 1

        Dim search As String = txtSearch.Text.Trim()
        Dim gender As String = ""
        If ddlGender.SelectedIndex > 0 Then gender = If(ddlGender.SelectedIndex = 1, "M", "F")

        Dim ageFrom As Integer = 0, ageTo As Integer = 0
        If Not String.IsNullOrEmpty(txtAgeFrom.Text) Then Integer.TryParse(txtAgeFrom.Text, ageFrom)
        If Not String.IsNullOrEmpty(txtAgeTo.Text) Then Integer.TryParse(txtAgeTo.Text, ageTo)

        Dim doctor As String = If(ddlDoctor.SelectedIndex > 0, ddlDoctor.SelectedValue, "")
        Dim fileNo As String = txtFileNo.Text.Trim()

        ' Last visit
        Dim includeLastVisit As Boolean = chkIncludeLastVisit.Checked
        Dim lastVisitFrom As Nullable(Of DateTime) = Nothing
        Dim lastVisitTo As Nullable(Of DateTime) = Nothing
        If includeLastVisit Then
            If Not String.IsNullOrEmpty(txtLastVisitFrom.Text) Then DateTime.TryParse(txtLastVisitFrom.Text, lastVisitFrom)
            If Not String.IsNullOrEmpty(txtLastVisitTo.Text) Then DateTime.TryParse(txtLastVisitTo.Text, lastVisitTo)
        End If

        SearchPatients(search, gender, ageFrom, ageTo, doctor, fileNo, includeLastVisit, lastVisitFrom, lastVisitTo)
    End Sub

    Protected Sub ddlPageSize_SelectedIndexChanged(sender As Object, e As EventArgs)
        PageSize = CInt(ddlPageSize.SelectedValue)
        PageIndex = 1
        LoadPatients()
    End Sub

    Protected Sub Page_Changed(sender As Object, e As CommandEventArgs)
        PageIndex = CInt(e.CommandArgument)
        LoadPatients()
    End Sub
End Class
