
CREATE PROCEDURE dbo.usp_SmsConfig_List
AS
    BEGIN
        SELECT *
        FROM dbo.SmsConfig
    END;