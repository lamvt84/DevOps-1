CREATE PROCEDURE dbo.usp_Services_ListByStatus @Status TINYINT = 1
AS
    BEGIN        
        SELECT *
        FROM dbo.[Services]
        WHERE [Status] = @Status
    END;