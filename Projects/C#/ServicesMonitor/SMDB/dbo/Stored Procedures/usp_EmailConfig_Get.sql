
CREATE PROCEDURE dbo.usp_EmailConfig_Get @Id          INT
AS
    BEGIN
        SELECT *
        FROM dbo.EmailConfig
        WHERE Id = @Id;
    END;