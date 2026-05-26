<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="MedicalReport.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.MedicalReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .medical-report-container {
            max-width: 1100px;
            margin: 24px auto;
            padding: 20px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            color: #333;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            box-sizing: border-box;
        }

        .hidden {
            display: none;
        }

        .report-title {
            text-align: center;
            margin-bottom: 24px;
            color: #2c3e50;
            font-size: 24px;
            font-weight: 600;
        }

        .report-header,
        .payment-section {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            align-items: center;
            margin-bottom: 20px;
            position: relative;
        }

            .report-header label,
            .payment-section label {
                flex: 0 0 auto;
                min-width: 90px;
                font-weight: 500;
            }

        .report-input {
            padding: 10px 14px;
            border-radius: 10px;
            border: 1px solid #ccc;
            flex: 1 1 180px;
            min-width: 140px;
            font-size: 14px;
            box-sizing: border-box;
        }

            .report-input.small {
                flex: 0 0 90px;
            }

        .autocomplete-container {
            position: relative;
            flex: 1 1 200px;
            min-width: 140px;
        }

        #patientSuggestions,
        #medicineSuggestions {
            background-color: #fff !important; /* إجبار الخلفية على الأبيض */
            border: 1px solid #ccc;
            max-height: 160px;
            overflow-y: auto;
            display: none;
            position: absolute;
            width: 100%;
            z-index: 1000;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            box-sizing: border-box;
            /* مهم جدا لجعل البانيل يظهر حتى قبل وجود العناصر */
            min-height: 40px;
            padding: 4px 0;
        }

            #patientSuggestions li,
            #medicineSuggestions li {
                padding: 8px 12px;
                cursor: pointer;
                background-color: #fff !important; /* خلفية كل عنصر */
                list-style: none;
            }

                #patientSuggestions li:hover,
                #medicineSuggestions li:hover {
                    background-color: #f5f5f5;
                }


        .report-textarea {
            width: 100%;
            min-height: 100px;
            padding: 10px;
            border-radius: 10px;
            border: 1px solid #ccc;
            resize: vertical;
            font-size: 14px;
            color: #333;
            box-sizing: border-box;
        }

        .medications-section {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            margin-bottom: 20px;
        }

            .medications-section input.report-input,
            .medications-section textarea.report-textarea {
                flex: 1 1 auto;
                min-width: 120px;
            }

            .medications-section small {
                flex-basis: 100%;
                color: #666;
                margin-top: -4px;
                margin-bottom: 6px;
            }

        button {
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            transition: 0.3s;
            margin-top: 4px;
        }

        #btnSave, #btnAddAttachment {
            background-color: #0078d7;
            color: white;
        }

            #btnSave:hover, #btnAddAttachment:hover {
                background-color: #005fa3;
            }

        #btnWhatsApp, #btnPrint {
            background-color: #aaa;
            color: white;
        }

            #btnWhatsApp:disabled, #btnPrint:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }

        #btnDiscount {
            background-color: #e67e22;
            color: white;
        }

            #btnDiscount:hover {
                background-color: #cf6c17;
            }

        .hidden {
            display: none;
        }

        .report-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: flex-start;
            margin-top: 12px;
        }

        @media (max-width: 768px) {
            .report-header label,
            .payment-section label,
            .medications-section input,
            .report-header input,
            .report-header select,
            .medications-section textarea {
                flex: 1 1 100%;
            }

            .report-header,
            .payment-section,
            .medications-section {
                gap: 8px;
            }
        }

        .medical-report-container {
            visibility: hidden;
        }

        /* ستايل جديد للـ FileUpload */
        .file-upload-wrapper {
            position: relative;
            display: inline-block;
            width: 100%;
            max-width: 300px; /* يمكنك تغييره حسب التصميم */
        }

            .file-upload-wrapper input[type="file"] {
                width: 100%;
                height: 40px;
                opacity: 0; /* نخفيه */
                position: absolute;
                top: 0;
                left: 0;
                cursor: pointer;
            }

        .file-upload-label {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 10px 14px;
            border-radius: 10px;
            background-color: #0078d7;
            color: white;
            font-weight: 500;
            cursor: pointer;
            transition: 0.3s;
        }

            .file-upload-label:hover {
                background-color: #005fa3;
            }

        .file-upload-filename {
            margin-top: 6px;
            font-size: 13px;
            color: #555;
            word-break: break-all;
        }
    </style>
    <div class="medical-report-container">
        <h2 class="report-title">📄 تقرير طبي للمريض</h2>

        <div class="report-header">
            <label>تاريخ الفحص:</label>
            <asp:TextBox ID="txtExamDate" runat="server" CssClass="report-input" TextMode="Date"></asp:TextBox>

            <label>الطبيب:</label>
            <asp:DropDownList ID="ddlDoctor" runat="server" CssClass="report-input"
                DataTextField="Name" DataValueField="DoctorID" AppendDataBoundItems="true">
                <asp:ListItem Text="-- اختر طبيب --" Value="" />
            </asp:DropDownList>

            <label>المريض:</label>
            <div class="autocomplete-container">
                <asp:TextBox ID="txtPatient" runat="server" CssClass="report-input"
                    placeholder="ابحث عن المريض..." AutoCompleteType="Disabled"
                    autocomplete="off"></asp:TextBox>

                <asp:Panel ID="patientSuggestions" runat="server" CssClass="suggestions-panel"
                    Style="display: none; position: absolute; z-index: 1000;">
                </asp:Panel>
            </div>
            <asp:Label ID="patientAge" runat="server"></asp:Label>
            <button type="button" id="btnOpenNewPatient">➕</button>
            <asp:HiddenField ID="hdnPatientID" runat="server" />
        </div>

        <div class="report-section">
            <label>التقرير الطبي:</label>
            <asp:TextBox ID="txtMedicalReport" runat="server" TextMode="MultiLine" CssClass="report-textarea" placeholder="اكتب التقرير الطبي هنا..."></asp:TextBox>
        </div>

        <div class="medications-section">
            <label>الأدوية:</label>
            <div class="autocomplete-container">
                <asp:TextBox ID="txtMedicine" runat="server" CssClass="report-input"
                    placeholder="اسم الدواء..." AutoCompleteType="Disabled"
                    autocomplete="off"></asp:TextBox>
                <asp:Panel ID="medicineSuggestions" runat="server" CssClass="suggestions-panel"
                    Style="display: none; position: absolute; z-index: 1000;">
                </asp:Panel>
            </div>
            <asp:HiddenField ID="HiddenField1" runat="server" />
            <label>عدد المرات:</label>
            <asp:TextBox ID="txtMedicineCount" runat="server" CssClass="report-input small" TextMode="Number" placeholder="عدد المرات"></asp:TextBox>
            <asp:TextBox ID="txtMedicineNote" runat="server" CssClass="report-input small" placeholder="ملاحظات..."></asp:TextBox>
            <small>اضغط Enter لإضافة الدواء</small>
            <asp:TextBox ID="txtMedicinesList" runat="server" TextMode="MultiLine" CssClass="report-textarea" ReadOnly="true" placeholder="الأدوية المضافة ستظهر هنا..."></asp:TextBox>
            <asp:HiddenField ID="hdnMedicinesList" runat="server" />
        </div>

        <div class="payment-section">
            <label>طريقة الدفع:</label>
            <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="report-input">
                <asp:ListItem Value="cash">نقدي</asp:ListItem>
                <asp:ListItem Value="debt">ذمم</asp:ListItem>
                <asp:ListItem Value="card">بطاقة</asp:ListItem>
                <asp:ListItem Value="insurance">تأمين</asp:ListItem>
            </asp:DropDownList>

            <label>
                المجموع الكلي:
                <asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>
                دينار</label>
            <label>المبلغ المدفوع:</label>
            <asp:TextBox ID="txtPaidAmount" runat="server" CssClass="report-input" TextMode="Number" ReadOnly="true" />

            <button type="button" id="btnDiscount">خصم</button>
            <asp:TextBox ID="txtDiscount" runat="server" CssClass="report-input small hidden" TextMode="Number" placeholder="أدخل الخصم أو النسبة" />
            <small id="discountNote" style="display: none; margin-left: 8px; color: #555; font-size: 12px;">اضغط على زر الخصم لتطبيق الخصم
            </small>

        </div>

        <asp:HiddenField ID="hdnTotal" runat="server" />
        <asp:HiddenField ID="hdnPaidAmount" runat="server" />

        <div class="file-upload-wrapper">
            <label class="file-upload-label" for="<%= fuAttachments.ClientID %>">
                📎 اختر ملف
            </label>
            <asp:FileUpload ID="fuAttachments" runat="server" CssClass="report-input" />
            <div id="fileNameDisplay" class="file-upload-filename">لم يتم اختيار أي ملف</div>
        </div>

        <div class="report-actions">
            <button type="button" id="btnWhatsApp" disabled>واتس اب</button>
            <button type="button" id="btnPrint" disabled>طباعة</button>
            <asp:Button ID="btnEditPlan" runat="server" Text="✏️ تعديل الخطة العلاجية" CssClass="btn btn-warning" Enabled="false" OnClick="btnEditPlan_Click" />
            <asp:Button ID="btnSave" runat="server" Text="💾 حفظ" CssClass="btn btn-primary" OnClick="btnSave_Click" />

            <asp:HiddenField ID="hdnNewPaidAmount" runat="server" />
            <asp:HiddenField ID="hdnInsuranceCompanyID" runat="server" />
            <asp:HiddenField ID="hdnInsuranceCardID" runat="server" />

        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const ddlPaymentMethod = document.getElementById('<%= ddlPaymentMethod.ClientID %>');
            const txtPaidAmount = document.getElementById('<%= txtPaidAmount.ClientID %>');
            const lblTotal = document.getElementById('<%= lblTotal.ClientID %>');

            ddlPaymentMethod.addEventListener('change', () => {
                if (ddlPaymentMethod.value === "debt") {
                    // ذمم ➝ صفر وإتاحة الكتابة
                    txtPaidAmount.value = "0";
                    txtPaidAmount.removeAttribute("readonly");
                } else {
                    // أي طريقة أخرى ➝ يرجع للمجموع ويصير للقراءة فقط
                    let val = lblTotal.innerText.replace(/[^0-9.,]/g, '');
                    val = val.replace(',', '.');
                    let total = parseFloat(val) || 0;

                    txtPaidAmount.value = total.toFixed(2);
                    txtPaidAmount.setAttribute("readonly", "true");
                }
            });
        });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const txtMedicine = document.getElementById('<%= txtMedicine.ClientID %>');
            const txtMedicineCount = document.getElementById('<%= txtMedicineCount.ClientID %>');
            const txtMedicineNote = document.getElementById('<%= txtMedicineNote.ClientID %>');
            const txtMedicinesList = document.getElementById('<%= txtMedicinesList.ClientID %>');
            const hdnMedicinesList = document.getElementById('<%= hdnMedicinesList.ClientID %>');

            txtMedicine.addEventListener('change', () => {
                if (txtMedicine.value.trim() !== '') txtMedicineCount.focus();
            });

            async function addMedicine() {
                const medicineName = txtMedicine.value.trim();
                const count = txtMedicineCount.value.trim();
                const note = txtMedicineNote.value.trim();

                if (!medicineName || !count) return;

                // تحقق من وجود الدواء
                const res = await fetch(`AddMedicine.ashx?query=${encodeURIComponent(medicineName)}`);
                const data = await res.json();

                if (!data.length) {
                    await fetch(`AddNewMedicine.ashx`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: `name=${encodeURIComponent(medicineName)}`
                    });
                }

                // أضف الدواء للقائمة
                let line = `${medicineName} ${count} مرات يومياً`;
                if (note) line += ` - ${note}`;
                txtMedicinesList.value += line + "\n";
                hdnMedicinesList.value = txtMedicinesList.value;

                // إعادة ضبط الحقول
                txtMedicine.value = '';
                txtMedicineCount.value = '';
                txtMedicineNote.value = '';
                txtMedicine.focus();
            }

            // على كل الأجهزة: إضافة الدواء عند الضغط على Enter أو ترك الخانة (blur)
            txtMedicineCount.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    addMedicine();
                }
            });

            txtMedicineCount.addEventListener('blur', () => {
                if (txtMedicine.value.trim() && txtMedicineCount.value.trim()) {
                    addMedicine();
                }
            });
        });
    </script>

    <script>
        const txtMedicine = document.getElementById('<%= txtMedicine.ClientID %>');
        const medicineSuggestions = document.getElementById('<%= medicineSuggestions.ClientID %>');
        const hdnMedicineID = document.getElementById('<%= HiddenField1.ClientID %>');

        txtMedicine.addEventListener('input', function () {
            const query = this.value.trim();
            if (!query) {
                medicineSuggestions.style.display = 'none';
                return;
            }

            fetch(`AddMedicine.ashx?query=${encodeURIComponent(query)}`)
                .then(res => res.json())
                .then(data => {
                    medicineSuggestions.innerHTML = '';
                    if (!data.length) {
                        medicineSuggestions.style.display = 'none';
                        return;
                    }

                    data.forEach(m => {
                        const li = document.createElement('li');
                        li.textContent = `${m.Name}`;
                        li.style.cursor = 'pointer';
                        li.style.padding = '6px 10px';

                        li.addEventListener('click', () => {
                            txtMedicine.value = m.Name;
                            hdnMedicineID.value = m.MedicineID;
                            medicineSuggestions.style.display = 'none';
                        });

                        medicineSuggestions.appendChild(li);
                    });

                    medicineSuggestions.style.width = txtMedicine.offsetWidth + "px";
                    medicineSuggestions.style.top = txtMedicine.offsetTop + txtMedicine.offsetHeight + "px";
                    medicineSuggestions.style.left = txtMedicine.offsetLeft + "px";
                    medicineSuggestions.style.display = "block";
                });
        });
    </script>
    <script>
        // PatientInfo.js
        const txtPatient = document.getElementById('<%= txtPatient.ClientID %>');
        const patientSuggestions = document.getElementById('<%= patientSuggestions.ClientID %>');
        const hdnPatientID = document.getElementById('<%= hdnPatientID.ClientID %>');

        txtPatient.addEventListener('input', function () {
            const query = this.value.trim();
            if (!query) {
                patientSuggestions.style.display = 'none';
                return;
            }

            fetch(`GetPatients.ashx?query=${encodeURIComponent(query)}`)
                .then(res => res.json())
                .then(data => {
                    patientSuggestions.innerHTML = '';
                    if (!data.length) {
                        patientSuggestions.style.display = 'none';
                        return;
                    }

                    data.forEach(p => {
                        const li = document.createElement('li');
                        li.textContent = `${p.Name} (${p.Age} سنة)`;
                        li.style.cursor = 'pointer';
                        li.style.padding = '6px 10px';

                        li.addEventListener('click', () => {
                            txtPatient.value = p.Name;
                            hdnPatientID.value = p.PatientID;
                            document.getElementById('<%= patientAge.ClientID %>').textContent = `العمر: ${p.Age}`;
                            patientSuggestions.style.display = 'none';

                            // استدعاء ملف التأمين لتحديث القيم
                            if (typeof updateInsurance === 'function') {
                                updateInsurance(p);
                            }
                        });

                        patientSuggestions.appendChild(li);
                    });

                    patientSuggestions.style.width = txtPatient.offsetWidth + "px";
                    patientSuggestions.style.top = txtPatient.offsetTop + txtPatient.offsetHeight + "px";
                    patientSuggestions.style.left = txtPatient.offsetLeft + "px";
                    patientSuggestions.style.display = "block";
                });
        });
    </script>
    <script>
        function updateInsurance(patient) {
            if (!patient.PatientID) return;

            fetch(`GetInsurance.ashx?PatientID=${patient.PatientID}`)
                .then(res => res.json())
                .then(data => {
                    const ddlPaymentMethod = document.getElementById('<%= ddlPaymentMethod.ClientID %>');
                    const txtPaidAmount = document.getElementById('<%= txtPaidAmount.ClientID %>');
                    const lblTotal = document.getElementById('<%= lblTotal.ClientID %>');

                    const hdnInsuranceCompanyID = document.getElementById('<%= hdnInsuranceCompanyID.ClientID %>');
                    const hdnInsuranceCardID = document.getElementById('<%= hdnInsuranceCardID.ClientID %>');

                    if (data.success) {
                        // تغيير طريقة الدفع لتأمين
                        ddlPaymentMethod.value = "insurance";

                        // حساب الخصم
                        let total = parseFloat(lblTotal.innerText.replace(/[^0-9.,]/g, '').replace(',', '.')) || 0;
                        let discount = 0;

                        if (data.CoverageType === "Percentage") {
                            discount = total * (parseFloat(data.CoveragePercentage) / 100);
                        } else if (data.CoverageType === "Fixed") {
                            discount = parseFloat(data.CoveragePercentage); // قيمة ثابتة
                        }

                        let finalAmount = total - discount;

                        if (finalAmount < 0) finalAmount = 0;

                        txtPaidAmount.value = finalAmount.toFixed(2);

                        hdnInsuranceCompanyID.value = data.InsuranceCompanyID;
                        hdnInsuranceCardID.value = data.CardNumber;

                    } else {
                        // لا يوجد تأمين أو منتهي
                        ddlPaymentMethod.value = "cash"; // اختيار افتراضي
                        txtPaidAmount.value = lblTotal.innerText.replace(/[^0-9.,]/g, '').replace(',', '.');
                    }
                });
        }
    </script>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const lblTotal = document.getElementById('<%= lblTotal.ClientID %>');
            const txtPaidAmount = document.getElementById('<%= txtPaidAmount.ClientID %>');
            const btnDiscount = document.getElementById('btnDiscount');
            const txtDiscount = document.getElementById('<%= txtDiscount.ClientID %>');

            let customDiscount = 0;
            let originalAmount = null;

            function getOriginalAmount() {
                if (originalAmount === null) {
                    let val = lblTotal.innerText.replace(/[^0-9.,]/g, '');
                    val = val.replace(',', '.');
                    originalAmount = parseFloat(val) || 0;
                }
                return originalAmount;
            }

            function applyDiscount() {
                let base = getOriginalAmount();
                let discountedAmount = base - customDiscount;
                if (discountedAmount < 0) discountedAmount = 0;

                lblTotal.innerText = discountedAmount.toFixed(2);
                txtPaidAmount.value = discountedAmount.toFixed(2);
            }

            btnDiscount.addEventListener('click', () => {
                txtDiscount.classList.toggle('hidden');
                const discountNote = document.getElementById('discountNote');
                if (!txtDiscount.classList.contains('hidden')) {
                    txtDiscount.focus();
                    discountNote.style.display = 'inline';
                } else {
                    discountNote.style.display = 'none';
                }
            });

            // أي تغيير في الحقل أو ضغط Enter
            txtDiscount.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    processDiscount();
                }
            });

            // على الموبايل: التعامل مع شارة ✅ (تغيير الحقل)
            txtDiscount.addEventListener('change', processDiscount);

            function processDiscount() {
                let val = parseFloat(txtDiscount.value.trim().replace(',', '.')) || 0;
                customDiscount = val;
                applyDiscount();
                txtDiscount.classList.add('hidden');
                txtDiscount.value = '';
            }
        });
    </script>
    <script>
        window.addEventListener('DOMContentLoaded', () => {
            document.querySelector('.medical-report-container').style.visibility = 'visible';
        });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const form = document.querySelector('form');

            form.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    const target = e.target;
                    // استثناء فقط لو حقل محدد يحتاج Enter (مثل txtMedicineCount)
                    if (target.id !== '<%= txtMedicineCount.ClientID %>') {
                        e.preventDefault();
                    }
                }
            });
        });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // قراءة البيانات من localStorage
            const selectedTreatments = localStorage.getItem('selectedTreatments');
            const totalAmount = localStorage.getItem('totalAmount');

            if (selectedTreatments) {
                const txtMedicalReport = document.getElementById('<%= txtMedicalReport.ClientID %>');
                txtMedicalReport.value = selectedTreatments; // يمكن تغييره لحقول أخرى حسب التصميم
            }

            if (totalAmount) {
                const lblTotal = document.getElementById('<%= lblTotal.ClientID %>');
                lblTotal.textContent = totalAmount;
                const hdnTotal = document.getElementById('<%= hdnTotal.ClientID %>');
                hdnTotal.value = totalAmount;
                const txtPaidAmount = document.getElementById('<%= txtPaidAmount.ClientID %>');
                txtPaidAmount.value = totalAmount;
                const hdnPaidAmount = document.getElementById('<%= hdnPaidAmount.ClientID %>');
                hdnPaidAmount.value = totalAmount;
            }
        });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const btnSave = document.getElementById('<%= btnSave.ClientID %>');
            const txtPaidAmount = document.getElementById('<%= txtPaidAmount.ClientID %>');
            const hdnNewPaidAmount = document.getElementById('<%= hdnNewPaidAmount.ClientID %>');

            btnSave.addEventListener('click', () => {
                const paidAmountValue = txtPaidAmount.value;

                // خزّن القيمة في HiddenField الجديد
                hdnNewPaidAmount.value = paidAmountValue;

                // عرض الرسالة قبل الحفظ
                /*alert("المبلغ المدفوع قبل الحفظ: " + paidAmountValue);*/
            });
        });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const txtPaidAmount = document.getElementById('<%= txtPaidAmount.ClientID %>');
            const hdnNewPaidAmount = document.getElementById('<%= hdnNewPaidAmount.ClientID %>');

            // بعد PostBack مباشرة نعيد ضبط القيمة
            if (hdnNewPaidAmount.value && hdnNewPaidAmount.value !== "") {
                txtPaidAmount.value = hdnNewPaidAmount.value;
            }
        });
    </script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const fileInput = document.getElementById('<%= fuAttachments.ClientID %>');
            const fileNameDisplay = document.getElementById('fileNameDisplay');

            fileInput.addEventListener('change', () => {
                if (fileInput.files.length > 0) {
                    fileNameDisplay.textContent = fileInput.files[0].name;
                } else {
                    fileNameDisplay.textContent = 'لم يتم اختيار أي ملف';
                }
            });
        });
    </script>
</asp:Content>


