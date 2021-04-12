CREATE VIEW [dbo].[View_BlocksReport]
AS
SELECT [database_name],
       [post_time],
       [wait_time],
       [blocked_xactid],
       [blocking_xactid],
       [is_blocking_source],
       [blocked_inputbuf],
       [blocking_inputbuf]
FROM dbo.BlockedProcessReports;
