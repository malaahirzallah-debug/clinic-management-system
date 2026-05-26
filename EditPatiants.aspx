<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="EditPatiants.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.EditPatiants" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <!-- عنوان الصفحة -->
        <div class="text-center mb-5">
            <h2 class="fw-bold text-primary">
                <i class="bi bi-person-plus"></i>تعديل بيانات المريض
            </h2>
            <p class="text-muted">يرجى تعبئة البيانات الأساسية للمريض بشكل دقيق</p>
        </div>

        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />

        <asp:UpdatePanel ID="updPatientForm" runat="server">
            <ContentTemplate>
                <div class="card mb-4 shadow border-0 rounded-3">
                    <div class="card-header bg-gradient bg-primary text-white fw-bold">
                        <i class="bi bi-file-person"></i>معلومات المريض
                    </div>
                    <div class="card-body row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">الاسم الكامل</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control form-control-lg" placeholder="اكتب الاسم الكامل" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">الرقم الوطني</label>
                            <asp:TextBox ID="txtNationalNo" runat="server" CssClass="form-control form-control-lg" placeholder="الرقم الوطني" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold">العمر</label>
                            <asp:TextBox ID="txtAge" runat="server" CssClass="form-control form-control-lg" onkeyup="syncDOBFromAge()" placeholder="بالسنوات" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold">تاريخ الميلاد</label>
                            <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control form-control-lg" TextMode="Date" onchange="syncAgeFromDOB()" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold">الجنس</label>
                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select form-select-lg">
                                <asp:ListItem Text="ذكر" Value="M" />
                                <asp:ListItem Text="أنثى" Value="F" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold">الحالة الاجتماعية</label>
                            <asp:DropDownList ID="ddlMarital" runat="server" CssClass="form-select form-select-lg">
                                <asp:ListItem Text="أعزب" />
                                <asp:ListItem Text="متزوج" />
                                <asp:ListItem Text="مطلق" />
                                <asp:ListItem Text="أرمل" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">الجنسية</label>
                            <asp:DropDownList ID="ddlNationality" runat="server" CssClass="form-select form-select-lg">
                                <asp:ListItem Selected="True">أردني</asp:ListItem>
                                <asp:ListItem>سوري</asp:ListItem>
                                <asp:ListItem>فلسطيني</asp:ListItem>
                                <asp:ListItem>مصري</asp:ListItem>
                                <asp:ListItem>عراقي</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">المهنة</label>
                            <asp:TextBox ID="txtJob" runat="server" CssClass="form-control form-control-lg" placeholder="مثال: موظف، طالب..." />
                        </div>
                    </div>
                </div>
                <div class="card mb-4 shadow border-0 rounded-3">
                    <div class="card-header bg-gradient bg-success text-white fw-bold"><i class="bi bi-telephone"></i>معلومات الاتصال </div>
                    <div class="card-body row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">رقم الهاتف</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control form-control-lg" placeholder="07XXXXXXXX" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">رقم هاتف احتياطي</label>
                            <asp:TextBox ID="txtAltPhone" runat="server" CssClass="form-control form-control-lg" placeholder="رقم آخر للتواصل" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">الإحالة</label>
                            <asp:DropDownList ID="ddlReferral" runat="server" CssClass="form-select form-select-lg">
                                <asp:ListItem>لا يوجد</asp:ListItem>
                                <asp:ListItem>صديق</asp:ListItem>
                                <asp:ListItem>إعلان</asp:ListItem>
                                <asp:ListItem>طبيب آخر</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">العنوان</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control form-control-lg" TextMode="MultiLine" Rows="3" placeholder="المدينة - الحي - الشارع" />
                        </div>
                    </div>
                </div>
                <!-- الأمراض المزمنة -->
                <div class="card mb-4 shadow border-0 rounded-3">
                    <div class="card-header bg-gradient bg-danger text-white fw-bold d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-heart-pulse"></i>الأمراض المزمنة</span>
                        <asp:Button ID="btnAddDisease" runat="server" Text="➕ إضافة" CssClass="btn btn-light btn-sm" />
                    </div>
                    <div class="card-body">
                        <asp:CheckBoxList ID="chkChronic" runat="server" CssClass="form-check" />
                    </div>
                </div>
                <!-- الحساسية -->
                <div class="card mb-4 shadow border-0 rounded-3">
                    <div class="card-header bg-gradient bg-warning fw-bold d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-exclamation-triangle"></i>الحساسية</span>
                        <asp:Button ID="btnAddAllergy" runat="server" Text="➕ إضافة" CssClass="btn btn-dark btn-sm" />
                    </div>
                    <div class="card-body">
                        <asp:CheckBoxList ID="chkAllergy" runat="server" CssClass="form-check" />
                    </div>
                </div>
                <!-- الملاحظات العامة -->
                <div class="card mb-4 shadow border-0 rounded-3">
                    <div class="card-header bg-gradient bg-info text-white fw-bold"><i class="bi bi-clipboard2-pulse"></i>الحالة الصحية العامة </div>
                    <div class="card-body">
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control form-control-lg" TextMode="MultiLine" Rows="4" placeholder="أدخل ملاحظات إضافية (إن وجدت)" />
                    </div>
                </div>
                <div class="text-center mb-5">
                    <asp:Button ID="btnSave" runat="server" Text="💾 حفظ" CssClass="btn btn-primary btn-lg px-5 me-2 shadow-sm" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="❌ إلغاء" CssClass="btn btn-outline-secondary btn-lg px-5 shadow-sm" OnClick="btnCancel_Click" />
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <!-- Snackbar -->
    <div id="snackbar" style="visibility: hidden; min-width: 250px; margin-left: -125px; background-color: #333; color: #fff; text-align: center; border-radius: 8px; padding: 16px; position: fixed; left: 50%; bottom: 30px; font-size: 17px; z-index: 9999; display: flex; justify-content: space-between; align-items: center;">
        <span id="snackbarMsg">تم الحفظ بنجاح</span>
        <button id="undoBtn" style="margin-left: 20px; background-color: #f8f9fa; border: none; color: #333; padding: 5px 10px; border-radius: 5px; cursor: pointer;">
            تراجع</button>
    </div>

    <script>
        function showSnackbar(message, undoCallback) {
            var snackbar = document.getElementById("snackbar");
            document.getElementById("snackbarMsg").innerText = message;
            snackbar.style.visibility = "visible";

            var undoBtn = document.getElementById("undoBtn");
            undoBtn.onclick = function () {
                undoCallback();
                snackbar.style.visibility = "hidden";
            };

            setTimeout(function () {
                snackbar.style.visibility = "hidden";
            }, 6000);
        }

        function undoLastSave(patientID) {
            __doPostBack('UndoPatient', patientID);
        }
    </script>
</asp:Content>
