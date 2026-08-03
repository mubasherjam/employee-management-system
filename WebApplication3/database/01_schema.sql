CREATE TABLE Department (
    DeptID       INT IDENTITY(1,1) PRIMARY KEY,
    DeptName     NVARCHAR(100) NOT NULL,
    CreatedBy    INT NULL,
    CreatedDate  DATETIME NULL,
    ModifiedBy   INT NULL,
    ModifiedDate DATETIME NULL,
    EndDate      DATETIME NULL
);
GO

CREATE TABLE Employee (
    EmpID                 INT IDENTITY(1,1) PRIMARY KEY,
    EmpName               NVARCHAR(100) NOT NULL,
    DeptID                INT NOT NULL FOREIGN KEY REFERENCES Department(DeptID),
    Gender                NVARCHAR(10) NOT NULL,
    DOB                   DATE NOT NULL,
    JoiningDate           DATE NOT NULL,
    IsActive              BIT NOT NULL DEFAULT(1),
    ProfilePic            VARBINARY(MAX) NULL,
    ProfilePicName        NVARCHAR(255) NULL,
    Email                 NVARCHAR(100) NULL,
    Phone                 NVARCHAR(20) NULL,
    Address               NVARCHAR(255) NULL,
    CNIC                  NVARCHAR(20) NULL,
    Designation           NVARCHAR(100) NULL,
    MaritalStatus         NVARCHAR(20) NULL,
    BloodGroup            NVARCHAR(5) NULL,
    EmergencyContactName  NVARCHAR(100) NULL,
    EmergencyContactPhone NVARCHAR(20) NULL,
    CreatedBy             INT NOT NULL,
    CreatedDate           DATETIME NOT NULL DEFAULT(GETDATE()),
    ModifiedBy            INT NULL,
    ModifiedDate          DATETIME NULL
);
GO

CREATE TABLE Salary (
    SalaryID     INT IDENTITY(1,1) PRIMARY KEY,
    EmpID        INT NOT NULL FOREIGN KEY REFERENCES Employee(EmpID),
    BasicSalary  DECIMAL(10,2) NOT NULL,
    Allowance    DECIMAL(10,2) NOT NULL DEFAULT(0),
    CreatedBy    INT NOT NULL,
    CreatedDate  DATETIME NOT NULL DEFAULT(GETDATE()),
    ModifiedBy   INT NULL,
    ModifiedDate DATETIME NULL
);
GO

CREATE TABLE Users (
    UserID              INT IDENTITY(1,1) PRIMARY KEY,
    Username            NVARCHAR(50) NOT NULL UNIQUE,
    Email               NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash        VARBINARY(64) NOT NULL,
    Role                NVARCHAR(20) NOT NULL DEFAULT('Employee'),
    EmpID               INT NULL FOREIGN KEY REFERENCES Employee(EmpID),
    IsActive            BIT NOT NULL DEFAULT(1),
    CreatedDate         DATETIME NOT NULL DEFAULT(GETDATE()),
    RememberTokenHash   VARBINARY(64) NULL,
    RememberTokenExpiry DATETIME NULL
);
GO