-- Create a temp table to hold values
CREATE TABLE exchangeRateAudit
(
	ID int IDENTITY,
	AuditNo nvarchar(50),
	ExchangeRateAP float,
	ForeignDebit float,
	ForeignCredit float,
	ForeignOutstanding float,
	Allocation text
)
GO


/*
INSERT INTO exchangeRateAudit
	select cAuditNumber, fExchangeRate, fForeignDebit, fForeignCredit, fForeignOutstanding, cAllocs
	from PostAP
	where iCurrencyID <> 0
GO
*/

DECLARE @Count int, 
		@x int,
		@exRateAP float,
		@exRateGL float,
		@AuditNo nvarchar(50)
SET @x = 1
SET @Count = (SELECT COUNT(*) FROM exchangeRateAudit)
PRINT @x

WHILE @x <= @Count
	SET @AuditNo = (
		SELECT AuditNo FROM exchangeRateAudit WHERE id = @x
	)
	SET @exRateAP = (
		SELECT ExchangeRateAP FROM exchangeRateAudit WHERE id = @x
	)
	SET @exRateGL = (
		SELECT fExchangeRate FROM PostGL WHERE cAuditNumber = @AuditNo AND Credit <> 0
	)
	PRINT @AuditNo + str(@exRateAP) + str(exRateGL)
GO
	

SELECT * FROM exchangeRateAudit

SELECT * FROM PostGL
WHERE cAuditNumber IN (SELECT AuditNo FROM exchangeRateAudit)




If(OBJECT_ID('exchangeRateAudit') Is Not Null)
Begin
    Drop Table exchangeRateAudit
End