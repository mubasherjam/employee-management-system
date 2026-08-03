<%@ Page Title="Dashboard" Language="C#" AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs" Inherits="HRMSApp.Dashboard" %>
<%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Dashboard - HRMS</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>

    <style>
        * { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; }

        body { background: #f0f2f6; min-height: 100vh; }

        .fade-in { animation: fadeIn 0.4s ease-in; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .page-wrap { max-width: 1100px; }
        .page-title { font-size: 1.65rem; font-weight: 800; color: #1a2332; letter-spacing: -0.02em; }
        .page-subtitle { color: #8892a0; font-size: 0.9rem; }

        .card { border: none; border-radius: 16px; overflow: hidden; }
        .card.shadow { box-shadow: 0 10px 40px rgba(20, 30, 60, 0.08) !important; }

        .card-header-custom {
            background: linear-gradient(135deg, #1a2332 0%, #2c3a52 100%);
            color: #fff;
            padding: 20px 28px;
            border: none;
        }

        /* ---- Stat cards ---- */
        .stat-card {
            background: #fff;
            border-radius: 16px;
            padding: 22px 24px;
            box-shadow: 0 10px 40px rgba(20, 30, 60, 0.08);
            display: flex;
            align-items: center;
            gap: 16px;
            height: 100%;
        }
        .stat-icon {
            width: 50px; height: 50px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
        }
        .stat-icon.purple { background: rgba(124,92,255,0.12); color: #7c5cff; }
        .stat-icon.green  { background: rgba(74,222,128,0.15); color: #16a34a; }
        .stat-icon.red    { background: rgba(214,51,108,0.12); color: #d6336c; }
        .stat-icon.blue   { background: rgba(37,99,235,0.12); color: #2563eb; }

        .stat-value { font-size: 1.55rem; font-weight: 800; color: #1a2332; line-height: 1.1; }
        .stat-label { color: #8892a0; font-size: 0.8rem; font-weight: 600; margin-top: 2px; }

        /* ---- Recent employees list ---- */
        .recent-item {
            display: flex; align-items: center; gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid #f0f2f6;
        }
        .recent-item:last-child { border-bottom: none; }

        .avatar-circle {
            width: 42px; height: 42px;
            border-radius: 50%;
            background: linear-gradient(135deg, #7c5cff, #6a4ce0);
            color: #fff; font-weight: 700; font-size: 0.85rem;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }

        .recent-name { font-weight: 700; color: #1a2332; font-size: 0.92rem; }
        .recent-meta { color: #8892a0; font-size: 0.78rem; }

        .empty-state {
            text-align: center;
            color: #adb5bd;
            padding: 30px 10px;
            font-size: 0.9rem;
        }

        .chart-wrap { position: relative; height: 260px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <uc:Navbar ID="Navbar1" runat="server" />

        <div class="container my-5 fade-in page-wrap">

            <div class="mb-4">
                <div class="page-title">Dashboard</div>
                <div class="page-subtitle">Overview of your workforce and department activity</div>
            </div>

            <!-- Stat cards -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-lg-3">
                    <div class="stat-card">
                        <div class="stat-icon purple"><i class="bi bi-people-fill"></i></div>
                        <div>
                            <div class="stat-value"><asp:Literal ID="litActiveCount" runat="server" Text="0" /></div>
                            <div class="stat-label">Active Employees</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card">
                        <div class="stat-icon red"><i class="bi bi-person-dash-fill"></i></div>
                        <div>
                            <div class="stat-value"><asp:Literal ID="litInactiveCount" runat="server" Text="0" /></div>
                            <div class="stat-label">Inactive Employees</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card">
                        <div class="stat-icon blue"><i class="bi bi-building"></i></div>
                        <div>
                            <div class="stat-value"><asp:Literal ID="litDeptCount" runat="server" Text="0" /></div>
                            <div class="stat-label">Departments</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card">
                        <div class="stat-icon green"><i class="bi bi-cash-stack"></i></div>
                        <div>
                            <div class="stat-value"><asp:Literal ID="litTotalPayroll" runat="server" Text="0" /></div>
                            <div class="stat-label">Monthly Payroll</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent employees + Department breakdown -->
            <div class="row g-3">
                <div class="col-lg-6">
                    <div class="card shadow">
                        <div class="card-header-custom">
                            <span style="font-weight:700;">Recently Added</span>
                        </div>
                        <div class="card-body p-4">
                            <asp:Repeater ID="rptRecent" runat="server">
                                <ItemTemplate>
                                    <div class="recent-item">
                                        <div class="avatar-circle"><%# GetInitials(Eval("EmpName").ToString()) %></div>
                                        <div>
                                            <div class="recent-name"><%# Eval("EmpName") %></div>
                                            <div class="recent-meta">
                                                <%# Eval("DeptName") %>
                                                <%# string.IsNullOrEmpty(Eval("Designation").ToString()) ? "" : " &middot; " + Eval("Designation") %>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <asp:Label ID="lblNoRecent" runat="server" CssClass="empty-state" Text="No employees yet." Visible="false" />
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card shadow">
                        <div class="card-header-custom">
                            <span style="font-weight:700;">Department Breakdown</span>
                        </div>
                        <div class="card-body p-4">
                            <div class="chart-wrap">
                                <canvas id="deptChart"></canvas>
                            </div>
                            <asp:Label ID="lblNoDepts" runat="server" CssClass="empty-state" Text="No departments yet." Visible="false" />
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <asp:Literal ID="ltrChartScript" runat="server" />
    </form>
</body>
</html>