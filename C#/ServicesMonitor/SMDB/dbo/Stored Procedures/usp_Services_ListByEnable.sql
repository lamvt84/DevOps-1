CREATE PROCEDURE dbo.usp_Services_ListByEnable @Enable TINYINT
AS
    BEGIN        
        SELECT s.*, g.Name GroupName
        FROM dbo.[Services] s
            JOIN dbo.Groups g ON s.GroupId = g.Id
        WHERE [Enable] = @Enable
    END;