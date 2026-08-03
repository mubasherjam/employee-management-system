-- Sample departments
INSERT INTO Department (DeptName, CreatedBy, CreatedDate) VALUES 
('HR', 1, GETDATE()), 
('IT', 1, GETDATE()), 
('Finance', 1, GETDATE()), 
('Operations', 1, GETDATE());
GO

-- Default admin login (username: admin, password: Admin@123)
-- IMPORTANT: change this password after first login in any real deployment
INSERT INTO Users (Username, Email, PasswordHash, Role)
VALUES ('admin', 'admin@company.com', HASHBYTES('SHA2_256', N'Admin@123'), 'Admin');
GO