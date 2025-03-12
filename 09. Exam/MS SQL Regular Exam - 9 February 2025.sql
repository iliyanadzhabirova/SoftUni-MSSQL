CREATE DATABASE EuroLeagues;

USE EuroLeagues;

-- Problem 01

CREATE TABLE Leagues (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    Name NVARCHAR(50) NOT NULL
);

CREATE TABLE Teams (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(50) NOT NULL UNIQUE,
    City NVARCHAR(50) NOT NULL,
    LeagueId INT NOT NULL,
    FOREIGN KEY (LeagueId) REFERENCES Leagues(Id)
);

CREATE TABLE Players (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Position NVARCHAR(20) NOT NULL
);

CREATE TABLE Matches (
    Id INT PRIMARY KEY IDENTITY NOT NULL,
    HomeTeamId INT NOT NULL,
    AwayTeamId INT NOT NULL,
    MatchDate DATETIME2 NOT NULL,
    HomeTeamGoals INT NOT NULL DEFAULT 0,
    AwayTeamGoals INT NOT NULL DEFAULT 0,
    LeagueId INT NOT NULL,
    FOREIGN KEY (HomeTeamId) REFERENCES Teams(Id),
    FOREIGN KEY (AwayTeamId) REFERENCES Teams(Id),
    FOREIGN KEY (LeagueId) REFERENCES Leagues(Id),
    CONSTRAINT CHK_HomeAwayTeams CHECK (HomeTeamId <> AwayTeamId)
);

CREATE TABLE PlayersTeams (
    PlayerId INT NOT NULL,
    TeamId INT NOT NULL,
    PRIMARY KEY (PlayerId, TeamId),
    FOREIGN KEY (PlayerId) REFERENCES Players(Id),
    FOREIGN KEY (TeamId) REFERENCES Teams(Id)
);

CREATE TABLE PlayerStats (
    PlayerId INT PRIMARY KEY NOT NULL,
    Goals INT NOT NULL DEFAULT 0,
    Assists INT NOT NULL DEFAULT 0,
    FOREIGN KEY (PlayerId) REFERENCES Players(Id)
);

CREATE TABLE TeamStats (
    TeamId INT PRIMARY KEY NOT NULL,
    Wins INT NOT NULL DEFAULT 0,
    Draws INT NOT NULL DEFAULT 0,
    Losses INT NOT NULL DEFAULT 0,
    FOREIGN KEY (TeamId) REFERENCES Teams(Id)
);


-- Problem 02

INSERT INTO Leagues (Name)
VALUES ('Eredivisie');

INSERT INTO Teams (Name, City, LeagueId)
VALUES 
('PSV', 'Eindhoven', 6),
('Ajax', 'Amsterdam', 6);

INSERT INTO Players (Name, Position)
VALUES 
('Luuk de Jong', 'Forward'),
('Josip Sutalo', 'Defender');

INSERT INTO Matches (HomeTeamId, AwayTeamId, MatchDate, HomeTeamGoals, AwayTeamGoals, LeagueId)
VALUES 
(98, 97, '2024-11-02 20:45:00', 3, 2, 6);

INSERT INTO PlayersTeams (PlayerId, TeamId)
VALUES 
(2305, 97),
(2306, 98);

INSERT INTO PlayerStats (PlayerId, Goals, Assists)
VALUES 
(2305, 2, 0),
(2306, 2, 0);

INSERT INTO TeamStats (TeamId, Wins, Draws, Losses)
VALUES 
(97, 15, 1, 3),
(98, 14, 3, 2);

-- Problem 03

UPDATE ps
SET ps.Goals = ps.Goals + 1
FROM PlayerStats ps
JOIN Players p ON ps.PlayerId = p.Id
JOIN PlayersTeams pt ON pt.PlayerId = p.Id
JOIN Teams t ON pt.TeamId = t.Id
JOIN Leagues l ON t.LeagueId = l.Id
WHERE p.Position = 'Forward' AND l.Name = 'La Liga';

-- Problem 04

DELETE ps
FROM PlayerStats ps
JOIN Players p ON ps.PlayerId = p.Id
JOIN PlayersTeams pt ON pt.PlayerId = p.Id
JOIN Teams t ON pt.TeamId = t.Id
JOIN Leagues l ON t.LeagueId = l.Id
WHERE p.Name IN ('Luuk de Jong', 'Josip Sutalo') AND l.Name = 'Eredivisie';

DELETE pt
FROM PlayersTeams pt
JOIN Players p ON pt.PlayerId = p.Id
JOIN Teams t ON pt.TeamId = t.Id
JOIN Leagues l ON t.LeagueId = l.Id
WHERE p.Name IN ('Luuk de Jong', 'Josip Sutalo') AND l.Name = 'Eredivisie';

DELETE p
FROM Players p
JOIN PlayersTeams pt ON p.Id = pt.PlayerId
JOIN Teams t ON pt.TeamId = t.Id
JOIN Leagues l ON t.LeagueId = l.Id
WHERE p.Name IN ('Luuk de Jong', 'Josip Sutalo') AND l.Name = 'Eredivisie';

-- Problem 05

SELECT 
    FORMAT(MatchDate, 'yyyy-MM-dd') AS MatchDate,
    HomeTeamGoals,
    AwayTeamGoals,
    (HomeTeamGoals + AwayTeamGoals) AS TotalGoals
FROM Matches
WHERE (HomeTeamGoals + AwayTeamGoals) >= 5
ORDER BY TotalGoals DESC, MatchDate ASC;
     
-- Problem 06

SELECT p.Name,
       t.City
FROM Players AS p
JOIN PlayersTeams AS ps ON p.Id = ps.PlayerId
JOIN Teams as t ON ps.TeamId = t.Id
WHERE p.Name LIKE'%Aaron%'
ORDER BY p.Name

-- Problem 07

SELECT p.Id,
       p.Name,
	   p.Position
FROM Players AS p
JOIN PlayersTeams AS ps ON p.Id = ps.PlayerId
JOIN Teams as t ON ps.TeamId = t.Id
WHERE t.City = 'London'
ORDER BY p.Name

-- Problem 08

SELECT TOP 10
ht.Name AS HomeTeamName,
at.Name AS AwayTeamName,
l.Name AS LeagueName,
FORMAT(m.MatchDate, 'yyyy-MM-dd') AS MatchDate            
FROM Matches m
JOIN Teams ht ON m.HomeTeamId = ht.Id
JOIN Teams at ON m.AwayTeamId = at.Id
JOIN Leagues l ON m.LeagueId = l.Id
WHERE m.MatchDate BETWEEN '2024-09-01' AND '2024-09-15'
AND l.Id % 2 = 0
ORDER BY m.MatchDate ASC, ht.Name ASC;

-- Problem 09

SELECT t.Id,
       t.Name,
	   SUM(m.AwayTeamGoals) AS TotalAwayGoals
FROM Teams AS t
JOIN Matches AS m ON t.Id = m.AwayTeamId
GROUP BY t.Id, t.Name
HAVING SUM(m.AwayTeamGoals) >=6
 ORDER BY TotalAwayGoals DESC, t.Name ASC;

-- Problem 10

SELECT 
l.Name AS LeagueName,
 ROUND(CAST(SUM(m.HomeTeamGoals + m.AwayTeamGoals) AS FLOAT) / CAST(COUNT(m.Id) AS FLOAT), 2) AS AvgScoringRate
FROM Matches m
JOIN Leagues l ON m.LeagueId = l.Id
GROUP BY l.Name
ORDER BY AvgScoringRate DESC

-- Problem 11

CREATE OR ALTER FUNCTION dbo.udf_LeagueTopScorer (@LeagueName NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    WITH MaxGoals AS
    (
        SELECT MAX(ps.Goals) AS MaxGoalCount
        FROM Players p
        JOIN PlayersTeams pt ON p.Id = pt.PlayerId
        JOIN Teams t ON pt.TeamId = t.Id
        JOIN PlayerStats ps ON p.Id = ps.PlayerId
        JOIN Leagues l ON t.LeagueId = l.Id
        WHERE l.Name = @LeagueName
    )
    SELECT p.Name AS PlayerName, ps.Goals AS TotalGoals
    FROM Players p
    JOIN PlayersTeams pt ON p.Id = pt.PlayerId
    JOIN Teams t ON pt.TeamId = t.Id
    JOIN PlayerStats ps ON p.Id = ps.PlayerId
    JOIN Leagues l ON t.LeagueId = l.Id
    CROSS JOIN MaxGoals
    WHERE l.Name = @LeagueName
    AND ps.Goals = MaxGoals.MaxGoalCount
);

SELECT dbo.udf_LeagueTopScorer('Premier League')

-- Problem 12

CREATE OR ALTER PROCEDURE usp_SearchTeamsByCity
    @CityName NVARCHAR(50)
AS
BEGIN
    SELECT t.Name AS TeamName,
           l.Name AS LeagueName,
           t.City
    FROM Teams t
    JOIN Leagues l ON t.LeagueId = l.Id
    WHERE t.City = @CityName
    ORDER BY t.Name ASC
END

EXEC usp_SearchTeamsByCity 'London'