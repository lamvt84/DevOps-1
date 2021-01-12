CREATE PROCEDURE dbo.usp_Services_GetServiceSummary 
AS
    BEGIN        
        SELECT COUNT(*) AS TotalService, SUM(CASE WHEN Status = 0 THEN 1 ELSE 0 END) AS ErrorService
        FROM dbo.[Services]
        WHERE Enable = 1;
    END;