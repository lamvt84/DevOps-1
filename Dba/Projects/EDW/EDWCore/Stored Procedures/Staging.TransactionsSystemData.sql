CREATE PROCEDURE [Staging].[TransactionsSystemData]
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
        [ServiceId] [int],
        [PayType] [tinyint],
        [AccountId] [int],
        [TransactorId] [int],
        [Amount] [numeric](28, 12),
        [RelatedAmount] [numeric](28, 12),
        [GrandAmount] [numeric](28, 12),
        [AmountState] [bit],
        [OpenBalance] [numeric](28, 12),
        [CloseBalance] [numeric](28, 12),
        [CreatedUnixTime] [int]
    )

    INSERT INTO #tempTransactions
    SELECT Action_Flag,
           Source_Name,
           Batch_Id,
           Sync_Id,
           [TransactionId],
           [RelationReceiptId],
           [ServiceId],
           [PayType],
           [AccountId],
           [TransactorId],
           [Amount],
           [RelatedAmount],
           [GrandAmount],
           [AmountState],
           [OpenBalance],
           [CloseBalance],
           [CreatedUnixTime]
    FROM EDWStaging.dbo.TransactionsSystemStaging
    WHERE Batch_Id = @Batch_Id
          AND Sync_Id = @Sync_Id;

    CREATE TABLE #tempCompare
    (
        Dml VARCHAR(1),
        [TransactionId] [bigint] NOT NULL
    )

    INSERT INTO #tempCompare
    SELECT MIN(DML) Dml,
           TransactionId
    FROM
    (
        SELECT 'I' AS DML,
               [TransactionId],
               [RelationReceiptId],
               [ServiceId],
               [PayType],
               [AccountId],
               [TransactorId],
               [Amount],
               [RelatedAmount],
               [GrandAmount],
               [AmountState],
               [OpenBalance],
               [CloseBalance],
               [CreatedUnixTime]
        FROM #tempTransactions
        UNION ALL
        SELECT 'D' AS DML,
               ft.[TransactionId],
               ft.[RelationReceiptId],
               ft.[ServiceId],
               ft.[PayType],
               ft.[AccountId],
               ft.[TransactorId],
               ft.[Amount],
               ft.[RelatedAmount],
               ft.[GrandAmount],
               ft.[AmountState],
               ft.[OpenBalance],
               ft.[CloseBalance],
               ft.[CreatedUnixTime]
        FROM Core.FactTransactionsSystem ft
            JOIN #tempTransactions t
                ON ft.TransactionId = t.TransactionId
        WHERE ft.Current_Flag = 'Y'
    ) tmp
    GROUP BY [TransactionId],
             [RelationReceiptId],
             [ServiceId],
             [PayType],
             [AccountId],
             [TransactorId],
             [Amount],
             [RelatedAmount],
             [GrandAmount],
             [AmountState],
             [OpenBalance],
             [CloseBalance],
             [CreatedUnixTime]
    HAVING COUNT(*) = 1

    UPDATE ft
    SET Current_Flag = 'N',
        Updated_Time = SYSDATETIMEOFFSET()
    FROM Core.FactTransactionsSystem ft
        JOIN #tempCompare t
            ON ft.TransactionId = t.TransactionId
    WHERE t.Dml = 'D'

    INSERT INTO Core.FactTransactionsSystem
    (
        [Source_Name],
        [Batch_Id],
        [Sync_Id],
        [Created_Time],
        [Current_Flag],
        [Delete_Flag],
        [TransactionId],
        [RelationReceiptId],
        [ServiceId],
        [PayType],
        [AccountId],
        [TransactorId],
        [Amount],
        [RelatedAmount],
        [GrandAmount],
        [AmountState],
        [OpenBalance],
        [CloseBalance],
        [CreatedUnixTime]
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
           [RelationReceiptId],
           [ServiceId],
           [PayType],
           [AccountId],
           [TransactorId],
           [Amount],
           [RelatedAmount],
           [GrandAmount],
           [AmountState],
           [OpenBalance],
           [CloseBalance],
           [CreatedUnixTime]
    FROM #tempTransactions t
        JOIN #tempCompare tc
            ON t.TransactionId = tc.TransactionId
    WHERE tc.Dml = 'I'
END
