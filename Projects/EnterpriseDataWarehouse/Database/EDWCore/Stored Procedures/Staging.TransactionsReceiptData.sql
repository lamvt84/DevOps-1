CREATE PROCEDURE [Staging].[TransactionsReceiptData]
    @Batch_Id INT,
    @Sync_Id INT
AS
BEGIN
    CREATE TABLE #tempTransactions
    (
        [Action] VARCHAR(1) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [Source_Name] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [Batch_Id] INT,
        [Sync_Id] INT,
        [TransactionId] [bigint] NOT NULL INDEX idx_TransactionID CLUSTERED,
        [SourceReceiptId] [bigint],
        [PayType] [tinyint],
        [UserId] [int],
        [AccountId] [int],
        [AccountName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [BankAccount] [varchar](30) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [BankCode] [varchar](30) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [Amount] [numeric](28,12),
        [Fee] [numeric](28,12),
        [RelatedFee] [numeric](28,12),
        [RelatedAmount] [numeric](28,12),
        [RelatedUserId] [int],
        [RelatedAccountId] [int],
        [RelatedAccount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [Description] [nvarchar](300) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [PaymentApp] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [PaymentReferenceId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [BankReferenceId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [BillingOrderId] [bigint],
        [CreatedUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [DeviceType] [tinyint],
        [ClientIP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS,
        [ReceiptCreatedTime] [datetimeoffset],
        [ReceiptInitTime] [datetimeoffset]
    )

    INSERT INTO #tempTransactions
    SELECT Action_Flag,
           Source_Name,
           Batch_Id,
           Sync_Id,
           [TransactionId],
           [SourceReceiptId],
           [PayType],
           [UserId],
           [AccountId],
           [AccountName],
           [BankAccount],
           [BankCode],
           [Amount],
           [Fee],
           [RelatedFee],
           [RelatedAmount],
           [RelatedUserId],
           [RelatedAccountId],
           [RelatedAccount],
           [Description],
           [PaymentApp],
           [PaymentReferenceId],
           [BankReferenceId],
           [BillingOrderId],
           [CreatedUser],
           [DeviceType],
           [ClientIP],
           [CreatedTime],
           [InitTime]
    FROM EDWStaging.dbo.TransactionsReceiptStaging
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
               [TransactionId],
               [SourceReceiptId],
               [PayType],
               [UserId],
               [AccountId],
               [AccountName],
               [BankAccount],
               [BankCode],
               [Amount],
               [Fee],
               [RelatedFee],
               [RelatedAmount],
               [RelatedUserId],
               [RelatedAccountId],
               [RelatedAccount],
               [Description],
               [PaymentApp],
               [PaymentReferenceId],
               [BankReferenceId],
               [BillingOrderId],
               [CreatedUser],
               [DeviceType],
               [ClientIP],
               [ReceiptCreatedTime],
               [ReceiptInitTime]
        FROM #tempTransactions
        UNION ALL
        SELECT 'D' AS DML,
               ft.[TransactionId],
               ft.[SourceReceiptId],
               ft.[PayType],
               ft.[UserId],
               ft.[AccountId],
               ft.[AccountName],
               ft.[BankAccount],
               ft.[BankCode],
               ft.[Amount],
               ft.[Fee],
               ft.[RelatedFee],
               ft.[RelatedAmount],
               ft.[RelatedUserId],
               ft.[RelatedAccountId],
               ft.[RelatedAccount],
               ft.[Description],
               ft.[PaymentApp],
               ft.[PaymentReferenceId],
               ft.[BankReferenceId],
               ft.[BillingOrderId],
               ft.[CreatedUser],
               ft.[DeviceType],
               ft.[ClientIP],
               ft.[ReceiptCreatedTime],
               ft.[ReceiptInitTime]
        FROM Core.FactTransactionsReceipt ft
            JOIN #tempTransactions t
                ON ft.TransactionId = t.TransactionId
        WHERE ft.Current_Flag = 'Y'
    ) tmp
    GROUP BY TransactionId,
             SourceReceiptId,
             PayType,
             UserId,
             AccountId,
             AccountName,
             BankAccount,
             BankCode,
             Amount,
             Fee,
             RelatedFee,
             RelatedAmount,
             RelatedUserId,
             RelatedAccountId,
             RelatedAccount,
             Description,
             PaymentApp,
             PaymentReferenceId,
             BankReferenceId,
             BillingOrderId,
             CreatedUser,
             DeviceType,
             ClientIP,
             ReceiptCreatedTime,
             ReceiptInitTime
    HAVING COUNT(*) = 1

    UPDATE ft
    SET Current_Flag = 'N',
        Updated_Time = SYSDATETIMEOFFSET()
    FROM Core.FactTransactionsReceipt ft
        JOIN #tempCompare t
            ON ft.TransactionId = t.TransactionId
    WHERE t.Dml = 'D'
          AND ft.Current_Flag = 'Y'

    INSERT INTO Core.FactTransactionsReceipt
    (
        [Source_Name],
        [Batch_Id],
        [Sync_Id],
        [Created_Time],
        [Current_Flag],
        [Delete_Flag],
        [TransactionId],
        [SourceReceiptId],
        [PayType],
        [UserId],
        [AccountId],
        [AccountName],
        [BankAccount],
        [BankCode],
        [Amount],
        [Fee],
        [RelatedFee],
        [RelatedAmount],
        [RelatedUserId],
        [RelatedAccountId],
        [RelatedAccount],
        [Description],
        [PaymentApp],
        [PaymentReferenceId],
        [BankReferenceId],
        [BillingOrderId],
        [CreatedUser],
        [DeviceType],
        [ClientIP],
        [ReceiptCreatedTime],
        [ReceiptInitTime]
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
           t.[TransactionId],
           [SourceReceiptId],
           [PayType],
           [UserId],
           [AccountId],
           [AccountName],
           [BankAccount],
           [BankCode],
           [Amount],
           [Fee],
           [RelatedFee],
           [RelatedAmount],
           [RelatedUserId],
           [RelatedAccountId],
           [RelatedAccount],
           [Description],
           [PaymentApp],
           [PaymentReferenceId],
           [BankReferenceId],
           [BillingOrderId],
           [CreatedUser],
           [DeviceType],
           [ClientIP],
           [ReceiptCreatedTime],
           [ReceiptInitTime]
    FROM #tempTransactions t
        JOIN #tempCompare tc
            ON t.TransactionId = tc.TransactionId
    WHERE tc.Dml = 'I'
END
