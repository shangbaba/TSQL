CREATE PROCEDURE speg_ProcToActivity
AS

WITH ProcActivity AS (
SELECT t.TaskID as Task_ID, StartTime, EndTime, Duration
FROM Provision p
INNER JOIN Task t ON p.Name = t.Name)

MERGE Activity AS TARGET
USING ProcActivity AS SOURCE ON TARGET.StartTime = SOURCE.StartTime
	AND TARGET.EndTime = SOURCE.EndTime 
WHEN NOT MATCHED BY TARGET THEN
	INSERT (Task_ID, StartTime, EndTime, Duration)
	VALUES (SOURCE.Task_ID, SOURCE.StartTime, SOURCE.EndTime, SOURCE.Duration)
OUTPUT $action,
	INSERTED.Task_ID as TaskEntryAdded,
	INSERTED.StartTime,
	INSERTED.EndTime,
	INSERTED.Duration;
