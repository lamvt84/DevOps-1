# Mapping Orphan Users with SQL Login

```sql
DECLARE @command varchar(1000) 

SELECT @command = 'IF ''?'' NOT IN(''master'', ''model'', ''msdb'', ''tempdb'') BEGIN USE ? 
		SELECT ''USE ?'' AS cmd
		UNION ALL
		SELECT ''GO'' AS cmd
		UNION ALL
		SELECT ''EXEC sp_change_users_login '''''' + name + '''''', '''''' + name + '''''''' AS cmd
		FROM sys.database_principals
		WHERE type = ''S''
			AND authentication_type = 1
			AND name NOT IN (''dbo'')
		UNION ALL 
		SELECT ''GO'' AS cmd
   END' 

EXEC sp_MSforeachdb @command 
```