# wUtility.Messaging

```sql
USE [master]
GO
/****** Object:  Database [wUtility.Messaging]    Script Date: 7/23/2020 3:20:44 PM ******/
CREATE DATABASE [wUtility.Messaging]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'wUtility.Messaging', FILENAME = N'D:\SQL DATA\wUtility.Messaging.mdf' , SIZE = 10MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB ),
FILEGROUP [SMS]
( NAME = N'wUtility.Messaging_Sms', FILENAME = N'D:\Database\2019\Mobipay\wUtility.Messaging_Sms.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB),
FILEGROUP [NOTIFICATION]
( NAME = N'wUtility.Messaging_Notification', FILENAME = N'D:\Database\2019\Mobipay\wUtility.Messaging_Notification.ndf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 100MB)
 LOG ON 
( NAME = N'wUtility.Messaging_log', FILENAME = N'D:\SQL DATA\wUtility.Messaging_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [wUtility.Messaging] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [wUtility.Messaging].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [wUtility.Messaging] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET ARITHABORT OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [wUtility.Messaging] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [wUtility.Messaging] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET  DISABLE_BROKER 
GO
ALTER DATABASE [wUtility.Messaging] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [wUtility.Messaging] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [wUtility.Messaging] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET RECOVERY FULL 
GO
ALTER DATABASE [wUtility.Messaging] SET  MULTI_USER 
GO
ALTER DATABASE [wUtility.Messaging] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [wUtility.Messaging] SET DB_CHAINING OFF 
GO
ALTER DATABASE [wUtility.Messaging] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [wUtility.Messaging] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [wUtility.Messaging] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'wUtility.Messaging', N'ON'
GO
ALTER DATABASE [wUtility.Messaging] SET QUERY_STORE = OFF
GO
USE [wUtility.Messaging]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
--USE [wUtility.Messaging]
--GO
--/****** Object:  User [dev_ewallet]    Script Date: 7/23/2020 3:20:44 PM ******/
--CREATE USER [dev_ewallet] FOR LOGIN [dev_ewallet] WITH DEFAULT_SCHEMA=[dbo]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [dev_ewallet]
--GO
/****** Object:  UserDefinedFunction [dbo].[DateTimeToUnixTime]    Script Date: 7/23/2020 3:20:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DateTimeToUnixTime] (
@ctimestamp datetime
)
RETURNS BIGINT
AS
BEGIN
  /* Function body */
  declare @return BIGINT

  SELECT @return = DATEDIFF(SECOND,{d '1970-01-01'}, @ctimestamp)

  return @return
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_ValidateEmail]    Script Date: 7/23/2020 3:20:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[udf_ValidateEmail] (@email varChar(255))

RETURNS bit
AS
begin
return
(
select 
	Case 
		When 	@Email is null then 0	                	--NULL Email is invalid
		When	charindex(' ', @email) 	<> 0 or		--Check for invalid character
				charindex('/', @email) 	<> 0 or --Check for invalid character
				charindex(':', @email) 	<> 0 or --Check for invalid character
				charindex(';', @email) 	<> 0 then 0 --Check for invalid character
		When len(@Email)-1 <= charindex('.', @Email) then 0--check for '%._' at end of string
		When 	@Email like '%@%@%'or 
				@Email Not Like '%@%.%'  then 0--Check for duplicate @ or invalid format
		WHEN @Email NOT LIKE '%_@_%_.__%' THEN 0
		Else 1
	END
)
end
GO
/****** Object:  UserDefinedFunction [dbo].[UnixTimeToDateTime]    Script Date: 7/23/2020 3:20:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UnixTimeToDateTime] (@Datetime BIGINT)
RETURNS DATETIME
AS
BEGIN
    --DECLARE @LocalTimeOffset BIGINT
    --       ,@AdjustedLocalDatetime BIGINT;
    --SET @LocalTimeOffset = DATEDIFF(second,GETDATE(),GETUTCDATE())
    --SET @AdjustedLocalDatetime = @Datetime - @LocalTimeOffset
    RETURN (SELECT DATEADD(second,@Datetime, CAST('1970-01-01 00:00:00' AS datetime)))
END;
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 7/23/2020 3:20:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ErrorLogID] [int] IDENTITY(1,1) NOT NULL,
	[ErrorTime] [datetime] NOT NULL,
	[UserName] [nvarchar](128) NOT NULL,
	[HostName] [nvarchar](200) NULL,
	[ErrorNumber] [int] NOT NULL,
	[ErrorCode] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorProcedure] [nvarchar](126) NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [nvarchar](4000) NOT NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED 
(
	[ErrorLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogSendMails]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogSendMails](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[FromName] [varchar](150) NULL,
	[ServiceID] [int] NULL,
	[FromEmail] [nvarchar](150) NULL,
	[ToEmail] [nvarchar](150) NULL,
	[Subjects] [nvarchar](max) NULL,
	[Messages] [nvarchar](max) NULL,
	[Status] [int] NULL,
	[CreatedTime] [datetime] NOT NULL,
	[CreatedUnixTime] [int] NOT NULL,
	[SendTime] [datetime] NULL,
	[SendUnixTime] [int] NULL,
	[IsResend] [bit] NOT NULL,
 CONSTRAINT [PK_LogSendMails] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [SMS]
) ON [SMS] TEXTIMAGE_ON [SMS]
GO
/****** Object:  Table [dbo].[LogSendSMS]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogSendSMS](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[FromName] [varchar](50) NULL,
	[Mobile] [varchar](50) NOT NULL,
	[ServiceID] [int] NOT NULL,
	[IsResend] [bit] NOT NULL,
	[Messsage] [varchar](200) NOT NULL,
	[Status] [int] NULL,
	[CreatedTime] [datetime] NOT NULL,
	[CreatedUnixTime] [int] NOT NULL,
	[SendTime] [datetime] NULL,
	[SendUnixTime] [int] NULL,
	[Type] [tinyint] NOT NULL,
 CONSTRAINT [PK_LogSendSMS] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [SMS]
) ON [SMS]
GO
/****** Object:  Table [dbo].[LogSMS_MOMT]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogSMS_MOMT](
	[LogID] [bigint] IDENTITY(1,1) NOT NULL,
	[FromName] [varchar](50) NULL,
	[Mobile] [varchar](50) NOT NULL,
	[ServiceNumber] [varchar](50) NOT NULL,
	[CommandCode] [varchar](50) NULL,
	[MO_Message] [varchar](200) NOT NULL,
	[RequestID] [varchar](30) NULL,
	[IsStatusErr] [bit] NOT NULL,
	[MT_Message] [varchar](200) NULL,
	[ReceiveTime] [datetime] NOT NULL,
	[ReceiveUnixTime] [int] NOT NULL,
	[SendTime] [datetime] NULL,
	[SendUnixTime] [int] NULL,
	[DescriptionErr] [nvarchar](250) NULL,
 CONSTRAINT [PK_LogReceiveSMS] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [SMS]
) ON [SMS]
GO
/****** Object:  Table [dbo].[Notification_Messages]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notification_Messages](
	[NotifyID] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](150) NOT NULL,
	[Message] [nvarchar](1500) NOT NULL,
	[Status] [tinyint] NULL,
	[NotifyType] [tinyint] NOT NULL,
	[TargetType] [tinyint] NOT NULL,
	[TargetID] [varchar](50) NULL,
	[Images] [varchar](500) NULL,
	[DeviceType] [tinyint] NOT NULL,
	[AppliedTime] [datetime] NOT NULL,
	[ExpireTime] [datetime] NULL,
	[AppliedUser] [varchar](30) NULL,
	[AppliedDevice] [nvarchar](500) NULL,
	[CreatedUser] [varchar](30) NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Notification_Messages] PRIMARY KEY CLUSTERED 
(
	[NotifyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [NOTIFICATION]
) ON [NOTIFICATION]
GO
/****** Object:  Table [dbo].[Notification_UnappliedReaders]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notification_UnappliedReaders](
	[NotifyID] [bigint] NOT NULL,
	[ReadUser] [varchar](30) NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Notification_UnappliedReaders] PRIMARY KEY CLUSTERED 
(
	[NotifyID] ASC,
	[ReadUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [NOTIFICATION]
) ON [NOTIFICATION]
GO
/****** Object:  Table [dbo].[Notification_UserDevices]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notification_UserDevices](
	[Username] [varchar](20) NOT NULL,
	[DeviceID] [varchar](100) NOT NULL,
	[DeviceToken] [varchar](500) NOT NULL,
	[DeviceType] [tinyint] NOT NULL,
	[Status] [int] NOT NULL,
	[ExNotifyID] [bigint] NOT NULL,
	[UpdateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Notify_Devices] PRIMARY KEY CLUSTERED 
(
	[Username] ASC,
	[DeviceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [NOTIFICATION]
) ON [NOTIFICATION]
GO
/****** Object:  Table [dbo].[Services]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services](
	[ServiceID] [int] NOT NULL,
	[ServiceName] [nvarchar](150) NULL,
	[CreatedTime] [datetime] NOT NULL,
	[ParentServiceID] [int] NOT NULL,
	[System] [varchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
 CONSTRAINT [PK_Services] PRIMARY KEY CLUSTERED 
(
	[ServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogSendMails] ADD  CONSTRAINT [DF_LogSendMails_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[LogSendMails] ADD  CONSTRAINT [DF_LogSendMails_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[LogSendMails] ADD  CONSTRAINT [DF_LogSendMails_CreatedUnixTime]  DEFAULT ((0)) FOR [CreatedUnixTime]
GO
ALTER TABLE [dbo].[LogSendMails] ADD  CONSTRAINT [DF_LogSendMails_IsResend]  DEFAULT ((0)) FOR [IsResend]
GO
ALTER TABLE [dbo].[LogSendSMS] ADD  CONSTRAINT [DF_LogSendSMS_IsResend]  DEFAULT ((0)) FOR [IsResend]
GO
ALTER TABLE [dbo].[LogSendSMS] ADD  CONSTRAINT [DF_LogSendSMS_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[LogSendSMS] ADD  CONSTRAINT [DF_LogSendSMS_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[LogSendSMS] ADD  CONSTRAINT [DF_LogSendSMS_CreatedUnixTime]  DEFAULT ([dbo].[DateTimeToUnixTime](getdate())) FOR [CreatedUnixTime]
GO
ALTER TABLE [dbo].[LogSendSMS] ADD  CONSTRAINT [DF_LogSendSMS_Type]  DEFAULT ((0)) FOR [Type]
GO
ALTER TABLE [dbo].[LogSMS_MOMT] ADD  CONSTRAINT [DF_Table_1_Status]  DEFAULT ((0)) FOR [IsStatusErr]
GO
ALTER TABLE [dbo].[LogSMS_MOMT] ADD  CONSTRAINT [DF_LogReceiveSMS_CreatedTime]  DEFAULT (getdate()) FOR [ReceiveTime]
GO
ALTER TABLE [dbo].[Notification_Messages] ADD  CONSTRAINT [DF_Notify_Contents_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Services] ADD  CONSTRAINT [DF_Services_CreatedTime]  DEFAULT (getdate()) FOR [CreatedTime]
GO
ALTER TABLE [dbo].[Services] ADD  CONSTRAINT [DF_Services_ParentServiceID]  DEFAULT ((0)) FOR [ParentServiceID]
GO
/****** Object:  StoredProcedure [dbo].[SP_CheckQuotaSendSMS]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_CheckQuotaSendSMS]
	@_ServiceID INT,
	@_Mobile VARCHAR(50),
	@_IsResend BIT = 0,
	@_CountSMSInDay INT = 0 OUTPUT,--tổng số SMS 1 ngày/1 dịch vụ
	@_ResponseStatus INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @_ERR_OVER_QUOTA INT = -5, -- vượt quá quota số lần gửi tự động miễn phí
			@_ERR_SENDING_SMS INT = -4, --2 tin sms gửi lại phải cách nhau 30s
			@_RESPONSE_SUCCESS INT = 1

	SET @_ResponseStatus = @_RESPONSE_SUCCESS;
	SET @_IsResend = ISNULL(@_IsResend, 0);
	--Neu  OTP kich hoat thì chỉ đc gửi 1 lần duy nhất
	IF(@_ServiceID = 10001 AND @_IsResend = 0 AND EXISTS(SELECT 1 FROM [dbo].[LogSendSMS] WHERE ServiceID = @_ServiceID AND Mobile = @_Mobile))
	BEGIN
		SET @_ResponseStatus = @_ERR_OVER_QUOTA; --vuot quota 1 ngay / 1lan free
		RETURN;
	END

	IF (@_IsResend = 1 AND EXISTS(SELECT 1 FROM [dbo].[LogSendSMS] WHERE IsResend = 1 AND ServiceID = @_ServiceID AND Mobile = @_Mobile AND CreatedUnixTime >= [dbo].[DateTimeToUnixTime](GETDATE()) - 60))
	BEGIN
		SET @_ResponseStatus = @_ERR_SENDING_SMS
		RETURN
	END

	SELECT @_CountSMSInDay = COUNT(LogID)
	FROM [dbo].[LogSendSMS] 
	WHERE ServiceID = @_ServiceID AND Mobile = @_Mobile AND IsResend = @_IsResend AND CreatedUnixTime >= [dbo].[DateTimeToUnixTime](CAST(GETDATE() AS DATE))

	
	--IF(@_ServiceID = 10007 AND @_CountSMSInDay > 5 AND @_IsResend = 0) -- Neu la OTP Thanh toán chỉ tự đông gửi 5 tin/ngày
	--BEGIN
	--	SET @_ResponseStatus = @_ERR_OVER_QUOTA; 
	--	RETURN;
	--END
	--ELSE IF(@_ServiceID <> 10007 AND @_CountSMSInDay > 1 AND @_IsResend = 0) --OTP # > Kiem tra xem trong 24h da gui tu dong lan nao chua
	--BEGIN
	--	SET @_ResponseStatus = @_ERR_OVER_QUOTA; 
	--	RETURN;
	--END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_LogError]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 01/05/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_LogError] 
    @ErrorCode int = 0 OUTPUT 
AS                               
BEGIN
   SET NOCOUNT ON;
   SET @ErrorCode = 0;

   BEGIN TRY
		IF ERROR_NUMBER() IS NULL   RETURN;
		IF XACT_STATE() = -1
			BEGIN
				PRINT 'Cannot log error since the current transaction is in an uncommittable state. ' 
				+ 'Rollback the transaction before executing SP_LogError in order to successfully log error information.';
				RETURN;
			END
		SET @ErrorCode = ERROR_NUMBER();
		IF @ErrorCode > 0 SET @ErrorCode = 0 - @ErrorCode;

		INSERT INTO [dbo].[ErrorLog]
				   ([ErrorTime]
				   ,[UserName]
				   ,[HostName]
				   ,[ErrorNumber]
				   ,[ErrorCode]
				   ,[ErrorSeverity]
				   ,[ErrorState]
				   ,[ErrorProcedure]
				   ,[ErrorLine]
				   ,[ErrorMessage])
			 VALUES
				   (GETDATE()
				   ,CONVERT(sysname, CURRENT_USER)
				   ,HOST_NAME()
				   ,ERROR_NUMBER()
				   ,@ErrorCode
				   ,ERROR_SEVERITY()
				   ,ERROR_STATE()
				   ,ERROR_PROCEDURE()
				   ,ERROR_LINE()
				   ,ERROR_MESSAGE())
	END TRY
	BEGIN CATCH
		PRINT 'An error occurred in stored procedure SP_LogError: ';
		EXECUTE [dbo].[SP_LogErrorPrint];
		RETURN -1;
	END CATCH
END;






GO
/****** Object:  StoredProcedure [dbo].[SP_LogErrorPrint]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- SP_PrintError prints error information about the error that caused 
-- execution to jump to the CATCH block of a TRY...CATCH construct. 
-- Should be executed from within the scope of a CATCH block otherwise 
-- it will return without printing any error information.
CREATE PROCEDURE    [dbo].[SP_LogErrorPrint] 
AS
BEGIN
    SET NOCOUNT ON;

    -- Print error information. 
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', State ' + CONVERT(varchar(5), ERROR_STATE()) + 
          ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') + 
          ', Line ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END;






GO
/****** Object:  StoredProcedure [dbo].[SP_Mail_Insert]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Mail_Insert]
	@_ServiceID INT,
	@_FromName	VARCHAR(150),
	@_FromEmail  NVARCHAR(150),
	@_ToEmail  NVARCHAR(150),
	@_Subjects  NVARCHAR(1000),
	@_Messages  NVARCHAR(max),
	@_IsResend BIT = 0,
	@_ResponseStatus BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOT_EXIST_SERVICE INT = -1,
			@_ERR_FROMEMAIL_INVALID INT = -2,
			@_ERR_TOEMAIL_INVALID INT = -3,
			@_ERR_SENDING_MAIL INT = -4,
			@_ERR_UNKNOWN INT = -99,
			@_ERR_DATA_INVALID INT = -600,
			@_MaxCreatedDate INT,
			@_IsResendIx BIT
	IF(ISNULL(@_ServiceID,0) = 0 
		OR ISNULL(@_FromEmail,'') = ''
		OR ISNULL(@_ToEmail,'') = '' 
		OR ISNULL(@_Subjects,'') = ''
		OR ISNULL(@_Messages,'') = '')
	BEGIN
		SET @_ResponseStatus = @_ERR_DATA_INVALID
		RETURN
	END

	--Kiem tra dinh dang email
	IF([dbo].[udf_ValidateEmail](@_FromEmail) = 0)
	BEGIN
		SET @_ResponseStatus = @_ERR_FROMEMAIL_INVALID;
		RETURN;
	END

	IF([dbo].[udf_ValidateEmail](@_ToEmail) = 0)
	BEGIN
		SET @_ResponseStatus = @_ERR_TOEMAIL_INVALID;
		RETURN;
	END


	IF(NOT EXISTS(SELECT 1 FROM [dbo].[Services] WHERE [ServiceID] = @_ServiceID))
	BEGIN
		SET @_ResponseStatus = @_ERR_NOT_EXIST_SERVICE
		RETURN
	END

	-- Kiem tra 2 email gui cung 1 service phai cach nhau it nhat 30s
	SELECT TOP(1) @_MaxCreatedDate = CreatedUnixTime, @_IsResendIx = IsResend
	FROM [dbo].[LogSendMails] 
	WHERE ToEmail = @_ToEmail AND ServiceID = @_ServiceID
	ORDER BY LogID DESC

	IF (@_MaxCreatedDate IS NOT NULL 
		AND (@_IsResendIx = @_IsResend AND @_MaxCreatedDate >= [dbo].[DateTimeToUnixTime](GETDATE()) - 30))
	BEGIN
		SET @_ResponseStatus = @_ERR_SENDING_MAIL
		RETURN
	END

	BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO [dbo].[LogSendMails]
				   ([ServiceID]
				   ,[FromName]
				   ,[FromEmail]
				   ,[ToEmail]
				   ,[Subjects]
				   ,[Messages]
				   ,[CreatedTime]
				   ,[CreatedUnixTime]
				   ,[IsResend])
			 VALUES
				   (@_ServiceID
				   ,@_FromName
				   ,@_FromEmail
				   ,@_ToEmail
				   ,@_Subjects
				   ,@_Messages
				   ,GETDATE()
				   ,[dbo].DateTimeToUnixTime(GETDATE())
				   ,@_IsResend)
			SET @_ResponseStatus =@@IDENTITY
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = @_ERR_UNKNOWN;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;	
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Mail_UpdateStatus]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Mail_UpdateStatus]
	@_LogID BIGINT,
	@_Status INT, --0:khoi tao, 1:send thanh cong, -1:send that bai
	@_ResponseStatus BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOT_EXIST_LOG INT = -1,
			@_ERR_UNKNOWN INT = -99,
			@_ERR_DATA_INVALID INT = -600

	IF(ISNULL(@_LogID,0) = 0 OR @_Status IS NULL)
	BEGIN 
		SET @_ResponseStatus = @_ERR_DATA_INVALID;
		RETURN;
	END
	IF (NOT EXISTS(SELECT 1 FROM [dbo].[LogSendMails] WHERE LogID = @_LogID))
	BEGIN
		SET @_ResponseStatus = @_ERR_NOT_EXIST_LOG;
		RETURN;
	END
	BEGIN TRANSACTION
		BEGIN TRY
			UPDATE [dbo].[LogSendMails]
			SET  [Status] = @_Status,
				[SendTime] = GETDATE(),
				[SendUnixTime] = [dbo].[DateTimeToUnixTime](GETDATE())
			WHERE [LogID] = @_LogID
	
			SET @_ResponseStatus = @_LogID
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = @_ERR_UNKNOWN;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;	
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SMS_Insert]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SMS_Insert]
	@_ServiceID INT,
	@_FromName	VARCHAR(150),
	@_Mobile  VARCHAR(50),
	@_Messages  NVARCHAR(200),
	@_IsResend BIT = 0,
	@_CountSMSInDay INT = 0 OUT, --Số lần gửi SMS theo dịch vụ
	@_ResponseStatus BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOT_EXIST_SERVICE INT = -1,
			@_ERR_MOBILE_INVALID INT = -2,
			--@_ERR_SENDING_SMS INT = -4,
			--@_ERR_OVER_QUOTA INT = -5,
			@_ERR_UNKNOWN INT = -99,
			@_ERR_DATA_INVALID INT = -600
	IF(ISNULL(@_ServiceID,0) = 0 
		OR ISNULL(@_Mobile,'') = ''
		OR ISNULL(@_Messages,'') = '')
	BEGIN
		SET @_ResponseStatus = @_ERR_DATA_INVALID
		RETURN
	END

	--Kiem tra dinh dang mobile
	IF (LEFT(@_Mobile, 1) = '0')
	BEGIN
		SET @_Mobile = '84' + SUBSTRING(@_Mobile, 2, LEN(@_Mobile) - 1);
	END
	ELSE IF(LEFT(@_Mobile, 2) <> '84')
	BEGIN
		SET @_ResponseStatus = @_ERR_MOBILE_INVALID
		RETURN;
	END

	IF (Len(@_Mobile) < 11 OR Len(@_Mobile) > 12)
	BEGIN
		SET @_ResponseStatus = @_ERR_MOBILE_INVALID
		RETURN;
	END	  

	IF(NOT EXISTS(SELECT 1 FROM [dbo].[Services] WHERE [ServiceID] = @_ServiceID))
	BEGIN
		SET @_ResponseStatus = @_ERR_NOT_EXIST_SERVICE
		RETURN
	END
	--Kiem tra quota send sms
	--EXEC dbo.SP_CheckQuotaSendSMS
	--@_ServiceID = @_ServiceID,
	--@_Mobile = @_Mobile,
	--@_IsResend = @_IsResend,
	--@_CountSMSInDay = @_CountSMSInDay OUT,
	--@_ResponseStatus = @_ResponseStatus OUT

	IF(@_ResponseStatus < 0) 
	BEGIN
		RETURN;
	END

	BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO [dbo].[LogSendSMS]
				   ([ServiceID]
				   ,[FromName]
				   ,[Mobile]
				   ,[Messsage]
				   ,[CreatedTime]
				   ,[CreatedUnixTime]
				   ,[IsResend])
			 VALUES
				   (@_ServiceID
				   ,@_FromName
				   ,@_Mobile
				   ,@_Messages
				   ,GETDATE()
				   ,[dbo].DateTimeToUnixTime(GETDATE())
				   ,@_IsResend)
			SET @_ResponseStatus =@@IDENTITY
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = @_ERR_UNKNOWN;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;	
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SMS_MOMT_InsertMO]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SMS_MOMT_InsertMO]
	@_FromName	VARCHAR(150),
	@_Mobile  VARCHAR(50),
	@_ServiceNumber VARCHAR(50),
	@_CommandCode VARCHAR(50) = NULL,
	@_MO_Message VARCHAR(200), --Nội dung tin MO đến
	@_RequestID VARCHAR(30) = '', --Mã referenceID
	@_IsStatusErr BIT = 0, --0: bthg, 1: có lỗi
	@_ResponseStatus BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_DUPLICATE_REQUESTID INT = -1,
			@_ERR_MOBILE_INVALID INT = -2,
			@_ERR_UNKNOWN INT = -99,
			@_ERR_DATA_INVALID INT = -600,
			@_MaxCreatedDate INT
			
	SET @_Mobile = ISNULL(@_Mobile,'')
	SET @_ServiceNumber = ISNULL(@_ServiceNumber,'')
	SET @_CommandCode = ISNULL(@_CommandCode,'')
	SET @_MO_Message = ISNULL(@_MO_Message,'')
	SET @_RequestID = ISNULL(@_RequestID,'')

	IF(ISNULL(@_ServiceNumber,'') = ''
		OR ISNULL(@_Mobile,'') = ''
		OR ISNULL(@_MO_Message,'') = '')
	BEGIN
		SET @_ResponseStatus = @_ERR_DATA_INVALID
		RETURN
	END

	--Kiem tra dinh dang mobile
	IF (LEFT(@_Mobile, 1) = '0')
	BEGIN
		SET @_Mobile = '84' + SUBSTRING(@_Mobile, 2, LEN(@_Mobile) - 1);
	END
	ELSE IF(LEFT(@_Mobile, 2) <> '84')
	BEGIN
		SET @_ResponseStatus = @_ERR_MOBILE_INVALID
		RETURN;
	END

	IF (Len(@_Mobile) < 11 OR Len(@_Mobile) > 12)
	BEGIN
		SET @_ResponseStatus = @_ERR_MOBILE_INVALID
		RETURN;
	END	  

	IF(@_RequestID <> '' AND EXISTS(SELECT 1 FROM [dbo].[LogSMS_MOMT] WHERE RequestID = @_RequestID))
	BEGIN
		SET @_ResponseStatus = @_ERR_DUPLICATE_REQUESTID
		RETURN;
	END

	BEGIN TRANSACTION
		BEGIN TRY
		--Ghi log
			INSERT INTO [dbo].[LogSMS_MOMT]
				   ([FromName]
				   ,[Mobile]
				   ,[ServiceNumber]
				   ,[CommandCode]
				   ,[MO_Message]
				   ,[RequestID]
				   ,[IsStatusErr]
				   ,[ReceiveTime]
				   ,[ReceiveUnixTime])
			 VALUES
				   (@_FromName
				   ,@_Mobile
				   ,@_ServiceNumber
				   ,@_CommandCode
				   ,@_MO_Message
				   ,@_RequestID
				   ,@_IsStatusErr
				   ,GETDATE()
				   ,[dbo].DateTimeToUnixTime(GETDATE())
				   )
			SET @_ResponseStatus =@@IDENTITY
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = @_ERR_UNKNOWN;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;	
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SMS_MOMT_InsertMT]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SMS_MOMT_InsertMT]
	@_LogID BIGINT,
	@_MT_Message VARCHAR(200), --Nội dung tin MT gửi đi
	@_IsStatusErr BIT = 0, --0: bthg, 1: có lỗi
	@_DescriptionErr NVARCHAR(250) = '',
	@_ResponseStatus BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_LOGID_NOT_EXISTS INT = -1,
			@_ERR_UNKNOWN INT = -99,
			@_ERR_DATA_INVALID INT = -600
			
	SET @_LogID = ISNULL(@_LogID,0)
	SET @_MT_Message = ISNULL(@_MT_Message,'')
	SET @_DescriptionErr = ISNULL(@_DescriptionErr,'')

	IF(@_LogID = 0 OR @_MT_Message = '')
	BEGIN
		SET @_ResponseStatus = @_ERR_DATA_INVALID
		RETURN
	END

	IF(NOT EXISTS(SELECT 1 FROM [dbo].[LogSMS_MOMT] WHERE LogID = @_LogID))
	BEGIN
		SET @_ResponseStatus = @_ERR_LOGID_NOT_EXISTS
		RETURN;
	END

	BEGIN TRANSACTION
		BEGIN TRY
			--Ghi log
			UPDATE [dbo].[LogSMS_MOMT] 
			SET MT_Message = CASE WHEN @_MT_Message = '' THEN MT_Message ELSE @_MT_Message END,
				IsStatusErr = @_IsStatusErr,
				DescriptionErr = CASE WHEN @_DescriptionErr = '' THEN DescriptionErr ELSE @_DescriptionErr END,
				SendTime = GETDATE(),
				SendUnixTime = [dbo].DateTimeToUnixTime(GETDATE())
			WHERE LogID = @_LogID

			SET @_ResponseStatus =@@IDENTITY
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = @_ERR_UNKNOWN;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;	
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SMS_UpdateStatus]    Script Date: 7/23/2020 3:20:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_SMS_UpdateStatus]
	@_LogID BIGINT,
	@_Status INT, --0:khoi tao, 1:send thanh cong, -1:send that bai
	@_ResponseStatus BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON
	DECLARE @_ERR_NOT_EXIST_LOG INT = -1,
			@_ERR_UNKNOWN INT = -99,
			@_ERR_DATA_INVALID INT = -600

	IF(ISNULL(@_LogID,0) = 0 OR @_Status IS NULL)
	BEGIN 
		SET @_ResponseStatus = @_ERR_DATA_INVALID;
		RETURN;
	END
	IF (NOT EXISTS(SELECT 1 FROM [dbo].[LogSendSMS] WHERE LogID = @_LogID))
	BEGIN
		SET @_ResponseStatus = @_ERR_NOT_EXIST_LOG;
		RETURN;
	END
	BEGIN TRANSACTION
		BEGIN TRY
			UPDATE [dbo].[LogSendSMS]
			SET  [Status] = @_Status,
				[SendTime] = GETDATE(),
				[SendUnixTime] = [dbo].[DateTimeToUnixTime](GETDATE())
			WHERE [LogID] = @_LogID
	
			SET @_ResponseStatus = @_LogID
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = @_ERR_UNKNOWN;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError]
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;	
	END CATCH; 
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0: tin chủ động MT, 1 : MO-MT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LogSendSMS', @level2type=N'COLUMN',@level2name=N'Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0: bình thường, 1: lỗi' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LogSMS_MOMT', @level2type=N'COLUMN',@level2name=N'IsStatusErr'
GO
USE [master]
GO
ALTER DATABASE [wUtility.Messaging] SET  READ_WRITE 
GO
```