CREATE PROCEDURE speg_ProcToTables
AS
EXEC speg_ProvisionImport
EXEC speg_ProvToCat
EXEC speg_ProvToTask
EXEC speg_TaskToBudget
EXEC speg_ProvToActivity

DROP TABLE CSVFile
GO