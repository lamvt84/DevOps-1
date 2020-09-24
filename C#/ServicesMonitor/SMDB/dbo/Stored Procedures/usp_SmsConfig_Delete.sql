
CREATE PROCEDURE dbo.usp_SmsConfig_Delete @Id INT
AS
    BEGIN
        DELETE FROM dbo.SmsConfig
        WHERE Id = @Id;
    END;