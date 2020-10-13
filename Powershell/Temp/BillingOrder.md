# Wallet.BillingOrder

```sql
USE [master]
GO
/****** Object:  Database [Wallet.BillingOrder]    Script Date: 7/23/2020 2:42:23 PM ******/
USE [master]
GO
/****** Object:  Database [Wallet.BillingOrder]    Script Date: 7/22/2020 4:47:44 PM ******/
CREATE DATABASE [Wallet.BillingOrder]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Wallet.BillingOrder', FILENAME = N'D:\Database\2019\Mobipay\Wallet.BillingOrder.mdf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ),
FILEGROUP [BANK]
( NAME = N'Wallet.BillingOrder_Bank', FILENAME = N'D:\Database\2019\Mobipay\Wallet.BillingOrder_Bank.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB),
FILEGROUP [ORDER]
( NAME = N'Wallet.BillingOrder_Order', FILENAME = N'D:\Database\2019\Mobipay\Wallet.BillingOrder_Order.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB),
FILEGROUP [PAYMENTAPP]
( NAME = N'Wallet.BillingOrder_PaymentApp', FILENAME = N'D:\Database\2019\Mobipay\Wallet.BillingOrder_PaymentApp.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 50MB),
FILEGROUP [INDEX]
( NAME = N'Wallet.BillingOrder_Index', FILENAME = N'D:\Database\2019\Mobipay\Wallet.BillingOrder_Index.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB)
 LOG ON 
( NAME = N'Wallet.BillingOrder_log', FILENAME = N'D:\Database\2019\Mobipay\Wallet.BillingOrder_log.ldf' , SIZE = 100MB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Wallet.BillingOrder] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Wallet.BillingOrder].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Wallet.BillingOrder] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET ARITHABORT OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Wallet.BillingOrder] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Wallet.BillingOrder] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Wallet.BillingOrder] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Wallet.BillingOrder] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [Wallet.BillingOrder] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET RECOVERY FULL 
GO
ALTER DATABASE [Wallet.BillingOrder] SET  MULTI_USER 
GO
ALTER DATABASE [Wallet.BillingOrder] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Wallet.BillingOrder] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Wallet.BillingOrder] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Wallet.BillingOrder] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Wallet.BillingOrder] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Wallet.BillingOrder', N'ON'
GO
ALTER DATABASE [Wallet.BillingOrder] SET QUERY_STORE = OFF
GO
USE [Wallet.BillingOrder]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
--USE [Wallet.BillingOrder]
--GO
--/****** Object:  User [wshop_sale_service]    Script Date: 7/23/2020 2:42:23 PM ******/
--CREATE USER [wshop_sale_service] FOR LOGIN [wshop_sale_service] WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [wallet_order_service]    Script Date: 7/23/2020 2:42:23 PM ******/
--CREATE USER [wallet_order_service] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [wallet_order_interface_api]    Script Date: 7/23/2020 2:42:23 PM ******/
--CREATE USER [wallet_order_interface_api] FOR LOGIN [wallet_order_interface_api] WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [dev_ewallet]    Script Date: 7/23/2020 2:42:23 PM ******/
--CREATE USER [dev_ewallet] FOR LOGIN [dev_ewallet] WITH DEFAULT_SCHEMA=[dbo]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [wshop_sale_service]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [wallet_order_service]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [wallet_order_interface_api]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [wallet_order_interface_api]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [dev_ewallet]
--GO
--ALTER ROLE [db_datawriter] ADD MEMBER [dev_ewallet]
--GO
USE [Wallet.BillingOrder]
GO
/****** Object:  Sequence [dbo].[OrderID]    Script Date: 7/23/2020 2:42:23 PM ******/
CREATE SEQUENCE [dbo].[OrderID] 
 AS [bigint]
 START WITH 1281900
 INCREMENT BY 1
 MINVALUE 0
 MAXVALUE 9223372036854775807
 CACHE 
GO
USE [Wallet.BillingOrder]
GO
/****** Object:  Sequence [dbo].[PaymentAppID]    Script Date: 7/23/2020 2:42:23 PM ******/
CREATE SEQUENCE [dbo].[PaymentAppID] 
 AS [int]
 START WITH 13260
 INCREMENT BY 1
 MINVALUE 0
 MAXVALUE 2147483647
 CACHE 
GO
/****** Object:  Table [dbo].[BankAccounts]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankAccounts](
	[BankAccountID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[AccountName] [varchar](30) NOT NULL,
	[BankID] [int] NOT NULL,
	[BankBranch] [nvarchar](100) NOT NULL,
	[BankAccount] [varchar](30) NOT NULL,
	[BankAccountName] [nvarchar](100) NOT NULL,
	[BankAccountAddress] [nvarchar](250) NULL,
	[BankAccountType] [tinyint] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[IsDefault] [bit] NOT NULL,
	[OpenDate] [varchar](50) NULL,
	[UpdatedUser] [varchar](30) NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_BankAccounts] PRIMARY KEY CLUSTERED 
(
	[BankAccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [BANK]
) ON [BANK]
GO
/****** Object:  Table [dbo].[BankAccounts_SubRequest]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankAccounts_SubRequest](
	[SubRequestID] [bigint] IDENTITY(1000,1) NOT NULL,
	[UserID] [int] NULL,
	[AccountName] [nvarchar](50) NULL,
	[BankID] [int] NULL,
	[BankCode] [varchar](20) NULL,
	[BankName] [nvarchar](50) NULL,
	[BankAccountName] [nvarchar](50) NULL,
	[BankAccount] [varchar](19) NULL,
	[Passport] [varchar](20) NULL,
	[SubStatus] [int] NULL,
	[ResponseMessage] [nvarchar](150) NULL,
	[BankOTP] [varchar](100) NULL,
	[DeviceType] [int] NULL,
	[BankAccountID] [int] NULL,
	[CreatedTime] [datetime] NULL,
	[UpdateTime] [datetime] NULL,
 CONSTRAINT [PK_AccountSubscriptions] PRIMARY KEY CLUSTERED 
(
	[SubRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [BANK]
) ON [BANK]
GO
/****** Object:  Table [dbo].[BankAccounts_SubValidation]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankAccounts_SubValidation](
	[BankAccountID] [int] NOT NULL,
	[SubscriptionID] [varchar](300) NOT NULL,
	[BankAccount] [varchar](30) NULL,
	[BankID] [int] NULL,
	[UserID] [int] NULL,
	[IssueDate] [date] NULL,
	[ExpireDate] [date] NULL,
	[CreatedTime] [datetime] NULL,
 CONSTRAINT [PK_AccountSubcription] PRIMARY KEY CLUSTERED 
(
	[BankAccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [BANK]
) ON [BANK]
GO
/****** Object:  Table [dbo].[BankExchangeRates]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Missing PK
CREATE TABLE [dbo].[BankExchangeRates](
	[ExchangeRateID] [int] IDENTITY(1,1) NOT NULL,
	[Currency] [char](5) NOT NULL,
	[Rate] [float] NOT NULL,
	[AppliedTime] [datetime] NOT NULL,
	[CreatedUser] [nchar](30) NULL,
	[CreatedTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Banks]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Banks](
	[BankID] [int] IDENTITY(1,1) NOT NULL,
	[BankCode] [varchar](30) NOT NULL,
	[BankName] [nvarchar](250) NULL,
	[BankType] [tinyint] NOT NULL,
	[BankServiceType] [tinyint] NULL,
	[BankStatus] [tinyint] NULL,
	[WebSite] [nvarchar](150) NULL,
	[Logo] [varchar](250) NULL,
	[Address] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[LogoMobileGrid] [varchar](250) NULL,
	[LogoMobileIcon] [varchar](250) NULL,
	[CardColor] [varchar](20) NULL,
	[CreatedTime] [datetime] NULL,
	[UpdatedUser] [varchar](30) NULL,
	[Linkable] [bit] NULL,
	[PartnerCode] [varchar](50) NULL,
	[BinCode] [varchar](50) NULL,
 CONSTRAINT [PK_Banks] PRIMARY KEY CLUSTERED 
(
	[BankID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [BANK]
) ON [BANK]
GO
/****** Object:  Table [dbo].[Banks_PartnerChanels]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Banks_PartnerChanels](
	[PartnerCode] [varchar](50) NOT NULL,
	[PartnerName] [nvarchar](250) NOT NULL,
	[BankLinkType] [tinyint] NOT NULL,
	[PaymentLinkType] [tinyint] NOT NULL,
	[PaymentUnlinkType] [tinyint] NOT NULL,
	[InternerGateUrl] [varchar](250) NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Banks_PartnerChanels] PRIMARY KEY CLUSTERED 
(
	[PartnerCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [BANK]
) ON [BANK]
GO
/****** Object:  Table [dbo].[Orders_BankTransfer]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders_BankTransfer](
	[BankTransferOrderID] [bigint] NOT NULL,
	[TransactionID] [bigint] NULL,
	[BankID] [int] NULL,
	[BankCode] [varchar](30) NOT NULL,
	[UserID] [int] NULL,
	[AccountName] [varchar](30) NULL,
	[Amount] [bigint] NULL,
	[Fee] [bigint] NULL,
	[BankFee] [bigint] NULL,
	[BankAccount] [varchar](20) NULL,
	[BankAccountName] [nvarchar](50) NULL,
	[BankReferenceID] [varchar](50) NULL,
	[BankBranch] [nvarchar](100) NULL,
	[BankTransferType] [tinyint] NULL,
	[BankCreatedTime] [datetime] NULL,
	[Description] [nvarchar](200) NULL,
	[CreatedTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[OrderStatus] [smallint] NOT NULL,
	[ConfirmUser] [varchar](100) NULL,
	[InformType] [tinyint] NOT NULL,
	[IsDeposit] [bit] NOT NULL,
 CONSTRAINT [PK_Orders_BankTransfer] PRIMARY KEY CLUSTERED 
(
	[BankTransferOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [BANK]
) ON [BANK]
GO
/****** Object:  Table [dbo].[Orders_Invoice]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders_Invoice](
	[InvoiceOrderID] [bigint] NOT NULL,
	[TransactionID] [bigint] NULL,
	[RefundTransactionID] [bigint] NULL,
	[ServiceID] [int] NOT NULL,
	[BankID] [int] NULL,
	[PaymentAppID] [int] NULL,
	[PayType] [tinyint] NOT NULL,
	[UserID] [int] NOT NULL,
	[AccountName] [varchar](30) NULL,
	[GrandAmount] [bigint] NOT NULL,
	[Amount] [bigint] NOT NULL,
	[Fee] [int] NOT NULL,
	[RelatedFee] [int] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[OrderStatus] [smallint] NULL,
	[Currency] [char](5) NULL,
	[DeviceType] [tinyint] NULL,
	[ClientIP] [nvarchar](15) NULL,
	[ConfirmUser] [varchar](50) NULL,
	[CreatedTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
 CONSTRAINT [PK_Orders_Invoice] PRIMARY KEY CLUSTERED 
(
	[InvoiceOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ORDER]
) ON [ORDER]
GO
/****** Object:  Table [dbo].[Orders_InvoiceBanking]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders_InvoiceBanking](
	[InvoiceOrderID] [bigint] NOT NULL,
	[BankID] [int] NOT NULL,
	[BankCode] [varchar](20) NOT NULL,
	[PartnerCode] [varchar](50) NULL,
	[BankAccount] [varchar](20) NULL,
	[BankAccountName] [nvarchar](50) NULL,
	[BankAmount] [money] NOT NULL,
	[BankReferenceID] [varchar](50) NULL,
	[RedirectURL] [varchar](250) NULL,
	[NotifyURL] [varchar](250) NULL,
	[ResponseTime] [datetime] NULL,
	[ResponseUnixTime] [int] NULL,
	[ResponseMessage] [nvarchar](150) NULL,
 CONSTRAINT [PK_Orders_InvoiceBanking] PRIMARY KEY CLUSTERED 
(
	[InvoiceOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ORDER]
) ON [ORDER]
GO
/****** Object:  Table [dbo].[Orders_InvoicePayment]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders_InvoicePayment](
	[InvoiceOrderID] [bigint] NOT NULL,
	[PaymentAppID] [int] NOT NULL,
	[PaymentApp] [varchar](50) NULL,
	[MerchantUserID] [int] NOT NULL,
	[MerchantAccount] [varchar](30) NOT NULL,
	[MerchantOrderAmount] [money] NOT NULL,
	[MerchantAmount] [money] NOT NULL,
	[MerchantFee] [money] NULL,
	[MerchantReferenceID] [varchar](50) NULL,
	[RedirectURL] [varchar](250) NULL,
	[NotifyURL] [varchar](250) NULL,
	[ResponseTime] [datetime] NULL,
	[ResponseMessage] [nvarchar](200) NULL,
 CONSTRAINT [PK_Orders_InvoicePayment] PRIMARY KEY CLUSTERED 
(
	[InvoiceOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ORDER]
) ON [ORDER]
GO
/****** Object:  Table [dbo].[Orders_InvoicePaymentIdentity]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders_InvoicePaymentIdentity](
	[PaymentAppID] [int] NOT NULL,
	[MerchantReferenceID] [varchar](50) NOT NULL,
	[InvoiceOrderID] [bigint] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Orders_InvoicePaymentIdentity] PRIMARY KEY CLUSTERED 
(
	[PaymentAppID] ASC,
	[MerchantReferenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ORDER]
) ON [ORDER]
GO
/****** Object:  Table [dbo].[PaymentApps_Button]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentApps_Button](
	[PaymentAppID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[ButtonStyle] [varchar](25) NOT NULL,
	[ButtonProduct] [nvarchar](100) NOT NULL,
	[ButtonCode] [varchar](50) NULL,
	[ButtonType] [tinyint] NOT NULL,
	[Price] [money] NOT NULL,
	[PaymentCode] [varchar](50) NULL,
	[PaymentLogo] [varchar](500) NULL,
	[PaymentLanguage] [tinyint] NULL,
	[SuccessUrl] [varchar](500) NULL,
	[CancelUrl] [varchar](500) NULL,
	[Description] [nvarchar](250) NULL,
	[Enable] [bit] NOT NULL,
	[ChargePackageID] [tinyint] NULL,
	[PaymentTypes] [varchar](100) NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_PaymentApps_Button] PRIMARY KEY CLUSTERED 
(
	[PaymentAppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PAYMENTAPP]
) ON [PAYMENTAPP]
GO
/****** Object:  Table [dbo].[PaymentApps_Mobile]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentApps_Mobile](
	[PaymentAppID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[AppName] [nvarchar](70) NOT NULL,
	[AppOS] [nvarchar](30) NULL,
	[Language] [nvarchar](20) NULL,
	[Description] [nvarchar](150) NULL,
	[PrivateKey] [varchar](150) NOT NULL,
	[ChargePackageID] [int] NULL,
	[PaymentTypes] [varchar](100) NULL,
	[Enable] [bit] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_PaymentApps_Mobile] PRIMARY KEY CLUSTERED 
(
	[PaymentAppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PAYMENTAPP]
) ON [PAYMENTAPP]
GO
/****** Object:  Table [dbo].[PaymentApps_Website]    Script Date: 7/23/2020 2:42:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentApps_Website](
	[PaymentAppID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[WebsiteName] [nvarchar](50) NOT NULL,
	[Logo] [varchar](100) NULL,
	[ResponseUrl] [varchar](100) NULL,
	[PrivateKey] [varchar](1000) NOT NULL,
	[NotifyUrl] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](250) NOT NULL,
	[ChargePackageID] [int] NULL,
	[PaymentTypes] [varchar](100) NULL,
	[Enable] [bit] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_PaymentApps_Website] PRIMARY KEY CLUSTERED 
(
	[PaymentAppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PAYMENTAPP]
) ON [PAYMENTAPP]
GO
ALTER TABLE [dbo].[BankAccounts] ADD  CONSTRAINT [DF_BankAccounts_UserID]  DEFAULT ((0)) FOR [UserID]
GO
ALTER TABLE [dbo].[BankAccounts] ADD  CONSTRAINT [DF_BankAccounts_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[BankAccounts_SubRequest] ADD  CONSTRAINT [DF_EcomSubscriptions_SouceID]  DEFAULT ((0)) FOR [DeviceType]
GO
ALTER TABLE [dbo].[BankAccounts_SubRequest] ADD  CONSTRAINT [DF_EcomSubscriptions_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Banks] ADD  CONSTRAINT [DF_Banks_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Banks_PartnerChanels] ADD  CONSTRAINT [DF_Banks_PartnerChanels_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[Orders_BankTransfer] ADD  CONSTRAINT [DF_Orders_BankTransfer_IsDeposit]  DEFAULT ((1)) FOR [IsDeposit]
GO
ALTER TABLE [dbo].[Orders_InvoicePaymentIdentity] ADD  CONSTRAINT [DF_Orders_InvoicePaymentIdentity_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[PaymentApps_Mobile] ADD  CONSTRAINT [DF_PaymentApps_Mobile_Enable]  DEFAULT ((1)) FOR [Enable]
GO
ALTER TABLE [dbo].[PaymentApps_Website] ADD  CONSTRAINT [DF_PaymentApps_Website_Enable]  DEFAULT ((1)) FOR [Enable]
GO
USE [master]
GO
ALTER DATABASE [Wallet.BillingOrder] SET  READ_WRITE 
GO
```