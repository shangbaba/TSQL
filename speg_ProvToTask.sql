ALTER PROCEDURE speg_ProvToTask
AS

WITH dedupedTask AS (
SELECT DISTINCT p.Name, description, c.CategoryID AS Cat_ID
FROM Provision p
INNER JOIN Category c ON p.Category = c.Name)

MERGE Task AS TARGET
USING dedupedTask AS SOURCE ON TARGET.Name = SOURCE.Name 
WHEN NOT MATCHED BY TARGET THEN
	INSERT (Name, Description, Category_ID)
	VALUES (SOURCE.Name, SOURCE.Description, SOURCE.Cat_ID)
OUTPUT $action,
	INSERTED.Name as TaskAdded,
	INSERTED.Description as DescriptionAdded,
	INSERTED.Category_ID as CategoryAdded;

--EXEC speg_ProvToTask