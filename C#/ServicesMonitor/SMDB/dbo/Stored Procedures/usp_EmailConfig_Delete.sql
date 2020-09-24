
CREATE PROCEDURE dbo.usp_EmailConfig_Delete @Id INT
AS
    BEGIN
        DELETE FROM dbo.EmailConfig
        WHERE Id = @Id;
    END;