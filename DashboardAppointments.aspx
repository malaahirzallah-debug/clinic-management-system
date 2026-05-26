<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="DashboardAppointments.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.DashboardAppointments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f6f8;
            margin: 0;
            padding: 0;
        }

        .filter-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            background: #fff;
            padding: 10px 15px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

            .filter-bar select, input[type="date"], button {
                padding: 8px 12px;
                border-radius: 5px;
                border: 1px solid #ccc;
                font-size: 14px;
            }

            .filter-bar button {
                background: #4CAF50;
                color: white;
                border: none;
                cursor: pointer;
                transition: 0.3s;
            }

                .filter-bar button:hover {
                    background: #45a049;
                }

        .appointments-container {
            display: flex;
            overflow-x: auto;
            padding-bottom: 20px;
            position: relative;
        }

        .time-column {
            flex: 0 0 60px;
            background: #fff;
            border-right: 1px solid #ddd;
            position: sticky;
            left: 0;
            z-index: 2;
            margin-top: 40px;
        }

        .time-slot {
            height: 110px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #555;
        }

        .days-container {
            display: flex;
            flex-direction: row;
        }

        .day-column {
            flex: 0 0 140px;
            background: #fff;
            border-right: 1px solid #ddd;
            position: relative;
            overflow: visible;
        }

        .day-header {
            height: 40px;
            background: #1976d2;
            color: white;
            text-align: center;
            line-height: 40px;
            font-weight: bold;
            position: sticky;
            top: 0;
            z-index: 5;
            pointer-events: auto;
        }

        .slot {
            height: 110px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            cursor: pointer;
            transition: 0.2s;
            position: relative;
        }

            .slot.empty {
                background-color: #e0e0e0;
            }

        .appointment {
    user-select: none;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%; /* يخلي النص بالنص */
    padding: 5px;
    background: #ff9800; /* لون أوضح */
    color: #fff; /* النص أبيض */
    font-size: 13px; /* أكبر شوي */
    font-weight: bold;
    display: flex; /* مهم عشان نوسّط */
    align-items: center; /* عمودي */
    justify-content: center; /* أفقي */
    border-radius: 6px;
    cursor: grab;
    z-index: 10;
    pointer-events: all;
    touch-action: none;
    text-align: center; /* لو كان النص طويل */
}


        .drawing-slot {
            position: absolute;
            left: 0;
            width: 100%;
            background: rgba(76,175,80,0.3);
            border: 2px dashed #4CAF50;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #333;
            font-weight: bold;
            pointer-events: none;
        }

        .appointment.selected {
            box-shadow: 0 0 0 1px red inset;
            /* أو border */
            border: 1px solid red;
        }

        @media (max-width: 768px) {
            .filter-bar {
                flex-direction: column;
                gap: 8px;
                padding: 8px;
            }

                .filter-bar select,
                .filter-bar input[type="date"],
                .filter-bar button {
                    width: 100%;
                    font-size: 13px;
                    padding: 6px 8px;
                }

            .day-column {
                flex: 0 0 100px; /* أصغر عرض للأعمدة */
            }

            .time-column {
                flex: 0 0 50px;
            }

            .time-slot, .slot, .appointment {
                font-size: 10px;
            }

            #addAppointmentModal {
                width: 90%; /* يتناسب مع الموبايل */
                padding: 15px;
            }

            #snackbar {
                font-size: 13px;
                padding: 10px 16px;
            }
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            display: none; /* مخفي بشكل افتراضي */
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            width: 700px;
            max-width: 95%;
            max-height: 90vh;
            overflow-y: auto;
            display: grid;
            grid-template-columns: 1fr 1fr; /* عمودين */
            gap: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }

            /* العنوان ياخذ كامل العرض */
            .modal-content h2 {
                grid-column: span 2;
                text-align: center;
                margin-bottom: 10px;
            }

            /* كل label + input كبلوك */
            .modal-content label {
                font-weight: bold;
                margin-bottom: 5px;
            }

            .modal-content input,
            .modal-content select,
            .modal-content textarea {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 6px;
                width: 100%;
                box-sizing: border-box;
            }

        /* ملاحظات تاخذ العمودين */
        #notes {
            grid-column: span 2;
            min-height: 80px;
            resize: vertical;
        }

        /* أزرار الحفظ والإغلاق */
        .modal-actions {
            grid-column: span 2;
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 15px;
        }

        .save-btn, .close-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .save-btn {
            background: #4CAF50;
            color: #fff;
        }

        .close-btn {
            background: #f44336;
            color: #fff;
        }

        /* على الموبايل: عمود واحد */
        @media (max-width: 768px) {
            .modal-content {
                grid-template-columns: 1fr;
                width: 90%;
            }

            .modal-actions {
                flex-direction: column;
            }

                .modal-actions button {
                    width: 100%;
                }
        }

        .autocomplete-dropdown li:hover {
            background: #f0f0f0;
        }
    </style>

    <div class="filter-bar">
        <%--<asp:DropDownList ID="ddlDoctors" runat="server" CssClass="doctor-select"></asp:DropDownList>--%>
        <asp:DropDownList ID="ddlDoctors" runat="server" CssClass="doctor-select" ClientIDMode="Static"></asp:DropDownList>
        <input type="date" id="dateFrom" />
        <input type="date" id="dateTo" />
        <button type="button" id="btnLoad">عرض</button>
        <!-- زر الإضافة -->
        <%--<button type="button" class="btn btn-primary" onclick="openAppointmentModal()">
            + إضافة حجز
        </button>--%>
        <div id="appointmentModal" class="modal-overlay">
            <div class="modal-content">
                <h2>إضافة حجز جديد</h2>

                <label>اسم الطبيب</label>
                <asp:DropDownList ID="doctorSelect" runat="server" Enabled="false"></asp:DropDownList>

                <label>اسم المريض</label>
                <input type="text" id="patientSearch" placeholder="ابحث عن المريض..." />

                <label>تاريخ الحجز</label>
                <input type="date" id="appointmentDate" readonly />

                <label>وقت الحجز</label>
                <input type="time" id="appointmentTime" readonly />

                <label>مدة الحجز (دقائق)</label>
                <input type="number" id="duration" value="30" />

                <label>نوع الحجز</label>
                <select id="appointmentType">
                    <option value="زيارة أول مرة">زيارة أول مرة</option>
                    <option value="زيارة عيادة">زيارة عيادة</option>
                    <option value="زيارة منزلية">زيارة منزلية</option>
                </select>

                <label>ملاحظات</label>
                <textarea id="notes"></textarea>

                <%--<label>لون الحجز</label>
                <input type="color" id="colorPicker" value="#4CAF50" />--%>

                <label>لون الحجز</label>
                <div id="colorPalette" style="display: flex; flex-wrap: wrap; gap: 5px;"></div>
                <input type="hidden" id="colorPicker" value="#4CAF50" />

                <%--<label>عدد الزيارات</label>
                <input type="number" id="visitCount" value="1" />--%>

                <div class="modal-actions">
                    <button type="button" class="save-btn" onclick="saveAppointment()">حفظ</button>
                    <button type="button" class="close-btn" onclick="closeAppointmentModal()">إغلاق</button>
                </div>
            </div>
        </div>
    </div>

    <!-- جدول المواعيد -->
    <div class="appointments-container">
        <div class="time-column" id="timeColumn"></div>
        <div class="days-container" id="daysContainer"></div>
    </div>

    <div id="snackbar"
        style="display: none; position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%); background: #323232; color: #fff; padding: 12px 20px; border-radius: 5px; box-shadow: 0 2px 6px rgba(0,0,0,0.3); z-index: 1000; font-size: 14px; display: none; align-items: center; gap: 10px;">
        <span id="snackbar-text"></span>
        <button id="undoBtn"
            style="display: none; background: #f44336; border: none; color: white; padding: 5px 10px; border-radius: 3px; cursor: pointer;">
            تراجع
        </button>
    </div>


    <!-- بانيل تفاصيل الموعد -->
    <div id="appointmentDetailsModal" class="modal-overlay">
        <div class="modal-content">
            <h2>تفاصيل الموعد</h2>

            <!-- بيانات الموعد -->
            <label>اسم الطبيب</label>
            <input type="text" id="detailDoctor" readonly />

            <label>اسم المريض</label>
            <input type="text" id="detailPatient" readonly />

            <label>تاريخ الحجز</label>
            <input type="date" id="detailDate" readonly />

            <label>وقت الحجز</label>
            <input type="time" id="detailTime" readonly />

            <label>مدة الحجز</label>
            <input type="text" id="detailDuration" readonly />

            <label>نوع الحجز</label>
            <input type="text" id="detailType" readonly />

            <label>ملاحظات</label>
            <textarea id="detailNotes"></textarea>

            <!-- بيانات المريض الموسعة -->
            <label>رقم الهاتف</label>
            <input type="text" id="detailPhone1" readonly />

            <label>رقم الهاتف</label>
            <input type="text" id="detailPhone2" readonly />

            <label>العمر</label>
            <input type="text" id="detailAge" readonly />

            <label>الأمراض المزمنة</label>
            <textarea id="detailChronic" readonly></textarea>

            <label>الحساسية</label>
            <textarea id="detailAllergy" readonly></textarea>

            <label>آخر زيارة</label>
            <input type="date" id="detailLastVisit" readonly />

            <label>الرصيد / الاشتراكات</label>
            <input type="text" id="detailBalance" readonly />

            <!-- الأزرار الأربعة الفارغة -->
            <div class="modal-actions">
    <button type="button" class="action-btn" style="background-color:#4CAF50; color:white; border:none; padding:8px 16px; border-radius:6px; cursor:pointer;">فتح زيارة وتأكيد الوصول</button>
    <button type="button" class="action-btn" style="background-color:#4CAF50; color:white; border:none; padding:8px 16px; border-radius:6px; cursor:pointer;">WhatsApp</button>
    <button type="button" class="action-btn" style="background-color:#4CAF50; color:white; border:none; padding:8px 16px; border-radius:6px; cursor:pointer;">تعديل ملاحظات الموعد</button>
    <button type="button" class="close-btn" onclick="closeAppointmentDetailsModal()" style="background-color:#f44336; color:white; border:none; padding:8px 16px; border-radius:6px; cursor:pointer;">إغلاق</button>
</div>

        </div>
    </div>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="Scripts/interact.min.js"></script>

    <input type="hidden" id="hdnDateFrom" value="" />
    <input type="hidden" id="hdnDateTo" value="" />
    <script>
        $(document).ready(function () {

            // متغير عام لتخزين رقم الموعد الحالي
            let currentAppointmentId = null;

            // فتح مودال تفاصيل الموعد
            function openAppointmentDetailsModal(appointmentId) {
                currentAppointmentId = appointmentId; // تخزين الرقم الحالي

                $('#appointmentDetailsModal').fadeIn(200).css("display", "flex");

                $.ajax({
                    type: "POST",
                    url: "DashboardAppointments.aspx/GetAppointmentDetails",
                    data: JSON.stringify({ appointmentId: appointmentId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) {
                        const data = res.d;

                        // تعبئة الحقول بالمعلومات
                        $('#detailDoctor').val(data.DoctorName);
                        $('#detailPatient').val(data.PatientName);
                        $('#detailDate').val(data.DateOfApp);
                        $('#detailTime').val(data.StartTime);
                        $('#detailDuration').val(data.DurationInMin + " دقيقة");
                        $('#detailType').val(data.BookingType);
                        $('#detailNotes').val(data.Note);

                        $('#detailPhone1').val(data.Phone1);
                        $('#detailPhone2').val(data.Phone2);
                        $('#detailAge').val(data.Age);
                        $('#detailChronic').val(data.ChronicDiseases);
                        $('#detailAllergy').val(data.Allergy);
                        $('#detailLastVisit').val(data.LastVisitDate);
                        $('#detailBalance').val(data.Balance);

                        // ضبط زر التأكيد
                        const confirmBtn = $('#appointmentDetailsModal .action-btn').first();

                        if (data.IsConfirmed) {
                            confirmBtn.prop('disabled', true).css({
                                'background-color': '#888',
                                'cursor': 'not-allowed'
                            });
                        } else {
                            confirmBtn.prop('disabled', false).css({
                                'background-color': '#4CAF50',
                                'cursor': 'pointer'
                            });

                            confirmBtn.off('click').on('click', function () {
                                if (confirm("هل أنت متأكد من تأكيد الزيارة وفتح بطاقة الزيارة؟")) {
                                    $.ajax({
                                        type: "POST",
                                        url: "DashboardAppointments.aspx/ConfirmAppointment",
                                        data: JSON.stringify({ appointmentId: currentAppointmentId }),
                                        contentType: "application/json; charset=utf-8",
                                        dataType: "json",
                                        success: function () {
                                            alert("تم تأكيد الموعد!");
                                            confirmBtn.prop('disabled', true).css({
                                                'background-color': '#888',
                                                'cursor': 'not-allowed'
                                            });
                                            // فتح صفحة بطاقة الزيارة
                                            window.location.href = 'OpenTreatmentCard.aspx';
                                        },
                                        error: function (err) {
                                            alert("خطأ أثناء تأكيد الموعد: " + err.responseText);
                                        }
                                    });
                                }
                            });
                        }
                    },
                    error: function (err) {
                        alert("خطأ أثناء جلب بيانات الموعد: " + err.responseText);
                    }
                });
            }

            // إغلاق مودال
            window.closeAppointmentDetailsModal = function () {
                $('#appointmentDetailsModal').fadeOut(200);
                currentAppointmentId = null; // إعادة تعيين الرقم عند الإغلاق
            }

            // فتح المودال عند النقر المزدوج على موعد
            $(document).on('dblclick', '.appointment', function () {
                const appointmentId = $(this).data('id');
                openAppointmentDetailsModal(appointmentId);
            });

            // زر تعديل الملاحظات
            const editNotesBtn = $('#appointmentDetailsModal .action-btn').eq(2);
            editNotesBtn.off('click').on('click', function () {
                if (!currentAppointmentId) return alert("لا يوجد موعد محدد!");
                const updatedNotes = $('#detailNotes').val();
                if (confirm("هل تريد حفظ التعديلات على الملاحظات؟")) {
                    $.ajax({
                        type: "POST",
                        url: "DashboardAppointments.aspx/UpdateAppointmentNotes",
                        data: JSON.stringify({ appointmentId: currentAppointmentId, notes: updatedNotes }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function () {
                            alert("تم تعديل الملاحظات بنجاح!");
                        },
                        error: function (err) {
                            alert("خطأ أثناء تعديل الملاحظات: " + err.responseText);
                        }
                    });
                }
            });

        });
    </script>    <%--سكربت عرض الزيارة ومعلومات الزيارة--%>
    <script>
        confirmBtn.click(function () {
            if (confirm('هل أنت متأكد من فتح الزيارة وتأكيد الوصول؟')) {
                $.ajax({
                    type: "POST",
                    url: "DashboardAppointments.aspx/ConfirmAppointment",
                    data: JSON.stringify({ appointmentId: data.AppointmentID }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function () {
                        confirmBtn.prop('disabled', true);
                        confirmBtn.css({
                            'background-color': '#888',
                            'cursor': 'not-allowed'
                        });
                        alert('تم تأكيد الوصول بنجاح!');
                    },
                    error: function (err) {
                        alert('حدث خطأ أثناء تأكيد الوصول: ' + err.responseText);
                    }
                });
            }
        });
    </script>    <%--سكربت تاكيد الموعد وفتح بطاقة زيارة--%>
    <script>
        $(document).ready(function () {
            if (typeof interact === 'undefined') { alert('interact.js لم يتم تحميله'); return; }

            const timeColumn = document.getElementById('timeColumn');
            const daysContainer = document.getElementById('daysContainer');
            const slotHeight = 110 / 12;
            const headerHeight = 40;
            let lastAction = null;

            // حفظ واستعادة التواريخ
            function saveCurrentDates() {
                $('#hdnDateFrom').val($('#dateFrom').val());
                $('#hdnDateTo').val($('#dateTo').val());
            }

            function restoreDates() {
                const from = $('#hdnDateFrom').val();
                const to = $('#hdnDateTo').val();
                if (from) $('#dateFrom').val(from);
                if (to) $('#dateTo').val(to);
            }

            // Snackbar
            function showSnackbar(message, undoCallback) {
                const snackbar = $('#snackbar');
                $('#snackbar-text').text(message);

                if (undoCallback) {
                    $('#undoBtn').show().off('click').on('click', function () {
                        undoCallback();
                        restoreDates(); // إعادة التواريخ بعد التراجع
                        snackbar.fadeOut(200);
                    });
                } else {
                    $('#undoBtn').hide();
                }

                snackbar.fadeIn(200);

                setTimeout(() => {
                    snackbar.fadeOut(200);
                }, 4000);
            }
            restoreDates(); // إعادة التواريخ بعد التراجع
            $('#undoBtn').click(function () {
                if (lastAction) { lastAction(); lastAction = null; restoreDates(); $('#snackbar').fadeOut(200); }
            });

            // السحب
            function initDraggable(elem) {
                let longPressTimer = null;
                let interactInstance = null;
                let startPos = { x: 0, y: 0 };
                let currentPos = { x: 0, y: 0 };
                let haloActive = false;

                const isTouchDevice = ('ontouchstart' in window) || navigator.maxTouchPoints > 0;

                const cleanup = () => {
                    clearTimeout(longPressTimer);
                    elem.removeEventListener('pointermove', onMove);
                    elem.removeEventListener('pointerup', cleanup);
                    elem.removeEventListener('pointercancel', cleanup);

                    if (haloActive && !interactInstance) {
                        elem.style.boxShadow = '';
                        haloActive = false;
                    }
                };

                const onMove = (e) => {
                    const dx = Math.abs(e.clientX - startPos.x);
                    const dy = Math.abs(e.clientY - startPos.y);
                    if (dx > 5 || dy > 5) cleanup();
                };

                elem.addEventListener('pointerdown', (e) => {
                    startPos = { x: e.clientX, y: e.clientY };

                    if (isTouchDevice) {
                        longPressTimer = setTimeout(() => {
                            haloActive = true;
                            elem.style.boxShadow = '0 0 0 3px red inset';

                            if (!interactInstance) {
                                interactInstance = interact(elem).draggable({
                                    inertia: false,
                                    autoScroll: true,
                                    listeners: {
                                        start(ev) {
                                            elem.style.cursor = 'grabbing';
                                            elem.style.boxShadow = '';
                                            haloActive = false;
                                        },
                                        move(ev) {
                                            currentPos.x += ev.dx;
                                            currentPos.y += ev.dy;
                                            elem.style.transform = `translate(${currentPos.x}px, ${currentPos.y}px)`;
                                        },
                                        end(ev) {
                                            elem.style.cursor = 'grab';
                                            if (interactInstance) {
                                                interactInstance.unset();
                                                interactInstance = null;
                                            }
                                        }
                                    }
                                });
                            }
                        }, 700);

                        elem.addEventListener('pointermove', onMove);
                        elem.addEventListener('pointerup', cleanup);
                        elem.addEventListener('pointercancel', cleanup);

                    } else {
                        if (!interactInstance) {
                            interactInstance = interact(elem).draggable({
                                inertia: false,
                                autoScroll: true,
                                listeners: {
                                    start(ev) {
                                        elem.style.cursor = 'grabbing';
                                    },
                                    move(ev) {
                                        currentPos.x += ev.dx;
                                        currentPos.y += ev.dy;
                                        elem.style.transform = `translate(${currentPos.x}px, ${currentPos.y}px)`;
                                    },
                                    end(ev) {
                                        elem.style.cursor = 'grab';
                                        if (interactInstance) {
                                            interactInstance.unset();
                                            interactInstance = null;
                                        }
                                    }
                                }
                            });
                        }
                    }
                });

                elem.style.cursor = 'grab';
            }

            // التكبير
            function initResizable(elem) {
                interact(elem).resizable({
                    edges: { bottom: true },
                    inertia: false,
                    listeners: {
                        move(event) {
                            const target = event.target;
                            let y = parseFloat(target.dataset.y) || 0;
                            let height = parseFloat(target.dataset.height) || target.offsetHeight;
                            height += event.deltaRect.height;
                            if (height < 20) height = 20;
                            target.style.height = height + 'px';
                            target.dataset.height = height;
                            target.style.transform = `translate(${target.dataset.x || 0}px, ${y}px)`;
                        },
                        end(event) {
                            const target = event.target;
                            const appointmentId = target.dataset.id;
                            const oldHeight = target.style.height;
                            const oldDuration = target.dataset.duration;

                            const heightPx = parseFloat(target.style.height);
                            let durationMin = Math.round(heightPx / (slotHeight * 12) * 60);

                            const dayCol = target.closest('.day-column');
                            const currentStartParts = target.dataset.startTime.split(':');
                            const currentStart = parseInt(currentStartParts[0]) * 60 + parseInt(currentStartParts[1]);

                            const appointmentsAfter = Array.from(dayCol.querySelectorAll('.appointment'))
                                .filter(a => a !== target && a.dataset.isCancelled !== "1")
                                .map(a => {
                                    const parts = a.dataset.startTime.split(':');
                                    const start = parseInt(parts[0]) * 60 + parseInt(parts[1]);
                                    return { start, element: a };
                                })
                                .filter(a => a.start > currentStart)
                                .sort((a, b) => a.start - b.start);

                            let maxDuration = appointmentsAfter.length > 0 ? appointmentsAfter[0].start - currentStart : 200;
                            if (durationMin > maxDuration) durationMin = maxDuration;
                            target.dataset.duration = durationMin;
                            target.style.height = (durationMin / 60 * slotHeight * 12 - 2) + 'px';

                            const patientName = target.innerText.split("\n")[0]; // الاسم بس من السطر الأول
                            target.innerText = patientName + "\n" + " (" + durationMin + " دقيقة)";

                            saveCurrentDates(); // حفظ التواريخ قبل أي POST

                            $.ajax({
                                type: "POST",
                                url: "DashboardAppointments.aspx/UpdateAppointmentDuration",
                                data: JSON.stringify({ appointmentId: appointmentId, newDuration: durationMin }),
                                contentType: "application/json; charset=utf-8",
                                success: function () {
                                    showSnackbar("تم تعديل مدة الموعد", function () {
                                        target.dataset.duration = oldDuration;
                                        target.style.height = oldHeight;
                                        saveCurrentDates(); // حفظ قبل التراجع
                                        $.ajax({
                                            type: "POST",
                                            url: "DashboardAppointments.aspx/UpdateAppointmentDuration",
                                            data: JSON.stringify({ appointmentId: appointmentId, newDuration: oldDuration }),
                                            contentType: "application/json; charset=utf-8",
                                            success: restoreDates // استعادة التواريخ بعد التراجع
                                        });
                                    });
                                }
                            });
                        }
                    }
                });
            }
            
            // إلغاء الموعد بالـ Del + كليك
            let selectedAppointment = null;
            $(document).on('click', '.appointment', function () {
                $('.appointment').removeClass('selected');
                $(this).addClass('selected');
                selectedAppointment = this;
            });

            $(document).keydown(function (e) {
                if (e.key === "Delete" && selectedAppointment && selectedAppointment.dataset.isCancelled !== "1") {
                    const appointmentId = selectedAppointment.dataset.id;
                    if (confirm("هل تريد إلغاء هذا الموعد؟")) {
                        saveCurrentDates(); // حفظ التواريخ قبل الإلغاء
                        $.ajax({
                            type: "POST",
                            url: "DashboardAppointments.aspx/DeleteAppointment",
                            data: JSON.stringify({ appointmentId: appointmentId }),
                            contentType: "application/json; charset=utf-8",
                            success: function () {
                                selectedAppointment.style.backgroundColor = "#ccc";
                                selectedAppointment.dataset.isCancelled = "1";
                                showSnackbar("تم إلغاء الموعد");
                                selectedAppointment = null;
                                restoreDates(); // استعادة التواريخ
                            },
                            error: function () { alert("خطأ أثناء إلغاء الموعد"); restoreDates(); }
                        });
                    }
                }
            });

            // تحميل المواعيد
            function loadAppointments() {
                const doctorId = $('#<%= ddlDoctors.ClientID %>').val();
                const fromDate = $('#dateFrom').val();
                const toDate = $('#dateTo').val();
                if (!doctorId || !fromDate || !toDate) { alert('اختر الدكتور والفترة!'); return; }

                const lastFrom = fromDate;
                const lastTo = toDate;

                saveCurrentDates(); // حفظ قبل التحميل

                $.ajax({
                    type: "POST",
                    url: "DashboardAppointments.aspx/GetAppointments",
                    data: JSON.stringify({ doctorId: doctorId, fromDate: fromDate, toDate: toDate }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {

                        $('#dateFrom').val($('#hdnDateFrom').val() || lastFrom);
                        $('#dateTo').val($('#hdnDateTo').val() || lastTo);

                        daysContainer.innerHTML = '';
                        timeColumn.innerHTML = '';
                        const data = response.d;

                        data.forEach((day, index) => {
                            let dayCol = document.createElement('div');
                            dayCol.className = 'day-column';
                            dayCol.dataset.date = day.ScheduleDate;

                            let header = document.createElement('div');
                            header.className = 'day-header';
                            header.innerText = day.ScheduleDate;
                            dayCol.appendChild(header);

                            for (let h = day.StartHour; h <= day.EndHour; h++) {
                                let slotDiv = document.createElement('div');
                                slotDiv.className = 'slot empty';
                                slotDiv.dataset.time = (h < 10 ? '0' + h : h) + ':00';
                                slotDiv.style.position = 'relative';
                                dayCol.appendChild(slotDiv);
                            }

                            if (index === 0) {
                                for (let h = day.StartHour; h <= day.EndHour; h++) {
                                    let slot1 = document.createElement('div');
                                    slot1.className = 'time-slot';
                                    slot1.innerText = (h < 10 ? '0' : '') + h + ':00';
                                    timeColumn.appendChild(slot1);
                                }
                            }

                            day.Appointments.forEach(a => {
                                let appDiv = document.createElement('div');
                                appDiv.className = 'appointment';
                                appDiv.innerText = a.PatientName + "\n" + " (" + a.DurationInMin + " دقيقة)";
                                appDiv.dataset.id = a.AppointmentID;
                                appDiv.dataset.startTime = a.StartTime;
                                appDiv.dataset.duration = a.DurationInMin;
                                appDiv.dataset.isCancelled = a.IsCancelled || "0";
                                appDiv.style.backgroundColor = a.IsCancelled ? "#ccc" : (a.BookingColor || '#ffb74d');

                                let startParts = a.StartTime.split(':');
                                let startMin = parseInt(startParts[0]) * 60 + parseInt(startParts[1]);
                                let duration = a.DurationInMin;

                                appDiv.style.top = ((startMin - day.StartHour * 60) / 60 * slotHeight * 12) + headerHeight + 'px';
                                appDiv.style.height = (duration / 60 * slotHeight * 12 - 2) + 'px';

                                dayCol.appendChild(appDiv);
                                initDraggable(appDiv);
                                initResizable(appDiv);
                            });

                            daysContainer.appendChild(dayCol);
                        });

                        setupDropzones();
                    },
                    error: function (err) { console.error(err); alert('خطأ أثناء جلب البيانات'); restoreDates(); }
                });
            }

            // Dropzone للسحب
            function setupDropzones() {
                interact('.day-column').unset();
                interact('.day-column').dropzone({
                    accept: '.appointment',
                    overlap: 0.5,
                    ondrop: function (event) {
                        const appointment = event.relatedTarget;
                        const oldCol = appointment.closest('.day-column');
                        const newCol = event.target.closest('.day-column');
                        const date = newCol.dataset.date;

                        const colRect = newCol.getBoundingClientRect();
                        const yInCol = appointment.getBoundingClientRect().top - colRect.top - headerHeight;
                        let newStart = Math.round(yInCol / (slotHeight * 12) * 60) + parseInt(newCol.querySelector('.slot').dataset.time.split(':')[0]) * 60;
                        const duration = parseInt(appointment.dataset.duration);

                        const existingAppointments = Array.from(newCol.querySelectorAll('.appointment'))
                            .filter(a => a !== appointment && a.dataset.isCancelled !== "1")
                            .map(a => {
                                const parts = a.dataset.startTime.split(':');
                                const start = parseInt(parts[0]) * 60 + parseInt(parts[1]);
                                const end = start + parseInt(a.dataset.duration);
                                return { start, end };
                            })
                            .sort((a, b) => a.start - b.start);

                        for (let a of existingAppointments) {
                            if (newStart < a.end && (newStart + duration) > a.start) newStart = a.end;
                        }

                        const snappedHours = Math.floor(newStart / 60);
                        const snappedMinutes = newStart % 60;
                        const snappedTime = (snappedHours < 10 ? '0' : '') + snappedHours + ':' + (snappedMinutes < 10 ? '0' : '') + snappedMinutes;

                        saveCurrentDates(); // حفظ قبل أي حركة

                        if (event.ctrlKey || window.event.ctrlKey) {
                            let clone = appointment.cloneNode(true);
                            clone.dataset.id = "temp_" + Date.now();
                            clone.dataset.startTime = snappedTime;
                            clone.dataset.x = 0;
                            clone.dataset.y = 0;
                            clone.style.transform = `translate(0px,0px)`;
                            clone.style.top = ((newStart - parseInt(newCol.querySelector('.slot').dataset.time.split(':')[0]) * 60) / 60 * slotHeight * 12 + headerHeight) + 'px';
                            clone.style.height = (duration / 60 * slotHeight * 12 - 2) + 'px';
                            newCol.appendChild(clone);
                            initDraggable(clone);
                            initResizable(clone);

                            $.ajax({
                                type: "POST",
                                url: "DashboardAppointments.aspx/CopyAppointment",
                                data: JSON.stringify({ appointmentId: appointment.dataset.id, newDate: date, newStartTime: snappedTime }),
                                contentType: "application/json; charset=utf-8",
                                success: function () { loadAppointments(); showSnackbar("تم نسخ الموعد"); restoreDates(); },
                                error: function () { alert('خطأ عند نسخ الموعد'); loadAppointments(); restoreDates(); }
                            });
                        } else {
                            $.ajax({
                                type: "POST",
                                url: "DashboardAppointments.aspx/MoveAppointment",
                                data: JSON.stringify({ appointmentId: appointment.dataset.id, newDate: date, newStartTime: snappedTime }),
                                contentType: "application/json; charset=utf-8",
                                success: function () { loadAppointments(); restoreDates(); },
                                error: function () { alert('خطأ عند تحريك الموعد'); loadAppointments(); restoreDates(); }
                            });
                        }
                    }
                });
            }

            // تهيئة
            const today = new Date();
            const nextMonth = new Date();
            nextMonth.setMonth(nextMonth.getMonth() + 1);
            const ddl = $('#<%= ddlDoctors.ClientID %>');
            if (ddl.find("option").length > 0) ddl.prop("selectedIndex", 0);

            $('#dateFrom').val(today.toISOString().split('T')[0]);
            $('#dateTo').val(nextMonth.toISOString().split('T')[0]);
            $('#btnLoad').click(loadAppointments);
            loadAppointments();
        });
    </script>
    <script>
        $(document).ready(function () {
            let lastAddedAppointmentId = null;
            let isDrawing = false;
            let startY = 0;
            let drawDiv = null;
            let currentColumn = null;
            const slotHeight = 110 / 12;
            const DRAW_THRESHOLD = 5;
            let longPressTimeout = null;
            let canDraw = false;

            function minutesToTime(min) {
                let h = Math.floor(min / 60);
                let m = min % 60;
                return (h < 10 ? '0' : '') + h + ':' + (m < 10 ? '0' : '') + m;
            }

            function showAddModal(startTime, duration, date, onSave) {
                $.ajax({
                    type: "POST",
                    url: "DashboardAppointments.aspx/GetPatients",
                    data: JSON.stringify({ clinicId: '<%= Session("ClinicID") %>' }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) {
                        const ddl = $('#ddlPatientList');
                        ddl.empty();
                        res.d.forEach(p => ddl.append(`<option value="${p.PatientID}">${p.FullName}</option>`));
                    },
                    error: function (xhr) { alert("خطأ في تحميل المرضى: " + xhr.responseText); }
                });

                $('#addAppointmentModal').fadeIn(200);

                $('#saveNewAppointment').off('click').on('click', function () {
                    const patientId = $('#ddlPatientList').val();
                    let dur = parseInt($('#newDuration').val()) || duration;
                    let startParts = $('#newStartTime').val().split(':');
                    let newStartTime = parseInt(startParts[0]) * 60 + parseInt(startParts[1]);
                    let color = $('#appointmentColor').val();
                    let tools = $('#ddlTools').val() || [];
                    if (!patientId) { alert('اختر المريض'); return; }
                    $('#addAppointmentModal').fadeOut(200);
                    onSave(patientId, dur, newStartTime, color, tools);
                });

                $('#cancelNewAppointment').off('click').on('click', function () {
                    $('#addAppointmentModal').fadeOut(200);
                });
            }

            // منع تحريك الشاشة أثناء الرسم (قوي)
            function preventScroll(e) {
                if (isDrawing) e.preventDefault();
            }
            document.addEventListener('touchmove', preventScroll, { passive: false });
            document.addEventListener('touchstart', preventScroll, { passive: false });

            function startDrawing(e) {
                const clientY = e.touches ? e.touches[0].clientY : e.clientY;
                currentColumn = $(this).closest('.day-column')[0];
                let colRect = currentColumn.getBoundingClientRect();
                startY = clientY - colRect.top;
                canDraw = false;
                isDrawing = false; // لم يبدأ الرسم بعد

                longPressTimeout = setTimeout(() => {
                    if (currentColumn) {
                        canDraw = true;
                        isDrawing = true;

                        // إنشاء المربع الأخضر
                        drawDiv = document.createElement('div');
                        Object.assign(drawDiv.style, {
                            position: 'absolute',
                            left: '0',
                            top: startY + 'px',
                            width: '100%',
                            background: 'rgba(76, 175, 80, 0.3)',
                            border: '2px dashed #4CAF50',
                            zIndex: 15,
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            fontSize: '12px',
                            color: '#333',
                            fontWeight: 'bold'
                        });
                        drawDiv.innerText = '...';
                        currentColumn.appendChild(drawDiv);
                    }
                }, 700);

                if (e.touches) e.preventDefault();
            }

            function moveDrawing(e) {
                if (!isDrawing || !canDraw || !drawDiv) return;

                const clientY = e.touches ? e.touches[0].clientY : e.clientY;
                let colRect = currentColumn.getBoundingClientRect();
                let y = clientY - colRect.top;
                let top = Math.min(startY, y);
                let height = Math.abs(y - startY);

                drawDiv.style.top = top + 'px';
                drawDiv.style.height = height + 'px';

                let startMin = Math.round(top / (slotHeight * 12) * 60) +
                    parseInt(currentColumn.querySelector('.slot').dataset.time.split(':')[0]) * 60;
                let duration = Math.round(height / (slotHeight * 12) * 60);

                let adjustedStartMin = startMin - 22; // نقص 22 دقيقة
                if (adjustedStartMin < 0) adjustedStartMin = 0; // لتجنب القيم السالبة
                drawDiv.innerText = `${minutesToTime(adjustedStartMin)} | ${duration} دقيقة`;


                if (e.touches) e.preventDefault();
            }

            function endDrawing(e) {
                clearTimeout(longPressTimeout);
                if (!currentColumn) return;
                isDrawing = false;

                if (!canDraw || !drawDiv) { drawDiv?.remove(); drawDiv = null; return; }

                let top = parseFloat(drawDiv.style.top);
                let height = parseFloat(drawDiv.style.height);
                if (height < DRAW_THRESHOLD) { drawDiv.remove(); drawDiv = null; return; }

                let startMin = Math.round(top / (slotHeight * 12) * 60) +
                    parseInt(currentColumn.querySelector('.slot').dataset.time.split(':')[0]) * 60;
                let duration = Math.round(height / (slotHeight * 12) * 60);
                const date = currentColumn.dataset.date;

                drawDiv.remove();
                drawDiv = null;

                // === التغيير الأساسي ===
                // فتح البانيل
                $('#appointmentModal').fadeIn(200).css("display", "flex");

                // ملأ البيانات تلقائيًا
                $('#<%= doctorSelect.ClientID %>').val($('#<%= ddlDoctors.ClientID %>').val()); // الطبيب
                $('#appointmentDate').val(date); // التاريخ

                let adjustedStartMin = startMin - 22;
                if (adjustedStartMin < 0) adjustedStartMin = 0;

                let hours = Math.floor(adjustedStartMin / 60);
                let minutes = adjustedStartMin % 60;
                $('#appointmentTime').val(`${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`);

                $('#duration').val(duration);
            }


            $(document).on('mousedown touchstart', '.slot.empty', startDrawing);
            $(document).on('mousemove touchmove', moveDrawing);
            $(document).on('mouseup touchend', endDrawing);

            $('#btnUndoAppointment').click(function () {
                if (lastAddedAppointmentId) undoLastAppointment();
            });
        });
    </script>    <%--جلب اسم المريض ورسم حدود الموعد--%>
    <script>
        // مصفوفة ألوان جميلة وثابتة
        const colors = [
            "#4CAF50", "#FF5722", "#2196F3", "#FFC107", "#9C27B0",
            "#E91E63", "#00BCD4", "#795548", "#FF9800", "#3F51B5",
            "#009688", "#CDDC39", "#F44336", "#673AB7", "#8BC34A",
            "#FFEB3B", "#FFCDD2", "#D32F2F", "#03A9F4", "#FFB74D",
            "#A1887F", "#9E9E9E", "#607D8B", "#C2185B", "#7B1FA2",
            "#388E3C", "#F57C00", "#1976D2", "#0288D1", "#D81B60",
            "#512DA8", "#689F38", "#FBC02D", "#C62828", "#1976D2",
            "#00796B", "#F06292", "#FFA000", "#5D4037", "#303F9F"
        ];

        const palette = document.getElementById('colorPalette');
        const colorInput = document.getElementById('colorPicker');

        colors.forEach(color => {
            const swatch = document.createElement('div');
            swatch.style.backgroundColor = color;
            swatch.style.width = '25px';
            swatch.style.height = '25px';
            swatch.style.borderRadius = '4px';
            swatch.style.cursor = 'pointer';
            swatch.title = color; // عند المرور يظهر الكود
            swatch.addEventListener('click', () => {
                colorInput.value = color; // تخزين اللون المختار
                // تحديد اللون المختار بصريًا
                document.querySelectorAll('#colorPalette div').forEach(d => d.style.outline = '');
                swatch.style.outline = '2px solid black';
            });
            palette.appendChild(swatch);
        });

        // تحديد اللون الافتراضي
        colorInput.value = "#4CAF50";
        palette.querySelector('div[title="#4CAF50"]').style.outline = '2px solid black';
    </script>    <%--سكربت الالوان--%>
    <script>
        $(document).ready(function () {
            const $input = $('#patientSearch');
            let $dropdown = $('<ul class="autocomplete-dropdown"></ul>').css({
                position: 'absolute',
                listStyle: 'none',
                margin: 0,
                padding: '5px 0',
                border: '1px solid #ccc',
                background: '#fff',
                zIndex: 9999,
                maxHeight: '200px',
                overflowY: 'auto',
                display: 'none',
                width: $input.outerWidth()
            });
            $('body').append($dropdown);

            $input.on('input', function () {
                const query = $(this).val().trim();
                if (query.length === 0) {
                    $dropdown.hide();
                    return;
                }

                $.ajax({
                    type: 'POST',
                    url: 'DashboardAppointments.aspx/GetPatients',
                    contentType: 'application/json; charset=utf-8',
                    data: JSON.stringify({ clinicId: '<%= Session("ClinicID") %>' }),
                    dataType: 'json',
                    success: function (res) {
                        const matches = res.d.filter(p => p.FullName.toLowerCase().includes(query.toLowerCase()));
                        if (matches.length === 0) {
                            $dropdown.hide();
                            return;
                        }
                        $dropdown.empty();
                        matches.forEach(p => {
                            $('<li></li>').text(p.FullName).css({
                                padding: '5px 10px',
                                cursor: 'pointer'
                            }).appendTo($dropdown).on('mousedown', function (e) {
                                e.preventDefault(); // منع فقدان التركيز
                                $input.val(p.FullName);
                                $dropdown.hide();
                            }).hover(function () {
                                $(this).css('background', '#f0f0f0');
                            }, function () {
                                $(this).css('background', '#fff');
                            });
                        });

                        const offset = $input.offset();
                        $dropdown.css({
                            top: offset.top + $input.outerHeight(),
                            left: offset.left,
                            width: $input.outerWidth()
                        }).show();
                    },
                    error: function () {
                        $dropdown.hide();
                    }
                });
            });

            $(document).on('click', function (e) {
                if (!$(e.target).is($input)) $dropdown.hide();
            });

            $(window).on('resize scroll', function () {
                $dropdown.hide();
            });
        });
    </script>    <%--سكربت الاوتو كومبليت--%>
    <script>
        // فتح البانيل كبوب أب
        function openAppointmentModal() {
            // نسخ قيمة الدكتور
            var mainDoctor = document.getElementById('<%= ddlDoctors.ClientID %>').value;
            document.getElementById('<%= doctorSelect.ClientID %>').value = mainDoctor;

            $('#appointmentModal').fadeIn(200).css("display", "flex");
        }

        // إغلاق البانيل
        function closeAppointmentModal() {
            $('#appointmentModal').fadeOut(200);
        }
    </script>    <%--سكربت فتح البانيل--%>
    <script>
        $(document).ready(function () {
            // تحميل الإجراءات من قاعدة البيانات
            $.ajax({
                type: "POST",
                url: "DashboardAppointments.aspx/GetTreatments",
                data: JSON.stringify({ clinicId: '<%= Session("ClinicID") %>' }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    res.d.forEach(t => {
                        $('#appointmentType').append(
                            `<option value="${t.TreatmentID}" data-duration="${t.DurationMinutes}">
                        ${t.TreatmentName}
                     </option>`
                        );
                    });
                },
                error: function (xhr) {
                    alert("خطأ في تحميل الإجراءات: " + xhr.responseText);
                }
            });

            // عند تغيير نوع الحجز
            $('#appointmentType').change(function () {
                let selected = $(this).find(':selected');
                let duration = selected.data('duration');
                if (duration) {
                    $('#duration').val(duration);
                } else {
                    // الخيارات الثابتة: نخلي القيمة الافتراضية 30
                    $('#duration').val(30);
                }
            });
        });
    </script>    <%--سكربت تحميل الاإجرائات--%>
    <script>
        function saveAppointment() {
            var doctorId = document.getElementById('<%= ddlDoctors.ClientID %>').value;
            var patientName = $('#patientSearch').val();
            var appointmentDate = $('#appointmentDate').val();
            var appointmentTime = $('#appointmentTime').val();
            var duration = $('#duration').val();
            var appointmentType = $('#appointmentType option:selected').text();
            var notes = $('#notes').val();
            var color = $('#colorPicker').val();

            if (!doctorId || !patientName || !appointmentDate || !appointmentTime) {
                alert("يرجى إدخال جميع الحقول المطلوبة");
                return;
            }

            $.ajax({
                type: "POST",
                url: "DashboardAppointments.aspx/SaveAppointment",
                data: JSON.stringify({
                    doctorId: doctorId,
                    patientName: patientName,
                    appointmentDate: appointmentDate,
                    appointmentTime: appointmentTime,
                    duration: duration,
                    appointmentType: appointmentType,
                    notes: notes,
                    color: color
                }),
                contentType: "application/json; charset=utf-8",
                success: function (res) {
                    alert("تم حفظ الموعد بنجاح");
                    $('#patientSearch').val('');
                    $('#notes').val('');
                    closeAppointmentModal();
                    // إعادة تحميل المواعيد
                    $('#btnLoad').click();
                },
                error: function (err) {
                    console.error(err);
                    alert("حصل خطأ أثناء الحفظ");
                }
            });
        }
    </script>    <%--سكربت الحفظ--%>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // عناصر الصفحة
            var ddlDoctors = document.getElementById("ddlDoctors");
            var txtDatefrom = document.getElementById("dateFrom");
            var txtDateto = document.getElementById("dateTo");
            var btnLoad = document.getElementById("btnLoad");

            // تغيير الطبيب
            if (ddlDoctors) {
                ddlDoctors.addEventListener("change", function () {
                    btnLoad.click();
                });
            }

            // تغيير التاريخ
            if (txtDatefrom) {
                txtDatefrom.addEventListener("change", function () {
                    btnLoad.click();
                });
            }
            if (txtDateto) {
                txtDateto.addEventListener("change", function () {
                    btnLoad.click();
                });
            }
        });
    </script>    <%--سكربت التحميل مع تغيير الطبيب او التاريخ--%>
    <script>
        $(document).ready(function () {

            // إغلاق أي بانيل عند الضغط خارج المحتوى
            $('.modal-overlay').click(function (e) {
                // إذا العنصر الذي تم النقر عليه هو overlay نفسه وليس المحتوى
                if ($(e.target).hasClass('modal-overlay')) {
                    $(this).fadeOut(200);
                }
            });

            // الدوال الخاصة بإغلاق البانيل يدوياً
            window.closeAppointmentModal = function () {
                $('#appointmentModal').fadeOut(200);
            }

            window.closeAppointmentDetailsModal = function () {
                $('#appointmentDetailsModal').fadeOut(200);
            }

        });
    </script>    <%--إغلاق البانيل خارج منطقته--%>
</asp:Content>
