<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Appointments.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.Appointments" %>

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
            overflow-y: visible;
            position: relative;
            padding-bottom: 20px;
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
            padding: 2px;
            background: #ffb74d;
            color: #333;
            font-size: 12px;
            text-align: center;
            border-radius: 4px;
            cursor: grab;
            z-index: 10;
            pointer-events: all;
            touch-action: none;
        }
    </style>

    <!-- فلتر -->
    <div class="filter-bar">
        <asp:DropDownList ID="ddlDoctors" runat="server" CssClass="doctor-select"></asp:DropDownList>
        <input type="date" id="dateFrom" />
        <input type="date" id="dateTo" />
        <button type="button" id="btnLoad">عرض</button>
    </div>

    <!-- جدول المواعيد -->
    <div class="appointments-container">
        <div class="time-column" id="timeColumn"></div>
        <div class="days-container" id="daysContainer"></div>
    </div>

    <div id="snackbar" style="display: none; position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%); background: #323232; color: #fff; padding: 12px 20px; border-radius: 5px; box-shadow: 0 2px 6px rgba(0,0,0,0.3); z-index: 1000; font-size: 14px; display: flex; align-items: center; gap: 10px;">
        <span id="snackbar-text"></span>
        <button id="undoBtn" style="background: #f44336; border: none; color: white; padding: 5px 10px; border-radius: 3px; cursor: pointer;">تراجع</button>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="Scripts/interact.min.js"></script>



    <script>
        $(document).ready(function () {
            if (typeof interact === 'undefined') { alert('interact.js لم يتم تحميله'); return; }

            const timeColumn = document.getElementById('timeColumn');
            const daysContainer = document.getElementById('daysContainer');
            const slotHeight = 110 / 12;
            const headerHeight = 40;
            let lastAction = null;

            function showSnackbar(message, undoCallback) {
                const snackbar = $('#snackbar');
                $('#snackbar-text').text(message);
                lastAction = undoCallback;
                snackbar.fadeIn(200);
                setTimeout(() => { snackbar.fadeOut(200); lastAction = null; }, 5000);
            }

            $('#undoBtn').click(function () {
                if (lastAction) { lastAction(); lastAction = null; $('#snackbar').fadeOut(200); }
            });

            function loadAppointments() {
                const doctorId = $('#<%= ddlDoctors.ClientID %>').val();
            const fromDate = $('#dateFrom').val();
            const toDate = $('#dateTo').val();
            if (!doctorId || !fromDate || !toDate) { alert('اختر الدكتور والفترة!'); return; }

            $.ajax({
                type: "POST",
                url: "DashboardAppointments.aspx/GetAppointments",
                data: JSON.stringify({ doctorId: doctorId, fromDate: fromDate, toDate: toDate }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
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
                            appDiv.innerText = a.PatientName;
                            appDiv.dataset.id = a.AppointmentID;
                            appDiv.dataset.startTime = a.StartTime;
                            appDiv.dataset.duration = a.DurationInMin;
                            appDiv.style.backgroundColor = a.BookingColor || '#ffb74d';

                            let startParts = a.StartTime.split(':');
                            let startMin = parseInt(startParts[0]) * 60 + parseInt(startParts[1]);
                            let duration = a.DurationInMin;

                            appDiv.style.top = ((startMin - day.StartHour * 60) / 60 * slotHeight * 12) + headerHeight + 'px';
                            appDiv.style.height = (duration / 60 * slotHeight * 12 - 2) + 'px';

                            dayCol.appendChild(appDiv);
                        });

                        daysContainer.appendChild(dayCol);
                    });

                    makeAppointmentsDraggable();
                    makeSlotsDropzones();
                    makeAppointmentsResizable();
                },
                error: function (err) { console.error(err); alert('خطأ أثناء جلب البيانات'); }
            });
        }

        function makeAppointmentsResizable() {
            interact('.appointment').resizable({
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

                        // احصل على العمود والموعدات الموجودة بعد الموعد الحالي
                        const dayCol = target.closest('.day-column');
                        const currentStartParts = target.dataset.startTime.split(':');
                        const currentStart = parseInt(currentStartParts[0]) * 60 + parseInt(currentStartParts[1]);

                        // نحصل على بداية الموعد التالي إن وجد
                        const appointmentsAfter = Array.from(dayCol.querySelectorAll('.appointment'))
                            .filter(a => a !== target)
                            .map(a => {
                                const parts = a.dataset.startTime.split(':');
                                const start = parseInt(parts[0]) * 60 + parseInt(parts[1]);
                                return { start, element: a };
                            })
                            .filter(a => a.start > currentStart)
                            .sort((a, b) => a.start - b.start);

                        let maxDuration = durationMin; // بشكل افتراضي، أي تمديد مسموح
                        if (appointmentsAfter.length > 0) {
                            const nextStart = appointmentsAfter[0].start;
                            maxDuration = nextStart - currentStart;
                        }

                        // قيد الحد الأعلى
                        if (durationMin > maxDuration) {
                            durationMin = maxDuration;
                            target.style.height = (durationMin / 60 * slotHeight * 12 - 2) + 'px';
                        }

                        target.dataset.duration = durationMin;

                        $.ajax({
                            type: "POST",
                            url: "DashboardAppointments.aspx/UpdateAppointmentDuration",
                            data: JSON.stringify({ appointmentId: appointmentId, newDuration: durationMin }),
                            contentType: "application/json; charset=utf-8",
                            success: function () {
                                showSnackbar("تم تعديل مدة الموعد", function () {
                                    target.dataset.duration = oldDuration;
                                    target.style.height = oldHeight;
                                    $.ajax({
                                        type: "POST",
                                        url: "DashboardAppointments.aspx/UpdateAppointmentDuration",
                                        data: JSON.stringify({ appointmentId: appointmentId, newDuration: oldDuration }),
                                        contentType: "application/json; charset=utf-8"
                                    });
                                });
                            }
                        });
                    }
                }
            });
        }

        function makeAppointmentsDraggable() {
            interact('.appointment').draggable({
                inertia: false,
                autoScroll: true,
                listeners: {
                    start(event) {
                        event.target.dataset.origX = event.target.dataset.x || 0;
                        event.target.dataset.origY = event.target.dataset.y || 0;
                        event.target.style.cursor = 'grabbing';
                    },
                    move(event) {
                        const target = event.target;
                        let x = parseFloat(target.dataset.x) || 0;
                        let y = parseFloat(target.dataset.y) || 0;
                        x += event.dx;
                        y += event.dy;
                        target.style.transform = `translate(${x}px, ${y}px)`;
                        target.dataset.x = x;
                        target.dataset.y = y;
                    },
                    end(event) { event.target.style.cursor = 'grab'; }
                }
            });
        }

        function makeSlotsDropzones() {
            interact('.day-column').dropzone({
                accept: '.appointment',
                overlap: 0.5,
                ondrop: function (event) {
                    const appointment = event.relatedTarget;
                    const oldCol = appointment.closest('.day-column');
                    const newCol = event.target.closest('.day-column');
                    const date = newCol.dataset.date;
                    const origX = parseFloat(appointment.dataset.origX) || 0;
                    const origY = parseFloat(appointment.dataset.origY) || 0;

                    const colRect = newCol.getBoundingClientRect();
                    const yInCol = appointment.getBoundingClientRect().top - colRect.top - headerHeight;
                    let newStart = Math.round(yInCol / (slotHeight * 12) * 60) + parseInt(newCol.querySelector('.slot').dataset.time.split(':')[0]) * 60;

                    const duration = parseInt(appointment.dataset.duration);

                    // احسب تصادم المواعيد
                    const existingAppointments = Array.from(newCol.querySelectorAll('.appointment'))
                        .filter(a => a !== appointment)
                        .map(a => {
                            const parts = a.dataset.startTime.split(':');
                            const start = parseInt(parts[0]) * 60 + parseInt(parts[1]);
                            const end = start + parseInt(a.dataset.duration);
                            return { start, end };
                        })
                        .sort((a, b) => a.start - b.start);

                    for (let a of existingAppointments) {
                        if (newStart < a.end && (newStart + duration) > a.start) {
                            newStart = a.end;
                        }
                    }

                    const snappedHours = Math.floor(newStart / 60);
                    const snappedMinutes = newStart % 60;
                    const snappedTime = (snappedHours < 10 ? '0' : '') + snappedHours + ':' + (snappedMinutes < 10 ? '0' : '') + snappedMinutes;

                    appointment.dataset.startTime = snappedTime;
                    appointment.dataset.x = 0;
                    appointment.dataset.y = 0;
                    appointment.style.transform = `translate(0px,0px)`;
                    appointment.style.top = ((newStart - parseInt(newCol.querySelector('.slot').dataset.time.split(':')[0]) * 60) / 60 * slotHeight * 12 + headerHeight) + 'px';
                    appointment.style.height = (duration / 60 * slotHeight * 12 - 2) + 'px';

                    if (oldCol !== newCol) newCol.appendChild(appointment);

                    $.ajax({
                        type: "POST",
                        url: "DashboardAppointments.aspx/MoveAppointment",
                        data: JSON.stringify({ appointmentId: appointment.dataset.id, newDate: date, newStartTime: snappedTime }),
                        contentType: "application/json; charset=utf-8",
                        error: function () { alert('خطأ عند تحريك الموعد'); resetAppointment(appointment, origX, origY); }
                    });
                }
            });

            function resetAppointment(app, x, y) {
                app.dataset.x = x;
                app.dataset.y = y;
                app.style.transform = `translate(${x}px,${y}px)`;
            }
        }

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


</asp:Content>
