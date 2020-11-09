CREATE PROCEDURE Dataflow.SyncTransactionSystem @MessageBody XML
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
        [Amount] [bigint],
        [RelatedAmount] [bigint],
        [GrandAmount] [bigint],
        [AmountState] [bit],
        [OpenBalance] [bigint],
        [CloseBalance] [bigint],
        [CreatedUnixTime] [int]
    )

    INSERT INTO #tempTransactions
    SELECT a.value(N'(./Action)[1]', N'varchar(1)') AS Action,
           a.value(N'(./Source_Name)[1]', N'varchar(30)') AS Source_Name,
           a.value(N'(./Batch_Id)[1]', N'int') AS Batch_Id,
           a.value(N'(./Sync_Id)[1]', N'int') AS Sync_Id,
           a.value(N'(./TransactionID)[1]', N'bigint') AS TransactionId,
           a.value(N'(./RelationReceiptID)[1]', N'bigint') AS RelationReceiptId,
           a.value(N'(./ServiceID)[1]', N'int') AS ServiceId,
           a.value(N'(./PayType)[1]', N'tinyint') AS PayType,
           a.value(N'(./AccountID)[1]', N'int') AS AccountId,
           a.value(N'(./TransactorID)[1]', N'int') AS TransactorId,
           a.value(N'(./Amount)[1]', N'bigint') AS Amount,
           a.value(N'(./RelatedAmount)[1]', N'bigint') AS RelatedAmount,
           a.value(N'(./GrandAmount)[1]', N'bigint') AS GrandAmount,
           a.value(N'(./AmountState)[1]', N'bit') AS AmountState,
           a.value(N'(./OpenBalance)[1]', N'bigint') AS OpenBalance,
           a.value(N'(./CloseBalance)[1]', N'bigint') AS CloseBalance,
           a.value(N'(./CreatedUnixTime)[1]', N'int') AS CreatedUnixTime
    FROM @MessageBody.nodes('/ETL/row') AS r(a);

    CREATE TABLE #tempCompare
    (
        Dml VARCHAR(1),
        [TransactionId] [bigint] NOT NULL
    )

    INSERT INTO #tempCompare
    SELECT Min(DML) Dml, TransactionId
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
    JOIN #tempCompare tc ON t.TransactionId = tc.TransactionId
    WHERE tc.Dml = 'I'
END