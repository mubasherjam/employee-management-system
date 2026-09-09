<%@ Page Title="Dashboard" Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs"
    Inherits="HRMSApp.Dashboard" %>

    <%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>
        <%@ Import Namespace="System.Globalization" %>
            <!DOCTYPE html>
            <html>

            <head runat="server">
                <title>Dashboard - HRMS</title>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet" />
                <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>


                <style>
                    /*  Leave summary hear  */
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
                        width: 160px;
                        height: 160px;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.08);
                        top: -70px;
                        right: -30px;
                    }

                    .card-header-leave .section-header-title,
                    .card-header-leave .section-count-badge {
                        position: relative;
                        z-index: 2;
                    }

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
                        box-shadow: 0 14px 28px rgba(20, 30, 60, 0.13);
                    }

                    @keyframes leaveCardIn {
                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .leave-ring-blob {
                        position: absolute;
                        width: 120px;
                        height: 120px;
                        border-radius: 50%;
                        background: radial-gradient(circle, rgba(124, 92, 255, 0.07), transparent 70%);
                        top: -40px;
                        right: -30px;
                        pointer-events: none;
                    }

                    .leave-ring-header {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        margin-bottom: 16px;
                        text-align: left;
                    }

                    .leave-ring-icon {
                        width: 36px;
                        height: 36px;
                        border-radius: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;
                        font-size: 1rem;
                        flex-shrink: 0;
                        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.18);
                    }

                    .leave-ring-title {
                        font-weight: 800;
                        font-size: 0.95rem;
                        color: #1a2332;
                        line-height: 1.2;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }

                    .leave-ring-svg-wrap {
                        position: relative;
                        width: 108px;
                        height: 108px;
                        margin: 0 auto 16px;
                    }

                    .leave-ring-svg-wrap svg {
                        transform: rotate(-90deg);
                    }

                    .leave-ring-track {
                        fill: none;
                        stroke: #eef0f4;
                        stroke-width: 8;
                    }

                    .leave-ring-progress {
                        fill: none;
                        stroke-width: 8;
                        stroke-linecap: round;
                        transition: stroke-dashoffset 1.2s cubic-bezier(0.22, 1, 0.36, 1);
                    }

                    .leave-ring-center {
                        position: absolute;
                        inset: 0;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                    }

                    .leave-ring-num {
                        font-size: 1.6rem;
                        font-weight: 800;
                        color: #1a2332;
                        line-height: 1;
                    }

                    .leave-ring-sub {
                        font-size: 0.62rem;
                        color: #8892a0;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.04em;
                        margin-top: 3px;
                    }

                    .leave-usage-bar-bg {
                        height: 6px;
                        border-radius: 6px;
                        background: #eef0f4;
                        overflow: hidden;
                        margin-bottom: 14px;
                    }

                    .leave-usage-bar-fill {
                        height: 100%;
                        border-radius: 6px;
                        transition: width 1s cubic-bezier(0.22, 1, 0.36, 1);
                    }

                    .leave-ring-footer {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 5px;
                        font-size: 0.8rem;
                        color: #8892a0;
                        font-weight: 600;
                    }

                    .leave-ring-footer b {
                        color: #1a2332;
                        font-weight: 800;
                    }

                    .leave-ring-divider {
                        color: #d7dde5;
                    }

                    /* leave summary ends here */

                    * {
                        font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                    }

                    body {
                        background: #f0f2f6;
                        min-height: 100vh;
                    }

                    .fade-in {
                        animation: fadeIn 0.4s ease-in;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(8px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .page-wrap {
                        max-width: 1100px;
                    }

                    .page-title {
                        font-size: 1.65rem;
                        font-weight: 800;
                        color: #1a2332;
                        letter-spacing: -0.02em;
                    }

                    .page-subtitle {
                        color: #8892a0;
                        font-size: 0.9rem;
                    }

                    .card {
                        border: none;
                        border-radius: 16px;
                        overflow: hidden;
                    }

                    .card.shadow {
                        box-shadow: 0 10px 40px rgba(20, 30, 60, 0.08) !important;
                    }

                    .card-header-custom {
                        background: linear-gradient(135deg, #1a2332 0%, #2c3a52 100%);
                        color: #fff;
                        padding: 20px 28px;
                        border: none;
                    }

                    .section-header {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .section-header-title {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        font-weight: 700;
                    }

                    .section-header-title i {
                        font-size: 1.1rem;
                        opacity: 0.9;
                    }

                    .section-count-badge {
                        background: rgba(255, 255, 255, 0.15);
                        padding: 4px 12px;
                        border-radius: 20px;
                        font-size: 0.75rem;
                        font-weight: 600;
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
                        width: 110px;
                        height: 110px;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.12);
                        top: -40px;
                        right: -30px;
                    }

                    .stat-card::after {
                        content: '';
                        position: absolute;
                        width: 60px;
                        height: 60px;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.08);
                        bottom: -25px;
                        right: 30px;
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

                    .stat-card:hover.purple {
                        box-shadow: 0 18px 36px rgba(124, 92, 255, 0.45);
                    }

                    .stat-card:hover.green {
                        box-shadow: 0 18px 36px rgba(22, 163, 74, 0.4);
                    }

                    .stat-card:hover.red {
                        box-shadow: 0 18px 36px rgba(214, 51, 108, 0.4);
                    }

                    .stat-card:hover.blue {
                        box-shadow: 0 18px 36px rgba(37, 99, 235, 0.4);
                    }

                    .stat-icon {
                        position: relative;
                        z-index: 2;
                        width: 52px;
                        height: 52px;
                        border-radius: 14px;
                        background: rgba(255, 255, 255, 0.2);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.35rem;
                        flex-shrink: 0;
                        backdrop-filter: blur(4px);
                    }

                    .stat-value {
                        position: relative;
                        z-index: 2;
                        font-size: 1.7rem;
                        font-weight: 800;
                        color: #fff;
                        line-height: 1.1;
                    }

                    .stat-label {
                        position: relative;
                        z-index: 2;
                        color: rgba(255, 255, 255, 0.85);
                        font-size: 0.8rem;
                        font-weight: 600;
                        margin-top: 3px;
                    }

                    /* ---- Recent employees list ---- */
                    .recent-item {
                        display: flex;
                        align-items: center;
                        gap: 14px;
                        padding: 14px 12px;
                        border-radius: 12px;
                        transition: background-color 0.15s ease, transform 0.15s ease;
                    }

                    .recent-item:hover {
                        background-color: #f8f7ff;
                        transform: translateX(2px);
                    }

                    .recent-item:not(:last-child) {
                        margin-bottom: 4px;
                    }

                    .avatar-circle {
                        width: 44px;
                        height: 44px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, #7c5cff, #6a4ce0);
                        color: #fff;
                        font-weight: 700;
                        font-size: 0.85rem;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        flex-shrink: 0;
                        box-shadow: 0 4px 10px rgba(124, 92, 255, 0.3);
                        border: 2px solid #fff;
                    }

                    .recent-rank {
                        width: 22px;
                        height: 22px;
                        border-radius: 6px;
                        background: #eef0f4;
                        color: #a3abba;
                        font-size: 0.7rem;
                        font-weight: 800;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        flex-shrink: 0;
                    }

                    .recent-name {
                        font-weight: 700;
                        color: #1a2332;
                        font-size: 0.92rem;
                    }

                    .recent-meta {
                        color: #8892a0;
                        font-size: 0.78rem;
                        display: flex;
                        align-items: center;
                        gap: 5px;
                        margin-top: 2px;
                    }

                    .recent-meta .dept-chip {
                        background: #eef3ff;
                        color: #3366ff;
                        padding: 2px 9px;
                        border-radius: 20px;
                        font-weight: 600;
                        font-size: 0.72rem;
                    }

                    .empty-state {
                        text-align: center;
                        color: #adb5bd;
                        padding: 40px 10px;
                        font-size: 0.9rem;
                    }

                    .empty-state i {
                        font-size: 1.8rem;
                        display: block;
                        margin-bottom: 10px;
                        color: #d7dbe4;
                    }

                    .chart-wrap {
                        position: relative;
                        height: 260px;
                        background: #fafbfc;
                        border-radius: 14px;
                        padding: 18px 14px 6px 6px;
                    }


                    /* ---- Org Chart (appended, new section) ---- */
                    .tree {
                        padding: 20px 0;
                        overflow-x: auto;
                    }

                    .tree ul {
                        padding-top: 30px;
                        position: relative;
                        display: flex;
                        justify-content: center;
                    }

                    .tree li {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        list-style-type: none;
                        position: relative;
                        padding: 30px 12px 0 12px;
                    }

                    .tree li::before,
                    .tree li::after {
                        content: '';
                        position: absolute;
                        top: 0;
                        right: 50%;
                        border-top: 2px solid #d7dde5;
                        width: 50%;
                        height: 30px;
                    }

                    .tree li::after {
                        right: auto;
                        left: 50%;
                        border-left: 2px solid #d7dde5;
                    }

                    .tree li:only-child::after,
                    .tree li:only-child::before {
                        display: none;
                    }

                    .tree li:only-child {
                        padding-top: 0;
                    }

                    .tree li:first-child::before,
                    .tree li:last-child::after {
                        border: 0 none;
                    }

                    .tree li:last-child::before {
                        border-right: 2px solid #d7dde5;
                        border-radius: 0 6px 0 0;
                    }

                    .tree li:first-child::after {
                        border-radius: 6px 0 0 0;
                    }

                    .tree ul ul::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 50%;
                        border-left: 2px solid #d7dde5;
                        width: 0;
                        height: 30px;
                    }

                    .org-card {
                        display: inline-flex;
                        flex-direction: column;
                        align-items: center;
                        border-radius: 12px;
                        padding: 14px 18px;
                        min-width: 165px;
                        box-shadow: 0 4px 14px rgba(20, 30, 60, 0.1);
                        transition: transform 0.15s ease;
                    }

                    .org-card:hover {
                        transform: translateY(-3px);
                    }


                    .org-avatar-photo-wrap {
                        margin-bottom: 8px;
                        position: relative;
                    }

                    .org-avatar-photo {
                        width: 46px;
                        height: 46px;
                        border-radius: 50%;
                        object-fit: cover;
                        border: 2px solid rgba(255, 255, 255, 0.5);
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                    }

                    .org-avatar {
                        width: 46px;
                        height: 46px;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.25);
                        color: #fff;
                        font-weight: 800;
                        font-size: 0.85rem;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        border: 2px solid rgba(255, 255, 255, 0.5);
                    }

                    .org-person {
                        color: #fff;
                        font-weight: 700;
                        font-size: 0.88rem;
                        text-align: center;
                    }

                    .org-title {
                        color: rgba(255, 255, 255, 0.85);
                        font-size: 0.75rem;
                        margin-top: 2px;
                        text-align: center;
                    }

                    .org-vacant {
                        font-style: italic;
                        opacity: 0.75;
                    }

                    .org-root {
                        background: linear-gradient(135deg, #16a34a, #15803d);
                    }

                    .org-manager {
                        background: linear-gradient(135deg, #2563eb, #1d4ed8);
                    }

                    .org-staff {
                        background: linear-gradient(135deg, #7c5cff, #6a4ce0);
                    }

                    .org-intern {
                        background: linear-gradient(135deg, #e0448a, #c22e73);
                    }



                    .legend-dot {
                        display: inline-block;
                        width: 10px;
                        height: 10px;
                        border-radius: 50%;
                        margin-right: 5px;
                    }


                    /* toggle icons in the chart tree*/
                    .tree ul.org-children-hidden {
                        display: none !important;
                    }

                    .tree ul.org-children-visible {
                        display: flex !important;
                    }

                    .org-toggle-icon {
                        margin-top: 8px;
                        color: rgba(255, 255, 255, 0.85);
                        font-size: 0.9rem;
                        transition: transform 0.2s ease;
                    }

                    .org-toggle-icon.rotated {
                        transform: rotate(180deg);
                    }

                    .org-card {
                        position: relative;
                    }

                    .org-card:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 8px 22px rgba(20, 30, 60, 0.18);
                    }



                    /* ---- Attendance Chart (new section) ---- */
                    .attendance-stats-row {
                        display: flex;
                        gap: 10px;
                        flex-wrap: wrap;
                    }

                    .attendance-stat-chip {
                        display: flex;
                        align-items: center;
                        gap: 7px;
                        padding: 6px 14px;
                        border-radius: 20px;
                        font-size: 0.78rem;
                        font-weight: 700;
                    }

                    .attendance-stat-chip .dot {
                        width: 8px;
                        height: 8px;
                        border-radius: 50%;
                    }

                    .chip-intime {
                        background: #ecfdf3;
                        color: #16a34a;
                    }

                    .chip-intime .dot {
                        background: #16a34a;
                    }

                    .chip-late {
                        background: #fffbeb;
                        color: #b45309;
                    }

                    .chip-late .dot {
                        background: #f59e0b;
                    }

                    .chip-notarrived {
                        background: #f1f5f9;
                        color: #64748b;
                    }

                    .chip-notarrived .dot {
                        background: #94a3b8;
                    }

                    /* attendance chart ends here*/

                    /* team attendance starts here*/

                    /* ---- Team Attendance (new section) ---- */
                    .team-member-row {
                        display: flex;
                        align-items: center;
                        gap: 16px;
                        padding: 16px 4px;
                        border-bottom: 1px solid #f0f2f6;
                    }

                    .team-member-row:last-child {
                        border-bottom: none;
                    }

                    .team-avatar-wrap {
                        flex-shrink: 0;
                    }

                    .team-avatar-photo {
                        width: 48px;
                        height: 48px;
                        border-radius: 50%;
                        object-fit: cover;
                        border: 2px solid #eef0f4;
                    }

                    .team-avatar-fallback {
                        width: 48px;
                        height: 48px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, #7c5cff, #6a4ce0);
                        color: #fff;
                        font-weight: 700;
                        font-size: 0.85rem;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                    }

                    .team-member-info {
                        flex: 1;
                        min-width: 160px;
                    }

                    .team-member-name {
                        font-weight: 700;
                        color: #1a2332;
                        font-size: 0.93rem;
                    }

                    .team-member-times {
                        display: flex;
                        gap: 14px;
                        margin-top: 4px;
                        font-size: 0.76rem;
                        color: #8892a0;
                    }

                    .team-member-times span {
                        display: flex;
                        align-items: center;
                        gap: 4px;
                    }

                    .team-member-times i {
                        font-size: 0.85rem;
                    }

                    .team-rate-wrap {
                        width: 160px;
                        flex-shrink: 0;
                    }

                    .team-rate-bar-bg {
                        height: 8px;
                        border-radius: 6px;
                        background: #eef0f4;
                        overflow: hidden;
                        margin-bottom: 4px;
                    }

                    .team-rate-bar-fill {
                        height: 100%;
                        border-radius: 6px;
                        background: linear-gradient(90deg, #16a34a, #22c55e);
                    }

                    .team-rate-label {
                        font-size: 0.72rem;
                        font-weight: 700;
                        color: #16a34a;
                        text-align: right;
                    }

                    .team-status-pills {
                        display: flex;
                        gap: 6px;
                        flex-shrink: 0;
                    }

                    .status-pill {
                        font-size: 0.7rem;
                        font-weight: 700;
                        padding: 3px 9px;
                        border-radius: 20px;
                    }

                    .pill-intime {
                        background: #ecfdf3;
                        color: #16a34a;
                    }

                    .pill-late {
                        background: #fffbeb;
                        color: #b45309;
                    }

                    .pill-absent {
                        background: #f1f5f9;
                        color: #64748b;
                    }

                    @media (max-width: 767px) {
                        .team-member-row {
                            flex-wrap: wrap;
                        }

                        .team-rate-wrap {
                            width: 100%;
                            order: 3;
                        }
                    }


                    /* ---- Last 7 Days Overview (redesign): a colorful, tinted KPI tile grid so
           each metric reads instantly by color, with a trend badge and its own
           sparkline per tile. ---- */
                    .l7-period-badge {
                        display: inline-flex;
                        align-items: center;
                        gap: 7px;
                        background: linear-gradient(135deg, #eef1f8, #e4e9f5);
                        color: #4a5568;
                        font-size: 0.73rem;
                        font-weight: 700;
                        padding: 6px 14px;
                        border-radius: 20px;
                        margin-bottom: 4px;
                        border: 1px solid #e2e7f0;
                    }

                    .l7-period-badge i {
                        color: #7c5cff;
                    }

                    .l7-subtitle {
                        font-size: 0.78rem;
                        color: #8892a0;
                        font-weight: 500;
                        margin: 0 0 6px;
                    }

                    @keyframes l7RiseIn {
                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .l7v2-card {
                        position: relative;
                        overflow: hidden;
                    }

                    .l7v2-card::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 3px;
                        background: linear-gradient(90deg, #4f8cf7, #9b7bff, #34d399, #f472b6, #4f8cf7);
                        background-size: 300% 100%;
                        animation: tgcGradientShift 7s ease infinite;
                        z-index: 2;
                    }

                    /* One joined panel instead of four separate cards: a 1px gap filled by the
           panel's own background draws a hairline divider between cells, so the
           sections read as distinct without each needing its own border/shadow. */
                    .l7v2-tiles {
                        display: grid;
                        grid-template-columns: repeat(2, minmax(0, 1fr));
                        gap: 1px;
                        margin: 12px 0 4px;
                        border-radius: 14px;
                        overflow: hidden;
                        background: #e8ecf3;
                        border: 1px solid #e8ecf3;
                        box-shadow: 0 6px 20px rgba(20, 30, 60, 0.06);
                    }

                    .l7v2-tile {
                        position: relative;
                        padding: 16px 16px 12px 18px;
                        background-color: #fff;
                        overflow: hidden;
                        opacity: 0;
                        transform: translateY(8px);
                        animation: l7RiseIn 0.45s ease forwards;
                        transition: box-shadow 0.2s ease;
                    }

                    .l7v2-tile::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        bottom: 0;
                        width: 4px;
                        z-index: 1;
                    }

                    .l7v2-tile::after {
                        content: '';
                        position: absolute;
                        width: 100px;
                        height: 100px;
                        border-radius: 50%;
                        top: -50px;
                        right: -35px;
                        pointer-events: none;
                        transition: transform 0.35s ease;
                    }

                    .l7v2-tile:hover {
                        box-shadow: inset 0 0 0 9999px rgba(20, 30, 60, 0.025);
                    }

                    .l7v2-tile:hover::after {
                        transform: scale(1.15);
                    }

                    /* children painted above the decorative ::after blob */
                    .l7v2-tile-top,
                    .l7v2-value,
                    .l7v2-label,
                    .l7v2-spark {
                        position: relative;
                        z-index: 2;
                    }

                    .l7v2-tile[data-accent="checkin"] {
                        background-image: linear-gradient(160deg, rgba(79, 140, 247, 0.09), rgba(79, 140, 247, 0.02) 60%);
                    }

                    .l7v2-tile[data-accent="checkout"] {
                        background-image: linear-gradient(160deg, rgba(155, 123, 255, 0.09), rgba(155, 123, 255, 0.02) 60%);
                    }

                    .l7v2-tile[data-accent="hours"] {
                        background-image: linear-gradient(160deg, rgba(52, 211, 153, 0.1), rgba(52, 211, 153, 0.02) 60%);
                    }

                    .l7v2-tile[data-accent="absent"] {
                        background-image: linear-gradient(160deg, rgba(244, 114, 182, 0.09), rgba(244, 114, 182, 0.02) 60%);
                    }

                    .l7v2-tile[data-accent="checkin"]::before {
                        background: linear-gradient(180deg, #4f8cf7, #2955c9);
                    }

                    .l7v2-tile[data-accent="checkout"]::before {
                        background: linear-gradient(180deg, #9b7bff, #6a4ce0);
                    }

                    .l7v2-tile[data-accent="hours"]::before {
                        background: linear-gradient(180deg, #34d399, #16a34a);
                    }

                    .l7v2-tile[data-accent="absent"]::before {
                        background: linear-gradient(180deg, #f472b6, #d63384);
                    }

                    .l7v2-tile[data-accent="checkin"]::after {
                        background: radial-gradient(circle, rgba(79, 140, 247, 0.3), transparent 70%);
                    }

                    .l7v2-tile[data-accent="checkout"]::after {
                        background: radial-gradient(circle, rgba(155, 123, 255, 0.3), transparent 70%);
                    }

                    .l7v2-tile[data-accent="hours"]::after {
                        background: radial-gradient(circle, rgba(52, 211, 153, 0.3), transparent 70%);
                    }

                    .l7v2-tile[data-accent="absent"]::after {
                        background: radial-gradient(circle, rgba(244, 114, 182, 0.3), transparent 70%);
                    }

                    .l7v2-tile-top {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        margin-bottom: 12px;
                    }

                    .l7v2-icon {
                        width: 36px;
                        height: 36px;
                        border-radius: 11px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 0.95rem;
                        color: #fff;
                        flex-shrink: 0;
                        box-shadow: 0 5px 12px rgba(20, 30, 60, 0.18);
                        transition: transform 0.25s ease;
                    }

                    .l7v2-tile:hover .l7v2-icon {
                        transform: scale(1.1) rotate(-4deg);
                    }

                    .l7v2-tile[data-accent="checkin"] .l7v2-icon {
                        background: linear-gradient(135deg, #4f8cf7, #2955c9);
                    }

                    .l7v2-tile[data-accent="checkout"] .l7v2-icon {
                        background: linear-gradient(135deg, #9b7bff, #6a4ce0);
                    }

                    .l7v2-tile[data-accent="hours"] .l7v2-icon {
                        background: linear-gradient(135deg, #34d399, #16a34a);
                    }

                    .l7v2-tile[data-accent="absent"] .l7v2-icon {
                        background: linear-gradient(135deg, #f472b6, #d63384);
                    }

                    .l7v2-trend {
                        display: inline-flex;
                        align-items: center;
                        gap: 2px;
                        font-size: 0.63rem;
                        font-weight: 800;
                        padding: 3px 9px;
                        border-radius: 20px;
                        color: #8892a0;
                        background: #fff;
                        border: 1px solid #eef0f4;
                    }

                    .l7v2-trend i {
                        font-size: 0.75rem;
                    }

                    .l7v2-trend.tone-good {
                        color: #16a34a;
                        background: #e8f9ef;
                        border-color: #cdeedd;
                    }

                    .l7v2-trend.tone-bad {
                        color: #dc2626;
                        background: #fdecec;
                        border-color: #f7d3d3;
                    }

                    .l7v2-value {
                        font-size: 1.4rem;
                        font-weight: 800;
                        color: #1a2332;
                        line-height: 1.15;
                        letter-spacing: -0.01em;
                        white-space: nowrap;
                    }

                    .l7v2-label {
                        font-size: 0.66rem;
                        color: #8892a0;
                        font-weight: 700;
                        margin-top: 3px;
                        text-transform: uppercase;
                        letter-spacing: 0.04em;
                    }

                    .l7v2-spark {
                        width: 100%;
                        height: 40px;
                        margin-top: 10px;
                    }

                    .l7v2-spark canvas {
                        display: block;
                        width: 100% !important;
                        height: 100% !important;
                    }

                    @media (max-width: 420px) {
                        .l7v2-tiles {
                            grid-template-columns: minmax(0, 1fr);
                        }
                    }

                    /* ---- Reporting Line Card (MD4, static front-end) ---- */
                    .rl-card {
                        position: relative;
                        overflow: hidden;
                        opacity: 0;
                        transform: translateY(10px);
                        animation: l7RiseIn 0.5s ease forwards;
                        transition: transform 0.28s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.28s ease;
                    }

                    .rl-card:hover {
                        transform: translateY(-6px);
                        box-shadow: 0 18px 36px rgba(20, 30, 60, 0.16) !important;
                    }

                    .rl-header {
                        background: linear-gradient(135deg, #5687d6 0%, #2f4f8f 55%, #253f77 100%);
                        color: #fff;
                        padding: 18px 28px;
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        font-weight: 700;
                        position: relative;
                        overflow: hidden;
                    }

                    .rl-header::before {
                        content: '';
                        position: absolute;
                        width: 150px;
                        height: 150px;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.08);
                        top: -65px;
                        right: -25px;
                    }

                    .rl-header>* {
                        position: relative;
                        z-index: 2;
                    }

                    .rl-header-icon {
                        width: 34px;
                        height: 34px;
                        border-radius: 10px;
                        background: rgba(255, 255, 255, 0.18);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1rem;
                        flex-shrink: 0;
                    }

                    .rl-body {
                        padding: 22px 24px 18px;
                    }

                    .rl-tree {
                        position: relative;
                        padding-left: 26px;
                    }

                    .rl-tree::before {
                        content: '';
                        position: absolute;
                        left: 9px;
                        top: 10px;
                        bottom: 14px;
                        width: 2px;
                        background: linear-gradient(180deg, #c3d3f0 0%, #dde6f7 60%, #eef2fa 100%);
                        border-radius: 2px;
                    }

                    .rl-node {
                        position: relative;
                    }

                    .rl-node::before {
                        content: '';
                        position: absolute;
                        left: -17px;
                        top: 50%;
                        width: 15px;
                        height: 2px;
                        background: #c3d3f0;
                        transform: translateY(-1px);
                    }

                    .rl-node::after {
                        content: '';
                        position: absolute;
                        left: -21px;
                        top: 50%;
                        width: 8px;
                        height: 8px;
                        border-radius: 50%;
                        background: #fff;
                        border: 2px solid #8fa8de;
                        transform: translate(-1px, -50%);
                        z-index: 2;
                    }

                    .rl-label {
                        display: inline-flex;
                        align-items: center;
                        font-size: 0.7rem;
                        font-weight: 800;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        color: #4b5b7d;
                        background: #eef2fa;
                        padding: 6px 12px;
                        border-radius: 8px;
                        margin: 0 0 12px;
                    }

                    .rl-label-flex {
                        display: flex;
                        width: 100%;
                        align-items: center;
                        justify-content: space-between;
                        gap: 8px;
                    }

                    .rl-tree .rl-label:not(:first-child) {
                        margin-top: 20px;
                    }

                    .rl-indirect-note {
                        font-weight: 500;
                        text-transform: none;
                        letter-spacing: normal;
                        color: #9aa6bd;
                        font-size: 0.66rem;
                        margin-left: 4px;
                    }

                    .rl-count-badge {
                        background: linear-gradient(135deg, #4b74c9, #2f4f8f);
                        color: #fff;
                        border-radius: 20px;
                        padding: 2px 11px;
                        font-size: 0.7rem;
                        font-weight: 800;
                        box-shadow: 0 3px 8px rgba(47, 79, 143, 0.3);
                    }

                    .rl-card-row {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        background: #f5f8fd;
                        border: 1px solid #eef2fa;
                        border-left: 3px solid #c3d3f0;
                        border-radius: 12px;
                        padding: 11px 14px;
                        margin-bottom: 10px;
                        box-shadow: 0 2px 6px rgba(20, 30, 60, 0.03);
                        transition: background 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
                    }

                    .rl-card-row:hover {
                        background: #eef3fb;
                        transform: translateX(3px);
                        box-shadow: 0 6px 14px rgba(47, 79, 143, 0.1);
                    }

                    .rl-manager-row {
                        border-left-color: #4b74c9;
                    }

                    .rl-reportee-row:last-child {
                        margin-bottom: 2px;
                    }

                    .rl-avatar {
                        width: 34px;
                        height: 34px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;
                        font-weight: 800;
                        font-size: 0.78rem;
                        flex-shrink: 0;
                        background: #7c8aa8;
                        box-shadow: 0 3px 8px rgba(20, 30, 60, 0.15);
                    }

                    .rl-avatar-manager {
                        width: 38px;
                        height: 38px;
                        background: linear-gradient(135deg, #4b74c9, #2f4f8f);
                        font-size: 1rem;
                    }

                    /* cycle avatar + accent colors for unlimited reportees */
                    .rl-reportee-row:nth-of-type(4n+1) {
                        border-left-color: #4f79d1;
                    }

                    .rl-reportee-row:nth-of-type(4n+1) .rl-avatar {
                        background: linear-gradient(135deg, #4f79d1, #33509b);
                    }

                    .rl-reportee-row:nth-of-type(4n+2) {
                        border-left-color: #ff9f57;
                    }

                    .rl-reportee-row:nth-of-type(4n+2) .rl-avatar {
                        background: linear-gradient(135deg, #ff9f57, #f0752a);
                    }

                    .rl-reportee-row:nth-of-type(4n+3) {
                        border-left-color: #4fc98a;
                    }

                    .rl-reportee-row:nth-of-type(4n+3) .rl-avatar {
                        background: linear-gradient(135deg, #4fc98a, #2ba268);
                    }

                    .rl-reportee-row:nth-of-type(4n+4) {
                        border-left-color: #f0616e;
                    }

                    .rl-reportee-row:nth-of-type(4n+4) .rl-avatar {
                        background: linear-gradient(135deg, #f0616e, #d63c4a);
                    }

                    .rl-name {
                        font-weight: 700;
                        color: #1a2332;
                        font-size: 0.88rem;
                    }

                    .rl-manager-sub {
                        font-size: 0.72rem;
                        color: #8892a0;
                        font-weight: 500;
                        margin-top: 1px;
                    }

                    .rl-indirect-star {
                        color: #c9a227;
                        font-weight: 800;
                    }

                    .rl-you-badge {
                        display: flex;
                        width: fit-content;
                        align-items: center;
                        gap: 6px;
                        background: linear-gradient(135deg, #1a2332, #2c3a52);
                        color: #fff;
                        font-weight: 700;
                        font-size: 0.75rem;
                        letter-spacing: 0.03em;
                        padding: 7px 18px;
                        border-radius: 20px;
                        margin: 0 0 10px;
                        box-shadow: 0 4px 10px rgba(26, 35, 50, 0.25);
                    }

                    .rl-reportees-wrap {
                        position: relative;
                    }

                    .rl-reportees-list {
                        max-height: 224px;
                        overflow-y: auto;
                        padding-right: 10px;
                        margin-right: -10px;
                        scrollbar-width: thin;
                        scrollbar-color: #90a8dd #e4eaf6;
                    }

                    .rl-reportees-list::-webkit-scrollbar {
                        width: 10px;
                    }

                    .rl-reportees-list::-webkit-scrollbar-track {
                        background: #e4eaf6;
                        border-radius: 8px;
                    }

                    .rl-reportees-list::-webkit-scrollbar-thumb {
                        background: linear-gradient(180deg, #90a8dd, #6685c9);
                        border-radius: 8px;
                        border: 2px solid #e4eaf6;
                    }

                    .rl-reportees-list::-webkit-scrollbar-thumb:hover {
                        background: linear-gradient(180deg, #7691cf, #4f6cb3);
                    }

                    .rl-scroll-fade {
                        position: absolute;
                        left: 0;
                        right: 10px;
                        bottom: 0;
                        height: 26px;
                        background: linear-gradient(180deg, rgba(255, 255, 255, 0), #ffffff 85%);
                        pointer-events: none;
                    }

                    .rl-scroll-hint {
                        text-align: center;
                        font-size: 0.72rem;
                        color: #6685c9;
                        font-weight: 700;
                        margin-top: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 4px;
                        animation: rlBounce 1.6s ease-in-out infinite;
                    }

                    @keyframes rlBounce {

                        0%,
                        100% {
                            transform: translateY(0);
                            opacity: 0.75;
                        }

                        50% {
                            transform: translateY(3px);
                            opacity: 1;
                        }
                    }

                    /* reporting line card ends here */

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
                        box-shadow: 0 18px 36px rgba(20, 30, 60, 0.16) !important;
                    }

                    .tgc-card::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 4px;
                        background: linear-gradient(90deg, #4f8cf7, #7c5cff, #34d399, #4f8cf7);
                        background-size: 300% 100%;
                        animation: tgcGradientShift 6s ease infinite;
                        z-index: 3;
                    }

                    @keyframes tgcGradientShift {
                        0% {
                            background-position: 0% 50%;
                        }

                        50% {
                            background-position: 100% 50%;
                        }

                        100% {
                            background-position: 0% 50%;
                        }
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
                        box-shadow: 0 6px 14px rgba(22, 163, 74, 0.18);
                    }

                    .tgc-growth-chip.negative {
                        background: linear-gradient(135deg, #fdecec, #fbe0e0);
                        color: #dc2626;
                        border-color: #f7d3d3;
                    }

                    .tgc-growth-chip.negative:hover {
                        box-shadow: 0 6px 14px rgba(220, 38, 38, 0.18);
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
                        display: flex;
                        align-items: baseline;
                        gap: 8px;
                        margin-bottom: 22px;
                    }

                    .status-count-hero .big-num {
                        font-size: 2.4rem;
                        font-weight: 800;
                        color: #1a2332;
                        line-height: 1;
                    }

                    .status-count-hero .big-label {
                        color: #8892a0;
                        font-size: 0.85rem;
                        font-weight: 600;
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

                    .candle-segment:hover {
                        filter: brightness(1.1);
                    }

                    .seg-ontime {
                        background: linear-gradient(180deg, #4ade80, #16a34a);
                    }

                    .seg-late {
                        background: linear-gradient(180deg, #fbbf24, #d97706);
                    }

                    .seg-absent {
                        background: linear-gradient(180deg, #f87171, #dc2626);
                    }

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
                        box-shadow: 0 10px 24px rgba(0, 0, 0, 0.25);
                        opacity: 0;
                        pointer-events: none;
                        transition: opacity 0.18s ease, transform 0.18s ease;
                        z-index: 10;
                    }

                    .candle-tooltip::after {
                        content: '';
                        position: absolute;
                        top: 100%;
                        left: 50%;
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
                        width: 10px;
                        height: 10px;
                        border-radius: 50%;
                        display: inline-block;
                        margin-right: 5px;
                    }

                    .dot-ontime {
                        background: #16a34a;
                    }

                    .dot-late {
                        background: #d97706;
                    }

                    .dot-absent {
                        background: #dc2626;
                    }

                    .candle-legend-item .legend-count {
                        font-size: 1.1rem;
                        font-weight: 800;
                        color: #1a2332;
                        display: block;
                        margin-top: 4px;
                    }

                    .candle-legend-item .legend-text {
                        font-size: 0.74rem;
                        color: #8892a0;
                        font-weight: 600;
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

                    /* ---- Yearly Leave Calendar Card (static preview) ---- */

                    /* ---- Yearly Leave Calendar Card (premium v2) ---- */
                    .leavecal-card {
                        position: relative;
                        overflow: hidden;
                        opacity: 0;
                        transform: translateY(10px);
                        animation: l7RiseIn 0.5s ease forwards;
                        transition: transform 0.3s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.3s ease;
                    }

                    .leavecal-card:hover {
                        transform: translateY(-6px);
                        box-shadow: 0 24px 48px rgba(20, 30, 60, 0.16) !important;
                    }

                    .leavecal-header {
                        background: linear-gradient(120deg, #0d9488 0%, #0891b2 50%, #075985 100%);
                        color: #fff;
                        padding: 22px 32px;
                        position: relative;
                        overflow: hidden;
                    }

                    .leavecal-header::before {
                        content: '';
                        position: absolute;
                        width: 200px;
                        height: 200px;
                        border-radius: 50%;
                        background: radial-gradient(circle, rgba(255, 255, 255, 0.14), transparent 70%);
                        top: -90px;
                        right: -20px;
                    }

                    .leavecal-header .section-header-title,
                    .leavecal-header .section-count-badge {
                        position: relative;
                        z-index: 2;
                    }

                    .leavecal-header .section-header-title {
                        font-size: 1.05rem;
                        letter-spacing: -0.01em;
                    }

                    .leavecal-header .section-count-badge {
                        background: rgba(255, 255, 255, 0.18);
                        border: 1px solid rgba(255, 255, 255, 0.28);
                        backdrop-filter: blur(8px);
                        font-weight: 700;
                    }

                    .leavecal-body {
                        padding: 26px 30px 28px;
                        background: #fff;
                    }

                    /* ---- Toolbar ---- */
                    .leavecal-toolbar {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        flex-wrap: wrap;
                        gap: 18px;
                        margin-bottom: 24px;
                        padding-bottom: 20px;
                        border-bottom: 1px solid #f0f2f6;
                    }

                    .leavecal-filters {
                        display: flex;
                        align-items: flex-end;
                        gap: 22px;
                    }

                    .leavecal-filter-group {
                        display: flex;
                        flex-direction: column;
                        gap: 6px;
                    }

                    .leavecal-filter-label {
                        font-size: 0.62rem;
                        font-weight: 800;
                        color: #9aa5b8;
                        text-transform: uppercase;
                        letter-spacing: 0.09em;
                    }

                    .leavecal-filter-select {
                        border: 1.5px solid #e7ebf2;
                        border-radius: 12px;
                        padding: 9px 34px 9px 15px;
                        font-size: 0.85rem;
                        font-weight: 700;
                        color: #12213a;
                        background: #fbfcfe;
                        min-width: 116px;
                        transition: all 0.18s ease;
                    }

                    .leavecal-filter-select:hover {
                        border-color: #0891b2;
                        background: #fff;
                    }

                    .leavecal-filter-select:focus {
                        outline: none;
                        border-color: #0891b2;
                        background: #fff;
                        box-shadow: 0 0 0 4px rgba(8, 145, 178, 0.13);
                    }

                    .leavecal-legend-top {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 9px;
                    }

                    .leavecal-legend-item {
                        display: flex;
                        align-items: center;
                        gap: 7px;
                        font-size: 0.72rem;
                        font-weight: 700;
                        color: #4a5568;
                        background: #f8f9fc;
                        border: 1px solid transparent;
                        border-radius: 20px;
                        padding: 6px 13px 6px 9px;
                        transition: all 0.18s ease;
                    }

                    .leavecal-legend-item:hover {
                        background: #fff;
                        border-color: #e7ebf2;
                        transform: translateY(-2px);
                        box-shadow: 0 8px 16px rgba(20, 30, 60, 0.08);
                    }

                    .leavecal-legend-dot {
                        width: 12px;
                        height: 12px;
                        border-radius: 50%;
                        flex-shrink: 0;
                    }

                    .leavecal-legend-dot.lc-normal {
                        background: #fff;
                        border: 1.5px solid #d7dde5;
                    }

                    .leavecal-legend-dot.lc-weekend {
                        background: #d7dde5;
                    }

                    .leavecal-legend-dot.lc-ph {
                        background: linear-gradient(135deg, #4ade80, #16a34a);
                    }

                    .leavecal-legend-dot.lc-cl {
                        background: linear-gradient(135deg, #22d3ee, #0891b2);
                    }

                    .leavecal-legend-dot.lc-sl {
                        background: linear-gradient(135deg, #c084fc, #9333ea);
                    }

                    .leavecal-legend-dot.lc-al {
                        background: linear-gradient(135deg, #d4b96a, #b8973f);
                    }

                    /* ---- Grid shell ---- */
                    .leavecal-panes {
                        display: flex;
                        align-items: stretch;
                        border-radius: 16px;
                        border: 1px solid #eef1f6;
                        background: #fff;
                        overflow: hidden;
                    }

                    .leavecal-monthpane {
                        flex: 0 0 auto;
                        background: #fff;
                        box-shadow: 6px 0 16px -6px rgba(20, 30, 60, 0.1);
                        position: relative;
                        z-index: 2;
                        padding: 8px 4px 8px 8px;
                    }

                    .leavecal-scroll {
                        flex: 1 1 auto;
                        overflow-x: auto;
                        padding: 8px 8px 8px 0;
                        scrollbar-width: thin;
                        scrollbar-color: #5eead4 #f0f2f6;
                    }

                    .leavecal-scroll::-webkit-scrollbar {
                        height: 8px;
                    }

                    .leavecal-scroll::-webkit-scrollbar-track {
                        background: #f0f2f6;
                        border-radius: 8px;
                    }

                    .leavecal-scroll::-webkit-scrollbar-thumb {
                        background: linear-gradient(90deg, #5eead4, #0891b2);
                        border-radius: 8px;
                    }

                    .leavecal-table {
                        border-collapse: separate;
                        border-spacing: 0;
                    }

                    .leavecal-table th,
                    .leavecal-table td {
                        padding: 0;
                        box-sizing: border-box;
                        vertical-align: middle;
                    }

                    .leavecal-row {
                        height: 42px;
                    }

                    /* was 34px - more breathing room per row */

                    .leavecal-monthpane th,
                    .leavecal-monthpane td {
                        text-align: left;
                        padding: 0 20px 0 12px;
                        font-weight: 800;
                        color: #12213a;
                        font-size: 0.78rem;
                        white-space: nowrap;
                        border-radius: 8px;
                        transition: background-color 0.15s ease, color 0.15s ease;
                    }

                    .leavecal-monthpane thead th {
                        color: #a3abba;
                        font-weight: 800;
                        font-size: 0.6rem;
                        text-transform: uppercase;
                        letter-spacing: 0.08em;
                    }

                    .leavecal-monthpane tbody tr:hover td {
                        background: #ecfdf9;
                        color: #0891b2;
                    }

                    /* Day headers - clean, no boxed weekend look, just soft text tinting */
                    .leavecal-daytable thead th {
                        text-align: center;
                        min-width: 38px;
                        padding: 8px 0 !important;
                    }

                    .lc-daylabel {
                        font-size: 0.6rem;
                        font-weight: 800;
                        color: #a3abba;
                        text-transform: uppercase;
                        letter-spacing: 0.04em;
                    }

                    .leavecal-daytable thead th.lc-weekend-head .lc-daylabel {
                        color: #8892a0;
                    }

                    .leavecal-cell {
                        text-align: center;
                    }

                    .lc-blank {
                        background: transparent;
                    }

                    /* Weekend band: soft flat tint, no diagonal stripes - reads as clean, premium, not busy */
                    .leavecal-cell.lc-weekend-col {
                        background: #EDEBEB;
                    }

                    /* Circular date chips instead of rounded-square badges - more modern */
                    .leavecal-chip {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        width: 30px;
                        height: 30px;
                        margin: 0 auto;
                        border-radius: 50%;
                        font-weight: 700;
                        font-size: 0.72rem;
                        color: #7c879b;
                        cursor: default;
                        transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.2s ease;
                    }

                    .leavecal-chip:hover {
                        position: relative;
                        z-index: 3;
                        transform: scale(1.3);
                        box-shadow: 0 10px 20px rgba(20, 30, 60, 0.25);
                    }

                    .leavecal-chip.lc-normal {
                        background: transparent;
                        color: #47536b;
                    }

                    .leavecal-chip.lc-normal:hover {
                        background: #eef1f6;
                        box-shadow: none;
                    }

                    .leavecal-chip.lc-weekend {
                        background: transparent;
                        color: #a3abba;
                    }

                    .leavecal-chip.lc-weekend:hover {
                        background: #e7eaf0;
                        box-shadow: none;
                        transform: scale(1.15);
                    }

                    .leavecal-chip.lc-ph {
                        background: linear-gradient(135deg, #4ade80, #16a34a);
                        color: #fff;
                        box-shadow: 0 4px 10px rgba(22, 163, 74, 0.35);
                    }

                    .leavecal-chip.lc-cl {
                        background: linear-gradient(135deg, #22d3ee, #0891b2);
                        color: #fff;
                        box-shadow: 0 4px 10px rgba(8, 145, 178, 0.35);
                    }

                    .leavecal-chip.lc-sl {
                        background: linear-gradient(135deg, #c084fc, #9333ea);
                        color: #fff;
                        box-shadow: 0 4px 10px rgba(147, 51, 234, 0.35);
                    }

                    .leavecal-chip.lc-al {
                        background: linear-gradient(135deg, #d4b96a, #b8973f);
                        color: #fff;
                        box-shadow: 0 4px 10px rgba(184, 151, 63, 0.35);
                    }

                    .leavecal-scroll-hint {
                        text-align: center;
                        font-size: 0.74rem;
                        color: #0891b2;
                        font-weight: 700;
                        margin-top: 14px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 6px;
                    }

                    /* yearly leave calendar ends here */

                    /* yearly leave calendar ends here */

                    /* yearly leave calendar (original) ends here */

                    /* =====================================================
           LEAVE CALENDAR – CLEAN, CLIENT-FRIENDLY REDESIGN
           Designer notes:
           • Pastel tinted cells → instantly readable color language
           • White cards with subtle shadows → modern, airy feel
           • Indigo→blue header → professional, trustworthy
           • Larger day cells & readable font → easy for all users
           ===================================================== */

                    /* Entrance animations */
                    @keyframes lcpMonthIn {
                        from {
                            opacity: 0;
                            transform: translateY(10px) scale(0.97);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0) scale(1);
                        }
                    }

                    @keyframes lcpTodayPulse {
                        0% {
                            box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.5);
                        }

                        70% {
                            box-shadow: 0 0 0 5px rgba(99, 102, 241, 0);
                        }

                        100% {
                            box-shadow: 0 0 0 0 rgba(99, 102, 241, 0);
                        }
                    }

                    @keyframes lcpShimmer {
                        0% {
                            transform: translateX(-100%);
                        }

                        100% {
                            transform: translateX(220%);
                        }
                    }

                    /* ---- Card wrapper ---- */
                    .lcp-card {
                        opacity: 0;
                        transform: translateY(10px);
                        animation: l7RiseIn 0.5s ease forwards;
                        border-radius: 0 0 16px 16px;
                        overflow: hidden;
                    }

                    /* ---- Header: clean indigo → sky gradient ---- */
                    .lcp-header {
                        background: linear-gradient(135deg, #4f46e5 0%, #3b82f6 60%, #06b6d4 100%);
                        color: #fff;
                        padding: 20px 28px 18px;
                        position: relative;
                        overflow: hidden;
                    }

                    .lcp-header::before {
                        content: '';
                        position: absolute;
                        width: 220px;
                        height: 220px;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.08);
                        top: -80px;
                        right: -40px;
                        pointer-events: none;
                    }

                    .lcp-header::after {
                        content: '';
                        position: absolute;
                        width: 120px;
                        height: 120px;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.05);
                        bottom: -50px;
                        left: 12%;
                        pointer-events: none;
                    }

                    .lcp-header .section-header-title,
                    .lcp-header .section-count-badge {
                        position: relative;
                        z-index: 2;
                    }

                    .lcp-header .section-header-title {
                        font-size: 1.05rem;
                        letter-spacing: -0.01em;
                    }

                    .lcp-header .section-header-title i {
                        font-size: 1.1rem;
                    }

                    .lcp-badge {
                        background: rgba(255, 255, 255, 0.18);
                        border: 1px solid rgba(255, 255, 255, 0.3);
                        font-weight: 700;
                    }

                    .lcp-expand-btn {
                        position: relative;
                        z-index: 2;
                        width: 34px;
                        height: 34px;
                        border-radius: 10px;
                        border: 1.5px solid rgba(255, 255, 255, 0.3);
                        background: rgba(255, 255, 255, 0.15);
                        color: #fff;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 0.85rem;
                        cursor: pointer;
                        transition: all 0.22s ease;
                    }

                    .lcp-expand-btn:hover {
                        background: rgba(255, 255, 255, 0.28);
                        transform: scale(1.08);
                        box-shadow: 0 6px 14px rgba(0, 0, 0, 0.18);
                    }

                    /* ---- Body ---- */
                    .lcp-wrap {
                        padding: 20px 20px 16px;
                        background: #f7f8fc;
                    }

                    /* ---- Stat chips (4 per row) ---- */
                    .lcp-stats-row {
                        display: grid;
                        grid-template-columns: repeat(4, minmax(0, 1fr));
                        gap: 12px;
                        margin-bottom: 20px;
                    }

                    .lcp-stat {
                        position: relative;
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 14px 16px;
                        border-radius: 14px;
                        background: #fff;
                        border: 1.5px solid #e8ecf4;
                        overflow: hidden;
                        box-shadow: 0 2px 8px rgba(20, 30, 60, 0.05);
                        transition: transform 0.25s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.25s ease;
                    }

                    .lcp-stat:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 10px 24px rgba(20, 30, 60, 0.1);
                    }

                    .lcp-stat::after {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        width: 35%;
                        height: 100%;
                        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.7), transparent);
                        transform: translateX(-100%);
                        pointer-events: none;
                    }

                    .lcp-stat:hover::after {
                        animation: lcpShimmer 0.75s ease-out;
                    }

                    .lcp-stat-icon {
                        width: 40px;
                        height: 40px;
                        border-radius: 12px;
                        flex-shrink: 0;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;
                        font-size: 1rem;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.14);
                    }

                    .lcp-stat-ph .lcp-stat-icon {
                        background: linear-gradient(135deg, #22c55e, #15803d);
                    }

                    .lcp-stat-al .lcp-stat-icon {
                        background: linear-gradient(135deg, #f59e0b, #d97706);
                    }

                    .lcp-stat-sl .lcp-stat-icon {
                        background: linear-gradient(135deg, #a855f7, #7c3aed);
                    }

                    .lcp-stat-cl .lcp-stat-icon {
                        background: linear-gradient(135deg, #38bdf8, #0284c7);
                    }

                    .lcp-stat-num {
                        font-size: 1.45rem;
                        font-weight: 800;
                        color: #1a2332;
                        line-height: 1;
                    }

                    .lcp-stat-label {
                        font-size: 0.68rem;
                        color: #8892a0;
                        font-weight: 600;
                        margin-top: 3px;
                    }

                    /* ---- Year navigation ---- */
                    .lcp-toolbar {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 14px;
                        margin-bottom: 12px;
                    }

                    .lcp-nav-btn {
                        width: 34px;
                        height: 34px;
                        border-radius: 10px;
                        border: 1.5px solid #dde3f0;
                        background: #fff;
                        color: #4f46e5;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 0.82rem;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        box-shadow: 0 1px 4px rgba(20, 30, 60, 0.06);
                    }

                    .lcp-nav-btn:hover {
                        background: #4f46e5;
                        color: #fff;
                        border-color: #4f46e5;
                        transform: scale(1.08);
                        box-shadow: 0 6px 16px rgba(79, 70, 229, 0.3);
                    }

                    .lcp-nav-btn:disabled {
                        opacity: 0.3;
                        cursor: not-allowed;
                        transform: none;
                        box-shadow: none;
                    }

                    .lcp-year-label {
                        font-size: 1.3rem;
                        font-weight: 800;
                        color: #1a2332;
                        min-width: 80px;
                        text-align: center;
                        letter-spacing: -0.02em;
                    }

                    /* ---- Year pills ---- */
                    .lcp-year-pills {
                        display: flex;
                        justify-content: center;
                        gap: 8px;
                        flex-wrap: wrap;
                        margin-bottom: 16px;
                    }

                    .lcp-pill {
                        flex-shrink: 0;
                        border: 1.5px solid #dde3f0;
                        background: #fff;
                        color: #6b7280;
                        font-size: 0.78rem;
                        font-weight: 700;
                        padding: 5px 16px;
                        border-radius: 20px;
                        cursor: pointer;
                        transition: all 0.2s ease;
                    }

                    .lcp-pill:hover {
                        background: #eef2ff;
                        color: #4f46e5;
                        border-color: #a5b4fc;
                    }

                    .lcp-pill.active {
                        background: linear-gradient(135deg, #4f46e5, #3b82f6);
                        border-color: transparent;
                        color: #fff;
                        box-shadow: 0 6px 16px rgba(79, 70, 229, 0.3);
                    }

                    /* ---- Month filter tabs ---- */
                    .lcp-month-tabs {
                        display: flex;
                        justify-content: center;
                        flex-wrap: wrap;
                        gap: 4px;
                        margin-bottom: 16px;
                        padding: 5px;
                        background: #fff;
                        border-radius: 14px;
                        border: 1.5px solid #e8ecf4;
                        box-shadow: 0 2px 8px rgba(20, 30, 60, 0.05);
                    }

                    .lcp-month-tab {
                        border: none;
                        background: transparent;
                        color: #6b7280;
                        font-size: 0.72rem;
                        font-weight: 700;
                        padding: 6px 12px;
                        border-radius: 10px;
                        cursor: pointer;
                        transition: all 0.18s ease;
                        letter-spacing: 0.01em;
                    }

                    .lcp-month-tab:hover {
                        background: #eef2ff;
                        color: #4f46e5;
                    }

                    .lcp-month-tab.active {
                        background: linear-gradient(135deg, #4f46e5, #3b82f6);
                        color: #fff;
                        box-shadow: 0 3px 10px rgba(79, 70, 229, 0.25);
                    }

                    .lcp-month-tab .lcp-tab-dot {
                        display: inline-block;
                        width: 5px;
                        height: 5px;
                        border-radius: 50%;
                        margin-left: 4px;
                        vertical-align: middle;
                    }

                    /* ---- Year panels ---- */
                    .lcp-year-panel {
                        display: none;
                    }

                    .lcp-year-panel.active {
                        display: block;
                        animation: l7RiseIn 0.35s ease forwards;
                    }

                    .lcp-months-grid {
                        display: grid;
                        grid-template-columns: repeat(4, minmax(0, 1fr));
                        gap: 14px;
                    }

                    /* ---- Month cards ---- */
                    .lcp-month-card {
                        position: relative;
                        border: 1.5px solid #e8ecf4;
                        border-radius: 16px;
                        padding: 14px 12px 12px;
                        background: #fff;
                        overflow: hidden;
                        box-shadow: 0 2px 8px rgba(20, 30, 60, 0.04);
                        transition: all 0.28s cubic-bezier(0.22, 1, 0.36, 1);
                        animation: lcpMonthIn 0.45s ease forwards;
                        opacity: 0;
                    }

                    .lcp-month-card:nth-child(1) {
                        animation-delay: 0.03s;
                    }

                    .lcp-month-card:nth-child(2) {
                        animation-delay: 0.06s;
                    }

                    .lcp-month-card:nth-child(3) {
                        animation-delay: 0.09s;
                    }

                    .lcp-month-card:nth-child(4) {
                        animation-delay: 0.12s;
                    }

                    .lcp-month-card:nth-child(5) {
                        animation-delay: 0.15s;
                    }

                    .lcp-month-card:nth-child(6) {
                        animation-delay: 0.18s;
                    }

                    .lcp-month-card:nth-child(7) {
                        animation-delay: 0.21s;
                    }

                    .lcp-month-card:nth-child(8) {
                        animation-delay: 0.24s;
                    }

                    .lcp-month-card:nth-child(9) {
                        animation-delay: 0.27s;
                    }

                    .lcp-month-card:nth-child(10) {
                        animation-delay: 0.30s;
                    }

                    .lcp-month-card:nth-child(11) {
                        animation-delay: 0.33s;
                    }

                    .lcp-month-card:nth-child(12) {
                        animation-delay: 0.36s;
                    }

                    .lcp-month-card:hover {
                        transform: translateY(-4px);
                        box-shadow: 0 12px 28px rgba(79, 70, 229, 0.12);
                        border-color: #a5b4fc;
                    }

                    /* Accent top bar on hover */
                    .lcp-month-card::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 3px;
                        background: linear-gradient(90deg, #4f46e5, #06b6d4);
                        opacity: 0;
                        transition: opacity 0.25s ease;
                    }

                    .lcp-month-card:hover::before {
                        opacity: 1;
                    }

                    .lcp-month-card.lcp-hidden {
                        display: none;
                    }

                    .lcp-month-card-head {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        font-weight: 800;
                        color: #1a2332;
                        font-size: 0.82rem;
                        margin-bottom: 10px;
                        padding: 0 2px;
                    }

                    .lcp-month-badge {
                        background: #eef2ff;
                        color: #4f46e5;
                        font-size: 0.6rem;
                        font-weight: 700;
                        padding: 2px 9px;
                        border-radius: 20px;
                        border: 1px solid #c7d2fe;
                    }

                    /* ---- Day grid ---- */
                    .lcp-mini-weekdays {
                        display: grid;
                        grid-template-columns: repeat(7, minmax(0, 1fr));
                        gap: 2px;
                        margin-bottom: 5px;
                    }

                    .lcp-mini-weekdays span {
                        text-align: center;
                        font-size: 0.55rem;
                        font-weight: 700;
                        color: #94a3b8;
                        text-transform: uppercase;
                        letter-spacing: 0.01em;
                        padding-bottom: 2px;
                    }

                    .lcp-mini-grid {
                        display: grid;
                        grid-template-columns: repeat(7, minmax(0, 1fr));
                        gap: 3px;
                    }

                    /* ---- Day cells ---- */
                    .lcp-day {
                        position: relative;
                        aspect-ratio: 1 / 1;
                        border-radius: 6px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        background: #f8fafc;
                        border: 1px solid #eef0f6;
                        font-size: 0.64rem;
                        cursor: default;
                        transition: all 0.18s ease;
                    }

                    .lcp-day:hover {
                        transform: scale(1.25);
                        box-shadow: 0 6px 16px rgba(20, 30, 60, 0.15);
                        z-index: 5;
                        border-color: transparent;
                    }

                    .lcp-day-empty {
                        background: transparent;
                        border: none;
                        cursor: default;
                    }

                    .lcp-day-empty:hover {
                        transform: none;
                        box-shadow: none;
                    }

                    .lcp-day-num {
                        font-weight: 600;
                        color: #374151;
                    }

                    /* Weekend */
                    .lcp-day.lcp-weekend {
                        background: #f1f5f9;
                        border-color: #e2e8f0;
                    }

                    .lcp-day.lcp-weekend .lcp-day-num {
                        color: #94a3b8;
                    }

                    /* Public Holiday – green */
                    .lcp-day.lcp-ph {
                        background: #dcfce7;
                        border-color: #86efac;
                    }

                    .lcp-day.lcp-ph .lcp-day-num {
                        color: #15803d;
                        font-weight: 700;
                    }

                    .lcp-day.lcp-ph:hover {
                        background: #bbf7d0;
                        box-shadow: 0 4px 12px rgba(34, 197, 94, 0.25);
                    }

                    /* Casual Leave – sky blue */
                    .lcp-day.lcp-cl {
                        background: #e0f2fe;
                        border-color: #7dd3fc;
                    }

                    .lcp-day.lcp-cl .lcp-day-num {
                        color: #0369a1;
                        font-weight: 700;
                    }

                    .lcp-day.lcp-cl:hover {
                        background: #bae6fd;
                        box-shadow: 0 4px 12px rgba(14, 165, 233, 0.25);
                    }

                    /* Sick Leave – purple */
                    .lcp-day.lcp-sl {
                        background: #f3e8ff;
                        border-color: #d8b4fe;
                    }

                    .lcp-day.lcp-sl .lcp-day-num {
                        color: #7c3aed;
                        font-weight: 700;
                    }

                    .lcp-day.lcp-sl:hover {
                        background: #e9d5ff;
                        box-shadow: 0 4px 12px rgba(168, 85, 247, 0.25);
                    }

                    /* Annual Leave – amber */
                    .lcp-day.lcp-al {
                        background: #fef9c3;
                        border-color: #fde047;
                    }

                    .lcp-day.lcp-al .lcp-day-num {
                        color: #a16207;
                        font-weight: 700;
                    }

                    .lcp-day.lcp-al:hover {
                        background: #fef08a;
                        box-shadow: 0 4px 12px rgba(234, 179, 8, 0.25);
                    }

                    /* Today – solid indigo with pulse */
                    .lcp-day.lcp-today {
                        background: #4f46e5 !important;
                        border-color: #4f46e5 !important;
                        animation: lcpTodayPulse 2s ease-in-out infinite;
                        z-index: 3;
                    }

                    .lcp-day.lcp-today .lcp-day-num {
                        color: #fff !important;
                        font-weight: 800;
                    }

                    /* ---- Tooltip ---- */
                    .lcp-tip {
                        position: absolute;
                        bottom: calc(100% + 8px);
                        left: 50%;
                        transform: translateX(-50%) translateY(6px);
                        background: #1e293b;
                        color: #fff;
                        font-size: 0.72rem;
                        line-height: 1.5;
                        padding: 9px 13px;
                        border-radius: 10px;
                        white-space: nowrap;
                        box-shadow: 0 10px 24px rgba(0, 0, 0, 0.25);
                        opacity: 0;
                        pointer-events: none;
                        transition: opacity 0.15s ease, transform 0.15s ease;
                        z-index: 20;
                    }

                    .lcp-tip b {
                        display: block;
                        font-weight: 700;
                        font-size: 0.74rem;
                        margin-bottom: 2px;
                    }

                    .lcp-tip .lcp-tip-type {
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                        font-size: 0.66rem;
                        font-weight: 600;
                        padding: 2px 8px;
                        border-radius: 20px;
                        margin-top: 3px;
                    }

                    .lcp-tip .lcp-tip-type.tt-ph {
                        background: rgba(34, 197, 94, 0.2);
                        color: #86efac;
                    }

                    .lcp-tip .lcp-tip-type.tt-cl {
                        background: rgba(56, 189, 248, 0.2);
                        color: #7dd3fc;
                    }

                    .lcp-tip .lcp-tip-type.tt-sl {
                        background: rgba(168, 85, 247, 0.2);
                        color: #d8b4fe;
                    }

                    .lcp-tip .lcp-tip-type.tt-al {
                        background: rgba(251, 191, 36, 0.2);
                        color: #fde68a;
                    }

                    .lcp-tip .lcp-tip-type.tt-wd {
                        background: rgba(255, 255, 255, 0.1);
                        color: rgba(255, 255, 255, 0.7);
                    }

                    .lcp-tip::after {
                        content: '';
                        position: absolute;
                        top: 100%;
                        left: 50%;
                        transform: translateX(-50%);
                        border: 5px solid transparent;
                        border-top-color: #1e293b;
                    }

                    .lcp-day:hover .lcp-tip {
                        opacity: 1;
                        transform: translateX(-50%) translateY(0);
                    }

                    /* ---- Legend ---- */
                    .lcp-legend {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 8px;
                        margin-top: 18px;
                        padding: 16px 4px 4px;
                        border-top: 1.5px solid #e8ecf4;
                        justify-content: center;
                    }

                    .lcp-legend-item {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        font-size: 0.76rem;
                        font-weight: 600;
                        color: #374151;
                        background: #fff;
                        border: 1.5px solid #e8ecf4;
                        border-radius: 20px;
                        padding: 6px 14px 6px 10px;
                        cursor: default;
                        transition: all 0.2s ease;
                    }

                    .lcp-legend-item:hover {
                        border-color: #a5b4fc;
                        transform: translateY(-2px);
                        box-shadow: 0 6px 14px rgba(79, 70, 229, 0.08);
                    }

                    .lcp-legend-dot {
                        width: 12px;
                        height: 12px;
                        border-radius: 4px;
                        flex-shrink: 0;
                    }

                    .lcp-legend-dot.lcp-normal {
                        background: #f8fafc;
                        border: 1.5px solid #cbd5e1;
                    }

                    .lcp-legend-dot.lcp-weekend {
                        background: #e2e8f0;
                        border: 1px solid #cbd5e1;
                    }

                    .lcp-legend-dot.lcp-ph {
                        background: #dcfce7;
                        border: 1.5px solid #86efac;
                    }

                    .lcp-legend-dot.lcp-cl {
                        background: #e0f2fe;
                        border: 1.5px solid #7dd3fc;
                    }

                    .lcp-legend-dot.lcp-sl {
                        background: #f3e8ff;
                        border: 1.5px solid #d8b4fe;
                    }

                    .lcp-legend-dot.lcp-al {
                        background: #fef9c3;
                        border: 1.5px solid #fde047;
                    }

                    /* ---- Fullscreen Modal ---- */
                    .lcp-modal-overlay {
                        position: fixed;
                        inset: 0;
                        background: rgba(15, 23, 42, 0.65);
                        backdrop-filter: blur(6px);
                        -webkit-backdrop-filter: blur(6px);
                        z-index: 9998;
                        opacity: 0;
                        visibility: hidden;
                        transition: opacity 0.3s ease, visibility 0.3s ease;
                    }

                    .lcp-modal-overlay.active {
                        opacity: 1;
                        visibility: visible;
                    }

                    .lcp-modal-content {
                        position: fixed;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%) scale(0.94);
                        width: 92vw;
                        max-width: 1100px;
                        max-height: 90vh;
                        overflow-y: auto;
                        background: #f7f8fc;
                        border-radius: 20px;
                        box-shadow: 0 32px 64px rgba(0, 0, 0, 0.25);
                        z-index: 9999;
                        opacity: 0;
                        visibility: hidden;
                        transition: all 0.35s cubic-bezier(0.22, 1, 0.36, 1);
                        scrollbar-width: thin;
                        scrollbar-color: #a5b4fc #eef2ff;
                    }

                    .lcp-modal-content::-webkit-scrollbar {
                        width: 7px;
                    }

                    .lcp-modal-content::-webkit-scrollbar-track {
                        background: #eef2ff;
                        border-radius: 8px;
                    }

                    .lcp-modal-content::-webkit-scrollbar-thumb {
                        background: linear-gradient(180deg, #a5b4fc, #4f46e5);
                        border-radius: 8px;
                    }

                    .lcp-modal-overlay.active .lcp-modal-content {
                        opacity: 1;
                        visibility: visible;
                        transform: translate(-50%, -50%) scale(1);
                    }

                    .lcp-modal-close {
                        position: sticky;
                        top: 12px;
                        float: right;
                        margin: 12px 12px 0 0;
                        width: 36px;
                        height: 36px;
                        border-radius: 10px;
                        border: none;
                        background: #e8ecf4;
                        color: #374151;
                        font-size: 1rem;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        z-index: 10;
                        transition: all 0.2s ease;
                    }

                    .lcp-modal-close:hover {
                        background: #1e293b;
                        color: #fff;
                        transform: rotate(90deg);
                    }

                    .lcp-modal-body {
                        padding: 20px 28px 28px;
                    }

                    .lcp-modal-body .lcp-months-grid {
                        grid-template-columns: repeat(4, minmax(0, 1fr));
                        gap: 14px;
                    }

                    .lcp-modal-body .lcp-month-card {
                        padding: 14px 12px 12px;
                    }

                    .lcp-modal-body .lcp-mini-grid {
                        gap: 3px;
                    }

                    /* ---- Summary bar in modal ---- */
                    .lcp-summary-bar {
                        display: flex;
                        align-items: center;
                        gap: 16px;
                        padding: 14px 20px;
                        margin-bottom: 16px;
                        background: #fff;
                        border: 1.5px solid #e8ecf4;
                        border-radius: 14px;
                        box-shadow: 0 2px 8px rgba(20, 30, 60, 0.05);
                    }

                    .lcp-summary-item {
                        display: flex;
                        align-items: center;
                        gap: 7px;
                        font-size: 0.8rem;
                        font-weight: 600;
                        color: #374151;
                    }

                    .lcp-summary-item .lcp-sum-num {
                        font-size: 1.15rem;
                        font-weight: 800;
                        color: #1a2332;
                    }

                    .lcp-summary-sep {
                        width: 1px;
                        height: 24px;
                        background: #e2e8f0;
                    }

                    /* ---- Responsive breakpoints ---- */
                    @media (max-width: 900px) {

                        .lcp-months-grid,
                        .lcp-modal-body .lcp-months-grid {
                            grid-template-columns: repeat(3, minmax(0, 1fr));
                        }
                    }

                    @media (max-width: 700px) {

                        .lcp-months-grid,
                        .lcp-modal-body .lcp-months-grid {
                            grid-template-columns: repeat(2, minmax(0, 1fr));
                        }

                        .lcp-stats-row {
                            grid-template-columns: repeat(2, minmax(0, 1fr));
                        }

                        .lcp-month-tab {
                            padding: 5px 8px;
                            font-size: 0.68rem;
                        }

                        .lcp-summary-bar {
                            flex-wrap: wrap;
                            gap: 8px;
                        }

                        .lcp-summary-sep {
                            display: none;
                        }
                    }

                    @media (max-width: 480px) {
                        .lcp-months-grid {
                            grid-template-columns: repeat(2, minmax(0, 1fr));
                        }

                        .lcp-day {
                            border-radius: 4px;
                            font-size: 0.6rem;
                        }

                        .lcp-header {
                            padding: 16px 18px 14px;
                        }

                        .lcp-wrap {
                            padding: 14px 14px 12px;
                        }
                    }

                    /* ---- redesigned leave calendar ends here ---- */
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
                                        <div class="stat-value">
                                            <asp:Literal ID="litActiveCount" runat="server" Text="0" />
                                        </div>
                                        <div class="stat-label">Active Employees</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="stat-card red">
                                    <div class="stat-icon"><i class="bi bi-person-dash-fill"></i></div>
                                    <div>
                                        <div class="stat-value">
                                            <asp:Literal ID="litInactiveCount" runat="server" Text="0" />
                                        </div>
                                        <div class="stat-label">Inactive Employees</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="stat-card blue">
                                    <div class="stat-icon"><i class="bi bi-building"></i></div>
                                    <div>
                                        <div class="stat-value">
                                            <asp:Literal ID="litDeptCount" runat="server" Text="0" />
                                        </div>
                                        <div class="stat-label">Departments</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="stat-card green">
                                    <div class="stat-icon"><i class="bi bi-cash-stack"></i></div>
                                    <div>
                                        <div class="stat-value">
                                            <asp:Literal ID="litTotalPayroll" runat="server" Text="0" />
                                        </div>
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
                                        <span class="section-header-title"><i class="bi bi-clock-history"></i>Recently
                                            Added</span>
                                        <span class="section-count-badge"><i class="bi bi-people-fill me-1"></i>
                                            <asp:Literal ID="litRecentCount" runat="server" Text="0" />
                                        </span>
                                    </div>
                                    <div class="card-body p-3">
                                        <asp:Repeater ID="rptRecent" runat="server">
                                            <ItemTemplate>
                                                <div class="recent-item">
                                                    <div class="recent-rank">
                                                        <%# Container.ItemIndex + 1 %>
                                                    </div>
                                                    <div class="avatar-circle">
                                                        <%# GetInitials(Eval("EmpName").ToString()) %>
                                                    </div>
                                                    <div>
                                                        <div class="recent-name">
                                                            <%# Eval("EmpName") %>
                                                        </div>
                                                        <div class="recent-meta">
                                                            <span class="dept-chip">
                                                                <%# Eval("DeptName") %>
                                                            </span>
                                                            <%# string.IsNullOrEmpty(Eval("Designation").ToString())
                                                                ? "" : "&middot; " + Eval("Designation") %>
                                                        </div>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                        <div class="empty-state" runat="server" id="divNoRecentWrap" visible="false">
                                            <i class="bi bi-inbox"></i>
                                            <asp:Label ID="lblNoRecent" runat="server" Text="No employees yet."
                                                Visible="false" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-6">
                                <div class="card shadow">
                                    <div class="card-header-custom section-header">
                                        <span class="section-header-title"><i
                                                class="bi bi-bar-chart-fill"></i>Department Breakdown</span>
                                        <span class="section-count-badge"><i class="bi bi-building me-1"></i>
                                            <asp:Literal ID="litDeptChartCount" runat="server" Text="0" />
                                            Depts
                                        </span>
                                    </div>
                                    <div class="card-body p-4">
                                        <div class="chart-wrap">
                                            <canvas id="deptChart"></canvas>
                                        </div>
                                        <asp:Label ID="lblNoDepts" runat="server" CssClass="empty-state"
                                            Text="No departments yet." Visible="false" />
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
                                        <span class="section-header-title"><i
                                                class="bi bi-calendar2-week-fill"></i>Leave Summary</span>
                                        <span class="section-count-badge"><i class="bi bi-list-check me-1"></i>
                                            <asp:Literal ID="litLeaveTypeCount" runat="server" Text="0" />
                                            Types
                                        </span>
                                    </div>
                                    <div class="card-body p-3">
                                        <asp:Literal ID="litLeaveList" runat="server" />
                                        <asp:Label ID="lblNoLeave" runat="server" CssClass="empty-state"
                                            Text="No leave data yet." Visible="false" />
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
                                    <span style="font-weight: 700;">Organization Chart</span>
                                </div>
                                <div class="card-body pb-0 pt-3">
                                    <div class="d-flex gap-3 flex-wrap" style="font-size: 0.8rem;">
                                        <span><span class="legend-dot"
                                                style="background: #16a34a;"></span>Executive</span>
                                        <span><span class="legend-dot"
                                                style="background: #2563eb;"></span>Manager</span>
                                        <span><span class="legend-dot" style="background: #7c5cff;"></span>Staff</span>
                                        <span><span class="legend-dot" style="background: #e0448a;"></span>Intern</span>
                                    </div>
                                </div>
                                <div class="card-body p-4" style="overflow-x: auto;">
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
                                    <span class="section-header-title"><i
                                            class="bi bi-calendar-check-fill"></i>Attendance Overview</span>
                                    <span class="section-count-badge"><i class="bi bi-clock-history me-1"></i>Last 12
                                        Days</span>
                                </div>
                                <div class="card-body pb-0 pt-3">
                                    <div class="attendance-stats-row">
                                        <span class="attendance-stat-chip chip-intime">
                                            <span class="dot"></span>In Time:
                                            <asp:Literal ID="litInTimeCount" runat="server" Text="0" />
                                        </span>
                                        <span class="attendance-stat-chip chip-late">
                                            <span class="dot"></span>Late:
                                            <asp:Literal ID="litLateCount" runat="server" Text="0" />
                                        </span>
                                        <span class="attendance-stat-chip chip-notarrived">
                                            <span class="dot"></span>Not Arrived:
                                            <asp:Literal ID="litNotArrivedCount" runat="server" Text="0" />
                                        </span>
                                    </div>
                                </div>
                                <div class="card-body p-4">
                                    <div class="chart-wrap">
                                        <canvas id="attendanceChart"></canvas>
                                    </div>
                                    <asp:Label ID="lblNoAttendance" runat="server" CssClass="empty-state"
                                        Text="No attendance records yet." Visible="false" />
                                </div>
                            </div>
                        </div>

                        <!-- ============================= -->
                        <!-- TEAM ATTENDANCE SECTION -->
                        <!-- ============================= -->
                        <div class="mt-4">
                            <div class="card shadow">
                                <div class="card-header-custom section-header">
                                    <span class="section-header-title"><i class="bi bi-people-fill"></i>Team Attendance
                                        Summary</span>
                                    <span class="section-count-badge"><i class="bi bi-person-check me-1"></i>
                                        <asp:Literal ID="litTeamAttCount" runat="server" Text="0" />
                                        Members
                                    </span>
                                </div>

                                <div class="card-body p-4 pb-2">
                                    <asp:Repeater ID="rptTeamAttendance" runat="server">
                                        <ItemTemplate>
                                            <div class="team-member-row">
                                                <div class="team-avatar-wrap">
                                                    <img class="team-avatar-photo"
                                                        src='<%# "ShowImage.ashx?EmpID=" + Eval("EmpID") %>'
                                                        onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                                                    <div class="team-avatar-fallback" style="display: none;">
                                                        <%# GetInitials(Eval("EmpName").ToString()) %>
                                                    </div>
                                                </div>
                                                <div class="team-member-info">
                                                    <div class="team-member-name">
                                                        <%# Eval("EmpName") %>
                                                    </div>
                                                    <div class="team-member-times">
                                                        <span><i class="bi bi-box-arrow-in-right"></i>In: <%#
                                                                Eval("AvgCheckIn") %></span>
                                                        <span><i class="bi bi-box-arrow-right"></i>Out: <%#
                                                                Eval("AvgCheckOut") %></span>
                                                        <span><i class="bi bi-hourglass-split"></i>
                                                            <%# Eval("AvgHours") %> hrs/day
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="team-status-pills">
                                                    <span class="status-pill pill-intime">
                                                        <%# Eval("InTimeCount") %> On-time
                                                    </span>
                                                    <span class="status-pill pill-late">
                                                        <%# Eval("LateCount") %> Late
                                                    </span>
                                                    <span class="status-pill pill-absent">
                                                        <%# Eval("NotArrivedCount") %> Absent
                                                    </span>
                                                </div>
                                                <div class="team-rate-wrap">
                                                    <div class="team-rate-bar-bg">
                                                        <div class="team-rate-bar-fill"
                                                            style='width: <%# GetAttendanceRate(Eval("InTimeCount"), Eval("TotalDays")) %>%;'>
                                                        </div>
                                                    </div>
                                                    <div class="team-rate-label">
                                                        <%# GetAttendanceRate(Eval("InTimeCount"), Eval("TotalDays")) %>
                                                            % on-time
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <asp:Label ID="lblNoTeamAttendance" runat="server" CssClass="empty-state"
                                        Text="No team attendance data yet." Visible="false" />
                                </div>

                                <div class="card-body p-4 pt-2">
                                    <div class="chart-wrap" style="height: 280px;">
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
                                <div class="card shadow h-100 l7-compact l7v2-card">
                                    <div class="card-header-custom section-header">
                                        <span class="section-header-title"><i class="bi bi-calendar-week"></i>Last 7
                                            Days Overview</span>
                                        <span class="section-count-badge"><i class="bi bi-clock-history me-1"></i>
                                            <asp:Literal ID="litL7Range" runat="server" Text="Rolling 7-Day Window" />
                                        </span>
                                    </div>
                                    <div class="card-body p-3">
                                        <p class="l7-subtitle">Attendance trends over the last 7 working days</p>

                                        <div class="l7v2-tiles">
                                            <div class="l7v2-tile" data-accent="checkin"
                                                style="animation-delay: 0.05s;">
                                                <div class="l7v2-tile-top">
                                                    <span class="l7v2-icon"><i
                                                            class="bi bi-box-arrow-in-right"></i></span>
                                                    <span class="l7v2-trend" id="l7TrendCheckIn"></span>
                                                </div>
                                                <div class="l7v2-value">
                                                    <asp:Literal ID="litL7AvgCheckIn" runat="server" Text="--:--" />
                                                </div>
                                                <div class="l7v2-label">Avg Check-In</div>
                                                <div class="l7v2-spark">
                                                    <canvas id="l7SparkCheckIn"></canvas>
                                                </div>
                                            </div>
                                            <div class="l7v2-tile" data-accent="checkout"
                                                style="animation-delay: 0.1s;">
                                                <div class="l7v2-tile-top">
                                                    <span class="l7v2-icon"><i class="bi bi-box-arrow-right"></i></span>
                                                    <span class="l7v2-trend" id="l7TrendCheckOut"></span>
                                                </div>
                                                <div class="l7v2-value">
                                                    <asp:Literal ID="litL7AvgCheckOut" runat="server" Text="--:--" />
                                                </div>
                                                <div class="l7v2-label">Avg Check-Out</div>
                                                <div class="l7v2-spark">
                                                    <canvas id="l7SparkCheckOut"></canvas>
                                                </div>
                                            </div>
                                            <div class="l7v2-tile" data-accent="hours" style="animation-delay: 0.15s;">
                                                <div class="l7v2-tile-top">
                                                    <span class="l7v2-icon"><i class="bi bi-hourglass-split"></i></span>
                                                    <span class="l7v2-trend" id="l7TrendHours"></span>
                                                </div>
                                                <div class="l7v2-value">
                                                    <asp:Literal ID="litL7AvgHours" runat="server" Text="0.0" />
                                                    hrs
                                                </div>
                                                <div class="l7v2-label">Avg Time Spent</div>
                                                <div class="l7v2-spark">
                                                    <canvas id="l7SparkHours"></canvas>
                                                </div>
                                            </div>
                                            <div class="l7v2-tile" data-accent="absent" style="animation-delay: 0.2s;">
                                                <div class="l7v2-tile-top">
                                                    <span class="l7v2-icon"><i class="bi bi-person-x-fill"></i></span>
                                                    <span class="l7v2-trend" id="l7TrendAbsent"></span>
                                                </div>
                                                <div class="l7v2-value">
                                                    <asp:Literal ID="litL7TotalAbsents" runat="server" Text="0" />
                                                </div>
                                                <div class="l7v2-label">Total Absents</div>
                                                <div class="l7v2-spark">
                                                    <canvas id="l7SparkAbsent"></canvas>
                                                </div>
                                            </div>
                                        </div>

                                        <asp:Label ID="lblNoL7Trend" runat="server" CssClass="empty-state"
                                            Text="No attendance trend data yet." Visible="false" />
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-6">
                                <div class="card shadow h-100 status-compact">
                                    <div class="card-header-custom">
                                        <span style="font-weight: 700;"><i
                                                class="bi bi-bar-chart-steps me-2"></i>Today's Status Snapshot</span>
                                    </div>
                                    <div class="card-body p-3">
                                        <div class="status-count-hero">
                                            <span class="big-num">
                                                <asp:Literal ID="litStatusTotalCount" runat="server" Text="0" />
                                            </span>
                                            <span class="big-label">Total Employees Tracked</span>
                                        </div>
                                        <div class="chart-wrap" style="height: 240px;">
                                            <canvas id="statusChart"></canvas>
                                        </div>
                                        <asp:Label ID="lblNoStatus" runat="server" CssClass="empty-state"
                                            Text="No attendance data for today." Visible="false" />
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
                                        <span style="font-weight: 700;"><i class="bi bi-graph-up me-2"></i>Compensation
                                            History &ndash; TGC Range</span>
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
                                        <asp:Label ID="lblNoEventHistory" runat="server" CssClass="empty-state"
                                            Text="No compensation history yet." Visible="false" />
                                    </div>
                                </div>
                            </div>

                            <!-- ============================= -->
                            <!-- MD4 CARD - REPORTING LINE (static front-end, unlimited reportees) -->
                            <!-- ============================= -->
                            <div class="col-lg-6">
                                <div class="card shadow h-100 l7-compact md4-card rl-card">
                                    <div class="rl-header">
                                        <span class="rl-header-icon"><i class="bi bi-diagram-3"></i></span>
                                        <span>Reporting Line</span>
                                    </div>
                                    <div class="card-body p-3 rl-body">
                                        <div class="rl-tree">
                                            <span class="rl-label rl-node">Reporting To</span>
                                            <div class="rl-card-row rl-manager-row rl-node">
                                                <div class="rl-avatar rl-avatar-manager"><i
                                                        class="bi bi-person-fill"></i></div>
                                                <div>
                                                    <div class="rl-name">Employee No. 2950</div>
                                                    <div class="rl-manager-sub">Manager</div>
                                                </div>
                                            </div>

                                            <div class="rl-you-badge rl-node"><i class="bi bi-person-check-fill"></i>YOU
                                            </div>

                                            <div class="rl-label rl-label-flex rl-node">
                                                <span>Reportees <span class="rl-indirect-note">(*) Indirect
                                                        Reportees</span></span>
                                                <span class="rl-count-badge" id="rlReporteeCount">12</span>
                                            </div>

                                            <div class="rl-reportees-wrap">
                                                <div class="rl-reportees-list" id="rlReporteesList">
                                                    <div class="rl-card-row rl-reportee-row rl-node">
                                                        <div class="rl-avatar">60</div>
                                                        <div class="rl-name">Employee No. 13160</div>
                                                    </div>
                                                    <div class="rl-card-row rl-reportee-row rl-node">
                                                        <div class="rl-avatar">73</div>
                                                        <div class="rl-name">Employee No. 14473</div>
                                                    </div>
                                                    <div class="rl-card-row rl-reportee-row rl-node">
                                                        <div class="rl-avatar">50</div>
                                                        <div class="rl-name">Employee No. 22050</div>
                                                    </div>
                                                    <div class="rl-card-row rl-reportee-row rl-node">
                                                        <div class="rl-avatar">61</div>
                                                        <div class="rl-name">Employee No. 23961 <span
                                                                class="rl-indirect-star">*</span></div>
                                                    </div>
                                                    <div class="rl-card-row rl-reportee-row rl-node">
                                                        <div class="rl-avatar">34</div>
                                                        <div class="rl-name">Employee No. 18234</div>
                                                    </div>
                                                    <div class="rl-card-row rl-reportee-row rl-node">
                                                        <div class="rl-avatar">88</div>
                                                        <div class="rl-name">Employee No. 19588 <span
                                                                class="rl-indirect-star">*</span></div>
                                                    </div>
                                                    <div class="rl-card-row rl-reportee-row rl-node">
                                                        <div class="rl-avatar">27</div>
                                                        <div class="rl-name">Employee No. 20127</div>
                                                    </div>
                                                </div>
                                                <div class="rl-scroll-fade"></div>
                                            </div>
                                            <div class="rl-scroll-hint"><i class="bi bi-chevron-down"></i>Scroll for
                                                more</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ============================= -->
                        <!-- YEARLY LEAVE CALENDAR (static preview) -->
                        <!-- ============================= -->
                        <!-- ============================= -->
                        <!-- YEARLY LEAVE CALENDAR (static preview) -->
                        <!-- ============================= -->
                        <div class="row g-3 mt-4">
                            <div class="col-12">
                                <div class="card shadow h-100 l7-compact leavecal-card">
                                    <div class="leavecal-header section-header">
                                        <span class="section-header-title"><i class="bi bi-calendar3"></i>Yearly Leave
                                            Calendar</span>
                                        <span class="section-count-badge"><i class="bi bi-eye me-1"></i>Static
                                            Preview</span>
                                    </div>
                                    <div class="card-body p-3 leavecal-body">

                                        <div class="leavecal-toolbar">
                                            <div class="leavecal-filters">
                                                <div class="leavecal-filter-group">
                                                    <span class="leavecal-filter-label">Year</span>
                                                    <asp:DropDownList ID="ddlLeaveCalYear" runat="server"
                                                        CssClass="leavecal-filter-select" AutoPostBack="true"
                                                        OnSelectedIndexChanged="ddlLeaveCalFilter_Changed">
                                                        <asp:ListItem Text="2025" Value="2025" />
                                                        <asp:ListItem Text="2026" Value="2026" Selected="True" />
                                                        <asp:ListItem Text="2027" Value="2027" />
                                                    </asp:DropDownList>
                                                </div>
                                                <div class="leavecal-filter-group">
                                                    <span class="leavecal-filter-label">Month</span>
                                                    <asp:DropDownList ID="ddlLeaveCalMonth" runat="server"
                                                        CssClass="leavecal-filter-select" AutoPostBack="true"
                                                        OnSelectedIndexChanged="ddlLeaveCalFilter_Changed">
                                                        <asp:ListItem Text="January" Value="1" Selected="True" />
                                                        <asp:ListItem Text="February" Value="2" />
                                                        <asp:ListItem Text="March" Value="3" />
                                                        <asp:ListItem Text="April" Value="4" />
                                                        <asp:ListItem Text="May" Value="5" />
                                                        <asp:ListItem Text="June" Value="6" />
                                                        <asp:ListItem Text="July" Value="7" />
                                                        <asp:ListItem Text="August" Value="8" />
                                                        <asp:ListItem Text="September" Value="9" />
                                                        <asp:ListItem Text="October" Value="10" />
                                                        <asp:ListItem Text="November" Value="11" />
                                                        <asp:ListItem Text="December" Value="12" />
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                            <div class="leavecal-legend-top">
                                                <span class="leavecal-legend-item"><span
                                                        class="leavecal-legend-dot lc-normal"></span>Working Day</span>
                                                <span class="leavecal-legend-item"><span
                                                        class="leavecal-legend-dot lc-weekend"></span>Weekend</span>
                                                <span class="leavecal-legend-item"><span
                                                        class="leavecal-legend-dot lc-ph"></span>Public Holiday</span>
                                                <span class="leavecal-legend-item"><span
                                                        class="leavecal-legend-dot lc-cl"></span>Casual Leave</span>
                                                <span class="leavecal-legend-item"><span
                                                        class="leavecal-legend-dot lc-sl"></span>Sick Leave</span>
                                                <span class="leavecal-legend-item"><span
                                                        class="leavecal-legend-dot lc-al"></span>Annual Leave</span>
                                            </div>
                                        </div>

                                        <asp:Literal ID="litLeaveCalendar" runat="server" />
                                        <div class="leavecal-scroll-hint"><i class="bi bi-arrow-left-right"></i>Scroll
                                            to see all days</div>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ============================= -->
                        <!-- LEAVE CALENDAR - REDESIGNED (month-grid, modal-ready) -->
                        <!-- ============================= -->
                        <div class="row g-3 mt-4">
                            <div class="col-12">
                                <div class="card shadow lcp-card">
                                    <div class="lcp-header section-header">
                                        <span class="section-header-title"><i class="bi bi-calendar3"></i>&nbsp;Leave
                                            Calendar</span>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="section-count-badge lcp-badge"><i
                                                    class="bi bi-grid-3x3-gap-fill me-1"></i>Year View</span>
                                            <button type="button" class="lcp-expand-btn" id="btnExpandLeaveCalendar"
                                                title="Open full-screen view">
                                                <i class="bi bi-arrows-fullscreen"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="card-body p-2 p-md-3">
                                        <asp:Literal ID="litLeaveCalendarPro" runat="server" />
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