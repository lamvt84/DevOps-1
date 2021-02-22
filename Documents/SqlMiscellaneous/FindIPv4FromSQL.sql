/* enable xp_cmdshell */
USE master
GO
EXEC sp_configure 'show advanced options', '1'
RECONFIGURE
EXEC sp_configure 'xp_cmdshell', '1'
RECONFIGURE
GO
DECLARE @ip VARCHAR(40)
DECLARE @ipLine VARCHAR(200)
DECLARE @pos INT
CREATE TABLE #temp
(
    ipLine VARCHAR(200)
)
INSERT #temp
EXEC master..xp_cmdshell 'ipconfig'
SELECT @@SERVERNAME,
       RTRIM(LTRIM(SUBSTRING(ipLine, CHARINDEX(':', ipLine, 1) + 1, LEN(ipLine) - CHARINDEX(':', ipLine, 1)))) IPv4
FROM #temp
WHERE UPPER(ipLine) LIKE '%IPV4 ADDRESS%'
DROP TABLE #temp
/* disable xp_cmdshell */
EXEC sp_configure 'show advanced options', '1'
RECONFIGURE
EXEC sp_configure 'xp_cmdshell', '0'
RECONFIGURE
GO