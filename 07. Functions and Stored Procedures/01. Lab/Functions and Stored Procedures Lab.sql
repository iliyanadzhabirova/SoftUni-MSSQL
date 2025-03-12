--CREATE OR ALTER FUNCTION udf_ProjectDuration(@StartDate DATETIME, @EndDate DATETIME)
--RETURNS INT AS
--BEGIN
--	DECLARE @projectDuration INT;
--	IF (@EndDate IS NULL)
--	BEGIN
--	    SET @EndDate = CURRENT_TIMESTAMP
--	  END
--	  SET @projectDuration = DATEDIFF(WEEK,@StartDate, @EndDate);

--	  RETURN @projectDuration;
--END

--SELECT 
--	[Name],
--	[Description],
--	StartDate,
--	EndDate,
--	dbo.udf_ProjectDuration(StartDate, EndDate) AS Duration
--FROM Projects

----------------------------------------------------------------------------------------

--CREATE OR ALTER FUNCTION udf_AverageSalaryForDepartment(@DepartmentName VARCHAR(50))
--RETURNS TABLE AS
--RETURN	SELECT
--	      d.[Name] AS Department,
--		  AVG(e.Salary) AS AverageSalary
--	 FROM Employees AS e JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
--	 WHERE d.[Name] = @DepartmentName
--	 GROUP BY d.DepartmentID, d.[Name];

--SELECT * FROM udf_AverageSalaryForDepartment('Production')

----------------------------------------------------------------------------------------

--CREATE OR ALTER FUNCTION udf_EmployeeListByDepartment(@DepartmentName VARCHAR(100))
--RETURNS @result TABLE(
--	FirstName VARCHAR(50),
--	LastName VARCHAR(50),
--	DepartmentName VARCHAR(50)) AS

--BEGIN
--    WITH EmployeeList_CTE(FirstName, LastName, DepartmentName) AS
--	   (SELECT e.FirstName,
--	           e.LastName,
--			   d.[Name]
--	   FROM Employees AS e JOIN Departments AS d ON e.DepartmentId = d.DepartmentID
--	   WHERE d.[Name] = @DepartmentName) 
	   
--	INSERT INTO @result SELECT Firstname, Lastname, DepartmentName FROM EmployeeList_CTE
--	RETURN
--END

--SELECT * 
--FROM udf_EmployeeListByDepartment('Sales')
--WHERE FirstName LIKE 'S%'
--ORDER BY FirstName, LastName

--------------------------------------------------------------------------------------

--CREATE OR ALTER FUNCTION udf_SalaryLevel(@Salary MONEY)
--RETURNS VARCHAR(10) AS
--BEGIN
--	DECLARE @level VARCHAR(10) = 'Average';
--	IF (@Salary < 30000) SET @level = 'Low';
--	ELSE IF (@Salary > 50000) SET @level = 'High';
--	RETURN @level
--END

--SELECT
--	FirstName,
--	LastName,
--	Salary,
--	dbo.udf_SalaryLevel(Salary) AS SalaryLevel
--FROM Employees

--------------------------------------------------------------------------------------

--CREATE OR ALTER PROC usp_SelectEmployeesBySeniority
--(@YearsOfExperience INT = 5, @MaxYearsOfExperience INT = 24) AS
--SELECT
--	FirstName,
--	LastName,
--	HireDate,
--	DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfExperience
--FROM Employees
--WHERE DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN @YearsOfExperience AND @MaxYearsOfExperience
--ORDER BY HireDate

--GO

--EXEC usp_SelectEmployeesBySeniority 
--@MaxYearsOfExperience = 23,
--@YearsOfExperience = 21

--------------------------------------------------------------------------------------


--CREATE OR ALTER PROCEDURE usp_SumNumbers
--(
--    @FirstNumber INT,
--	@SecondNumber INT,
--	@Result INT OUTPUT
--) AS
--BEGIN
--	SET @Result = @FirstNumber + @SecondNumber
--END

--GO

--DECLARE @answer INT

--EXECUTE usp_SumNumbers 6, 12, @answer OUTPUT

--SELECT CONCAT_WS(' ', 'Sum is:', @answer)

--------------------------------------------------------------------------------------

--CREATE OR ALTER PROCEDURE usp_MultipleResults AS
--BEGIN
--	SELECT * FROM Employees
--	SELECT * FROM Projects
--END

--GO

--EXEC usp_MultipleResults

--------------------------------------------------------------------------------------

BEGIN TRY
 -- Generate a divide-by-zero error.
 SELECT 1/0
END TRY
BEGIN CATCH
 SELECT
 ERROR_NUMBER() AS ErrorNumber
 ,ERROR_SEVERITY() AS ErrorSeverity
 ,ERROR_STATE() AS ErrorState
 ,ERROR_PROCEDURE() AS ErrorProcedure
 ,ERROR_LINE() AS ErrorLine
 ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO--------------------------------------------------------------------------------------
BEGIN TRY
    THROW 50234, 'Unknown Error', 1
END TRY
BEGIN CATCH
 SELECT
 ERROR_NUMBER() AS ErrorNumber
 ,ERROR_SEVERITY() AS ErrorSeverity
 ,ERROR_MESSAGE() AS Erroe
END CATCH
GO

--------------------------------------------------------------------------------------

BEGIN TRY
    SELECT 1/0
END TRY
BEGIN CATCH
END CATCH
SELECT @@Error

GO
