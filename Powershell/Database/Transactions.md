# Wallet.Transactions

```sql
USE [master]
GO
/****** Object:  Database [Wallet.Transaction]    Script Date: 7/23/2020 2:49:54 PM ******/
CREATE DATABASE [Wallet.Transaction]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Wallet.Transactions', FILENAME = N'D:\Database\2019\Mobipay\Wallet.Transactions.mdf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ),
FILEGROUP [TRANSACTION]
( NAME = N'Wallet.Transactions_Transaction', FILENAME = N'D:\Database\2019\Mobipay\Wallet.Transactions_Transaction.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB),
FILEGROUP [TRANSACTION_SERVICE]
( NAME = N'Wallet.Transactions_TransactionService', FILENAME = N'D:\Database\2019\Mobipay\Wallet.Transactions_TransactionService.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB)
 LOG ON 
( NAME = N'Wallet.Transactions_log', FILENAME = N'D:\Database\2019\Mobipay\Wallet.Transactions_log.ldf' , SIZE = 100MB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Wallet.Transaction] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Wallet.Transaction].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Wallet.Transaction] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET ARITHABORT OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Wallet.Transaction] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Wallet.Transaction] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Wallet.Transaction] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Wallet.Transaction] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [Wallet.Transaction] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [Wallet.Transaction] SET RECOVERY FULL 
GO
ALTER DATABASE [Wallet.Transaction] SET  MULTI_USER 
GO
ALTER DATABASE [Wallet.Transaction] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Wallet.Transaction] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Wallet.Transaction] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Wallet.Transaction] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Wallet.Transaction] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Wallet.Transaction', N'ON'
GO
ALTER DATABASE [Wallet.Transaction] SET QUERY_STORE = OFF
GO
USE [Wallet.Transaction]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
--USE [Wallet.Transaction]
--GO
--/****** Object:  User [wallet_core_service_archive]    Script Date: 7/23/2020 2:49:54 PM ******/
--CREATE USER [wallet_core_service_archive] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [wallet_core_service]    Script Date: 7/23/2020 2:49:54 PM ******/
--CREATE USER [wallet_core_service] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [dev_ewallet]    Script Date: 7/23/2020 2:49:54 PM ******/
--CREATE USER [dev_ewallet] FOR LOGIN [dev_ewallet] WITH DEFAULT_SCHEMA=[dbo]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [wallet_core_service_archive]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [wallet_core_service]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [dev_ewallet]
--GO
--ALTER ROLE [db_datawriter] ADD MEMBER [dev_ewallet]
--GO
USE [Wallet.Transaction]
GO
/****** Object:  Sequence [dbo].[TransactionID]    Script Date: 7/23/2020 2:49:55 PM ******/
CREATE SEQUENCE [dbo].[TransactionID] 
 AS [bigint]
 START WITH 6833427599
 INCREMENT BY 1
 MINVALUE 0
 MAXVALUE 9223372036854775807
 CACHE 
GO
/****** Object:  View [dbo].[Accounts]    Script Date: 7/23/2020 2:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Accounts]
AS
SELECT * FROM [Wallet.Account].dbo.Accounts

GO
/****** Object:  View [dbo].[Accounts_Secondary]    Script Date: 7/23/2020 2:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Accounts_Secondary]
AS
SELECT * FROM [Wallet.Account].[dbo].[Accounts_Secondary]

GO
/****** Object:  View [dbo].[Accounts_System]    Script Date: 7/23/2020 2:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Accounts_System]
AS
SELECT * FROM [Wallet.Account].[dbo].[Accounts_System]

GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 7/23/2020 2:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[TransactionID] [bigint] NOT NULL,
	[RelationReceiptID] [bigint] NOT NULL,
	[PayType] [tinyint] NOT NULL,
	[ServiceID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[Amount] [bigint] NOT NULL,
	[AmountState] [bit] NOT NULL,
	[Description] [nvarchar](300) NULL,
	[OpenBalance] [bigint] NOT NULL,
	[CloseBalance] [bigint] NOT NULL,
	[CreatedUnixTime] [int] NOT NULL,
	[InitUnixTime] [int] NULL,
	[ClientUnixIP] [bigint] NULL,
 CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [TRANSACTION]
) ON [TRANSACTION]
GO
/****** Object:  Table [dbo].[Transactions_OrderIdentity]    Script Date: 7/23/2020 2:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions_OrderIdentity](
	[BillingOrderUID] [bigint] NOT NULL,
	[RelationReceiptID] [bigint] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Receipts_UniqueOrder] PRIMARY KEY CLUSTERED 
(
	[BillingOrderUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [TRANSACTION]
) ON [TRANSACTION]
GO
/****** Object:  Table [dbo].[Transactions_Receipt]    Script Date: 7/23/2020 2:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions_Receipt](
	[TransactionID] [bigint] NOT NULL,
	[SourceReceiptID] [bigint] NULL,
	[PayType] [tinyint] NOT NULL,
	[UserID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[AccountName] [varchar](50) NOT NULL,
	[BankAccount] [varchar](30) NULL,
	[BankCode] [varchar](30) NULL,
	[Amount] [bigint] NOT NULL,
	[Fee] [bigint] NOT NULL,
	[RelatedFee] [bigint] NOT NULL,
	[RelatedAmount] [bigint] NOT NULL,
	[RelatedUserID] [int] NOT NULL,
	[RelatedAccountID] [int] NOT NULL,
	[RelatedAccount] [varchar](50) NOT NULL,
	[Description] [nvarchar](300) NULL,
	[PaymentApp] [varchar](50) NULL,
	[PaymentReferenceID] [varchar](50) NULL,
	[BankReferenceID] [varchar](50) NULL,
	[BillingOrderID] [bigint] NULL,
	[CreatedUser] [varchar](50) NULL,
	[DeviceType] [tinyint] NULL,
	[ClientIP] [varchar](50) NULL,
	[CreatedTime] [datetime] NOT NULL,
	[InitTime] [datetime] NULL,
 CONSTRAINT [PK_Transactions_Receipt] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [TRANSACTION]
) ON [TRANSACTION]
GO
/****** Object:  Table [dbo].[Transactions_ServiceFees]    Script Date: 7/23/2020 2:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions_ServiceFees](
	[FeeConfigID] [int] NOT NULL,
	[Note] [nvarchar](450) NULL,
	[Paytypes] [varchar](50) NOT NULL,
	[Services] [varchar](500) NOT NULL,
	[TransferorFee] [varchar](50) NOT NULL,
	[ReceiverFee] [varchar](50) NOT NULL,
	[NextTransferorFee] [varchar](50) NOT NULL,
	[NextReceiverFee] [varchar](50) NOT NULL,
	[NextApplyTime] [datetime] NULL,
	[Changeable] [bit] NOT NULL,
	[ApplyObjectID] [int] NOT NULL,
	[ApplyObjectType] [tinyint] NOT NULL,
	[UpdatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Transactions_ServicePolicies] PRIMARY KEY CLUSTERED 
(
	[FeeConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [TRANSACTION_SERVICE]
) ON [TRANSACTION_SERVICE]
GO
/****** Object:  Table [dbo].[Transactions_Services]    Script Date: 7/23/2020 2:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions_Services](
	[ServiceID] [int] NOT NULL,
	[GroupServiceID] [int] NOT NULL,
	[GroupServiceName] [nvarchar](150) NULL,
	[ServiceKey] [nvarchar](50) NOT NULL,
	[ServiceName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[AffectToBalance] [tinyint] NOT NULL,
	[Enable] [bit] NOT NULL,
	[ParentID] [int] NOT NULL,
 CONSTRAINT [PK__Wallet_S__C51BB0EA72FCCF20] PRIMARY KEY CLUSTERED 
(
	[ServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [TRANSACTION_SERVICE]
) ON [TRANSACTION_SERVICE]
GO
/****** Object:  Table [dbo].[Transactions_System]    Script Date: 7/23/2020 2:49:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions_System](
	[TransactionID] [bigint] NOT NULL,
	[RelationReceiptID] [bigint] NOT NULL,
	[ServiceID] [int] NOT NULL,
	[PayType] [tinyint] NOT NULL,
	[AccountID] [int] NOT NULL,
	[TransactorID] [int] NOT NULL,
	[Amount] [bigint] NOT NULL,
	[RelatedAmount] [bigint] NOT NULL,
	[GrandAmount] [bigint] NOT NULL,
	[AmountState] [bit] NOT NULL,
	[OpenBalance] [bigint] NOT NULL,
	[CloseBalance] [bigint] NOT NULL,
	[CreatedUnixTime] [int] NOT NULL,
 CONSTRAINT [PK_Transactions_System] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [TRANSACTION_SERVICE]
) ON [TRANSACTION_SERVICE]
GO
ALTER TABLE [dbo].[Transactions_OrderIdentity] ADD  CONSTRAINT [DF_Receipts_UniqueOrder_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Transactions_ServiceFees] ADD  CONSTRAINT [DF_Transactions_ServiceFees_UpdatedTime]  DEFAULT (getdate()) FOR [UpdatedTime]
GO
ALTER TABLE [dbo].[Transactions_Services] ADD  CONSTRAINT [DF__Wallet_Se__Enabl__117F9D94]  DEFAULT ((1)) FOR [Enable]
GO
ALTER TABLE [dbo].[Transactions_Services] ADD  CONSTRAINT [DF__Wallet_Se__Paren__108B795B]  DEFAULT ((0)) FOR [ParentID]
GO
ALTER TABLE [dbo].[Transactions_System] ADD  CONSTRAINT [DF_Transactions_System_RelatedAmount]  DEFAULT ((0)) FOR [RelatedAmount]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'*100 + Subfix' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transactions_OrderIdentity', @level2type=N'COLUMN',@level2name=N'BillingOrderUID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Accounts_1"
            Begin Extent = 
               Top = 33
               Left = 62
               Bottom = 163
               Right = 232
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Accounts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Accounts'
GO
USE [master]
GO
ALTER DATABASE [Wallet.Transaction] SET  READ_WRITE 
GO

```