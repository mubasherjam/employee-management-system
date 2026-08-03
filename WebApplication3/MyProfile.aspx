<%@ Page Title="My Profile" Language="C#" AutoEventWireup="true" 
    CodeBehind="MyProfile.aspx.cs" Inherits="HRMSApp.MyProfile" %>
<%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>My Profile</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <style>
        body { background: #f0f2f6; font-family: 'Inter', sans-serif; }
        .card { border: none; border-radius: 16px; }
        .card-header-custom { background: #0B62E0; color: #fff; padding: 24px 32px; }
        .form-label { font-weight: 600; color: #2c3e50; }
        .readonly-field { background: #f8f9fa; color: #6c757d; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <uc:Navbar ID="Navbar1" runat="server" />

        <div class="container mt-4 mb-5" style="max-width: 700px;">
            <div class="card shadow">
                <div class="card-header card-header-custom">
                    <h3 class="m-0"><i class="bi bi-person-badge-fill me-2"></i>My Profile</h3>
                    <small>You can update your contact details below</small>
                </div>
                <div class="card-body p-4">

                    <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3" />

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Full Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control readonly-field" ReadOnly="true" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Department</label>
                            <asp:TextBox ID="txtDeptReadOnly" runat="server" CssClass="form-control readonly-field" ReadOnly="true" />
                        </div>
                    </div>

                    <hr />

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Phone</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-12">
                            <label class="form-label">Address</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Emergency Contact Name</label>
                            <asp:TextBox ID="txtEmergencyName" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Emergency Contact Phone</label>
                            <asp:TextBox ID="txtEmergencyPhone" runat="server" CssClass="form-control" />
                        </div>
                    </div>

                    <hr />
                    <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" 
                        CssClass="btn btn-primary" OnClick="btnSaveProfile_Click" />

                </div>
            </div>
        </div>
    </form>
</body>
</html>