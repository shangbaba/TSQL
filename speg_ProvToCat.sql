CREATE PROCEDURE speg_ProvToCat
AS

WITH dedupedCat AS (SELECT DISTINCT Category FROM Provision)

MERGE Category AS TARGET
USING dedupedCat AS SOURCE ON TARGET.name = SOURCE.Category
WHEN NOT MATCHED BY TARGET THEN
	INSERT (name)
	VALUES (SOURCE.Category)
OUTPUT $action,
	INSERTED.name as newCategory;

--TRUNCATE TABLE Category
--EXEC speg_ProvToCat

--SELECT * FROM Category