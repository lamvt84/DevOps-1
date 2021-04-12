CREATE PROCEDURE [dbo].[pr_HourlySlowReport]
(
    @Interval INT, --Report from last ? hour
    @EmailTo NVARCHAR(200),
    @DBName NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @subject NVARCHAR(200),
            @body NVARCHAR(MAX),
            @xml NVARCHAR(MAX),
            @isSessionOn NVARCHAR(200) = '',
            @receipt_db NVARCHAR(MAX);
    SELECT @receipt_db = list_mail
    FROM CitigoMailList
    WHERE type = 1
          AND status = 1; -- type : 1-> slow, 2-->block, 3--> deadlock || status: 0-->invalid, 1-->valid
    DECLARE @error NVARCHAR(MAX) = ''
    BEGIN TRY
        --Get report
        ;WITH cte
         AS (SELECT COUNT(ID) AS [EventsCount],
                    CAST(AVG([Duration]) AS NUMERIC(32, 2)) AS [AVGDuration],
                    CAST(AVG([CPUTime]) AS NUMERIC(32, 2)) AS [AVGCPUTime],
                    AVG([PhysicalReads]) AS AVGPhysicalReads,
                    AVG([LogicalReads]) AS AVGLogicalReads,
                    AVG([Writes]) AS AVGWrites,
                    CASE --filter SQL text for grouping
                        WHEN [STMT_Batch_Text] LIKE N'%prClearRetailerAndSendMail%' THEN
                            'prClearRetailerAndSendMail'
                        WHEN [STMT_Batch_Text] LIKE N'%pr_Product_Group%' THEN
                            'exec [dbo].[pr_Product_Group]'
                        WHEN [STMT_Batch_Text] LIKE N'%ImportProduct%' THEN
                            'ImportProduct'
                        --if UPDATE then get all SQL text before SET
                        WHEN [STMT_Batch_Text] LIKE N'%UPDATE%' THEN
                            SUBSTRING(   [STMT_Batch_Text],
                                         1,
                                         CASE
                                             WHEN CHARINDEX('SET', [STMT_Batch_Text]) = 0 THEN
                                                 300
                                             ELSE
                                                 CHARINDEX('SET', [STMT_Batch_Text]) - 1
                                         END
                                     )
                        --if INSERT then get all SQL text untill table name or ]([
                        WHEN [STMT_Batch_Text] LIKE N'%INSERT%' THEN
                            SUBSTRING(   [STMT_Batch_Text],
                                         1,
                                         CASE
                                             WHEN CHARINDEX(']([', [STMT_Batch_Text]) = 0 THEN
                                                 300
                                             ELSE
                                                 CHARINDEX(']([', [STMT_Batch_Text])
                                         END
                                     )
                        --if DELETE then get all SQL text before WHERE
                        WHEN [STMT_Batch_Text] LIKE N'%DELETE%' THEN
                            SUBSTRING(   [STMT_Batch_Text],
                                         1,
                                         CASE
                                             WHEN CHARINDEX('WHERE', [STMT_Batch_Text]) = 0 THEN
                                                 300
                                             ELSE
                                                 CHARINDEX('WHERE', [STMT_Batch_Text]) - 1
                                         END
                                     )
                        --get all exec stored procedure untill @ where param are set
                        WHEN CHARINDEX('exec [dbo]', [STMT_Batch_Text]) = 1 THEN
                            REPLACE(SUBSTRING([STMT_Batch_Text], 1, CHARINDEX('@', [STMT_Batch_Text])), '@', '')
                        WHEN [STMT_Batch_Text] = '' THEN
                            CAST([SQLText] AS NVARCHAR(300))
                        ELSE
                            CAST([STMT_Batch_Text] AS NVARCHAR(300))
                    END AS [ShortedSQLText]
             FROM SlowQueryLog WITH (NOLOCK)
             WHERE [Time]
                   BETWEEN DATEADD(HOUR, - (@Interval), GETDATE()) AND GETDATE()
                   --Eliminate system queries
                   AND CHARINDEX('.sql', [STMT_Batch_Text]) = 0
                   AND CHARINDEX('@profile_name', [STMT_Batch_Text]) = 0
                   AND CHARINDEX('@fromDate', [STMT_Batch_Text]) = 0
             GROUP BY CASE --filter SQL text for grouping
                          WHEN [STMT_Batch_Text] LIKE N'%prClearRetailerAndSendMail%' THEN
                              'prClearRetailerAndSendMail'
                          WHEN [STMT_Batch_Text] LIKE N'%pr_Product_Group%' THEN
                              'exec [dbo].[pr_Product_Group]'
                          WHEN [STMT_Batch_Text] LIKE N'%ImportProduct%' THEN
                              'ImportProduct'
                          --if UPDATE then get all SQL text before SET
                          WHEN [STMT_Batch_Text] LIKE N'%UPDATE%' THEN
                              SUBSTRING(   [STMT_Batch_Text],
                                           1,
                                           CASE
                                               WHEN CHARINDEX('SET', [STMT_Batch_Text]) = 0 THEN
                                                   300
                                               ELSE
                                                   CHARINDEX('SET', [STMT_Batch_Text]) - 1
                                           END
                                       )
                          --if INSERT then get all SQL text untill table name or ]([
                          WHEN [STMT_Batch_Text] LIKE N'%INSERT%' THEN
                              SUBSTRING(   [STMT_Batch_Text],
                                           1,
                                           CASE
                                               WHEN CHARINDEX(']([', [STMT_Batch_Text]) = 0 THEN
                                                   300
                                               ELSE
                                                   CHARINDEX(']([', [STMT_Batch_Text])
                                           END
                                       )
                          --if DELETE then get all SQL text before WHERE
                          WHEN [STMT_Batch_Text] LIKE N'%DELETE%' THEN
                              SUBSTRING(
                                           [STMT_Batch_Text],
                                           1,
                                           CASE
                                               WHEN CHARINDEX('WHERE', [STMT_Batch_Text]) = 0 THEN
                                                   300
                                               ELSE
                                                   CHARINDEX('WHERE', [STMT_Batch_Text]) - 1
                                           END
                                       )
                          --get all exec stored procedure untill @ where param are set
                          WHEN CHARINDEX('exec [dbo]', [STMT_Batch_Text]) = 1 THEN
                              REPLACE(SUBSTRING([STMT_Batch_Text], 1, CHARINDEX('@', [STMT_Batch_Text])), '@', '')
                          WHEN [STMT_Batch_Text] = '' THEN
                              CAST([SQLText] AS NVARCHAR(300))
                          ELSE
                              CAST([STMT_Batch_Text] AS NVARCHAR(300))
                      END)

        --Format HTML table email body
        SELECT @xml = CAST(
             (
                 SELECT [EventsCount] AS 'td',
                        '',
                        [AVGDuration] AS 'td',
                        '',
                        [AVGCPUTime] AS 'td',
                        '',
                        [AVGPhysicalReads] AS 'td',
                        '',
                        [AVGLogicalReads] AS 'td',
                        '',
                        [AVGWrites] AS 'td',
                        '',
                        CAST([ShortedSQLText] AS NVARCHAR(200)) AS 'td'
                 FROM cte
                 ORDER BY [EventsCount] DESC,
                          [AVGDuration] DESC
                 FOR XML PATH('tr'), ELEMENTS
             ) AS NVARCHAR(MAX))
    END TRY
    BEGIN CATCH
        SELECT @error = ERROR_MESSAGE()
    END CATCH

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.dm_xe_sessions
        WHERE name = 'KV_SlowQueryLog'
    ) --Check if extended events is running
        SET @isSessionOn = '    Warning!!! Extended Events session is not running.'

    IF (@xml IS NOT NULL OR LEN(@xml) != 0) --Send email if there are blocks
    BEGIN
        SET @subject
            = @DBName + '-Slow Query Report. Between ' + CAST(DATEADD(HOUR, - (@Interval), GETDATE()) AS NVARCHAR)
              + ' -> ' + CAST(GETDATE() AS NVARCHAR);
        SET @body
            = '<html><body><H3>' + @subject + @isSessionOn + @error
              + '</H3>
						<table border = 1> 
						<tr>
						<th> EventsCount </th> <th> AVGDuration(s) </th> <th> AVGCPUTime(s) </th> 
						<th> AVGPhysicalReads </th> <th> AVGLogicalReads </th> <th> AVGWrites </th> <th> ShortedSQLText </th> </tr>';
        SET @body = @body + @xml + '</table></body></html>';

        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                     @body_format = 'HTML',
                                     @recipients = @receipt_db, -- @EmailTo,
                                     @subject = @subject,
                                     @body = @body;
    END
    ELSE --Send email no slow found
    BEGIN
        SET @subject
            = @DBName + '- Slow Query Report. Between ' + CAST(DATEADD(HOUR, - (@Interval), GETDATE()) AS NVARCHAR)
              + ' -> ' + CAST(GETDATE() AS NVARCHAR);
        SET @body = 'No slow queries found. ' + @isSessionOn + @error;

        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                     @body_format = 'HTML',
                                     @recipients = @receipt_db, -- @EmailTo,
                                     @subject = @subject,
                                     @body = @body;
    END
END