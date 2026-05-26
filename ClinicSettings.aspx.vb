Imports System.Data.SqlClient

Public Class ClinicSettings
    Inherits System.Web.UI.Page

    Private ReadOnly connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If

        If Not IsPostBack Then
            BindClinicTypes()
            LoadSelectedTypes()
            LoadUsers()
        End If
    End Sub

    ' ربط CheckBoxList بالأنواع الثابتة
    Private Sub BindClinicTypes()
        chkClinicTypes.Items.Clear()
        chkClinicTypes.Items.Add(New ListItem("أسنان", "1"))
        chkClinicTypes.Items.Add(New ListItem("علاج طبيعي", "2"))
        chkClinicTypes.Items.Add(New ListItem("أخرى", "3"))
    End Sub

    ' تحميل الأنواع المختارة مسبقًا من قاعدة البيانات
    Private Sub LoadSelectedTypes()
        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            Dim sql As String = "SELECT TypeValue FROM ClinicSelectedTypes WHERE ClinicID=@ClinicID"
            Using cmd As New SqlCommand(sql, conn)
                cmd.Parameters.Add("@ClinicID", SqlDbType.Int).Value = clinicID
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        For Each item As ListItem In chkClinicTypes.Items
                            If item.Value = reader("TypeValue").ToString() Then
                                item.Selected = True
                            End If
                        Next
                    End While
                End Using
            End Using
        End Using
    End Sub

    Protected Sub ddlRoles_SelectedIndexChanged(sender As Object, e As EventArgs)
        ' يمكنك إضافة أي كود تحتاجه عند تغيير الدور
    End Sub


    ' حفظ الأنواع المختارة
    Protected Sub btnSaveSettings_Click(sender As Object, e As EventArgs) Handles btnSaveSettings.Click
        If Session("ClinicID") Is Nothing Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "snackbar", "alert('خطأ: لم يتم التعرف على العيادة');", True)
            Return
        End If

        Dim clinicID As Integer = Convert.ToInt32(Session("ClinicID"))

        Using conn As New SqlConnection(connStr)
            conn.Open()
            Dim transaction = conn.BeginTransaction()

            Try
                ' حذف الخيارات القديمة أولاً
                Using deleteCmd As New SqlCommand("DELETE FROM ClinicSelectedTypes WHERE ClinicID=@ClinicID", conn, transaction)
                    deleteCmd.Parameters.Add("@ClinicID", SqlDbType.Int).Value = clinicID
                    deleteCmd.ExecuteNonQuery()
                End Using

                ' إدخال الأنواع الجديدة دفعة واحدة
                Using insertCmd As New SqlCommand("INSERT INTO ClinicSelectedTypes (ClinicID, TypeValue) VALUES (@ClinicID, @TypeValue)", conn, transaction)
                    insertCmd.Parameters.Add("@ClinicID", SqlDbType.Int).Value = clinicID
                    insertCmd.Parameters.Add("@TypeValue", SqlDbType.Int)

                    For Each item As ListItem In chkClinicTypes.Items
                        If item.Selected Then
                            insertCmd.Parameters("@TypeValue").Value = Convert.ToInt32(item.Value)
                            insertCmd.ExecuteNonQuery()
                        End If
                    Next
                End Using

                transaction.Commit()


                Dim selectedUserID As Integer = Convert.ToInt32(ddlUsers.SelectedValue)
                Dim selectedRoleID As Integer = Convert.ToInt32(ddlRoles.SelectedValue)

        If selectedUserID = 0 Or selectedRoleID = 0 Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('اختر المستخدم والدور أولاً');", True)
            Return
        End If

                ' مسح الصلاحيات القديمة
                Using cmdDelete As New SqlCommand("DELETE FROM UserPermissions WHERE UserID=@UserID AND RoleID=@RoleID AND ClinicID=@ClinicID", conn)
                        cmdDelete.Parameters.AddWithValue("@UserID", selectedUserID)
                        cmdDelete.Parameters.AddWithValue("@RoleID", selectedRoleID)
                        cmdDelete.Parameters.AddWithValue("@ClinicID", clinicID)
                        cmdDelete.ExecuteNonQuery()
                    End Using

                    ' جمع الصلاحيات المحددة
                    Dim permissions As New List(Of String)
                    GetCheckedPermissions(Me, permissions)

                    ' حفظ الصلاحيات الجديدة
                    Using cmdInsert As New SqlCommand("INSERT INTO UserPermissions (ClinicID, UserID, RoleID, PermissionKey, IsAllowed, CreatedAt, UpdatedAt) VALUES (@ClinicID, @UserID, @RoleID, @PermissionKey, @IsAllowed, GETDATE(), GETDATE())", conn)
                        cmdInsert.Parameters.Add("@ClinicID", SqlDbType.Int)
                        cmdInsert.Parameters.Add("@UserID", SqlDbType.Int)
                        cmdInsert.Parameters.Add("@RoleID", SqlDbType.Int)
                        cmdInsert.Parameters.Add("@PermissionKey", SqlDbType.NVarChar, 100)
                        cmdInsert.Parameters.Add("@IsAllowed", SqlDbType.Bit)

                        For Each perm As String In permissions
                            cmdInsert.Parameters("@ClinicID").Value = clinicID
                            cmdInsert.Parameters("@UserID").Value = selectedUserID
                            cmdInsert.Parameters("@RoleID").Value = selectedRoleID
                            cmdInsert.Parameters("@PermissionKey").Value = perm
                            cmdInsert.Parameters("@IsAllowed").Value = True
                            cmdInsert.ExecuteNonQuery()
                        Next
                    End Using
                Dim newSessionID As String = Guid.NewGuid().ToString() ' رقم جديد

                Using cmd As New SqlCommand("UPDATE Users SET CurrentSessionID=@NewSessionID WHERE UserID=@UserID AND ClinicID=@ClinicID", conn)
                        cmd.Parameters.AddWithValue("@NewSessionID", newSessionID)
                        cmd.Parameters.AddWithValue("@UserID", selectedUserID)
                    cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                    cmd.ExecuteNonQuery()
                    End Using

                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('تم الحفظ بنجاح');", True)

            Catch ex As Exception
            transaction.Rollback()
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "snackbar", $"alert('خطأ أثناء الحفظ: {ex.Message}');", True)
            End Try
        End Using
    End Sub

    Private Sub GetCheckedPermissions(parent As Control, ByRef permissions As List(Of String))
        For Each c As Control In parent.Controls
            If TypeOf c Is CheckBox Then
                Dim chk As CheckBox = DirectCast(c, CheckBox)
                If chk.Checked AndAlso Not String.IsNullOrEmpty(chk.ID) Then
                    permissions.Add(chk.ID)
                End If
            End If
            ' recurse
            If c.HasControls() Then
                GetCheckedPermissions(c, permissions)
            End If
        Next
    End Sub

    Private Sub LoadUsers()
        ddlUsers.Items.Clear()
        ddlUsers.Items.Add(New ListItem("-- اختر مستخدم --", "0"))

        Dim clinicID As Integer = 0
        If Session("ClinicID") IsNot Nothing Then
            clinicID = Convert.ToInt32(Session("ClinicID"))
        End If

        If clinicID = 0 Then Exit Sub

        Using con As New SqlConnection(connStr)
            con.Open()
            Dim sql As String = "SELECT UserID, UserName FROM Users WHERE ClinicID=@ClinicID ORDER BY UserName"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)
                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    While rdr.Read()
                        ddlUsers.Items.Add(New ListItem(rdr("UserName").ToString(), rdr("UserID").ToString()))
                    End While
                End Using
            End Using
        End Using
    End Sub

    Protected Sub ddlUsers_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim selectedUserID As Integer = Convert.ToInt32(ddlUsers.SelectedValue)
        If selectedUserID > 0 Then
            LoadUserPermissions(selectedUserID)
        Else
            ' إعادة تعيين الشجرة والدور إذا لم يتم اختيار مستخدم
            ddlRoles.SelectedValue = "0"
            ClearPermissionTree()
        End If
    End Sub

    Private Sub LoadUserPermissions(userID As Integer)
        ' أولًا نعيد تعيين كل الصلاحيات
        ClearPermissionTree()
        ddlRoles.SelectedValue = "0"

        Dim clinicID As Integer = 0
        If Session("ClinicID") IsNot Nothing Then
            clinicID = Convert.ToInt32(Session("ClinicID"))
        End If

        If clinicID = 0 Then Exit Sub

        Using con As New SqlConnection(connStr)
            con.Open()
            Dim sql As String = "SELECT RoleID, PermissionKey, IsAllowed FROM UserPermissions WHERE UserID=@UserID AND ClinicID=@ClinicID"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@UserID", userID)
                cmd.Parameters.AddWithValue("@ClinicID", clinicID)

                Using rdr As SqlDataReader = cmd.ExecuteReader()
                    While rdr.Read()
                        ' ضبط الدور
                        ddlRoles.SelectedValue = rdr("RoleID").ToString()

                        ' ضبط الصلاحيات
                        Dim key As String = rdr("PermissionKey").ToString()
                        Dim isAllowed As Boolean = Convert.ToBoolean(rdr("IsAllowed"))

                        ' نبحث عن الـ CheckBox حسب القيمة Value
                        Dim chk As CheckBox = FindCheckBoxByID(key)
                        If chk IsNot Nothing Then
                            chk.Checked = isAllowed
                        End If
                    End While
                End Using
            End Using
        End Using
    End Sub


    Private Sub ClearPermissionTree()
        ' إعادة تعيين كل الـ CheckBoxes إلى غير محدد
        ClearCheckBoxesRecursive(Me.Page)
    End Sub

    Private Sub ClearCheckBoxesRecursive(ctrl As Control)
        For Each c As Control In ctrl.Controls
            If TypeOf c Is CheckBox Then
                DirectCast(c, CheckBox).Checked = False
            End If
            If c.HasControls() Then
                ClearCheckBoxesRecursive(c)
            End If
        Next
    End Sub

    Private Function FindCheckBoxByID(id As String) As CheckBox
        Return FindCheckBoxRecursive(Me.Page, id)
    End Function

    Private Function FindCheckBoxRecursive(ctrl As Control, id As String) As CheckBox
        For Each c As Control In ctrl.Controls
            If TypeOf c Is CheckBox Then
                Dim chk As CheckBox = DirectCast(c, CheckBox)
                If chk.ID = id Then
                    Return chk
                End If
            End If
            If c.HasControls() Then
                Dim found As CheckBox = FindCheckBoxRecursive(c, id)
                If found IsNot Nothing Then Return found
            End If
        Next
        Return Nothing
    End Function

    Protected Sub btnCancelSettings_Click(sender As Object, e As EventArgs) Handles btnCancelSettings.Click
        Response.Redirect("HomePage.aspx")
    End Sub
End Class
