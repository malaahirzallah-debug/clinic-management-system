Imports System.Data.SqlClient
Public Class AddExpense
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadExpenseTypes()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    Private Sub LoadExpenseTypes()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT ExpenseTypeID, TypeName FROM ExpenseTypes WHERE ClinicID=@ClinicID ORDER BY TypeName", conn)
            cmd.Parameters.AddWithValue("@ClinicID", Session("ClinicID"))
            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            ddlExpenseType.Items.Clear()
            ddlExpenseType.Items.Add(New ListItem("-- اختر النوع --", ""))
            While reader.Read()
                ddlExpenseType.Items.Add(New ListItem(reader("TypeName").ToString(), reader("ExpenseTypeID").ToString()))
            End While
            reader.Close()
        End Using
    End Sub


    Protected Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Dim clinicId As Integer = Convert.ToInt32(Session("ClinicID"))
        Dim expenseDate As Date
        If Not Date.TryParse(txtPayDate.Text, expenseDate) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('رجاءً أدخل تاريخ صالح');", True)
            Exit Sub
        End If

        Dim paymentMethod As String = ddlPaymentMethod.SelectedValue
        Dim amount As Decimal
        If Not Decimal.TryParse(txtAmount.Text, amount) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('رجاءً أدخل مبلغ صالح');", True)
            Exit Sub
        End If
        Dim notes As String = txtNotes.Text

        Using conn As New SqlConnection(connStr)
            conn.Open()

            Dim expenseTypeID As Integer

            ' تحقق إذا المستخدم كتب نوع جديد
            If Not String.IsNullOrEmpty(txtNewExpenseType.Text.Trim()) Then
                Dim newTypeName As String = txtNewExpenseType.Text.Trim()

                ' تحقق إذا النوع موجود مسبقاً لتجنب التكرار
                Dim checkCmd As New SqlCommand("SELECT ExpenseTypeID FROM ExpenseTypes WHERE ClinicID=@ClinicID AND TypeName=@TypeName", conn)
                checkCmd.Parameters.AddWithValue("@ClinicID", clinicId)
                checkCmd.Parameters.AddWithValue("@TypeName", newTypeName)
                Dim existingID As Object = checkCmd.ExecuteScalar()

                If existingID IsNot Nothing Then
                    expenseTypeID = Convert.ToInt32(existingID)
                Else
                    ' إدراج النوع الجديد
                    Dim insertTypeCmd As New SqlCommand("INSERT INTO ExpenseTypes (ClinicID, TypeName, CreatedAt) OUTPUT INSERTED.ExpenseTypeID VALUES (@ClinicID, @TypeName, GETDATE())", conn)
                    insertTypeCmd.Parameters.AddWithValue("@ClinicID", clinicId)
                    insertTypeCmd.Parameters.AddWithValue("@TypeName", newTypeName)
                    expenseTypeID = Convert.ToInt32(insertTypeCmd.ExecuteScalar())
                End If
            Else
                ' استخدم النوع المختار من الدروب داون
                If String.IsNullOrEmpty(ddlExpenseType.SelectedValue) Then
                    ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('رجاءً اختر نوع المصروف');", True)
                    Exit Sub
                End If
                expenseTypeID = Convert.ToInt32(ddlExpenseType.SelectedValue)
            End If

            ' إدراج المصروف
            Dim query As String = "INSERT INTO Expenses (ClinicID, ExpenseDate, ExpenseTypeID, PaymentMethod, Amount, Notes, CreatedAt) " &
                              "VALUES (@ClinicID, @ExpenseDate, @ExpenseTypeID, @PaymentMethod, @Amount, @Notes, GETDATE())"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ClinicID", clinicId)
                cmd.Parameters.AddWithValue("@ExpenseDate", expenseDate)
                cmd.Parameters.AddWithValue("@ExpenseTypeID", expenseTypeID)
                cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod)
                cmd.Parameters.AddWithValue("@Amount", amount)
                cmd.Parameters.AddWithValue("@Notes", notes)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        ClientScript.RegisterStartupScript(Me.GetType(), "saved", "alert('✅ تم حفظ المصروف بنجاح'); window.location='AddExpense.aspx';", True)
    End Sub

    Protected Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Response.Redirect("HomePage.aspx")
    End Sub
End Class