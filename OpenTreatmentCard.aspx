<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="OpenTreatmentCard.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.OpenTreatmentCard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .treatment-container {
            max-width: 1100px;
            margin: 24px auto;
            padding: 16px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            color: #333;
        }

        .treatment-title {
            text-align: center;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        .group-buttons, .treatment-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            justify-content: center;
            margin-bottom: 20px;
        }

        .group-btn, .treatment-btn {
            padding: 14px 18px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            background: #0078d7;
            color: white;
            font-size: 14px;
            transition: 0.3s;
        }

        .group-btn:hover, .treatment-btn:hover {
            background: #005fa3;
        }

        .treatment-grid-container {
            overflow-x: auto;
        }

        .treatment-grid {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 16px;
        }

        .treatment-grid th, .treatment-grid td {
            border: 1px solid #ddd;
            padding: 8px 12px;
            text-align: center;
        }

        .treatment-grid th {
            background: #f4f6f8;
        }

        .delete-btn {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 4px 8px;
            border-radius: 6px;
            cursor: pointer;
        }

        .delete-btn:hover {
            background: #c0392b;
        }

        .treatment-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .btn-pay {
            background: #27ae60;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            transition: 0.3s;
        }

        .btn-pay:hover {
            background: #1f8f4f;
        }
    </style>

    <div class="treatment-container">
        <h2 class="treatment-title">🦷 بطاقة معالجة المريض</h2>

        <!-- أزرار الجروبات -->
        <div class="group-buttons">
            <asp:Repeater ID="rptGroups" runat="server">
                <ItemTemplate>
                    <button type="button" class="group-btn" data-group='<%# Eval("GroupID") %>'>
                        <%# Eval("GroupName") %>
                    </button>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- أزرار التريتمنت الفرعية -->
        <div class="treatment-buttons"></div>

        <!-- جدول الإجراءات -->
        <div class="treatment-grid-container">
            <table class="treatment-grid">
                <thead>
                    <tr>
                        <th>الإجراء</th>
                        <th>القيمة</th>
                        <th>حذف</th>
                    </tr>
                </thead>
                <tbody id="treatment-list"></tbody>
            </table>
        </div>

        <div class="treatment-summary">
            <label>المجموع الكلي: <span id="totalAmount">0</span> دينار</label>
            <button id="btnPay" type="button" class="btn-pay">💳 دفع</button>
        </div>
    </div>

    <script>
        // جلب بيانات التريتمنت من CodeBehind
        const treatmentData = <%= TreatmentsJson %>;

        const treatmentButtonsDiv = document.querySelector('.treatment-buttons');
        const treatmentListTbody = document.getElementById('treatment-list');
        const totalAmountSpan = document.getElementById('totalAmount');

        document.querySelectorAll('.group-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const groupId = btn.dataset.group;
                treatmentButtonsDiv.innerHTML = '';
                treatmentData[groupId].forEach(tr => {
                    const tbtn = document.createElement('button');
                    tbtn.type = 'button';
                    tbtn.textContent = `${tr.name} (${tr.price} د.)`;
                    tbtn.className = 'treatment-btn';
                    tbtn.addEventListener('click', () => addTreatment(tr.name, tr.price));
                    treatmentButtonsDiv.appendChild(tbtn);
                });
            });
        });

        function addTreatment(name, price) {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${name}</td>
                <td>${price}</td>
                <td><button class="delete-btn" onclick="removeTreatment(this)">❌</button></td>
            `;
            treatmentListTbody.appendChild(tr);
            updateTotal();
        }

        function removeTreatment(btn) {
            btn.closest('tr').remove();
            updateTotal();
        }

        function updateTotal() {
            let total = 0;
            treatmentListTbody.querySelectorAll('tr').forEach(r => total += parseFloat(r.cells[1].textContent));
            totalAmountSpan.textContent = total;
        }

        document.getElementById('btnPay').addEventListener('click', function (e) {
            e.preventDefault();

            const treatments = Array.from(treatmentListTbody.querySelectorAll('tr')).map(r => r.cells[0].textContent);

            if (treatments.length === 0) {
                alert('يرجى اختيار إجراءات قبل الدفع.');
                return;
            }

            const treatmentsText = treatments.join('\n');
            localStorage.setItem('selectedTreatments', treatmentsText);
            const total = Array.from(treatmentListTbody.querySelectorAll('tr'))
                .reduce((sum, r) => sum + parseFloat(r.cells[1].textContent), 0);
            localStorage.setItem('totalAmount', total);
            window.location.href = 'MedicalReport.aspx';
        });

    </script>


</asp:Content>
