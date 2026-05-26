<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="TreatmentPlan.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.TreatmentPlan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
       

        .dental-chart {
            position: relative;
            width: 800px;
            height: 400px;
            margin: 0 auto;
            border: 1px solid #ccc;
            border-radius: 15px;
        }

        .tooth {
            position: absolute;
            width: 40px;
            height: 40px;
            cursor: pointer;
            border-radius: 50%;
            transition: transform 0.2s ease;
        }

            .tooth:hover {
                transform: scale(1.2);
                box-shadow: 0 0 10px rgba(0,0,0,0.3);
            }

        .treatment-panel {
            position: fixed;
            top: 50px;
            right: 50px;
            width: 300px;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            display: none;
            z-index: 1000;
        }

            .treatment-panel h4 {
                margin-top: 0;
                color: #007bff;
            }

            .treatment-panel select,
            .treatment-panel textarea,
            .treatment-panel button {
                width: 100%;
                margin-bottom: 10px;
                padding: 8px 10px;
                font-size: 14px;
                border-radius: 5px;
                border: 1px solid #ccc;
                box-sizing: border-box;
            }

            .treatment-panel button {
                background-color: #007bff;
                color: #fff;
                border: none;
                cursor: pointer;
                font-weight: bold;
                transition: background-color 0.2s ease;
            }

                .treatment-panel button:hover {
                    background-color: #0056b3;
                }

        @media (max-width: 900px) {
            .dental-chart {
                width: 100%;
                height: 300px;
            }

            .treatment-panel {
                width: 90%;
                top: 20px;
                right: 5%;
            }
        }

        .teeth-container {
            position: relative;
            display: block;
            width: 100%;
            max-width: 100%;
            margin: 0 auto;
            text-align: center;
        }

            .teeth-container img {
                width: 100%;
                height: auto;
            }

        .tooth {
            position: absolute;
            width: 5%;
            height: 8%;
            border-radius: 50%;
            /*background-color: rgba(255,0,0,0.4);*/ /* بس انخلص الشغل بنشيلها عشان يصير شفاف*/
            cursor: pointer;
        }

        .Bigtooth {
            position: absolute;
            width: 5%;
            height: 17%;
            border-radius: 50%;
            /*background-color: rgba(255,0,0,0.4);*/ /* بس انخلص الشغل بنشيلها عشان يصير شفاف*/
            cursor: pointer;
        }

            .Bigtooth:hover {
                transform: scale(1.2);
                box-shadow: 0 0 10px rgba(0,0,0,0.3);
            }

        .tooth:hover {
            transform: scale(1.2);
        }
    </style>

    <h1>خطة علاجية تفاعلية</h1>

    <div class="teeth-container">
        <img src="Images/Screenshot(66).png" alt="Dental Chart" />

        <!-- مثال على سن قابل للنقر -->
        <div class="tooth" style="top: 35%; left: 2.5%;" data-tooth="18"></div>
        <div class="tooth" style="top: 35%; left: 8.5%;" data-tooth="17"></div>
        <div class="tooth" style="top: 35%; left: 15%;" data-tooth="16"></div>
        <div class="tooth" style="top: 35%; left: 21%;" data-tooth="15"></div>
        <div class="tooth" style="top: 35%; left: 27%;" data-tooth="14"></div>
        <div class="tooth" style="top: 35%; left: 33%;" data-tooth="13"></div>
        <div class="tooth" style="top: 35%; left: 39%;" data-tooth="12"></div>
        <div class="tooth" style="top: 35%; left: 45%;" data-tooth="11"></div>

        <div class="Bigtooth" style="top: 13%; left: 2.5%;" data-tooth="18"></div>
        <div class="Bigtooth" style="top: 13%; left: 9%;" data-tooth="17"></div>
        <div class="Bigtooth" style="top: 13%; left: 15%;" data-tooth="16"></div>
        <div class="Bigtooth" style="top: 13%; left: 21%;" data-tooth="15"></div>
        <div class="Bigtooth" style="top: 13%; left: 27%;" data-tooth="14"></div>
        <div class="Bigtooth" style="top: 12%; left: 33%;" data-tooth="13"></div>
        <div class="Bigtooth" style="top: 13%; left: 39.5%;" data-tooth="12"></div>
        <div class="Bigtooth" style="top: 13%; left: 45%;" data-tooth="11"></div>

        <div class="tooth" style="top: 35%; left: 51%;" data-tooth="21"></div>
        <div class="tooth" style="top: 35%; left: 57%;" data-tooth="22"></div>
        <div class="tooth" style="top: 35%; left: 62.5%;" data-tooth="23"></div>
        <div class="tooth" style="top: 35%; left: 68.5%;" data-tooth="24"></div>
        <div class="tooth" style="top: 35%; left: 74%;" data-tooth="25"></div>
        <div class="tooth" style="top: 35%; left: 80%;" data-tooth="26"></div>
        <div class="tooth" style="top: 35%; left: 86%;" data-tooth="27"></div>
        <div class="tooth" style="top: 35%; left: 92.5%;" data-tooth="28"></div>

        <div class="Bigtooth" style="top: 13%; left: 51%;" data-tooth="21"></div>
        <div class="Bigtooth" style="top: 13%; left: 57%;" data-tooth="22"></div>
        <div class="Bigtooth" style="top: 13%; left: 62.5%;" data-tooth="23"></div>
        <div class="Bigtooth" style="top: 13%; left: 68.5%;" data-tooth="24"></div>
        <div class="Bigtooth" style="top: 13%; left: 74%;" data-tooth="25"></div>
        <div class="Bigtooth" style="top: 13%; left: 80%;" data-tooth="26"></div>
        <div class="Bigtooth" style="top: 13%; left: 86%;" data-tooth="27"></div>
        <div class="Bigtooth" style="top: 13%; left: 92.5%;" data-tooth="28"></div>

        <div class="tooth" style="top: 56%; left: 92.5%;" data-tooth="38"></div>
        <div class="tooth" style="top: 56%; left: 86%;" data-tooth="37"></div>
        <div class="tooth" style="top: 56%; left: 80%;" data-tooth="36"></div>
        <div class="tooth" style="top: 56%; left: 74%;" data-tooth="35"></div>
        <div class="tooth" style="top: 56%; left: 68.5%;" data-tooth="34"></div>
        <div class="tooth" style="top: 56%; left: 62.5%;" data-tooth="33"></div>
        <div class="tooth" style="top: 56%; left: 57%;" data-tooth="32"></div>
        <div class="tooth" style="top: 56%; left: 51%;" data-tooth="31"></div>

        <div class="tooth" style="top: 56%; left: 45%;" data-tooth="41"></div>
        <div class="tooth" style="top: 56%; left: 39.5%;" data-tooth="42"></div>
        <div class="tooth" style="top: 56%; left: 33%;" data-tooth="43"></div>
        <div class="tooth" style="top: 56%; left: 27%;" data-tooth="44"></div>
        <div class="tooth" style="top: 56%; left: 21%;" data-tooth="45"></div>
        <div class="tooth" style="top: 56%; left: 15%;" data-tooth="46"></div>
        <div class="tooth" style="top: 56%; left: 9%;" data-tooth="47"></div>
        <div class="tooth" style="top: 56%; left: 2.5%;" data-tooth="48"></div>

        <div class="Bigtooth" style="top: 68%; left: 92.5%;" data-tooth="38"></div>
        <div class="Bigtooth" style="top: 68%; left: 86%;" data-tooth="37"></div>
        <div class="Bigtooth" style="top: 68%; left: 80%;" data-tooth="36"></div>
        <div class="Bigtooth" style="top: 68%; left: 74%;" data-tooth="35"></div>
        <div class="Bigtooth" style="top: 68%; left: 68.5%;" data-tooth="34"></div>
        <div class="Bigtooth" style="top: 68%; left: 62.5%;" data-tooth="33"></div>
        <div class="Bigtooth" style="top: 68%; left: 57%;" data-tooth="32"></div>
        <div class="Bigtooth" style="top: 68%; left: 51%;" data-tooth="31"></div>

        <div class="Bigtooth" style="top: 68%; left: 45%;" data-tooth="41"></div>
        <div class="Bigtooth" style="top: 68%; left: 39.5%;" data-tooth="42"></div>
        <div class="Bigtooth" style="top: 68%; left: 33%;" data-tooth="43"></div>
        <div class="Bigtooth" style="top: 68%; left: 27%;" data-tooth="44"></div>
        <div class="Bigtooth" style="top: 68%; left: 21%;" data-tooth="45"></div>
        <div class="Bigtooth" style="top: 68%; left: 15%;" data-tooth="46"></div>
        <div class="Bigtooth" style="top: 68%; left: 9%;" data-tooth="47"></div>
        <div class="Bigtooth" style="top: 68%; left: 2.5%;" data-tooth="48"></div>
    </div>

    <div class="treatment-panel" id="treatmentPanel">
        <h4>إجراءات السن <span id="selectedTooth">--</span></h4>

        <select id="treatmentGroup">
            <option value="">اختر المجموعة</option>
        </select>

        <select id="treatmentItem">
            <option value="">اختر الإجراء</option>
        </select>

        <textarea id="treatmentNotes" placeholder="أدخل ملاحظات إضافية"></textarea>

        <button type="button" id="addTreatment">➕ إضافة للإجراء</button>
    </div>

    <div id="selectedTreatments" class="selected-units"></div>
    <asp:HiddenField ID="hfSelectedTreatments" runat="server" />

    <button type="button" id="btnSaveAll" style="margin-top: 10px; padding: 10px 20px; background: #27ae60; color: #fff; border: none; border-radius: 6px; cursor: pointer;">💾 حفظ كل الإجراءات</button>

    <style>
        .unit-card, .treatment-card {
            display: inline-flex;
            align-items: center;
            justify-content: space-between;
            padding: 8px 12px;
            margin: 5px;
            background: #3498db;
            color: #fff;
            border-radius: 8px;
            cursor: default;
            font-size: 14px;
        }

            .treatment-card button {
                background: #e74c3c;
                border: none;
                color: #fff;
                border-radius: 6px;
                margin-left: 10px;
                cursor: pointer;
            }

                .treatment-card button:hover {
                    background: #c0392b;
                }

        .tooth-container {
            display: inline-block;
            vertical-align: top;
            margin: 10px;
            padding: 5px;
            background: #f0f0f0;
            border-radius: 10px;
            min-width: 120px;
        }

        .unit-card {
            font-weight: bold;
            margin-bottom: 5px;
            text-align: center;
            background: #3498db;
            color: #fff;
            border-radius: 8px;
            padding: 5px;
        }

        .treatment-card {
            background: #2980b9;
            color: #fff;
            padding: 4px 6px;
            border-radius: 6px;
            margin-bottom: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
        }

            .treatment-card button {
                background: #e74c3c;
                border: none;
                color: #fff;
                border-radius: 6px;
                cursor: pointer;
            }

            .treatment-card div {
                display: inline-flex;
                gap: 5px;
            }

        .confirm-btn {
            background: #27ae60;
            border: none;
            color: #fff;
            border-radius: 6px;
            cursor: pointer;
        }

            .confirm-btn:hover {
                background: #1e8449;
            }

        .delete-btn {
            background: #e74c3c;
            border: none;
            color: #fff;
            border-radius: 6px;
            cursor: pointer;
        }

            .delete-btn:hover {
                background: #c0392b;
            }
    </style>

    <script>
        document.getElementById('addTreatment').addEventListener('click', function () {
            const groupSelect = document.getElementById('treatmentGroup');
            const treatmentSelect = document.getElementById('treatmentItem');
            const notes = document.getElementById('treatmentNotes').value;
            const tooth = selectedTooth;

            if (!groupSelect.value || !treatmentSelect.value || !tooth) return;

            const container = document.getElementById('selectedTreatments');

            // التحقق إذا الكونتينر للسن موجود بالفعل
            let toothContainer = container.querySelector(`.tooth-container[data-tooth='${tooth}']`);

            if (!toothContainer) {
                toothContainer = document.createElement('div');
                toothContainer.className = 'tooth-container';
                toothContainer.setAttribute('data-tooth', tooth);

                const header = document.createElement('div');
                header.className = 'unit-card';
                header.textContent = `سن ${tooth}`;
                toothContainer.appendChild(header);

                container.appendChild(toothContainer);
            }

            // إضافة الإجراء داخل الكونتينر
            const treatmentCard = document.createElement('div');
            treatmentCard.className = 'treatment-card';
            treatmentCard.setAttribute('data-group', groupSelect.value);
            treatmentCard.setAttribute('data-treatment', treatmentSelect.value);
            treatmentCard.setAttribute('data-notes', notes);

            treatmentCard.innerHTML = `
    ${groupSelect.options[groupSelect.selectedIndex].text} - ${treatmentSelect.options[treatmentSelect.selectedIndex].text}
    <div>
        <button type="button" class="confirm-btn">✅</button>
        <button type="button" class="delete-btn">×</button>
    </div>
`;

            //treatmentCard.querySelector('.delete-btn').addEventListener('click', () => {
            //    treatmentCard.remove();
            //    updateHiddenField();
            //    if (toothContainer.querySelectorAll('.treatment-card').length === 0) {
            //        toothContainer.remove();
            //    }
            //});

            // حدث زر الصح
            // حدث زر الصح
            treatmentCard.querySelector('.confirm-btn').addEventListener('click', () => {
                // تغيير لون الإجراء لتأكيده
                treatmentCard.style.backgroundColor = '#27ae60'; // أخضر للتأكيد

                // تعطيل زر الحذف بعد التأكيد
                const deleteBtn = treatmentCard.querySelector('.delete-btn');
                deleteBtn.disabled = true;
                deleteBtn.style.cursor = 'not-allowed';
                deleteBtn.style.opacity = '0.6'; // لإظهار أنه معطل
            });


            toothContainer.appendChild(treatmentCard);

            updateHiddenField();
            attachEvents(treatmentCard);
            // إعادة تعيين الحقول بعد الإضافة
            treatmentSelect.selectedIndex = 0;
            document.getElementById('treatmentNotes').value = '';
        });

        // تحديث الـ HiddenField لإرسال البيانات للسيرفر
        function updateHiddenField() {
            const units = [];
            document.querySelectorAll('#selectedTreatments .tooth-container').forEach(tc => {
                const tooth = tc.getAttribute('data-tooth');
                tc.querySelectorAll('.treatment-card').forEach(card => {
                    units.push([
                        tooth,
                        card.getAttribute('data-group'),
                        card.getAttribute('data-treatment'),
                        card.getAttribute('data-notes')
                    ].join('|'));
                });
            });
            document.getElementById('<%= hfSelectedTreatments.ClientID %>').value = units.join(';');
        }


    </script>
    <script>
        const teeth = document.querySelectorAll('.tooth, .Bigtooth');
        const panel = document.getElementById('treatmentPanel');
        const selectedToothSpan = document.getElementById('selectedTooth');
        let selectedTooth = null;

        // إظهار البانل عند الضغط على السن
        teeth.forEach(tooth => {
            tooth.addEventListener('click', (e) => {
                e.stopPropagation(); // منع إغلاق البانل عند الضغط على السن
                teeth.forEach(t => t.classList.remove('selected'));
                tooth.classList.add('selected');
                selectedTooth = tooth.dataset.tooth;
                selectedToothSpan.textContent = selectedTooth;
                panel.style.display = 'block';
                loadGroups(); // تحميل المجموعات من السيرفر
            });
        });

        // إخفاء البانل عند الضغط في أي مكان خارجها
        document.addEventListener('click', () => {
            panel.style.display = 'none';
            teeth.forEach(t => t.classList.remove('selected'));
        });

        // منع اختفاء البانل إذا ضغطت بداخلها
        panel.addEventListener('click', (e) => {
            e.stopPropagation();
        });

        // تحميل المجموعات من قاعدة البيانات
        function loadGroups() {
            fetch('TreatmentPlan.aspx/GetGroups', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: '{}'
            })
                .then(res => res.json())
                .then(data => {
                    const groups = JSON.parse(data.d);
                    const groupSelect = document.getElementById('treatmentGroup');
                    groupSelect.innerHTML = '<option value="">اختر المجموعة</option>';
                    groups.forEach(g => {
                        const opt = document.createElement('option');
                        opt.value = g.id;
                        opt.textContent = g.name;
                        groupSelect.appendChild(opt);
                    });
                });
        }

        // تحميل الإجراءات حسب المجموعة المختارة
        document.getElementById('treatmentGroup').addEventListener('change', function () {
            const groupId = this.value;
            const treatmentSelect = document.getElementById('treatmentItem');
            treatmentSelect.innerHTML = '<option value="">اختر الإجراء</option>';

            if (!groupId) return;

            fetch('TreatmentPlan.aspx/GetTreatments', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ groupId: parseInt(groupId) })
            })
                .then(res => res.json())
                .then(data => {
                    const treatments = JSON.parse(data.d);
                    treatments.forEach(t => {
                        const opt = document.createElement('option');
                        opt.value = t.id;
                        opt.textContent = t.name;
                        treatmentSelect.appendChild(opt);
                    });
                });
        });
    </script>
    <script>
        document.getElementById('btnSaveAll').addEventListener('click', function () {
            const hfValue = document.getElementById('<%= hfSelectedTreatments.ClientID %>').value;
            if (!hfValue) {
                alert('لا توجد إجراءات للحفظ.');
                return;
            }

            fetch('TreatmentPlan.aspx/SaveTreatments', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ treatmentsData: hfValue })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.d === 'OK') {
                        alert('تم حفظ كل الإجراءات بنجاح.');
                    } else {
                        alert('حدث خطأ أثناء الحفظ.');
                    }
                });
        });
    </script>
        <script>
            // سكربت مستقل لإضافة وظائف الحذف والتأكيد
            document.addEventListener('DOMContentLoaded', function () {
                // دالة لإضافة الأحداث لكل treatment-card موجود أو جديد
                function attachEvents(card) {
                    // إذا سبق وربطنا الأحداث، لا نربطها مرة ثانية
                    if (card.dataset.eventsAttached) return;
                    card.dataset.eventsAttached = true;

                    const deleteBtn = card.querySelector('.delete-btn');
                    const confirmBtn = card.querySelector('.confirm-btn');

                    if (!deleteBtn || !confirmBtn) return;

                    deleteBtn.addEventListener('click', () => {
                        const tooth = card.closest('.tooth-container').getAttribute('data-tooth');
                        const treatmentID = card.getAttribute('data-treatment');

                        if (!confirm('هل تريد حذف هذا الإجراء من قاعدة البيانات؟')) return;

                        fetch('TreatmentPlan.aspx/DeleteTreatment', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                toothNumber: tooth,
                                treatmentID: parseInt(treatmentID)
                            })
                        })
                            .then(res => res.json())
                            .then(data => {
                                if (data.d === 'OK') {
                                    const container = card.closest('.tooth-container');
                                    card.remove();
                                    if (typeof updateHiddenField === 'function') updateHiddenField();
                                    if (container.querySelectorAll('.treatment-card').length === 0) {
                                        container.remove();
                                    }
                                } else {
                                    alert('حدث خطأ أثناء الحذف: ' + data.d);
                                }
                            })
                            .catch(err => alert('فشل الاتصال بالخادم: ' + err));
                    });


                    confirmBtn.addEventListener('click', () => {
                        const tooth = card.closest('.tooth-container').getAttribute('data-tooth');
                        const treatmentID = card.getAttribute('data-treatment');

                        fetch('TreatmentPlan.aspx/MarkTreatmentDone', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                patientID: parseInt('<%= Session("PatientID") %>'),
                            toothNumber: tooth,
                            treatmentID: parseInt(treatmentID)
                        })
                    })
                        .then(res => res.json())
                        .then(data => {
                            if (data.d === 'OK') {
                                card.style.backgroundColor = '#27ae60'; // أخضر
                                deleteBtn.disabled = true;
                                deleteBtn.style.cursor = 'not-allowed';
                                deleteBtn.style.opacity = '0.6';
                            } else {
                                alert('حدث خطأ أثناء تحديث الحالة.');
                            }
                        });
                });
            }

            // تطبيق على كل البطاقات الموجودة عند التحميل
            document.querySelectorAll('.treatment-card').forEach(card => attachEvents(card));

            // مراقبة DOM لأي بطاقات جديدة تضاف
            const container = document.getElementById('selectedTreatments');
            const observer = new MutationObserver(mutations => {
                mutations.forEach(m => {
                    m.addedNodes.forEach(node => {
                        if (node.classList && node.classList.contains('treatment-card')) {
                            attachEvents(node);
                        } else if (node.querySelectorAll) {
                            node.querySelectorAll('.treatment-card').forEach(c => attachEvents(c));
                        }
                    });
                });
            });

            observer.observe(container, { childList: true, subtree: true });
        });
        </script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const patientID = parseInt('<%= Session("PatientID") %>');
            const clinicID = parseInt('<%= Session("ClinicID") %>');

            if (!patientID || !clinicID) return;

            fetch('TreatmentPlan.aspx/GetPatientTreatments', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ patientID: patientID, clinicID: clinicID })
            })
                .then(res => res.json())
                .then(data => {
                    const treatments = JSON.parse(data.d);
                    const container = document.getElementById('selectedTreatments');

                    treatments.forEach(t => {
                        let toothContainer = container.querySelector(`.tooth-container[data-tooth='${t.tooth}']`);
                        if (!toothContainer) {
                            toothContainer = document.createElement('div');
                            toothContainer.className = 'tooth-container';
                            toothContainer.setAttribute('data-tooth', t.tooth);

                            const header = document.createElement('div');
                            header.className = 'unit-card';
                            header.textContent = `سن ${t.tooth}`;
                            toothContainer.appendChild(header);

                            container.appendChild(toothContainer);
                        }

                        const treatmentCard = document.createElement('div');
                        treatmentCard.className = 'treatment-card';
                        treatmentCard.setAttribute('data-treatment', t.treatmentID);
                        treatmentCard.setAttribute('data-notes', t.notes);

                        // أهم تعديل هنا: إضافة data-group
                        treatmentCard.setAttribute('data-group', t.groupID || 0); // إذا ما موجود، نحط 0

                        treatmentCard.innerHTML = `
    <span>${t.treatmentName} - ${t.notes}</span>
    <div>
        <button type="button" class="confirm-btn">✅</button>
        <button type="button" class="delete-btn">×</button>
    </div>
`;

                        // إذا الحالة Done نلوّن البطاقة بالأخضر ونوقف الحذف
                        if (t.status === 'Done') {
                            treatmentCard.style.backgroundColor = '#27ae60';
                            const deleteBtn = treatmentCard.querySelector('.delete-btn');
                            deleteBtn.disabled = true;
                            deleteBtn.style.cursor = 'not-allowed';
                            deleteBtn.style.opacity = '0.6';
                        }

                        toothContainer.appendChild(treatmentCard);

                        // ربط الأحداث بعد إضافتها
                        if (typeof attachEvents === 'function') attachEvents(treatmentCard);
                    });

                    // تحديث الـ HiddenField بعد التحميل كامل
                    if (typeof updateHiddenField === 'function') updateHiddenField();
                })
                /*.catch(err => console.error('خطأ عند تحميل الإجراءات:', err));*/
        });
    </script>
</asp:Content>
