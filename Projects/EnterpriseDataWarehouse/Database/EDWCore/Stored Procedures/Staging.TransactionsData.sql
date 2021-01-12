CREATE PROCEDURE [Staging].[TransactionsData]
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
