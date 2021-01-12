# wShop.SaleProduct

```sql
USE [master]
GO
/****** Object:  Database [wShop.SaleProduct]    Script Date: 7/23/2020 3:05:56 PM ******/
CREATE DATABASE [wShop.SaleProduct]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'wShop.SaleProduct', FILENAME = N'D:\Database\2019\Mobipay\wShop.SaleProduct.mdf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ),
FILEGROUP [POLICY]
( NAME = N'wShop.SaleProduct_Policy', FILENAME = N'D:\Database\2019\Mobipay\wShop.SaleProduct_Policy.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB),
FILEGROUP [SALEORDER]
( NAME = N'wShop.SaleProduct_SaleOrder', FILENAME = N'D:\Database\2019\Mobipay\wShop.SaleProduct_SaleOrder.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB),
FILEGROUP [PRODUCT]
( NAME = N'wShop.SaleProduct_Product', FILENAME = N'D:\Database\2019\Mobipay\wShop.SaleProduct_Product.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 50MB)
 LOG ON 
( NAME = N'wShop.SaleProduct_log', FILENAME = N'D:\Database\2019\Mobipay\wShop.SaleProduct_log.ldf' , SIZE = 50MB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [wShop.SaleProduct] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [wShop.SaleProduct].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [wShop.SaleProduct] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET ARITHABORT OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [wShop.SaleProduct] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [wShop.SaleProduct] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET  DISABLE_BROKER 
GO
ALTER DATABASE [wShop.SaleProduct] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [wShop.SaleProduct] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [wShop.SaleProduct] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET RECOVERY FULL 
GO
ALTER DATABASE [wShop.SaleProduct] SET  MULTI_USER 
GO
ALTER DATABASE [wShop.SaleProduct] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [wShop.SaleProduct] SET DB_CHAINING OFF 
GO
ALTER DATABASE [wShop.SaleProduct] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [wShop.SaleProduct] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [wShop.SaleProduct] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'wShop.SaleProduct', N'ON'
GO
ALTER DATABASE [wShop.SaleProduct] SET QUERY_STORE = OFF
GO
USE [wShop.SaleProduct]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
--USE [wShop.SaleProduct]
--GO
--/****** Object:  User [dev_ewallet]    Script Date: 7/23/2020 3:05:57 PM ******/
--CREATE USER [dev_ewallet] FOR LOGIN [dev_ewallet] WITH DEFAULT_SCHEMA=[dbo]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [dev_ewallet]
--GO
--ALTER ROLE [db_datawriter] ADD MEMBER [dev_ewallet]
--GO
USE [wShop.SaleProduct]
GO
/****** Object:  Sequence [dbo].[ProductID]    Script Date: 7/23/2020 3:05:57 PM ******/
CREATE SEQUENCE [dbo].[ProductID] 
 AS [int]
 START WITH 35000
 INCREMENT BY 1000
 MINVALUE 0
 MAXVALUE 2147483647
 CACHE 
GO
USE [wShop.SaleProduct]
GO
/****** Object:  Sequence [dbo].[ProductServiceID]    Script Date: 7/23/2020 3:05:57 PM ******/
CREATE SEQUENCE [dbo].[ProductServiceID] 
 AS [int]
 START WITH 15000000
 INCREMENT BY 1000000
 MINVALUE 0
 MAXVALUE 2147483647
 CACHE 
GO
USE [wShop.SaleProduct]
GO
/****** Object:  Sequence [dbo].[SubProductID]    Script Date: 7/23/2020 3:05:57 PM ******/
CREATE SEQUENCE [dbo].[SubProductID] 
 AS [int]
 START WITH 160
 INCREMENT BY 1
 MINVALUE 0
 MAXVALUE 2147483647
 CACHE 
GO
/****** Object:  Table [dbo].[Policies_ExportRate]    Script Date: 7/23/2020 3:05:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Policies_ExportRate](
	[ExportRateID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[AppliedObjectID] [int] NOT NULL,
	[AppliedObjectType] [tinyint] NOT NULL,
	[PolicyType] [tinyint] NOT NULL,
	[RateAmount] [float] NOT NULL,
	[FixAmount] [int] NOT NULL,
	[AppliedTime] [datetime] NOT NULL,
	[ExpiryTime] [datetime] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Policies_SaleApplying] PRIMARY KEY CLUSTERED 
(
	[ExportRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [POLICY]
) ON [POLICY]
GO
/****** Object:  Table [dbo].[Policies_ImportDiscount]    Script Date: 7/23/2020 3:05:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Policies_ImportDiscount](
	[ImportDiscountID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[RateAmount] [float] NOT NULL,
	[AppliedTime] [datetime] NOT NULL,
	[ExpiryTime] [datetime] NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Policies_ImportDiscount] PRIMARY KEY CLUSTERED 
(
	[ImportDiscountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [POLICY]
) ON [POLICY]
GO
/****** Object:  Table [dbo].[Policies_UpdateLog]    Script Date: 7/23/2020 3:05:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Policies_UpdateLog](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[AppliedObjectID] [int] NULL,
	[AppliedObjectType] [tinyint] NULL,
	[PolicyType] [tinyint] NULL,
	[LogData] [varchar](150) NULL,
	[AppliedTime] [datetime] NULL,
	[ExpiryTime] [datetime] NULL,
	[CreatedUser] [varchar](30) NULL,
	[CreatedTime] [datetime] NULL,
 CONSTRAINT [PK_Policies_UpdateLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [POLICY]
) ON [POLICY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 7/23/2020 3:05:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] NOT NULL,
	[SortIndex] [int] NOT NULL,
	[ParentID] [int] NULL,
	[ProductCode] [varchar](50) NOT NULL,
	[ProductName] [nvarchar](100) NOT NULL,
	[ParValue] [int] NULL,
	[AppliedVersion] [tinyint] NULL,
	[PriorityState] [tinyint] NULL,
	[Disable] [bit] NOT NULL,
	[ProductType] [tinyint] NOT NULL,
	[ExchangeRate] [float] NOT NULL,
	[UpdatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRODUCT]
) ON [PRODUCT]
GO
/****** Object:  Table [dbo].[Products_Detail]    Script Date: 7/23/2020 3:05:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products_Detail](
	[ProductID] [int] NOT NULL,
	[Description] [nvarchar](250) NULL,
	[Detail] [nvarchar](1050) NULL,
	[Logo] [varchar](100) NULL,
 CONSTRAINT [PK_Products_Detail] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRODUCT]
) ON [PRODUCT]
GO
/****** Object:  Table [dbo].[Products_UpdateLog]    Script Date: 7/23/2020 3:05:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products_UpdateLog](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductType] [tinyint] NULL,
	[LogType] [tinyint] NULL,
	[Reason] [nvarchar](100) NULL,
	[CreatedUser] [varchar](30) NULL,
	[CreatedTime] [datetime] NULL,
 CONSTRAINT [PK_Products_UpdateLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRODUCT]
) ON [PRODUCT]
GO
/****** Object:  Table [dbo].[SaleOrders]    Script Date: 7/23/2020 3:05:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaleOrders](
	[SaleOrderID] [bigint] IDENTITY(863000,1) NOT NULL,
	[CustomerUserID] [int] NOT NULL,
	[CustomerMobile] [varchar](30) NOT NULL,
	[CustomerEmail] [varchar](50) NULL,
	[CustomerName] [nvarchar](100) NULL,
	[TotalGrandAmount] [bigint] NOT NULL,
	[PaymentFee] [bigint] NULL,
	[PaymentAmount] [bigint] NOT NULL,
	[Description] [nvarchar](150) NULL,
	[OrderStatus] [smallint] NOT NULL,
	[PayType] [tinyint] NULL,
	[DeviceType] [tinyint] NULL,
	[PaymentOrderID] [bigint] NULL,
	[TransactionID] [bigint] NULL,
	[PartnerOrderID] [bigint] NULL,
	[ClientIP] [varchar](30) NULL,
	[ConfirmUser] [varchar](50) NULL,
	[CreatedUser] [varchar](50) NULL,
	[CreatedTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
 CONSTRAINT [PK_SaleOrders] PRIMARY KEY CLUSTERED 
(
	[SaleOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [SALEORDER]
) ON [SALEORDER]
GO
/****** Object:  Table [dbo].[SaleOrders_Product]    Script Date: 7/23/2020 3:05:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaleOrders_Product](
	[SaleOrderID] [bigint] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductValue] [int] NULL,
	[Amount] [bigint] NULL,
	[Discount] [bigint] NULL,
	[Fee] [bigint] NULL,
	[Quantity] [int] NULL,
	[GrandAmount] [bigint] NULL,
	[ProductAccount] [varchar](30) NULL,
	[ProductDetail] [nvarchar](250) NULL,
	[ImportDiscount] [bigint] NULL,
	[ProductType] [tinyint] NULL,
 CONSTRAINT [PK_SaleOrders_Product] PRIMARY KEY CLUSTERED 
(
	[SaleOrderID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [SALEORDER]
) ON [SALEORDER]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_Disable]  DEFAULT ((0)) FOR [Disable]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_ExchangeRate]  DEFAULT ((1)) FOR [ExchangeRate]
GO
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [DF_Products_UpdatedTime]  DEFAULT (getdate()) FOR [UpdatedTime]
GO
USE [master]
GO
ALTER DATABASE [wShop.SaleProduct] SET  READ_WRITE 
GO
```