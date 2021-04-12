CREATE PROCEDURE [dbo].[pr_HourlyBlocksReport]
(@Interval TINYINT --Report from last ? hour
)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @subject NVARCHAR(MAX),
            @body NVARCHAR(MAX),
            @xml NVARCHAR(MAX),
            @receipt_db NVARCHAR(MAX);
    SELECT @receipt_db = list_mail
    FROM dbo.CitigoMailList
    WHERE type = 2
          AND status = 1; -- type : 1-> slow, 2-->block, 3--> deadlock || status: 0-->invalid, 1-->valid;

    --Get report
    WITH cte
    AS (SELECT MAX(MaxTime) AS MaxTime,
               SUM(Blocks) AS BlockTimes,
               blocking_inputbuf AS BlockingQuery
        FROM
        (
            SELECT MAX(wait_time) AS MaxTime,
                   1 AS Blocks,
                   blocked_xactid,
                   blocking_xactid,
                   blocking_inputbuf
            FROM BlockedProcessReports
            WHERE (post_time
                  BETWEEN DATEADD(HOUR, - (@Interval), GETDATE()) AND GETDATE()
                  )
                  AND is_blocking_source = 1
                  AND blocking_inputbuf IS NOT NULL
                  AND blocking_inputbuf != ''
            GROUP BY blocked_xactid,
                     blocking_xactid,
                     blocking_inputbuf
        ) AS a
        GROUP BY blocking_inputbuf)

    --Format HTML table email body
    SELECT @xml = CAST(
        (
            SELECT [MaxTime] AS 'td',
                   '',
                   [BlockTimes] AS 'td',
                   '',
                   [BlockingQuery] AS 'td'
            FROM cte
            FOR XML PATH('tr'), ELEMENTS
        ) AS NVARCHAR(MAX));

    --Send email if there are blocks
    IF (@xml IS NOT NULL OR LEN(@xml) != 0)
    BEGIN
        SET @subject
            = 'DB.6-Blocks Report. Between ' + CAST(DATEADD(HOUR, - (@Interval), GETDATE()) AS NVARCHAR) + ' -> '
              + CAST(GETDATE() AS NVARCHAR);
        SET @body
            = '<html><body><H3>' + @subject
              + '</H3>
					<table border = 1> 
					<tr>
					<th> Max WaitTime(ms) </th> <th> Block Times </th> <th> Blocking Query </th> </tr>';
        SET @body = @body + @xml + '</table></body></html>';

        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                     --@importance = 'high',
                                     @body_format = 'HTML',
                                     @recipients = @receipt_db,
                                     @subject = @subject,
                                     @body = @body;
    END
END