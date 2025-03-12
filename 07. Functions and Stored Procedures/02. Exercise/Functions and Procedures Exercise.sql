
USE 

[SoftUni]

GO

-- Problem 01

--CREATE OR ALTER PROCEDURE [dbo].[usp_GetEmployeesSalaryAbove35000]
--AS (
--			SELECT [FirstName],
--			       [LastName]
--			 FROM  [Employees]
--            WHERE [Salary] > 35000
--   )

--GO

--EXEC [dbo].[usp_GetEmployeesSalaryAbove35000]

-- Problem 02

--CREATE OR ALTER PROCEDURE [dbo].[usp_GetEmployeesSalaryAboveNumber] @minSalary DECIMAL(18, 4)
--   AS
--       (
--		 SELECT [FirstName]	,
--		        [LastName]
--		   FROM [Employees]
--		  WHERE [Salary] >= @minSalary
--       )
--GO

--EXEC [dbo].[usp_GetEmployeesSalaryAboveNumber] 35000
--EXEC [dbo].[usp_GetEmployeesSalaryAboveNumber] 100000

--Problem 03

--CREATE OR ALTER PROCEDURE [dbo].[usp_GetTownsStartingWith] @string VARCHAR(50)
-- AS
--       (
--		 SELECT [Name]	
--		     AS Town
--		   FROM [Towns]
--		  WHERE LEFT(Name,LEN(@string)) = @string
--       )
--GO

--EXEC [dbo].[usp_GetTownsStartingWith]'b'

-- Problem 04

--CREATE OR ALTER PROCEDURE [dbo].[usp_GetEmployeesFromTown] @townName VARCHAR(50)
--     AS 	 
--	    (
--			SELECT [e].[FirstName],
--			       [e].[LastName]
--			  FROM [Employees]
--			    AS [e]
--		 LEFT JOIN [Addresses]
--			    AS [a]
--			    ON [e].[AddressID] = [a].AddressID
--		 LEFT JOIN [Towns]
--		        AS [t]
--				ON [a].[TownID] = [t].[TownID]
--				WHERE [t].[Name] = @townName
--	    )
--GO
 
-- EXEC [dbo].[usp_GetEmployeesFromTown] 'Sofia'
-- EXEC [dbo].[usp_GetEmployeesFromTown] 'Monroe'
-- EXEC [dbo].[usp_GetEmployeesFromTown] 'Bordeaux'
-- EXEC [dbo].[usp_GetEmployeesFromTown] NULL

-- GO

-- Problem 05

--CREATE OR ALTER FUNCTION ufn_GetSalaryLevel (@salary DECIMAL(18,4))
--RETURNS VARCHAR(10) AS
--BEGIN
--	DECLARE @level VARCHAR(10) = 'Average';
--	IF (@salary < 30000) SET @level = 'Low';
--	ELSE IF (@salary > 50000) SET @level = 'High';
--	RETURN @level
--END

--SELECT
--	Salary,
--	dbo.ufn_GetSalaryLevel(salary) AS [Salary Level]
--FROM Employees

-- Problem 06

--CREATE PROC usp_EmployeesBySalaryLevel(@SalaryLevel VARCHAR(10))
--   AS 
--     SELECT FirstName,LastName 
--     FROM Employees 
--     WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

--  GO

--EXEC dbo.usp_EmployeesBySalaryLevel 'High'

 -- Problem 07

-- CREATE OR ALTER FUNCTION [dbo].[ufn_IsWordComprised](@setOfLetters VARCHAR(100), @word VARCHAR(70))
-- RETURNS BIT
--          AS
--	   BEGIN
--	            DECLARE @wordIndex TINYINT = 1;

--				WHILE(@wordIndex <= LEN(@word))
--				BEGIN
--				      DECLARE @currentLetter CHAR(1);
--					  SET @currentLetter = SUBSTRING(@word, @wordIndex, 1);

--					  IF (CHARINDEX(@currentLetter, @setOfLetters) = 0)
--					  BEGIN
--					        RETURN 0;
--					    END
--					 SET @wordIndex += 1;
--				  END
--              RETURN 1 ;
--	     END

--GO

--SELECT [dbo].[ufn_IsWordComprised] ('oistmiahf', 'Sofia')
--SELECT [dbo].[ufn_IsWordComprised] ('oistmiahf', 'halves')
--SELECT [dbo].[ufn_IsWordComprised] ('bobr', 'Rob')
--SELECT [dbo].[ufn_IsWordComprised] ('pppp', 'Guy')

-- Problem 08

--CREATE OR ALTER PROCEDURE [dbo].[usp_DeleteEmployeesFromDepartment] @departmentId INT
--    AS 
-- BEGIN	    -- Detach the relation between EmployeeProject and Employees
--		    DELETE 
--			  FROM [dbo].[EmployeesProjects]
--			 WHERE [EmployeeID] IN (
--			                            SELECT [EmployeeID]
--										  FROM [Employees]
--										 WHERE [DepartmentID] = @departmentId
--			  			  )
--			 -- Detach self-relation in Employees
--			 UPDATE [Employees]
--			    SET [ManagerID] = NULL
--			  WHERE [ManagerID] IN (
--			                            SELECT [EmployeeID]
--										  FROM [Employees]
--										 WHERE [DepartmentID] = @departmentId
--			                        )
--          -- Delete the NOT NULL constraint in ManagerID from Departments to detach the relation Employee-Department
--		  ALTER TABLE [Departments]
--		  ALTER COLUMN [ManagerID] INT NULL
--		  -- Detach the relation between Employee and Department
--		  UPDATE [Departments]
--		     SET [ManagerID] = NULL
--		   WHERE [ManagerID] IN (
--		                            SELECT [EmployeeID]
--									FROM [Employees]
--									WHERE [DepartmentID] = @departmentId
--		                         )
--           -- All relations are detached, we can proceed to deleting Employees
--		   DELETE
--		     FROM [Employees]
--			WHERE [DepartmentID] = @departmentId

--			-- All Employees of the Department are deleted, another relation is detached
--			DELETE
--			  FROM [Departments]
--			 WHERE [DepartmentID] = @departmentId

--			 SELECT COUNT(*)
--			   FROM [Employees]
--			  WHERE [DepartmentID] = @departmentId
--    END	  
							 
--GO

--EXEC [dbo].[usp_DeleteEmployeesFromDepartment] 6

GO 

USE [Bank]

GO

-- Problem 09

--CREATE OR ALTER PROCEDURE usp_GetHoldersFullName 
--    AS
--	SELECT FirstName + ' ' + LastName AS [Full Name] 
--    FROM AccountHolders

--	GO

--EXEC usp_GetHoldersFullName 

-- Problem 10

--CREATE PROC usp_GetHoldersWithBalanceHigherThan (@number DECIMAL(18,4))
--AS
--SELECT
--	ah.FirstName,
--	ah.LastName		
--FROM AccountHolders AS ah
--JOIN
--(
--	SELECT 
--		AccountHolderId,
--		SUM(Balance) AS TotalMoney
--	FROM Accounts
--	GROUP BY AccountHolderId
--) AS a ON ah.Id = a.AccountHolderId

--WHERE a.TotalMoney > @number
--ORDER BY ah.FirstName, ah.LastName


-- Problem 11

--CREATE OR ALTER FUNCTION [dbo].[ufn_CalculateFutureValue](@initialSum DECIMAL(22, 6), @interestRate FLOAT, @years INT)
--RETURNS
--DECIMAL (20, 4)
--     AS
--  BEGIN
--		 DECLARE @futureValue DECIMAL(22, 6);
--		 DECLARE @totalInterest DECIMAL(22, 10 );
--		 SET @totalInterest = POWER((1 + @interestRate), @years);
--		 SET @futureValue = @initialSum * @totalInterest ; 
--		 RETURN ROUND(@futureValue, 4);
--    END

--	GO

--SELECT 
--       [dbo].[ufn_CalculateFutureValue](1000, 0.10, 5)
 
-- Problem 12

--CREATE PROC usp_CalculateFutureValueForAccount (@AccountId INT, @InterestRate FLOAT) AS
--SELECT a.Id AS [Account Id],
--	   ah.FirstName AS [First Name],
--	   ah.LastName AS [Last Name],
--	   a.Balance,
--	   dbo.ufn_CalculateFutureValue(Balance, @InterestRate, 5) AS [Balance in 5 years]
--  FROM AccountHolders AS ah
--  JOIN Accounts AS a ON ah.Id = a.Id
-- WHERE a.Id = @AccountId

-- Problem  13

USE [Diablo]

GO

--CREATE OR ALTER FUNCTION [dbo].[ufn_CashInUsersGames](@gameName NVARCHAR(50))
--RETURNS
--  TABLE
--     AS
--	        RETURN
--                    SELECT SUM ([Cash])
--                        AS [SumCash]
--                      FROM(
                           
--                       SELECT [Cash],
--                              ROW_NUMBER()OVER(ORDER BY [Cash] DESC)
--                    	   AS [RowNumber]
--                         FROM [Games]
--                           AS [g]
--                    LEFT JOIN [UsersGames]
--                           AS [ug]
--                    	   ON [ug].[GameId] = [g].[Id]
--                        WHERE [g].[Name] = @gameName
                    
--                    	)
--                      AS [RowNumberingTempTable]
--                    WHERE [RowNumber] % 2 = 1
	
--SELECT *
--  FROM [dbo].[ufn_CashInUsersGames]('Love in a mist')


