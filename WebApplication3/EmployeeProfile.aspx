<%@ Page Title="Employee Profile" Language="C#" AutoEventWireup="true" 
    CodeBehind="EmployeeProfile.aspx.cs" Inherits="HRMSApp.EmployeeProfile" %>
<%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>


<!DOCTYPE html>
<html>
<head runat="server">
    <title>Employee Profile</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <style>
        body {
            background: linear-gradient(135deg, #e8f0fe 0%, #f4f6f9 100%);
            min-height: 100vh;
        }
        .fade-in { animation: fadeIn 0.4s ease-in; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .card { border: none; }
        .card.shadow { box-shadow: 0 6px 24px rgba(0,0,0,0.08) !important; }
        .card-header-custom { background: linear-gradient(90deg, #0d6efd, #0a58ca); color: #fff; }
        .form-label { font-weight: 600; color: #2c3e50; }
        .required::after { content: " *"; color: #dc3545; }

        .input-icon-group { position: relative; }
        .input-icon-group i {
            position: absolute; left: 12px; top: 50%;
            transform: translateY(-50%); color: #6c757d; z-index: 5;
        }
        .input-icon-group .form-control,
        .input-icon-group .form-select { padding-left: 38px; }

        .form-control, .form-select {
            border: 1px solid #d7dde5;
            transition: box-shadow 0.15s ease, border-color 0.15s ease;
        }
        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 3px rgba(13,110,253,0.15);
            border-color: #86b7fe;
        }

        .avatar-preview {
            width: 84px; height: 84px; border-radius: 50%; object-fit: cover;
            border: 3px solid #e8f0fe; box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .avatar-placeholder {
            width: 84px; height: 84px; border-radius: 50%; background: #eef2f7;
            display: flex; align-items: center; justify-content: center;
            color: #adb5bd; font-size: 2rem; border: 3px dashed #d7dde5;
        }

        .button-container {
    display: flex;
    justify-content: flex-end;   /* right align */
    margin-top: 20px;
}

.action-bar {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
}
.button-container {
    width: 100%;
}

.button-container .action-bar {
    justify-content: flex-start !important;
    align-items: center;
}

        /* Accordion styling */
        .accordion-button {
            font-weight: 700;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #2c3e50;
            background-color: #f8f9fa;
        }
        .accordion-button:not(.collapsed) {
            background-color: #e7f1ff;
            color: #0d6efd;
            box-shadow: none;
        }
        .accordion-button:focus { box-shadow: none; }
        .accordion-button i { margin-right: 10px; font-size: 1rem; }
        .accordion-item { border-color: #e9ecef; }
        .accordion-body { background: #fff; }

        .btn-action {
            min-width: 110px;
            transition: transform 0.1s ease, box-shadow 0.15s ease;
        }
        .btn-action:hover { transform: translateY(-1px); box-shadow: 0 4px 10px rgba(0,0,0,0.12); }

        .action-bar {
            position: sticky; bottom: 0; background: #fff;
            padding: 1rem 0; border-top: 1px solid #eee; margin-top: 1.5rem;
        }

        .breadcrumb-bar { font-size: 0.9rem; }

        .accordion-item:not(:last-child) {
    margin-bottom: 8px;
    border-radius: 8px;
    overflow: hidden;
}
.accordion-item {
    border-radius: 8px !important;
}

.profile-hero {
    display: flex;
    align-items: center;
    gap: 32px;
    padding: 32px;
    background: linear-gradient(135deg, #f0f6ff 0%, #f8fafd 100%);
    border-radius: 16px;
    border: 1px solid #e7f0ff;
}

.hero-photo-wrap { flex-shrink: 0; }

.hero-avatar {
    width: 130px;
    height: 130px;
    border-radius: 50%;
    object-fit: cover;
    border: 4px solid #fff;
    box-shadow: 0 6px 20px rgba(13, 110, 253, 0.15);
}

.hero-avatar-placeholder {
    width: 130px;
    height: 130px;
    border-radius: 50%;
    background: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #b8c2d1;
    font-size: 3.2rem;
    border: 4px dashed #d7e3f5;
    box-shadow: 0 6px 20px rgba(13, 110, 253, 0.08);
}

.hero-info {
    flex: 1;
    min-width: 0;
}

.hero-title-row {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 12px;
}

.hero-name {
    display: block;
    font-size: 1.55rem;
    font-weight: 800;
    color: #1a2332;
    letter-spacing: -0.01em;
    line-height: 1.2;
}

.hero-designation {
    display: block;
    font-size: 0.95rem;
    color: #0d6efd;
    font-weight: 600;
    margin-top: 3px;
}

.hero-status-badge {
    background: #e8f9ee;
    color: #16a34a;
    font-size: 0.78rem;
    font-weight: 700;
    padding: 6px 14px;
    border-radius: 20px;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    white-space: nowrap;
    margin-top: 2px;
}
.hero-status-badge i { font-size: 0.5rem; }

.hero-divider {
    height: 1px;
    background: #dde8f7;
    margin: 18px 0;
}

.hero-meta-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px 32px;
}

.hero-meta-item {
    display: flex;
    align-items: center;
    gap: 12px;
}

.hero-meta-icon {
    width: 38px;
    height: 38px;
    background: #fff;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #0d6efd;
    font-size: 1.05rem;
    flex-shrink: 0;
    box-shadow: 0 2px 8px rgba(13,110,253,0.1);
}

.hero-meta-label {
    font-size: 0.72rem;
    color: #8892a0;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    font-weight: 700;
    margin-bottom: 2px;
}

.hero-meta-value {
    font-size: 0.92rem;
    color: #2c3e50;
    font-weight: 600;
    word-break: break-word;
}

@media (max-width: 768px) {
    .profile-hero {
        flex-direction: column;
        text-align: center;
    }
    .hero-title-row {
        flex-direction: column;
        align-items: center;
    }
    .hero-meta-grid {
        grid-template-columns: 1fr;
    }
    .hero-meta-item {
        justify-content: center;
    }
}
.hero-photo-btn {
    position: relative;
    padding: 0;
    border: none;
    background: none;
    cursor: pointer;
    border-radius: 50%;
    display: block;
}

.hero-photo-btn:hover .hero-photo-zoom-overlay {
    opacity: 1;
}

.hero-photo-zoom-overlay {
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    border-radius: 50%;
    background: rgba(13, 110, 253, 0.55);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    font-size: 1.8rem;
    opacity: 0;
    transition: opacity 0.2s ease;
}

/* Lightbox modal image zoom */
.lightbox-content {
    background: rgba(10, 12, 20, 0.95);
    border: none;
    border-radius: 16px;
    padding: 20px;
}

.lightbox-img {
    width: 100%;
    max-height: 75vh;
    object-fit: contain;
    border-radius: 10px;
}

.lightbox-close {
    position: absolute;
    top: 16px;
    right: 16px;
    z-index: 10;
    background-color: rgba(255,255,255,0.15);
    border-radius: 50%;
    padding: 8px;
}

    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <uc:Navbar ID="Navbar1" runat="server" />
    <div class="container my-5 fade-in">
    <!-- rest of existing page unchanged -->



        <div class="card shadow">
            <div class="card-header card-header-custom d-flex align-items-center justify-content-between py-3">
                <div class="d-flex align-items-center">
                    <i class="bi bi-person-badge-fill fs-4 me-2"></i>
                    <h3 class="m-0">Employee Profile</h3>
                </div>
                <asp:HyperLink runat="server" NavigateUrl="~/EmployeeList.aspx" CssClass="btn btn-sm btn-light">
                    <i class="bi bi-list-ul me-1"></i>View All Employees
                </asp:HyperLink>
            </div>

            <div class="card-body p-4">

                <asp:HiddenField ID="hfEmpID" runat="server" Value="0" />
                <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3" />
<!-- Hero section: bigger photo + key info at a glance -->
<div class="profile-hero mb-4">
<div class="hero-photo-wrap">
    <button type="button" id="btnOpenPhoto" class="hero-photo-btn" onclick="openPhotoModal()">
        <asp:Image ID="imgAvatarPreview" runat="server" CssClass="hero-avatar" Visible="false" />
        <div id="avatarPlaceholder" runat="server" class="hero-avatar-placeholder">
            <i class="bi bi-person-fill"></i>
        </div>
        <div class="hero-photo-zoom-overlay">
            <i class="bi bi-zoom-in"></i>
        </div>
    </button>
</div>

    <div class="hero-info">
        <div class="hero-title-row">
            <div>
                <asp:Label ID="lblHeroName" runat="server" CssClass="hero-name" Text="New Employee" />
                <asp:Label ID="lblHeroDesignation" runat="server" CssClass="hero-designation" Text="Designation not set" />
            </div>
            <span class="hero-status-badge">
                <i class="bi bi-circle-fill"></i> Active
            </span>
        </div>

        <div class="hero-divider"></div>

        <div class="hero-meta-grid">
            <div class="hero-meta-item">
                <div class="hero-meta-icon"><i class="bi bi-diagram-3"></i></div>
                <div>
                    <div class="hero-meta-label">Department</div>
                    <asp:Label ID="lblHeroDept" runat="server" CssClass="hero-meta-value" Text="No department" />
                </div>
            </div>
            <div class="hero-meta-item">
                <div class="hero-meta-icon"><i class="bi bi-envelope"></i></div>
                <div>
                    <div class="hero-meta-label">Email</div>
                    <asp:Label ID="lblHeroEmail" runat="server" CssClass="hero-meta-value" Text="No email on file" />
                </div>
            </div>
            <div class="hero-meta-item">
                <div class="hero-meta-icon"><i class="bi bi-telephone"></i></div>
                <div>
                    <div class="hero-meta-label">Phone</div>
                    <asp:Label ID="lblHeroPhone" runat="server" CssClass="hero-meta-value" Text="No phone on file" />
                </div>
            </div>
            <div class="hero-meta-item">
                <div class="hero-meta-icon"><i class="bi bi-calendar-check"></i></div>
                <div>
                    <div class="hero-meta-label">Joined</div>
                    <asp:Label ID="lblHeroJoined" runat="server" CssClass="hero-meta-value" Text="Not set" />
                </div>
            </div>
        </div>
    </div>
</div>

                <!-- ACCORDION SECTIONS -->
                <div class="accordion" id="profileAccordion">

                    <!-- Basic Info -->
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" 
                                data-bs-target="#secBasic" aria-expanded="true">
                                <i class="bi bi-person-vcard"></i>Basic Info
                            </button>
                        </h2>
                        <div id="secBasic" class="accordion-collapse collapse show" data-bs-parent="#profileAccordion">
                            <div class="accordion-body">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Full Name" CssClass="form-label required" AssociatedControlID="txtName" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-person"></i>
                                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="e.g. John Smith" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Designation / Job Title" CssClass="form-label" AssociatedControlID="txtDesignation" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-briefcase"></i>
                                            <asp:TextBox ID="txtDesignation" runat="server" CssClass="form-control" placeholder="e.g. Software Engineer" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Department" CssClass="form-label required" AssociatedControlID="ddlDepartment" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-diagram-3"></i>
                                            <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-select"
                                                DataTextField="DeptName" DataValueField="DeptID" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label required d-block">Gender</label>
                                        <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal" CssClass="d-flex gap-4 mt-2">
                                            <asp:ListItem Text="Male" Value="Male" Selected="True" />
                                            <asp:ListItem Text="Female" Value="Female" />
                                        </asp:RadioButtonList>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Date of Birth" CssClass="form-label required" AssociatedControlID="txtDOB" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-calendar-heart"></i>
                                            <asp:TextBox ID="txtDOB" runat="server" TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Joining Date" CssClass="form-label required" AssociatedControlID="txtJoiningDate" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-calendar-check"></i>
                                            <asp:TextBox ID="txtJoiningDate" runat="server" TextMode="Date" CssClass="form-control" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Marital Status" CssClass="form-label" AssociatedControlID="ddlMaritalStatus" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-heart"></i>
                                            <asp:DropDownList ID="ddlMaritalStatus" runat="server" CssClass="form-select">
                                                <asp:ListItem Text="Single" Value="Single" />
                                                <asp:ListItem Text="Married" Value="Married" />
                                                <asp:ListItem Text="Other" Value="Other" />
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Blood Group" CssClass="form-label" AssociatedControlID="ddlBloodGroup" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-droplet"></i>
                                            <asp:DropDownList ID="ddlBloodGroup" runat="server" CssClass="form-select">
                                                <asp:ListItem Text="A+" Value="A+" />
                                                <asp:ListItem Text="A-" Value="A-" />
                                                <asp:ListItem Text="B+" Value="B+" />
                                                <asp:ListItem Text="B-" Value="B-" />
                                                <asp:ListItem Text="AB+" Value="AB+" />
                                                <asp:ListItem Text="AB-" Value="AB-" />
                                                <asp:ListItem Text="O+" Value="O+" />
                                                <asp:ListItem Text="O-" Value="O-" />
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-6 d-flex align-items-center">
                                        <div class="form-check form-switch">
                                            <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" CssClass="form-check-input" />
                                            <label class="form-label mb-0 ms-2">Currently Active Employee</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Contact & Identity -->
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" 
                                data-bs-target="#secContact" aria-expanded="false">
                                <i class="bi bi-telephone"></i>Contact &amp; Identity
                            </button>
                        </h2>
                        <div id="secContact" class="accordion-collapse collapse" data-bs-parent="#profileAccordion">
                            <div class="accordion-body">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Email Address" CssClass="form-label" AssociatedControlID="txtEmail" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-envelope"></i>
                                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="name@company.com" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Phone Number" CssClass="form-label" AssociatedControlID="txtPhone" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-telephone"></i>
                                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="03XX-XXXXXXX" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="CNIC / National ID" CssClass="form-label" AssociatedControlID="txtCNIC" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-card-text"></i>
                                            <asp:TextBox ID="txtCNIC" runat="server" CssClass="form-control" placeholder="XXXXX-XXXXXXX-X" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Address" CssClass="form-label" AssociatedControlID="txtAddress" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-geo-alt"></i>
                                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Street, city" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Compensation -->
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" 
                                data-bs-target="#secComp" aria-expanded="false">
                                <i class="bi bi-cash-coin"></i>Compensation
                            </button>
                        </h2>
                        <div id="secComp" class="accordion-collapse collapse" data-bs-parent="#profileAccordion">
                            <div class="accordion-body">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Basic Salary" CssClass="form-label required" AssociatedControlID="txtBasicSalary" />
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-currency-exchange me-1"></i>Rs.</span>
                                            <asp:TextBox ID="txtBasicSalary" runat="server" CssClass="form-control" placeholder="0.00" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Allowance" CssClass="form-label" AssociatedControlID="txtAllowance" />
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-gift me-1"></i>Rs.</span>
                                            <asp:TextBox ID="txtAllowance" runat="server" CssClass="form-control" placeholder="0.00" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Emergency Contact -->
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" 
                                data-bs-target="#secEmergency" aria-expanded="false">
                                <i class="bi bi-exclamation-triangle"></i>Emergency Contact
                            </button>
                        </h2>
                        <div id="secEmergency" class="accordion-collapse collapse" data-bs-parent="#profileAccordion">
                            <div class="accordion-body">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Contact Name" CssClass="form-label" AssociatedControlID="txtEmergencyName" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-person-lines-fill"></i>
                                            <asp:TextBox ID="txtEmergencyName" runat="server" CssClass="form-control" placeholder="e.g. family member" />
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <asp:Label runat="server" Text="Contact Phone" CssClass="form-label" AssociatedControlID="txtEmergencyPhone" />
                                        <div class="input-icon-group">
                                            <i class="bi bi-telephone-forward"></i>
                                            <asp:TextBox ID="txtEmergencyPhone" runat="server" CssClass="form-control" placeholder="03XX-XXXXXXX" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Documents -->
                    <div class="accordion-item">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" 
                                data-bs-target="#secDocs" aria-expanded="false">
                                <i class="bi bi-paperclip"></i>Documents
                            </button>
                        </h2>
                        <div id="secDocs" class="accordion-collapse collapse" data-bs-parent="#profileAccordion">
                            <div class="accordion-body">
                                <label class="form-label">Profile Picture</label>
                                <asp:FileUpload ID="fuProfilePic" runat="server" CssClass="form-control" onchange="previewAvatar(this)" />
                                <small class="text-muted">JPG or PNG recommended</small>
                            </div>
                        </div>
                    </div>

                </div>

<div class="button-container">
    <div class="action-bar d-flex flex-wrap gap-2">
        <asp:Button ID="btnSave" runat="server"
            Text="Save"
            CssClass="btn btn-success btn-action"
            OnClick="btnSave_Click"
            OnClientClick="showSpinner(this,'Saving...')" />

        <asp:Button ID="btnUpdate" runat="server"
            Text="Update"
            CssClass="btn btn-primary btn-action"
            OnClick="btnUpdate_Click"
            OnClientClick="showSpinner(this,'Updating...')" />

        <asp:Button ID="btnDelete" runat="server"
            Text="Delete"
            CssClass="btn btn-danger btn-action"
            OnClick="btnDelete_Click"
            CausesValidation="false"
            OnClientClick="return confirmDelete();" />

        <asp:Button ID="btnClear" runat="server"
            Text="Clear"
            CssClass="btn btn-outline-secondary btn-action"
            OnClick="btnClear_Click"
            CausesValidation="false" />
    </div>
</div>

            </div>
        </div>

    </div>
        <!-- Photo Lightbox Modal -->
<div class="modal fade" id="photoLightbox" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content lightbox-content">
            <button type="button" class="btn-close btn-close-white lightbox-close" data-bs-dismiss="modal"></button>
            <img id="lightboxImage" src="" alt="Profile Photo" class="lightbox-img" />
        </div>
    </div>
</div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>

        function openPhotoModal() {
            var avatarImg = document.getElementById('<%= imgAvatarPreview.ClientID %>');
            var lightboxImg = document.getElementById('lightboxImage');

            // If there's no photo at all (placeholder showing), don't open the modal
            if (!avatarImg.src || avatarImg.style.display === 'none') {
                return;
            }

            lightboxImg.src = avatarImg.src;

            var modal = new bootstrap.Modal(document.getElementById('photoLightbox'));
            modal.show();
        }

        function previewAvatar(input) {
            var img = document.getElementById('<%= imgAvatarPreview.ClientID %>');
            var placeholder = document.getElementById('<%= avatarPlaceholder.ClientID %>');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    img.src = e.target.result;
                    img.style.display = 'block';
                    placeholder.style.display = 'none';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function syncHero() {
            var name = document.getElementById('<%= txtName.ClientID %>').value.trim();
      var designation = document.getElementById('<%= txtDesignation.ClientID %>').value.trim();
      var email = document.getElementById('<%= txtEmail.ClientID %>').value.trim();
      var phone = document.getElementById('<%= txtPhone.ClientID %>').value.trim();
      var joiningDate = document.getElementById('<%= txtJoiningDate.ClientID %>').value;
      var deptDropdown = document.getElementById('<%= ddlDepartment.ClientID %>');
      var dept = deptDropdown.options[deptDropdown.selectedIndex] ? deptDropdown.options[deptDropdown.selectedIndex].text : '';

      document.getElementById('<%= lblHeroName.ClientID %>').innerText = name || 'New Employee';
      document.getElementById('<%= lblHeroDesignation.ClientID %>').innerText = designation || 'Designation not set';
      document.getElementById('<%= lblHeroDept.ClientID %>').innerText = dept || 'No department';
    document.getElementById('<%= lblHeroEmail.ClientID %>').innerText = email || 'No email on file';
    document.getElementById('<%= lblHeroPhone.ClientID %>').innerText = phone || 'No phone on file';
    document.getElementById('<%= lblHeroJoined.ClientID %>').innerText = joiningDate || 'Not set';
}

document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('<%= txtName.ClientID %>').addEventListener('keyup', syncHero);
    document.getElementById('<%= txtDesignation.ClientID %>').addEventListener('keyup', syncHero);
    document.getElementById('<%= txtEmail.ClientID %>').addEventListener('keyup', syncHero);
    document.getElementById('<%= txtPhone.ClientID %>').addEventListener('keyup', syncHero);
    document.getElementById('<%= txtJoiningDate.ClientID %>').addEventListener('change', syncHero);
    document.getElementById('<%= ddlDepartment.ClientID %>').addEventListener('change', syncHero);
});

        function showSpinner(btn, text) {
            setTimeout(function () {
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>' + text;
            }, 10);
        }
        function confirmDelete() {
            return confirm("Are you sure you want to delete this employee? This cannot be undone.");
        }
    </script>
</body>
</html>