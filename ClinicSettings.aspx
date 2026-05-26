<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ClinicSettings.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.ClinicSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-5">

        <div class="text-center mb-5">
            <h2 class="fw-bold text-primary">
                <i class="bi bi-gear-fill"></i>إعدادات العيادة
            </h2>
            <p class="text-muted fs-5">تحكم بأنواع العيادة وخياراتها الأساسية وصلاحيات المستخدمين</p>
        </div>

        <div class="card shadow-sm border-0 rounded-4 mb-4">
            <div class="card-header bg-primary text-white fw-bold d-flex align-items-center">
                <i class="bi bi-list-check me-2"></i>أنواع العيادة
            </div>
            <div class="card-body">
                <asp:CheckBoxList ID="chkClinicTypes" runat="server" CssClass="form-check clinic-types-list">
                    <asp:ListItem Text="أسنان" Value="1" />
                    <asp:ListItem Text="علاج طبيعي" Value="2" />
                    <asp:ListItem Text="أخرى" Value="3" />
                </asp:CheckBoxList>
            </div>
        </div>

        <!-- بطاقة صلاحيات المستخدمين -->
        <div class="card shadow-sm border-0 rounded-4 mb-4">
            <div class="card-header bg-warning text-dark fw-bold d-flex align-items-center">
                <i class="bi bi-shield-lock me-2"></i>صلاحيات المستخدمين
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">اختر المستخدم</label>
                <asp:DropDownList ID="ddlUsers" runat="server" CssClass="form-select" AutoPostBack="True" OnSelectedIndexChanged="ddlUsers_SelectedIndexChanged">
                    <asp:ListItem Text="-- اختر مستخدم --" Value="0" />
                </asp:DropDownList>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="form-label fw-bold">اختر الدور</label>
                    <asp:DropDownList ID="ddlRoles" runat="server" CssClass="form-select" AutoPostBack="True" OnSelectedIndexChanged="ddlRoles_SelectedIndexChanged">
                        <asp:ListItem Text="-- اختر دور --" Value="0" />
                        <asp:ListItem Text="مدير" Value="1" />
                        <asp:ListItem Text="طبيب" Value="2" />
                        <asp:ListItem Text="سكرتير/ة" Value="3" />
                    </asp:DropDownList>
                </div>
                <div class="permissions-tree">

                    <ul>
                        <li>
                            <asp:CheckBox ID="chkMainDashboard" runat="server" CssClass="child" AutoPostBack="False" />
                            لوحة التحكم الرئيسية
                <ul>
                    <li>
                        <asp:CheckBox ID="chkDashboard" runat="server" CssClass="child" AutoPostBack="False" />
                        Dashboard
                    </li>
                </ul>
                        </li>
                        <!-- سجل المرضى -->
                        <li>
                            <asp:CheckBox ID="chkPatients" runat="server" CssClass="child" AutoPostBack="False" />
                            سجل المرضى
                <ul>
                    <li>
                        <asp:CheckBox ID="chkNewPatients" runat="server" CssClass="child" AutoPostBack="False" />
                        فتح سجل جديد
                    </li>
                    <li>
                        <asp:CheckBox ID="chkShowPatients" runat="server" CssClass="child" AutoPostBack="False" />
                        البحث عن بيانات المرضى
                        <ul>
                            <li>
                                <asp:CheckBox ID="btnSearch" runat="server" CssClass="child" AutoPostBack="False" />
                                زر بحث</li>
                            <li>
                                <asp:CheckBox ID="btnVisits" runat="server" CssClass="child" AutoPostBack="False" />
                                عرض الزيارات
                                <ul>
                                    <li>
                                        <asp:CheckBox ID="btnLast5Visits" runat="server" CssClass="child" AutoPostBack="False" />
                                        آخر 5 زيارات</li>
                                    <li>
                                        <asp:CheckBox ID="btnTreatmentPlan" runat="server" CssClass="child" AutoPostBack="False" />
                                        الخطة العلاجية</li>
                                    <li>
                                        <asp:CheckBox ID="btnAttachments" runat="server" CssClass="child" AutoPostBack="False" />
                                        المرفقات</li>
                                </ul>
                            </li>
                            <li>
                                <asp:CheckBox ID="btnEditPatient" runat="server" CssClass="child" AutoPostBack="False" />
                                تعديل بيانات المريض</li>
                            <li>
                                <asp:CheckBox ID="btnExportExcel" runat="server" CssClass="child" AutoPostBack="False" />
                                تصدير Excel</li>
                            <li>
                                <asp:CheckBox ID="btnExportPDF" runat="server" CssClass="child" AutoPostBack="False" />
                                تصدير PDF</li>
                        </ul>
                    </li>
                    <li>
                        <asp:CheckBox ID="chkPatientsPayments" runat="server" CssClass="child" AutoPostBack="False" />
                        دفع الذمم أو الإشتراكات</li>
                    <li>
                        <asp:CheckBox ID="chkPatientPaymentsReport" runat="server" CssClass="child" AutoPostBack="False" />
                        تقارير</li>
                    <li>
                        <asp:CheckBox ID="chkPatientsDebtsSubscriptions" runat="server" CssClass="child" AutoPostBack="False" />
                        عرض الذمم والإشتراكات</li>
                </ul>
                        </li>

                        <!-- يومية -->
                        <li>
                            <asp:CheckBox ID="chkDaily" runat="server" CssClass="child" AutoPostBack="False" />
                            📋 يومية
                <ul>
                    <li>
                        <asp:CheckBox ID="chkOpenTreatmentCard" runat="server" CssClass="child" AutoPostBack="False" />
                        فتح بطاقة معالجة</li>
                    <li>
                        <asp:CheckBox ID="chkDashboardAppointments" runat="server" CssClass="child" AutoPostBack="False" />
                        المواعيد</li>
                    <li>
                        <asp:CheckBox ID="chkAppointments" runat="server" CssClass="child" AutoPostBack="False" />
                        عمل تقرير طبي</li>
                </ul>
                        </li>

                        <!-- الأطباء -->
                        <li>
                            <asp:CheckBox ID="chkDoctors" runat="server" CssClass="child" AutoPostBack="False" />
                            الأطباء
                <ul>
                    <li>
                        <asp:CheckBox ID="chkAddDoctor" runat="server" CssClass="child" AutoPostBack="False" />
                        إضافة بيانات طبيب</li>
                    <li>
                        <asp:CheckBox ID="chkShowAllDoctor" runat="server" CssClass="child" AutoPostBack="False" />
                        عرض الأطباء
                        <ul>
                            <li>
                                <asp:CheckBox ID="btnEditDoctor" runat="server" CssClass="child" AutoPostBack="False" />
                                تعديل بيانات الطبيب</li>
                            <li>
                                <asp:CheckBox ID="btnToggleDoctor" runat="server" CssClass="child" AutoPostBack="False" />
                                إيقاف الطبيب</li>
                </ul>
                        </li>
                        <li>
                            <asp:CheckBox ID="chkDoctorSchedule" runat="server" CssClass="child" AutoPostBack="False" />
                            أوقات دوام الأطباء</li>
                        <li>
                            <asp:CheckBox ID="chkDoctorReports" runat="server" CssClass="child" AutoPostBack="False" />
                            تقارير</li>
                        </ul>
                        </li>

                        <!-- بطاقات التأمين -->
                        <li>
                            <asp:CheckBox ID="chkInsurance" runat="server" CssClass="child" AutoPostBack="False" />
                            بطاقات التأمين
                <ul>
                    <li>
                        <asp:CheckBox ID="chkAddInsuranceCompany" runat="server" CssClass="child" AutoPostBack="False" />
                        إضافة شركات تأمين</li>
                    <li>
                        <asp:CheckBox ID="chkAddInsuranceCard" runat="server" CssClass="child" AutoPostBack="False" />
                        إضافة بطاقات تأمين</li>
                    <li>
                        <asp:CheckBox ID="chkInsuranceReports" runat="server" CssClass="child" AutoPostBack="False" />
                        تقارير مالية</li>
                </ul>
                        </li>

                        <!-- حسابات -->
                        <li>
                            <asp:CheckBox ID="chkAccounts" runat="server" CssClass="child" AutoPostBack="False" />
                            حسابات
                <ul>
                    <li>
                        <asp:CheckBox ID="chkSuppliers" runat="server" CssClass="child" AutoPostBack="False" />
                        تعريف بطاقة مورد</li>
                    <li>
                        <asp:CheckBox ID="chkSuppliersList" runat="server" CssClass="child" AutoPostBack="False" />
                        عرض الموردين
                        <ul>
                            <li>
                                <asp:CheckBox ID="btnEditSupplier" runat="server" CssClass="child" AutoPostBack="False" />
                                تعديل المورد</li>
                            <li>
                                <asp:CheckBox ID="btnViewInvoices" runat="server" CssClass="child" AutoPostBack="False" />
                                عرض الفواتير</li>
                        </ul>
                    </li>
                    <li>
                        <asp:CheckBox ID="chkEmployees" runat="server" CssClass="child" AutoPostBack="False" />
                        إضافة موظفين</li>
                    <li>
                        <asp:CheckBox ID="chkEmployeesList" runat="server" CssClass="child" AutoPostBack="False" />
                        عرض الموظفين
                        <ul>
                            <li>
                                <asp:CheckBox ID="btnEditEmployee" runat="server" CssClass="child" AutoPostBack="False" />
                                تعديل بيانات الموظف</li> 
                            <li>
                                <asp:CheckBox ID="btnViewWithdrawals" runat="server" CssClass="child" AutoPostBack="False" />
                                عرض المسحوبات</li>
                        </ul>
                    </li>
                    <li>
                        <asp:CheckBox ID="chkWithdrawals" runat="server" CssClass="child" AutoPostBack="False" />
                        مسحوبات</li>
                    <li>
                        <asp:CheckBox ID="chkAddExpense" runat="server" CssClass="child" AutoPostBack="False" />
                        مصاريف</li>
                    <li>
                        <asp:CheckBox ID="chkAddPurchaseInvoice" runat="server" CssClass="child" AutoPostBack="False" />
                        فواتير مشتريات</li>
                    <li>
                        <asp:CheckBox ID="chkFinancialReports" runat="server" CssClass="child" AutoPostBack="False" />
                        تقارير محاسبة مفصلة</li>
                    <li>
                        <asp:CheckBox ID="chkDebtsReports" runat="server" CssClass="child" AutoPostBack="False" />
                        تقارير ذمم مفصلة</li>
                </ul>
                        </li>

                        <!-- ضبط -->
                        <li>
                            <asp:CheckBox ID="chkSettings" runat="server" CssClass="child" AutoPostBack="False" />
                            ضبط
                <ul>
                    <li>
                        <asp:CheckBox ID="chkTreatmentsManager" runat="server" CssClass="child" AutoPostBack="False" />
                        الإجرائات الطبية
                        <ul>
                            <li>
                                <asp:CheckBox ID="btnAddGroup" runat="server" CssClass="child" AutoPostBack="False" />
                                إضافة مجموعة</li>
                            <li>
                                <asp:CheckBox ID="btnAddTreatment" runat="server" CssClass="child" AutoPostBack="False" />
                                إضافة إجراء</li>
                            <li>
                                <asp:CheckBox ID="btnEditGroup" runat="server" CssClass="child" AutoPostBack="False" />
                                تعديل مجموعة</li>
                            <li>
                                <asp:CheckBox ID="btnEditTreatment" runat="server" CssClass="child" AutoPostBack="False" />
                                تعديل إجراء</li>
                            <li>
                                <asp:CheckBox ID="btnDeleteGroup" runat="server" CssClass="child" AutoPostBack="False" />
                                حذف مجموعة</li>
                            <li>
                                <asp:CheckBox ID="btnDeleteTreatment" runat="server" CssClass="child" AutoPostBack="False" />
                                حذف إجراء</li>
                        </ul>
                    </li>
                    <li>
                        <asp:CheckBox ID="chkClinicSettings" runat="server" CssClass="child" AutoPostBack="False" />
                        خيارات</li>
                    <li>
                        <asp:CheckBox ID="chkPersonalPage" runat="server" CssClass="child" AutoPostBack="False" />
                        ضبط الصفحة الشخصية</li>
                    <li>
                        <asp:CheckBox ID="chkSubscriptionPayment" runat="server" CssClass="child" AutoPostBack="False" />
                        تجديد الإشتراك</li>
                    <li>
                        <asp:CheckBox ID="chkContactUs" runat="server" CssClass="child" AutoPostBack="False" />
                        تواصل معنا</li>
                </ul>
                        </li>
                    </ul>
                </div>
            </div>

        </div>
        <!-- أزرار الحفظ والعودة -->
        <div class="text-center mb-5 d-flex justify-content-center gap-3 flex-wrap">
            <asp:Button ID="btnSaveSettings" runat="server" Text="💾 حفظ الإعدادات" CssClass="btn btn-success btn-lg px-5 shadow-sm"
                OnClick="btnSaveSettings_Click" />
            <asp:Button ID="btnCancelSettings" runat="server" Text="⬅ العودة" CssClass="btn btn-outline-secondary btn-lg px-5 shadow-sm"
                OnClick="btnCancelSettings_Click" />
        </div>

    </div>

    <style>
        /* تحسين شكل الأيقونات */
        .card-header i {
            font-size: 1.2rem;
        }

        /* تحسين قائمة أنواع العيادة */
        .clinic-types-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
            font-size: 1rem;
        }

            .clinic-types-list input[type=checkbox] {
                transform: scale(1.2);
                margin-left: 10px;
            }

        /* قائمة الصلاحيات */
        .permissions-checkboxes {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

            .permissions-checkboxes input[type=checkbox] {
                transform: scale(1.1);
                margin-left: 8px;
            }

        /* تحسين تجربة الأزرار */
        .btn-success:hover {
            background-color: #218838;
        }

        .btn-outline-secondary:hover {
            background-color: #e2e6ea;
        }

        /* تحسين البطاقة */
        .card-body {
            padding: 25px;
        }

        .permissions-tree ul {
            list-style: none;
            padding-left: 20px;
        }

        .permissions-tree li {
            margin: 5px 0;
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', () => {

            const allCheckboxes = document.querySelectorAll('.permissions-tree input[type="checkbox"]');

            allCheckboxes.forEach(chk => {
                chk.addEventListener('change', function () {
                    const li = this.closest('li');
                    if (!li) return;

                    // تحديد/إلغاء كل الأبناء
                    const children = li.querySelectorAll('ul input[type="checkbox"]');
                    children.forEach(child => child.checked = this.checked);

                    // تحديث كل الآباء للأعلى
                    updateParentCheckboxes(li);
                });
            });

            function updateParentCheckboxes(li) {
                const parentUL = li.parentElement.closest('ul');
                if (!parentUL) return;

                const parentLI = parentUL.closest('li');
                if (!parentLI) return;

                const parentChk = parentLI.querySelector('input[type="checkbox"]');

                // تحقق من كل الأبناء: إذا أي فرع محدد خلي الاب محدد، إذا ولا واحد محدد خلي الاب غير محدد
                const allChildCheckboxes = parentLI.querySelectorAll('ul input[type="checkbox"]');
                const anyChildChecked = Array.from(allChildCheckboxes).some(child => child.checked);

                parentChk.checked = anyChildChecked;

                // استدعاء تكراري للأعلى
                updateParentCheckboxes(parentLI);
            }

        });
    </script>

</asp:Content>

