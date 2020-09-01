CREATE PROCEDURE [dbo].[usp_Services_ListByGroupId] @GroupId INT
AS
    BEGIN
        IF (@GroupId > 0)
            SELECT *
            FROM dbo.[Services]
            WHERE GroupId = @GroupId;
        ELSE
            SELECT *
            FROM dbo.[Services];
    END;