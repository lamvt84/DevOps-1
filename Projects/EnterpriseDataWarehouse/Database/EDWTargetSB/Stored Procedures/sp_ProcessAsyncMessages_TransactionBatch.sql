CREATE PROCEDURE [dbo].[sp_ProcessAsyncMessages_TransactionBatch]
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
        IF @RecvReqMsgName = '//ETL/Batch/Message/TransactionsReceipt'
            EXEC [EDWCore].[Staging].[ProcessTransactionData] @RecvReqMsg = @RecvReqMsg,
                                                              @SyncName = 'TRANSACTIONS_RECEIPT'
        IF @RecvReqMsgName = '//ETL/Batch/Message/TransactionsSystem'
            EXEC [EDWCore].[Staging].[ProcessTransactionData] @RecvReqMsg = @RecvReqMsg,
                                                              @SyncName = 'TRANSACTIONS_SYSTEM'
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
