-- Problem 01

SELECT COUNT(Id)
  FROM 
WizzardDeposits

-- Problem 02
SELECT MAX (MagicWandSize)
  FROM WizzardDeposits

--Problem 03

GO

USE [Gringotts]

GO

  SELECT [DepositGroup],
         MAX([MagicWandSize]) 
	  AS [LongestMagicWand]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]

--Proof of the grouping

  SELECT 
DISTINCT [DepositGroup]
    FROM [WizzardDeposits]

-- Problem 04

SELECT 
   TOP (2) 
         [DepositGroup]
    FROM [WizzardDeposits]
GROUP BY DepositGroup
ORDER BY AVG([MagicWandSize])

-- Problem 05

SELECT [DepositGroup],
       SUM([DepositAmount])
  AS [TotalSum]  
FROM [WizzardDeposits]
GROUP BY [DepositGroup]

-- Problem 06

  SELECT [DepositGroup],
         SUM([DepositAmount])
	  AS [TotalSum]  
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]


-- Problem 07

  SELECT [DepositGroup],
         SUM([DepositAmount])
	  AS [TotalSum]
    FROM [WizzardDeposits]
   WHERE  [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]
  HAVING SUM([DepositAmount]) < 150000
ORDER BY [TotalSum] DESC

-- Problem 08

  SELECT [DepositGroup],
         [MagicWandCreator],
		 MIN([DepositCharge])
	  AS [MinDepositCharge]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup],
         [MagicWandCreator]
ORDER BY [MagicWandCreator],
         [DepositGroup]

-- Problem 09

SELECT [AgeGroup],
       COUNT(*)
	AS [WizardsCount]
  FROM
     (
       SELECT *,
             CASE 
       			WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
       			WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
       			WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
       			WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
       			WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
       			WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
       			WHEN [Age] > 60 THEN '[61+]'
       		END
         AS [AgeGroup]
       FROM [WizzardDeposits]

      )

      AS [AgeGroupTempTable]
GROUP BY [AgeGroup]

-- Second way to solve the problem

SELECT CASE 
       	   WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
       	   WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
       	   WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
       	   WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
       	   WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
       	   WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
       	   WHEN [Age] > 60 THEN '[61+]'
      END
       AS [AgeGroup],
          COUNT(*)
       AS [WizzardsCount]
     FROM [WizzardDeposits]
 GROUP BY
 (
  CASE 
       	   WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
       	   WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
       	   WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
       	   WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
       	   WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
       	   WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
       	   WHEN [Age] > 60 THEN '[61+]'
       END
 )
-- Problem 10

  SELECT LEFT(FirstName, 1) AS FirstLetter
    FROM WizzardDeposits
   WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)
ORDER BY FirstLetter

-- Problem 11

  SELECT DepositGroup,
         IsDepositExpired,
         AVG(DepositInterest)
    FROM WizzardDeposits
   WHERE DepositStartDate > '01/01/1985'
GROUP BY DepositGroup,
         IsDepositExpired
ORDER BY DepositGroup DESC,
         IsDepositExpired;

--Problem 12
SELECT SUM ([Difference])
    AS [SumDifference]
  FROM
      (
         SELECT [wd1].[FirstName]
    	     AS [Host Wizard],
                [wd1].[DepositAmount]
             AS [Host Deposit],
    		    [wd2].[FirstName]
    		 AS [Guest Wizard],
    		    [wd2].[DepositAmount]
    		 AS [Guest Deposit],
    		    [wd1].[DepositAmount] - [wd2].[DepositAmount]
    		 AS [Difference]
           FROM [WizzardDeposits]
             AS [wd1]
    INNER JOIN  [WizzardDeposits]
             AS [wd2]
    		 ON [wd2].[Id] = [wd1].[Id] + 1
	     )
   AS [HostGuestWizardTempTable]

-- Second way to solve the problem
SELECT SUM([Difference])
    AS [SumDifference]
  FROM
(
    SELECT [FirstName]
        AS [Host Wizard],
      	   [DepositAmount]
      	AS [Host Deposit],
      	   LEAD([FirstName]) OVER(ORDER BY [Id])
      	AS [Guest Wizard],
      	   LEAD([DepositAmount]) OVER (ORDER BY [Id]) 
      	AS [Guest Deposit],
      	   [DepositAmount] - LEAD([DepositAmount]) OVER (ORDER BY [Id]) 
      	AS [Difference]
      FROM [WizzardDeposits]
  )
AS [HostGuestWizardTempTable]

-- Problem 13

GO

USE SoftUni

GO

SELECT DepartmentID,
       SUM([Salary])
	    AS TotalSalary
FROM Employees
GROUP BY DepartmentID

-- Problem 14

  SELECT DepartmentID,
         MIN(Salary)
      AS MinimumSalary
    FROM Employees

   WHERE DepartmentID IN (2,5,7) AND HireDate > '01/01/2000'
GROUP BY DepartmentID


-- Problem 15

GO

USE [SoftUni]

GO

-- SELECT INTO does NOT take the PK's, FK's and CONSTRAINTs

SELECT *
  INTO
	   [EmployeesWithHighSalary]
  FROM [Employees]
 WHERE [Salary] > 30000

DELETE 
  FROM [EmployeesWithHighSalary]
 WHERE [ManagerID] = 42

 UPDATE [EmployeesWithHighSalary]
    SET [Salary] += 5000
  WHERE [DepartmentID] = 1

  SELECT [DepartmentID],
         AVG([Salary])
	  AS [AverageSalary]
    FROM [EmployeesWithHighSalary]
GROUP BY [DepartmentID]

-- Problem 16

  SELECT [DepartmentID],
         MAX([Salary])
	  AS [Mazsalary]
	FROM [Employees]
GROUP BY [DepartmentID]
  HAVING MAX([Salary]) NOT BETWEEN 30000 AND 70000

-- Problem 17

SELECT COUNT(Salary) 
  FROM Employees
 WHERE ManagerID IS NULL

-- Problem 18
SELECT [DepartmentID],
       [Salary]
  AS   [ThirdHighestSalary]
FROM   (

         SELECT [DepartmentID],
                [Salary],
                 DENSE_RANK() OVER(PARTITION BY [DepartmentID] ORDER BY [Salary] DESC)
	         AS [SalaryRank]
	       FROM [Employees]
	    )
      AS [SalaryRankTempTable]
   WHERE [SalaryRank] = 3
GROUP BY [DepartmentID], [Salary]

-- Problem 19

SELECT 
   TOP (10)
       [e1].[FirstName],
	   [e1].[LastName],
	   [e1].[DepartmentID]
  FROM [Employees]
    AS [e1]
 WHERE [e1].[Salary] >

       (
		 SELECT AVG([e2].[Salary])
        	 AS [AvgSalary]
           FROM [Employees]
		     AS [e2]
          WHERE [e2].[DepartmentID] = [e1].[DepartmentID]
		 		 
	    )
 ORDER BY [e1].[DepartmentID] 



