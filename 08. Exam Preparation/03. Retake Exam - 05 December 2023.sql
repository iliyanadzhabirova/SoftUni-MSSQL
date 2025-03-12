CREATE DATABASE  RailwaysDb 

USE  RailwaysDb 

--Problem 01

CREATE TABLE Passengers(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(80) NOT NULL
);


CREATE TABLE Towns(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(30) NOT NULL
);


CREATE TABLE RailwayStations(
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL,
    TownId INT NOT NULL,
    FOREIGN KEY (TownId) REFERENCES Towns(Id)
);


CREATE TABLE Trains(
    Id INT PRIMARY KEY IDENTITY,
    HourOfDeparture VARCHAR(5) NOT NULL,
    HourOfArrival VARCHAR(5) NOT NULL,
    DepartureTownId INT NOT NULL,
    ArrivalTownId INT NOT NULL,
    FOREIGN KEY (DepartureTownId) REFERENCES Towns(Id),
    FOREIGN KEY (ArrivalTownId) REFERENCES Towns(Id)
);


CREATE TABLE TrainsRailwayStations(
    TrainId INT NOT NULL,
    RailwayStationId INT NOT NULL,
    CONSTRAINT PK_TrainsRailwayStations PRIMARY KEY (TrainId, RailwayStationId),
    CONSTRAINT FK_TrainsRailwayStations_TrainId FOREIGN KEY (TrainId) REFERENCES Trains(Id),
    CONSTRAINT FK_TrainsRailwayStations_RailwayStationId FOREIGN KEY (RailwayStationId) REFERENCES RailwayStations(Id)
);


CREATE TABLE MaintenanceRecords(
    Id INT PRIMARY KEY IDENTITY,
    DateOfMaintenance DATE NOT NULL,
    Details VARCHAR(2000) NOT NULL,
    TrainId INT NOT NULL,
    FOREIGN KEY (TrainId) REFERENCES Trains(Id)
);


CREATE TABLE Tickets(
    Id INT PRIMARY KEY IDENTITY,
    Price DECIMAL(5,2) NOT NULL,
    DateOfDeparture DATE NOT NULL,
    DateOfArrival DATE NOT NULL,
    TrainId INT NOT NULL,
    PassengerId INT NOT NULL,
    FOREIGN KEY (TrainId) REFERENCES Trains(Id),
    FOREIGN KEY (PassengerId) REFERENCES Passengers(Id)
);

-- Problem 02

INSERT INTO Trains (HourOfDeparture,HourOfArrival, DepartureTownId, ArrivalTownId) VALUES
('07:00','19:00',1,3),
('08:30', '20:30', 5, 6),
('09:00','21:00',4,8),
('06:45','03:55',27,7),
('10:15','12:15',15	,5)

INSERT INTO TrainsRailwayStations (TrainId,	RailwayStationId) VALUES
(36, 1), (37, 60), (39, 3),
(36, 4), (37, 16), (39, 31),
(36, 31), (38, 10), (39, 19),
(36, 57), (38, 50), (40, 41),
(36, 7), (38, 52), (40, 7),
(37, 13), (38, 22), (40, 52),
(37, 54), (39, 68), (40, 13)


INSERT INTO Tickets (Price, DateOfDeparture, DateOfArrival, TrainID, PassengerId) VALUES
(90.00, '2023-12-01', '2023-12-01', 36, 1),
(115.00, '2023-08-02', '2023-08-02', 37, 2),
(160.00, '2023-08-03', '2023-08-03', 38, 3),
(255.00, '2023-09-01', '2023-09-02', 39, 21),
(95.00, '2023-09-02', '2023-09-03', 40, 22);

--Problem 03

UPDATE Tickets
SET DateOfDeparture = DATEADD(day, 7, DateOfDeparture),
    DateOfArrival = DATEADD(day, 7, DateOfArrival)
WHERE DateOfDeparture > '2023-10-31';

-- Problem 04

DELETE FROM Tickets 
WHERE TrainId IN (
    SELECT Id 
    FROM Trains 
    WHERE DepartureTownId = (SELECT Id FROM Towns WHERE Name = 'Berlin')
);

DELETE FROM MaintenanceRecords 
WHERE TrainId IN (
    SELECT Id 
    FROM Trains 
    WHERE DepartureTownId = (SELECT Id FROM Towns WHERE Name = 'Berlin')
);

DELETE FROM TrainsRailwayStations 
WHERE TrainId IN (
    SELECT Id 
    FROM Trains 
    WHERE DepartureTownId = (SELECT Id FROM Towns WHERE Name = 'Berlin')
);

DELETE FROM Trains 
WHERE DepartureTownId = (SELECT Id FROM Towns WHERE Name = 'Berlin');

-- Problem 05

SELECT DateOfDeparture,
Price AS TicketPrice 
FROM Tickets
ORDER BY Price, DateOfDeparture DESC

-- Problem 06

SELECT p.Name AS PassengerName,
       t.Price AS TicketPrice,
	   t.DateOfDeparture,
	   tr.Id AS TrainId
FROM Passengers AS p

JOIN Tickets AS t ON p.Id = t.PassengerId
JOIN Trains As tr ON t.TrainId = tr.Id

ORDER BY t.Price DESC, p.Name

-- Problem 07

SELECT t.Name,
       rs.Name
FROM RailwayStations AS rs

LEFT JOIN TrainsRailwayStations trs on rs.Id = trs.RailwayStationId
JOIn Towns AS t ON rs.TownId = t.Id
WHERE RailwayStationId IS NULL

ORDER BY t.Name, rs.Name

--Problem 08

	SELECT TOP(3)
			tr.Id AS TrainId,
			tr.HourOfDeparture,
			ti.Price AS TicketPrice,
			tow.Name AS Destination
	FROM Trains AS tr
	JOIN Tickets AS ti ON tr.Id = ti.TrainId 
	JOIN Towns AS tow ON tr.ArrivalTownId = tow.Id
	WHERE tr.HourOfDeparture LIKE '08:%'
	AND ti.Price > 50.00
	ORDER BY ti.Price ASC;

-- Problem 09

SELECT tow.Name AS TownName,
       COUNT(p.Name) AS PassengersCount
FROM Passengers AS p
JOIN Tickets AS t ON p.Id = t.PassengerId
JOIN Trains AS tr ON t.TrainId = tr.Id
JOIN Towns AS tow ON tr.ArrivalTownId = tow.Id
WHERE t.Price > 76.99
GROUP BY tow.Name
ORDER BY tow.Name

-- Problem 10

SELECT t.Id AS TrainID,
       tow.Name AS DepartureTown,
	   ma.Details
FROM Trains AS t
JOIN Towns AS tow ON t.DepartureTownId = tow.Id
JOIN MaintenanceRecords AS ma ON t.Id = ma.TrainId
WHERE ma.Details LIKE '%inspection%'
ORDER BY t.Id

-- Problem 11

CREATE OR ALTER FUNCTION udf_TownsWithTrains(@name NVARCHAR(50))

RETURNS INT
AS
BEGIN
DECLARE @TrainsCount INT;
 SELECT @TrainsCount = COUNT(*)
    FROM Trains t
    JOIN Towns tow ON t.ArrivalTownId = tow.Id
	JOIN Towns tow1 ON t.DepartureTownId = tow1.Id
    WHERE @name IN (tow.Name, tow1.Name)
    
    RETURN @TrainsCount;

END;

SELECT dbo.udf_TownsWithTrains('Paris')

-- Problem 12

CREATE PROCEDURE usp_SearchByTown @townName NVARCHAR(50)
AS
BEGIN
    SELECT p.Name AS PassengerName,
	ti.DateOfDeparture,
	tr.HourOfDeparture
    FROM Passengers AS p
	JOIN Tickets AS ti ON p.Id = ti.PassengerId
	JOIN Trains AS tr ON tr.Id = ti.TrainId
	JOIN Towns AS tow ON tr.ArrivalTownId = tow.Id

	WHERE  tow.Name = @townName
	ORDER BY ti.DateOfDeparture DESC, p.Name 
END;

EXEC usp_SearchByTown 'Berlin'
