USE [Time Management]
GO
/****** Object:  StoredProcedure [dbo].[speg_ProvToTask]    Script Date: 27/03/2019 10:43:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[speg_ProvToTask]
AS

WITH dedupedTask AS (
SELECT DISTINCT p.Name, description, c.CategoryID AS Cat_ID
FROM Provision p
INNER JOIN Category c ON p.Category = c.Name)

MERGE Task AS TARGET
USING dedupedTask AS SOURCE ON TARGET.Name = SOURCE.Name
WHEN MATCHED AND (TARGET.Description <> SOURCE.Description OR
				  TARGET.Category_ID <> SOURCE.Cat_ID) THEN
	UPDATE
		SET TARGET.Description = SOURCE.Description,
			TARGET.Category_ID = SOURCE.Cat_ID
WHEN NOT MATCHED BY TARGET THEN
	INSERT (Name, Description, Category_ID)
	VALUES (SOURCE.Name, SOURCE.Description, SOURCE.Cat_ID)
OUTPUT $action,
	INSERTED.Name as TaskAdded,
	INSERTED.Description as DescriptionAdded,
	INSERTED.Category_ID as CategoryAdded;