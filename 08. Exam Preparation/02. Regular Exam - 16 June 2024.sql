CREATE DATABASE LibraryDb

USE LibraryDb

GO

-- Problem 01

CREATE TABLE Genres(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(30) NOT NULL
);

CREATE TABLE Contacts(
Id INT PRIMARY KEY IDENTITY,
Email NVARCHAR(100) ,
PhoneNumber NVARCHAR(20) ,
PostAddress NVARCHAR(200) ,
Website NVARCHAR(50) 
);

CREATE TABLE Authors(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(100) NOT NULL,
ContactId INT NOT NULL FOREIGN KEY REFERENCES Contacts(Id) 
);

CREATE TABLE Libraries(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(50) NOT NULL,
ContactId INT NOT NULL FOREIGN KEY REFERENCES Contacts(Id) 
);

CREATE TABLE Books(
Id INT PRIMARY KEY IDENTITY,
Title NVARCHAR(100) NOT NULL,
YearPublished INT NOT NULL,
ISBN NVARCHAR(13) UNIQUE NOT NULL,
AuthorId INT NOT NULL FOREIGN KEY REFERENCES Authors(Id) ,
GenreId INT NOT NULL FOREIGN KEY REFERENCES Genres(Id)
);

CREATE TABLE LibrariesBooks(
	LibraryId INT NOT NULL FOREIGN KEY REFERENCES Libraries(Id),
	BookId INT NOT NULL FOREIGN KEY REFERENCES Books(Id),
	PRIMARY KEY ([LibraryId], [BookId])
)

---- Problem 02

--SET IDENTITY_INSERT Contacts ON;

--INSERT INTO Contacts (Id, [Email], [PhoneNumber], [PostAddress], [Website]) VALUES
--(21, NULL, NULL, NULL, NULL),
--(22, NULL, NULL, NULL, NULL),
--(23, 'stephen.king@example.com', '+4445556666', '15 Fiction Ave, Bangor, ME', 'www.stephenking.com'),
--(24, 'suzanne.collins@example.com', '+7778889999', '10 Mockingbird Ln, NY, NY', 'www.suzannecollins.com');

--SET IDENTITY_INSERT Contacts OFF;

--SET IDENTITY_INSERT Authors ON;

--INSERT INTO Authors (Id, [Name], [ContactId]) VALUES
--(16, 'George Orwell', 21),
--(17, 'Aldous Huxley', 22),
--(18, 'Stephen King', 23),
--(19, 'Suzanne Collins', 24);

--SET IDENTITY_INSERT Authors OFF;

--SET IDENTITY_INSERT Books ON;

--INSERT INTO Books (Id, [Title], [YearPublished], [ISBN], [AuthorId], [GenreId]) VALUES
--(36, '1984', 1949, '9780451524935', 16, 2),
--(37, 'Animal Farm', 1945, '9780451526342', 16, 2),
--(38, 'Brave New World', 1932, '9780060850524', 17, 2),
--(39, 'The Doors of Perception', 1954, '9780060850531', 17, 2),
--(40, 'The Shining', 1977, '9780307743657', 18, 9),
--(41, 'It', 1986, '9781501142970', 18, 9),
--(42, 'The Hunger Games', 2008, '9780439023481', 19, 7),
--(43, 'Catching Fire', 2009, '9780439023498', 19, 7),
--(44, 'Mockingjay', 2010, '9780439023511', 19, 7);

--SET IDENTITY_INSERT Books OFF;

--INSERT INTO LibrariesBooks (LibraryId, BookId) VALUES
--(1, 36),
--(1, 37),
--(2, 38),
--(2, 39),
--(3, 40),
--(3, 41),
--(4, 42),
--(4, 43),
--(5, 44);

---- Problem 03

--UPDATE Contacts
--SET Website = LOWER('www.' + REPLACE(a.Name, ' ', '') + '.com')
--FROM Contacts c
--INNER JOIN Authors a ON c.Id = a.ContactId
--WHERE c.Website IS NULL;

---- Problem 04

--DELETE FROM LibrariesBooks WHERE BookId = (SELECT Id FROM Authors WHERE Name = 'Alex Michaelides');

--DELETE FROM Books WHERE Id = (SELECT Id FROM Authors WHERE Name = 'Alex Michaelides');

--DELETE FROM Authors WHERE Name = 'Alex Michaelides';

-- Problem 05

SELECT Title AS [Book Title],
       ISBN,
	   YearPublished AS [YearReleased]
FROM Books
ORDER BY YearPublished DESC, Title

-- Problem 06

SELECT b.Id,
       b.Title,
	   b.ISBN,
	   g.Name
FROM Books AS b
JOIN Genres AS g ON b.GenreId = g.Id
WHERE g.Name IN('Biography', 'Historical Fiction' )
ORDER BY g.Name, b.Title

-- Problem 07

SELECT 
    l.Name AS LibraryName,
    c.Email
FROM Libraries l
JOIN Contacts c ON l.ContactId = c.Id
WHERE l.Id NOT IN (
    SELECT lb.LibraryId
    FROM LibrariesBooks lb
    JOIN Books b ON lb.BookId = b.Id
    WHERE b.GenreId = (SELECT Id FROM Genres WHERE Name = 'Mystery')
)
ORDER BY l.Name;

-- Problem 08

SELECT TOP (3)
       b.Title AS Year,
       b.YearPublished,
	   g.Name AS Genre
FROM Books AS b
JOIN Genres AS g On b.GenreId = g.Id
WHERE b.YearPublished > 2000 AND b.Title LIKE '%a%' OR b.YearPublished < 1950 AND g.Name LIKE '%Fantasy%'
ORDER BY b.Title, b.YearPublished DESC

-- Problem 09

SELECT a.Name AS Author,
       c.Email,
	   c.PostAddress AS Address
FROM Authors AS a
JOIN Contacts AS c ON a.ContactId = c.Id
WHERE PostAddress LIKE '%UK%'
ORDER BY a.Name

-- Problem 10

SELECT a.Name AS Author,
       b.Title AS Title,
	   l.Name AS Library,
	   c.PostAddress
FROM Authors AS a
JOIN Books AS b ON a.Id = b.AuthorId
JOIN Genres AS g On b.GenreId = g.Id
JOIN LibrariesBooks AS lb ON b.Id = lb.BookId
JOIN Libraries AS L ON lb.LibraryId = l.Id
JOIN Contacts AS c ON l.ContactId = c.Id

WHERE g.Name = 'Fiction' AND c.PostAddress LIKE '%Denver%'
ORDER BY b.Title

--Problem 11

CREATE FUNCTION dbo.udf_AuthorsWithBooks(@name NVARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @BooksCount INT;
    
    SELECT @BooksCount = COUNT(*)
    FROM Books b
    JOIN Authors a ON b.AuthorId = a.Id
	
    WHERE @name = a.Name;
    
    RETURN @BooksCount;
END;

SELECT dbo.udf_AuthorsWithBooks('J.K. Rowling')

-- Problem 12

CREATE PROCEDURE usp_SearchByGenre @genreName NVARCHAR(30)
AS
BEGIN
    SELECT 
        b.Title,
        b.YearPublished,
        b.ISBN,
        a.Name AS AuthorName,
        g.Name AS GenreName
    FROM Books b
    JOIN Authors a ON b.AuthorId = a.Id
    JOIN Genres g ON b.GenreId = g.Id
    WHERE g.Name = @genreName
    ORDER BY b.Title;
END;

EXEC usp_SearchByGenre 'Fantasy'

-- Problem 13

CREATE OR AlTER FUNCTION udf_GenreFilter(@genre_name VARCHAR(255))
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        b.Id AS BookId,
        b.Title,
        b.YearPublished,
        b.ISBN,
        a.Name AS Author,
        l.Name AS Library
    FROM Books b
    JOIN Authors a ON b.AuthorId = a.Id
    JOIN Genres g ON b.GenreId = g.Id
    JOIN LibrariesBooks lb ON b.Id = lb.BookId
    JOIN Libraries l ON lb.LibraryId = l.Id
    WHERE g.Name = @genre_name
);


	SELECT * FROM udf_GenreFilter('Fiction');