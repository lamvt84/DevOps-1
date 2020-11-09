CREATE PROCEDURE [Staging].[ProcessTransactionData]
    @RecvReqMsg XML,
    @SyncName VARCHAR(30)
AS
BEGIN
    DECLARE @Batch_Id INT;
    DECLARE @Sync_Id INT;
    DECLARE @Package_Name VARCHAR(150) = 'EDW_Core_Transactions.dtsx'
    DECLARE @Proc_Name VARCHAR(150)
    DECLARE @Execution_Id BIGINT

    SET @Batch_Id = CAST(CAST(@RecvReqMsg.query('/ETL/row/Batch_Id/text()') AS NVARCHAR(MAX)) AS INT)
    SET @Sync_Id = CAST(CAST(@RecvReqMsg.query('/ETL/row/Sync_Id/text()') AS NVARCHAR(MAX)) AS INT)

    IF EXISTS
    (
        SELECT 1
        FROM dbo.SyncSource
        WHERE Sync_Id = @Sync_Id
              AND Sync_Status = 1
    )
       AND EXISTS
    (
        SELECT 1
        FROM dbo.Batch
        WHERE Batch_Id = @Batch_Id
              AND Batch_Status = 1
    )
    BEGIN
        SELECT @Proc_Name = Proc_Name
        FROM dbo.SyncProcMapping
        WHERE Sync_Name = @SyncName
        IF (@Proc_Name IS NOT NULL)
        BEGIN
            EXEC [SSISDB].[catalog].[create_execution] @package_name = @Package_Name,
                                                       @folder_name = N'EDW',
                                                       @project_name = N'EDW_Core',
                                                       @use32bitruntime = False,
                                                       @reference_id = NULL,
                                                       @execution_id = @Execution_Id OUTPUT


            EXEC [SSISDB].[catalog].[set_execution_parameter_value] @Execution_Id,
                                                                    @object_type = 30,
                                                                    @parameter_name = N'BatchId',
                                                                    @parameter_value = @Batch_Id

            EXEC [SSISDB].[catalog].[set_execution_parameter_value] @Execution_Id,
                                                                    @object_type = 30,
                                                                    @parameter_name = N'SyncId',
                                                                    @parameter_value = @Sync_Id

            EXEC [SSISDB].[catalog].[set_execution_parameter_value] @Execution_Id,
                                                                    @object_type = 30,
                                                                    @parameter_name = N'ProcName',
                                                                    @parameter_value = @Proc_Name

            EXEC [SSISDB].[catalog].[set_execution_parameter_value] @Execution_Id,
                                                                    @object_type = 50,
                                                                    @parameter_name = N'LOGGING_LEVEL',
                                                                    @parameter_value = 1

            EXEC [SSISDB].[catalog].[start_execution] @Execution_Id
        END
    END
END
