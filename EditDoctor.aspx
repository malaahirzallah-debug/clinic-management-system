<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="EditDoctor.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.EditDoctor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="edit-doctor-container">
        <h2 class="edit-doctor-title">✏️ تعديل بيانات الطبيب</h2>

        <div class="edit-doctor-form">
            <asp:HiddenField ID="hfDoctorID" runat="server" />

            <div class="form-group">
                <label for="txtDoctorName">اسم الطبيب:</label>
                <asp:TextBox ID="txtDoctorName" runat="server" CssClass="form-input" />
            </div>

            <div class="form-group">
                <label for="txtSpecialty">التخصص:</label>
                <asp:TextBox ID="txtSpecialty" runat="server" CssClass="form-input" />
            </div>

            <div class="form-group">
                <label for="txtPhone">رقم الهاتف:</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" />
            </div>

            <div class="form-group checkbox-group">
                <asp:CheckBox ID="chkActive" runat="server" />
                <label for="chkActive">تفعيل الطبيب</label>
            </div>

            <div class="form-group">
                <label for="txtCreatedAt">تاريخ الإضافة:</label>
                <asp:TextBox ID="txtCreatedAt" runat="server" CssClass="form-input" ReadOnly="true" />
            </div>
        </div>

        <div class="form-actions">
            <asp:Button ID="btnUpdateDoctor" runat="server" CssClass="btn-save" Text="💾 حفظ التعديلات" />
            <asp:Button ID="btnClearDoctor" runat="server" CssClass="btn-clear" Text="🧹 مسح الحقول" />
            <asp:Button ID="btnBack" runat="server" CssClass="btn-back" Text="⬅️ رجوع" OnClientClick="history.back(); return false;" />
        </div>
    </div>

    <style>
        .edit-doctor-container {
            max-width: 700px;
            margin: 24px auto;
            padding: 16px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            color: #333;
        }

        .btn-back {
    padding: 10px 20px;
    border-radius: 10px;
    border: none;
    color: #fff;
    cursor: pointer;
    font-size: 14px;
    transition: background 0.2s;
    background-color: #7f8c8d; /* لون مميز لكنه متناسق */
}

.btn-back:hover {
    background-color: #606b6f;
}


        .edit-doctor-title {
            text-align: center;
            margin-bottom: 24px;
            font-size: 22px;
            font-weight: 600;
            color: #2c3e50;
        }

        .edit-doctor-form {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

            .form-group label {
                margin-bottom: 6px;
                font-size: 14px;
                color: #444;
            }

        .form-input {
            padding: 10px 12px;
            font-size: 14px;
            border: 1px solid #dcdfe6;
            border-radius: 8px;
            outline: none;
            transition: border-color 0.2s;
        }

            .form-input:focus {
                border-color: #27ae60;
            }

        .checkbox-group {
            flex-direction: row;
            align-items: center;
            gap: 8px;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }

        .btn-save, .btn-clear {
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            color: #fff;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.2s;
        }

        .btn-save {
            background-color: #0078d7;
        }

            .btn-save:hover {
                background-color: #005fa3;
            }

        .btn-clear {
            background-color: #e67e22;
        }

            .btn-clear:hover {
                background-color: #cf6c17;
            }

        @media (max-width: 768px) {
            .form-actions {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
</asp:Content>
