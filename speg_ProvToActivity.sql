USE [Time Management]
GO
/****** Object:  StoredProcedure [dbo].[speg_ProcToActivity]    Script Date: 27/03/2019 10:32:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[speg_ProvToActivity]
AS

WITH ProcActivity AS (
SELECT t.TaskID as Task_ID, StartTime, EndTime, Duration
FROM Provision p
INNER JOIN Task t ON p.Name = t.Name)

MERGE Activity AS TARGET
USING ProcActivity AS SOURCE ON TARGET.Task_ID = SOURCE.Task_ID AND 
								TARGET.StartTime = SOURCE.StartTime

WHEN MATCHED AND (TARGET.EndTime <> SOURCE.Endtime OR 
				  TARGET.Duration <> SOURCE.Duration) THEN
	UPDATE
		SET TARGET.EndTime = SOURCE.EndTime,
			TARGET.Duration = SOURCE.Duration

WHEN NOT MATCHED BY TARGET THEN
	INSERT (Task_ID, StartTime, EndTime, Duration)
	VALUES (SOURCE.Task_ID, SOURCE.StartTime, SOURCE.EndTime, SOURCE.Duration)
OUTPUT $action,
	INSERTED.Task_ID as TaskEntries,
	INSERTED.StartTime,
	INSERTED.EndTime,
	INSERTED.Duration;