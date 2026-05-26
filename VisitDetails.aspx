<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="VisitDetails.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.VisitDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
        .visit-details-container {
            width: 90%;
            margin: 20px auto;
            font-family: "Tahoma", sans-serif;
            color: #333;
        }

        .visit-header {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            text-align: center;
        }

        .visit-info p {
            margin: 8px 0;
            font-size: 15px;
        }

        .visit-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        .visit-btn {
            background: #0078d7;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
            font-size: 14px;
            min-width: 140px;
        }

        .visit-btn:hover {
            background: #005fa3;
        }

        .back-btn {
            background: #6c757d;
        }

        .back-btn:hover {
            background: #545b62;
        }

        .print-btn {
            background: #28a745;
        }

        .print-btn:hover {
            background: #1f7a34;
        }

        @media (max-width: 768px) {
            .visit-info {
                font-size: 14px;
            }
            .visit-btn {
                font-size: 13px;
                padding: 8px 12px;
            }
        }
    </style>
    <div class="visit-details-container">
        <div class="visit-header">
            <h2>تفاصيل الزيارة</h2>
        </div>

        <div class="visit-info">
            <p><strong>رقم الزيارة:</strong> <asp:Label ID="lblVisitID" runat="server"></asp:Label></p>
            <p><strong>تاريخ الزيارة:</strong> <asp:Label ID="lblVisitDate" runat="server"></asp:Label></p>
            <p><strong>اسم المريض:</strong> <asp:Label ID="lblPatientName" runat="server"></asp:Label></p>
            <p><strong>الإجراءات:</strong> <asp:Label ID="lblMedicalReport" runat="server"></asp:Label></p>
            <p><strong>الأدوية:</strong> <asp:Label ID="lblMedicines" runat="server"></asp:Label></p>
            <p><strong>قيمة الجلسة:</strong> <asp:Label ID="lblVisitAmount" runat="server"></asp:Label> دينار</p>
            <p><strong>المدفوع:</strong> <asp:Label ID="lblPaidAmount" runat="server"></asp:Label> دينار</p>
            <p><strong>طريقة الدفع:</strong> <asp:Label ID="lblPaymentMethod" runat="server"></asp:Label></p>
        </div>

        <div class="visit-actions">
            <asp:Button ID="btnBack" runat="server" CssClass="visit-btn back-btn" Text="⬅️ رجوع للزيارات" />
            <asp:Button ID="btnPrint" runat="server" CssClass="visit-btn print-btn" Text="🖨️ طباعة الزيارة" />
        </div>
    </div>
</asp:Content>
