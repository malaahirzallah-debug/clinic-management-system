<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site1.Master" CodeBehind="PersonalPage.aspx.vb" Inherits="DashBoardClinicManagmmantSystem.PersonalPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="row align-items-center">
            <!-- العمود الأول: الصورة -->
            <div class="col-lg-6 col-md-12 mb-3 mb-lg-0">
                <div class="overlap-images text-center">
                    <img id="img5" runat="server" class="preview-img-lg"
                        src="https://images.unsplash.com/photo-1522097564775-a638360455cf?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=b88f256d95b1ef21167431eb91061f8f&auto=format&fit=crop&w=500&q=60"
                        alt="">
                    <br />
                    <label for="FileUpload5" class="btn btn-sm btn--primary mt-2">اختر صورة</label>
                    <asp:FileUpload ID="FileUpload5" runat="server" CssClass="d-none" ClientIDMode="Static"
                        onchange="previewImage(this, 'img5')" />
                </div>
            </div>


            <!-- العمود الثاني: النص -->
            <div class="col-lg-6 col-md-12">
                <div class="text-wrapper text-end">
                    <h1 class="display-4">مرحباً بكم في
                         <div class="form-group mb-3">
                             <div class="form-group mb-3">
                                 <asp:TextBox ID="lblClinicName" runat="server" CssClass="form-control large-text"
                                     Placeholder="ادخل اسم العيادة أو الطبيب"></asp:TextBox>
                             </div>

                             <style>
                                 .large-text {
                                     font-size: 35px; /* حجم الخط */
                                     font-weight: bold; /* لو بدك النص يكون غامق */
                                 }
                             </style>
                    </h1>
                    <asp:Label ID="lblNotes" runat="server"></asp:Label>
                    <div class="container py-4">

                        <div class="form-group mb-3">
                            <label>المسمى الوظيفي:</label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"
                                Placeholder="استشاري طب...إلخ"></asp:TextBox>
                        </div>

                        <div class="form-group mb-3">
                            <label>ملاحظة تقنية وتسويقية:</label>
                            <asp:TextBox ID="lblNote" runat="server" CssClass="form-control"
                                Placeholder="أحب تقديم حلول جمالية ووظيفية مبتكرة لمرضاي...إلخ"></asp:TextBox>
                        </div>

                        <div class="form-group mb-3">
                            <label>التخصص:</label>
                            <asp:TextBox ID="txtSpecialization" runat="server" CssClass="form-control"
                                Placeholder="أكتب التخصص الفرعي...إلخ"></asp:TextBox>
                        </div>

                        <div class="form-group mb-3">
                            <label>المؤهلات العلمية:</label>
                            <asp:TextBox ID="txtQualifications" runat="server" CssClass="form-control"
                                TextMode="MultiLine" Rows="5"
                                Placeholder="بكالوريوس طب...إلخ)
                                             زمالة... - جامعة ...إلخ
                                             دورات متقدمة في...إلخ"></asp:TextBox>
                        </div>

                        <div class="form-group mb-3">
                            <label>الخبرة:</label>
                            <asp:TextBox ID="txtExperience" runat="server" CssClass="form-control"
                                TextMode="MultiLine" Rows="4"
                                Placeholder="أكثر من 15 سنة خبرة في ...إلخ"></asp:TextBox>
                        </div>

                        <div class="form-group mb-3">
                            <label>الخدمات المقدمة:</label>
                            <asp:TextBox ID="txtServices" runat="server" CssClass="form-control"
                                TextMode="MultiLine" Rows="6"
                                Placeholder=" يتم كتابة الخدمات المقدمة من العيادة لما لا يتجاوز 4 اسطر كحد اقصى"></asp:TextBox>
                        </div>

                        <div class="form-group mb-3">
                            <label>أوقات الدوام:</label>
                            <asp:TextBox ID="txtWorkingHours" runat="server" CssClass="form-control"
                                TextMode="MultiLine" Rows="4"
                                Placeholder="الأحد – الخميس: 9:00 صباحاً – 6:00 مساءً
                                                الجمعة: عطلة
                                                السبت: 10:00 صباحاً – 4:00 مساءً"></asp:TextBox>
                        </div>

                        <div class="form-group mb-3">
                            <label>العنوان:</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control"
                                Placeholder="ادخل العنوان هنا"></asp:TextBox>
                        </div>

                        <div class="form-group mb-3">
                            <label>الهاتف:</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"
                                Placeholder="ادخل رقم الهاتف"></asp:TextBox>
                        </div>

                        <div class="form-group mb-3">
                            <label>الايميل:</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                                Placeholder="ادخل البريد الإلكتروني"></asp:TextBox>
                        </div>

                        <div class="form-group mb-3">
                            <label>الموقع الإلكتروني:</label>
                            <asp:TextBox ID="txtWebsite" runat="server" CssClass="form-control"
                                Placeholder="ادخل رابط الموقع الإلكتروني إن وجد"></asp:TextBox>
                        </div>

                    </div>

                </div>
            </div>


            <div class="section random-people py-5">
                <div class="container">
                    <div class="row">
                        <div class="col-md col-6 ">
                            <img id="img1" runat="server" class="preview-img"
                                src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&h=800&q=60"
                                alt="">
                            <br />
                            <label for="FileUpload1" class="btn btn-sm btn--primary mt-2">اختر صورة</label>
                            <asp:FileUpload ID="FileUpload1" runat="server" CssClass="d-none" ClientIDMode="Static"
                                onchange="previewImage(this, 'img1')" />

                        </div>
                        <div class="col-md col-6 ">
                            <img id="img2" runat="server" class="preview-img"
                                src="https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?auto=format&fit=crop&w=400&h=800&q=60"
                                alt="">
                            <br />
                            <label for="FileUpload2" class="btn btn-sm btn--primary mt-2">اختر صورة</label>
                            <asp:FileUpload ID="FileUpload2" runat="server" CssClass="d-none" ClientIDMode="Static"
                                onchange="previewImage(this, 'img2')" />

                        </div>
                        <div class="col-md col-6 ">
                            <img id="img3" runat="server" class="preview-img"
                                src="https://images.unsplash.com/photo-1519063358282-1b7f996c7ee9?auto=format&fit=crop&w=400&h=800&q=60"
                                alt="">
                            <br />
                            <label for="FileUpload3" class="btn btn-sm btn--primary mt-2">اختر صورة</label>
                            <asp:FileUpload ID="FileUpload3" runat="server" CssClass="d-none" ClientIDMode="Static"
                                onchange="previewImage(this, 'img3')" />

                        </div>
                        <div class="col-md col-6 ">
                            <img id="img4" runat="server" class="preview-img"
                                src="https://images.unsplash.com/photo-1520810627419-35e362c5dc07?auto=format&fit=crop&w=400&h=800&q=60"
                                alt="">
                            <br />
                            <label for="FileUpload4" class="btn btn-sm btn--primary mt-2">اختر صورة</label>
                            <asp:FileUpload ID="FileUpload4" runat="server" CssClass="d-none" ClientIDMode="Static"
                                onchange="previewImage(this, 'img4')" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="container mt-5">
                <h4 class="mb-3 text-center">روابط التواصل الاجتماعي</h4>
                <div class="row text-center">
                    <!-- Facebook -->
                    <div class="col-md-3 col-6 mb-3">
                        <i class="fab fa-facebook fa-2x text-primary"></i>
                        <asp:TextBox ID="txtFacebook" runat="server" CssClass="form-control mt-2" placeholder="رابط الفيسبوك"></asp:TextBox>
                    </div>

                    <!-- Instagram -->
                    <div class="col-md-3 col-6 mb-3">
                        <i class="fab fa-instagram fa-2x text-danger"></i>
                        <asp:TextBox ID="txtInstagram" runat="server" CssClass="form-control mt-2" placeholder="رابط الانستغرام"></asp:TextBox>
                    </div>

                    <!-- WhatsApp -->
                    <div class="col-md-3 col-6 mb-3">
                        <i class="fab fa-whatsapp fa-2x text-success"></i>
                        <asp:TextBox ID="txtWhatsApp" runat="server" CssClass="form-control mt-2" placeholder="رابط الواتساب"></asp:TextBox>
                    </div>

                    <!-- LinkedIn -->
                    <div class="col-md-3 col-6 mb-3">
                        <i class="fab fa-linkedin fa-2x text-primary"></i>
                        <asp:TextBox ID="txtLinkedIn" runat="server" CssClass="form-control mt-2" placeholder="رابط لينكدإن"></asp:TextBox>
                    </div>

                    <!-- Twitter / X -->
                    <div class="col-md-3 col-6 mb-3">
                        <i class="fab fa-x-twitter fa-2x text-info"></i>
                        <asp:TextBox ID="txtTwitter" runat="server" CssClass="form-control mt-2" placeholder="رابط تويتر أو X"></asp:TextBox>
                    </div>

                    <!-- YouTube -->
                    <div class="col-md-3 col-6 mb-3">
                        <i class="fab fa-youtube fa-2x text-danger"></i>
                        <asp:TextBox ID="txtYouTube" runat="server" CssClass="form-control mt-2" placeholder="رابط يوتيوب"></asp:TextBox>
                    </div>

                    <!-- Telegram -->
                    <div class="col-md-3 col-6 mb-3">
                        <i class="fab fa-telegram fa-2x text-primary"></i>
                        <asp:TextBox ID="txtTelegram" runat="server" CssClass="form-control mt-2" placeholder="رابط تيليجرام"></asp:TextBox>
                    </div>

                    <!-- Snapchat -->
                    <div class="col-md-3 col-6 mb-3">
                        <i class="fab fa-snapchat fa-2x text-warning"></i>
                        <asp:TextBox ID="txtSnapchat" runat="server" CssClass="form-control mt-2" placeholder="رابط سناب شات"></asp:TextBox>
                    </div>
                </div>
            </div>

            <div id="map" style="width:100%; height:400px;"></div>
<asp:TextBox ID="txtLatitude" runat="server" CssClass="d-none"></asp:TextBox>
<asp:TextBox ID="txtLongitude" runat="server" CssClass="d-none"></asp:TextBox>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

<script>
    window.onload = function () {
        var lat = parseFloat('<%= txtLatitude.Text %>') || 31.9454;
        var lng = parseFloat('<%= txtLongitude.Text %>') || 35.9284;

        var map = L.map('map').setView([lat, lng], 12);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        var marker = L.marker([lat, lng], { draggable: true }).addTo(map);

        marker.on('dragend', function (e) {
            var pos = marker.getLatLng();
            document.getElementById('<%= txtLatitude.ClientID %>').value = pos.lat;
            document.getElementById('<%= txtLongitude.ClientID %>').value = pos.lng;
        });

        map.on('click', function(e){
            marker.setLatLng(e.latlng);
            document.getElementById('<%= txtLatitude.ClientID %>').value = e.latlng.lat;
            document.getElementById('<%= txtLongitude.ClientID %>').value = e.latlng.lng;
        });
    };
</script>


            <!-- زر الحفظ -->
            <asp:Button ID="btnSaveImages" runat="server"
                CssClass="btn btn-lg btn--primary"
                Text="حفظ التعديلات"
                OnClick="btnSaveImages_Click" />
            <asp:Button ID="ShowPage" runat="server"
                CssClass="btn btn-lg btn--primary"
                Text="عرض الصفحة كما تظهر للزوار"
                OnClick="ShowPage_Click" />


            <style>
                /* الألوان */
                :root {
                    --primary: #1187c5;
                    --primary-light: #46a0dc;
                    --primary-dark: #0e6aa0;
                    --accent: #99a833;
                    --accent-light: #b0c14a;
                    --accent-dark: #7a861e;
                    --background: #fff;
                    --background-secondary: #f7f7f7;
                    --text: #515050;
                    --heading: #1b1c21;
                }

                /* خطوط */
                strong, b {
                    font-weight: 700;
                }
                /* حجم الصورة الخامسة الكبير */
                .preview-img-lg {
                    width: 400px; /* العرض */
                    height: 600px; /* الارتفاع */
                    object-fit: cover; /* لضمان ملء الإطار بدون تشويه */
                    border-radius: 8px;
                    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
                    margin-bottom: 10px;
                }

                body {
                    padding-bottom: 100px;
                    overflow-x: hidden;
                }
                /* حجم الصور الأربعة */
                .preview-img {
                    width: 250px; /* العرض */
                    height: 550px; /* الارتفاع */
                    object-fit: cover; /* يضمن إن الصورة تنقص/تنقص بدون ما تخرب */
                    border-radius: 8px;
                    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
                    margin-bottom: 10px;
                }

                /* أزرار */
                .btn {
                    border: 2px solid #515050;
                    border-radius: 2px;
                    padding: 5px 20px;
                    transition: 300ms ease-in-out;
                    color: #515050;
                    background-color: transparent;
                    margin: 5px;
                    box-shadow: none;
                }

                    .btn:hover {
                        background-color: #515050;
                        color: #fff;
                    }

                    .btn:active {
                        border-color: #7f7f7f;
                        background-color: #7f7f7f;
                    }

                    /* btn--primary */
                    .btn.btn--primary {
                        color: #1187c5;
                        border-color: #1187c5;
                        background-color: #fff;
                    }

                        .btn.btn--primary:hover {
                            color: #fff;
                            background-color: #1187c5;
                        }

                /* hero */
                .hero {
                    height: 100vh;
                    background-position: center center;
                    background-repeat: no-repeat;
                    background-size: cover;
                    position: relative;
                    display: flex;
                    align-items: center;
                    color: #fff;
                }

                    .hero::before {
                        content: "";
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: linear-gradient(135deg, #1187c5 0%, #99a833 100%);
                        opacity: 0.7;
                    }

                    .hero .hero__content {
                        position: relative;
                    }

                /* overlap-images */
                .overlap-images {
                    position: relative;
                    display: flex;
                    flex-direction: column;
                    align-items: flex-start;
                }

                    .overlap-images img:nth-child(1) {
                        width: 80%;
                        box-shadow: 10px 10px 100px 0px #999;
                    }

                    .overlap-images img:nth-child(2) {
                        align-self: flex-end;
                        width: 60%;
                        margin-top: -50%;
                        box-shadow: 10px 10px 100px 0px #999;
                    }

                /* back-dots */
                .back-dots {
                    position: relative;
                }

                    .back-dots::before {
                        content: '';
                        width: 90%;
                        height: 90%;
                        top: -5%;
                        left: -5%;
                        position: absolute;
                        z-index: -1;
                        background-image: url('https://demo.curlythemes.com/dentist-wp/wp-content/plugins/xtender/assets/front/svg/dots-black.svg');
                    }

                /* random-people */
                .random-people__image-wrapper {
                    position: relative;
                    transition: 300ms ease-in-out;
                }

                    .random-people__image-wrapper::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: #111;
                        opacity: 0.3;
                        transition: 300ms ease-in-out;
                    }

                    .random-people__image-wrapper img {
                        width: 100%;
                    }

                    .random-people__image-wrapper:hover {
                        transform: scale(1.1);
                        box-shadow: 5px 5px 70px 0px #555;
                    }

                        .random-people__image-wrapper:hover::before {
                            opacity: 0;
                        }

                /* صور */
                img {
                    max-width: 100%;
                }
            </style>
            <script>
                document.querySelectorAll("input[type='file']").forEach(input => {
                    input.addEventListener("change", function () {
                        const img = this.closest('div').querySelector('img');
                        if (this.files && this.files[0] && img) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                img.src = e.target.result;
                            }
                            reader.readAsDataURL(this.files[0]);
                        }
                    });
                });
            </script>
            
</asp:Content>
