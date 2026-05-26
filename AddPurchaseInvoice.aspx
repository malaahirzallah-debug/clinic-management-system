<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="AddPurchaseInvoice.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.AddPurchaseInvoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .form-container {
            max-width: 950px;
            margin: 30px auto;
            padding: 20px;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            font-family: "Segoe UI", Tahoma, sans-serif;
            direction: rtl;
            text-align: right;
        }

        .form-title {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 25px;
            color: #2c3e50;
        }

        .form-group {
            margin-bottom: 16px;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
        }

            .form-group label {
                font-weight: 600;
                margin-bottom: 6px;
                width: 180px;
            }

            .form-group input, .form-group select, .form-group textarea {
                flex: 1;
                padding: 8px 12px;
                border-radius: 8px;
                border: 1px solid #ccc;
                font-size: 14px;
            }

        .form-actions {
            text-align: center;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 22px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            margin: 5px;
            transition: 0.3s;
        }

        .btn-save {
            background-color: #28a745;
            color: #fff;
        }

            .btn-save:hover {
                background-color: #218838;
            }

        .btn-close {
            background-color: #dc3545;
            color: #fff;
        }

            .btn-close:hover {
                background-color: #b52a37;
            }

        .invoice-grid {
            margin-top: 20px;
            width: 100%;
            border-collapse: collapse;
        }

            .invoice-grid th, .invoice-grid td {
                border: 1px solid #ccc;
                padding: 8px;
            }

            .invoice-grid th {
                background-color: #f5f5f5;
            }

        .total-row {
            font-weight: bold;
            background-color: #f0f8ff;
        }

        .invoice-grid .btn-close {
            padding: 4px 10px; /* أقل padding لتناسب الجدول */
            font-size: 12px; /* حجم أصغر ليناسب الأعمدة */
            display: inline-block;
            vertical-align: middle;
        }

        .invoice-grid td {
            text-align: center; /* يجعل كل شيء مركزي داخل الخلايا */
            vertical-align: middle;
        }
    </style>

    <div class="form-container">
        <div class="form-title">إضافة فاتورة مشتريات</div>

        <div class="form-group">
            <label for="ddlSupplier">المورد:</label>
            <asp:DropDownList ID="ddlSupplier" runat="server" CssClass="form-control">
                <asp:ListItem Text="-- اختر المورد --" Value="" />
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <label for="txtInvoiceNo">رقم الفاتورة:</label>
            <asp:TextBox ID="txtInvoiceNo" runat="server" CssClass="form-control" />
        </div>

        <div class="form-group">
            <label for="txtInvoiceDate">التاريخ:</label>
            <asp:TextBox ID="txtInvoiceDate" runat="server" CssClass="form-control" TextMode="Date" />
        </div>

        <div class="form-group">
            <label for="ddlPaymentMethod">طريقة الدفع:</label>
            <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="form-control">
                <asp:ListItem Text="كاش" Value="Cash" />
                <asp:ListItem Text="تحويل بنكي" Value="Bank" />
                <asp:ListItem Text="بطاقة" Value="Card" />
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <label for="txtNotes">ملاحظات:</label>
            <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
        </div>

        <!-- صف الإدخال للبنود -->
        <table class="invoice-grid">
            <tr>
                <th>رقم الصنف</th>
                <th>اسم الصنف</th>
                <th>الكمية</th>
                <th>السعر الفردي</th>
                <th>الضريبة %</th>
                <th>المجموع</th>
                <th>أفعال</th>
            </tr>
            <tr>
                <td>
                    <asp:TextBox ID="txtItemCode" runat="server" CssClass="form-control" /></td>
                <td>
                    <asp:TextBox ID="txtItemName" runat="server" CssClass="form-control" /></td>
                <td>
                    <asp:TextBox ID="txtQty" runat="server" CssClass="form-control" /></td>
                <td>
                    <asp:TextBox ID="txtUnitPrice" runat="server" CssClass="form-control" /></td>
                <td>
                    <asp:TextBox ID="txtTax" runat="server" CssClass="form-control" /></td>
                <td>
                    <asp:TextBox ID="txtTotal" runat="server" CssClass="form-control" ReadOnly="true" /></td>
                <td>
                    <asp:Button ID="btnAdd" runat="server" Text="➕ إضافة" CssClass="btn btn-save" OnClick="btnAdd_Click" /></td>
            </tr>
        </table>

        <asp:GridView ID="gvInvoice" runat="server" AutoGenerateColumns="False" CssClass="invoice-grid"
            OnRowCommand="gvInvoice_RowCommand">
            <Columns>
                <asp:BoundField DataField="ItemCode" HeaderText="رقم الصنف" />
                <asp:BoundField DataField="ItemName" HeaderText="اسم الصنف" />
                <asp:BoundField DataField="Qty" HeaderText="الكمية" />
                <asp:BoundField DataField="UnitPrice" HeaderText="السعر الفردي" DataFormatString="{0:N2}" />
                <asp:BoundField DataField="Tax" HeaderText="الضريبة %" DataFormatString="{0:N2}" />
                <asp:BoundField DataField="Total" HeaderText="المجموع" DataFormatString="{0:N2}" />
                <asp:TemplateField HeaderText="أحداث">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server" CommandName="DeleteRow"
                            CommandArgument='<%# Container.DataItemIndex %>'
                            Text="❌ حذف" CssClass="btn btn-close" ButtonType="Button" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <div style="text-align: right; margin-top: 10px;">
            <strong>قيمة الضريبة: </strong>
            <asp:Label ID="lblTotalTax" runat="server" Text="0.00"></asp:Label>
        </div>

        <div style="text-align: right; margin-top: 10px;">
            <strong>المجموع الكلي: </strong>
            <asp:Label ID="lblGrandTotal" runat="server" Text="0.00"></asp:Label>
        </div>

        <div class="form-actions">
            <asp:Button ID="btnSaveInvoice" runat="server" Text="💾 حفظ الفاتورة" CssClass="btn btn-save" OnClick="btnSaveInvoice_Click" />
            <asp:Button ID="btnClose" runat="server" Text="❌ إغلاق" CssClass="btn btn-close" OnClientClick="window.location='HomePage.aspx'; return false;" />
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
    <link href="https://code.jquery.com/ui/1.13.2/themes/smoothness/jquery-ui.css" rel="stylesheet" />

    <script type="text/javascript">
        function calculateTotal() {
            var qty = parseFloat($('#<%= txtQty.ClientID %>').val()) || 0;
            var price = parseFloat($('#<%= txtUnitPrice.ClientID %>').val()) || 0;
            var tax = parseFloat($('#<%= txtTax.ClientID %>').val()) || 0;

            var totalWithoutTax = qty * price;
            var taxValue = totalWithoutTax * tax / 100;
            var total = totalWithoutTax + taxValue;

            $('#<%= txtTotal.ClientID %>').val(total.toFixed(2));
        }


        // تحديث المجموع عند أي تغيير في الكمية أو السعر أو الضريبة
        $('#<%= txtQty.ClientID %>, #<%= txtUnitPrice.ClientID %>, #<%= txtTax.ClientID %>').on('input', calculateTotal);

        // autocomplete لرقم الصنف
        $('#<%= txtItemCode.ClientID %>').autocomplete({
            source: 'GetItems.ashx',
            minLength: 1,
            select: function (event, ui) {
                $('#<%= txtItemCode.ClientID %>').val(ui.item.ItemCode);
                $('#<%= txtItemName.ClientID %>').val(ui.item.ItemName);
                $('#<%= txtUnitPrice.ClientID %>').val(ui.item.UnitPrice);
                $('#<%= txtTax.ClientID %>').val(ui.item.TaxRate);
                calculateTotal();
                return false;
            }
        }).autocomplete("instance")._renderItem = function (ul, item) {
            return $("<li>")
                .append("<div>" + item.ItemCode + " - " + item.ItemName + " (السعر: " + item.UnitPrice + ", الضريبة: " + item.TaxRate + "%)</div>")
                .appendTo(ul);
        };

        // autocomplete لاسم الصنف
        $('#<%= txtItemName.ClientID %>').autocomplete({
            source: 'GetItems.ashx',
            minLength: 1,
            select: function (event, ui) {
                $('#<%= txtItemCode.ClientID %>').val(ui.item.ItemCode);
                $('#<%= txtItemName.ClientID %>').val(ui.item.ItemName);
                $('#<%= txtUnitPrice.ClientID %>').val(ui.item.UnitPrice);
                $('#<%= txtTax.ClientID %>').val(ui.item.TaxRate);
                calculateTotal();
                return false;
            }
        }).autocomplete("instance")._renderItem = function (ul, item) {
            return $("<li>")
                .append("<div>" + item.ItemName + " - " + item.ItemCode + " (السعر: " + item.UnitPrice + ", الضريبة: " + item.TaxRate + "%)</div>")
                .appendTo(ul);
        };
    </script>


</asp:Content>
