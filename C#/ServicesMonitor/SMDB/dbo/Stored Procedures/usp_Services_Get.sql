
CREATE PROCEDURE dbo.usp_Services_Get @Id INT
AS
    BEGIN
        SELECT s.*, 
               g.Name GroupName,
               g.Tag GroupTag
        FROM dbo.[Services] s
            LEFT JOIN dbo.Groups g ON s.GroupId = g.Id
        WHERE s.Id = @Id;
    END;