CREATE TRIGGER trDelAgtNotAllowed on _rtblAgents
    INSTEAD OF DELETE
AS

BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0
        RETURN;

    SET NOCOUNT ON;

    BEGIN
        RAISERROR
            (N'Agents cannot be deleted. They can only be marked as inactive.', -- Error message.
            10, -- Severity.
            1); -- State.

        -- Rollback any active or uncommittable transactions
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;
    END;
END;

GO