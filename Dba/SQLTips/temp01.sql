SELECT * FROM dbo.AlertConfig
SELECT * FROM dbo.EmailConfig

TRUNCATE TABLE dbo.AlertConfig
TRUNCATE TABLE dbo.EmailConfig

UPDATE dbo.Services
SET Status = 0
WHERE Id = 1