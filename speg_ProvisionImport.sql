USE [Time Management]
GO
/****** Object:  StoredProcedure [dbo].[speg_ProvisionImport]    Script Date: 27/03/2019 9:55:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[speg_ProvisionImport]
AS

WITH PreProvision AS (
SELECT
	Task_name, Task_description, Start_time, End_time, Duration, Note, Category
FROM CSVFile)

MERGE Provision AS TARGET
USING PreProvision AS SOURCE ON TARGET.Name = SOURCE.Task_name AND 
								TARGET.StartTime = SOURCE.Start_Time
WHEN MATCHED AND (TARGET.EndTime <> SOURCE.End_time OR 
				  TARGET.Category <> SOURCE.Category OR
				  TARGET.Description <> SOURCE.Task_description OR
				  TARGET.Duration <> SOURCE.Duration) THEN
	UPDATE
		SET TARGET.EndTime = SOURCE.End_time,
			TARGET.Duration = SOURCE.Duration,
			TARGET.Category = SOURCE.Category,
			TARGET.Description = SOURCE.Task_description
WHEN NOT MATCHED BY TARGET THEN
	INSERT (Name, Description, StartTime, EndTime, Duration, Note, Category)
	VALUES (SOURCE.Task_name, 
			SOURCE.Task_description, 
			SOURCE.Start_time, 
			SOURCE.End_time, 
			SOURCE.Duration, 
			SOURCE.Note, 
			SOURCE.Category)

OUTPUT $action,
	INSERTED.Name as TaskEntries,
	INSERTED.StartTime,
	INSERTED.EndTime,
	INSERTED.Duration;