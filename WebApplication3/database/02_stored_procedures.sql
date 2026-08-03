-- ================================
-- DEPARTMENT PROCEDURES
-- ================================
CREATE PROCEDURE sp_Department_GetAll
AS
BEGIN
    SELECT DeptID, DeptName, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, EndDate
    FROM Department
    WHERE EndDate IS NULL
    ORDER BY DeptName;
END
GO

CREATE PROCEDURE sp_Department_GetAllIncludingDeleted
AS
BEGIN
    SELECT DeptID, DeptName, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, EndDate
    FROM Department
    ORDER BY DeptName;
END
GO

CREATE PROCEDURE sp_Department_Insert
    @DeptName NVARCHAR(100),
    @UserID INT,
    @NewDeptID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Department WHERE DeptName = @DeptName AND EndDate IS NULL)
    BEGIN
        SET @NewDeptID = -1;
        RETURN;
    END
    INSERT INTO Department (DeptName, CreatedBy, CreatedDate)
    VALUES (@DeptName, @UserID, GETDATE());
    SET @NewDeptID = SCOPE_IDENTITY();
END
GO

CREATE PROCEDURE sp_Department_Update
    @DeptID INT,
    @DeptName NVARCHAR(100),
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Department
    SET DeptName = @DeptName, ModifiedBy = @UserID, ModifiedDate = GETDATE()
    WHERE DeptID = @DeptID;
END
GO

CREATE PROCEDURE sp_Department_Delete
    @DeptID INT,
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Department
    SET EndDate = GETDATE(), ModifiedBy = @UserID, ModifiedDate = GETDATE()
    WHERE DeptID = @DeptID;
END
GO

-- ================================
-- EMPLOYEE PROCEDURES
-- ================================
CREATE PROCEDURE sp_Employee_GetAll
AS
BEGIN
    SELECT e.EmpID, e.EmpName, d.DeptName, e.Gender, e.DOB, e.JoiningDate,
           e.IsActive, s.BasicSalary, s.Allowance, e.DeptID,
           e.Designation, e.Email, e.Phone
    FROM Employee e
    INNER JOIN Department d ON e.DeptID = d.DeptID
    LEFT JOIN Salary s ON e.EmpID = s.EmpID
    WHERE e.IsActive = 1
    ORDER BY e.EmpID DESC;
END
GO

CREATE PROCEDURE sp_Employee_GetByID
    @EmpID INT
AS
BEGIN
    SELECT e.EmpID, e.EmpName, e.DeptID, e.Gender, e.DOB, e.JoiningDate,
           e.IsActive, s.BasicSalary, s.Allowance,
           e.Email, e.Phone, e.Address, e.CNIC, e.Designation,
           e.MaritalStatus, e.BloodGroup, e.EmergencyContactName, e.EmergencyContactPhone
    FROM Employee e
    LEFT JOIN Salary s ON e.EmpID = s.EmpID
    WHERE e.EmpID = @EmpID;
END
GO

CREATE PROCEDURE sp_Employee_Insert
    @EmpName NVARCHAR(100), @DeptID INT, @Gender NVARCHAR(10), @DOB DATE,
    @JoiningDate DATE, @IsActive BIT,
    @ProfilePic VARBINARY(MAX) = NULL, @ProfilePicName NVARCHAR(255) = NULL,
    @BasicSalary DECIMAL(10,2), @Allowance DECIMAL(10,2),
    @Email NVARCHAR(100) = NULL, @Phone NVARCHAR(20) = NULL, @Address NVARCHAR(255) = NULL,
    @CNIC NVARCHAR(20) = NULL, @Designation NVARCHAR(100) = NULL,
    @MaritalStatus NVARCHAR(20) = NULL, @BloodGroup NVARCHAR(5) = NULL,
    @EmergencyContactName NVARCHAR(100) = NULL, @EmergencyContactPhone NVARCHAR(20) = NULL,
    @UserID INT, @NewEmpID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Employee (EmpName, DeptID, Gender, DOB, JoiningDate, IsActive,
                           ProfilePic, ProfilePicName, Email, Phone, Address, CNIC,
                           Designation, MaritalStatus, BloodGroup,
                           EmergencyContactName, EmergencyContactPhone,
                           CreatedBy, CreatedDate)
    VALUES (@EmpName, @DeptID, @Gender, @DOB, @JoiningDate, @IsActive,
            @ProfilePic, @ProfilePicName, @Email, @Phone, @Address, @CNIC,
            @Designation, @MaritalStatus, @BloodGroup,
            @EmergencyContactName, @EmergencyContactPhone,
            @UserID, GETDATE());
    SET @NewEmpID = SCOPE_IDENTITY();
    INSERT INTO Salary (EmpID, BasicSalary, Allowance, CreatedBy, CreatedDate)
    VALUES (@NewEmpID, @BasicSalary, @Allowance, @UserID, GETDATE());
END
GO

CREATE PROCEDURE sp_Employee_Update
    @EmpID INT, @EmpName NVARCHAR(100), @DeptID INT, @Gender NVARCHAR(10), @DOB DATE,
    @JoiningDate DATE, @IsActive BIT,
    @ProfilePic VARBINARY(MAX) = NULL, @ProfilePicName NVARCHAR(255) = NULL,
    @BasicSalary DECIMAL(10,2), @Allowance DECIMAL(10,2),
    @Email NVARCHAR(100) = NULL, @Phone NVARCHAR(20) = NULL, @Address NVARCHAR(255) = NULL,
    @CNIC NVARCHAR(20) = NULL, @Designation NVARCHAR(100) = NULL,
    @MaritalStatus NVARCHAR(20) = NULL, @BloodGroup NVARCHAR(5) = NULL,
    @EmergencyContactName NVARCHAR(100) = NULL, @EmergencyContactPhone NVARCHAR(20) = NULL,
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Employee
    SET EmpName = @EmpName, DeptID = @DeptID, Gender = @Gender, DOB = @DOB,
        JoiningDate = @JoiningDate, IsActive = @IsActive,
        ProfilePic = CASE WHEN @ProfilePic IS NOT NULL THEN @ProfilePic ELSE ProfilePic END,
        ProfilePicName = CASE WHEN @ProfilePicName IS NOT NULL THEN @ProfilePicName ELSE ProfilePicName END,
        Email = @Email, Phone = @Phone, Address = @Address, CNIC = @CNIC,
        Designation = @Designation, MaritalStatus = @MaritalStatus, BloodGroup = @BloodGroup,
        EmergencyContactName = @EmergencyContactName, EmergencyContactPhone = @EmergencyContactPhone,
        ModifiedBy = @UserID, ModifiedDate = GETDATE()
    WHERE EmpID = @EmpID;

    UPDATE Salary
    SET BasicSalary = @BasicSalary, Allowance = @Allowance,
        ModifiedBy = @UserID, ModifiedDate = GETDATE()
    WHERE EmpID = @EmpID;
END
GO

CREATE PROCEDURE sp_Employee_Delete
    @EmpID INT,
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Employee
    SET IsActive = 0, ModifiedBy = @UserID, ModifiedDate = GETDATE()
    WHERE EmpID = @EmpID;
END
GO

-- ================================
-- USER LOGIN PROCEDURE
-- ================================
CREATE PROCEDURE sp_User_Login
    @UsernameOrEmail NVARCHAR(100),
    @Password NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT UserID, Username, Email, Role, EmpID
    FROM Users
    WHERE (Username = @UsernameOrEmail OR Email = @UsernameOrEmail)
      AND PasswordHash = HASHBYTES('SHA2_256', @Password)
      AND IsActive = 1;
END
GO