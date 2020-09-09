# Partition



### Object

| Database            | Schema | Table                 |
| ------------------- | ------ | --------------------- |
| Wallet.Transaction  | dbo    | Transactions          |
|                     |        | Transactions_Receipt  |
|                     |        | Transactions_System   |
| Wallet.BillingOrder | dbo    | Orders_BankTransfer   |
|                     |        | Orders_Invoice        |
|                     |        | Orders_InvoiceBanking |
|                     |        | Orders_InvoicePayment |
|                     |        |                       |



### Scripting

##### [Wallet.Transaction]

Create file group

```sql
USE [Wallet.Transaction]
GO
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M1]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M2]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M3]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M4]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M5]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M6]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M7]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M8]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M9]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M10]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M11]
ALTER DATABASE [Wallet.Transaction] ADD FILEGROUP [M12]
GO
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M1]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M2]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M3]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M4]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M5]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M6]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M7]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M8]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M9]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M10]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M11]
ALTER DATABASE [Wallet.Transaction] ADD FILE (  ) TO FILEGROUP [M12]
GO
```

Create database scheme and function

```sql
USE [Wallet.Transaction]
GO
CREATE PARTITION FUNCTION [pf_Month](int) AS RANGE LEFT FOR VALUES (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
CREATE PARTITION SCHEME [ps_Month] AS PARTITION [pf_Month] TO ([M1], [M2], [M3], [M4], [M5], [M6], [M7], [M8], [M9], [M10], [M11])
GO
```

Implement partitioned table

```sql
USE [Wallet.Transaction]
GO
/* Remove PK */
ALTER TABLE [dbo].[Transactions] DROP CONSTRAINT [PK_Transactions]
ALTER TABLE [dbo].[Transactions_Receipt] DROP CONSTRAINT [PK_Transactions_Receipt]
ALTER TABLE [dbo].[Transactions_System] DROP CONSTRAINT [PK_Transactions_System]

/* Add computed column */
ALTER TABLE [dbo].[Transactions] ADD PartitionNum AS DATEADD(S, CreatedUnixTime, '1970-01-01 00:00:00') PERSISTED NOT NULL
ALTER TABLE [dbo].[Transactions_Receipt] ADD PartitionNum AS DATEADD(S, CreatedUnixTime, '1970-01-01 00:00:00') PERSISTED NOT NULL
ALTER TABLE [dbo].[Transactions_System] ADD PartitionNum AS DATEADD(S, CreatedUnixTime, '1970-01-01 00:00:00') PERSISTED NOT NULL

/* Re-create PK for partitioning*/
ALTER TABLE [dbo].[Transactions] ADD CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED (TransactionID, PartitionNum) WITH (ALLOW_PAGE_LOCKS = OFF) ON [ps_Month]([PartitionNum])
ALTER TABLE [dbo].[Transactions_Receipt] ADD CONSTRAINT [PK_Transactions_Receipt] PRIMARY KEY CLUSTERED (TransactionID, PartitionNum) WITH (ALLOW_PAGE_LOCKS = OFF) ON [ps_Month]([PartitionNum])
ALTER TABLE [dbo].[Transactions_System] ADD CONSTRAINT [PK_Transactions_System] PRIMARY KEY CLUSTERED (TransactionID, PartitionNum) WITH (ALLOW_PAGE_LOCKS = OFF) ON [ps_Month]([PartitionNum])
```



**[Wallet.BillingOrder]**

Create file group

```sql
USE [Wallet.BillingOrder]
GO
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M1]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M2]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M3]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M4]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M5]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M6]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M7]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M8]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M9]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M10]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M11]
ALTER DATABASE [Wallet.BillingOrder] ADD FILEGROUP [M12]
GO
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M1]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M2]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M3]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M4]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M5]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M6]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M7]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M8]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M9]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M10]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M11]
ALTER DATABASE [Wallet.BillingOrder] ADD FILE (  ) TO FILEGROUP [M12]
GO
```

Create database scheme and function

```sql
USE [Wallet.BillingOrder]
GO
CREATE PARTITION FUNCTION [pf_Month](int) AS RANGE LEFT FOR VALUES (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
CREATE PARTITION SCHEME [ps_Month] AS PARTITION [pf_Month] TO ([M1], [M2], [M3], [M4], [M5], [M6], [M7], [M8], [M9], [M10], [M11])
GO
```

Implement partitioned table

```sql
USE [Wallet.BillingOrder]
GO
/* Remove PK */
ALTER TABLE [dbo].[Orders_BankTransfer] DROP CONSTRAINT [PK_Orders_BankTransfer]
ALTER TABLE [dbo].[Orders_Invoice] DROP CONSTRAINT [PK_Orders_Invoice]
ALTER TABLE [dbo].[Orders_InvoiceBanking] DROP CONSTRAINT [PK_Orders_InvoiceBanking]
ALTER TABLE [dbo].[Orders_InvoicePayment] DROP CONSTRAINT [PK_Orders_InvoicePayment]

/* Add computed column */
ALTER TABLE [dbo].[Orders_BankTransfer] ADD PartitionNum AS MONTH(CreatedTime) PERSISTED NOT NULL
ALTER TABLE [dbo].[Orders_Invoice] ADD PartitionNum AS MONTH(CreatedTime) PERSISTED NOT NULL
ALTER TABLE [dbo].[Transactions_System] ADD PartitionNum AS MONTH(ResponseTime) PERSISTED NOT NULL
ALTER TABLE [dbo].[Transactions_System] ADD PartitionNum AS MONTH(ResponseTime) PERSISTED NOT NULL

/* Re-create PK for partitioning*/
ALTER TABLE [dbo].[Orders_BankTransfer] ADD CONSTRAINT [PK_Orders_BankTransfer] PRIMARY KEY CLUSTERED (BankTransferOrderID, PartitionNum) WITH (ALLOW_PAGE_LOCKS = OFF) ON [ps_Month]([PartitionNum])
ALTER TABLE [dbo].[Orders_Invoice] ADD CONSTRAINT [PK_Orders_Invoice] PRIMARY KEY CLUSTERED (InvoiceOrderID, PartitionNum) WITH (ALLOW_PAGE_LOCKS = OFF) ON [ps_Month]([PartitionNum])
ALTER TABLE [dbo].[Orders_InvoiceBanking] ADD CONSTRAINT [PK_Orders_InvoiceBanking] PRIMARY KEY CLUSTERED (InvoiceOrderID, PartitionNum) WITH (ALLOW_PAGE_LOCKS = OFF) ON [ps_Month]([PartitionNum])
ALTER TABLE [dbo].[Orders_InvoicePayment] ADD CONSTRAINT [PK_Orders_InvoicePayment] PRIMARY KEY CLUSTERED (InvoiceOrderID, PartitionNum) WITH (ALLOW_PAGE_LOCKS = OFF) ON [ps_Month]([PartitionNum])
```



### Querying-Data Advisor for best performance

- Do not use **SELECT ***
- Always include PartitionNum in order to minimize amount of data for reading
- Try to advoid scanning whole table or whole partition for querying data

Example

```sql
USE [Wallet.Transaction]
GO

SELECT  [TransactionID],[RelationReceiptID],[PayType],[ServiceID],[AccountID],[Amount],[AmountState],[Description],[OpenBalance]
	,[CloseBalance]
FROM dbo.Transactions
WHERE TransactionID = xxxx
AND PartitionNum = 3
```

```sql
USE [Wallet.BillingOrder]
GO

SELECT  [InvoiceOrderID],[TransactionID],[RefundTransactionID],[ServiceID],[BankID],[PaymentAppID],[PayType],[UserID]
	,[AccountName],[GrandAmount],[Amount],[Fee]
FROM dbo.Orders_Invoice
WHERE InvoiceOrderID = xxxx
AND PartitionNum = 3
```

