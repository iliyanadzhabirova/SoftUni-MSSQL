USE [SoftUni]

GO

-- Problem 01
-- 1st way - Use LEFT()built-in function
-- 2nd way - Use a wildcard

SELECT FirstName,
	   LastName
  FROM Employees
 WHERE [FirstName] LIKE 'Sa%'

-- Problem 02

SELECT FirstName,
	   LastName
  FROM Employees
 WHERE [LastName] LIKE '%ei%'

-- Problem 03

SELECT [FirstName] 
  FROM Employees
 WHERE DepartmentID IN (3, 10) 
       AND (YEAR([HireDate])) BETWEEN 1995 AND 2005

-- Problem 04

SELECT FirstName,
	   LastName
  FROM Employees
 WHERE CHARINDEX('engineer', JobTitle) = 0

-- Problem 05

   SELECT [Name]
     FROM Towns
    WHERE LEN([Name]) IN (5,6)
 ORDER BY [Name]

-- Problem 06

  SELECT *
    FROM [Towns]
   WHERE LEFT([Name],1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name]

-- Problem 07

SELECT *
    FROM [Towns]
    WHERE LEFT([Name],1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]

-- Problem 08
GO

CREATE VIEW [v_EmployeesHiredAfter2000]

	AS
	   (
	      SELECT  [FirstName],
				  [LastName]
           FROM Employees
	      WHERE (YEAR([HireDate])) > 2000       

       )

GO

-- Problem 09

          SELECT  [FirstName],
				  [LastName]
           FROM Employees
	      WHERE (LEN([LastName])) = 5    

-- Problem 10

  SELECT [EmployeeID],
         [FirstName],
	     [LastName],
	     [Salary],
	     DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID])
	  AS [Rank]
    FROM Employees
   WHERE [Salary] BETWEEN 10000 AND 50000
ORDER BY [Salary] DESC

-- Problem 11

GO

CREATE VIEW [v_EmployeesRankedByEmployeeID]

	AS
	   (
	       SELECT [EmployeeID],
				  [FirstName],
				  [LastName],
	              [Salary],
	              DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID])
	           AS [Rank]
             FROM Employees
            WHERE [Salary] BETWEEN 10000 AND 50000
       )

GO

  SELECT *
    FROM [dbo].[v_EmployeesRankedByEmployeeID]
   WHERE [Rank] = 2
ORDER BY [Salary] DESC

-- Second way to solve the problem

SELECT *
    FROM 
	( 
	       SELECT [EmployeeID],
				  [FirstName],
				  [LastName],
	              [Salary],
	              DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID])
	           AS [Rank]
             FROM Employees
            WHERE [Salary] BETWEEN 10000 AND 50000	
	)
	  AS [e]
   WHERE [Rank] = 2
ORDER BY [Salary] DESC

GO

USE [Geography]

GO

-- Problem 12

SELECT CountryName,
       IsoCode AS [ISO Code]
FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode;

-- Problem 13

  SELECT [p].[PeakName],
	     [r].[RiverName],
	     LOWER(CONCAT (SUBSTRING([p].[Peakname], 1 , LEN([p].[PeakName]) - 1), [r].[RiverName]))
      AS [Mix]
    FROM [Peaks]
      AS [P],
         [Rivers]
      AS [r]
   WHERE RIGHT([p].[PeakName], 1) = LEFT([r].[RiverName], 1)
ORDER BY [Mix]

-- Problem 14
GO

USE Diablo

GO

SELECT TOP (50)
    [Name],
    FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM [Games]
WHERE YEAR([Start]) IN (2011, 2012)
ORDER BY [Start], [Name];

-- Problem 15

GO

USE [Diablo]

GO

  SELECT [Username],
         SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email]) - CHARINDEX('@', [Email]))
      AS [Email Provider]
    FROM [Users] 
ORDER BY [Email Provider], [Username]

-- Problem 16

SELECT [Username],
       [IpAddress]
FROM Users
WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [Username]

-- Problem 17

  SELECT [g].[Name],
	     CASE 
	          WHEN DATEPART(HOUR, [g].[Start]) BETWEEN 0 AND 11 THEN 'Morning'
			  WHEN DATEPART(HOUR, [g].[Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
		   	  ELSE 'Evening'
	     END
	  AS [Part of the Day] ,
	     CASE 
			  WHEN [g].[Duration] <= 3 THEN 'Extra Short'
			  WHEN [g].[Duration] BETWEEN 4 AND 6 THEN 'Short'
			  WHEN [g].[Duration] > 6 THEN 'Long'
			  ELSE 'Extra Long'
		  END
      AS [Duration]
    FROM [Games]
      AS [g]
ORDER BY [g].[Name],
         [Duration], 
		 [Part of the Day]

-- Problem 18

CREATE DATABASE Orders

USE Orders

CREATE TABLE Orders (
  Id INT,
  ProductName VARCHAR(100),
  OrderDate DATETIME
);

INSERT INTO Orders (Id, ProductName, OrderDate)
VALUES
  (1, 'Butter', '2016-09-19 00:00:00'),
  (2, 'Milk', '2016-09-30 00:00:00'),
  (3, 'Cheese', '2016-09-04 00:00:00'),
  (4, 'Bread', '2015-12-20 00:00:00'),
  (5, 'Tomatoes', '2015-01-01 00:00:00');

SELECT
  ProductName,
  OrderDate,
  DATEADD(day, 3, OrderDate) AS PayDueDate,  
  DATEADD(month, 1, OrderDate) AS DeliverDueDate  
FROM
  Orders;

-- Problem 19

CREATE TABLE People (
  Id INT,
  [Name] VARCHAR(100),
  Birthdate DATETIME
);

INSERT INTO People (Id, [Name], Birthdate)
VALUES
  (1, 'Victor', '2000-12-07 00:00:00.000'),
  (2, 'Steven', '1992-09-10 00:00:00.000'),
  (3, 'Stephen', '1910-09-19 00:00:00.000'),
  (4, 'John', '2010-01-06 00:00:00.000');

  SELECT
  Name,
  -- Age in Years
  DATEDIFF(YEAR, Birthdate, GETDATE()) - CASE
    WHEN (MONTH(Birthdate) > MONTH(GETDATE())) OR 
         (MONTH(Birthdate) = MONTH(GETDATE()) AND DAY(Birthdate) > DAY(GETDATE()))
    THEN 1 ELSE 0 END AS [Age in Years],
  -- Age in Months
  DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age in Months],
  -- Age in Days
  DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age in Days],
  -- Age in Minutes
  DATEDIFF(MINUTE, Birthdate, GETDATE()) AS [Age in Minutes]
FROM
  People;