CREATE PROCEDURE dbo.usp_Services_ListByEnable @Enable TINYINT
AS
    BEGIN        
        SELECT *
        FROM dbo.[Services]
        WHERE [Enable] = @Enable
    END;