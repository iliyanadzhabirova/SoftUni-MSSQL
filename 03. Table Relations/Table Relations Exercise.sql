CREATE DATABASE TableRelations

GO

USE TableRelations

GO
--Problem 01

CREATE TABLE Persons (
	PersonID INT,
	FirstName VARCHAR(64),
	Salary MONEY,
	PassportID INT
)

CREATE TABLE Passports (
	PassportID INT,
	PassportNumber VARCHAR(64) UNIQUE
	
)

INSERT INTO Passports
	VALUES  (101,'N34FG21B'),
			(102,'K65LO4R7'),
			(103,'ZE657QP2')

INSERT INTO Persons
	VALUES  (1,'Roberto', 43300, 102),
	        (2,'Tom', 56100, 103),
	        (3,'Yana', 60200, 101)

-- Creating primary keys

ALTER TABLE Persons
ALTER COLUMN PersonID INT NOT NULL

ALTER TABLE Passports
ALTER COLUMN PassportID INT NOT NULL

ALTER TABLE Persons
ADD CONSTRAINT PK_Persons_PersonID PRIMARY KEY(PersonID) 

ALTER TABLE Passports
ADD CONSTRAINT PK_Passports_PassportID PRIMARY KEY(PassportID) 

-- Creating Foreign Key

           ALTER TABLE Persons
        ADD CONSTRAINT FK_Persons_Passports_PassportID 
FOREIGN KEY(PassportID) REFERENCES Passports(PassportID)

--

ALTER TABLE Persons
ADD CONSTRAINT UQ_Person_PassportID UNIQUE(PassportID)

--Problem 02 - One to Many 

CREATE TABLE Manufacturers(
             ManufacturerID INT PRIMARY KEY,
			 [Name] VARCHAR(64) NOT NULL,
			 EstablishedOn DATETIME

)

CREATE TABLE Models(
             ModelID INT PRIMARY KEY,
			 [Name] VARCHAR(64) NOT NULL,
			 ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)

)

INSERT INTO Manufacturers(ManufacturerID, [Name],EstablishedOn)
     VALUES 
	 (1, 'BMW', '1916-03-07'),
	 (2, 'Tesla', '2003-01-01'),
	 (3, 'Lada', '1966-05-01')

INSERT INTO Models(ModelID, [Name],ManufacturerID)
     VALUES 
	 (101, 'X1', 1),
	 (102, 'i6', 1),
	 (103, 'Model S', 2),
	 (104, 'Model X', 2),
	 (105, 'Model 3', 2),
	 (106, 'Nova', 3)

--Problem 03 Many to many

CREATE TABLE Students(
	StudentID INT PRIMARY KEY,
	[Name] VARCHAR(64)
)
CREATE TABLE Exams(
	ExamID INT PRIMARY KEY,
	[Name] VARCHAR(64)
)
CREATE  TABLE StudentsExams (
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID),
	CONSTRAINT PK_Students_Exams PRIMARY KEY (StudentID, ExamID)
)
INSERT INTO Students 
VALUES (1,'Mila'), (2, 'Toni'), (3, 'Ron')

INSERT INTO Exams
VALUES (101,'SpringMVC'), (102, 'Neo4j'), (103, 'racle 11g')

INSERT INTO StudentsExams
VALUES (1, 101), (1, 102), (2, 101), (3, 103)

-- Problem 04 Self referencing

CREATE TABLE Teachers (
	TeacherID INT PRIMARY KEY,
	[Name] VARCHAR(64),
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers(TeacherID, [Name])
	VALUES 
	(101, 'John'),
	(102, 'Maya'),
	(103, 'Silvia'),
	(104, 'Ted'),
	(105, 'Mark'),
	(106, 'Greta')

UPDATE Teachers
SET ManagerID = 106
WHERE TeacherID = 102

UPDATE Teachers
SET ManagerID = 106
WHERE TeacherID = 103

UPDATE Teachers
SET ManagerID = 105
WHERE TeacherID = 104

UPDATE Teachers
SET ManagerID = 101
WHERE TeacherID = 105

UPDATE Teachers
SET ManagerID = 101
WHERE TeacherID = 106

SELECT * FROM Teachers

--Problem 05

	CREATE TABLE Cities (
		CityID INT PRIMARY KEY,
		[Name] VARCHAR(128) NOT NULL 
	)

	CREATE TABLE Customers (
		CustomerID INT PRIMARY KEY,
		[Name] VARCHAR(128) NOT NULL,
		Birthday DATETIME,
		CityID INT FOREIGN KEY REFERENCES Cities(CityID)
	)

	CREATE TABLE Orders (
		OrderID INT PRIMARY KEY,
		CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID) 
	)

	CREATE TABLE ItemTypes (
		ItemTypeID INT PRIMARY KEY,
		[Name] VARCHAR(128) NOT NULL 
	)

	CREATE TABLE Items (
		ItemID INT PRIMARY KEY,
		[Name] VARCHAR(128) NOT NULL,
		ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
	)

	CREATE TABLE OrderItems (
		OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) ,
		ItemID INT FOREIGN KEY REFERENCES Items(ItemID)
		CONSTRAINT PK_OrderItems PRIMARY KEY(OrderID, ItemID)
	)

USE TableRelations2

GO

--Problem 06

CREATE TABLE Majors(
	MajorID INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR (64) NOT NULL
)

CREATE TABLE Students(
	StudentID INT PRIMARY KEY IDENTITY,
	StudentNumber VARCHAR (64) NOT NULL,
	StudentName  VARCHAR (128) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Subjects(
	SubjectID INT PRIMARY KEY IDENTITY,
	SubjectName VARCHAR (64) NOT NULL
)

CREATE TABLE Agenda(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
	CONSTRAINT PK_AGENDA PRIMARY KEY (StudentID,SubjectID)
)

CREATE TABLE Payments(
	PaymentID INT PRIMARY KEY IDENTITY,
	PaymentDate DATETIME NOT NULL,
	PaymentAmount DECIMAL(10,2) NOT NULL,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

-- Problem 09

USE Geography

GO

  SELECT MountainRange, PeakName, Elevation 
    FROM Peaks AS p -- p from Peaks, using alias to save typing
    JOIN Mountains 
      AS m ON m.ID = p.MountainID
   WHERE MountainRange = 'Rila'
ORDER BY Elevation DESC

 

