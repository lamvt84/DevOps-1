CREATE OR ALTER TRIGGER [dbo].[tr_TransactionsReceipt_IUD]
ON [dbo].[Transactions_Receipt]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @ChangeMsg XML;
    DECLARE @DeletedCnt INT = 0;
    DECLARE @InsertedCnt INT = 0;
    DECLARE @Action CHAR(1);
    DECLARE @Source_Name VARCHAR(20) = 'PAYMOBI';
    DECLARE @Batch_Id INT = 0;
    DECLARE @Sync_Id INT = 0;
    DECLARE @ServiceName NVARCHAR(512) = N'//WalletTransaction/Service/Source';

    BEGIN
        SELECT @InsertedCnt = COUNT(*)
        FROM inserted
        SELECT @DeletedCnt = COUNT(*)
        FROM deleted

        SELECT @Action = CASE
                             WHEN @InsertedCnt IS NOT NULL
                                  AND @DeletedCnt IS NOT NULL THEN
                                 'U'
                             WHEN @InsertedCnt IS NULL THEN
                                 'D'
                             ELSE
                                 'I'
                         END
        IF (@Action = 'U')
        BEGIN
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       i.*
                FROM inserted i
                    JOIN
                    (
                        SELECT DISTINCT
                               r.TransactionID
                        FROM
                        (
                            SELECT 'I' [Type],
                                   *
                            FROM inserted
                            UNION ALL
                            SELECT 'D' [Type],
                                   *
                            FROM deleted
                        ) r
                        GROUP BY TransactionID,
                                 SourceReceiptID,
                                 PayType,
                                 UserID,
                                 AccountID,
                                 AccountName,
                                 BankAccount,
                                 BankCode,
                                 Amount,
                                 Fee,
                                 RelatedFee,
                                 RelatedAmount,
                                 RelatedUserID,
                                 RelatedAccountID,
                                 RelatedAccount,
                                 Description,
                                 PaymentApp,
                                 PaymentReferenceID,
                                 BankReferenceID,
                                 BillingOrderID,
                                 CreatedUser,
                                 DeviceType,
                                 ClientIP,
                                 CreatedTime,
                                 InitTime
                        HAVING COUNT(*) = 1
                    ) t
                        ON i.TransactionID = t.TransactionID
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END
        IF (@Action = 'D')
        BEGIN;
            -- Build the XML message, flagging it as an update
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       *
                FROM deleted
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END;
        IF (@Action = 'I')
        BEGIN;
            -- Build the XML message, flagging it as an update
            SET @ChangeMsg =
            (
                SELECT @Action AS [Action],
                       @Source_Name AS [Source_Name],
                       @Batch_Id AS [Batch_Id],
                       @Sync_Id AS [Sync_Id],
                       *
                FROM inserted
                FOR XML RAW, ELEMENTS, ROOT('ETL')
            );
        END;

        IF @ChangeMsg IS NOT NULL
            EXEC [EDWInitiatorSB].dbo.sp_SendMessage_Transactions @ServiceName = @ServiceName,
                                                                  @MessageTypeName = N'//WalletTransaction/TransactionsReceipt/Request',
                                                                  @MessageBody = @ChangeMsg
    END

END
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_TransactionsReceipt_IUD]',
                        @order = N'Last',
                        @stmttype = N'DELETE'
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_TransactionsReceipt_IUD]',
                        @order = N'Last',
                        @stmttype = N'INSERT'
GO

EXEC sp_settriggerorder @triggername = N'[dbo].[tr_TransactionsReceipt_IUD]',
                        @order = N'Last',
                        @stmttype = N'UPDATE'
GO


