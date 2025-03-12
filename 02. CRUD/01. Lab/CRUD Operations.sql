SELECT 
	CONCAT_WS (' ', FirstName, MiddleName, LastName) AS [Full Name]
	, JobTitle AS [Job Title]
	, Salary
FROM Employees

SELECT DISTINCT DepartmentID FROM Employees

SELECT 
	LastName
	, DepartmentID
	, Salary
FROM Employees
WHERE 
	Salary <= 20000

SELECT 
	LastName
	, DepartmentID
	, Salary
FROM Employees
WHERE 
	DepartmentID BETWEEN 2 AND 5

	SELECT 
	LastName
	, DepartmentID
	, Salary
FROM Employees
WHERE 
	DepartmentID IN (2, 5)

		SELECT 
	LastName
	, DepartmentID
	, Salary
FROM Employees
WHERE 
	DepartmentID NOT IN (2, 5, 7)

SELECT * FROM Employees  ORDER BY Salary, FirstName

CREATE VIEW v_EmployeesProjection AS 
SELECT 
	CONCAT_WS(' ',FirstName, LastName) AS [Full Name]
	, Salary 
FROM Employees

SELECT * FROM v_EmployeesProjection

SET IDENTITY_INSERT Towns ON;
GO
INSERT INTO Towns(TownID, [Name]) VALUES(33,'Paris')
GO
SET IDENTITY_INSERT Towns OFF;
GO

INSERT INTO Towns ([Name]) VALUES ('Plovdiv');

INSERT INTO Projects
	([Name],StartDate) VALUES
	('Reflective Jacket', GETDATE()),
    ('Hoover board', GETDATE()),
	('Flying saucer', GETDATE())

INSERT INTO Projects
	([Name],StartDate) 
SELECT 'Restructuring of' + [Name], GETDATE() FROM Departments

DELETE FROM Projects WHERE ProjectID > 130

SELECT 
	FirstName
	,LastName
	,Salary
INTO EmploeesSalary
FROM Employees

DROP TABLE EmploeesSalary

UPDATE Employees SET
	FirstName = 'Petar'
	, LastName = 'Petrov'
WHERE EmployeeID = 1

UPDATE Employees SET
	FirstName = 'Guy'
	, LastName = 'Gilbert'
WHERE EmployeeID = 1

UPDATE Projects SET
	EndDate = GETDATE()
WHERE EndDate is NULL