DECLARE @temp_table table
(
	postid int, 
	torecid int, 
	famount decimal(19, 4), 
	fforeignamount decimal(19, 4), 
	dtorecdate datetime,  
	iplrecid int
)
DECLARE @allocs nvarchar(100),
		@Id int

IF OBJECT_ID('tempdb..#temp' ) IS NOT NULL DROP TABLE #temp;
IF OBJECT_ID('tempdb..#temp1' ) IS NOT NULL DROP TABLE #temp1;
IF OBJECT_ID('tempdb..#temp2' ) IS NOT NULL DROP TABLE #temp2;


Select *
Into   #temp
From   PostAR
WHERE	cAllocs is not null

SELECT *
INTO #temp1
From @temp_table

set nocount on
-- select * from #Temp


While EXISTS(SELECT * FROM #Temp)
Begin
	Select Top 1 @Id = AutoIdx, @allocs = cAllocs From #Temp
	INSERT INTO @temp_table
		select iToRecID, * from [dbo].[_efnAllocsSplit](@allocs)
	UPDATE @temp_table
	SET postid = @Id
	INSERT INTO #temp1 
		SELECT * FROM @temp_table

	DELETE FROM @temp_table

    Delete from #Temp Where AutoIdx = @Id

	PRINT ('Row No. ' + CAST(@ID as nvarchar(20)) + ' is Deleted.')

End

GO

SELECT
	#temp1.*,
	AutoIdx,
	TxDate,
	Id,
	AccountLink,
	TrCodeID,
	Debit,
	Credit,
	iCurrencyID,
	fExchangeRate,
	fForeignDebit,
	fForeignCredit,
	Description,
	Reference,
	cReference2,
	Order_No,
	cAuditNumber,
	Outstanding,
	fForeignOutstanding,
	cAllocs,
	InvNumKey
FROM
	PostAR
	RIGHT JOIN
	#temp1 on postar.AutoIdx = #temp1.postid
WHERE postid in (4, 83, 84)

SELECT * INTO #temp2 FROM 
(SELECT
	#temp1.*,
	AutoIdx,
	TxDate,
	Id,
	AccountLink,
	TrCodeID,
	Debit,
	Credit,
	iCurrencyID,
	fExchangeRate,
	fForeignDebit,
	fForeignCredit,
	Description,
	Reference,
	cReference2,
	Order_No,
	cAuditNumber,
	Outstanding,
	fForeignOutstanding,
	cAllocs,
	InvNumKey
FROM
	PostAR
	RIGHT JOIN
	#temp1 on postar.AutoIdx = #temp1.postid
) AS P

DELETE FROM #temp2

ALTER TABLE #temp2
ADD Seq int IDENTITY;

SELECT * FROM #temp1



