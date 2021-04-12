CREATE PROCEDURE [dbo].[sp_IndexStats_Collect]
AS
BEGIN
    DECLARE @DatabaseName VARCHAR(50),
            @DatabaseId INT
    DECLARE @ServerName VARCHAR(50) = @@SERVERNAME
    DECLARE @Sql NVARCHAR(4000)
    DECLARE @IndexStats TABLE
    (
        [server_name] [varchar](50) NULL,
        [database_id] [int] NULL,
        [database_name] [varchar](30) NULL,
        [object_id] [int] NULL,
        [index_id] [int] NULL,
        [index_type] [int] NULL,
        [schema_name] [varchar](30) NULL,
        [object_name] [varchar](150) NULL,
        [index_name] [varchar](150) NULL,
        [object_type] [varchar](10) NULL,
        [is_unique] [bit] NULL,
        [is_primary_key] [bit] NULL,
        [is_XML] [bit] NULL,
        [is_spatial] [bit] NULL,
        [is_NC_columnstore] [bit] NULL,
        [is_CX_columnstore] [bit] NULL,
        [is_in_memory_oltp] [bit] NULL,
        [is_disabled] [bit] NULL,
        [is_hypothetical] [bit] NULL,
        [is_padded] [bit] NULL,
        [fill_factor] [tinyint] NULL,
        [filter_definition] [nvarchar](max) NULL,
        [user_seeks] [bigint] NULL,
        [user_scans] [bigint] NULL,
        [user_lookups] [bigint] NULL,
        [user_updates] [bigint] NULL,
        [last_user_seek] [datetime] NULL,
        [last_user_scan] [datetime] NULL,
        [last_user_lookup] [datetime] NULL,
        [last_user_update] [datetime] NULL,
        [create_date] [datetime] NULL,
        [modify_date] [datetime] NULL
    )

    DECLARE c CURSOR FAST_FORWARD FOR
    SELECT database_id,
           name
    FROM sys.databases
    WHERE name LIKE 'KiotViet%'

    OPEN c
    FETCH NEXT FROM c
    INTO @DatabaseId,
         @DatabaseName

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Sql
            = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                SELECT  ''' + @ServerName + ''' AS server_name,
						' + CAST(@DatabaseId AS NVARCHAR(10)) + N' AS database_id,
						''' + @DatabaseName
              + ''' AS database_name, 
                        so.object_id, 
                        si.index_id, 
                        si.type,                        
                        COALESCE(sc.NAME, ''Unknown'') AS [schema_name],
                        COALESCE(so.name, ''Unknown'') AS [object_name], 
                        COALESCE(si.name, ''Unknown'') AS [index_name],
                        CASE WHEN so.[type] = CAST(''V'' AS CHAR(2)) THEN ''View'' ELSE ''Table'' END, 
                        si.is_unique, 
                        si.is_primary_key, 
                        CASE when si.type = 3 THEN 1 ELSE 0 END AS is_XML,
                        CASE when si.type = 4 THEN 1 ELSE 0 END AS is_spatial,
                        CASE when si.type = 6 THEN 1 ELSE 0 END AS is_NC_columnstore,
                        CASE when si.type = 5 then 1 else 0 end as is_CX_columnstore,
                        CASE when si.data_space_id = 0 then 1 else 0 end as is_in_memory_oltp,
                        si.is_disabled,
                        si.is_hypothetical, 
                        si.is_padded, 
                        si.fill_factor,                       
                        CASE WHEN si.filter_definition IS NOT NULL THEN si.filter_definition
                             ELSE N''''
                        END AS filter_definition,
                        ISNULL(us.user_seeks, 0),
                        ISNULL(us.user_scans, 0),
                        ISNULL(us.user_lookups, 0),
                        ISNULL(us.user_updates, 0),
                        us.last_user_seek,
                        us.last_user_scan,
                        us.last_user_lookup,
                        us.last_user_update,
                        so.create_date,
                        so.modify_date
                FROM    ' + QUOTENAME(@DatabaseName)
              + N'.sys.indexes AS si WITH (NOLOCK)
                        JOIN ' + QUOTENAME(@DatabaseName)
              + N'.sys.objects AS so WITH (NOLOCK) ON si.object_id = so.object_id
                                               AND so.is_ms_shipped = 0 /*Exclude objects shipped by Microsoft*/
                                               AND so.type <> ''TF'' /*Exclude table valued functions*/
                        JOIN ' + QUOTENAME(@DatabaseName)
              + N'.sys.schemas sc ON so.schema_id = sc.schema_id
                        LEFT JOIN sys.dm_db_index_usage_stats AS us WITH (NOLOCK) ON si.[object_id] = us.[object_id]
                                                                       AND si.index_id = us.index_id
                                                                       AND us.database_id = '
              + CAST(@DatabaseId AS NVARCHAR(10))
              + N'
                WHERE    si.[type] IN ( 0, 1, 2, 3, 4, 5, 6 ) 
                /* Heaps, clustered, nonclustered, XML, spatial, Cluster Columnstore, NC Columnstore */ 
				OPTION    ( RECOMPILE );
        ';
        PRINT @Sql
        INSERT @IndexStats
        EXECUTE sp_executesql @Sql;

        FETCH NEXT FROM c
        INTO @DatabaseId,
             @DatabaseName
    END

    CLOSE c
    DEALLOCATE c

    SELECT *
    FROM @IndexStats
    ORDER BY [schema_name],
             [object_name],
             [index_type]
END
GO