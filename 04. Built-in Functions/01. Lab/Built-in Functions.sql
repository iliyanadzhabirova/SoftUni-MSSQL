
USE SoftUni

GO

----------------------

SELECT 
	DepartmentID,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary DESC)
OVER (PARTITION BY DepartmentID) AS MedianCont

FROM Employees

----------------------

SELECT 
	DepartmentID,
	EmployeeID, FirstName, Salary,
	RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
FROM Employees

SELECT FirstName, Salary
FROM Employees
ORDER BY Salary DESC

----------------------

SELECT 
	DepartmentID,
	EmployeeID, FirstName, Salary,
	ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
FROM Employees

----------------------

SELECT 
	DepartmentID,
	EmployeeID, FirstName, Salary,
	DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS Rank
FROM Employees

---------------------- 

SELECT FirstName + ' ' + LastName
 AS [Full Name]
 FROM Employees

---------------------- 

SELECT CONCAT(FirstName, ' ', LastName)
 AS [Full Name]
 FROM Employees

----------------------

SELECT CONCAT_WS('-', FirstName, LastName) -- Concat with separator
 AS [Full Name]
 FROM Employees

 ----------------------

 SELECT LTRIM(' Iliyana')

 SELECT LEN('Iliyana !')

 SELECT DATALENGTH('Iliyana !')

 SELECT LEFT('Iliyana !', 3)

 SELECT RIGHT('Iliyana !', 3)

 SELECT UPPER('Iliyana !')

 SELECT LOWER('Iliyana !')

 SELECT REVERSE('Iliyana !')

 SELECT REPLICATE('Iliyana !', 5)

 ----------------------

 SELECT LEFT ('1546789245631548', 6) + '**********'

 ----------------------

  CREATE VIEW V_EmployeesSalaries2 AS(
	SELECT FirstName, LastName, Salary
	FROM Employees  
  )

 ----------------------

 SELECT CHARINDEX('a', 'Iliyana')

 SELECT CHARINDEX(' ', 'Iliyana e top', 5)

 SELECT STUFF('Iliyana e top', 11, 3, 'KKK')

 ----------------------

 SELECT 33.0 / 2

 SELECT 33 / 2

 SELECT RAND()

 SELECT CEILING(RAND()*48 +1)

 ----------------------

 SELECT DATEPART (DAYOFYEAR, '2021-08-11')

 SELECT DATEDIFF(DAY, '2000-01-01 ', GETDATE())

 SELECT DATEDIFF(SECOND, '2000-01-01 ', GETDATE())

 SELECT DATENAME(WEEKDAY, '2000-01-01 ')

 SELECT DATENAME(WEEKDAY, DATEADD(DAY, 5, '2025-01-01'))

 SELECT EOMONTH ('2024-02-05')

 SELECT CONVERT(VARCHAR, GETDATE(),1)

 SELECT CONVERT(VARCHAR, GETDATE(),3) 

 SELECT CONVERT(VARCHAR, GETDATE(),120) 

 ----------------------

SELECT FirstName,
		ISNULL(MiddleName, 'Empty'),
		LastName
FROM Employees

SELECT 
		[Name], StartDate,
		ISNULL(CAST(EndDate AS VARCHAR), 'Not finished')
FROM Projects

SELECT 
		[Name], StartDate,
		ISNULL(CONVERT(VARCHAR, EndDate, 120), 'Not finished')
FROM Projects

 ----------------------

SELECT * FROM Employees
ORDER BY EmployeeID
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY

 ----------------------

 SELECT * FROM 
 Employees	
 WHERE FirstName LIKE 'K%' -- starts with K, % - 0 or more symbols, any symbol 

 SELECT * FROM 
 Employees	
 WHERE FirstName LIKE '%a' -- % - 0 or more symbols, last one is a

 SELECT * FROM 
 Employees	
 WHERE FirstName LIKE '%ee%' -- 0 or more symbols, then 'ee' , 0 or more symbols

 SELECT * FROM 
 Employees	
 WHERE FirstName LIKE 'K___' -- _ - exactly one symbol

 SELECT * FROM 
 Employees	
 WHERE FirstName LIKE '[CK]%' -- [CK] - either C or K - 1 symbol

SELECT * FROM 
 Employees	
 WHERE FirstName LIKE '[^KC]%' -- [^KC] - all but K and C symbol

