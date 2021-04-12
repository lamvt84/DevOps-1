CREATE PROCEDURE [dbo].[pr_HourlyDeadLockReport]
WITH EXECUTE AS OWNER
AS
BEGIN
    DECLARE @start_dt DATETIME,
            @end_dt DATETIME,
            @subject NVARCHAR(max);
    DECLARE @body NVARCHAR(MAX),
            @xml NVARCHAR(MAX),
            @footer1 NVARCHAR(max),
            @footer2 NVARCHAR(max);
    DECLARE @err NVARCHAR(2000) = ''
    DECLARE @OPENQUERY NVARCHAR(MAX),
            @OPENQUERYCount NVARCHAR(MAX),
            @db_name VARCHAR(50),
            @db_name_lock VARCHAR(50),
            @thread_hold INT = 3,
            @time_interval INT,
            @receipt_db NVARCHAR(MAX),
            @thread_hold_curr INT;

    SELECT @receipt_db = list_mail
    FROM CitigoMailList
    WHERE type = 3
          AND status = 1; -- type : 1-> slow, 2-->block, 3--> deadlock || status: 0-->invalid, 1-->valid

    BEGIN

        SET @footer1
            = ' Intent exclusive (IX): Protects requested or acquired exclusive locks on some (but not all) resources lower in the hierarchy. IX is a superset of IS, and it also protects requesting shared locks on lower level resources.';
        SET @footer2
            = ' Exclusive (X):	Used for data-modification operations, such as INSERT, UPDATE, or DELETE. Ensures that multiple updates cannot be made to the same resource at the same time'
        SELECT @thread_hold = thread_hold,
               @time_interval = time_interval
        FROM dbo.DeadLockConfig
        WHERE status = '1';
        SELECT @start_dt = DATEADD(mi, -@time_interval, GETDATE()),
               @end_dt = GETDATE();

        SELECT @thread_hold_curr = COUNT(*)
        FROM [dbo].[DeadlockLog]
        WHERE TIME >= @start_dt
              AND TIME < @end_dt;
        PRINT @thread_hold;
        PRINT @thread_hold_curr;
        IF (@thread_hold <= @thread_hold_curr)
        BEGIN
            ;WITH cte
            AS (SELECT 'DB6' DB,
                       LockMode,
                       COUNT(*) Block_Times,
                       BlockedQuery,
                       BlockingQuery
                FROM [dbo].[DeadlockLog]
                WHERE TIME >= @start_dt
                      AND TIME < @end_dt
                GROUP BY BlockedQuery,
                         BlockingQuery,
                         LockMode)
            SELECT @xml = CAST(
                (
                    SELECT [DB] AS 'td',
                           '',
                           [LockMode] AS 'td',
                           '',
                           [Block_Times] AS 'td',
                           '',
                           BlockedQuery AS 'td',
                           '',
                           BlockingQuery AS 'td'
                    FROM cte
                    FOR XML PATH('tr'), ELEMENTS
                ) AS NVARCHAR(MAX));


            SET @subject
                = '[DB6] Deadlock Report. Between ' + CAST(@start_dt AS NVARCHAR) + ' -> ' + CAST(@end_dt AS NVARCHAR);

            SET @body
                = '<html><body><H3>' + @subject + '. ' + @err
                  + '</H3>
                    <table border = 1> 
                    <tr>
                    <th> DB </th><th> LockMode(ms) </th> <th> Blocks Count </th> <th> BlockedQuery Query </th><th> Blocking Query </th>  </tr>';
            SET @body = @body + @xml + '</table></body><br/>' + @footer1 + '<br/>' + @footer2 + '</html>';


            EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                                                    --@importance = 'high',
                                         @body_format = 'HTML',
                                         @recipients = @receipt_db, --'tu.nc@citigo.com.vn',-- @EmailTo,
                                         @subject = @subject,
                                         @body = @body;
        END;
    END;
END