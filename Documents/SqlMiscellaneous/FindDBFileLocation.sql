SELECT
	@@SERVERNAME AS SName,
    db.name AS DBName,
    type_desc AS FileType,
    Physical_Name AS Location
FROM
    sys.master_files mf
INNER JOIN 
    sys.databases db ON db.database_id = mf.database_id
WHERE db.name NOT IN (
'master',
'tempdb',
'model',
'msdb')