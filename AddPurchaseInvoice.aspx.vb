Imports System.Data
Imports System.Data.SqlClient
Public Class AddPurchaseInvoice
    Inherits System.Web.UI.Page
    Dim connStr As String = System.Configuration.ConfigurationManager.ConnectionStrings("ClinicDashboardDB").ConnectionString

    Private Property InvoiceItems As DataTable
        Get
            If ViewState("InvoiceItems") Is Nothing Then
                Dim dt As New DataTable()
                dt.Columns.Add("ItemCode")
                dt.Columns.Add("ItemName")
                dt.Columns.Add("Qty", GetType(Decimal))
                dt.Columns.Add("UnitPrice", GetType(Decimal))
                dt.Columns.Add("Tax", GetType(Decimal))
                dt.Columns.Add("Total", GetType(Decimal))
                ViewState("InvoiceItems") = dt
            End If
            Return DirectCast(ViewState("InvoiceItems"), DataTable)
        End Get
        Set(value As DataTable)
            ViewState("InvoiceItems") = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadSuppliers()
            gvInvoice.DataSource = InvoiceItems
            gvInvoice.DataBind()
        End If
        If Session("ClinicID") Is Nothing OrElse Session("ClinicID").ToString() = "" Then
            Response.Redirect("LoginPage.aspx")
            Return
        End If
    End Sub

    ' إضافة بند جديد للفاتورة
    Protected Sub btnAdd_Click(sender As Object, e As EventArgs)
        Try
            Dim dt As DataTable = InvoiceItems
            Dim total As Decimal = 0
            Dim qty As Decimal = If(String.IsNullOrEmpty(txtQty.Text), 0, Convert.ToDecimal(txtQty.Text))
            Dim unitPrice As Decimal = If(String.IsNullOrEmpty(txtUnitPrice.Text), 0, Convert.ToDecimal(txtUnitPrice.Text))
            Dim tax As Decimal = If(String.IsNullOrEmpty(txtTax.Text), 0, Convert.ToDecimal(txtTax.Text))
            total = qty * unitPrice * (1 + tax / 100)

            Dim dr As DataRow = dt.NewRow()
            dr("ItemCode") = txtItemCode.Text
            dr("ItemName") = txtItemName.Text
            dr("Qty") = qty
            dr("UnitPrice") = unitPrice
            dr("Tax") = tax
            dr("Total") = total

            dt.Rows.Add(dr)
            InvoiceItems = dt

            gvInvoice.DataSource = dt
            gvInvoice.DataBind()
            UpdateTotals()

            ' مسح حقول الإدخال
            txtItemCode.Text = ""
            txtItemName.Text = ""
            txtQty.Text = ""
            txtUnitPrice.Text = ""
            txtTax.Text = ""
            txtTotal.Text = ""

        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('حدث خطأ: " & ex.Message.Replace("'", "") & "');", True)
        End Try
    End Sub

    ' حفظ الفاتورة مع البنود
    Protected Sub btnSaveInvoice_Click(sender As Object, e As EventArgs)
        Try
            Dim clinicId As Integer = Convert.ToInt32(Session("ClinicID"))
            Dim supplierId As Integer = Convert.ToInt32(ddlSupplier.SelectedValue)
            Dim invoiceNo As String = txtInvoiceNo.Text
            Dim invoiceDate As Date = Date.Parse(txtInvoiceDate.Text)
            Dim paymentMethod As String = ddlPaymentMethod.SelectedValue
            Dim notes As String = txtNotes.Text

            Using conn As New SqlConnection(connStr)
                conn.Open()
                Dim trans As SqlTransaction = conn.BeginTransaction()

                Dim cmdInvoice As New SqlCommand(
"INSERT INTO PurchaseInvoices (ClinicID, SupplierID, InvoiceNo, InvoiceDate, PaymentMethod, Notes, TotalTax, GrandTotal, CreatedAt) 
 VALUES (@ClinicID, @SupplierID, @InvoiceNo, @InvoiceDate, @PaymentMethod, @Notes, @TotalTax, @GrandTotal, GETDATE());
 SELECT SCOPE_IDENTITY()", conn, trans)

                cmdInvoice.Parameters.AddWithValue("@TotalTax", Convert.ToDecimal(lblTotalTax.Text))
                cmdInvoice.Parameters.AddWithValue("@GrandTotal", Convert.ToDecimal(lblGrandTotal.Text))
                cmdInvoice.Parameters.AddWithValue("@ClinicID", clinicId)
                cmdInvoice.Parameters.AddWithValue("@SupplierID", supplierId)
                cmdInvoice.Parameters.AddWithValue("@InvoiceNo", invoiceNo)
                cmdInvoice.Parameters.AddWithValue("@InvoiceDate", invoiceDate)
                cmdInvoice.Parameters.AddWithValue("@PaymentMethod", paymentMethod)
                cmdInvoice.Parameters.AddWithValue("@Notes", notes)


                Dim invoiceId As Integer = Convert.ToInt32(cmdInvoice.ExecuteScalar())

                ' إدخال البنود
                For Each dr As DataRow In InvoiceItems.Rows
                    Dim cmdItem As New SqlCommand(
                        "INSERT INTO PurchaseInvoiceItems (InvoiceID, ClinicID, ItemCode, ItemName, Qty, UnitPrice, Tax, Total, CreatedAt) 
                         VALUES (@InvoiceID, @ClinicID, @ItemCode, @ItemName, @Qty, @UnitPrice, @Tax, @Total, GETDATE())", conn, trans)
                    cmdItem.Parameters.AddWithValue("@InvoiceID", invoiceId)
                    cmdItem.Parameters.AddWithValue("@ClinicID", clinicId)
                    cmdItem.Parameters.AddWithValue("@ItemCode", dr("ItemCode"))
                    cmdItem.Parameters.AddWithValue("@ItemName", dr("ItemName"))
                    cmdItem.Parameters.AddWithValue("@Qty", dr("Qty"))
                    cmdItem.Parameters.AddWithValue("@UnitPrice", dr("UnitPrice"))
                    cmdItem.Parameters.AddWithValue("@Tax", dr("Tax"))
                    cmdItem.Parameters.AddWithValue("@Total", dr("Total"))

                    cmdItem.ExecuteNonQuery()
                Next

                trans.Commit()
            End Using

            ' مسح البيانات بعد الحفظ
            InvoiceItems.Clear()
            gvInvoice.DataSource = InvoiceItems
            gvInvoice.DataBind()

            txtInvoiceNo.Text = ""
            txtInvoiceDate.Text = ""
            txtNotes.Text = ""
            ddlPaymentMethod.SelectedIndex = 0

            ClientScript.RegisterStartupScript(Me.GetType(), "saved", "alert('✅ تم حفظ الفاتورة بنجاح');", True)

        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('حدث خطأ: " & ex.Message.Replace("'", "") & "');", True)
        End Try
    End Sub
    Private Sub UpdateTotals()
        Dim total As Decimal = 0
        Dim totalTax As Decimal = 0

        For Each dr As DataRow In InvoiceItems.Rows
            Dim qty As Decimal = Convert.ToDecimal(dr("Qty"))
            Dim unitPrice As Decimal = Convert.ToDecimal(dr("UnitPrice"))
            Dim tax As Decimal = Convert.ToDecimal(dr("Tax"))

            ' حساب مجموع الضريبة لكل بند
            Dim lineTax As Decimal = qty * unitPrice * tax / 100
            totalTax += lineTax

            ' حساب المجموع لكل بند (السعر + الضريبة)
            total += qty * unitPrice + lineTax
        Next

        lblTotalTax.Text = totalTax.ToString("N2")
        lblGrandTotal.Text = total.ToString("N2")
    End Sub

    Protected Sub gvInvoice_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "DeleteRow" Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            InvoiceItems.Rows(index).Delete()
            gvInvoice.DataSource = InvoiceItems
            gvInvoice.DataBind()
            UpdateTotals()
        End If
    End Sub

    Private Sub LoadSuppliers()
        Using conn As New SqlConnection(connStr)
            Dim cmd As New SqlCommand("SELECT SupplierID, CompanyName FROM Suppliers WHERE ClinicID=@ClinicID ORDER BY CompanyName", conn)
            cmd.Parameters.AddWithValue("@ClinicID", Session("ClinicID"))
            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            ddlSupplier.Items.Clear()
            ddlSupplier.Items.Add(New ListItem("-- اختر المورد --", ""))
            While reader.Read()
                ddlSupplier.Items.Add(New ListItem(reader("CompanyName").ToString(), reader("SupplierID").ToString()))
            End While
        End Using
    End Sub

End Class