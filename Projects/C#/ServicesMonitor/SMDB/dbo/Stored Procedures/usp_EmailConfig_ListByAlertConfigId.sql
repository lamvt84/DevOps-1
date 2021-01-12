
CREATE PROCEDURE dbo.usp_EmailConfig_ListByAlertConfigId @AlertConfigId          INT
AS
    BEGIN
        SELECT *
        FROM dbo.EmailConfig
        WHERE AlertConfigId = @AlertConfigId;
    END;