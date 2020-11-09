CREATE PROCEDURE Dataflow.SyncTransactionReceipt @MessageBody XML
AS
BEGIN
    CREATE TABLE #tempTransactions
    (
        [Action] VARCHAR(1),
        [Source_Name] VARCHAR(30),
        [Batch_Id] INT,
        [Sync_Id] INT,
        [TransactionId] [bigint] NOT NULL INDEX idx_TransactionID CLUSTERED,
        [SourceReceiptId] [bigint],
        [PayType] [tinyint],
        [UserId] [int],
        [AccountId] [int],
        [AccountName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [BankAccount] [varchar](30) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [BankCode] [varchar](30) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [Amount] [bigint],
        [Fee] [bigint],
        [RelatedFee] [bigint],
        [RelatedAmount] [bigint],
        [RelatedUserId] [int],
        [RelatedAccountId] [int],
        [RelatedAccount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [Description] [nvarchar](300) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [PaymentApp] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [PaymentReferenceId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [BankReferenceId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [BillingOrderId] [bigint],
        [CreatedUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [DeviceType] [tinyint],
        [ClientIP] [varchar](50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
        [CreatedTime] [datetime],
        [InitTime] [datetime]
    )

    INSERT INTO #tempTransactions
    SELECT a.value(N'(./Action)[1]', N'varchar(1)') AS Action,
           a.value(N'(./Source_Name)[1]', N'varchar(30)') AS Source_Name,
           a.value(N'(./Batch_Id)[1]', N'int') AS Batch_Id,
           a.value(N'(./Sync_Id)[1]', N'int') AS Sync_Id,
           a.value(N'(./TransactionID)[1]', N'bigint') AS TransactionId,
           a.value(N'(./SourceReceiptID)[1]', N'bigint') AS SourceReceiptId,
           a.value(N'(./PayType)[1]', N'tinyint') AS PayType,
           a.value(N'(./UserID)[1]', N'int') AS UserId,
           a.value(N'(./AccountID)[1]', N'int') AS AccountId,
           a.value(N'(./AccountName)[1]', N'varchar(50)') AS AccountName,
           a.value(N'(./BankAccount)[1]', N'varchar(30)') AS BankAccount,
           a.value(N'(./BankCode)[1]', N'varchar(30)') AS BankCode,
           a.value(N'(./Amount)[1]', N'bigint') AS Amount,
           a.value(N'(./Fee)[1]', N'bigint') AS Fee,
           a.value(N'(./RelatedFee)[1]', N'bigint') AS RelatedFee,
           a.value(N'(./RelatedAmount)[1]', N'bigint') AS RelatedAmount,
           a.value(N'(./RelatedUserID)[1]', N'int') AS RelatedUserId,
           a.value(N'(./RelatedAccountID)[1]', N'int') AS RelatedAccountId,
           a.value(N'(./RelatedAccount)[1]', N'varchar(50)') AS RelatedAccount,
           a.value(N'(./Description)[1]', N'nvarchar(300)') AS Description,
           a.value(N'(./PaymentApp)[1]', N'varchar(50)') AS PaymentApp,
           a.value(N'(./PaymentReferenceID)[1]', N'varchar(50)') AS PaymentReferenceId,
           a.value(N'(./BankReferenceID)[1]', N'varchar(50)') AS BankReferenceId,
           a.value(N'(./BillingOrderID)[1]', N'bigint') AS BillingOrderId,
           a.value(N'(./CreatedUser)[1]', N'varchar(50)') AS CreatedUser,
           a.value(N'(./DeviceType)[1]', N'tinyint') AS DeviceType,
           a.value(N'(./ClientIP)[1]', N'varchar(50)') AS ClientIP,
           a.value(N'(./CreatedTime)[1]', N'datetime') AS CreatedTime,
           a.value(N'(./InitTime)[1]', N'datetime') AS InitTime
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
               [CreatedTime] AT TIME ZONE 'SE Asia Standard Time' AS [ReceiptCreatedTime],
               [InitTime] AT TIME ZONE 'SE Asia Standard Time' AS [ReceiptInitTime]
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
        [Source_Name]
           ,[Batch_Id]
           ,[Sync_Id]
           ,[Created_Time]           
           ,[Current_Flag]
           ,[Delete_Flag]
           ,[TransactionId]
           ,[SourceReceiptId]
           ,[PayType]
           ,[UserId]
           ,[AccountId]
           ,[AccountName]
           ,[BankAccount]
           ,[BankCode]
           ,[Amount]
           ,[Fee]
           ,[RelatedFee]
           ,[RelatedAmount]
           ,[RelatedUserId]
           ,[RelatedAccountId]
           ,[RelatedAccount]
           ,[Description]
           ,[PaymentApp]
           ,[PaymentReferenceId]
           ,[BankReferenceId]
           ,[BillingOrderId]
           ,[CreatedUser]
           ,[DeviceType]
           ,[ClientIP]
           ,[ReceiptCreatedTime]
           ,[ReceiptInitTime]
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
           [CreatedTime] AT TIME ZONE 'SE Asia Standard Time' AS [ReceiptCreatedTime],
           [InitTime] AT TIME ZONE 'SE Asia Standard Time' AS [ReceiptInitTime]
    FROM #tempTransactions t
    JOIN #tempCompare tc ON t.TransactionId = tc.TransactionId
    WHERE tc.Dml = 'I'
END