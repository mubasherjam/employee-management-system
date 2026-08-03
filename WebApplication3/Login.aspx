<%@ Page Title="Login" Language="C#" AutoEventWireup="true" 
    CodeBehind="Login.aspx.cs" Inherits="HRMSApp.Login" %>
<%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>


<!DOCTYPE html>
<html>
<head runat="server">

    <title>Login - HRMS</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        * { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; box-sizing: border-box; }

        body {
            background: linear-gradient(135deg, #1a2332 0%, #2c3a52 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 24px;
        }

        .login-shell {
            width: 100%;
            max-width: 920px;
            min-height: 560px;
            background: #fff;
            border-radius: 28px;
            box-shadow: 0 30px 80px rgba(0,0,0,0.4);
            display: flex;
            overflow: hidden;
            animation: fadeIn 0.5s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ---- Left branding panel ---- */
        .login-brand-panel {
            flex: 1;
            background: linear-gradient(160deg, #7c5cff 0%, #5a3fd6 60%, #4530b3 100%);
            position: relative;
            padding: 48px 44px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: #fff;
            overflow: hidden;
        }

        .brand-blob {
            position: absolute;
            border-radius: 50%;
            background: rgba(255,255,255,0.08);
        }
        .brand-blob-1 { width: 280px; height: 280px; top: -80px; left: -100px; }
        .brand-blob-2 { width: 200px; height: 200px; bottom: -60px; right: -60px; background: rgba(255,255,255,0.06); }
        .brand-blob-3 { width: 90px; height: 90px; bottom: 120px; left: -20px; background: rgba(255,255,255,0.1); }

        .brand-icon {
            width: 54px;
            height: 54px;
            background: rgba(255,255,255,0.15);
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            position: relative;
            z-index: 2;
        }

        .brand-content {
            position: relative;
            z-index: 2;
        }
        .brand-content h2 {
            font-size: 1.9rem;
            font-weight: 800;
            margin: 24px 0 12px 0;
            line-height: 1.25;
        }
        .brand-content p {
            color: rgba(255,255,255,0.75);
            font-size: 0.95rem;
            line-height: 1.6;
            max-width: 320px;
        }

        .brand-footer {
            position: relative;
            z-index: 2;
            display: flex;
            align-items: center;
            gap: 10px;
            color: rgba(255,255,255,0.6);
            font-size: 0.82rem;
        }
        .brand-footer .dot {
            width: 6px; height: 6px; border-radius: 50%;
            background: #4ade80;
            box-shadow: 0 0 0 3px rgba(74, 222, 128, 0.2);
        }

        /* ---- Right form panel ---- */
        .login-form-panel {
            flex: 1;
            padding: 56px 48px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-heading h1 {
            font-size: 1.65rem;
            font-weight: 800;
            color: #1a2332;
            margin: 0 0 6px 0;
        }
        .form-heading p {
            color: #8892a0;
            font-size: 0.9rem;
            margin-bottom: 30px;
        }

        .form-label {
            font-weight: 600;
            color: #2c3e50;
            font-size: 0.85rem;
            margin-bottom: 6px;
            display: block;
        }

        .input-icon-group { position: relative; margin-bottom: 20px; }
        .input-icon-group i {
            position: absolute; left: 14px; top: 50%;
            transform: translateY(-50%); color: #adb5bd; font-size: 1rem; z-index: 5;
        }
        .input-icon-group .form-control {
            padding: 13px 16px 13px 42px;
            border-radius: 12px;
            border: 1.5px solid #e7ecf5;
            font-size: 0.95rem;
            background: #f8fafc;
            transition: all 0.15s ease;
        }
        .input-icon-group .form-control:focus {
            border-color: #7c5cff;
            box-shadow: 0 0 0 4px rgba(124,92,255,0.12);
            background: #fff;
        }

        .btn-login {
            background: linear-gradient(135deg, #7c5cff, #6a4ce0);
            color: #fff;
            font-weight: 700;
            border: none;
            border-radius: 12px;
            padding: 14px;
            width: 100%;
            font-size: 0.98rem;
            transition: all 0.15s ease;
            margin-top: 6px;
        }
        .btn-login:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 24px rgba(124,92,255,0.35);
            color: #fff;
        }

        .error-alert {
            background: #fff0f3;
            color: #d6336c;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 0.87rem;
            font-weight: 500;
            margin-bottom: 18px;
            display: none;
            align-items: center;
            gap: 8px;
        }

        .form-sub-footer {
            text-align: center;
            margin-top: 26px;
            color: #adb5bd;
            font-size: 0.85rem;
        }

        @media (max-width: 768px) {
            .login-shell { flex-direction: column; max-width: 440px; }
            .login-brand-panel { padding: 36px; min-height: 200px; }
            .brand-content h2 { font-size: 1.5rem; margin: 16px 0 8px 0; }
            .brand-content p { display: none; }
            .login-form-panel { padding: 36px 32px; }
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">

            <div class="login-shell">

        <!-- Left branding panel -->
        <div class="login-brand-panel">
            <div class="brand-blob brand-blob-1"></div>
            <div class="brand-blob brand-blob-2"></div>
            <div class="brand-blob brand-blob-3"></div>

            <div class="brand-icon"><i class="bi bi-building"></i></div>

            <div class="brand-content">
                <h2>Welcome back to HRMS Portal</h2>
                <p>Manage employee records, departments, and payroll — all in one secure workspace.</p>
            </div>

            <div class="brand-footer">
                <span class="dot"></span>
                Secure database connection active
            </div>
        </div>

        <!-- Right form panel -->
        <div class="login-form-panel">

            <div class="form-heading">
                <h1>Sign In</h1>
                <p>Enter your credentials to access your account</p>
            </div>

            <asp:Label ID="lblError" runat="server" CssClass="error-alert" />

            <div>
                <label class="form-label">Username or Email</label>
                <div class="input-icon-group">
                    <i class="bi bi-person"></i>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                        placeholder="e.g. admin" />
                </div>
            </div>

            <div>
                <label class="form-label">Password</label>
                <div class="input-icon-group mb-2">
                    <i class="bi bi-lock"></i>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" 
                        TextMode="Password" placeholder="Enter your password" />
                </div>
            </div>

            <!-- cookie input -->
            <div class="">
    <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="" />
    <label class="form-check-label" style="color:#2c3e50; font-size:0.88rem;">
        Remember me
    </label>
</div>

            <asp:Button ID="btnLogin" runat="server" Text="Sign In" 
                CssClass="btn btn-login mt-3" OnClick="btnLogin_Click" />

            <div class="form-sub-footer">
                HRMS Learning Project &middot; Internal Use Only
            </div>

        </div>

    </div>
    </form>
</body>
</html>