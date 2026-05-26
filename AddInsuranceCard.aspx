<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="AddInsuranceCard.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.AddInsuranceCard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .form-container {
            max-width: 800px;
            margin: 30px auto;
            background: #f9f9f9;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0px 4px 12px rgba(0,0,0,0.1);
            font-family: Tahoma, Arial, sans-serif;
        }

            .form-container h2 {
                text-align: center;
                margin-bottom: 25px;
                color: #2c3e50;
            }

        .form-group {
            margin-bottom: 15px;
        }

            .form-group label {
                font-weight: bold;
                display: block;
                margin-bottom: 5px;
                color: #34495e;
            }

            .form-group input, .form-group select, .form-group textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
            }

            .form-group textarea {
                resize: vertical;
                min-height: 80px;
            }

        .btn-submit {
            display: inline-block;
            width: auto;
            background: #3498db;
            color: white;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }

            .btn-submit:hover {
                background: #2980b9;
            }

        .btn-close1 {
            display: inline-block;
            width: auto;
            background: #7f8c8d;
            color: white;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }

            .btn-close1:hover {
                background: #606b6e;
            }

        .card-header-custom {
            font-weight: bold;
            color: white;
            border-radius: 8px 8px 0 0;
            padding: 12px 15px;
        }

        .bg-primary-custom {
            background: linear-gradient(90deg, #3498db, #2980b9);
        }
    </style>

    <div class="form-container">

        <h2>➕ إضافة بطاقة تأمين</h2>

        <div class="card mb-4 shadow border-0 rounded-3">
            <div class="card-header card-header-custom bg-primary-custom">
                <i class="bi bi-card-list"></i>معلومات البطاقة
            </div>
            <div class="card-body row g-3">

                <div class="col-md-6 form-group">
                    <label>اسم المريض</label>
                    <asp:DropDownList ID="ddlPatient" runat="server" CssClass="form-select form-select-lg" />
                </div>

                <div class="col-md-6 form-group">
                    <label>شركة التأمين</label>
                    <asp:DropDownList ID="ddlInsuranceCompany" runat="server" CssClass="form-select form-select-lg" />
                </div>

                <div class="col-md-6 form-group">
                    <label>رقم بطاقة التأمين</label>
                    <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control form-control-lg" placeholder="ادخل رقم البطاقة" />
                </div>

                <div class="col-md-6 form-group">
                    <label>تاريخ انتهاء التأمين</label>
                    <asp:TextBox ID="txtExpiryDate" runat="server" CssClass="form-control form-control-lg" TextMode="Date" />
                </div>

                <div class="col-md-6 form-group">
                    <label>نوع التغطية</label>
                    <asp:DropDownList ID="ddlCoverageType" runat="server" CssClass="form-select form-select-lg">
                        <asp:ListItem Text="نسبة مئوية" Value="Percentage" />
                        <asp:ListItem Text="مبلغ ثابت" Value="Fixed" />
                    </asp:DropDownList>
                </div>

                <div class="col-md-6 form-group">
                    <label>نسبة التغطية</label>
                    <asp:TextBox ID="txtCoverage" runat="server" CssClass="form-control form-control-lg" placeholder="مثال: 80%" />
                </div>

                <div class="col-md-6 form-group">
                    <label>درجة التأمين</label>
                    <asp:DropDownList ID="ddlInsuranceLevel" runat="server" CssClass="form-select form-select-lg">
                        <asp:ListItem Text="VIP" Value="Vip" />
                        <asp:ListItem Text="أولى" Value="أولى" />
                        <asp:ListItem Text="ثانية" Value="ثانية" />
                        <asp:ListItem Text="ثالثة" Value="ثالثة" />
                    </asp:DropDownList>
                </div>
                <div class="col-12 form-group">
                    <label>ملاحظات</label>
                    <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control form-control-lg" TextMode="MultiLine" Rows="3" placeholder="ادخل ملاحظات إضافية (إن وجدت)" />
                </div>
            </div>
        </div>

        <div class="text-center mb-5">
            <asp:Button ID="btnSave" runat="server" Text="💾 حفظ" CssClass="btn-submit me-2" />
            <asp:Button ID="btnClose" runat="server" Text="❌ إغلاق" CssClass="btn-close1" PostBackUrl="~/HomePage.aspx" />
        </div>

    </div>

</asp:Content>
