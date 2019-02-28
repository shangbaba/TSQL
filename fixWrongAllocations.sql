IF OBJECT_ID('tempdb..#tempEGevo' ) IS NOT NULL DROP TABLE #tempEGevo;
IF OBJECT_ID('tempdb..#tempEGevo1' ) IS NOT NULL DROP TABLE #tempEGevo1;
IF OBJECT_ID('tempdb..#tempEGevo2' ) IS NOT NULL DROP TABLE #tempEGevo2;

SET NOCOUNT ON

-- Create a temp table variable for feeding translated allocs info into the temp table
-- The @temp_table is just to temparorily hold translated allocs for each allocation string
DECLARE @allocs nvarchar(100), -- For allocs strings
		@Id int, -- For PostAP/PostAR AutoIdx
		@temp_table table
		(
			postid int, 
			torecid int, 
			famount decimal(19, 4), 
			fforeignamount decimal(19, 4), 
			dtorecdate datetime,  
			iplrecid int
		)

-- Create a temp table to hold all allocated transactions in PostAR/PostAP for a specific account
SELECT *
INTO   #tempEGevo
FROM   postap
WHERE	cAllocs is not null and AccountLink = 175 --This needs to be changed

-- Create a temp table to have the exact same columns as the table variable
SELECT *
INTO #tempEGevo1
FROM @temp_table

-- Loop through the tempEGevo and populate tempEGevo1 with translated allocs details
WHILE EXISTS(SELECT * FROM #tempEGevo)
BEGIN
	SELECT TOP 1 @Id = AutoIdx, @allocs = cAllocs From #tempEGevo -- set @Id and @allocs values
	INSERT INTO @temp_table										  -- Insert duplicate values into the postid column
		SELECT iToRecID, * FROM [dbo].[_efnAllocsSplit](@allocs)  -- Doesn't matter which column to use
	UPDATE @temp_table											  -- Because it will be updated at this step anyway
	SET postid = @Id											  -- with the PostAP/PostAR AutoIdx
	INSERT INTO #tempEGevo1										  -- Then the records are inserted into the consolidated
		SELECT * FROM @temp_table								  -- holding table tempEGevo1

	DELETE FROM @temp_table										  -- The variable will be emptied for the next allocation string

    DELETE FROM #tempEGevo Where AutoIdx = @Id					  -- Part of the loop to reduce record from the tempEGevo as it has been processed

	-- This is just to print a message out
	PRINT ('AutoIdx ' + CAST(@ID as nvarchar(20)) + ' in the #tempEGevo table' + ' has been Deleted.')
END
GO

-- Show the translated allocs along with the PostAP/PostAR information
SELECT
	#tempEGevo1.*,
	cAllocs,
	cAuditNumber,
	Debit,
	Credit,
	TxDate,
	Id,
	AccountLink,
	TrCodeID,
	iCurrencyID,
	fExchangeRate,
	fForeignDebit,
	fForeignCredit,
	Description,
	Reference,
	cReference2,
	Order_No,
	Outstanding,
	fForeignOutstanding,
	InvNumKey
FROM
	postap
	RIGHT JOIN
	#tempEGevo1 on postap.AutoIdx = #tempEGevo1.postid
WHERE dtorecdate = '20190227'
ORDER BY torecid DESC
GO

-- Steps to reverse the allocations
-- Step 1, find the audit trail numbers for all PEX/LEX transactions from PostAP/PostAR
SELECT * FROM PostAP WHERE cAuditNumber like '1609%'
GO
-- Step 2, check and delete all PEX/LEX transactions in PostGL
SELECT * 
FROM PostGL 
WHERE cAuditNumber IN (
	SELECT cAuditNumber FROM PostAP WHERE cAuditNumber like '1609%')
GO

DELETE FROM PostGL 
WHERE cAuditNumber IN (
	SELECT cAuditNumber FROM PostAP WHERE cAuditNumber like '1609%')
GO

-- Step 3, delete all PEX/LEX transactions in PostAP/PostAR
DELETE FROM PostAP WHERE cAuditNumber like '1609%'
GO

-- Step 4, update PostAP/PostAR table as follows
UPDATE PostAP
SET cAllocs = NULL, Outstanding = Credit, fForeignOutstanding = fForeignCredit
WHERE AutoIdx IN (
SELECT AutoIdx FROM postap
	RIGHT JOIN
	#tempEGevo1 on postap.AutoIdx = #tempEGevo1.postid
	WHERE dtorecdate = '20190227'
)
GO

-- Remove all the temp tables that are created
IF OBJECT_ID('tempdb..#tempEGevo' ) IS NOT NULL DROP TABLE #tempEGevo;
IF OBJECT_ID('tempdb..#tempEGevo1' ) IS NOT NULL DROP TABLE #tempEGevo1;
IF OBJECT_ID('tempdb..#tempEGevo2' ) IS NOT NULL DROP TABLE #tempEGevo2;
GO