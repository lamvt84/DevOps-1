
CREATE PROCEDURE dbo.usp_Services_Get @Id INT
AS
    BEGIN
        SELECT * FROM dbo.[Services] WHERE Id = @Id
    END;