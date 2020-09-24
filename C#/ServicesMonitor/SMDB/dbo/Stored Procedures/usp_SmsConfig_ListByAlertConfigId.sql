
CREATE PROCEDURE dbo.usp_SmsConfig_ListByAlertConfigId @AlertConfigId          INT
AS
    BEGIN
        SELECT *
        FROM dbo.SmsConfig
        WHERE AlertConfigId = @AlertConfigId;
    END;