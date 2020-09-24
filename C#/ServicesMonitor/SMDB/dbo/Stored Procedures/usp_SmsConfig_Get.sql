
CREATE PROCEDURE dbo.usp_SmsConfig_Get @Id          INT
AS
    BEGIN
        SELECT *
        FROM dbo.SmsConfig
        WHERE Id = @Id;
    END;