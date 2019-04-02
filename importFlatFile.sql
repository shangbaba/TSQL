CREATE TABLE #dataTMP (	[Task_name] [nvarchar](50) NOT NULL,
	[Task_description] [nvarchar](50) NOT NULL,
	[Start_time] [nvarchar](50) NOT NULL,
	[End_time] [nvarchar](50) NOT NULL,
	[Duration] [nvarchar](50) NOT NULL,
	[Duration_in_hours] [float] NOT NULL,
	[Note] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](50) NOT NULL
)
GO

BULK
INSERT #dataTMP
FROM 'D:\Downloads\CSVFile.csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO

UPDATE #dataTMP
SET [Task_name] = REPLACE([Task_name], CHAR(34), ''),
	[Task_description] = REPLACE([Task_description], CHAR(34), ''),
	[Start_time] = REPLACE([Start_time], CHAR(34), ''),
	[End_time] = REPLACE([End_time], CHAR(34), ''),
	[Duration] = REPLACE([Duration], CHAR(34), ''),
	[Duration_in_hours] = REPLACE([Duration_in_hours], CHAR(34), ''),
	[Note] = REPLACE([Note], CHAR(34), ''),
	[Category] = REPLACE([Category], CHAR(34), '')
GO

INSERT INTO dataStationDay([Task_name] [nvarchar](50) NOT NULL,
	[Task_description] [nvarchar](50) NOT NULL,
	[Start_time] [datetime] NOT NULL,
	[End_time] [datetime] NOT NULL,
	[Duration] [time](0) NOT NULL,
	[Duration_in_hours] [float] NOT NULL,
	[Note] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](50) NOT NULL)
SELECT * FROM #dataTMP

GO

DROP TABLE #dataTMP 

SELECT Task_name, 
Task_description, 
CAST(Start_time AS datetime), 
CAST(End_time AS datetime), 
CAST(Duration AS time(0)),
Duration_in_hours,
Note,
Category
FROM #dataTMP