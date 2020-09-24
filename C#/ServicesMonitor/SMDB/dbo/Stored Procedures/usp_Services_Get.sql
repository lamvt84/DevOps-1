
CREATE PROCEDURE dbo.usp_Services_Get @Id INT
AS
    BEGIN
        SELECT s.*, 
               g.Name GroupName
        FROM dbo.[Services] s
             JOIN dbo.Groups g ON s.GroupId = g.Id
        WHERE s.Id = @Id;
    END;