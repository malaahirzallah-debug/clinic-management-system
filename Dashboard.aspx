<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="Dashboard.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* ===================== ستايل الداش بورد ===================== */
        .dashboard-container {
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background-color: #f5f6fa;
        }

        .filter-bar {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .filter-bar label {
            font-weight: bold;
            color: #333;
        }

        .date-picker {
            padding: 6px 12px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        .btn-primary {
            background-color: #007bff;
            color: white;
            padding: 7px 18px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.2s ease;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .main-stats {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .stat-card {
            flex: 1;
            min-width: 180px;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.15);
        }

        .stat-card h3 {
            margin-bottom: 12px;
            color: #333;
            font-size: 16px;
        }

        .stat-card label,
        .stat-card span {
            font-size: 22px;
            font-weight: bold;
            color: #007bff;
            display: block;
        }

        /* ===================== المخططات ===================== */
       .charts-grid {
    display: grid;
    grid-template-columns: 1fr 1fr; /* عمودين ثابتين */
    gap: 20px;
    width: 100%; /* كامل عرض الكونتينر */
    max-width: 100%; /* تمنع أي تجاوز */
    margin: 0 auto; /* توسيط الشبكة لو أحببت */
    box-sizing: border-box; /* تحسب البادينغ ضمن العرض */
    padding: 0; /* نزيل أي padding إضافي */
}



     .chart-card {
    background-color: #fff;
    padding: 15px;
    border-radius: 10px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.08);
    display: flex;
    flex-direction: column;
    justify-content: center;
    width: 100%; 
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    box-sizing: border-box;
}



        .chart-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 16px rgba(0,0,0,0.12);
        }

        .chart-card h4 {
            margin-bottom: 15px;
            text-align: center;
            color: #444;
            font-size: 15px;
        }

        .chart-card canvas {
            width: 100% !important;
            height: 100% !important; /* ياخد كل ارتفاع البطاقة */
        }

        /* ===================== ريسبونسف ===================== */
        @media (max-width: 767px) {
            .charts-grid {
                grid-template-columns: 1fr; /* عمود واحد على الموبايل */
            }

            .main-stats {
                flex-direction: column;
            }

            .stat-card {
                width: 100%;
            }

            .chart-card {
                height: 250px; /* أقل شوي للموبايل */
            }
        }
    </style>

    <div class="dashboard-container">

        <!-- فلترة التاريخ -->
        <div class="filter-bar">
            <label>من:</label>
            <asp:TextBox ID="txtFromDate" runat="server" CssClass="date-picker" />
            <label>إلى:</label>
            <asp:TextBox ID="txtToDate" runat="server" CssClass="date-picker" />
            <asp:Button ID="btnFilter" runat="server" Text="تطبيق" CssClass="btn-primary" OnClick="btnFilter_Click" />
        </div>

        <!-- الاحصائيات الرئيسية -->
        <div class="main-stats">
            <div class="stat-card">
                <h3>عدد الحالات اليومية</h3>
                <asp:Label ID="lblDailyVisits" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-card">
                <h3>عدد المرضى الجدد</h3>
                <asp:Label ID="lblNewPatients" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-card">
                <h3>الإيرادات</h3>
                <asp:Label ID="lblRevenue" runat="server" Text="0"></asp:Label>
            </div>
            <div class="stat-card">
                <h3>معدل النمو</h3>
                <asp:Label ID="lblGrowthRate" runat="server" Text="0%"></asp:Label>
            </div>
        </div>

        <!-- المخططات -->
        <div class="charts-grid">
            <div class="chart-card">
                <h4>الإيرادات حسب الطبيب</h4>
                <canvas id="revenueByDoctorChart"></canvas>
            </div>
            <div class="chart-card">
                <h4>عدد الحالات اليومية</h4>
                <canvas id="dailyVisitsChart"></canvas>
            </div>
            <div class="chart-card">
                <h4>الإجراءات الطبية الأكثر شيوعاً</h4>
                <canvas id="treatmentsChart"></canvas>
            </div>
            <div class="chart-card">
                <h4>إجمالي الزيارات والمواعيد</h4>
                <canvas id="appointmentsChart"></canvas>
            </div>
        </div>

    </div>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script type="text/javascript">
        const revenueByDoctorChart = new Chart(document.getElementById('revenueByDoctorChart'), {
            type: 'bar',
            data: { labels: [], datasets: [{ label: 'الإيرادات', data: [], backgroundColor: '#007bff' }] },
            options: { responsive: true }
        });

        const dailyVisitsChart = new Chart(document.getElementById('dailyVisitsChart'), {
            type: 'line',
            data: { labels: [], datasets: [{ label: 'عدد الحالات', data: [], borderColor: '#28a745', fill: false }] },
            options: { responsive: true }
        });

        const treatmentsChart = new Chart(document.getElementById('treatmentsChart'), {
            type: 'pie',
            data: { labels: [], datasets: [{ data: [], backgroundColor: ['#007bff', '#28a745', '#ffc107', '#dc3545', '#6f42c1', '#17a2b8'] }] },
            options: { responsive: true }
        });

        const appointmentsChart = new Chart(document.getElementById('appointmentsChart'), {
            type: 'doughnut',
            data: { labels: ['الزيارات', 'المواعيد'], datasets: [{ data: [0, 0], backgroundColor: ['#17a2b8', '#ffc107'] }] },
            options: { responsive: true }
        });

        function updateRevenueByDoctorChart(labels, data) {
            revenueByDoctorChart.data.labels = labels;
            revenueByDoctorChart.data.datasets[0].data = data;
            revenueByDoctorChart.update();
        }

        function updateDailyVisitsChart(labels, data) {
            dailyVisitsChart.data.labels = labels;
            dailyVisitsChart.data.datasets[0].data = data;
            dailyVisitsChart.update();
        }

        function updateTreatmentsChart(labels, data) {
            treatmentsChart.data.labels = labels;
            treatmentsChart.data.datasets[0].data = data;
            treatmentsChart.update();
        }

        function updateAppointmentsChart(visits, appointments) {
            appointmentsChart.data.datasets[0].data = [visits, appointments];
            appointmentsChart.update();
        }
    </script>
</asp:Content>
