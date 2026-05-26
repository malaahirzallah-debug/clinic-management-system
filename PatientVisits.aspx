<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="PatientVisits.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.PatientVisits" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="patient-details-container">
        <!-- بيانات المريض -->
        <div class="patient-header">
            <h2>🧾 بيانات المريض</h2>
            <div class="patient-info">
                <p>
                    <strong>رقم الملف:</strong>
                    <asp:Label ID="lblPatientID" runat="server"></asp:Label>
                </p>
                <p>
                    <strong>الاسم:</strong>
                    <asp:Label ID="lblName" runat="server"></asp:Label>
                </p>
                <p>
                    <strong>الرقم الوطني:</strong>
                    <asp:Label ID="lblNationalID" runat="server"></asp:Label>
                </p>
                <p>
                    <strong>الهاتف:</strong>
                    <asp:Label ID="lblPhone" runat="server"></asp:Label>
                </p>
                <p>
                    <strong>الهاتف الاحتياطي:</strong>
                    <asp:Label ID="lblAltPhone" runat="server"></asp:Label>
                </p>
            </div>
        </div>

        <!-- الأزرار -->
        <div class="patient-actions">
            <asp:LinkButton ID="btnLast5Visits" runat="server" CssClass="patient-btn" OnClick="btnLast5Visits_Click">
                📑 تقرير آخر 5 زيارات
            </asp:LinkButton>

            <asp:LinkButton ID="btnTreatmentPlan" runat="server" CssClass="patient-btn" OnClick="btnTreatmentPlan_Click">
                الخطة العلاجية
            </asp:LinkButton>

            <asp:LinkButton ID="btnAttachments" runat="server" CssClass="patient-btn" OnClick="btnAttachments_Click">
                📷 المرفقات
            </asp:LinkButton>

            <asp:LinkButton ID="btnBack" runat="server" CssClass="patient-btn" OnClick="btnBack_Click">
    ⬅️ رجوع
            </asp:LinkButton>

        </div>

        <!-- تقرير آخر 5 زيارات -->
        <div id="divLast5Visits" runat="server" class="mini-visits-container">
            <asp:Repeater ID="rptLast5Visits" runat="server">
                <ItemTemplate>
                    <div class="mini-visit">
                        <p><strong>📅 التاريخ:</strong> <%# Convert.ToDateTime(Eval("VisitDate")).ToString("dd/MM/yyyy") %></p>
                        <p><strong>📝 الإجراءات:</strong> <%# Eval("MedicalReport") %></p>
                        <p><strong>💊 الأدوية:</strong> <%# Eval("Medicines") %></p>
                        <hr />
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Button ID="btnPrintLast5"
                runat="server"
                CssClass="patient-btn print-hide"
                Text="🖨️ طباعة الزيارات"
                OnClientClick="printSection(); return false;"
                Visible="False" />
        </div>

        <!-- الزيارات السابقة -->
        <div class="visits-section">
            <h3>📂 الزيارات السابقة</h3>

            <asp:Label ID="lblNoVisits" runat="server" CssClass="no-visits" Text="لا يوجد زيارات سابقة" Visible="False"></asp:Label>

            <asp:Repeater ID="visitsRepeater" runat="server">
                <ItemTemplate>
                    <div class="visit-card">
                        <div class="visit-info">
                            <p><strong>📅 تاريخ الزيارة:</strong> <%# Convert.ToDateTime(Eval("VisitDate")).ToString("dd/MM/yyyy") %></p>
                            <p><strong>📝 الإجراءات:</strong> <%# Eval("MedicalReport") %></p>
                            <p><strong>💊 الأدوية:</strong> <%# Eval("Medicines") %></p>
                            <p><strong>💵 قيمة الجلسة:</strong> <%# Eval("VisitAmount") %> دينار</p>
                            <p><strong>✅ المدفوع:</strong> <%# Eval("PaidAmount") %> دينار</p>
                            <p><strong>💳 طريقة الدفع:</strong> <%# Eval("PaymentMethod") %></p>
                        </div>
                        <asp:LinkButton ID="lnkDetails" runat="server"
                            CssClass="patient-btn view-btn"
                            CommandArgument='<%# Eval("VisitID") & "|" & Eval("PatientID") %>'
                            CommandName="ViewDetails">
                            👁️ عرض التفاصيل
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <script type="text/javascript">
        function printSection() {
            // نسخ محتوى الـ div
            var divContents = document.getElementById('<%= divLast5Visits.ClientID %>').cloneNode(true);

            // إزالة أي زر داخل الـ div قبل الطباعة
            var buttons = divContents.querySelectorAll("button, .print-hide");
            buttons.forEach(btn => btn.remove());

            var printWindow = window.open('', '', 'height=700,width=900');
            printWindow.document.write('<html><head><title>طباعة آخر 5 زيارات</title>');
            printWindow.document.write('<style>');
            printWindow.document.write('body { font-family: Tahoma, sans-serif; direction: rtl; text-align: right; }');
            printWindow.document.write('.mini-visits-container { border: 1px solid #ccc; padding: 15px; border-radius: 12px; background:#fff; }');
            printWindow.document.write('.mini-visit { margin-bottom: 10px; }');
            printWindow.document.write('.mini-visit:last-child hr { display:none; }');
            printWindow.document.write('</style></head><body>');
            printWindow.document.write('<h2 style="text-align:center;">📑 تقرير آخر 5 زيارات</h2>');
            printWindow.document.write(divContents.innerHTML);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }

    </script>
    <!-- CSS -->
    <style>
        .patient-details-container {
            width: 90%;
            margin: 20px auto;
            font-family: "Tahoma", sans-serif;
            color: #333;
        }

        .patient-header {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .patient-info p {
            margin: 5px 0;
        }

        .patient-actions {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .patient-btn {
            background: #0078d7;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
            font-size: 14px;
            text-decoration: none;
        }

            .patient-btn:hover {
                background: #005fa3;
            }

        .print-btn {
            margin-top: 15px;
            background: #444;
        }

        .visits-section {
            margin-top: 30px;
        }

        .visit-card {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            flex-wrap: wrap;
        }

        .visit-info {
            flex: 1;
            min-width: 250px;
        }

            .visit-info p {
                margin: 4px 0;
            }

        .view-btn {
            background: #28a745;
            padding: 8px 12px;
            margin-top: 10px;
        }

        .no-visits {
            text-align: center;
            font-size: 16px;
            color: #777;
            margin-top: 20px;
        }

        .last5visits-card {
            background: #fdfdfd;
            border: 1px solid #ccc;
            border-radius: 12px;
            padding: 15px;
            margin-top: 20px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .mini-visits-container {
            border: 1px solid #ccc;
            border-radius: 12px;
            padding: 15px;
            margin-top: 10px;
            background: #fff;
        }

        .mini-visit {
            margin-bottom: 10px;
        }

            .mini-visit:last-child hr {
                display: none; /* يخفي الخط الفاصل بعد آخر زيارة */
            }

        @media (max-width: 768px) {
            .visit-card {
                flex-direction: column;
                text-align: center;
            }

            .visit-info {
                margin-bottom: 10px;
            }
        }

        @media print {
            .print-hide {
                display: none !important;
            }
        }
    </style>
</asp:Content>



