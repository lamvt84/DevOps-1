CREATE PROCEDURE Dataflow.SyncTransaction @MessageBody XML
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
        [Amount] [bigint],
        [AmountState] [bit],
        [Description] [nvarchar](300) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [OpenBalance] [bigint],
        [CloseBalance] [bigint],
        [CreatedUnixTime] [int],
        [InitUnixTime] [int],
        [ClientUnixIP] [bigint]
    )

    INSERT INTO #tempTransactions
    SELECT a.value(N'(./Action)[1]', N'varchar(1)') AS Action,
           a.value(N'(./Source_Name)[1]', N'varchar(30)') AS Source_Name,
           a.value(N'(./Batch_Id)[1]', N'int') AS Batch_Id,
           a.value(N'(./Sync_Id)[1]', N'int') AS Sync_Id,
           a.value(N'(./TransactionID)[1]', N'bigint') AS TransactionId,
           a.value(N'(./RelationReceiptID)[1]', N'bigint') AS RelationReceiptId,
           a.value(N'(./PayType)[1]', N'tinyint') AS PayType,
           a.value(N'(./ServiceID)[1]', N'int') AS ServiceId,
           a.value(N'(./AccountID)[1]', N'int') AS AccountId,
           a.value(N'(./Amount)[1]', N'bigint') AS Amount,
           a.value(N'(./AmountState)[1]', N'bit') AS AmountState,
           a.value(N'(./Description)[1]', N'NVarChar(300)') AS Description,
           a.value(N'(./OpenBalance)[1]', N'bigint') AS OpenBalance,
           a.value(N'(./CloseBalance)[1]', N'bigint') AS CloseBalance,
           a.value(N'(./CreatedUnixTime)[1]', N'int') AS CreatedUnixTime,
           a.value(N'(./InitUnixTime)[1]', N'int') AS InitUnixTime,
           a.value(N'(./ClientUnixIP)[1]', N'bigint') AS ClientUnixIP
    FROM @MessageBody.nodes('/ETL/row') AS r(a);

    CREATE TABLE #tempCompare
    (
        Dml VARCHAR(1),
        [TransactionId] [bigint] NOT NULL,
    )

    INSERT INTO #tempCompare
    SELECT Min(DML) Dml, TransactionId
    FROM
    (
        SELECT  
            'I' AS DML,
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
        SELECT  
            'D' AS DML,
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
        JOIN #tempTransactions t ON ft.TransactionId = t.TransactionId
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
    SET    
        Current_Flag = 'N',
        Updated_Time = SYSDATETIMEOFFSET()
    FROM Core.FactTransactions ft
    JOIN #tempCompare t ON ft.TransactionId = t.TransactionId
    WHERE t.Dml = 'D'

    INSERT INTO Core.FactTransactions
    (
        [Source_Name]
        ,[Batch_Id]
        ,[Sync_Id]
        ,[Created_Time]
        ,[Current_Flag]
        ,[Delete_Flag]
        ,[TransactionId]
        ,[RelationReceiptId]
        ,[PayType]
        ,[ServiceId]
        ,[AccountId]
        ,[Amount]
        ,[AmountState]
        ,[Description]
        ,[OpenBalance]
        ,[CloseBalance]
        ,[CreatedUnixTime]
        ,[InitUnixTime]
        ,[ClientUnixIP]
    )
    SELECT 
        Source_Name,
        Batch_Id,
        Sync_Id,
        SYSDATETIMEOFFSET(),
        'Y',
        CASE WHEN [Action] = 'D' THEN 'Y' ELSE 'N' END,
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
    JOIN #tempCompare tc ON t.TransactionId = tc.TransactionId
    WHERE tc.Dml = 'I'
END