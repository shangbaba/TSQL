CREATE PROCEDURE speg_TaskToBudget
AS

MERGE Budget AS TARGET
USING Task AS SOURCE ON TARGET.Task_ID = SOURCE.TaskID 
WHEN NOT MATCHED BY TARGET THEN
	INSERT (Task_ID)
	VALUES (SOURCE.TaskID)
WHEN NOT MATCHED BY SOURCE THEN DELETE
OUTPUT $action,
	INSERTED.Task_ID as TaskAdded,
	DELETED.Task_ID as TaskDeleted;

--EXEC speg_TaskToBudget