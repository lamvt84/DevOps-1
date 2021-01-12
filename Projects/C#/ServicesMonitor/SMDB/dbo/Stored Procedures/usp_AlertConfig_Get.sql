
CREATE PROCEDURE dbo.usp_AlertConfig_Get @Id          INT
AS
    BEGIN
        SELECT *
        FROM dbo.AlertConfig
        WHERE Id = @Id;
    END;