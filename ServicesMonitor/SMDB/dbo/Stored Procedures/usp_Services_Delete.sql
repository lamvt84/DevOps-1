
CREATE PROCEDURE dbo.usp_Services_Delete @Id INT
AS
    BEGIN
        DELETE FROM dbo.[Services]
        WHERE Id = @Id;
    END;