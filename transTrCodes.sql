ALTER PROCEDURE dbo.transTrCodes @t nvarchar(50), @cc nvarchar(50), @cs nvarchar(255)
AS
BEGIN

DECLARE @table nvarchar(50) = 'PostAR',
		@caseColumn nvarchar(50) = 'TrCodeID',
		@columns nvarchar(255) = 'TxDate, Reference,',
		@trCodes nvarchar(MAX),
		@codeID int,
		@code nvarchar(8),
		@whenClause nvarchar(MAX) -- Hold the string like 'WHEN ... THEN ... WHEN ... THEN

-- Set table that needs to convert transaction codes
SET @table = @t

-- Set column that needs to convert transaction codes
SET @caseColumn = @cc

-- Set other columns that are needed
SET @columns = @cs

SET @whenClause = ''
SET @codeID = 1

WHILE @codeID <= (SELECT COUNT(*) FROM TrCodes) -- Check how many rows in the trCodes table
	BEGIN
		SET @code = (SELECT Code FROM TrCodes WHERE idTrCodes = @codeID)
		SET @trCodes = 'WHEN '+ @caseColumn +' = ' + CAST(@codeID AS nvarchar(8)) + ' THEN ''' + @code + ''''
		SET @whenClause = CONCAT(@whenClause, @trCodes, ' ')
		SET @codeID = @codeID + 1
	END
SET @trCodes = 'SELECT ' + @columns + ' CASE ' + @whenClause + ' ELSE ''NOT FOUND'' END AS CodeName FROM ' + @table
EXEC (@trCodes)
END
GO





