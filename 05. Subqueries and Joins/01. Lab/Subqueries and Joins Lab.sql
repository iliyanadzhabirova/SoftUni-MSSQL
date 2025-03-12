SELECT 
	e.EmployeeID,
	e.FirstName,
	e.LastName,
	d.[Name]
FROM Departments AS d
LEFT JOIN Employees AS e ON e.DepartmentID = d.DepartmentID AND d.DepartmentID = 3 

--------------------------

 SELECT TOP 50
		e.FirstName,
		e.LastName,
		t.[Name] AS Town,
		a.AddressText
   FROM Employees AS e
	    JOIN Addresses AS a ON e.AddressID = a.AddressID
	    JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY FirstName, LastName

--------------------------

SELECT e.EmployeeID,
       e.FirstName,
       e.LastName,
	   d.[Name] AS DepartmentName
FROM Employees AS e
	 JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE D.[Name] = 'Sales'

ORDER BY e.EmployeeID

--------------------------

 SELECT e.FirstName,
        e.LastName,
	    e.HireDate,
	    d.[Name] AS DepName
   FROM Employees AS e
	    JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
  WHERE e.HireDate > '1999-01-01'
	    AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.HireDate ASC

--------------------------

SELECT TOP 50 
    e.EmployeeID,
	CONCAT_WS(' ', e.FirstName, e.LastName) AS EmployeeName,
	CONCAT_WS(' ', m.FirstName, m.LastName) AS ManagerName,
	d.[Name] AS DepartmentName
FROM Employees As e
	JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
	JOIN Employees AS m ON d.ManagerID = m.EmployeeID
ORDER BY e.EmployeeID ASC

--------------------------

SELECT *
FROM Employees
WHERE DepartmentID IN
	(SELECT
		DepartmentID
	FROM Departments
	WHERE [Name] = 'Finance');

--------------------------

SELECT TOP 1
	AVG (Salary) AS MinAverageSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY 1
--------------------------

CREATE TABLE #Empl
(
Id INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50),
Address VARCHAR(50)
)
SELECT * FROM #Empl

INSERT INTO #Empl
SELECT
	e.EmployeeID,
	e.FirstName,
	e.LastName,
	a.AddressText
FROM Employees AS e
	JOIN Addresses AS a ON e.AddressID = a.AddressID;

DELETE FROM #Empl WHERE Id > 20;

--------------------------

WITH CTE_Employees([First Name], [Last Name], [Department Name]) AS
    (SELECT
	e.FirstName,
	e.LastName,
	d.[Name]
    FROM Employees AS e
	JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
 )

 SELECT * FROM CTE_Employees; 
	