HRMS — Employee Management System

A small Human Resource Management System built with ASP.NET Web Forms (C#) and SQL Server, created as a learning project to understand the full flow between a web frontend and a relational database.

Features

- Employee CRUD (Create, Read, Update, soft-delete)
- Department management (Add/Edit/Delete via modal popup)
- Profile picture upload, stored as binary data in SQL Server and streamed back via a custom HTTP handler
- Login system with hashed passwords (SHA-256) and "Remember Me" via secure token-based cookies (2-day expiry)
- Role-based access control (Admin vs Employee)
- Employee self-service profile page (view/edit own contact info only)
- Responsive Bootstrap 5 UI with a shared navbar (User Control)

Tech Stack

- ASP.NET Web Forms (.NET Framework 4.8)
- C#
- SQL Server (developed against SQL Server Express / LocalDB)
- Bootstrap 5, Bootstrap Icons
- Vanilla JavaScript (fetch API for the Department management modal)

Prerequisites

- Visual Studio 2022 or later (with ASP.NET workload installed)
- SQL Server Express (or any SQL Server instance) + SQL Server Management Studio (SSMS) preferred 2022
- IIS Express (comes bundled with Visual Studio)

Setup Instructions

1. Clone the repository
```bash
   git clone https://github.com/mubasherjam/employee-management-system.git
```

2. Set up the database
   - Open SSMS, connect to your SQL Server instance
   - Create a new database (e.g., `myDB`)
   - Run the SQL scripts in order from the `/database` folder:
     1. `01_schema.sql` — creates tables (Department, Employee, Salary, Users)
     2. `02_stored_procedures.sql` — creates all stored procedures
     3. `03_seed_data.sql` — inserts sample departments and a test admin login

3. Configure the connection string
   - Copy `Web.config.example` to `Web.config`
   - Update the `connectionString` value with your actual SQL Server instance name and database name

4. Open and run
   - Open `HRMSApp.sln` in Visual Studio
   - Press F5 (or Ctrl+F5) to run — this launches IIS Express and opens the app in your browser

5. Log in
   - Default admin login: `admin` / `Admin@123` (created by the seed script — change this password in a real deployment)

Project Structure

/HRMSApp
/Navbar.ascx - Shared navigation bar (User Control), includes Department modal
/Login.aspx - Login page with Remember Me
/Logout.aspx - Clears session and cookie
/EmployeeList.aspx - Admin-only employee directory
/EmployeeProfile.aspx - Admin-only add/edit employee form
/MyProfile.aspx - Self-service profile for Employee-role users
/ShowImage.ashx - Streams profile pictures from the database
/DepartmentApi.ashx - JSON API for Department CRUD (used by the modal)
/database
01_schema.sql
02_stored_procedures.sql
03_seed_data.sql

Known Limitations (Learning Project Scope)

- Passwords are hashed but not salted (fine for learning, not production-grade)
- No email verification or password reset flow yet
- Single "Admin" and "Employee" roles only

License

This is a personal learning project — feel free to fork and adapt.
