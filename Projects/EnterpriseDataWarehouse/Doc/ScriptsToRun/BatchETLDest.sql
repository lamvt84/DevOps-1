USE [EDWTargetSB]
GO
CREATE MESSAGE TYPE [//ETL/Batch/Message/Transactions] VALIDATION = WELL_FORMED_XML
GO
CREATE MESSAGE TYPE [//ETL/Batch/Message/Reply] VALIDATION = WELL_FORMED_XML
GO
CREATE CONTRACT [//ETL/Batch/Contract]
      (
            [//ETL/Batch/Message/Transactions] SENT BY INITIATOR,
            [//ETL/Batch/Message/Reply] SENT BY TARGET
      );
GO
CREATE QUEUE [dbo].[//ETL/Batch/Queue/Target]
      WITH ACTIVATION (
            STATUS = ON,
            MAX_QUEUE_READERS = 1,
            PROCEDURE_NAME = [dbo].[sp_ProcessAsyncMessages_TransactionQueue],
            EXECUTE AS OWNER);
GO
CREATE SERVICE [//ETL/Batch/Service/Target]
	AUTHORIZATION [dbo]
	ON QUEUE [dbo].[//ETL/Batch/Queue/Target] (
		[//ETL/Batch/Contract]
	)
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_ProcessAsyncMessages_TransactionBatch]
AS
BEGIN
    DECLARE @RecvReqDlgHandle UNIQUEIDENTIFIER;
    DECLARE @RecvReqMsg XML;
    DECLARE @RecvReqMsgName sysname;
    DECLARE @ServiceName VARCHAR(512) = '//ETL/Batch/Service/Target'    

    BEGIN TRY
        BEGIN TRANSACTION
        WAITFOR
        (
            RECEIVE TOP (1) @RecvReqDlgHandle = conversation_handle,
                            @RecvReqMsg = message_body,
                            @RecvReqMsgName = message_type_name
            FROM [dbo].[//ETL/Batch/Queue/Target]
        ),
        TIMEOUT 1000;
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.BrokerConversation
            WHERE ServiceName = @ServiceName
        )
            INSERT INTO [dbo].[BrokerConversation]
            VALUES
            (@RecvReqDlgHandle, @ServiceName)
        IF @RecvReqMsg IS NOT NULL
            INSERT [dbo].[BrokerMessages]
            (
                ConversationHandler,
                MessageTypeName,
                MessageBody
            )
            SELECT @RecvReqDlgHandle,
                   @RecvReqMsgName,
                   @RecvReqMsg
        COMMIT


        IF @RecvReqMsgName = '//ETL/Batch/Message/Transactions'
            EXEC [EDWCore].[Staging].[ProcessTransactionData] @RecvReqMsg = @RecvReqMsg,
                                                              @SyncName = 'TRANSACTIONS'     
        IF @RecvReqMsgName = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
            BEGIN
                END CONVERSATION @RecvReqDlgHandle
                DELETE FROM [dbo].[BrokerConversation] WHERE ServiceName = @ServiceName
            END
    END TRY
    BEGIN CATCH
        IF XACT_STATE() = -1
            ROLLBACK TRANSACTION
        INSERT INTO dbo.ErrorLog
        (
            ErrorTime,
            UserName,
            ErrorNumber,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorMessage,
            MessageBody
        )
        VALUES
        (GETDATE(), USER_NAME(), ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(),
         ERROR_MESSAGE(), @RecvReqMsg)
    END CATCH
END
GO

USE [EDWCore]
GO
CREATE OR ALTER PROCEDURE [Staging].[TransactionsData]
    @Batch_Id INT,
    @Sync_Id INT
AS
BEGIN
    CREATE TABLE #tempTransactions
    (
        [Action] VARCHAR(1) NULL,
        [Source_Name] VARCHAR(30),
        [Batch_Id] INT,
        [Sync_Id] INT,
        [TransactionId] [bigint] NOT NULL INDEX idx_TransactionID CLUSTERED,
        [RelationReceiptId] [bigint],
        [PayType] [tinyint],
        [ServiceId] [int],
        [AccountId] [int],
        [Amount] [numeric](28,12),
        [AmountState] [bit],
        [Description] [nvarchar](300) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [OpenBalance] [numeric](28,12),
        [CloseBalance] [numeric](28,12),
        [CreatedUnixTime] [int],
        [InitUnixTime] [int],
        [ClientUnixIP] [bigint]
    )

    INSERT INTO #tempTransactions
    SELECT Action_Flag,
           Source_Name,
           Batch_Id,
           Sync_Id,
           TransactionId,
           RelationReceiptId,
           PayType,
           ServiceId,
           AccountId,
           Amount,
           AmountState,
           Description,
           OpenBalance,
           CloseBalance,
           CreatedUnixTime,
           InitUnixTime,
           ClientUnixIP
    FROM EDWStaging.dbo.TransactionsStaging
    WHERE Batch_Id = @Batch_Id
          AND Sync_Id = @Sync_Id;

    CREATE TABLE #tempCompare
    (
        Dml VARCHAR(1),
        [TransactionId] [bigint] NOT NULL,
    )

    INSERT INTO #tempCompare
    SELECT MIN(DML) Dml,
           TransactionId
    FROM
    (
        SELECT 'I' AS DML,
               TransactionId,
               RelationReceiptId,
               PayType,
               ServiceId,
               AccountId,
               Amount,
               AmountState,
               Description,
               OpenBalance,
               CloseBalance,
               CreatedUnixTime,
               InitUnixTime,
               ClientUnixIP
        FROM #tempTransactions
        UNION ALL
        SELECT 'D' AS DML,
               ft.TransactionId,
               ft.RelationReceiptId,
               ft.PayType,
               ft.ServiceId,
               ft.AccountId,
               ft.Amount,
               ft.AmountState,
               ft.Description,
               ft.OpenBalance,
               ft.CloseBalance,
               ft.CreatedUnixTime,
               ft.InitUnixTime,
               ft.ClientUnixIP
        FROM Core.FactTransactions ft
            JOIN #tempTransactions t
                ON ft.TransactionId = t.TransactionId
        WHERE ft.Current_Flag = 'Y'
    ) tmp
    GROUP BY TransactionId,
             RelationReceiptId,
             PayType,
             ServiceId,
             AccountId,
             Amount,
             AmountState,
             Description,
             OpenBalance,
             CloseBalance,
             CreatedUnixTime,
             InitUnixTime,
             ClientUnixIP
    HAVING COUNT(*) = 1

    UPDATE ft
    SET Current_Flag = 'N',
        Updated_Time = SYSDATETIMEOFFSET()
    FROM Core.FactTransactions ft
        JOIN #tempCompare t
            ON ft.TransactionId = t.TransactionId
    WHERE t.Dml = 'D'

    INSERT INTO Core.FactTransactions
    (
        [Source_Name],
        [Batch_Id],
        [Sync_Id],
        [Created_Time],
        [Current_Flag],
        [Delete_Flag],
        [TransactionId],
        [RelationReceiptId],
        [PayType],
        [ServiceId],
        [AccountId],
        [Amount],
        [AmountState],
        [Description],
        [OpenBalance],
        [CloseBalance],
        [CreatedUnixTime],
        [InitUnixTime],
        [ClientUnixIP]
    )
    SELECT Source_Name,
           Batch_Id,
           Sync_Id,
           SYSDATETIMEOFFSET(),
           'Y',
           CASE
               WHEN [Action] = 'D' THEN
                   'Y'
               ELSE
                   'N'
           END,
           t.TransactionId,
           RelationReceiptId,
           PayType,
           ServiceId,
           AccountId,
           Amount,
           AmountState,
           Description,
           OpenBalance,
           CloseBalance,
           CreatedUnixTime,
           InitUnixTime,
           ClientUnixIP
    FROM #tempTransactions t
        JOIN #tempCompare tc
            ON t.TransactionId = tc.TransactionId
    WHERE tc.Dml = 'I'
END
