CREATE PROCEDURE egspLastGRVProcessed
AS

IF OBJECT_ID('lastGRVProcessed', 'U') IS NULL
	BEGIN
		CREATE TABLE [dbo].[lastGRVProcessed](
			[Reference] [varchar](50) NULL,
			[AutoIdx] [bigint] NOT NULL,
			[Id] [varchar](5) NOT NULL,
			[TrCodeID] [int] NULL,
			[Order_No] [varchar](50) NULL
			) ON [PRIMARY]
	END;


-- Insert only the lastest processed GRV's into the lastGRVProcessed table.


DECLARE @topLGPID int,
		@topGLID int
SET @topLGPID = (SELECT TOP 1 lastGRVProcessed.AutoIdx FROM lastGRVProcessed ORDER BY lastGRVProcessed.AutoIdx DESC)
SET @topGLID = (SELECT TOP 1 PostGL.AutoIdx	FROM PostGL ORDER BY PostGL.AutoIdx DESC)

IF @topLGPID <> '' -- If the table is not freshly created then do the following.
	BEGIN
		IF @topLGPID < @topGLID -- Comparing the ID in lastGRVProcessed table and ID in PostGL to determine whether there are new GRV's.
			BEGIN
				DELETE FROM lastGRVProcessed  -- Empty the table to make room for the latest processed GRV's.
				INSERT INTO lastGRVProcessed  -- Insert the latest processed GRV's into the lastGRVProcessed table.
					SELECT DISTINCT Reference, MAX(PostGL.AutoIdx), Id, TrCodeID, Order_No
					FROM PostGL
					WHERE PostGL.AutoIdx > @topLGPID AND TrCodeID = 36
					GROUP BY Reference, Id, TrCodeID, Order_No
			END;
	END;
ELSE  -- If the table is freshly created with no records, insert the lastest GRV into it.
	INSERT INTO lastGRVProcessed
		SELECT TOP 1 PostGL.AutoIdx, Id, TrCodeID, Reference, Order_No
		FROM PostGL
		ORDER BY PostGL.AutoIdx DESC;
GO


-- Testing Scripts
/*
INSERT INTO lastGRVProcessed 
	SELECT PostGL.AutoIdx, Id, TrCodeID, Reference, Order_No FROM PostGL WHERE PostGL.autoidx = 1350

INSERT INTO lastGRVProcessed 
	SELECT Reference, PostGL.AutoIdx, Id, TrCodeID, Order_No FROM PostGL WHERE PostGL.autoidx = 1350

SELECT * FROM lastGRVProcessed

DELETE FROM lastGRVProcessed
*/


select top 100 ilinkeddocID, * from invnum
where invdate = CAST(GETDATE() AS DATE)  -- GrvNumber = 'GRV0048'

SELECT TOP 100 iSOLinkedPOLineID, * FROM _btblinvoicelines
order by iinvoiceID desc

select top 10 * from PostGL
where txdate = CAST(GETDATE() AS DATE)