<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Navbar.ascx.cs" Inherits="HRMSApp.Navbar" %>

<style>
:root {
  --color-gray-300: #d1d5db;
  --color-gray-900: #111827;
  --color-blue-600: #2563eb;
  --color-blue-700: #1d4ed8;
  --color-white: #ffffff;
  --container-padding: 1.5rem;
  --nav-padding-y: 1rem;
  --space-x-3: 0.75rem;
  --space-x-8: 2rem;
  --space-y-4: 1rem;
  --rounded-lg: 0.5rem;
  --button-padding-x: 1.5rem;
  --button-padding-y: 0.75rem;
  --icon-size: 1.5rem;
  --logo-size: 2.5rem;
  --font-size-xl: 1.25rem;
}
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
  font-family: ui-sans-serif, system-ui, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
}
.header-section { background-color: var(--color-gray-900); }
.nav-container { max-width: 1536px; margin: 0 auto; padding: 1rem var(--container-padding); }
.nav-content { display: flex; align-items: center; justify-content: space-between; }
.brand { display: flex; align-items: center; gap: var(--space-x-3); text-decoration: none; }
.logo {
  width: var(--logo-size); height: var(--logo-size);
  background-color: var(--color-blue-600); border-radius: var(--rounded-lg);
  display: flex; align-items: center; justify-content: center;
}
.logo svg { width: var(--icon-size); height: var(--icon-size); color: var(--color-white); }
.brand-name { font-size: var(--font-size-xl); font-weight: 700; color: var(--color-white); }
.desktop-nav { display: none; align-items: center; gap: var(--space-x-8); }
.nav-link { color: var(--color-gray-300); text-decoration: none; transition: color 0.2s ease; background: none; border: none; cursor: pointer; font-size: 1rem; }
.nav-link:hover { color: var(--color-white); }
.nav-link.active { color: var(--color-white); font-weight: 600; }
.cta-button {
  background-color: var(--color-blue-600); color: var(--color-white);
  padding: var(--button-padding-y) var(--button-padding-x);
  border-radius: var(--rounded-lg); border: none; cursor: pointer;
  transition: background-color 0.2s ease; text-decoration: none; display: inline-block;
}
.cta-button:hover { background-color: var(--color-blue-700); color: var(--color-white); }
.mobile-menu-button {
  display: block; color: var(--color-gray-300); background: none; border: none; cursor: pointer; padding: 0;
}
.mobile-menu-button:hover { color: var(--color-white); }
.mobile-menu-button:focus { outline: none; }
.mobile-menu-button svg { width: var(--icon-size); height: var(--icon-size); }
.mobile-menu { display: none; margin-top: var(--space-y-4); padding-bottom: var(--nav-padding-y); }
.mobile-menu.active { display: block; }
.mobile-nav { display: flex; flex-direction: column; gap: var(--space-y-4); }
.mobile-nav .cta-button { width: 100%; text-align: center; }
.menu-icon.hidden, .close-icon.hidden { display: none; }
.user-badge { color: var(--color-gray-300); font-size: 0.85rem; margin-right: 0.5rem; }
@media (min-width: 768px) {
  .desktop-nav { display: flex; }
  .mobile-menu-button { display: none; }
  .mobile-menu { display: none !important; }
}

/* ---- Department Modal (dark themed) ---- */
.dept-modal-content { background: #1e2130; border-radius: 20px; border: none; color: #fff; box-shadow: 0 25px 60px rgba(0,0,0,0.4); }
.dept-modal-header { border-bottom: 1px solid rgba(255,255,255,0.08); padding: 28px 36px 20px 36px; }
.dept-modal-title { font-weight: 800; font-size: 1.4rem; color: #fff; display: flex; align-items: center; gap: 12px; }
.dept-modal-title i { width: 42px; height: 42px; background: rgba(124, 92, 255, 0.15); color: #a78bfa; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; font-size: 1.1rem; }
.dept-modal-subtitle { color: rgba(255,255,255,0.45); font-size: 0.85rem; font-weight: 500; margin-top: 4px; }
.dept-modal-body { padding: 24px 36px 32px 36px; }
.dept-input-row { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 14px; padding: 16px; }
.dept-input-row .form-control { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12); color: #fff; border-radius: 10px; padding: 12px 16px; font-size: 0.95rem; }
.dept-input-row .form-control::placeholder { color: rgba(255,255,255,0.4); }
.dept-input-row .form-control:focus { background: rgba(255,255,255,0.09); border-color: #7c5cff; box-shadow: 0 0 0 3px rgba(124,92,255,0.2); color: #fff; }
.btn-dept-save { background: linear-gradient(135deg, #7c5cff, #6a4ce0); color: #fff; font-weight: 700; border-radius: 10px; border: none; padding: 12px 26px; white-space: nowrap; transition: all 0.15s ease; }
.btn-dept-save:hover { background: linear-gradient(135deg, #8a6dff, #7c5cff); color: #fff; transform: translateY(-1px); box-shadow: 0 6px 16px rgba(124,92,255,0.35); }
.dept-section-label { color: rgba(255,255,255,0.45); font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.07em; font-weight: 700; margin: 26px 0 14px 0; display: flex; align-items: center; gap: 8px; }
.dept-section-label::after { content: ""; flex: 1; height: 1px; background: rgba(255,255,255,0.08); }
.dept-list-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
@media (max-width: 576px) { .dept-list-grid { grid-template-columns: 1fr; } }
.dept-list-item { display: flex; align-items: center; justify-content: space-between; padding: 14px 16px; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06); border-radius: 12px; transition: all 0.15s ease; }
.dept-list-item:hover { background: rgba(255,255,255,0.06); border-color: rgba(124,92,255,0.3); }
.dept-name-text { font-weight: 600; color: #fff; font-size: 0.95rem; display: flex; align-items: center; gap: 10px; }
.dept-name-text::before { content: ""; width: 8px; height: 8px; border-radius: 50%; background: #7c5cff; flex-shrink: 0; }
.dept-actions .btn-icon-dept { width: 34px; height: 34px; border-radius: 9px; border: 1px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.65); display: inline-flex; align-items: center; justify-content: center; margin-left: 6px; transition: all 0.15s ease; text-decoration: none; }
.btn-icon-dept.icon-edit:hover { background: #7c5cff; border-color: #7c5cff; color: #fff; }
.btn-icon-dept.icon-delete:hover { background: #e0448a; border-color: #e0448a; color: #fff; }
.btn-add-dept { background: #fff; color: #1a2332; font-weight: 700; border: none; padding: 10px 20px; border-radius: 10px; font-size: 0.9rem; transition: all 0.15s ease; }
.btn-add-dept:hover { background: #e9ecef; color: #1a2332; transform: translateY(-1px); }
.dept-msg { font-size: 0.87rem; font-weight: 500; }
</style>

<section class="header-section">
  <nav class="nav-container">
    <div class="nav-content">
      <a href="EmployeeList.aspx" class="brand">
        <div class="logo">
          <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
          </svg>
        </div>
        <span class="brand-name">HRMS Portal</span>
      </a>

<%--      <div class="desktop-nav">
        <a href="EmployeeList.aspx" class="nav-link" runat="server" id="lnkEmployeesDesktop">Employees</a>
        <button type="button" class="nav-link" onclick="showDeptModal()">
            <i class="bi bi-building-add me-1"></i>Edit Department
        </button>
        <a href="EmployeeProfile.aspx" class="nav-link" runat="server" id="lnkNewEntryDesktop">New Entry</a>
        <a href="Dashboard.aspx" class="nav-link" runat="server" id="lnkDashboardDesktop">Dashboard</a>
        <asp:Literal ID="litUserBadgeDesktop" runat="server" />
        <a class="cta-button" runat="server" id="lnkAuthDesktop">Login</a>
      </div>--%>
        <div class="desktop-nav">
    <a href="EmployeeList.aspx" class="nav-link" runat="server" id="lnkEmployeesDesktop">Employees</a>
    <button type="button" class="nav-link" runat="server" id="btnEditDeptDesktop" onclick="showDeptModal()">
        <i class="bi bi-building-add me-1"></i>Edit Department
    </button>
            <!-- role based addition -->
    <a href="EmployeeProfile.aspx" class="nav-link" runat="server" id="lnkNewEntryDesktop">New Entry</a>
    <a href="ManageUsers.aspx" class="nav-link" runat="server" id="lnkManageUsersDesktop">Manage Users</a>
    <a href="MyProfile.aspx" class="nav-link" runat="server" id="lnkMyProfileDesktop">My Profile</a>
    <a href="Dashboard.aspx" class="nav-link" runat="server" id="lnkDashboardDesktop">Dashboard</a>
    <asp:Literal ID="litUserBadgeDesktop" runat="server" />
    <a class="cta-button" runat="server" id="lnkAuthDesktop">Login</a>
</div>

      <button id="mobile-menu-button" class="mobile-menu-button" aria-label="Toggle menu" aria-expanded="false">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path class="menu-icon" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
          <path class="close-icon hidden" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
      </button>
    </div>

    <div id="mobile-menu" class="mobile-menu" aria-label="Mobile navigation">
      <div class="mobile-nav">
        <a href="EmployeeList.aspx" class="nav-link" runat="server" id="lnkEmployeesMobile">Employees</a>

          <button type="button" class="nav-link" id="btnEditDeptMobile" runat="server" style="text-align:left;" onclick="showDeptModal()">
    <i class="bi bi-building-add me-1"></i>Edit Department
</button>

        <a href="EmployeeProfile.aspx" class="nav-link" runat="server" id="lnkNewEntryMobile">New Entry</a>
        <a href="ManageUsers.aspx" class="nav-link" runat="server" id="lnkManageUsersMobile">Manage Users</a>
        <a href="Dashboard.aspx" class="nav-link" runat="server" id="lnkDashboardMobile">Dashboard</a>
        <a class="cta-button" runat="server" id="lnkAuthMobile">Login</a>
          <!-- role based addition -->
         <a class="cta-button" runat="server" id="lnkMyProfileMobile">Login</a>

      </div>
    </div>
  </nav>

  <!-- Department Management Modal -->
  <div class="modal fade" id="deptModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content dept-modal-content">

        <div class="dept-modal-header d-flex align-items-center justify-content-between">
          <div>
            <div class="dept-modal-title">
              <i class="bi bi-building"></i>
              Manage Departments
            </div>
            <div class="dept-modal-subtitle">Add, rename, or remove departments across your organization</div>
          </div>
          <button type="button" class="btn-close btn-close-white" onclick="hideDeptModal()"></button>
        </div>

        <asp:UpdatePanel ID="upDept" runat="server" UpdateMode="Conditional">
          <ContentTemplate>

            <div class="dept-modal-body">

              <asp:HiddenField ID="hfDeptID" runat="server" Value="0" />

              <asp:Label ID="lblDeptMessage" runat="server" CssClass="d-block mb-2 dept-msg" />

              <div class="dept-input-row d-flex gap-2">
                <asp:TextBox ID="txtDeptName" runat="server" CssClass="form-control" placeholder="Department Name" />
                <asp:Button ID="btnDeptSave" runat="server" Text="Add" CssClass="btn btn-dept-save" OnClick="btnDeptSave_Click" />
                <asp:Button ID="btnDeptCancelEdit" runat="server" Text="Cancel" CssClass="btn btn-outline-light" Visible="false" CausesValidation="false" OnClick="btnDeptCancelEdit_Click" />
              </div>

              <div class="dept-section-label">Existing Departments</div>

              <div class="dept-list-grid">
                <asp:Repeater ID="rptDepartments" runat="server">
                  <ItemTemplate>
                    <div class="dept-list-item">
                      <span class="dept-name-text"><%# Eval("DeptName") %></span>
                      <span class="dept-actions">
                        <a href="#" class="btn-icon-dept icon-edit" 
                           onclick="triggerDeptProxy('edit', '<%# Eval("DeptID") %>'); return false;">
                          <i class="bi bi-pencil-fill"></i>
                        </a>
                        <a href="#" class="btn-icon-dept icon-delete" 
                           onclick="if(confirm('Delete this department? Employees in it will keep their records, but you should reassign them first.')) { triggerDeptProxy('delete', '<%# Eval("DeptID") %>'); } return false;">
                          <i class="bi bi-trash-fill"></i>
                        </a>
                      </span>
                    </div>
                  </ItemTemplate>
                </asp:Repeater>
              </div>

            </div>

            <asp:HiddenField ID="hfDeptAction" runat="server" Value="" />
            <asp:Button ID="btnDeptProxy" runat="server" style="display:none;" OnClick="btnDeptProxy_Click" />

          </ContentTemplate>
          <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnDeptSave" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnDeptCancelEdit" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnDeptProxy" EventName="Click" />
          </Triggers>
        </asp:UpdatePanel>

      </div>
    </div>
  </div>

</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
  var mobileMenuButton = document.getElementById('mobile-menu-button');
  var mobileMenu = document.getElementById('mobile-menu');
  var menuIcon = mobileMenuButton.querySelector('.menu-icon');
  var closeIcon = mobileMenuButton.querySelector('.close-icon');

  mobileMenuButton.addEventListener('click', function () {
    var isExpanded = mobileMenuButton.getAttribute('aria-expanded') === 'true';
    mobileMenuButton.setAttribute('aria-expanded', !isExpanded);
    mobileMenu.classList.toggle('active');
    menuIcon.classList.toggle('hidden');
    closeIcon.classList.toggle('hidden');
  });

  // Department modal - top-level, globally accessible functions
  var deptModal = null;

  document.addEventListener("DOMContentLoaded", function () {
      deptModal = new bootstrap.Modal(
          document.getElementById("deptModal"),
          { backdrop: "static", keyboard: false }
      );
  });

  function showDeptModal() {
      deptModal.show();
  }

  function hideDeptModal() {
      deptModal.hide();
  }

  function openDeptModalAfterUpdate() {
      if (deptModal == null) {
          deptModal = new bootstrap.Modal(
              document.getElementById("deptModal"),
              { backdrop: "static", keyboard: false }
          );
      }
      deptModal.show();
  }

  function triggerDeptProxy(action, deptId) {
      document.getElementById('<%= hfDeptAction.ClientID %>').value = action;
      document.getElementById('<%= hfDeptID.ClientID %>').value = deptId;
      document.getElementById('<%= btnDeptProxy.ClientID %>').click();
    }
</script>