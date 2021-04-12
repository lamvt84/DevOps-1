CREATE PROCEDURE [dbo].[sp_DatabaseReport_Collect]
    @ServerName VARCHAR(50) = @@SERVERNAME,
    @Type TINYINT = 0 -- 1: slow query, 2: blocking report, 3: Replication Log,  4: Fragment Index
AS
BEGIN
    SET @Type = ISNULL(@Type, 0)
    DECLARE @ReportName NVARCHAR(150)
    DECLARE @FilteredDate DATETIME = '2021-02-18 00:00:00'
    DECLARE @TraceId BIGINT,
            @MaxId BIGINT

    IF @Type = 1
        GOTO slow_query
    IF @Type = 2
        GOTO blocking_report
    IF @Type = 3
        GOTO replication_log
    IF @Type = 4
        GOTO fragment_index
    GOTO finally_sp

    slow_query:
    SET @ReportName = 'SLOW_QUERY'
    SELECT @TraceId = trace_id
    FROM dbo.DatabaseReportTraceId
    WHERE report_name = @ReportName
    SELECT TOP 1
           @MaxId = ID
    FROM dbo.SlowQueryLog WITH (NOLOCK)
    ORDER BY Id DESC

    UPDATE dbo.DatabaseReportTraceId
    SET trace_id = ISNULL(@MaxId, 0)
    WHERE report_name = @ReportName

    SELECT @ServerName AS server_name,
           *
    FROM dbo.SlowQueryLog WITH (NOLOCK)
    WHERE ID > @TraceId
          AND ID <= @MaxId
          AND [Time] >= @FilteredDate

    GOTO finally_sp

    blocking_report:
    SET @ReportName = 'BLOCKING_REPORT'
    SELECT @TraceId = trace_id
    FROM dbo.DatabaseReportTraceId
    WHERE report_name = @ReportName
    SELECT TOP 1
           @MaxId = ID
    FROM dbo.BlockedProcessReports WITH (NOLOCK)
    ORDER BY Id DESC

    UPDATE dbo.DatabaseReportTraceId
    SET trace_id = ISNULL(@MaxId, 0)
    WHERE report_name = @ReportName

    SELECT @ServerName AS server_name,
           *
    FROM dbo.BlockedProcessReports WITH (NOLOCK)
    WHERE ID > @TraceId
          AND ID <= @MaxId
          AND post_time >= @FilteredDate

    GOTO finally_sp

    replication_log:
    SET @ReportName = 'REPLICATION_LOG'
    SELECT @TraceId = trace_id
    FROM dbo.DatabaseReportTraceId
    WHERE report_name = @ReportName
    SELECT TOP 1
           @MaxId = ID
    FROM dbo.ReplicationLog WITH (NOLOCK)
    ORDER BY Id DESC

    UPDATE dbo.DatabaseReportTraceId
    SET trace_id = ISNULL(@MaxId, 0)
    WHERE report_name = @ReportName

    SELECT @ServerName AS server_name,
           *
    FROM dbo.ReplicationLog WITH (NOLOCK)
    WHERE ID > @TraceId
          AND ID <= @MaxId

    GOTO finally_sp

    fragment_index:
    SET @ReportName = 'FRAGMENT_INDEX'
    SELECT @TraceId = trace_id
    FROM dbo.DatabaseReportTraceId
    WHERE report_name = @ReportName
    SELECT TOP 1
           @MaxId = ID
    FROM dbo.IndexFragmentation WITH (NOLOCK)
    ORDER BY Id DESC

    UPDATE dbo.DatabaseReportTraceId
    SET trace_id = ISNULL(@MaxId, 0)
    WHERE report_name = @ReportName

    SELECT @ServerName AS server_name,
           *
    FROM dbo.IndexFragmentation WITH (NOLOCK)
    WHERE ID > @TraceId
          AND ID <= @MaxId

    GOTO finally_sp

    finally_sp:
    PRINT 'Done'
END
GO