USE SoftUni

GO 

--Problem 01
--Two approaches for solution: (Unclear requirements)
-- 1. Hide Employees which does not have Address(INNER JOIN)
-- 2. Show Employees without Address with NULL Address (LEFT OUTER JOIN )
 SELECT
  TOP(5)
		EmployeeID,
		JobTitle,
		e.AddressID,
		a.AddressText
	FROM Employees
      AS e
         INNER JOIN [Addresses]
	  AS a
	  ON e.AddressID = a.AddressID
ORDER BY e.AddressID

--Problem 02

SELECT TOP 50
		e.FirstName,
		e.LastName,
		t.[Name] AS Town,
		a.AddressText
   FROM Employees AS e
	    JOIN Addresses AS a ON e.AddressID = a.AddressID
	    JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY FirstName, LastName

--Problem 03

SELECT e.EmployeeID,
       e.FirstName,
       e.LastName,
	   d.[Name] AS DepartmentName
FROM Employees AS e
	 JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE D.[Name] = 'Sales'

ORDER BY e.EmployeeID

--Problem 04

    SELECT 
	   TOP (5)
           e.EmployeeID,
		   e.FirstName,
		   e.Salary,
		   d.[Name]
      FROM Employees
        AS e
INNER JOIN Departments
	    AS d
	    ON e.DepartmentID = d.DepartmentID
   	 WHERE e.Salary > 15000
  ORDER BY e.DepartmentID

-- Problem 05 

   SELECT 
      TOP (3)
	      e.EmployeeID,
		  e.FirstName
	 FROM Employees
	   AS e
          LEFT JOIN EmployeesProjects
	   AS ep
   	   ON ep.EmployeeID = e.EmployeeID
    WHERE ep.ProjectID IS NULL
 ORDER BY e.

 --Problem 06

 SELECT e.FirstName,
        e.LastName,
	    e.HireDate,
	    d.[Name] AS DepName
   FROM Employees AS e
	    JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
  WHERE e.HireDate > '1999-01-01'
	    AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.HireDate ASC


 --Problem 07

  SELECT TOP(5)
         ep.EmployeeID,
		 e.FirstName,
		 p.[Name]
	FROM EmployeesProjects
	  AS ep
	     INNER JOIN Employees 
	  AS e
	  ON ep.EmployeeID = e.EmployeeID
	     INNER JOIN Projects
	  AS p
	  ON ep.ProjectID = p.ProjectID
   WHERE p.StartDate > '08/13/2002'
         AND
		 p.EndDate IS NULL
ORDER BY ep.EmployeeID

--Problem 08

SELECT e.EmployeeID,
       e.FirstName,
  CASE 
   WHEN p.StartDate > '01/01/2005' THEN NULL
   ELSE p.[Name]
  END 
  FROM Employees AS e
       INNER JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
       INNER JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

--Problem 09

  SELECT e1.EmployeeID,
         e1.FirstName,
		 e1.ManagerID,
		 e2.FirstName
	  AS ManagerName
    FROM Employees
      AS e1
         LEFT JOIN Employees
      AS e2
      ON e1.ManagerID = e2.EmployeeID
   WHERE e1.ManagerID IN (3,7)
ORDER BY e1.EmployeeID

-- Provlem 10

SELECT TOP 50
            e.EmployeeID,
            e.FirstName + ' ' + e.LastName   
        AS [EmployeeName],
            m.FirstName + ' ' + m.LastName 
        AS [ManagerName],
           d.[Name]                         
        AS [DepartmentName]
      FROM Employees AS e
           INNER JOIN Employees m
        ON e.ManagerID = m.EmployeeID
           INNER JOIN Departments d
        ON e.DepartmentID = d.DepartmentID
  ORDER BY e.EmployeeID

-- Problem 11

SELECT TOP 1
	AVG (Salary) AS MinAverageSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY 1

-- Problem 12

SELECT mc.CountryCode ,
       m.MountainRange, 
	   p.PeakName, 
	   p.Elevation
FROM Mountains AS m
INNER JOIN Peaks AS p ON m.Id = p.MountainId
INNER JOIN MountainsCountries AS mc ON m.Id = mc.MountainId
WHERE p.Elevation > 2835
AND mc.CountryCode = 'BG'
ORDER BY Elevation DESC


-- Problem 13

GO 

USE Geography

GO

  SELECT c.CountryCode,
         COUNT(mc.MountainId)
      AS MountainRanges
    FROM Countries
      AS c
         LEFT JOIN MountainsCountries
      AS mc
	  ON mc.CountryCode = c.CountryCode 
   WHERE c.CountryName IN ('United States', 'Russia','Bulgaria')
GROUP BY c.CountryCode

-- Problem 14

SELECT TOP (5)
        c.CountryName,
        r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r ON cr.RiverId = r.Id

WHERE ContinentCode = 'AF'
ORDER BY c.CountryName

-- Problem 15

SELECT ContinentCode,
       CurrencyCode,
	   CurrencyUsage
  FROM
   (
         SELECT*,
                  DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY CurrencyUsage DESC)
               AS CurrencyRank
             FROM (
           SELECT cn.ContinentCode,
                  c.CurrencyCode,
		          COUNT(c.CurrencyCode)
	           AS CurrencyUsage 
             FROM Continents
               AS cn
                  LEFT JOIN Countries
               AS c
               ON c.ContinentCode = cn.ContinentCode
         GROUP BY cn.ContinentCode,
		          c.CurrencyCode
           HAVING COUNT (c.CurrencyCode) > 1

                  )
               AS CurrencyUsageTable
  )
        AS CurrencyRankingTempTable
     WHERE CurrencyRank = 1
  ORDER BY ContinentCode

-- Problem 16

SELECT 
     COUNT(c.CountryCode) AS [Count]

FROM Countries AS c

LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode

WHERE MountainId IS NULL


-- Problem 17

  SELECT 
     TOP(5) 
      c.CountryName, 
	  MAX(p.Elevation) AS [HighestPeakElevation], 
	  MAX(r.Length) AS [LongestRiverLength]
    FROM Countries AS c
       LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
       LEFT JOIN Peaks AS p ON mc.MountainId = p.MountainId
       LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
       LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
GROUP BY c.CountryName
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, c.CountryName


-- Problem 18
 SELECT 
    TOP (5)
         [CountryName]
      AS [Country],
	    ISNULL([PeakName], '(no highest peak)')
     AS [Highest Peak Name],
	    ISNULL([Elevation], 0)
	 AS [Highest Peak Elevation],
	    ISNULL ([MountainRange], '(no mountain)')
	 AS [Mountain]
   FROM (

                 SELECT c.CountryName,
                        p.PeakName,
                		p.Elevation,
                		m.MountainRange,
                		DENSE_RANK() OVER (PARTITION BY c.CountryName ORDER BY p.Elevation DESC)
                	 AS PeakRank
                   FROM Countries
                     AS c
                LEFT JOIN MountainsCountries
                     AS mc
                	 ON mc.CountryCode = c.CountryCode
                LEFT JOIN Mountains
                     AS m
                	 ON mc.MountainId = m.Id
                LEFT JOIN Peaks
                     AS p
                	 ON p.MountainId = m.Id
		)
	  AS PeakRankingTempTable
   WHERE PeakRank = 1
   ORDER BY Country,
   [Highest Peak Name]