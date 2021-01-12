# Wallet.Accounts

```sql
USE [master]
GO
/****** Object:  Database [Wallet.Account]    Script Date: 7/22/2020 3:51:13 PM ******/
CREATE DATABASE [Wallet.Account]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Wallet.Account', FILENAME = N'D:\Database\2019\Mobipay\Wallet.Account.mdf' , SIZE = 100MB , MAXSIZE = UNLIMITED, FILEGROWTH = 50MB ), 
 FILEGROUP [ACCOUNT]
( NAME = N'Wallet.Account_Account', FILENAME = N'D:\Database\2019\Mobipay\Wallet.Account_Account.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB),
FILEGROUP [USER]
( NAME = N'Wallet.Account_User', FILENAME = N'D:\Database\2019\Mobipay\Wallet.Account_User.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB),
FILEGROUP [INDEX]
( NAME = N'Wallet.Account_Index', FILENAME = N'D:\Database\2019\Mobipay\Wallet.Account_Index.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB),
 FILEGROUP [Wallet.Account_MemOp] CONTAINS MEMORY_OPTIMIZED_DATA  DEFAULT
( NAME = N'Wallet.Account_MemOp', FILENAME = N'D:\Database\2019\Mobipay\Wallet.Account_MemOp' , MAXSIZE = UNLIMITED)
 LOG ON 
( NAME = N'Wallet.Account_log', FILENAME = N'D:\Database\2019\Mobipay\Wallet.Account.ldf' , SIZE = 100MB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 COLLATE SQL_Latin1_General_CP1_CI_AS
GO
ALTER DATABASE [Wallet.Account] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Wallet.Account].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Wallet.Account] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Wallet.Account] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Wallet.Account] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Wallet.Account] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Wallet.Account] SET ARITHABORT OFF 
GO
ALTER DATABASE [Wallet.Account] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Wallet.Account] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Wallet.Account] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Wallet.Account] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Wallet.Account] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Wallet.Account] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Wallet.Account] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Wallet.Account] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Wallet.Account] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Wallet.Account] SET DISABLE_BROKER 
GO
ALTER DATABASE [Wallet.Account] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Wallet.Account] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Wallet.Account] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Wallet.Account] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Wallet.Account] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Wallet.Account] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [Wallet.Account] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Wallet.Account] SET RECOVERY FULL 
GO
ALTER DATABASE [Wallet.Account] SET  MULTI_USER 
GO
ALTER DATABASE [Wallet.Account] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Wallet.Account] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Wallet.Account] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Wallet.Account] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Wallet.Account] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Wallet.Account', N'ON'
GO
ALTER DATABASE [Wallet.Account] SET QUERY_STORE = OFF
GO
USE [Wallet.Account]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO

--USE [Wallet.Account]
--GO
--/****** Object:  User [wallet_core_service]    Script Date: 7/23/2020 2:14:22 PM ******/
--CREATE USER [wallet_core_service] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [dev_ewallet]    Script Date: 7/23/2020 2:14:22 PM ******/
--CREATE USER [dev_ewallet] FOR LOGIN [dev_ewallet] WITH DEFAULT_SCHEMA=[dbo]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [wallet_core_service]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [dev_ewallet]
--GO
--ALTER ROLE [db_datawriter] ADD MEMBER [dev_ewallet]
--GO
--USE [Wallet.Account]
--GO
/****** Object:  Sequence [dbo].[AccountID]    Script Date: 7/23/2020 2:14:22 PM ******/
CREATE SEQUENCE [dbo].[AccountID] 
 AS [int]
 START WITH 6890
 INCREMENT BY 1
 MINVALUE 0
 MAXVALUE 2147483647
 CACHE 
GO
/****** Object:  Table [dbo].[__Users_Auth]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__Users_Auth](
	[Username] [varchar](50) NOT NULL,
	[UserID] [int] NOT NULL,
	[IsVerify] [bit] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Users_Auth] PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ACCOUNT]
) ON [ACCOUNT]
GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts](
	[AccountID] [int] NOT NULL,
	[AccountName] [varchar](50) NOT NULL,
	[Balance] [bigint] NOT NULL,
	[BalanceType] [tinyint] NULL,
	[Currency] [char](5) NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ACCOUNT],
 CONSTRAINT [IX_AccountName] UNIQUE NONCLUSTERED 
(
	[AccountName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [INDEX]
) ON [ACCOUNT]
GO
/****** Object:  Table [dbo].[Accounts_Secondary]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts_Secondary](
	[AccountID] [int] NOT NULL,
	[AccountName] [varchar](50) NOT NULL,
	[Balance] [bigint] NOT NULL,
	[BalanceType] [tinyint] NOT NULL,
	[Currency] [char](5) NOT NULL,
	[UserID] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Accounts_Secodary_1] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ACCOUNT]
) ON [ACCOUNT]
GO
/****** Object:  Table [dbo].[Accounts_System]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts_System](
	[AccountID] [int] NOT NULL,
	[TransactorID] [int] NOT NULL,
	[Balance] [bigint] NOT NULL,
	[UpdatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Accounts_SysSecondary] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC,
	[TransactorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [ACCOUNT]
) ON [ACCOUNT]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(681310,1) NOT NULL,
	[Username] [varchar](50) NULL,
	[Password] [varchar](500) NOT NULL,
	[VerifyType] [tinyint] NOT NULL,
	[UserType] [tinyint] NOT NULL,
	[UserStatus] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[UpdatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [USER]
) ON [USER]
GO
/****** Object:  Table [dbo].[Users_Auth]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_Auth]
(
	[Username] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UserID] [int] NOT NULL,
	[IsVerify] [bit] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,

 CONSTRAINT [Users_Auth_primaryKey]  PRIMARY KEY NONCLUSTERED HASH 
(
	[Username]
)WITH ( BUCKET_COUNT = 16384)
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_AND_DATA )
GO
/****** Object:  Table [dbo].[Users_AuthDevices]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_AuthDevices](
	[UserID] [int] NOT NULL,
	[DeviceID] [varchar](100) NOT NULL,
	[PublicKey] [varchar](1000) NOT NULL,
	[SecureData] [varchar](max) NULL,
	[ActiveTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Users_ActiveDevices] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [USER]
) ON [USER] TEXTIMAGE_ON [USER]
GO
/****** Object:  Table [dbo].[Users_BlockService]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_BlockService](
	[UserID] [int] NOT NULL,
	[ServiceID] [int] NOT NULL,
	[BlockType] [tinyint] NOT NULL,
	[Reason] [nvarchar](150) NULL,
	[CreatedTime] [datetime] NULL,
	[CreatedUser] [varchar](30) NULL,
 CONSTRAINT [PK_Users_BlockService] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[ServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [USER]
) ON [USER]
GO
/****** Object:  Table [dbo].[Users_Profile]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_Profile](
	[UserID] [int] NOT NULL,
	[AccountName] [varchar](50) NOT NULL,
	[Mobile] [varchar](30) NULL,
	[FullName] [nvarchar](100) NULL,
	[Email] [varchar](100) NULL,
	[Passport] [varchar](30) NULL,
	[Avatar] [varchar](150) NULL,
 CONSTRAINT [PK_Users_Profile_1] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [USER]
) ON [USER]
GO
/****** Object:  Table [dbo].[Users_ProfileAttributes]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_ProfileAttributes](
	[UserID] [int] NOT NULL,
	[KeyID] [int] NOT NULL,
	[ValueNumber] [bigint] NULL,
	[ValueText] [nvarchar](500) NULL,
 CONSTRAINT [PK_Users_Profile] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[KeyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [USER]
) ON [USER]
GO
/****** Object:  Table [dbo].[Users_ProfileAttributes_Dict]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_ProfileAttributes_Dict](
	[KeyID] [int] NOT NULL,
	[KeyName] [varchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[ValueType] [tinyint] NOT NULL,
	[SortIndex] [int] NOT NULL,
 CONSTRAINT [PK_User_Profile_Dict] PRIMARY KEY CLUSTERED 
(
	[KeyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [USER]
) ON [USER]
GO
/****** Object:  Table [dbo].[Users_ProfileLocations]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_ProfileLocations](
	[LocationID] [int] NOT NULL,
	[LocationCode] [varchar](30) NULL,
	[LocationName] [nvarchar](100) NOT NULL,
	[LocationLevel] [tinyint] NOT NULL,
	[ParentID] [int] NOT NULL,
 CONSTRAINT [PK_ProfileLocations] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [USER]
) ON [USER]
GO
/****** Object:  Table [dbo].[Users_ProfileVerification]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_ProfileVerification](
	[UserID] [int] NOT NULL,
	[AccountName] [varchar](50) NOT NULL,
	[ImageUrl] [varchar](1000) NOT NULL,
	[VerifyStatus] [tinyint] NOT NULL,
	[Description] [nvarchar](200) NULL,
	[UserConfirm] [varchar](50) NULL,
	[ConfirmTime] [datetime] NULL,
	[CreatedTime] [datetime] NOT NULL,
	[CreatedUnixTime] [int] NOT NULL,
 CONSTRAINT [PK_Users_ProfileVerification] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [USER]
) ON [USER]
GO
/****** Object:  Table [dbo].[Users_SecureConfig]    Script Date: 7/23/2020 2:14:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users_SecureConfig](
	[UserID] [int] NOT NULL,
	[SecureType] [int] NOT NULL,
	[AccountName] [varchar](50) NOT NULL,
	[MinAmount] [bigint] NOT NULL,
	[SecureStatus] [tinyint] NOT NULL,
	[NotifyType] [varchar](30) NULL,
	[ModifiedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Users_SecureConfig] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[SecureType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [USER]
) ON [USER]
GO
ALTER TABLE [dbo].[__Users_Auth] ADD  CONSTRAINT [DF_Users_Auth_EnableOn__Users_Auth]  DEFAULT ((0)) FOR [IsVerify]
GO
ALTER TABLE [dbo].[__Users_Auth] ADD  CONSTRAINT [DF_Users_Auth_CreatedTimeOn__Users_Auth]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Accounts] ADD  CONSTRAINT [DF_Accounts_Balance]  DEFAULT ((0)) FOR [Balance]
GO
ALTER TABLE [dbo].[Accounts] ADD  CONSTRAINT [DF_Accounts_Currency]  DEFAULT ('VND') FOR [Currency]
GO
ALTER TABLE [dbo].[Accounts_Secondary] ADD  CONSTRAINT [DF_Accounts_Secodary_Balance]  DEFAULT ((0)) FOR [Balance]
GO
ALTER TABLE [dbo].[Accounts_Secondary] ADD  CONSTRAINT [DF_Accounts_Secodary_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Accounts_System] ADD  CONSTRAINT [DF_Accounts_SysSecondary_Balance]  DEFAULT ((0)) FOR [Balance]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_VerifyType]  DEFAULT ((0)) FOR [VerifyType]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_UserStatus]  DEFAULT ((0)) FOR [UserStatus]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_CreatedTime1]  DEFAULT (getdate()) FOR [UpdatedTime]
GO
ALTER TABLE [dbo].[Users_Auth] ADD  CONSTRAINT [DF_Users_Auth_Enable]  DEFAULT ((0)) FOR [IsVerify]
GO
ALTER TABLE [dbo].[Users_Auth] ADD  CONSTRAINT [DF_Users_Auth_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Users_AuthDevices] ADD  CONSTRAINT [DF_Users_ActiveDevices_ActiveTime]  DEFAULT (getdate()) FOR [ActiveTime]
GO
ALTER TABLE [dbo].[Users_ProfileAttributes_Dict] ADD  CONSTRAINT [DF_Users_ProfileAttributes_Dict_SortIndex]  DEFAULT ((1)) FOR [SortIndex]
GO
ALTER TABLE [dbo].[Users_ProfileLocations] ADD  CONSTRAINT [DF_Global_ProfileLocations_LocationLevel]  DEFAULT ((1)) FOR [LocationLevel]
GO
ALTER TABLE [dbo].[Users_ProfileLocations] ADD  CONSTRAINT [DF_ProfileLocations_ParentID]  DEFAULT ((0)) FOR [ParentID]
GO
ALTER TABLE [dbo].[Users_ProfileVerification] ADD  CONSTRAINT [DF_Users_VerifyOrders_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Users_SecureConfig] ADD  CONSTRAINT [DF_Users_SecureConfig_MinAmount]  DEFAULT ((0)) FOR [MinAmount]
GO
ALTER TABLE [dbo].[Users_SecureConfig] ADD  CONSTRAINT [DF_Users_SecureConfig_Status]  DEFAULT ((1)) FOR [SecureStatus]
GO
ALTER TABLE [dbo].[Users_SecureConfig] ADD  CONSTRAINT [DF_Users_SecureConfig_ModifiedTime]  DEFAULT (getdate()) FOR [ModifiedTime]
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD  CONSTRAINT [CK_Accounts_Balance] CHECK  (([Balance]>=(0)))
GO
ALTER TABLE [dbo].[Accounts] CHECK CONSTRAINT [CK_Accounts_Balance]
GO
ALTER TABLE [dbo].[Accounts_System]  WITH CHECK ADD  CONSTRAINT [CK_Accounts_System_Balance] CHECK  (([Balance]>=(0)))
GO
ALTER TABLE [dbo].[Accounts_System] CHECK CONSTRAINT [CK_Accounts_System_Balance]
GO
USE [master]
GO
ALTER DATABASE [Wallet.Account] SET  READ_WRITE 
GO
```