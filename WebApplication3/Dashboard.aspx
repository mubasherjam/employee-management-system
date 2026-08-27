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
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>


    <style>

        /* ---- Leave summary header ---- */
        .card-header-leave {
            background: linear-gradient(135deg, #6a4ce0 0%, #4b2fb0 55%, #7c5cff 100%);
            color: #fff;
            padding: 20px 28px;
            border: none;
            position: relative;
            overflow: hidden;
        }
        .card-header-leave::before {
            content: '';
            position: absolute;
            width: 160px; height: 160px;
            border-radius: 50%;
            background: rgba(255,255,255,0.08);
            top: -70px; right: -30px;
        }
        .card-header-leave .section-header-title,
        .card-header-leave .section-count-badge { position: relative; z-index: 2; }

        /* ---- Leave Summary: MD4 grid (3-per-row) progress ring cards ---- */
        .leave-ring-card {
            position: relative;
            background: #fff;
            border-radius: 16px;
            padding: 22px 20px 20px;
            border: 1px solid #eef0f4;
            overflow: hidden;
            text-align: center;
            height: 100%;
            opacity: 0;
            transform: translateY(10px);
            animation: leaveCardIn 0.5s ease forwards;
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }
        .leave-ring-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 14px 28px rgba(20,30,60,0.13);
        }
        @keyframes leaveCardIn { to { opacity: 1; transform: translateY(0); } }

        .leave-ring-blob {
            position: absolute;
            width: 120px; height: 120px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(124,92,255,0.07), transparent 70%);
            top: -40px; right: -30px;
            pointer-events: none;
        }

        .leave-ring-header {
            display: flex; align-items: center; gap: 10px;
            margin-bottom: 16px; text-align: left;
        }
        .leave-ring-icon {
            width: 36px; height: 36px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 1rem; flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.18);
        }
        .leave-ring-title {
            font-weight: 800; font-size: 0.95rem; color: #1a2332;
            line-height: 1.2;
            overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
        }

        .leave-ring-svg-wrap {
            position: relative;
            width: 108px; height: 108px;
            margin: 0 auto 16px;
        }
        .leave-ring-svg-wrap svg { transform: rotate(-90deg); }
        .leave-ring-track { fill: none; stroke: #eef0f4; stroke-width: 8; }
        .leave-ring-progress {
            fill: none; stroke-width: 8; stroke-linecap: round;
            transition: stroke-dashoffset 1.2s cubic-bezier(0.22, 1, 0.36, 1);
        }
        .leave-ring-center {
            position: absolute; inset: 0;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
        }
        .leave-ring-num { font-size: 1.6rem; font-weight: 800; color: #1a2332; line-height: 1; }
        .leave-ring-sub {
            font-size: 0.62rem; color: #8892a0; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.04em; margin-top: 3px;
        }

        .leave-usage-bar-bg {
            height: 6px; border-radius: 6px; background: #eef0f4;
            overflow: hidden; margin-bottom: 14px;
        }
        .leave-usage-bar-fill {
            height: 100%; border-radius: 6px;
            transition: width 1s cubic-bezier(0.22, 1, 0.36, 1);
        }

        .leave-ring-footer {
            display: flex; align-items: center; justify-content: center; gap: 5px;
            font-size: 0.8rem; color: #8892a0; font-weight: 600;
        }
        .leave-ring-footer b { color: #1a2332; font-weight: 800; }
        .leave-ring-divider { color: #d7dde5; }

        /* leave summary ends here */

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
            position: relative;
            border-radius: 18px;
            padding: 24px 22px;
            display: flex;
            align-items: center;
            gap: 16px;
            height: 100%;
            overflow: hidden;
            color: #fff;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: default;
        }
        .stat-card:hover {
            transform: translateY(-4px);
        }

        /* Decorative background blobs */
        .stat-card::before {
            content: '';
            position: absolute;
            width: 110px; height: 110px;
            border-radius: 50%;
            background: rgba(255,255,255,0.12);
            top: -40px; right: -30px;
        }
        .stat-card::after {
            content: '';
            position: absolute;
            width: 60px; height: 60px;
            border-radius: 50%;
            background: rgba(255,255,255,0.08);
            bottom: -25px; right: 30px;
        }

.stat-card.purple {
    background: linear-gradient(135deg, #8b7bb8 0%, #5f4b8b 100%);
    box-shadow: 0 12px 28px rgba(95, 75, 139, 0.3);
}
.stat-card.green {
    background: linear-gradient(135deg, #54876b 0%, #3b624d 100%);
    box-shadow: 0 12px 28px rgba(84, 135, 107, 0.3);
}
.stat-card.red {
    background: linear-gradient(135deg, #ff6b6b 0%, #e03131 100%);
    box-shadow: 0 12px 28px rgba(224, 49, 49, 0.3);
}
.stat-card.blue {
    background: linear-gradient(135deg, #3f6fc4 0%, #1e3a5f 100%);
    box-shadow: 0 12px 28px rgba(30, 58, 95, 0.3);
}
        .stat-card:hover.purple { box-shadow: 0 18px 36px rgba(124,92,255,0.45); }
        .stat-card:hover.green  { box-shadow: 0 18px 36px rgba(22,163,74,0.4); }
        .stat-card:hover.red    { box-shadow: 0 18px 36px rgba(214,51,108,0.4); }
        .stat-card:hover.blue   { box-shadow: 0 18px 36px rgba(37,99,235,0.4); }

        .stat-icon {
            position: relative; z-index: 2;
            width: 52px; height: 52px;
            border-radius: 14px;
            background: rgba(255,255,255,0.2);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.35rem;
            flex-shrink: 0;
            backdrop-filter: blur(4px);
        }

        .stat-value {
            position: relative; z-index: 2;
            font-size: 1.7rem; font-weight: 800; color: #fff; line-height: 1.1;
        }
        .stat-label {
            position: relative; z-index: 2;
            color: rgba(255,255,255,0.85); font-size: 0.8rem; font-weight: 600; margin-top: 3px;
        }

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



        /* ---- Attendance Chart (new section) ---- */
        .attendance-stats-row {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .attendance-stat-chip {
            display: flex; align-items: center; gap: 7px;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 700;
        }
        .attendance-stat-chip .dot {
            width: 8px; height: 8px; border-radius: 50%;
        }
        .chip-intime { background: #ecfdf3; color: #16a34a; }
        .chip-intime .dot { background: #16a34a; }
        .chip-late { background: #fffbeb; color: #b45309; }
        .chip-late .dot { background: #f59e0b; }
        .chip-notarrived { background: #f1f5f9; color: #64748b; }
        .chip-notarrived .dot { background: #94a3b8; }
        /* attendance chart ends here*/

        /* team attendance starts here*/

        /* ---- Team Attendance (new section) ---- */
        .team-member-row {
            display: flex; align-items: center; gap: 16px;
            padding: 16px 4px;
            border-bottom: 1px solid #f0f2f6;
        }
        .team-member-row:last-child { border-bottom: none; }

        .team-avatar-wrap { flex-shrink: 0; }
        .team-avatar-photo {
            width: 48px; height: 48px; border-radius: 50%;
            object-fit: cover; border: 2px solid #eef0f4;
        }
        .team-avatar-fallback {
            width: 48px; height: 48px; border-radius: 50%;
            background: linear-gradient(135deg, #7c5cff, #6a4ce0);
            color: #fff; font-weight: 700; font-size: 0.85rem;
            display: flex; align-items: center; justify-content: center;
        }

        .team-member-info { flex: 1; min-width: 160px; }
        .team-member-name { font-weight: 700; color: #1a2332; font-size: 0.93rem; }
        .team-member-times {
            display: flex; gap: 14px; margin-top: 4px;
            font-size: 0.76rem; color: #8892a0;
        }
        .team-member-times span { display: flex; align-items: center; gap: 4px; }
        .team-member-times i { font-size: 0.85rem; }

        .team-rate-wrap { width: 160px; flex-shrink: 0; }
        .team-rate-bar-bg {
            height: 8px; border-radius: 6px; background: #eef0f4;
            overflow: hidden; margin-bottom: 4px;
        }
        .team-rate-bar-fill {
            height: 100%; border-radius: 6px;
            background: linear-gradient(90deg, #16a34a, #22c55e);
        }
        .team-rate-label { font-size: 0.72rem; font-weight: 700; color: #16a34a; text-align: right; }

        .team-status-pills { display: flex; gap: 6px; flex-shrink: 0; }
        .status-pill {
            font-size: 0.7rem; font-weight: 700;
            padding: 3px 9px; border-radius: 20px;
        }
        .pill-intime { background: #ecfdf3; color: #16a34a; }
        .pill-late { background: #fffbeb; color: #b45309; }
        .pill-absent { background: #f1f5f9; color: #64748b; }

        @media (max-width: 767px) {
            .team-member-row { flex-wrap: wrap; }
            .team-rate-wrap { width: 100%; order: 3; }
        }


        /* ---- Last 7 Days Summary Card (KPI tiles, each with its own single-metric sparkline) ---- */
        .l7-period-badge {
            display: inline-flex; align-items: center; gap: 7px;
            background: linear-gradient(135deg, #eef1f8, #e4e9f5);
            color: #4a5568;
            font-size: 0.73rem; font-weight: 700;
            padding: 6px 14px; border-radius: 20px;
            margin-bottom: 14px;
            border: 1px solid #e2e7f0;
        }
        .l7-period-badge i { color: #7c5cff; }

        .l7-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .l7-tile {
            position: relative;
            border-radius: 16px;
            padding: 16px 16px 12px;
            overflow: hidden;
            color: #fff;
            opacity: 0;
            transform: translateY(10px);
            animation: l7RiseIn 0.45s ease forwards;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .l7-tile:hover { transform: translateY(-4px); }
        @keyframes l7RiseIn { to { opacity: 1; transform: translateY(0); } }

        /* Decorative highlight lives in the empty top-right corner only, away from the
           icon/value/label so it never washes out the text's contrast. */
        .l7-tile::before {
            content: '';
            position: absolute;
            width: 90px; height: 90px;
            border-radius: 50%;
            background: rgba(255,255,255,0.05);
            top: -34px; right: -22px;
            pointer-events: none;
        }

        /* One shared neutral charcoal background across all four tiles - each metric keeps
           its own identity through the icon badge and sparkline color instead of a colored card. */
        .l7-tile {
            background: #1A3263;
            box-shadow: 0 8px 20px rgba(15,18,26,0.35);
        }
        .l7-tile:hover {
            box-shadow: 0 14px 28px rgba(15,18,26,0.5);
        }

        .l7-tile-top {
            position: relative; z-index: 2;
            display: flex; align-items: center; gap: 12px;
            margin-bottom: 10px;
        }

        .l7-icon-badge {
            width: 32px; height: 32px;
            border-radius: 9px;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.85rem;
            flex-shrink: 0;
            color: #fff;
            box-shadow: 0 3px 8px rgba(0,0,0,0.25);
        }
        .tile-checkin  .l7-icon-badge { background: linear-gradient(135deg, #4f8cf7, #2955c9); }
        .tile-checkout .l7-icon-badge { background: linear-gradient(135deg, #9b7bff, #6a4ce0); }
        .tile-hours    .l7-icon-badge { background: linear-gradient(135deg, #34d399, #16a34a); }
        .tile-absent   .l7-icon-badge { background: linear-gradient(135deg, #f472b6, #d63384); }

        .l7-value {
            font-size: 1.3rem; font-weight: 800;
            line-height: 1.15;
            letter-spacing: -0.01em;
            white-space: nowrap;
        }
        .l7-label {
            font-size: 0.64rem;
            color: rgba(255,255,255,0.85);
            font-weight: 700;
            margin-top: 2px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .l7-spark-wrap {
            position: relative;
            z-index: 2;
            height: 46px;
            margin: 6px -4px 0;
        }

        /* ---- Compensation History Card (TGC Range trend) ---- */
        .tgc-card {
            position: relative;
            overflow: hidden;
            opacity: 0;
            transform: translateY(10px);
            animation: l7RiseIn 0.5s ease forwards;
            transition: transform 0.28s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.28s ease;
        }
        .tgc-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 18px 36px rgba(20,30,60,0.16) !important;
        }
        .tgc-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 4px;
            background: linear-gradient(90deg, #4f8cf7, #7c5cff, #34d399, #4f8cf7);
            background-size: 300% 100%;
            animation: tgcGradientShift 6s ease infinite;
            z-index: 3;
        }
        @keyframes tgcGradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .tgc-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 16px;
        }

        .tgc-growth-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.78rem;
            font-weight: 700;
            padding: 6px 14px;
            border-radius: 20px;
            background: linear-gradient(135deg, #e7f9ef, #dcf5e8);
            color: #16a34a;
            border: 1px solid #cdeedd;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: default;
        }
        .tgc-growth-chip:hover {
            transform: scale(1.06);
            box-shadow: 0 6px 14px rgba(22,163,74,0.18);
        }
        .tgc-growth-chip.negative {
            background: linear-gradient(135deg, #fdecec, #fbe0e0);
            color: #dc2626;
            border-color: #f7d3d3;
        }
        .tgc-growth-chip.negative:hover {
            box-shadow: 0 6px 14px rgba(220,38,38,0.18);
        }
        .tgc-growth-chip i {
            font-size: 0.82rem;
            transition: transform 0.2s ease;
        }
        .tgc-growth-chip:hover i {
            transform: translateY(-2px);
        }

        .tgc-chart-wrap {
            position: relative;
            height: 260px;
        }

        .tgc-current-row {
            display: flex;
            align-items: baseline;
            gap: 10px;
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px dashed #e9edf3;
        }
        .tgc-current-value {
            font-size: 1.5rem;
            font-weight: 800;
            color: #1a2332;
            letter-spacing: -0.01em;
            transition: color 0.2s ease;
        }
        .tgc-current-label {
            font-size: 0.72rem;
            color: #8892a0;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        /* ---- Status Breakdown Card (candle bar with hover tooltip) ---- */
        .status-count-hero {
            display: flex; align-items: baseline; gap: 8px;
            margin-bottom: 22px;
        }
        .status-count-hero .big-num {
            font-size: 2.4rem; font-weight: 800; color: #1a2332; line-height: 1;
        }
        .status-count-hero .big-label {
            color: #8892a0; font-size: 0.85rem; font-weight: 600;
        }

        .candle-bar-track {
            display: flex;
            width: 100%;
            height: 46px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: inset 0 0 0 1px #eef0f4;
        }

        .candle-segment {
            position: relative;
            height: 100%;
            transition: flex-grow 0.8s cubic-bezier(0.22, 1, 0.36, 1), filter 0.15s ease;
            cursor: pointer;
            min-width: 4px;
        }
        .candle-segment:hover { filter: brightness(1.1); }

        .seg-ontime { background: linear-gradient(180deg, #4ade80, #16a34a); }
        .seg-late   { background: linear-gradient(180deg, #fbbf24, #d97706); }
        .seg-absent { background: linear-gradient(180deg, #f87171, #dc2626); }

       .candle-tooltip {
    position: absolute;
    bottom: calc(100% + 10px);
    left: 50%;
    transform: translateX(-50%) translateY(6px);
    background: #1a2332;
    color: #fff;
    font-size: 0.76rem;
    padding: 10px 14px;
    border-radius: 10px;

    width: max-content;
    min-width: 150px;
    max-width: 260px;

    line-height: 1.5;
    box-shadow: 0 10px 24px rgba(0,0,0,0.25);
    opacity: 0;
    pointer-events: none;
    transition: opacity 0.18s ease, transform 0.18s ease;
    z-index: 10;
}
        .candle-tooltip::after {
            content: '';
            position: absolute;
            top: 100%; left: 50%;
            transform: translateX(-50%);
            border: 6px solid transparent;
            border-top-color: #1a2332;
        }
        .candle-tooltip .tooltip-title {
            font-weight: 800;
            display: block;
            margin-bottom: 3px;
        }
        .candle-segment:hover .candle-tooltip {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }

        .candle-legend-row {
            display: flex;
            justify-content: space-between;
            margin-top: 18px;
        }
        .candle-legend-item {
            text-align: center;
            flex: 1;
        }
        .candle-legend-item .legend-dot-lg {
            width: 10px; height: 10px; border-radius: 50%;
            display: inline-block; margin-right: 5px;
        }
        .dot-ontime { background: #16a34a; }
        .dot-late   { background: #d97706; }
        .dot-absent { background: #dc2626; }

        .candle-legend-item .legend-count {
            font-size: 1.1rem; font-weight: 800; color: #1a2332; display: block; margin-top: 4px;
        }
        .candle-legend-item .legend-text {
            font-size: 0.74rem; color: #8892a0; font-weight: 600;
        }


        /* ---- Status Snapshot Card (matches Department Breakdown style) ---- */
        .status-chart-wrap {
            position: relative;
            height: 260px;
            background: #fafbfc;
            border-radius: 14px;
            padding: 18px 14px 6px 6px;
        }
        .status-employee-name {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 0.73rem;
    line-height: 1.6;
    white-space: nowrap;
}

.status-employee-name i {
    font-size: 0.68rem;
    opacity: 0.8;
}

.status-no-employees {
    font-size: 0.73rem;
    opacity: 0.7;
    font-style: italic;
}

        .l7-compact .card-body.p-3 {
            padding: 18px !important;
        }

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

            <!-- ============================= -->
            <!-- STAT CARDS -->
            <!-- ============================= -->
            <div class="row g-3">
                <div class="col-6 col-lg-3">
                    <div class="stat-card purple">
                        <div class="stat-icon"><i class="bi bi-people-fill"></i></div>
                        <div>
                            <div class="stat-value"><asp:Literal ID="litActiveCount" runat="server" Text="0" /></div>
                            <div class="stat-label">Active Employees</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card red">
                        <div class="stat-icon"><i class="bi bi-person-dash-fill"></i></div>
                        <div>
                            <div class="stat-value"><asp:Literal ID="litInactiveCount" runat="server" Text="0" /></div>
                            <div class="stat-label">Inactive Employees</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card blue">
                        <div class="stat-icon"><i class="bi bi-building"></i></div>
                        <div>
                            <div class="stat-value"><asp:Literal ID="litDeptCount" runat="server" Text="0" /></div>
                            <div class="stat-label">Departments</div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card green">
                        <div class="stat-icon"><i class="bi bi-cash-stack"></i></div>
                        <div>
                            <div class="stat-value"><asp:Literal ID="litTotalPayroll" runat="server" Text="0" /></div>
                            <div class="stat-label">Monthly Payroll</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ============================= -->
            <!-- RECENT EMPLOYEES + DEPARTMENT BREAKDOWN -->
            <!-- ============================= -->
            <div class="row g-3 mt-4">
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

            <!-- ============================= -->
            <!-- LEAVE SUMMARY SECTION -->
            <!-- ============================= -->
            <div class="row g-3 mt-4">
                <div class="col-12">
                    <div class="card shadow">
                        <div class="card-header-leave section-header">
                            <span class="section-header-title"><i class="bi bi-calendar2-week-fill"></i> Leave Summary</span>
                            <span class="section-count-badge"><i class="bi bi-list-check me-1"></i><asp:Literal ID="litLeaveTypeCount" runat="server" Text="0" /> Types</span>
                        </div>
                        <div class="card-body p-3">
                            <asp:Literal ID="litLeaveList" runat="server" />
                            <asp:Label ID="lblNoLeave" runat="server" CssClass="empty-state" Text="No leave data yet." Visible="false" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- ============================= -->
            <!-- ORG CHART SECTION -->
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

            <!-- ============================= -->
            <!-- ATTENDANCE CHART SECTION -->
            <!-- ============================= -->
            <div class="mt-4">
                <div class="card shadow">
                    <div class="card-header-custom section-header">
                        <span class="section-header-title"><i class="bi bi-calendar-check-fill"></i> Attendance Overview</span>
                        <span class="section-count-badge"><i class="bi bi-clock-history me-1"></i>Last 12 Days</span>
                    </div>
                    <div class="card-body pb-0 pt-3">
                        <div class="attendance-stats-row">
                            <span class="attendance-stat-chip chip-intime">
                                <span class="dot"></span> In Time: <asp:Literal ID="litInTimeCount" runat="server" Text="0" />
                            </span>
                            <span class="attendance-stat-chip chip-late">
                                <span class="dot"></span> Late: <asp:Literal ID="litLateCount" runat="server" Text="0" />
                            </span>
                            <span class="attendance-stat-chip chip-notarrived">
                                <span class="dot"></span> Not Arrived: <asp:Literal ID="litNotArrivedCount" runat="server" Text="0" />
                            </span>
                        </div>
                    </div>
                    <div class="card-body p-4">
                        <div class="chart-wrap">
                            <canvas id="attendanceChart"></canvas>
                        </div>
                        <asp:Label ID="lblNoAttendance" runat="server" CssClass="empty-state" Text="No attendance records yet." Visible="false" />
                    </div>
                </div>
            </div>

            <!-- ============================= -->
            <!-- TEAM ATTENDANCE SECTION -->
            <!-- ============================= -->
            <div class="mt-4">
                <div class="card shadow">
                    <div class="card-header-custom section-header">
                        <span class="section-header-title"><i class="bi bi-people-fill"></i> Team Attendance Summary</span>
                        <span class="section-count-badge"><i class="bi bi-person-check me-1"></i><asp:Literal ID="litTeamAttCount" runat="server" Text="0" /> Members</span>
                    </div>

                    <div class="card-body p-4 pb-2">
                        <asp:Repeater ID="rptTeamAttendance" runat="server">
                            <ItemTemplate>
                                <div class="team-member-row">
                                    <div class="team-avatar-wrap">
                                        <img class="team-avatar-photo" src='<%# "ShowImage.ashx?EmpID=" + Eval("EmpID") %>' 
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                        <div class="team-avatar-fallback" style="display:none;"><%# GetInitials(Eval("EmpName").ToString()) %></div>
                                    </div>
                                    <div class="team-member-info">
                                        <div class="team-member-name"><%# Eval("EmpName") %></div>
                                        <div class="team-member-times">
                                            <span><i class="bi bi-box-arrow-in-right"></i> In: <%# Eval("AvgCheckIn") %></span>
                                            <span><i class="bi bi-box-arrow-right"></i> Out: <%# Eval("AvgCheckOut") %></span>
                                            <span><i class="bi bi-hourglass-split"></i> <%# Eval("AvgHours") %> hrs/day</span>
                                        </div>
                                    </div>
                                    <div class="team-status-pills">
                                        <span class="status-pill pill-intime"><%# Eval("InTimeCount") %> On-time</span>
                                        <span class="status-pill pill-late"><%# Eval("LateCount") %> Late</span>
                                        <span class="status-pill pill-absent"><%# Eval("NotArrivedCount") %> Absent</span>
                                    </div>
                                    <div class="team-rate-wrap">
                                        <div class="team-rate-bar-bg">
                                            <div class="team-rate-bar-fill" style='width:<%# GetAttendanceRate(Eval("InTimeCount"), Eval("TotalDays")) %>%;'></div>
                                        </div>
                                        <div class="team-rate-label"><%# GetAttendanceRate(Eval("InTimeCount"), Eval("TotalDays")) %>% on-time</div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoTeamAttendance" runat="server" CssClass="empty-state" Text="No team attendance data yet." Visible="false" />
                    </div>

                    <div class="card-body p-4 pt-2">
                        <div class="chart-wrap" style="height:280px;">
                            <canvas id="teamAttendanceChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ============================= -->
            <!-- LAST 7 DAYS + STATUS SNAPSHOT ROW -->
            <!-- ============================= -->
            <div class="row g-3 mt-4">

                <div class="col-lg-6">
                    <div class="card shadow h-100 l7-compact">
                        <div class="card-header-custom">
                            <span style="font-weight:700;"><i class="bi bi-calendar-week me-2"></i>Last 7 Days Overview</span>
                        </div>
                        <div class="card-body p-3">
                            <span class="l7-period-badge">
                                <i class="bi bi-clock-history"></i>
                                <asp:Literal ID="litL7Range" runat="server" Text="Rolling 7-Day Window" />
                            </span>
                            <div class="l7-grid">
                                <div class="l7-tile tile-checkin" style="animation-delay:0.05s;">
                                    <div class="l7-tile-top">
                                        <span class="l7-icon-badge"><i class="bi bi-box-arrow-in-right"></i></span>
                                        <div>
                                            <div class="l7-value"><asp:Literal ID="litL7AvgCheckIn" runat="server" Text="--:--" /></div>
                                            <div class="l7-label">Avg Check-In</div>
                                        </div>
                                    </div>
                                    <div class="l7-spark-wrap"><canvas id="l7SparkCheckIn"></canvas></div>
                                </div>
                                <div class="l7-tile tile-checkout" style="animation-delay:0.1s;">
                                    <div class="l7-tile-top">
                                        <span class="l7-icon-badge"><i class="bi bi-box-arrow-right"></i></span>
                                        <div>
                                            <div class="l7-value"><asp:Literal ID="litL7AvgCheckOut" runat="server" Text="--:--" /></div>
                                            <div class="l7-label">Avg Check-Out</div>
                                        </div>
                                    </div>
                                    <div class="l7-spark-wrap"><canvas id="l7SparkCheckOut"></canvas></div>
                                </div>
                                <div class="l7-tile tile-hours" style="animation-delay:0.15s;">
                                    <div class="l7-tile-top">
                                        <span class="l7-icon-badge"><i class="bi bi-hourglass-split"></i></span>
                                        <div>
                                            <div class="l7-value"><asp:Literal ID="litL7AvgHours" runat="server" Text="0.0" /> hrs</div>
                                            <div class="l7-label">Avg Time Spent</div>
                                        </div>
                                    </div>
                                    <div class="l7-spark-wrap"><canvas id="l7SparkHours"></canvas></div>
                                </div>
                                <div class="l7-tile tile-absent" style="animation-delay:0.2s;">
                                    <div class="l7-tile-top">
                                        <span class="l7-icon-badge"><i class="bi bi-person-x-fill"></i></span>
                                        <div>
                                            <div class="l7-value"><asp:Literal ID="litL7TotalAbsents" runat="server" Text="0" /></div>
                                            <div class="l7-label">Total Absents</div>
                                        </div>
                                    </div>
                                    <div class="l7-spark-wrap"><canvas id="l7SparkAbsent"></canvas></div>
                                </div>
                            </div>
                            <asp:Label ID="lblNoL7Trend" runat="server" CssClass="empty-state" Text="No attendance trend data yet." Visible="false" />
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card shadow h-100 status-compact">
                        <div class="card-header-custom">
                            <span style="font-weight:700;"><i class="bi bi-bar-chart-steps me-2"></i>Today's Status Snapshot</span>
                        </div>
                        <div class="card-body p-3">
                            <div class="status-count-hero">
                                <span class="big-num"><asp:Literal ID="litStatusTotalCount" runat="server" Text="0" /></span>
                                <span class="big-label">Total Employees Tracked</span>
                            </div>
                            <div class="chart-wrap" style="height:240px;">
                                <canvas id="statusChart"></canvas>
                            </div>
                            <asp:Label ID="lblNoStatus" runat="server" CssClass="empty-state" Text="No attendance data for today." Visible="false" />
                        </div>
                    </div>
                </div>

            </div>

            <!-- ============================= -->
            <!-- LAST 7 DAYS OVERVIEW - VERTICAL LINE CHART VARIANT (for comparison) -->
            <!-- ============================= -->
            <div class="row g-3 mt-4">
                <div class="col-lg-6">
                    <div class="card shadow h-100 l7-compact">
                        <div class="card-header-custom">
                            <span style="font-weight:700;"><i class="bi bi-graph-up-arrow me-2"></i>Last 7 Days Overview &ndash; Vertical Trend</span>
                        </div>
                        <div class="card-body p-3">
                            <span class="l7-period-badge">
                                <i class="bi bi-clock-history"></i>
                                <asp:Literal ID="litL7RangeAlt" runat="server" Text="Rolling 7-Day Window" />
                            </span>
                            <div class="l7-grid">
                                <div class="l7-tile tile-checkin" style="animation-delay:0.05s;">
                                    <div class="l7-tile-top">
                                        <span class="l7-icon-badge"><i class="bi bi-box-arrow-in-right"></i></span>
                                        <div>
                                            <div class="l7-value"><asp:Literal ID="litL7AvgCheckInAlt" runat="server" Text="--:--" /></div>
                                            <div class="l7-label">Avg Check-In</div>
                                        </div>
                                    </div>
                                    <div class="l7-spark-wrap"><canvas id="l7vSparkCheckIn"></canvas></div>
                                </div>
                                <div class="l7-tile tile-checkout" style="animation-delay:0.1s;">
                                    <div class="l7-tile-top">
                                        <span class="l7-icon-badge"><i class="bi bi-box-arrow-right"></i></span>
                                        <div>
                                            <div class="l7-value"><asp:Literal ID="litL7AvgCheckOutAlt" runat="server" Text="--:--" /></div>
                                            <div class="l7-label">Avg Check-Out</div>
                                        </div>
                                    </div>
                                    <div class="l7-spark-wrap"><canvas id="l7vSparkCheckOut"></canvas></div>
                                </div>
                                <div class="l7-tile tile-hours" style="animation-delay:0.15s;">
                                    <div class="l7-tile-top">
                                        <span class="l7-icon-badge"><i class="bi bi-hourglass-split"></i></span>
                                        <div>
                                            <div class="l7-value"><asp:Literal ID="litL7AvgHoursAlt" runat="server" Text="0.0" /> hrs</div>
                                            <div class="l7-label">Avg Time Spent</div>
                                        </div>
                                    </div>
                                    <div class="l7-spark-wrap"><canvas id="l7vSparkHours"></canvas></div>
                                </div>
                                <div class="l7-tile tile-absent" style="animation-delay:0.2s;">
                                    <div class="l7-tile-top">
                                        <span class="l7-icon-badge"><i class="bi bi-person-x-fill"></i></span>
                                        <div>
                                            <div class="l7-value"><asp:Literal ID="litL7TotalAbsentsAlt" runat="server" Text="0" /></div>
                                            <div class="l7-label">Total Absents</div>
                                        </div>
                                    </div>
                                    <div class="l7-spark-wrap"><canvas id="l7vSparkAbsent"></canvas></div>
                                </div>
                            </div>
                            <asp:Label ID="lblNoL7TrendAlt" runat="server" CssClass="empty-state" Text="No attendance trend data yet." Visible="false" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- ============================= -->
            <!-- COMPENSATION HISTORY - TGC RANGE TREND -->
            <!-- ============================= -->
            <div class="row g-3 mt-4">
                <div class="col-lg-6">
                    <div class="card shadow h-100 l7-compact tgc-card">
                        <div class="card-header-custom">
                            <span style="font-weight:700;"><i class="bi bi-graph-up me-2"></i>Compensation History &ndash; TGC Range</span>
                        </div>
                        <div class="card-body p-3">
                            <div class="tgc-toolbar">
                                <span class="l7-period-badge">
                                    <i class="bi bi-clock-history"></i>
                                    <asp:Literal ID="litTgcRange" runat="server" Text="Since Joining" />
                                </span>
                                <span class="tgc-growth-chip" id="tgcGrowthChip">
                                    <i class="bi bi-arrow-up-right" id="tgcGrowthIcon"></i>
                                    <span id="tgcGrowthText">--</span>
                                </span>
                            </div>
                            <div class="tgc-chart-wrap">
                                <canvas id="tgcRangeChart"></canvas>
                            </div>
                            <div class="tgc-current-row">
                                <span class="tgc-current-value" id="tgcCurrentValue">--</span>
                                <span class="tgc-current-label">Current TGC</span>
                            </div>
                            <asp:Label ID="lblNoEventHistory" runat="server" CssClass="empty-state" Text="No compensation history yet." Visible="false" />
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <asp:Literal ID="ltrTeamAttendanceScript" runat="server" />
        <asp:Literal ID="ltrStatusChartScript" runat="server" />
        <asp:Literal ID="ltrAttendanceChartScript" runat="server" />
        <asp:Literal ID="ltrChartScript" runat="server" />
        <asp:Literal ID="ltrL7ChartScript" runat="server" />
        <asp:Literal ID="ltrEventHistoryChartScript" runat="server" />


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
  
    // Animate leave progress bars from 0 to their real width on load
window.addEventListener('load', function () {
    var rings = document.querySelectorAll('.leave-ring-progress');
    rings.forEach(function (ring, i) {
        var target = ring.getAttribute('data-target-offset');
        setTimeout(function () {
            ring.style.strokeDashoffset = target;
        }, 200 + (i * 120));
    });
});
  
    
</script>

 
    </form>
</body>
</html>
