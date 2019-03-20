--CREATE DATABASE [Time Management]
--GO

USE [Time Management]
GO

CREATE TABLE Category
(
	CategoryID int IDENTITY(1,1) NOT NULL,
	Name nvarchar(50) NOT NULL,
	CONSTRAINT PK_CategoryID PRIMARY KEY CLUSTERED (CategoryID ASC)
)
GO

CREATE TABLE Task
(
	TaskID int IDENTITY(1,1) NOT NULL,
	Name nvarchar(50) NOT NULL,
	Description nvarchar(100),
	Category_ID int,
	Active bit NOT NULL CONSTRAINT DF_Active DEFAULT (1),
	CONSTRAINT PK_TaskID PRIMARY KEY CLUSTERED (TaskID ASC),
	CONSTRAINT FK_CategoryTask FOREIGN KEY (Category_ID) REFERENCES Category (CategoryID)
)
GO

CREATE TABLE Budget
(
	BudgetID int IDENTITY(1,1) NOT NULL,
	Task_ID int NOT NULL,
	Monday smallint DEFAULT (0),
	Tuesday smallint DEFAULT (0),
	Wednesday smallint DEFAULT (0),
	Thursday smallint DEFAULT (0),
	Friday smallint DEFAULT (0),
	Saturday smallint DEFAULT (0),
	Sunday smallint DEFAULT (0),
	CONSTRAINT PK_BudgetID PRIMARY KEY CLUSTERED (BudgetID ASC),
	CONSTRAINT FK_TaskBudget FOREIGN KEY (Task_ID) REFERENCES Task (TaskID)
)
GO

CREATE TABLE Activity
(
	ActivityID int IDENTITY(1,1) NOT NULL,
	Task_ID int NOT NULL,
	StartTime datetime NOT NULL,
	EndTime datetime  NOT NULL,
	Duration time NOT NULL,
	CONSTRAINT PK_ActivityID PRIMARY KEY CLUSTERED (ActivityID ASC),
	CONSTRAINT FK_TaskActivity FOREIGN KEY (Task_ID) REFERENCES Task (TaskID)
)
GO

CREATE TABLE Provision
(
	ProvisionID int IDENTITY(1,1) NOT NULL,
	Name nvarchar(50) NOT NULL,
	Description nvarchar(100),
	StartTime datetime NOT NULL,
	EndTime datetime NOT NULL,
	Duration time NOT NULL,
	Note nvarchar(250),
	Category nvarchar(50),
	CONSTRAINT PK_ProvisionID PRIMARY KEY CLUSTERED (ProvisionID ASC)
)
GO