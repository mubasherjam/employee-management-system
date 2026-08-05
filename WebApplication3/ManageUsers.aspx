<%@ Page Title="Manage Users" Language="C#" AutoEventWireup="true" 
    CodeBehind="ManageUsers.aspx.cs" Inherits="HRMSApp.ManageUsers" %>
<%@ Register Src="~/Navbar.ascx" TagPrefix="uc" TagName="Navbar" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Manage Users</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background: #f0f2f6; }
        .card { border: none; border-radius: 16px; }
        .card.shadow { box-shadow: 0 10px 40px rgba(20,30,60,0.08) !important; }
        .card-header-custom { background: #1a2332; color: #fff; padding: 24px 32px; }
        .table thead th {
            background: transparent; color: #a3abba; font-size: 0.72rem;
            text-transform: uppercase; letter-spacing: 0.06em; font-weight: 700;
            border-bottom: 1px solid #eef0f4; padding: 14px 12px;
        }
        .table tbody td { padding: 14px 12px; vertical-align: middle; border-bottom: 1px solid #f4f5f8; }
        .badge-role { font-size: 0.75rem; padding: 5px 12px; border-radius: 20px; font-weight: 600; }
        .badge-admin { background: #fff0f3; color: #d6336c; }
        .badge-employee { background: #eef3ff; color: #3366ff; }
        .unlinked-text { color: #dc3545; font-size: 0.82rem; font-style: italic; }
        .linked-text { color: #16a34a; font-size: 0.85rem; font-weight: 600; }
        .form-select-sm, .btn-sm { font-size: 0.83rem; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <uc:Navbar ID="Navbar1" runat="server" />

        <div class="container mt-4 mb-5" style="max-width: 1100px;">
            <div class="card shadow">
                <div class="card-header card-header-custom">
                    <h3 class="m-0"><i class="bi bi-people-fill me-2"></i>Manage Users</h3>
                    <small>Link signup accounts to employee records, and manage roles</small>
                </div>
                <div class="card-body p-4">

                    <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3" />

                    <asp:UpdatePanel ID="upUsers" runat="server">
                        <ContentTemplate>
                            <div class="table-responsive">
                                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false" 
                                    CssClass="table align-middle mb-0" GridLines="None"
                                    DataKeyNames="UserID" OnRowCommand="gvUsers_RowCommand">
                                    <Columns>
                                        <asp:BoundField DataField="Username" HeaderText="Username" />
                                        <asp:BoundField DataField="Email" HeaderText="Email" />

                                        <asp:TemplateField HeaderText="Role">
                                            <ItemTemplate>
                                                <span class='<%# Eval("Role").ToString() == "Admin" ? "badge-role badge-admin" : "badge-role badge-employee" %>'>
                                                    <%# Eval("Role") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Linked Employee">
                                            <ItemTemplate>
                                                <asp:Literal runat="server" 
                                                    Text='<%# Eval("EmpID") == DBNull.Value ? "<span class=\"unlinked-text\">Not linked</span>" : "<span class=\"linked-text\">" + Eval("LinkedEmployeeName") + " (ID #" + Eval("EmpID") + ")</span>" %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Actions">
                                            <ItemTemplate>
                                                <div class="d-flex gap-1 align-items-center flex-wrap">

                                                    <asp:DropDownList ID="ddlEmployeeLink" runat="server" CssClass="form-select form-select-sm" style="width:180px;" />

                                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-primary" 
                                                        CommandName="LinkEmployee" 
                                                        CommandArgument='<%# Eval("UserID") %>'>
                                                        Link
                                                    </asp:LinkButton>

                                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-secondary" 
                                                        CommandName="Unlink" 
                                                        CommandArgument='<%# Eval("UserID") %>'>
                                                        Unlink
                                                    </asp:LinkButton>

                                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-danger" 
                                                        CommandName="ToggleRole" 
                                                        CommandArgument='<%# Eval("UserID") + "|" + Eval("Role") %>'>
                                                        <%# Eval("Role").ToString() == "Admin" ? "Demote to Employee" : "Promote to Admin" %>
                                                    </asp:LinkButton>

                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div class="text-center text-muted py-4">No users found.</div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div>
            </div>
        </div>
    </form>
</body>
</html>