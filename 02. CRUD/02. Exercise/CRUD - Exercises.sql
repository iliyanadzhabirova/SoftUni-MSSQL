USE [SoftUni]

GO

--Problem 02
-- * <=> All columns in the Table

SELECT * 
  FROM [Departments] 

--Problem 03

SELECT [Name]
  FROM [Departments]

--Problem 04
SELECT [FirstName],
       [Lastname],
	   [Salary]
  FROM [Employees]

--Problem 05
-- SELECT reads mentioned columns in the eaxct same order

SELECT [FirstName]
     , [MiddleName]
	 , [LastName]
  FROM [Employees]

--Problem 06
--Concatenation of texts - process of summing texts with operator (+) and the result is joined texts.
--Email Address = FirstName.LastName@softuni.bg
--You can use the built-in function for text concatenation

SELECT [FirstName] + '.' + [LastName] + '@softuni.bg'
    AS [Full Email Address]
  FROM [Employees]

-- Second possible way

SELECT CONCAT(
       [FirstName], 
	   '.', 
	   [LastName], 
	   '@softuni.bg')
    AS [Full Email Address]
  FROM [Employees]

--Problem 07

   SELECT 
 DISTINCT [Salary]
     FROM [Employees]

--Problem 08
-- WHERE  is SQL Command for applying filters
-- To remember: WHERE is always written AFTER "FROM" and BEFORE "ORDER BY" !!!
-- Also keep in mind: The order of writing does not match the order od execution!!!
-- Due to different execution order , you can use column for filtering which is NOT selected

SELECT *
  FROM [Employees]
  WHERE [JobTitle] = 'Sales Representative'

--Problem 09
-- SQL Based Solution
-- To remember: BETWEEN operator is inclusive!!! -> values 20000 and 30000are included in the filtered data
SELECT [FirstName],
	   [LastName],
	   [JobTitle]
 FROM [Employees]
WHERE [Salary] BETWEEN 20000 AND 30000

-- General Based Solution
-- Salary in interval between 20000 and 30000 <=> 1. Salary greater or equal to 20000
--                                                2. Salary less or equal to 30000	
SELECT [FirstName],
	   [LastName],
	   [JobTitle]
 FROM [Employees]
WHERE [Salary] >= 20000 
      AND 
	  [Salary] <= 30000

--Problem 10
-- NULL values are problem 
-- ISNULL(param, replacement) -> checks if the param is NULL and if so, it returns passed replacement. If not, it returns passed param.

SELECT [FirstName] + ' ' + ISNULL([MiddleName], '') + ' ' + [LastName]
    AS [Full Name]
	FROM [Employees]
	WHERE [Salary] IN (25000, 14000, 12500, 23600)

-- CONCAT() function can work with NULL values. BY default NULL values are replaced with empty text (string).

SELECT CONCAT([FirstName], ' ', [MiddleName], ' ', [LastName])
    AS [Full Name]
  FROM [Employees]
 WHERE [Salary] IN (25000, 14000, 12500, 23600)  

 -- The problem we see for a real scenario is that there is doubled space when the MiddleName is NULL
 -- This problem can be solved by using the built-in function CONCAT_WS()

 SELECT CONCAT_WS (' ', [FirstName], [MiddleName], [LastName])
    AS [FullName]
  FROM [Employees]
 WHERE [Salary] IN (25000, 14000, 12500, 23600)
 
 -- IN () from the SQL <=> [Salary] = Value1 OR 2. [Salary] = Value2 OR ... OR [Salary] = ValueN

 --Problem 11
 -- To remember: To check if the Column is equal to NULL we do not use the "is equal to" operator (=)
 -- For NULL checking in SQL use operators IS and IS NOT 

 SELECT [FirstName], [LastName]
   FROM [Employees]
  WHERE [ManagerID] IS NULL

--Problem 12
SELECT [FirstName], 
       [LastName],
	   [Salary]
   FROM [Employees]
  WHERE [Salary] > 50000
  ORDER BY [Salary] DESC

--Problem 13
--ORDER BY - SQL Command for SORT by given criteria, supports ASC/DESC order and by default the order is ASC 
-- To remember: ORDER BY is written after WHERE commands, but is executed after/simultenious with the SELECT
-- To remember: Despite that ORDER BY is executed after SELECT, ORDER BY can work with columns that are not selected 
-- To remember: Thanks to the execution order, ORDER BY can sort based on newly created columns 

SELECT TOP (5)
		   [FirstName],
		   [LastName]
      FROM [Employees]
 ORDER BY  [Salary] DESC

-- You can't add more than one WHERE clause in the SQL query
-- You  can combine several logical expressions using logic operators AND (Intersection), OR (Union) and NOT 

--Problem 14

SELECT [FirstName], 
       [LastName]
   FROM [Employees]
  WHERE [DepartmentID] != 4
 
--Problem 15

  SELECT * 
    FROM [Employees]
ORDER BY [Salary]     DESC,
         [FirstName]  ASC,
		 [LastName]   DESC,
		 [MiddleName] ASC
--Problem 16
CREATE
  VIEW [V_EmployeesSalaries]
    AS (
	     SELECT [FirstName],
	             [Lastname],
			     [Salary]	 
						
           FROM  [Employees]
	   )
SELECT*
FROM [dbo].[V_EmployeesSalaries]

--Problem 17
-- Views are named and saved SELECT queries

CREATE
  VIEW [V_EmployeeNameJobTitle]
    AS (
	     SELECT CONCAT(
	                     [FirstName],
	                     ' ',
	                     [MiddleName],
	                     ' ',
	                     [Lastname]
						 
						)
                 AS  [Full Name],
                     [JobTitle]
               FROM  [Employees]
	   )

SELECT*
FROM [dbo].[V_EmployeeNameJobTitle]

--Problem 18
  SELECT 
DISTINCT[JobTitle]
    FROM [Employees]

--Problem 19

SELECT TOP (10) *
      FROM [Projects]
  ORDER BY [StartDate],
           [Name]

--Problem 20
SELECT TOP (7) 
		   [FirstName],
		   [LastName],
           [HireDate]
      FROM [Employees]
  ORDER BY [HireDate] DESC
         

 
--Problem 21
-- There is quick operators (+=, -=, *=, /=) -> Add to, Subtract from, Multiply by and Divide by  
-- x += y <=> x = x + y
-- x -= y <=> x = x - y
-- [Salary] += (0.12 * [Salary]) <=> [Salary] = [Salary] + (0.12 * [Salary])
SELECT*
  FROM [Departments]

UPDATE [Employees]
   SET [Salary] += (0.12 * [Salary]) --Increase by 12%
 WHERE [DepartmentID] IN (1, 2, 4, 11)

 SELECT [Salary]
   FROM [Employees]

--Problem 22
GO

USE [Geography]

GO

  SELECT [PeakName]  
    FROM [Peaks]
ORDER BY[PeakName]

--Problem 23

SELECT TOP (30)
[CountryName],
[Population]
FROM [Countries]
WHERE [ContinentCode] = 'Eu'
ORDER BY [Population] DESC, [CountryName] 

SELECT * FROM [Countries]
--Problem 24

GO

USE [Geography]

GO

SELECT [CountryName],
       [CountryCode],
	     CASE
	         WHEN [CurrencyCode] = 'EUR' THEN 'Euro'
		     ELSE 'Not Euro'
	     END
	  AS [Currency]
    FROM [Countries]
ORDER BY [CountryName]

--Problem 25

GO

USE [Diablo]

GO

  SELECT [Name]
    FROM [Characters]
ORDER BY [Name]