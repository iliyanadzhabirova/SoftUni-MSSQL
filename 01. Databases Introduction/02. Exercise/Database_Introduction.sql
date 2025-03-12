-- Problem 01

CREATE DATABASE [Minions]
GO

USE [Minions]
GO

-- Problem 02

CREATE TABLE [Minions](
	[Id] INT PRIMARY KEY NOT NULL,
	[Name] NVARCHAR (50) NOT NULL,
	[Age] INT 
)

CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY NOT NULL,
	[Name] NVARCHAR (85) NOT NULL
)

-- Problem 03
-- Alter is command to update STRUCTURE and CONSTRAINTS of the Table

ALTER TABLE [Minions]
ADD [TownId] INT

ALTER TABLE [Minions]
ADD CONSTRAINT [FK_Minions_Towns_Id]
FOREIGN KEY ([TownId]) REFERENCES [Towns]([Id])

-- Problem 04
-- Within INSERT Statement () means a single row
INSERT INTO [Towns]([Id], [Name])
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO [Minions]([Id], [Name], [Age], [TownID])
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

-- Problem 05
-- TRUNCATE = Factory Reset = Delete All Data

TRUNCATE TABLE [Minions]

-- Problem 06
DROP TABLE [Minions];

DROP TABLE [Towns];

-- Problem 07
CREATE TABLE [People]
(
    [Id] INT UNIQUE IDENTITY NOT NULL,
    [Name] NVARCHAR(200) NOT NULL,
    [Picture] VARBINARY(MAX),
    [Height] NUMERIC(3, 2),
    [Weight] NUMERIC(5, 2),
    [Gender] CHAR(1) CHECK([Gender] IN('M', 'F')) NOT NULL,
    [Birthdate] DATE NOT NULL,
    [Biography] NVARCHAR(MAX)
);

ALTER TABLE [People]
ADD PRIMARY KEY([Id]);

ALTER TABLE [People]
ADD CONSTRAINT [CH_PictureSize] CHECK(DATALENGTH([Picture]) <= 2 * 1024 * 1024);

INSERT INTO [People]([Name], [Gender], [Birthdate])
VALUES
(
    'Alice Johnson',
    'F',
    '1990-04-10'
),
(
    'Bob Smith',
    'M',
    '1985-07-22'
),
(
    'Charlie Brown',
    'M',
    '1993-11-30'
),
(
    'Diana Green',
    'F',
    '2000-02-15'
),
(
    'Edward White',
    'M',
    '1988-09-05'
);

-- Problem 08

CREATE TABLE [Users](
	[Id] BIGINT PRIMARY KEY IDENTITY NOT NULL,
	[Username] VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(MAX),
	[LastLoginTime] DATETIME2,
	[IsDeleted] BIT
)

INSERT INTO [Users]([Username], [Password], [ProfilePicture], [LastLoginTime], [IsDeleted])
VALUES 
('Pesho','123456', NULL, GETDATE(), NULL),
('Gosho','12345678', NULL, GETUTCDATE(), 0),
('Ivan','1234', NULL, NULL,1),
('Dragan','123456789', NULL, NULL, 0),
('Mariq','123', NULL, GETDATE(), 1)

-- Problem 09
ALTER TABLE [Users]
DROP CONSTRAINT [PK__Users__77222459D9946D67]

ALTER TABLE [Users]
ADD CONSTRAINT [PK_Composite_Id_Username]
PRIMARY KEY([Id], [Username])

-- Problem 10

ALTER TABLE [Users]
ADD CONSTRAINT [CK_Password_Min_Length_5]
CHECK(LEN([Password]) >=5)

-- Problem 11
-- Import for Default Constraint - Sets default value if column value is NO SPECIFIED during insertion
-- Setting NULL while importing, this will not set DEFAULT value
ALTER TABLE [Users]
ADD CONSTRAINT [DF_LastLoginTime_Current_Time]
DEFAULT GETDATE() FOR [LastLoginTime]

INSERT INTO [Users]([Username], [Password], [ProfilePicture], [IsDeleted])
VALUES 
('Pesho2','123456', NULL, NULL)

-- Problem 12
ALTER TABLE [Users]
DROP CONSTRAINT [PK_Composite_Id_Username];

ALTER TABLE [Users]
ADD CONSTRAINT [PK_Users_Id]
PRIMARY KEY ([Id]);

ALTER TABLE [Users]
ADD CONSTRAINT [UQ_Username] UNIQUE ([Username]);

ALTER TABLE [Users]
ADD CONSTRAINT [CK_Username_Min_Length_3]
CHECK (LEN([Username]) >= 3);

-- Problem 13
CREATE DATABASE [Movies];
GO

USE [Movies];

CREATE TABLE [Directors]
(
    [Id] INT NOT NULL PRIMARY KEY,
    [DirectorName] NVARCHAR(50) NOT NULL,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [Directors]([Id], [DirectorName], [Notes])
VALUES
(
    1, 'Christopher Nolan', 'Famous for his complex narratives and visual storytelling'
),
(
    2, 'Steven Spielberg', 'Legendary director known for films like Jaws and E.T.'
),
(
    3, 'Quentin Tarantino', 'Director known for his unique style of storytelling and dialogue'
),
(
    4, 'Martin Scorsese', 'Known for his influential work in gangster films and dramas'
),
(
    5, 'James Cameron', 'Director of iconic films such as Titanic and Avatar'
);

CREATE TABLE [Genres]
(
    [Id] INT NOT NULL PRIMARY KEY,
    [GenreName] NVARCHAR(50) NOT NULL,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [Genres]([Id], [GenreName], [Notes])
VALUES
(
    1, 'Action', 'Films with high-intensity scenes, often involving physical combat or chases'
),
(
    2, 'Drama', 'Films focused on realistic storytelling, exploring human emotions and relationships'
),
(
    3, 'Comedy', 'Films designed to entertain and provoke laughter'
),
(
    4, 'Sci-Fi', 'Films exploring futuristic or speculative concepts often involving advanced technology'
),
(
    5, 'Horror', 'Films created to evoke fear, suspense, or disgust from the audience'
);

CREATE TABLE [Categories]
(
    [Id] INT NOT NULL PRIMARY KEY,
    [CategoryName] NVARCHAR(50) NOT NULL,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [Categories]([Id], [CategoryName], [Notes])
VALUES
(
    1, 'Blockbuster', 'High-budget films that achieve wide commercial success'
),
(
    2, 'Indie', 'Low-budget films produced outside of major film studios, often with artistic storytelling'
),
(
    3, 'Animation', 'Films created using animation techniques, either 2D or 3D'
),
(
    4, 'Documentary', 'Non-fiction films that aim to document real-life events or issues'
),
(
    5, 'Romantic', 'Films that focus on love and relationships, often with a happy ending'
);

CREATE TABLE [Movies]
(
    [Id] INT NOT NULL PRIMARY KEY,
    [Title] NVARCHAR(255) NOT NULL,
    [DirectorId] INT FOREIGN KEY REFERENCES [Directors]([Id]),
    [CopyrightYear] INT,
    [Length] NVARCHAR(50),
    [GenreId] INT FOREIGN KEY REFERENCES [Genres]([Id]),
    [CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]),
    [Rating] INT,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [Movies]([Id], [Title], [DirectorId], [CopyrightYear], [Length], [GenreId], [CategoryId], [Rating], [Notes])
VALUES
(
    1, 'Inception', 1, 2010, '148 minutes', 4, 1, 8, 'A sci-fi thriller that explores the world of dreams and the subconscious'
),
(
    2, 'Jurassic Park', 2, 1993, '127 minutes', 4, 1, 8, 'A groundbreaking action-adventure film about a dinosaur theme park'
),
(
    3, 'Pulp Fiction', 3, 1994, '154 minutes', 3, 2, 9, 'A non-linear crime film that intertwines several stories'
),
(
    4, 'The Irishman', 4, 2019, '209 minutes', 2, 2, 7, 'A gangster drama exploring loyalty and betrayal over decades'
),
(
    5, 'Avatar', 5, 2009, '162 minutes', 4, 1, 8, 'A visually stunning sci-fi epic set on the alien world of Pandora'
);

-- Problem 14
CREATE DATABASE [CarRental];
GO

USE [CarRental];

CREATE TABLE [Categories]
(
    [Id] INT PRIMARY KEY NOT NULL,
    [CategoryName] NVARCHAR(50) NOT NULL,
    [DailyRate] DECIMAL(10, 2),
    [WeeklyRate] DECIMAL(10, 2),
    [MonthlyRate] DECIMAL(10, 2),
    [WeekendRate] DECIMAL(10, 2)
);

ALTER TABLE [Categories]
ADD CONSTRAINT [CK_AtLeastOneRate] CHECK(
    ([DailyRate] IS NOT NULL)
    OR ([WeeklyRate] IS NOT NULL)
    OR ([MonthlyRate] IS NOT NULL)
    OR ([WeekendRate] IS NOT NULL)
);

INSERT INTO [Categories]([Id], [CategoryName], [DailyRate], [WeeklyRate], [MonthlyRate], [WeekendRate])
VALUES
(
    1, 'Economy', 15.00, 70.00, 250.00, 50.00
),
(
    2, 'Luxury', 40.00, 200.00, 800.00, 150.00
),
(
    3, 'SUV', 35.00, 160.00, 600.00, 120.00
);

CREATE TABLE [Cars]
(
    [Id] INT PRIMARY KEY NOT NULL,
    [PlateNumber] VARCHAR(50) NOT NULL,
    [Manufacturer] VARCHAR(50) NOT NULL,
    [Model] VARCHAR(50) NOT NULL,
    [CarYear] INT NOT NULL,
    [CategoryId] INT NOT NULL FOREIGN KEY REFERENCES [Categories]([Id]),
    [Doors] TINYINT NOT NULL,
    [Picture] VARBINARY(MAX),
    [Condition] NVARCHAR(50),
    [Available] BIT DEFAULT 1
);

INSERT INTO [Cars]([Id], [PlateNumber], [Manufacturer], [Model], [CarYear], [CategoryId], [Doors], [Available])
VALUES
(
    1, 'AB123CD', 'Toyota', 'Corolla', 2015, 1, 4, 1
),
(
    2, 'XY987ZT', 'Audi', 'A6', 2020, 2, 4, 1
),
(
    3, 'GH456JK', 'Honda', 'CR-V', 2018, 3, 5, 1
);

CREATE TABLE [Employees]
(
    [Id] INT PRIMARY KEY NOT NULL,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [Title] NVARCHAR(50) NOT NULL,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [Employees]([Id], [FirstName], [LastName], [Title], [Notes])
VALUES
(
    1, 'John', 'Doe', 'Mechanic', 'Specializes in engine repairs'
),
(
    2, 'Jane', 'Smith', 'Team Leader', 'Manages the car rental operations'
),
(
    3, 'Robert', 'Brown', 'Manager', 'Oversees the rental branch'
);

CREATE TABLE [Customers]
(
    [Id] INT NOT NULL PRIMARY KEY,
    [DriverLicenceNumber] VARCHAR(50) UNIQUE NOT NULL,
    [FullName] NVARCHAR(50) NOT NULL,
    [Address] NVARCHAR(255),
    [City] NVARCHAR(50),
    [ZIPCode] NVARCHAR(50),
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [Customers]([Id], [DriverLicenceNumber], [FullName], [Address], [City], [ZIPCode], [Notes])
VALUES
(
    1, 'A123456789', 'Alice Johnson', '123 Main St', 'Springfield', '12345', 'Frequent renter'
),
(
    2, 'B987654321', 'Bob White', '456 Oak Rd', 'Greenville', '67890', 'Occasional renter'
),
(
    3, 'C192837465', 'Charlie Black', '789 Pine Ln', 'Hilltown', '11223', 'New customer'
);

CREATE TABLE [RentalOrders]
(
    [Id] INT PRIMARY KEY NOT NULL,
    [EmployeeId] INT NOT NULL FOREIGN KEY REFERENCES [Employees]([Id]),
    [CustomerId] INT NOT NULL FOREIGN KEY REFERENCES [Customers]([Id]),
    [CarId] INT NOT NULL FOREIGN KEY REFERENCES [Cars]([Id]),
    [TankLevel] NUMERIC(5, 2),
    [KilometrageStart] INT,
    [KilometrageEnd] INT,
    [TotalKilometrage] INT,
    [StartDate] DATE NOT NULL,
    [EndDate] DATE NOT NULL,
    [TotalDays] INT NOT NULL,
    [RateApplied] DECIMAL(10, 2),
    [TaxRate] DECIMAL(10, 2),
    [OrderStatus] NVARCHAR(50),
    [NOTES] NVARCHAR(MAX)
);

ALTER TABLE [RentalOrders]
ADD CONSTRAINT [CK_TotalDays] CHECK(DATEDIFF(DAY, [StartDate], [EndDate]) = [TotalDays]);

INSERT INTO [RentalOrders]([Id], [EmployeeId], [CustomerId], [CarId], [StartDate], [EndDate], [TotalDays], [RateApplied], [TaxRate], [OrderStatus], [NOTES])
VALUES
(
    1, 3, 1, 1, '2024-01-01', '2024-01-10', 9, 135.00, 10.00, 'Completed', 'Excellent experience'
),
(
    2, 1, 2, 2, '2024-02-01', '2024-02-07', 6, 240.00, 20.00, 'Completed', 'Smooth process'
),
(
    3, 2, 3, 3, '2024-03-01', '2024-03-12', 11, 385.00, 25.00, 'Completed', 'First time rental'
);

-- Problem 15
CREATE DATABASE [Hotel];
GO

USE [Hotel];

CREATE TABLE [Employees]
(
    [Id] INT PRIMARY KEY NOT NULL,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [Title] NVARCHAR(255) NOT NULL,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [Employees]([Id], [FirstName], [LastName], [Title])
VALUES
(
    1, 'John', 'Smith', 'General Manager'
),
(
    2, 'Emily', 'Davis', 'Front Desk Supervisor'
),
(
    3, 'Michael', 'Wilson', 'Housekeeping Manager'
);

CREATE TABLE [Customers]
(
    [AccountNumber] INT PRIMARY KEY NOT NULL,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [PhoneNumber] VARCHAR(50),
    [EmergencyName] NVARCHAR(50) NOT NULL,
    [EmergencyNumber] INT NOT NULL,
    [Notes] NVARCHAR(50)
);

INSERT INTO [Customers]([AccountNumber], [FirstName], [LastName], [EmergencyName], [EmergencyNumber])
VALUES
(
    1, 'Sophia', 'Martin', 'Liam', 44455
),
(
    2, 'Oliver', 'Thomas', 'Mason', 66666
),
(
    3, 'Isabella', 'Taylor', 'Ethan', 88888
);

CREATE TABLE [RoomStatus]
(
    [RoomStatus] NVARCHAR(50) PRIMARY KEY NOT NULL,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [RoomStatus]([RoomStatus])
VALUES
(
    'Free'
),
(
    'In use'
),
(
    'Reserved'
);

CREATE TABLE [RoomTypes]
(
    [RoomType] NVARCHAR(50) PRIMARY KEY NOT NULL,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [RoomTypes]([RoomType])
VALUES
(
    'Luxory'
),
(
    'Casual'
),
(
    'Misery'
);

CREATE TABLE [BedTypes]
(
    [BedType] NVARCHAR(50) PRIMARY KEY NOT NULL,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [BedTypes]([BedType])
VALUES
(
    'Single'
),
(
    'Double'
),
(
    'King'
);

CREATE TABLE [Rooms]
(
    [RoomNumber] INT PRIMARY KEY NOT NULL,
    [RoomType] NVARCHAR(50) NOT NULL,
    [BedType] NVARCHAR(50) NOT NULL,
    [Rate] DECIMAL(10, 2) NOT NULL,
    [RoomStatus] NVARCHAR(50) NOT NULL,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [Rooms]([RoomNumber], [RoomType], [BedType], [Rate], [RoomStatus])
VALUES
(
    1, 'Luxory', 'King', 100, 'Reserved'
),
(
    2, 'Casual', 'Double', 50, 'In use'
),
(
    3, 'Misery', 'Single', 19, 'Free'
);

CREATE TABLE [Payments]
(
    [Id] INT PRIMARY KEY NOT NULL,
    [EmployeeId] INT NOT NULL,
    [PaymentDate] DATE NOT NULL,
    [AccountNumber] INT NOT NULL,
    [FirstDateOccupied] DATE NOT NULL,
    [LastDateOccupied] DATE NOT NULL,
    [TotalDays] INT NOT NULL,
    [AmountCharged] DECIMAL(10, 2) NOT NULL,
    [TaxRate] DECIMAL(10, 2) NOT NULL,
    [TaxAmount] DECIMAL(10, 2) NOT NULL,
    [PaymentTotal] DECIMAL(10, 2) NOT NULL,
    [Notes] NVARCHAR(MAX)
);

ALTER TABLE [Payments]
ADD CONSTRAINT [CK_TotalDays] CHECK(DATEDIFF(DAY, [FirstDateOccupied], [LastDateOccupied]) = [TotalDays]);

ALTER TABLE [Payments]
ADD CONSTRAINT [CK_TaxAmount] CHECK([TaxAmount] = [TotalDays] * [TaxRate]);

INSERT INTO [Payments]([Id], [EmployeeId], [PaymentDate], [AccountNumber], [FirstDateOccupied], [LastDateOccupied], [TotalDays], [AmountCharged], [TaxRate], [TaxAmount], [PaymentTotal])
VALUES
(
    1, 1, '2015-10-05', 1, '2015-10-05', '2015-10-10', 5, 75, 50, 250, 75
),
(
    2, 3, '2015-10-11', 1, '2015-12-15', '2015-12-25', 10, 100, 50, 500, 100
),
(
    3, 2, '2015-12-23', 1, '2015-12-23', '2015-12-24', 1, 75, 75, 75, 75
);

CREATE TABLE [Occupancies]
(
    [Id] INT PRIMARY KEY NOT NULL,
    [EmployeeId] INT NOT NULL,
    [DateOccupied] DATE NOT NULL,
    [AccountNumber] INT NOT NULL,
    [RoomNumber] INT NOT NULL,
    [RateApplied] DECIMAL(10, 2),
    [PhoneCharge] VARCHAR(50) NOT NULL,
    [Notes] NVARCHAR(MAX)
);

INSERT INTO [Occupancies]([Id], [EmployeeId], [DateOccupied], [AccountNumber], [RoomNumber], [PhoneCharge])
VALUES
(
    1, 2, '2012-08-24', 3, 1, '088 88 888 888'
),
(
    2, 3, '2015-06-15', 2, 3, '088 88 555 555'
),
(
    3, 1, '2016-05-12', 1, 2, '088 88 555 333'
);

-- Problem 16

CREATE DATABASE [SoftUni]
GO

USE [SoftUni]

CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(85) NOT NULL	
)

CREATE TABLE [Addresses](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[AddressText] NVARCHAR(147) NOT NULL,
	[TownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) 
)

CREATE TABLE [Departments](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,	
	[Name] NVARCHAR(70) NOT NULL
)

CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,	
	[FirstName] NVARCHAR(36) NOT NULL,
	[MiddleName] NVARCHAR(36),
	[LastName] NVARCHAR(36) NOT NULL,
	[JobTitle] NVARCHAR(40) NOT NULL,
	[DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]) NOT NULL,
	[HireDate] DATE NOT NULL DEFAULT (GETDATE()),
	[Salary] DECIMAL(18, 2) NOT NULL,
	[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) 
)

-- Problem 17
BACKUP DATABASE [SoftUni] TO DISK = 'D:\softuni-backup.bak';

USE [CarRental];

DROP DATABASE [SoftUni];

RESTORE DATABASE [SoftUni] FROM DISK = 'D:\softuni-backup.bak';

-- Problem 18

INSERT INTO [Towns]([Name])
VALUES
('Sofia'),
('Ploviv'),
('Varna'),
('Burgas')

INSERT INTO [Departments]([Name])
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

INSERT INTO [Employees]([FirstName], [MiddleName], [LastName], [JobTitle], [DepartmentId], [HireDate], [Salary])
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4 , '02/01/2013', 3500.00 ),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '03/02/2004', 4000.00 ),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5 , '08/28/2016', 525.25 ),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2 , '12/09/2007', 3000.00 ),
('Peter', 'Pan', 'Pan', 'Intern', 3 , '08/28/2016', 599.88 )

-- Problem 19

SELECT *
FROM [Towns]

SELECT *
FROM [Departments]

SELECT *
FROM [Employees]

-- Problem 20
-- By deafault ORDER BY is ascending (ASC). If you descending, you must specify by DESC.
SELECT *
FROM [Towns]
ORDER BY [Name]

SELECT *
FROM [Departments]
ORDER BY [Name]

SELECT *
FROM [Employees]
ORDER BY [Salary] DESC

-- Problem 21

SELECT [Name]
FROM [Towns]
ORDER BY [Name]

SELECT [Name]
FROM [Departments]
ORDER BY [Name]

SELECT [FirstName], [LastName], [JobTitle], [Salary]
FROM [Employees]
ORDER BY [Salary] DESC

-- Problem 22

UPDATE [Employees]
  SET
      [Salary] *= 1.10;

SELECT [Salary]
FROM Employees;

-- Problem 23

USE [Hotel];

UPDATE [Payments]
  SET
      [TaxRate] = [TaxRate] - ([TaxRate] * 0.03);

SELECT [TaxRate]
FROM [Payments];

-- Problem 24

TRUNCATE TABLE [Occupancies];
