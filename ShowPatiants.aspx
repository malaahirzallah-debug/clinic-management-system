<%@ Page Language="vb" MasterPageFile="~/Site1.Master" AutoEventWireup="false" CodeBehind="ShowPatiants.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.ShowPatiants" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        body {
            font-family: "Segoe UI", Tahoma, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 20px;
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
            text-align: center;
        }

        /* basic search */
        .search-box {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

            .search-box input {
                width: 70%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 25px 0 0 25px;
                outline: none;
                font-size: 16px;
            }

            .search-box button {
                padding: 12px 20px;
                border: none;
                background-color: #007bff;
                color: white;
                border-radius: 0 25px 25px 0;
                cursor: pointer;
                font-size: 16px;
                transition: 0.3s;
            }

                .search-box button:hover {
                    background-color: #0056b3;
                }

        /* advanced filter */
        .advanced-filter {
            background: #fff;
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }

            .advanced-filter h4 {
                margin: 0 0 15px;
                font-size: 16px;
                color: #444;
            }

            .advanced-filter .row {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
            }

                .advanced-filter .row label {
                    flex: 1 1 200px;
                    display: flex;
                    flex-direction: column;
                    font-size: 14px;
                    color: #555;
                }

            .advanced-filter input,
            .advanced-filter select {
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
            }

        /* tools above results */
        .tools {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }

            .tools .left,
            .tools .right {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .tools button,
            .tools select {
                padding: 6px 12px;
                border-radius: 6px;
                border: 1px solid #ccc;
                background: #fff;
                cursor: pointer;
            }

                .tools button:hover {
                    background: #f0f0f0;
                }

        /* patient cards grid */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            overflow: hidden;
            text-align: center;
            padding: 15px;
            transition: transform 0.2s;
        }

            .card:hover {
                transform: translateY(-5px);
            }

            .card img {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                object-fit: cover;
                margin-bottom: 15px;
                background: #eee;
            }

            .card h3 {
                margin: 0;
                font-size: 18px;
                color: #333;
            }

            .card p {
                margin: 5px 0;
                font-size: 14px;
                color: #666;
            }

            .card .actions {
                margin-top: 10px;
                display: flex;
                justify-content: center;
                gap: 8px;
            }

                .card .actions a {
                    display: inline-block;
                    padding: 6px 12px;
                    font-size: 14px;
                    border-radius: 6px;
                    text-decoration: none;
                    color: white;
                }

        .btn-view {
            background: #17a2b8;
        }

            .btn-view:hover {
                background: #138496;
            }

        .btn-edit {
            background: #ffc107;
            color: #333 !important;
        }

            .btn-edit:hover {
                background: #e0a800;
            }

        /* pagination */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 25px;
            gap: 5px;
        }

            .pagination button {
                border: 1px solid #ccc;
                padding: 6px 12px;
                border-radius: 4px;
                background: #fff;
                cursor: pointer;
            }

                .pagination button.active {
                    background: #007bff;
                    color: #fff;
                    border-color: #007bff;
                }

        @media (max-width: 600px) {
            .search-box input {
                width: 60%;
            }
        }

        /* last visit checkbox + date range */
        .last-visit-filter {
            display: flex;
            align-items: center; /* محاذاة التشيك بوكس والنص أفقيًا */
            gap: 10px; /* المسافة بين التشيك بوكس وحقول التاريخ */
            flex-wrap: wrap;
            margin-top: 5px;
        }

            .last-visit-filter .chk-custom {
                margin: 0; /* إزالة أي مسافة علوية */
                vertical-align: middle; /* محاذاة التشيك بوكس مع النص */
                font-size: 14px;
            }

            .last-visit-filter .date-range {
                display: flex;
                gap: 8px;
                align-items: center;
            }

                .last-visit-filter .date-range label {
                    display: flex;
                    flex-direction: column; /* النص فوق التاريخ */
                    margin: 0;
                }

                .last-visit-filter .date-range input {
                    padding: 8px; /* نفس البادينغ الموجود في التكست بوكسات */
                    font-size: 14px; /* نفس حجم التكست بوكس */
                    border-radius: 6px;
                    border: 1px solid #ccc;
                    width: 150px; /* نفس عرض التكست بوكسات الأخرى تقريبًا */
                    box-sizing: border-box;
                }
    </style>

    <div class="container">
        <h2>🔍 البحث عن المرضى</h2>

        <!-- basic search -->
        <div class="search-box">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="ابحث بالاسم أو رقم الهاتف أو رقم الملف..."></asp:TextBox>
            <asp:Button ID="btnSearch" runat="server" Text="بحث" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
        </div>

        <!-- advanced filters -->
        <div class="advanced-filter">
            <h4>تصفية متقدمة</h4>
            <div class="row">
                <label>
                    الجنس
                    <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">الكل</asp:ListItem>
                        <asp:ListItem Value="male">ذكر</asp:ListItem>
                        <asp:ListItem Value="female">أنثى</asp:ListItem>
                    </asp:DropDownList>
                </label>
                <label>
                    العمر (من)
                    <asp:TextBox ID="txtAgeFrom" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                </label>
                <label>
                    العمر (إلى)
                    <asp:TextBox ID="txtAgeTo" runat="server" CssClass="form-control" TextMode="Number"></asp:TextBox>
                </label>
                <label>
                    الطبيب المعالج
                    <asp:DropDownList ID="ddlDoctor" runat="server" CssClass="form-control">
                        <asp:ListItem Value="">الكل</asp:ListItem>
                        <asp:ListItem>د. أحمد</asp:ListItem>
                        <asp:ListItem>د. سارة</asp:ListItem>
                    </asp:DropDownList>
                </label>
                <label>
                    رقم ملف / بطاقة التأمين
                    <asp:TextBox ID="txtFileNo" runat="server" CssClass="form-control"></asp:TextBox>
                </label>

                <div class="last-visit-filter">
                    <asp:CheckBox ID="chkIncludeLastVisit" runat="server" Text="شمل تاريخ الزيارة في البحث" CssClass="chk-custom" />
                    <div class="date-range">
                        <label>
                            من
                    <asp:TextBox ID="txtLastVisitFrom" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </label>
                        <label>
                            إلى
                    <asp:TextBox ID="txtLastVisitTo" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </label>
                    </div>
                </div>


            </div>
        </div>

        <!-- tools -->
        <div class="tools">
            <div class="left">
                <asp:Button ID="btnExportExcel" runat="server" Text="📊 تصدير Excel" CssClass="btn btn-secondary" />
                <asp:Button ID="btnExportPDF" runat="server" Text="📄 تصدير PDF" CssClass="btn btn-secondary" />
            </div>
            <div class="right">
                <label>
                    فرز حسب:
                    <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="form-control">
                        <asp:ListItem>الاسم</asp:ListItem>
                        <asp:ListItem>العمر</asp:ListItem>
                        <asp:ListItem>الطبيب</asp:ListItem>
                        <asp:ListItem>التاريخ</asp:ListItem>
                    </asp:DropDownList>
                </label>
                <label>
                    عدد النتائج:
                    <asp:DropDownList ID="ddlPageSize" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged">
                        <asp:ListItem>10</asp:ListItem>
                        <asp:ListItem>20</asp:ListItem>
                        <asp:ListItem>50</asp:ListItem>
                    </asp:DropDownList>
                </label>
            </div>
        </div>

        <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>

        <!-- patient cards -->
        <div class="card-grid">
            <asp:Repeater ID="rptPatients" runat="server" OnItemDataBound="rptPatients_ItemDataBound">
                <ItemTemplate>
                    <div class="card">
                        <img src='<%# Eval("PhotoPath") %>' onerror="this.onerror=null;this.src='default-patient.png';" alt="صورة المريض" />
                        <h3><%# Eval("FullName") %></h3>
                        <p>العمر: <%# Eval("Age") %></p>
                        <p>الهاتف: <%# Eval("Phone") %></p>
                        <p>آخر زيارة: <%# If(Eval("LastVisit") Is DBNull.Value, "-", String.Format("{0:dd/MM/yyyy}", Eval("LastVisit"))) %></p>
                        <p>
                            الحالة المالية: 
                            <strong style='color: <%# If(Convert.ToDecimal(If(Eval("Balance") Is DBNull.Value, 0, Eval("Balance"))) < 0, "red", "green") %>;'>
                                <%# Convert.ToDecimal(If(Eval("Balance") Is DBNull.Value, 0, Eval("Balance"))).ToString("N2") & " دينار" %>
                            </strong>
                        </p>
                        <div class="actions">
                            <asp:LinkButton ID="btnView" runat="server" CssClass="btn-view" Text="👁️ عرض الزيارات" PostBackUrl='<%# "PatientVisits.aspx?PatientID=" & Eval("PatientID") %>' />
                            <asp:LinkButton ID="btnEditPatient" runat="server" CssClass="btn-edit" Text="✏️ تعديل" PostBackUrl='<%# "EditPatiants.aspx?PatientID=" & Eval("PatientID") %>' />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- pagination -->
        <div class="pagination">
            <asp:Repeater ID="rptPagination" runat="server">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkPage" runat="server" CommandArgument='<%# Eval("PageNumber") %>' OnCommand="Page_Changed" CssClass='<%# If(Eval("IsCurrent"), "active", "") %>'>
                        <%# Eval("PageNumber") %>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
