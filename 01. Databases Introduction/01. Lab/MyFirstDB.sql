/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[Title]
      ,[Author]
      ,[Description]
  FROM [MyFirstDB].[dbo].[Books]

   SELECT * FROM Books WHERE [Description] IS NULL

  UPDATE Books SET Description = 'Най-добрата пародия'WHERE Id=2

  INSERT INTO Books (Title,Auhor) VALUES ('Time void', 'Peter Hamilton')

  SELECT 
  Author,
  Title
  FROM Books
  WHERE Id>1
