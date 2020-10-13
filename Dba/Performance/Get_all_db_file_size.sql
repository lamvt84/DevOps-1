SELECT CONCAT( ' UNION ALL ', 'SELECT '
                        ,'''Database layout'' AS [object],'
                        ,' N'''
                        ,'[' + name + ']'
                        ,'''' 
                        ,' AS databaseName'
                        ,',filegroups.name AS fileGroupName
                          ,physical_name AS fileName
                          ,database_files.name AS [Name]
                          ,filegroups.type AS fileGroupType
                          ,IsContainer = IIF(filegroups.type = ''FX'', ''Yes'', ''No'')
                          ,filegroups.type_desc AS fileGroupDescription
                          ,database_files.state_desc AS fileGroupState
                          ,FORMAT(database_files.size * CONVERT(BIGINT, 8192) / 1024, ''###,###,###,###'') AS sizeKB
                          ,FORMAT(database_files.size * CONVERT(BIGINT, 8192) / 1048576.0, ''###,###,###,###'') AS sizeMB
                          ,FORMAT(database_files.size * CONVERT(BIGINT, 8192) / 1073741824.0, ''###,###,###,###.##'') AS sizeGB
                          ,FORMAT(SUM(database_files.size / 128.0) OVER(), ''###,###,###,###'') AS totalSizeMB
                        FROM '
                        ,'[' + name + ']'
                        ,'.sys.database_files
                        LEFT JOIN '
                        ,'[' + name + ']'
                        ,'.sys.filegroups ON database_files.data_space_id = filegroups.data_space_id')
    FROM sys.databases
    WHERE name NOT IN ( 'master', 'model', 'tempdb', 'distribution', 'msdb', 'SSISDB', 'masterdb', 'DBATools')  
    AND state_desc = 'ONLINE';