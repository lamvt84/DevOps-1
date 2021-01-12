
CREATE PROCEDURE dbo.usp_EmailConfig_List
AS
    BEGIN
        SELECT *
        FROM dbo.EmailConfig
    END;