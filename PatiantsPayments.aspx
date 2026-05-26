<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="PatiantsPayments.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.PatiantsPayments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="payments-container">
        <h2 class="payments-title">💳 دفع الذمم والاشتراكات</h2>

        <div class="payments-card">
            <div class="payments-grid">
                <div class="payments-field">
                    <label class="payments-label">نوع الدفعة</label>
                    <asp:DropDownList ID="ddlPaymentType" runat="server" CssClass="payments-dropdown" AutoPostBack="True" OnSelectedIndexChanged="ddlPaymentType_SelectedIndexChanged">
                        <asp:ListItem Text="— اختر —" Value=""></asp:ListItem>
                        <asp:ListItem Text="تسديد ذمم" Value="debt"></asp:ListItem>
                        <asp:ListItem Text="دفع اشتراك" Value="subscription"></asp:ListItem>
                    </asp:DropDownList>
                    <small class="payments-hint">اختر نوع الدفعة لتعبئة أسماء المرضى ديناميكياً</small>
                </div>

                <div class="payments-field">
                    <label class="payments-label">اسم المريض</label>
                    <asp:DropDownList ID="ddlPatients" runat="server" CssClass="payments-dropdown">
                        <asp:ListItem Value="">— اختر نوع الدفعة أولاً —</asp:ListItem>
                    </asp:DropDownList>
                    <small class="payments-hint">في حالة "تسديد ذمم" ستظهر فقط الأسماء التي عليها ذمم</small>
                </div>
            </div>

            <div class="payments-grid">
                <div class="payments-field">
                    <label class="payments-label">تاريخ الدفعة</label>
                    <asp:TextBox ID="txtPayDate" runat="server" CssClass="payments-input" TextMode="Date"></asp:TextBox>
                </div>

                <div class="payments-field">
                    <label class="payments-label">
                        المبلغ المدفوع
                        <span class="payments-pill" id="lblDueHint">مثال: الذمم = 0.00</span>
                    </label>
                    <asp:TextBox ID="txtAmount" runat="server" CssClass="payments-input" placeholder="0.00"></asp:TextBox>
                    <small class="payments-hint">في حالة الذمم، سيتم إظهار مجموع الذمم عند اختيار المريض</small>
                </div>
            </div>

            <div class="payments-field">
                <label class="payments-label">ملاحظات</label>
                <asp:TextBox ID="txtNotes" runat="server" CssClass="payments-textarea" TextMode="MultiLine" Rows="3" placeholder="اكتب أي ملاحظات هنا..."></asp:TextBox>
            </div>

            <div class="payments-actions">
                <asp:Button ID="btnSave" runat="server" CssClass="payments-btn" Text="💾 حفظ" OnClick="btnSave_Click" />
                <a href="HomePage.aspx" class="payments-btn-outline">إلغاء</a>
            </div>
        </div>
    </div>

    <style>
        .payments-container {
            max-width: 1100px;
            margin: 24px auto;
            padding: 0 16px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            color: #333;
        }

        .payments-title {
            text-align: center;
            margin-bottom: 16px;
            font-weight: 700;
            color: #2c3e50;
        }

        .payments-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
            padding: 18px;
        }

        .payments-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(260px, 1fr));
            gap: 16px;
            margin-bottom: 16px;
        }

        @media (max-width: 768px) {
            .payments-grid {
                grid-template-columns: 1fr;
            }
        }

        .payments-field {
            display: flex;
            flex-direction: column;
        }

        .payments-label {
            font-size: 14px;
            color: #444;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .payments-input,
        .payments-textarea,
        .payments-dropdown {
            width: 100%;
            border: 1px solid #dcdfe6;
            border-radius: 8px;
            padding: 10px 12px;
            font-size: 14px;
            background: #fff;
            outline: none;
            transition: border-color .2s, box-shadow .2s;
        }

            .payments-input:focus,
            .payments-textarea:focus,
            .payments-dropdown:focus {
                border-color: #27ae60;
                box-shadow: 0 0 0 3px rgba(39,174,96,0.12);
            }

        .payments-textarea {
            resize: vertical;
            min-height: 100px;
        }

        .payments-pill {
            display: inline-block;
            font-size: 12px;
            background: #eef6ff;
            color: #0b6bc7;
            padding: 4px 8px;
            border-radius: 999px;
            border: 1px solid #d7e8ff;
        }

        .payments-hint {
            font-size: 12px;
            color: #777;
            margin-top: 6px;
        }

        .payments-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-top: 8px;
            flex-wrap: wrap;
        }

        .payments-btn {
            background: #27ae60;
            color: #fff;
            border: none;
            padding: 10px 18px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            transition: background .2s, transform .06s;
        }

            .payments-btn:hover {
                background: #1f8f4f;
            }

            .payments-btn:active {
                transform: translateY(1px);
            }

        .payments-btn-outline {
            background: #fff;
            color: #444;
            border: 1px solid #cfd6de;
            padding: 10px 18px;
            border-radius: 10px;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            transition: background .2s, color .2s;
        }

            .payments-btn-outline:hover {
                background: #f4f6f8;
                color: #111;
            }
    </style>

</asp:Content>
