<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="TreatmentPlans.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.TreatmentPlans" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .treatment-dashboard {
            display: flex;
            gap: 30px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 50px;
        }

        .treatment-box {
            width: 330px;
            height: 330px;
            background: #f5f6fa;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            text-align: center;
            cursor: pointer;
            transition: transform 0.2s ease;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .treatment-box:hover {
            transform: scale(1.05);
        }

        .treatment-box img {
            width: 280px;
            height: 280px;
            border-radius: 15px;
            margin-bottom: 15px;
        }

        .treatment-box h3 {
            font-size: 20px;
            color: #333;
        }
    </style>

    <div class="treatment-dashboard">
        <asp:PlaceHolder ID="phTreatmentBoxes" runat="server"></asp:PlaceHolder>
    </div>

    <script type="text/javascript">
        function openPlan(department) {
            var patientID = '<%= If(Session("PatientID") IsNot Nothing, Session("PatientID").ToString(), "0") %>';
            if (patientID === "0") {
                alert("رقم المريض غير متوفر!");
                return;
            }

            switch (department) {
                case 'Dental':
                    window.location.href = 'TreatmentPlan.aspx?PatientID=' + patientID;
                    break;
                case 'Physiotherapy':
                    window.location.href = 'PhysioTreatmentPlan.aspx?PatientID=' + patientID;
                    break;
                case 'Other':
                    window.location.href = 'PhysioTreatmentPlan.aspx?PatientID=' + patientID;
                    break;
            }
        }
    </script>

</asp:Content>

