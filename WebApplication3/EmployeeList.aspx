<%@ Page Title="Employee List" Language="C#" AutoEventWireup="true"
    CodeBehind="EmployeeList.aspx.cs" Inherits="HRMSApp.EmployeeList" %>
<%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>

<!DOCTYPE html>
<html>

<head runat="server">

    <title>Employee List</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
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

        /* ---- Header ---- */
        .card-header-custom {
            background: #0B62E0;
            color: #fff;
            padding: 28px 32px 24px 32px;
            border: none;
        }

        .count-badge {
            background: rgba(255,255,255,0.12);
            color: #fff;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
        }

        .btn-new-entry {
            background: #fff;
            color: #1a2332;
            font-weight: 700;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-size: 0.9rem;
            transition: all 0.15s ease;
        }

            .btn-new-entry:hover {
                background: #e9ecef;
                color: #1a2332;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }

        /* ---- Search bar (inside header now) ---- */
        .search-wrap {
            background: rgba(255,255,255,0.08);
            border-radius: 10px;
            padding: 2px;
        }

            .search-wrap input {
                background: transparent;
                border: none;
                color: #fff;
                padding: 10px 14px;
                font-size: 0.9rem;
            }

                .search-wrap input::placeholder {
                    color: rgba(255,255,255,0.55);
                }

                .search-wrap input:focus {
                    background: rgba(255,255,255,0.1);
                    box-shadow: none;
                    color: #fff;
                }

            .search-wrap i {
                color: rgba(255,255,255,0.55);
            }

        /* ---- Table area ---- */
        .card-body {
            padding: 8px 24px 24px 24px;
            background: #fff;
        }

        .table {
            margin-bottom: 0;
        }

            .table thead th {
                background: transparent;
                color: #a3abba;
                font-size: 0.72rem;
                text-transform: uppercase;
                letter-spacing: 0.07em;
                font-weight: 700;
                border: none;
                border-bottom: 1px solid #eef0f4;
                padding: 16px 12px;
            }

            .table tbody td {
                padding: 16px 12px;
                vertical-align: middle;
                border: none;
                border-bottom: 1px solid #f4f5f8;
            }

            .table tbody tr:last-child td {
                border-bottom: none;
            }

            .table tbody tr {
                transition: all 0.15s ease;
            }

                .table tbody tr:hover {
                    background-color: #f8faff;
                }

                    .table tbody tr:hover td:first-child {
                        border-top-left-radius: 10px;
                        border-bottom-left-radius: 10px;
                    }

                    .table tbody tr:hover td:last-child {
                        border-top-right-radius: 10px;
                        border-bottom-right-radius: 10px;
                    }

        /* ---- Avatar ---- */
        .avatar-photo {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            object-fit: cover;
            flex-shrink: 0;
            border: 2.5px solid #e7ecf5;
        }

        .avatar-circle {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0d6efd, #0a58ca);
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.95rem;
            flex-shrink: 0;
        }

        .name-cell {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .emp-name {
            font-weight: 700;
            color: #1a2332;
            font-size: 0.95rem;
        }

        .emp-id {
            color: #a3abba;
            font-size: 0.78rem;
            font-weight: 500;
        }

        /* ---- Badges ---- */
        .badge-dept {
            background-color: #eef3ff;
            color: #3366ff;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.78rem;
        }

        .badge-gender {
            font-size: 0.78rem;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .badge-gender-male {
            background-color: #eef3ff;
            color: #3366ff;
        }

        .badge-gender-female {
            background-color: #fff0f7;
            color: #e0448a;
        }

        .salary-cell {
            font-weight: 700;
            color: #16a34a;
            font-size: 0.92rem;
        }

        /* ---- Edit button ---- */
        .btn-edit-pencil {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1.5px solid #eef0f4;
            color: #8892a0;
            background: #fff;
            transition: all 0.15s ease;
        }

            .btn-edit-pencil:hover {
                background: #1a2332;
                border-color: #1a2332;
                color: #fff;
                transform: translateY(-1px);
            }

        /* ---- Empty state ---- */
        .empty-state {
            padding: 60px 20px;
            text-align: center;
            color: #a3abba;
        }

            .empty-state i {
                font-size: 2.5rem;
                margin-bottom: 12px;
                display: block;
                color: #d7dbe4;
            }

        #noSearchResults {
            display: none;
            padding: 40px 20px;
            text-align: center;
            color: #a3abba;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />
    <uc:Navbar ID="Navbar1" runat="server" />

    <div class="container mt-3 mb-5 fade-in page-wrap">

        <div class="mb-3">
            <div class="page-title">Employee Directory</div>
            <div class="page-subtitle">Manage employee records, roles, and compensation</div>
        </div>

        <div class="card shadow">

            <div class="card-header card-header-custom">
                <div class="d-flex align-items-center justify-content-between flex-wrap gap-3 mb-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-people-fill fs-4 me-2"></i>
                            <h3 class="m-0">Employee List</h3>
                        </div>
                        <asp:Label ID="lblCount" runat="server" CssClass="count-badge" />
                    </div>

                    <asp:Button ID="btnNewEntry" runat="server" Text="+ New Entry"
                        CssClass="btn btn-new-entry" OnClick="btnNewEntry_Click"
                        CausesValidation="false" />
                </div>

                <div class="search-wrap d-flex align-items-center">
                    <i class="bi bi-search ms-2"></i>
                    <input type="text" id="txtQuickSearch" class="form-control"
                        placeholder="Search by name or department..." onkeyup="filterTable()" />
                </div>
            </div>

            <div class="card-body">

                <asp:Label ID="lblMessage" runat="server" CssClass="d-block mt-3 text-danger fw-semibold" />

                <div class="table-responsive">
                    <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="false"
                        DataKeyNames="EmpID" CssClass="table align-middle mb-0"
                        OnRowCommand="gvEmployees_RowCommand"
                        GridLines="None">
                        <Columns>

                            <asp:TemplateField HeaderText="" ItemStyle-Width="55px">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEdit" runat="server"
                                        CommandName="EditRow"
                                        CommandArgument='<%# Eval("EmpID") %>'
                                        CssClass="btn-edit-pencil"
                                        ToolTip="Edit this employee">
                                    <i class="bi bi-pencil-fill"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Employee">
                                <ItemTemplate>
                                    <div class="name-cell">
                                        <img src='<%# "ShowImage.ashx?EmpID=" + Eval("EmpID") %>'
                                            class="avatar-photo"
                                            onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-flex';" />
                                        <div class="avatar-circle" style="display: none;">
                                            <%# GetInitials(Eval("EmpName").ToString()) %>
                                        </div>
                                        <div>
                                            <div class="emp-name"><%# Eval("EmpName") %></div>
                                            <div class="emp-id">ID #<%# Eval("EmpID") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Department">
                                <ItemTemplate>
                                    <span class="badge-dept"><%# Eval("DeptName") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Gender">
                                <ItemTemplate>
                                    <span class='<%# Eval("Gender").ToString() == "Male" ? "badge-gender badge-gender-male" : "badge-gender badge-gender-female" %>'>
                                        <i class='<%# Eval("Gender").ToString() == "Male" ? "bi bi-gender-male" : "bi bi-gender-female" %>'></i>
                                        <%# Eval("Gender") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Salary">
                                <ItemTemplate>
                                    <span class="salary-cell">Rs. <%# Eval("BasicSalary", "{0:N0}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state">
                                <i class="bi bi-inbox"></i>
                                No employees found. Click <strong>"+ New Entry"</strong> above to add one.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>

                    <div id="noSearchResults">
                        <i class="bi bi-search fs-2 d-block mb-2"></i>
                        No employees match your search.
                    </div>
                </div>

            </div>
        </div>

    </div>

</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function filterTable() {
        var input = document.getElementById('txtQuickSearch');
        var filter = input.value.toLowerCase();

        var table = document.querySelector('.table');
        var rows = table.getElementsByTagName('tr');

        var visibleCount = 0;

        for (var i = 1; i < rows.length; i++) {

            var rowText = rows[i].textContent.toLowerCase();

            if (rowText.indexOf(filter) > -1) {
                rows[i].style.display = "";
                visibleCount++;
            }
            else {
                rows[i].style.display = "none";
            }
        }

        document.getElementById("noSearchResults").style.display =
            (visibleCount === 0 && filter.length > 0) ? "block" : "none";
    }
</script>
</body>
</html>