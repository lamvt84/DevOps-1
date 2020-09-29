CREATE PROCEDURE [dbo].[usp_Services_ListByGroupId] @GroupId INT
AS
    BEGIN
        IF (@GroupId > 0)
            SELECT s.*, g.Name GroupName
            FROM dbo.[Services] s
                JOIN dbo.Groups g ON s.GroupId = g.Id
            WHERE GroupId = @GroupId
            ORDER BY Name ASC;
        ELSE
            SELECT s.*, g.Name GroupName
            FROM dbo.[Services] s
                JOIN dbo.Groups g ON s.GroupId = g.Id
            ORDER BY Name ASC;
    END;