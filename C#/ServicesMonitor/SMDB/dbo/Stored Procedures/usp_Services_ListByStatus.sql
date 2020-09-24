CREATE PROCEDURE dbo.usp_Services_ListByStatus @Status TINYINT = 1
AS
    BEGIN        
        SELECT s.*, g.Name GroupName
        FROM dbo.[Services] s
            JOIN dbo.Groups g ON s.GroupId = g.Id
        WHERE [Status] = @Status
    END;