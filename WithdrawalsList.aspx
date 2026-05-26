<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="WithdrawalsList.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.WithdrawalsList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .table-container {
            max-width: 1000px;
            margin: 24px auto;
            padding: 16px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            color: #333;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            box-sizing: border-box;
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            min-width: 700px;
        }

        .table th, .table td {
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            font-size: 14px;
        }

        .table th {
            background-color: #f4f6f8;
            color: #2c3e50;
        }

        .btn-action {
            padding: 6px 14px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 13px;
            color: #fff;
            transition: 0.3s;
            margin: 2px 0;
        }

        .btn-edit { background-color: #e67e22; }
        .btn-edit:hover { background-color: #cf6c17; }

        .btn-delete { background-color: #d9534f; }
        .btn-delete:hover { background-color: #c12e2a; }

        @media (max-width:768px) {
            .table th, .table td {
                padding: 8px 6px;
                font-size: 12px;
            }

            /* يمكن إخفاء أعمدة ثانوية لتوفير مساحة */
            .table th:nth-child(2), /* ClinicID */
            .table td:nth-child(2),
            .table th:nth-child(5), /* Details */
            .table td:nth-child(5),
            .table th:nth-child(8), /* Notes */
            .table td:nth-child(8) {
                display: none;
            }

            .btn-action {
                font-size: 11px;
                padding: 4px 8px;
            }
        }
        .btn-back {
        background-color: #b0b0b0; /* لون سكني */
        color: #fff; /* نص أبيض */
        padding: 10px 20px;
        border-radius: 10px;
        border: none;
        cursor: pointer;
        transition: 0.3s;
    }

    .btn-back:hover {
        background-color: #999999; /* ظل أغمق عند المرور */
    }
    </style>

    <div class="table-container">
        <h2 style="text-align:center; margin-bottom:20px;">المسحوبات</h2>

        <asp:GridView ID="gvWithdrawals" runat="server" AutoGenerateColumns="False" CssClass="table">
            <Columns>
                <asp:BoundField DataField="WithdrawalID" HeaderText="رقم المسحوب" ReadOnly="True" />
                <asp:BoundField DataField="ClinicID" HeaderText="رقم العيادة" />
                <asp:BoundField DataField="WithdrawalDate" HeaderText="تاريخ المسحوب" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField DataField="WithdrawalType" HeaderText="نوع المسحوب" />
                <asp:BoundField DataField="Details" HeaderText="تفاصيل" />
                <asp:BoundField DataField="Amount" HeaderText="المبلغ" DataFormatString="{0:N2}" />
                <asp:BoundField DataField="PaymentMethod" HeaderText="طريقة الدفع" />
                <asp:BoundField DataField="Notes" HeaderText="ملاحظات" />
                <asp:BoundField DataField="CreatedAt" HeaderText="تاريخ الإنشاء" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
            </Columns>
        </asp:GridView>
        <asp:Button ID="btnBack" runat="server" CssClass="btn-back" Text="⬅ رجوع" PostBackUrl="EmployeesList.aspx" />
    </div>
</asp:Content>
