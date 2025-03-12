CREATE DATABASE TouristAgency

USE TouristAgency

GO

-- Problem 01

CREATE TABLE Countries(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(50) NOT NULL
);

CREATE TABLE Destinations(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
CountryId INT NOT NULL FOREIGN KEY REFERENCES Countries(Id)
);

CREATE TABLE Rooms(
Id INT PRIMARY KEY IDENTITY,
Type VARCHAR(50) NOT NULL,
Price DECIMAL(18,2) NOT NULL,
BedCount INT NOT NULL CHECK (BedCount BETWEEN 1 AND 10)
);

CREATE TABLE Hotels(
Id INT PRIMARY KEY IDENTITY,
Name VARCHAR(50) NOT NULL,
DestinationId INT NOT NULL FOREIGN KEY REFERENCES Destinations(Id)
);

CREATE TABLE Tourists(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(80) NOT NULL,
PhoneNumber VARCHAR(20) NOT NULL,
Email VARCHAR(80) NOT NULL,
CountryId INT NOT NULL FOREIGN KEY REFERENCES Countries(Id)
);

CREATE TABLE Bookings(
Id INT PRIMARY KEY IDENTITY,
ArrivalDate DateTime2 NOT NULL,
DepartureDate DateTime2 NOT NULL,
AdultsCount INT NOT NULL CHECK (AdultsCount BETWEEN  0 AND 10),
ChildrenCount INT NOT NULL CHECK (ChildrenCount BETWEEN  0 AND 9),
TouristId INT NOT NULL FOREIGN KEY REFERENCES Tourists(Id),
HotelId INT NOT NULL FOREIGN KEY REFERENCES Hotels(Id),
RoomId INT NOT NULL FOREIGN KEY REFERENCES Rooms(Id)
);

CREATE TABLE HotelsRooms(
HotelId INT NOT NULL FOREIGN KEY REFERENCES Hotels(Id),
RoomId INT NOT NULL FOREIGN KEY REFERENCES Rooms(Id),
PRIMARY KEY([HotelId],[RoomId])
);

-- Problem 02

INSERT INTO Tourists(Name,PhoneNumber,Email,CountryId) VALUES
('John Rivers', '653-551-1555 ', 'john.rivers@example.com',6),
('Adeline Aglae', '122-654-8726 ', 'adeline.aglae@example.com',2),
('Sergio Ramirez', '233-465-2876 ', 's.ramirez@example.com',3),
('Johan Muller', '322-876-9826', 'j.muller@example.com', 7),
('Eden Smith', '551-874-2234', 'eden.smith@example.com', 6)

INSERT INTO Bookings(ArrivalDate,DepartureDate,AdultsCount,ChildrenCount,TouristId,HotelId,RoomId ) VALUES
('2024-03-01', '2024-03-11', 1,0,21,3,5),
('2023-12-28', '2024-01-06',2,1,22,13,3),
('2023-11-15', '2023-11-20',1,2,23,19,7),
('2023-12-05', '2023-12-09',4,0,24,6,4),
('2024-05-01','2024-05-07',6,0,25,14,6)

--Problem 03

UPDATE Bookings

SET DepartureDate = DATEADD(day, 1 , DepartureDate)

UPDATE Tourists 

SET Email = NULL
WHERE Tourists.Name LIKE ('%MA%')

-- Problem 04

DELETE FROM Bookings 
WHERE TouristId IN (SELECT Id FROM Tourists WHERE Name LIKE '%Smith%');

DELETE FROM Tourists 
WHERE Name LIKE '%Smith%';

-- Problem 05

SELECT FORMAT(ArrivalDate, 'yyyy-MM-dd') AS FormattedArrivalDate,
       AdultsCount,
       ChildrenCount
FROM Bookings AS b
JOIN Rooms AS r ON b.RoomId = r.Id
ORDER BY r.Price DESC, ArrivalDate;

-- Problem 06

SELECT h.Id,
       h.Name
FROM Hotels AS h
JOIN HotelsRooms AS hr ON h.Id = hr.HotelId
JOIN Rooms AS r ON hr.RoomId = r.Id
JOIN Bookings AS b ON b.HotelId = h.Id
WHERE r.Type = 'VIP Apartment'
GROUP BY h.Id, h.Name
ORDER BY COUNT(b.Id) DESC;

-- Problem 07

SELECT  t.Id,
       t.Name,
       t.PhoneNumber
FROM Tourists AS t
LEFT JOIN Bookings as b ON t.Id = b.TouristId
WHERE b.Id IS NULL
ORDER BY t.Name

-- Problem 08

SELECT TOP (10)
       h.Name AS HotelName,
       d.Name AS DestinationName,
	   c.Name AS CountryName
 
 FROM Bookings as b
 JOIN Hotels AS h ON b.HotelId = h.Id
 JOIN Destinations AS d ON h.DestinationId = d.Id
 JOIN Countries AS c ON d.CountryId = c.Id

 WHERE b.ArrivalDate < '2023-12-31' AND h.Id%2=1
 ORDER BY c.Name, b.ArrivalDate
 
 -- Problem 09

 SELECT h.Name, r.Price
FROM Tourists AS t
JOIN Bookings AS b ON t.Id = b.TouristId
JOIN Rooms AS r ON b.RoomId = r.Id
JOIN Hotels AS h ON b.HotelId = h.Id
WHERE t.Name NOT LIKE '%EZ'
ORDER By r.Price DESC

-- Problem 10

SELECT h.Name AS HotelName,
       SUM(r.Price * DATEDIFF(DAY, b.ArrivalDate, b.DepartureDate)) AS TotalRevenue
FROM Bookings AS b
JOIN Rooms AS r ON b.RoomId = r.Id
JOIN Hotels AS h ON b.HotelId = h.Id
GROUP BY h.Name
ORDER BY TotalRevenue DESC;

-- Problem 11

CREATE FUNCTION dbo.udf_RoomsWithTourists (@name VARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @TotalTourists INT;

    SELECT @TotalTourists = SUM(b.AdultsCount + b.ChildrenCount)
    FROM Bookings AS b
    JOIN Rooms AS r ON b.RoomId = r.Id
    WHERE r.Type = @name;

    RETURN @TotalTourists;
END;

-- Problem 12

CREATE PROCEDURE usp_SearchByCountry (@country NVARCHAR(50))
AS
BEGIN
    SELECT t.Name,
           t.PhoneNumber,
           t.Email,
           COUNT(b.Id) AS CountOfBookings
    FROM Tourists AS t
    JOIN Bookings AS b ON t.Id = b.TouristId
    JOIN Hotels AS h ON b.HotelId = h.Id
    JOIN Countries AS c ON t.CountryId = c.Id
    WHERE c.Name = @country
    GROUP BY t.Name, t.PhoneNumber, t.Email
    ORDER BY t.Name ASC, CountOfBookings DESC;
END;