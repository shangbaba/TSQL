use [Time Management]

CREATE TABLE Task
(
	AutoIdx int IDENTITY(1,1) NOT NULL,
	Name nvarchar(50) NOT NULL,
	Description nvarchar(100),
	Category nvarchar(25),
	Active bit NOT NULL
)
GO

CREATE TABLE Budget
(
	AutoIdx int IDENTITY(1,1) NOT NULL,
	Task_ID int NOT NULL,
	Value smallint,
	Monday bit NOT NULL,
	Tuesday bit NOT NULL,
	Wednesday bit NOT NULL,
	Thursday bit NOT NULL,
	Friday bit NOT NULL,
	Saturday bit NOT NULL,
	Sunday bit NOT NULL
)
GO

CREATE TABLE Category
(
	AutoIdx int IDENTITY(1,1) NOT NULL,
	Name nvarchar(25) NOT NULL
)
GO

CREATE TABLE Activity
(
	AutoIdx int IDENTITY(1,1) NOT NULL,
	Task_ID int NOT NULL,
	StartTime datetime NOT NULL,
	CreatedOn datetime NOT NULL
)