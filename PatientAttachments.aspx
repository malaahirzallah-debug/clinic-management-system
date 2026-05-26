<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="PatientAttachments.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.PatientAttachments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="attachments-container">
        <h2>📷 مرفقات المريض</h2>

        <div class="attachments-grid">
            <asp:Repeater ID="rptAttachments" runat="server">
                <ItemTemplate>
                    <div class="attachment-thumb">
                        <a href='<%# ResolveUrl(Eval("FileURL").ToString()) %>' target="_blank">
                            <img src='<%# ResolveUrl(Eval("FileURL").ToString()) %>' alt="Attachment" />
                        </a>
                        <p>تاريخ الرفع: <%# Convert.ToDateTime(Eval("CreatedAt")).ToString("dd/MM/yyyy") %></p>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
    <div style="text-align: center; margin-bottom: 20px;">
        <asp:LinkButton ID="btnBackToVisits" runat="server" CssClass="patient-btn" OnClick="btnBackToVisits_Click">
        ⬅️ رجوع
        </asp:LinkButton>
    </div>
    <style>
        .attachments-container {
            width: 95%;
            max-width: 1200px;
            margin: 30px auto;
            font-family: "Tahoma", sans-serif;
            color: #333;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #2c3e50;
            font-size: 28px;
        }

        /* Grid layout ديناميكي */
        .attachments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 15px;
        }

        .attachment-thumb {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            border: 1px solid #ddd;
            border-radius: 12px;
            padding: 8px;
            background: #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }

            .attachment-thumb img {
                width: 100%;
                height: auto;
                max-height: 180px;
                object-fit: contain;
                border-radius: 10px;
                margin-bottom: 6px;
                transition: transform 0.3s ease;
            }

            .attachment-thumb:hover img {
                transform: scale(1.05);
            }

        .patient-btn {
            background: #0078d7;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
            font-size: 14px;
            text-decoration: none;
            margin-bottom: 20px; /* مسافة عن المرفقات */
        }

            .patient-btn:hover {
                background: #005fa3;
            }

        @media (max-width: 1024px) {
            .attachments-grid {
                grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .attachments-grid {
                grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
            }
        }
    </style>

</asp:Content>




