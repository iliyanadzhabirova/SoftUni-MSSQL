USE 

SoftUni

GO

--------------------------------

  SELECT DepartmentID ,
         SUM(Salary) AS TotalSalary
    FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--------------------------------

SELECT 
     d.[Name],
	 STRING_AGG(CONCAT_WS(' ',e.FirstName, e.LastName), ', ')
     WITHIN GROUP (ORDER BY e.FirstName, e.LastName) AS EmployeeList
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
--WHERE d.[Name] = 'Sales'
GROUP BY d.DepartmentID, d.[Name]
ORDER BY d.[Name]

--------------------------------

SELECT dt.DepartmentName, dt.EmployeeCount FROM
(SELECT
    d.[Name] AS DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.[Name] ) AS dt

WHERE dt.EmployeeCount > 10

--------------------------------
-- Better way to solve the problem using HAVING

SELECT
    d.[Name] AS DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.[Name]
HAVING COUNT(e.EmployeeID) > 10

--------------------------------
SELECT
    d.[Name] AS DepartmentName,
    SUM(e.Salary) AS TotalSalary
FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID, d.[Name]
HAVING SUM(e.Salary) >= 150000

