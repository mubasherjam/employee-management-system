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

        .section-header {
            display: flex; align-items: center; justify-content: space-between;
        }
        .section-header-title { display: flex; align-items: center; gap: 10px; font-weight: 700; }
        .section-header-title i { font-size: 1.1rem; opacity: 0.9; }
        .section-count-badge {
            background: rgba(255,255,255,0.15);
            padding: 4px 12px; border-radius: 20px;
            font-size: 0.75rem; font-weight: 600;
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
       /* ---- Recent employees list ---- */
        .recent-item {
            display: flex; align-items: center; gap: 14px;
            padding: 14px 12px;
            border-radius: 12px;
            transition: background-color 0.15s ease, transform 0.15s ease;
        }
        .recent-item:hover {
            background-color: #f8f7ff;
            transform: translateX(2px);
        }
        .recent-item:not(:last-child) { margin-bottom: 4px; }

        .avatar-circle {
            width: 44px; height: 44px;
            border-radius: 50%;
            background: linear-gradient(135deg, #7c5cff, #6a4ce0);
            color: #fff; font-weight: 700; font-size: 0.85rem;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(124,92,255,0.3);
            border: 2px solid #fff;
        }

        .recent-rank {
            width: 22px; height: 22px;
            border-radius: 6px;
            background: #eef0f4;
            color: #a3abba;
            font-size: 0.7rem;
            font-weight: 800;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }

        .recent-name { font-weight: 700; color: #1a2332; font-size: 0.92rem; }
        .recent-meta {
            color: #8892a0; font-size: 0.78rem;
            display: flex; align-items: center; gap: 5px; margin-top: 2px;
        }
        .recent-meta .dept-chip {
            background: #eef3ff; color: #3366ff;
            padding: 2px 9px; border-radius: 20px;
            font-weight: 600; font-size: 0.72rem;
        }

        .empty-state {
            text-align: center;
            color: #adb5bd;
            padding: 40px 10px;
            font-size: 0.9rem;
        }
        .empty-state i { font-size: 1.8rem; display: block; margin-bottom: 10px; color: #d7dbe4; }

        .chart-wrap {
            position: relative;
            height: 260px;
            background: #fafbfc;
            border-radius: 14px;
            padding: 18px 14px 6px 6px;
        }


        /* ---- Org Chart (appended, new section) ---- */
        .tree { padding: 20px 0; overflow-x: auto; }
        .tree ul {
            padding-top: 30px; position: relative;
            display: flex; justify-content: center;
        }
        .tree li {
            display: flex; flex-direction: column; align-items: center;
            list-style-type: none;
            position: relative;
            padding: 30px 12px 0 12px;
        }
        .tree li::before, .tree li::after {
            content: '';
            position: absolute; top: 0; right: 50%;
            border-top: 2px solid #d7dde5;
            width: 50%; height: 30px;
        }
        .tree li::after {
            right: auto; left: 50%;
            border-left: 2px solid #d7dde5;
        }
        .tree li:only-child::after, .tree li:only-child::before { display: none; }
        .tree li:only-child { padding-top: 0; }
        .tree li:first-child::before, .tree li:last-child::after { border: 0 none; }
        .tree li:last-child::before { border-right: 2px solid #d7dde5; border-radius: 0 6px 0 0; }
        .tree li:first-child::after { border-radius: 6px 0 0 0; }
        .tree ul ul::before {
            content: '';
            position: absolute; top: 0; left: 50%;
            border-left: 2px solid #d7dde5;
            width: 0; height: 30px;
        }

        .org-card {
            display: inline-flex; flex-direction: column; align-items: center;
            border-radius: 12px;
            padding: 14px 18px;
            min-width: 165px;
            box-shadow: 0 4px 14px rgba(20,30,60,0.1);
            transition: transform 0.15s ease;
        }
        .org-card:hover { transform: translateY(-3px); }


        .org-avatar-photo-wrap { margin-bottom: 8px; position: relative; }

.org-avatar-photo {
    width: 46px; height: 46px; border-radius: 50%;
    object-fit: cover;
    border: 2px solid rgba(255,255,255,0.5);
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}

.org-avatar {
    width: 46px; height: 46px; border-radius: 50%;
    background: rgba(255,255,255,0.25);
    color: #fff; font-weight: 800; font-size: 0.85rem;
    display: flex; align-items: center; justify-content: center;
    border: 2px solid rgba(255,255,255,0.5);
}

        .org-person { color: #fff; font-weight: 700; font-size: 0.88rem; text-align: center; }
        .org-title { color: rgba(255,255,255,0.85); font-size: 0.75rem; margin-top: 2px; text-align: center; }
        .org-vacant { font-style: italic; opacity: 0.75; }

        .org-root    { background: linear-gradient(135deg, #16a34a, #15803d); }
        .org-manager { background: linear-gradient(135deg, #2563eb, #1d4ed8); }
        .org-staff   { background: linear-gradient(135deg, #7c5cff, #6a4ce0); }
        .org-intern  { background: linear-gradient(135deg, #e0448a, #c22e73); }



        .legend-dot {
    display: inline-block; width: 10px; height: 10px;
    border-radius: 50%; margin-right: 5px;
}


        /* toggle icons in the chart tree*/
.tree ul.org-children-hidden{
    display:none !important;
}

.tree ul.org-children-visible{
    display:flex !important;
}
.org-toggle-icon {
    margin-top: 8px;
    color: rgba(255,255,255,0.85);
    font-size: 0.9rem;
    transition: transform 0.2s ease;
}
.org-toggle-icon.rotated { transform: rotate(180deg); }

.org-card { position: relative; }
.org-card:hover { transform: translateY(-3px); box-shadow: 0 8px 22px rgba(20,30,60,0.18); }

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
                        <div class="card-header-custom section-header">
                            <span class="section-header-title"><i class="bi bi-clock-history"></i> Recently Added</span>
                            <span class="section-count-badge"><i class="bi bi-people-fill me-1"></i><asp:Literal ID="litRecentCount" runat="server" Text="0" /></span>
                        </div>
                        <div class="card-body p-3">
                            <asp:Repeater ID="rptRecent" runat="server">
                                <ItemTemplate>
                                    <div class="recent-item">
                                        <div class="recent-rank"><%# Container.ItemIndex + 1 %></div>
                                        <div class="avatar-circle"><%# GetInitials(Eval("EmpName").ToString()) %></div>
                                        <div>
                                            <div class="recent-name"><%# Eval("EmpName") %></div>
                                            <div class="recent-meta">
                                                <span class="dept-chip"><%# Eval("DeptName") %></span>
                                                <%# string.IsNullOrEmpty(Eval("Designation").ToString()) ? "" : "&middot; " + Eval("Designation") %>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                            <div class="empty-state" runat="server" id="divNoRecentWrap" visible="false">
                                <i class="bi bi-inbox"></i>
                                <asp:Label ID="lblNoRecent" runat="server" Text="No employees yet." Visible="false" />
                            </div>
                        </div>
                    </div>
                </div>

               <div class="col-lg-6">
                    <div class="card shadow">
                        <div class="card-header-custom section-header">
                            <span class="section-header-title"><i class="bi bi-bar-chart-fill"></i> Department Breakdown</span>
                            <span class="section-count-badge"><i class="bi bi-building me-1"></i><asp:Literal ID="litDeptChartCount" runat="server" Text="0" /> Depts</span>
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

            <!-- org chart !-->
                        <!-- ============================= -->
            <!-- ORG CHART SECTION (new, appended below existing dashboard content) -->
            <!-- ============================= -->
            <div class="mt-4">
                <div class="card shadow">
                    <div class="card-header-custom">
                        <span style="font-weight:700;">Organization Chart</span>
                    </div>
                    <div class="card-body pb-0 pt-3">
    <div class="d-flex gap-3 flex-wrap" style="font-size:0.8rem;">
        <span><span class="legend-dot" style="background:#16a34a;"></span> Executive</span>
        <span><span class="legend-dot" style="background:#2563eb;"></span> Manager</span>
        <span><span class="legend-dot" style="background:#7c5cff;"></span> Staff</span>
        <span><span class="legend-dot" style="background:#e0448a;"></span> Intern</span>
    </div>
</div>
                    <div class="card-body p-4" style="overflow-x:auto;">
                        <asp:Literal ID="litOrgChart" runat="server" />
                    </div>
                </div>
            </div>

        </div>

        <asp:Literal ID="ltrChartScript" runat="server" />


        <!-- javascript function -->


        
<script>
    function toggleOrgNode(nodeId) {
        var childrenList = document.getElementById(nodeId + '-children');
        var card = document.getElementById(nodeId);
        var icon = card.querySelector('.org-toggle-icon i');

        if (!childrenList) return;

        var isHidden = childrenList.classList.contains('org-children-hidden');

        if (isHidden) {
            childrenList.classList.remove('org-children-hidden');
            childrenList.classList.add('org-children-visible');
            icon.classList.remove('bi-chevron-down');
            icon.classList.add('bi-chevron-up');
        } else {
            childrenList.classList.remove('org-children-visible');
            childrenList.classList.add('org-children-hidden');
            icon.classList.remove('bi-chevron-up');
            icon.classList.add('bi-chevron-down');

            // Also collapse any expanded grandchildren, so re-expanding starts fresh
            var nestedLists = childrenList.querySelectorAll('ul');
            nestedLists.forEach(function (ul) {
                ul.classList.remove('org-children-visible');
                ul.classList.add('org-children-hidden');
            });
            var nestedIcons = childrenList.querySelectorAll('.bi-chevron-up');
            nestedIcons.forEach(function (icon) {
                icon.classList.remove('bi-chevron-up');
                icon.classList.add('bi-chevron-down');
            });
        }
    }

    // Auto-expand the CEO's direct reports on page load, so the chart isn't just one lonely box

    
    
</script>
    </form>
</body>
</html>
