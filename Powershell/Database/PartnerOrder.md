# wShop.PartnerOrder

```sql
USE [master]
GO
/****** Object:  Database [wShop.PartnerOrder]    Script Date: 7/23/2020 2:57:07 PM ******/
CREATE DATABASE [wShop.PartnerOrder]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'wShop.PartnerOrder', FILENAME = N'D:\Database\2019\Mobipay\wShop.PartnerOrder.mdf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ),
FILEGROUP [ORDER]
( NAME = N'wShop.PartnerOrder_Order', FILENAME = N'D:\Database\2019\Mobipay\wShop.PartnerOrder_Order.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB),
FILEGROUP [PARTNER]
( NAME = N'wShop.PartnerOrder_Partner', FILENAME = N'D:\Database\2019\Mobipay\wShop.PartnerOrder_Partner.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB)
 LOG ON 
( NAME = N'wShop.PartnerOrder_log', FILENAME = N'D:\Database\2019\Mobipay\wShop.PartnerOrder_log.ldf' , SIZE = 50MB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [wShop.PartnerOrder] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [wShop.PartnerOrder].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [wShop.PartnerOrder] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET ARITHABORT OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [wShop.PartnerOrder] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [wShop.PartnerOrder] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET  DISABLE_BROKER 
GO
ALTER DATABASE [wShop.PartnerOrder] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [wShop.PartnerOrder] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [wShop.PartnerOrder] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET RECOVERY FULL 
GO
ALTER DATABASE [wShop.PartnerOrder] SET  MULTI_USER 
GO
ALTER DATABASE [wShop.PartnerOrder] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [wShop.PartnerOrder] SET DB_CHAINING OFF 
GO
ALTER DATABASE [wShop.PartnerOrder] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [wShop.PartnerOrder] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [wShop.PartnerOrder] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'wShop.PartnerOrder', N'ON'
GO
ALTER DATABASE [wShop.PartnerOrder] SET QUERY_STORE = OFF
GO
USE [wShop.PartnerOrder]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
--USE [wShop.PartnerOrder]
--GO
--/****** Object:  User [dev_ewallet]    Script Date: 7/23/2020 2:57:07 PM ******/
--CREATE USER [dev_ewallet] FOR LOGIN [dev_ewallet] WITH DEFAULT_SCHEMA=[dbo]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [dev_ewallet]
--GO
--ALTER ROLE [db_datawriter] ADD MEMBER [dev_ewallet]
--GO
/****** Object:  Table [dbo].[Orders_Invoice]    Script Date: 7/23/2020 2:57:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders_Invoice](
	[InvoiceOrderID] [bigint] IDENTITY(9621000,1) NOT NULL,
	[PartnerOrderID] [varchar](20) NOT NULL,
	[PartnerCode] [varchar](20) NULL,
	[ProductID] [int] NULL,
	[ProductCode] [varchar](50) NULL,
	[Description] [nvarchar](100) NULL,
	[ProductAccount] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[Amount] [bigint] NULL,
	[ProductValue] [bigint] NULL,
	[OrderStatus] [smallint] NULL,
	[SaleOrderID] [bigint] NULL,
	[PartnerReferenceID] [varchar](50) NULL,
	[ResponseMessage] [nvarchar](200) NULL,
	[ResponseTime] [datetime] NULL,
	[DeviceType] [tinyint] NULL,
	[ClientIP] [varchar](15) NULL,
	[ConfirmUser] [varchar](50) NULL,
	[CreatedTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
 CONSTRAINT [PK_Order_InvoiceProduct] PRIMARY KEY CLUSTERED 
(
	[InvoiceOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ORDER]
) ON [ORDER]
GO
/****** Object:  Table [dbo].[Orders_ProductItem]    Script Date: 7/23/2020 2:57:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders_ProductItem](
	[ProductItemID] [bigint] IDENTITY(5000,1) NOT NULL,
	[ItemKey] [varchar](30) NOT NULL,
	[ItemData] [varchar](2500) NOT NULL,
	[ProductID] [int] NOT NULL,
	[InvoiceOrderID] [bigint] NOT NULL,
 CONSTRAINT [PK_Orders_ProductItem] PRIMARY KEY CLUSTERED 
(
	[ProductItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ORDER]
) ON [ORDER]
GO
/****** Object:  Table [dbo].[Orders_SaleIdentity]    Script Date: 7/23/2020 2:57:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders_SaleIdentity](
	[SaleOrderID] [bigint] NOT NULL,
	[InvoiceOrderID] [bigint] NULL,
	[CreatedTime] [datetime] NULL,
 CONSTRAINT [PK_Orders_Invoice_Identity] PRIMARY KEY CLUSTERED 
(
	[SaleOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ORDER]
) ON [ORDER]
GO
/****** Object:  Table [dbo].[PartnerChanels]    Script Date: 7/23/2020 2:57:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PartnerChanels](
	[PartnerCode] [varchar](50) NOT NULL,
	[PartnerName] [nvarchar](250) NULL,
	[InternerGateUrl] [varchar](250) NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_PartnerChanels] PRIMARY KEY CLUSTERED 
(
	[PartnerCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PARTNER]
) ON [PARTNER]
GO
/****** Object:  Table [dbo].[PartnerProducts]    Script Date: 7/23/2020 2:57:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PartnerProducts](
	[ProductD] [int] NOT NULL,
	[PartnerCode] [varchar](50) NOT NULL,
	[ProductCode] [varchar](50) NULL,
	[PartnerProductCode] [varchar](50) NULL,
	[ProductName] [nvarchar](100) NULL,
	[CreatedTime] [datetime] NULL,
 CONSTRAINT [PK_PartnerProducts] PRIMARY KEY CLUSTERED 
(
	[ProductD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PARTNER]
) ON [PARTNER]
GO
ALTER TABLE [dbo].[Orders_Invoice] ADD  CONSTRAINT [DF_Orders_Invoice_Quantity]  DEFAULT ((1)) FOR [Quantity]
GO
ALTER TABLE [dbo].[Orders_Invoice] ADD  CONSTRAINT [DF_Orders_Invoice_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Orders_SaleIdentity] ADD  CONSTRAINT [DF_Orders_Invoice_Identity_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[PartnerChanels] ADD  CONSTRAINT [DF_PartnerChanels_UpdateTime]  DEFAULT (getdate()) FOR [UpdateTime]
GO
ALTER TABLE [dbo].[PartnerProducts] ADD  CONSTRAINT [DF_PartnerProducts_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
USE [master]
GO
ALTER DATABASE [wShop.PartnerOrder] SET  READ_WRITE 
GO
```