<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="ManageChronicDiseases.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.ManageChronicDiseases" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .form-container {
            max-width: 700px;
            margin: 30px auto;
            padding: 20px;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            font-family: "Segoe UI", Tahoma, sans-serif;
            direction: rtl;
            text-align: right;
        }

        .form-title {
            text-align: center;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 25px;
            color: #2c3e50;
        }

        .form-group {
            margin-bottom: 16px;
        }

            .form-group label {
                font-weight: 600;
                margin-bottom: 6px;
                display: block;
            }

        .form-control {
            width: 100%;
            padding: 10px 14px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

            .form-control:focus {
                outline: none;
                border-color: #0078d7;
                box-shadow: 0 0 6px rgba(0,120,215,0.3);
            }

        .form-actions {
            text-align: center;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 22px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            margin: 5px;
            transition: 0.3s;
        }

        .btn-save {
            background-color: #28a745;
            color: #fff;
        }

            .btn-save:hover {
                background-color: #218838;
            }

        .btn-close1 {
            background-color: #dc3545;
            color: #fff;
        }

            .btn-close1:hover {
                background-color: #b52a37;
            }


        .table-actions {
            text-align: center;
        }
    </style>

    <div class="form-container">
        <div class="form-title">
            <i class="bi bi-heart-pulse"></i>إدارة الأمراض المزمنة
        </div>

        <!-- إضافة مرض جديد -->
        <div class="form-group">
            <label for="txtNewDisease">أدخل اسم المرض:</label>
            <asp:TextBox ID="txtNewDisease" runat="server" CssClass="form-control" Placeholder="أدخل اسم المرض"></asp:TextBox>
        </div>
        <div class="form-actions">
            <asp:Button ID="btnSaveDisease" runat="server" Text="💾 حفظ" CssClass="btn btn-save" OnClick="btnSaveDisease_Click" />
            <asp:Button ID="btnClose" runat="server" Text="❌ إغلاق" CssClass="btn btn-close1" OnClick="btnClose_Click" />
        </div>

        <!-- جدول عرض الأمراض الحالية -->
        <div class="mt-4">
            <asp:GridView ID="gvDiseases" runat="server" AutoGenerateColumns="False" CssClass="table table-hover"
                EmptyDataText="لا توجد أمراض مسجلة بعد." ShowHeaderWhenEmpty="True"
                DataKeyNames="DiseaseID">
                <Columns>
                    <asp:BoundField DataField="DiseaseID" HeaderText="ID" ReadOnly="True" ItemStyle-Width="50px" />
                    <asp:BoundField DataField="DiseaseName" HeaderText="اسم المرض" />
                    <asp:CommandField ShowDeleteButton="True" ItemStyle-CssClass="table-actions" />
                </Columns>
            </asp:GridView>

        </div>
    </div>

</asp:Content>

