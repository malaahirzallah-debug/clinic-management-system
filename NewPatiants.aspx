<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="NewPatiants.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.NewPatiants" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4">
        <div class="text-center mb-5">
            <h2 class="fw-bold text-primary">
                <i class="bi bi-person-plus"></i>إضافة مريض جديد
            </h2>
            <p class="text-muted">يرجى تعبئة البيانات الأساسية للمريض بشكل دقيق</p>
        </div>

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
            <div class="card-header bg-gradient bg-success text-white fw-bold">
                <i class="bi bi-telephone"></i>معلومات الاتصال
            </div>
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

        <div class="card mb-4 shadow border-0 rounded-3">
            <div class="card-header bg-gradient bg-danger text-white fw-bold d-flex justify-content-between align-items-center">
                <span><i class="bi bi-heart-pulse"></i>الأمراض المزمنة</span>
                <asp:Button ID="btnAddDisease" runat="server" Text="➕ إضافة" CssClass="btn btn-light btn-sm"
                    OnClick="btnAddDisease_Click" />
            </div>
            <div class="card-body">
                <asp:CheckBoxList ID="chkChronic" runat="server" CssClass="form-check">
                </asp:CheckBoxList>
            </div>
        </div>

        <div class="card mb-4 shadow border-0 rounded-3">
            <div class="card-header bg-gradient bg-warning fw-bold d-flex justify-content-between align-items-center">
                <span><i class="bi bi-exclamation-triangle"></i>الحساسية</span>
                <asp:Button ID="btnAddAllergy" runat="server" Text="➕ إضافة" CssClass="btn btn-dark btn-sm"
                    OnClick="btnAddAllergy_Click" />
            </div>
            <div class="card-body">
                <asp:CheckBoxList ID="chkAllergy" runat="server" CssClass="form-check">
                </asp:CheckBoxList>
            </div>
        </div>

        <div class="card mb-4 shadow border-0 rounded-3">
            <div class="card-header bg-gradient bg-info text-white fw-bold">
                <i class="bi bi-clipboard2-pulse"></i>الحالة الصحية العامة
            </div>
            <div class="card-body">
                <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control form-control-lg" TextMode="MultiLine" Rows="4" placeholder="أدخل ملاحظات إضافية (إن وجدت)" />
            </div>
        </div>

        <div class="text-center mb-5">
            <asp:Button ID="btnSave" runat="server" Text="💾 حفظ"
                CssClass="btn btn-primary btn-lg px-5 me-2 shadow-sm"
                OnClientClick="this.disabled=true; this.value='...جاري الحفظ';" UseSubmitBehavior="false" />

            <asp:Button ID="btnTreatmentPlan" runat="server" Text="📝 فتح خطة علاجية" 
        CssClass="btn btn-success btn-lg px-5 me-2 shadow-sm"
        Enabled="False" OnClick="btnTreatmentPlan_Click" />

    <asp:Button ID="btnInsurance" runat="server" Text="📄 تسجيل بيانات تأمين" 
        CssClass="btn btn-warning btn-lg px-5 shadow-sm"
        Enabled="False" OnClick="btnInsurance_Click" />

            <asp:Button ID="btnCancel" runat="server" Text="⬅ عودة" CssClass="btn btn-outline-secondary btn-lg px-5 shadow-sm" OnClick="btnCancel_Click" />
        </div>
    </div>

    <script>
        function syncDOBFromAge() {
            let ageInput = document.getElementById("<%= txtAge.ClientID %>");
            let dobInput = document.getElementById("<%= txtDOB.ClientID %>");
            let age = parseInt(ageInput.value);
            if (!isNaN(age) && age > 0) {
                let today = new Date();
                let birthYear = today.getFullYear() - age;
                dobInput.value = birthYear + "-" + String(today.getMonth() + 1).padStart(2, '0') + "-" + String(today.getDate()).padStart(2, '0');
            }
        }

        function syncAgeFromDOB() {
            let ageInput = document.getElementById("<%= txtAge.ClientID %>");
            let dobInput = document.getElementById("<%= txtDOB.ClientID %>");
            if (dobInput.value) {
                let dob = new Date(dobInput.value);
                let diff = Date.now() - dob.getTime();
                let ageDt = new Date(diff);
                let age = Math.abs(ageDt.getUTCFullYear() - 1970);
                ageInput.value = age;
            }
        }
    </script>

    <style>
        #snackbar {
            visibility: hidden;
            min-width: 280px;
            background-color: #323232;
            color: #fff;
            text-align: center;
            border-radius: 10px;
            padding: 16px;
            position: fixed;
            z-index: 9999;
            left: 50%;
            bottom: 30px;
            transform: translateX(-50%);
            font-size: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

            #snackbar.show {
                visibility: visible;
                animation: fadein 0.5s, fadeout 0.5s 3s;
            }

            #snackbar button {
                background: transparent;
                border: none;
                color: #4caf50;
                font-weight: bold;
                cursor: pointer;
                margin-left: 10px;
            }

        @keyframes fadein {
            from {
                bottom: 0;
                opacity: 0;
            }

            to {
                bottom: 30px;
                opacity: 1;
            }
        }

        @keyframes fadeout {
            from {
                bottom: 30px;
                opacity: 1;
            }

            to {
                bottom: 0;
                opacity: 0;
            }
        }
    </style>

    <div id="snackbar">
        <span id="snackbarMsg"></span>
        <button onclick="undoAction()">تراجع</button>
    </div>

    <script>
        let lastAction = null;

        function showSnackbar(msg, action) {
            document.getElementById("snackbarMsg").innerText = msg;
            let sb = document.getElementById("snackbar");
            sb.className = "show";
            lastAction = action || null;
            setTimeout(function () {
                sb.className = sb.className.replace("show", "");
            }, 4000);
        }

        function undoAction() {
            if (lastAction) {
                lastAction();
            }
            document.getElementById("snackbar").className = "";
        }
    </script>
</asp:Content>
