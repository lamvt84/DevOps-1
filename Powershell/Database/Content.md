# wUtility.Content

```sql
USE [master]
GO
/****** Object:  Database [wUtility.Content]    Script Date: 7/23/2020 3:13:56 PM ******/
CREATE DATABASE [wUtility.Content]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'wUtility.Content', FILENAME = N'D:\SQL DATA\wUtility.Content.mdf' , SIZE = 50MB , MAXSIZE = UNLIMITED, FILEGROWTH = 50MB )
 LOG ON 
( NAME = N'wUtility.Content_log', FILENAME = N'D:\SQL DATA\wUtility.Content_log.ldf' , SIZE = 10MB , MAXSIZE = 2048GB , FILEGROWTH = 50MB )
GO
ALTER DATABASE [wUtility.Content] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [wUtility.Content].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [wUtility.Content] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [wUtility.Content] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [wUtility.Content] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [wUtility.Content] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [wUtility.Content] SET ARITHABORT OFF 
GO
ALTER DATABASE [wUtility.Content] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [wUtility.Content] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [wUtility.Content] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [wUtility.Content] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [wUtility.Content] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [wUtility.Content] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [wUtility.Content] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [wUtility.Content] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [wUtility.Content] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [wUtility.Content] SET  DISABLE_BROKER 
GO
ALTER DATABASE [wUtility.Content] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [wUtility.Content] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [wUtility.Content] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [wUtility.Content] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [wUtility.Content] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [wUtility.Content] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [wUtility.Content] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [wUtility.Content] SET RECOVERY FULL 
GO
ALTER DATABASE [wUtility.Content] SET  MULTI_USER 
GO
ALTER DATABASE [wUtility.Content] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [wUtility.Content] SET DB_CHAINING OFF 
GO
ALTER DATABASE [wUtility.Content] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [wUtility.Content] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [wUtility.Content] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'wUtility.Content', N'ON'
GO
ALTER DATABASE [wUtility.Content] SET QUERY_STORE = OFF
GO
USE [wUtility.Content]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
--USE [wUtility.Content]
--GO
--/****** Object:  User [wUtility.Content.cmsadmin]    Script Date: 7/23/2020 3:13:57 PM ******/
--CREATE USER [wUtility.Content.cmsadmin] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [wUtility.Content.app]    Script Date: 7/23/2020 3:13:57 PM ******/
--CREATE USER [wUtility.Content.app] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [dev_ewallet]    Script Date: 7/23/2020 3:13:57 PM ******/
--CREATE USER [dev_ewallet] FOR LOGIN [dev_ewallet] WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  User [cuongbx]    Script Date: 7/23/2020 3:13:57 PM ******/
--CREATE USER [cuongbx] FOR LOGIN [cuongbx] WITH DEFAULT_SCHEMA=[dbo]
--GO
--/****** Object:  DatabaseRole [exec_for_app]    Script Date: 7/23/2020 3:13:57 PM ******/
--CREATE ROLE [exec_for_app]
--GO
--ALTER ROLE [exec_for_app] ADD MEMBER [wUtility.Content.app]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [dev_ewallet]
--GO
/****** Object:  FullTextCatalog [article_ctlg]    Script Date: 7/23/2020 3:13:57 PM ******/
CREATE FULLTEXT CATALOG [article_ctlg] AS DEFAULT
GO
/****** Object:  FullTextStopList ArticleStopList    Script Date: 7/23/2020 3:13:57 PM ******/
CREATE FULLTEXT STOPLIST [ArticleStopList]
;
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetParentID]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<QuocPhong.Tran>
-- Create date: <07/31/2015>
-- Description:	<Lay FatherID theo FunctionID>
-- =============================================
CREATE FUNCTION [dbo].[FN_GetParentID]
(
	@_FunctionID int
)
RETURNS INT
AS

BEGIN
	DECLARE @_ParentID INT
	SELECT @_ParentID = ParentID FROM  dbo.Functions WHERE  FunctionID= @_FunctionID
	RETURN @_ParentID

END





GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetParentName]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<QuocPhong.Tran>
-- Create date: <07/31/2015>
-- Description:	<Lay Ten chuc nang cha theo @_FatherID>
-- =============================================
CREATE FUNCTION [dbo].[FN_GetParentName]
(
	-- Add the parameters for the function here
	@_ParentID int
)
RETURNS NVARCHAR(150)
AS
BEGIN
	DECLARE @_ParentName NVARCHAR(150)
	SELECT @_ParentName=[FunctionName] FROM dbo.Functions WHERE FunctionID=@_ParentID
	RETURN @_ParentName

END




GO
/****** Object:  UserDefinedFunction [dbo].[FN_Parameters_Split]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE FUNCTION [dbo].[FN_Parameters_Split]
    (@String NVARCHAR(MAX)
    ,@Delimiter NVARCHAR(10))
    
RETURNS @ValueTable TABLE ([Index] INT IDENTITY(1,1), [Value] NVARCHAR(1000))
BEGIN
    DECLARE @NextString NVARCHAR(MAX)
    DECLARE @Pos INT
   
    SET @String = @String + @Delimiter
	--Get position of first Comma
    SET @Pos = CHARINDEX(@Delimiter,@String)   
 
	--Loop while there is still a comma in the String of levels
    WHILE (@pos <> 0) 
        BEGIN
            SET @NextString = SUBSTRING(@String,1,@Pos - 1)
 
            INSERT  INTO @ValueTable
                    ([Value])
            VALUES  (LTRIM(RTRIM(@NextString)))
 
            SET @String = SUBSTRING(@String,@pos + 1,LEN(@String))  
            
            SET @pos = CHARINDEX(@Delimiter,@String)
        END
 
    RETURN
END






GO
/****** Object:  UserDefinedFunction [dbo].[FN_Parameters_SplitTable]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_Parameters_SplitTable]
    (@String NVARCHAR(MAX)
    ,@RowDelimiter NVARCHAR(10)
    ,@ColumnDelimiter NVARCHAR(10))
RETURNS @Table TABLE ([Index] INT IDENTITY, [Value1] NVARCHAR(200), [Value2] NVARCHAR(200), [Value3] NVARCHAR(200), [ValueN] NVARCHAR(200))
BEGIN
    
    DECLARE @Value NVARCHAR(1000);
    DECLARE CUR_SPLIT CURSOR FOR
    SELECT Value FROM dbo.FN_Parameters_Split(@String,@RowDelimiter);
    
    OPEN CUR_SPLIT
	FETCH NEXT FROM CUR_SPLIT INTO @Value
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @Index INT = 0;
		DECLARE @ValueIn NVARCHAR(200)='';
		DECLARE	@ColumnCount INT = 1;
		
		IF(ISNULL(@Value,'') <> '')
		BEGIN		
			WHILE (@ColumnCount <= (SELECT COUNT(*) FROM dbo.FN_Parameters_Split(@Value,@ColumnDelimiter)))
			BEGIN
				SELECT TOP 1 @ValueIn=Value FROM dbo.FN_Parameters_Split(@Value,@ColumnDelimiter) WHERE [Index] = @ColumnCount;
				
				IF(@ColumnCount = 1)
				BEGIN
					INSERT INTO @Table(Value1)VALUES(@ValueIn);
					SET @Index = @@IDENTITY;
				END
				ELSE IF (@ColumnCount = 1)
				BEGIN
					UPDATE @Table SET Value1 = @ValueIn WHERE [Index] = @Index;
				END
				ELSE IF (@ColumnCount = 2)
				BEGIN
					UPDATE @Table SET Value2 = @ValueIn WHERE [Index] = @Index;
				END
				ELSE IF (@ColumnCount = 3)
				BEGIN
					UPDATE @Table SET Value3 = @ValueIn WHERE [Index] = @Index;
				END
				ELSE BEGIN
					UPDATE @Table SET ValueN = ISNULL(ValueN,'') + CASE WHEN ISNULL(ValueN,'') <> '' THEN ';' ELSE '' END + @ValueIn
					WHERE [Index] = @Index;
				END
				
				SET @ColumnCount  = @ColumnCount + 1;
			END 
		END
		
		FETCH NEXT FROM CUR_SPLIT INTO @Value
	END
	
	CLOSE CUR_SPLIT;
	DEALLOCATE CUR_SPLIT;
	
	RETURN;
END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_Split]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_Split] 
(
 @Keyword NVARCHAR(4000),
 @Delimiter NVARCHAR(255)
)
RETURNS @SplitKeyword TABLE (Keyword NVARCHAR(4000))
AS
BEGIN
 DECLARE @Word NVARCHAR(255)
 DECLARE @TempKeyword TABLE (Keyword NVARCHAR(4000))

 WHILE (CHARINDEX(@Delimiter, @Keyword, 1)>0)
 BEGIN
  SET @Word = SUBSTRING(@Keyword, 1 , CHARINDEX(@Delimiter, @Keyword, 1) - 1)
  SET @Keyword = SUBSTRING(@Keyword, CHARINDEX(@Delimiter, @Keyword, 1) + 1, LEN(@Keyword))
  INSERT INTO @TempKeyword VALUES(@Word)
 END
 
 INSERT INTO @TempKeyword VALUES(@Keyword)
 
 INSERT @SplitKeyword
 SELECT * FROM @TempKeyword
 RETURN
END










GO
/****** Object:  Table [dbo].[BankAccountConfig]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankAccountConfig](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BankCode] [varchar](20) NOT NULL,
	[BankName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](150) NOT NULL,
	[BrandName] [nvarchar](100) NOT NULL,
	[BankNumber] [varchar](50) NOT NULL,
	[BankAccountHolder] [varchar](50) NOT NULL,
 CONSTRAINT [PK_BankAccountConfig] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Banner]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Banner](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](550) NOT NULL,
	[NewsId] [int] NULL,
	[TimeCreate] [datetime] NULL,
	[BannerOrder] [int] NULL,
	[ImageLink] [nvarchar](950) NULL,
	[ConnectLink] [varchar](950) NULL,
	[Status] [int] NULL,
	[Creator] [nvarchar](250) NULL,
	[Type] [int] NULL,
	[ParentProductId] [int] NULL,
 CONSTRAINT [PK_Banner] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 7/23/2020 3:13:57 PM ******/
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
/****** Object:  Table [dbo].[Languages]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Languages](
	[LanguageID] [int] NOT NULL,
	[LanguageCode] [varchar](10) NOT NULL,
	[Label] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsTag]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsTag](
	[NewId] [int] NOT NULL,
	[TagId] [int] NOT NULL,
	[TagContent] [nvarchar](max) NULL,
 CONSTRAINT [PK_NewsTag] PRIMARY KEY CLUSTERED 
(
	[NewId] ASC,
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tag]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tag](
	[TagId] [int] IDENTITY(1,1) NOT NULL,
	[SystemID] [int] NULL,
	[TagName] [nvarchar](250) NULL,
	[TagKey] [nvarchar](250) NULL,
	[Status] [bit] NULL,
	[CreatedUser] [varchar](40) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED 
(
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_ArticleDetail]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_ArticleDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ArticleID] [int] NOT NULL,
	[LanguageID] [tinyint] NOT NULL,
	[Title] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[ImageUrl] [varchar](250) NULL,
	[Content] [nvarchar](max) NULL,
	[Tags] [nvarchar](250) NULL,
	[Status] [tinyint] NULL,
	[UpdatedUser] [varchar](30) NULL,
	[UpdateDate] [datetime] NULL,
	[PublishDate] [datetime] NULL,
	[ContentSMS] [varchar](200) NULL,
	[Logo] [nvarchar](250) NULL,
 CONSTRAINT [PK_tbl_ArticleDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_ArticleLog]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_ArticleLog](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[ArticleId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[AccountName] [varchar](50) NULL,
	[ReferURL] [nvarchar](350) NULL,
	[ReferSite] [nvarchar](350) NULL,
	[DeviceType] [tinyint] NULL,
	[ClientIP] [varchar](30) NULL,
	[CreatedTime] [datetime] NULL,
	[CreatedDateInt] [int] NULL,
	[CreatedHour] [tinyint] NULL,
	[Browser] [varchar](20) NULL,
	[Operating] [varchar](20) NULL,
 CONSTRAINT [PK_tbl_ArticleLog] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Articles]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Articles](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Alias] [varchar](250) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedUser] [varchar](50) NOT NULL,
	[ViewCount] [int] NULL,
	[Type] [tinyint] NOT NULL,
	[NumLike] [int] NULL,
	[NumComment] [int] NULL,
	[MainCateID] [int] NULL,
	[TypeTargetID] [int] NULL,
 CONSTRAINT [PK_tbl_Articles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Articles2Cate]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Articles2Cate](
	[CateId] [int] NOT NULL,
	[ArticleId] [bigint] NOT NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_tbl_Articles2Cate] PRIMARY KEY CLUSTERED 
(
	[CateId] ASC,
	[ArticleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Category]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentID] [int] NULL,
	[Alias] [nvarchar](250) NULL,
	[OrderNo] [int] NULL,
	[Status] [bit] NULL,
	[CreatedUser] [varchar](50) NULL,
	[ModifyUser] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifyDate] [datetime] NULL,
	[SystemID] [int] NULL,
	[ImageUrl] [varchar](250) NULL,
 CONSTRAINT [PK_tbl_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_CategoryContent]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_CategoryContent](
	[CategoryID] [int] NOT NULL,
	[LanguageID] [int] NOT NULL,
	[CategoryName] [nvarchar](50) NULL,
	[Tags] [nvarchar](250) NULL,
	[CategoryContent] [nvarchar](500) NULL,
 CONSTRAINT [PK_tbl_CategoryContent] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC,
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_System]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_System](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemName] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_System] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_NonClustered_ArticlesDetail]    Script Date: 7/23/2020 3:13:57 PM ******/
CREATE NONCLUSTERED INDEX [IX_NonClustered_ArticlesDetail] ON [dbo].[tbl_ArticleDetail]
(
	[UpdateDate] ASC,
	[PublishDate] ASC,
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UIX_ArticleDetailUnique]    Script Date: 7/23/2020 3:13:57 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UIX_ArticleDetailUnique] ON [dbo].[tbl_ArticleDetail]
(
	[ArticleID] ASC,
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_NonClustered_Articles]    Script Date: 7/23/2020 3:13:57 PM ******/
CREATE NONCLUSTERED INDEX [IX_NonClustered_Articles] ON [dbo].[tbl_Articles]
(
	[CreatedDate] ASC,
	[Type] ASC,
	[ViewCount] ASC,
	[MainCateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_NonClusterIDX_Article2Cate]    Script Date: 7/23/2020 3:13:57 PM ******/
CREATE NONCLUSTERED INDEX [IX_NonClusterIDX_Article2Cate] ON [dbo].[tbl_Articles2Cate]
(
	[SortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_NonClustered_Category]    Script Date: 7/23/2020 3:13:57 PM ******/
CREATE NONCLUSTERED INDEX [IX_NonClustered_Category] ON [dbo].[tbl_Category]
(
	[ParentID] ASC,
	[OrderNo] ASC,
	[Status] ASC,
	[SystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Banner] ADD  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[tbl_Articles] ADD  CONSTRAINT [DF__tbl_Articl__Type__4CA06362]  DEFAULT ((0)) FOR [Type]
GO
ALTER TABLE [dbo].[tbl_Articles] ADD  CONSTRAINT [DF__tbl_Artic__NumLi__4D94879B]  DEFAULT ((0)) FOR [NumLike]
GO
ALTER TABLE [dbo].[tbl_Articles] ADD  CONSTRAINT [DF__tbl_Artic__NumCo__4E88ABD4]  DEFAULT ((0)) FOR [NumComment]
GO
ALTER TABLE [dbo].[tbl_Articles] ADD  CONSTRAINT [DF_tbl_Articles_MainCateID]  DEFAULT ((0)) FOR [MainCateID]
GO
ALTER TABLE [dbo].[tbl_Category] ADD  CONSTRAINT [DF_tbl_Category_OrderNo]  DEFAULT ((0)) FOR [OrderNo]
GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_Delete]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Articles_Delete]
	@_Id INT,
	@_Username   varchar(50) = '',
	--
	@_ResponseStatus int output
AS
BEGIN
	SET NOCOUNT ON;
	SET NOCOUNT, XACT_ABORT ON;
   DECLARE @_ERR_ARTICLES_INACTIVE INT = -24,
			@_ERR_ARTICLES_NOT_EXIST INT = -25
			
	IF EXISTS (SELECT * FROM tbl_ArticleDetail WHERE ArticleID = @_Id AND [Status] > 0)
	BEGIN		
		SET @_ResponseStatus = @_ERR_ARTICLES_INACTIVE;
		RETURN;
	END
	IF(NOT EXISTS(SELECT * FROM [dbo].[tbl_Articles] WHERE Id = @_Id))
	BEGIN
		SET @_ResponseStatus = @_ERR_ARTICLES_NOT_EXIST;
		RETURN;
	END
	BEGIN TRANSACTION
	BEGIN TRY
		EXEC [dbo].[SP_Articles2Cate_DeleteByCondition] @_Article = @_Id

		DELETE FROM [dbo].[tbl_Articles]  WHERE Id  = @_Id 
		DELETE FROM dbo.tbl_ArticleDetail WHERE ArticleID=@_Id
		DELETE FROM dbo.[tbl_Articles] WHERE Id  = @_Id 
		SET @_ResponseStatus = 1;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = -99;
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
		-- Insert Log
		EXEC	[dbo].[sp_LogError]				
	END CATCH;
END




GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_GetByCondition]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Articles_GetByCondition]
	@_LanguageID INT = 1
	,@_NewsID INT = 0
	,@_Title NVARCHAR(250) = ''
	,@_Type INT = -1 --0:thuong, 1: mới, 2: hot
	,@_CategoryID INT
	,@_Status TINYINT = 99
	,@_FromDate DateTime = NULL
	,@_ToDate DateTime = NULL
	,@_TopCount INT = 20
	,@_TagId INT = -1
	,@_OrderType INT = 1 -- 1:sortorder, 2:publish date, 3:UpdateDate, 4:view count
AS
BEGIN
	SET NOCOUNT ON;
	SET @_OrderType = ISNULL(@_OrderType, 1)
		IF (ISNULL(@_NewsID,0) > 0)
		BEGIN
			SELECT N.Id, N.Alias, N.MainCateID, ISNULL(ND.LanguageID,@_LanguageID) LanguageID, ISNULL(ND.Title,N.Alias) Title, ND.Description, ND.ImageUrl, ND.Tags,N.[Type], ND.[Status], ND.UpdatedUser, ND.UpdateDate, ND.PublishDate, ND.Content
			FROM tbl_Articles N 
			LEFT OUTER JOIN tbl_ArticleDetail ND ON N.Id = ND.ArticleID 
			WHERE N.Id = @_NewsID  AND ND.LanguageID = @_LanguageID
		END
		ELSE BEGIN
			SELECT TOP(ISNULL(@_TopCount,20)) A.* from (
				SELECT distinct ROW_NUMBER() OVER(ORDER BY A.Id DESC) AS STT,  A.Id, A.Alias, A.MainCateID, A.[Type], ISNULL(AD.LanguageID,@_LanguageID) LanguageID, ISNULL(AD.Title,A.Alias) Title, AD.Description, 
							ISNULL(AD.[Status],0) [Status], AD.ImageUrl, AD.Tags, AD.UpdatedUser, ISNULL(AD.UpdateDate, A.CreatedDate) UpdateDate, 
							ISNULL(AD.PublishDate, A.CreatedDate) PublishDate, '' Content, A.ViewCount,AC.SortOrder, AC.CateId
				FROM tbl_Articles A LEFT JOIN NewsTag NT ON A.Id = NT.[NewId]
				LEFT JOIN tbl_Articles2Cate AC ON A.Id = AC.ArticleId 
				LEFT JOIN tbl_ArticleDetail AD ON A.Id = AD.ArticleId
				WHERE (ISNULL(@_TagId, -1) = -1 OR (NT.TagId = @_TagId))
					  AND AD.LanguageID = @_LanguageID
					  AND AC.CateId = @_CategoryID
					  AND (ISNULL(@_Status,99) = 99 OR ISNULL(AD.[Status],0) = @_Status)
					  AND (ISNULL(@_Title,'') = '' OR Title LIKE N'%'+@_Title+N'%')
					  AND (ISNULL(@_Type,-1) = -1 OR A.[Type] = @_Type)
					  AND AD.PublishDate BETWEEN ISNULL(@_FromDate ,'2016-01-01 00:00:00') AND ISNULL(@_ToDate,GETDATE())
			)  a
			ORDER BY (CASE WHEN @_OrderType = 1 THEN SortOrder END),
			(CASE WHEN @_OrderType = 2 THEN PublishDate
				WHEN @_OrderType = 3 THEN UpdateDate
				ELSE ViewCount END) DESC
		END
END





GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_GetByPosition]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		cuongbx
-- Create date: 11/23/2016
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SP_Articles_GetByPosition]
	@_ArticleId INT 
	,@_CategoryId INT
	,@_LanguageId INT = 1
	,@_IsNext BIT = 0 OUT
	,@_IsPrev BIT = 0 OUT
AS
BEGIN
	SET @_IsNext = 0
	SET @_IsPrev = 0
	DECLARE @PrevNewsID INT = 0;
	DECLARE @NextNewsID INT = 0;
	DECLARE @CurrentOrder INT;
	DECLARE @NearOrder INT = 0;

	SELECT @CurrentOrder = SortOrder FROM tbl_Articles2Cate WHERE CateId = @_CategoryId AND ArticleId = @_ArticleId
	SET @CurrentOrder = ISNULL(@CurrentOrder,0)

	
	--next
	SELECT   TOP 1 @NextNewsID = ISNULL(ac.ArticleId,0)
	FROM tbl_Articles2Cate ac LEFT JOIN [dbo].[tbl_ArticleDetail] ad ON ac.ArticleId = ad.ArticleID
	WHERE ac.SortOrder > @CurrentOrder 
		AND ac.CateId = @_CategoryId 
		AND ad.[Status] = 1 
		AND ad.LanguageID = ISNULL(@_LanguageId,1)
	ORDER BY SortOrder	

	--preview
	SELECT   TOP 1 @PrevNewsID = ISNULL(ac.ArticleId,0)
	FROM tbl_Articles2Cate ac LEFT JOIN [dbo].[tbl_ArticleDetail] ad ON ac.ArticleId = ad.ArticleID
	WHERE SortOrder < @CurrentOrder 
		AND CateId = @_CategoryId 
		AND ad.[Status] = 1
		AND ad.LanguageID = ISNULL(@_LanguageId,1)
	ORDER BY SortOrder DESC
	
	IF (@NextNewsID > 0)
		SET @_IsNext = 1;
	
	IF (@PrevNewsID > 0)
		SET @_IsPrev = 1;


	SELECT A.Id, A.Alias, A.MainCateID, A.[Type], 
	case A.Id WHEN @NextNewsID THEN 1 
			  WHEN @PrevNewsID THEN 2
			  END Position
	FROM tbl_Articles A 
	WHERE ((ISNULL(@NextNewsID,0) = 0 OR A.Id = @NextNewsID)
	OR (ISNULL(@PrevNewsID,0) = 0 OR A.Id = @PrevNewsID))
END




GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_GetInfo]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Articles_GetInfo]
	@_Id int = 0,
	@_LanguageID INT = 1,
	@_Status TINYINT = 99
AS
BEGIN	
	SET NOCOUNT ON;
	SELECT A.Id, A.Alias, A.MainCateID, A.CreatedDate, ISNULL(AD.LanguageID,@_LanguageID) LanguageID, ISNULL(AD.Title,A.Alias) Title, 
	AD.[Description], AD.ImageUrl, AD.Tags,A.Type, AD.[Status], AD.UpdatedUser, AD.UpdateDate, AD.PublishDate, AD.Content , AD.ContentSMS,A.ViewCount
		FROM tbl_Articles A 
		LEFT OUTER JOIN tbl_ArticleDetail AD	ON A.Id = AD.ArticleID AND AD.LanguageID = @_LanguageID 
		WHERE A.Id = @_Id AND (ISNULL(@_Status,99) = 99 OR AD.[Status] = @_Status)

	--	SELECT A.Id, A.MainCateID, A.Alias, A.CreatedDate, ISNULL(AD.LanguageID,@_LanguageID) LanguageID, ISNULL(AD.Title,A.Alias) Title, 
	--AD.[Description], AD.ImageUrl, AD.Tags,A.Type, AD.[Status], AD.UpdatedUser, AD.UpdateDate, AD.PublishDate, AD.Content,A.ViewCount
	--	FROM tbl_Articles A 
	--	LEFT OUTER JOIN tbl_ArticleDetail AD	ON A.Id = AD.ArticleID AND AD.LanguageID = @_LanguageID 
	--	LEFT OUTER JOIN tbl_Articles2Cate AC	ON A.Id = AC.ArticleID 
	--	WHERE A.Id = @_Id AND (ISNULL(@_Status,99) = 99 OR AD.[Status] = @_Status)
	--		AND MainCateID = AC.CateId

		-- Update ViewCount
		IF EXISTS(SELECT * FROM tbl_Articles WHERE Id = @_Id)
			BEGIN
				UPDATE tbl_Articles
				SET  ViewCount = ViewCount+1
				WHERE Id = @_Id
			END
			
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_GetPage]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_Articles_GetPage]
	@_SystemID INT = 0
	,@_LanguageID INT = 1
	,@_Type INT = -1 --0 tin thường, 1 tin mới, 2 tin nổi bật
	,@_Title NVARCHAR(250) = ''
	,@_Categories VARCHAR(200)
	,@_Status TINYINT = 99
	,@_FromDate DateTime = NULL
	,@_ToDate DateTime = NULL
	,@_CurrPage INT = 1
	,@_RecordPerPage INT = 10
	,@_TotalRecord INT = 0 OUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @_CurrPage = ISNULL(@_CurrPage, 1)
	SET @_RecordPerPage = ISNULL(@_RecordPerPage, 10)
	SET @_TotalRecord = 0
	DECLARE @_Start INT = (((@_CurrPage-1) * @_RecordPerPage)+1)
	DECLARE @_End INT =   @_Start + @_RecordPerPage-1
	DECLARE @_TableCategories TABLE (CategoryID INT);
	INSERT INTO @_TableCategories SELECT [Value] FROM [dbo].FN_Parameters_Split(@_Categories,',') WHERE ISNULL([Value],'') <> '';

	IF (ISNULL(@_SystemID,0) <> 0 AND (SELECT COUNT(*) FROM @_TableCategories WHERE CategoryID > 0) = 0)
	BEGIN		
		INSERT INTO @_TableCategories
		SELECT Id FROM tbl_Category WHERE SystemID = @_SystemID
		SET @_Categories = '0';
	END
	
	SELECT * INTO #Temp 
  FROM (
  SELECT ROW_NUMBER() OVER(ORDER BY A.Id DESC) AS STT, 
   A.Id, A.Alias, A.MainCateID, C.Alias MainCateName, A.Type, ISNULL(AD.Title,A.Alias) Title, ISNULL(AD.[Description],'') [Description], ISNULL(AD.ImageUrl,'') ImageUrl, AD.Tags, ISNULL(AD.[Status],0) [Status], 
   A.CreatedDate, ISNULL(AD.PublishDate, A.CreatedDate) PublishDate, ISNULL(AD.UpdateDate, A.CreatedDate) UpdateDate, 
   A.CreatedUser, ISNULL(AD.LanguageID,0) LanguageID,A.ViewCount
 FROM tbl_Articles A 
  LEFT JOIN tbl_ArticleDetail AD ON A.Id = AD.ArticleID 
  LEFT JOIN tbl_Category C ON A.MainCateID = C.Id
  WHERE ISNULL(AD.PublishDate, A.CreatedDate) BETWEEN ISNULL(@_FromDate ,'2016-01-01 00:00:00') AND ISNULL(@_ToDate,GETDATE())
      AND (ISNULL(AD.LanguageID,0) = 0 OR AD.LanguageID = @_LanguageID)
   AND (ISNULL(@_Status,99) = 99 OR ISNULL(AD.[Status],0) = @_Status)
   AND (ISNULL(@_Title,'') = '' OR Title LIKE N'%'+@_Title+N'%')
   AND (ISNULL(@_Type,-1) = -1 OR  [Type] = @_Type)
   AND (ISNULL(@_Categories,'') = '' OR A.Id IN (SELECT ArticleId FROM tbl_Articles2Cate 
                 WHERE CateId IN (SELECT CategoryID FROM @_TableCategories)))   
 ) a
	SELECT @_TotalRecord = (SELECT COUNT(STT) FROM #Temp) 

	SELECT * From #Temp 
	WHERE STT BETWEEN @_Start AND @_End
	drop table #Temp 

END


GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_GetRelateArticles]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		cuongbx
-- Create date: 08/12/2016
-- Description:	<Lấy tin liên quan - random tin trong cateId>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Articles_GetRelateArticles]
	@_LanguageID INT = 1
	,@_CategoryID INT
	,@_TopCount INT = 10
AS
BEGIN
	SET NOCOUNT ON;
		SELECT TOP(ISNULL(@_TopCount,10)) A.* from (
				SELECT distinct ROW_NUMBER() OVER(ORDER BY A.Id DESC) AS STT,  A.Id, A.Alias, A.MainCateID, A.[Type], ISNULL(AD.LanguageID,@_LanguageID) LanguageID, ISNULL(AD.Title,A.Alias) Title, AD.Description, 
							ISNULL(AD.[Status],0) [Status], AD.ImageUrl, AD.Tags, AD.UpdatedUser, ISNULL(AD.UpdateDate, A.CreatedDate) UpdateDate, 
							ISNULL(AD.PublishDate, A.CreatedDate) PublishDate, '' Content, A.ViewCount,AC.SortOrder, AC.CateId
				FROM tbl_Articles A LEFT JOIN NewsTag NT ON A.Id = NT.[NewId]
				LEFT JOIN tbl_Articles2Cate AC ON A.Id = AC.ArticleId 
				LEFT JOIN tbl_ArticleDetail AD ON A.Id = AD.ArticleId
				WHERE AD.LanguageID = @_LanguageID
					  AND AD.[Status] = 1	
					  AND (ISNULL(@_CategoryID,-1)=-1 OR AC.CateId = @_CategoryID)
		
		)  a
			ORDER BY NEWID()
			
END











GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_GetRows]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		cuongbx
-- Create date: 11/23/2016
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SP_Articles_GetRows]
	@_LanguageID INT = 1
	,@_Type INT = -1 --0 tin thường, 1 tin mới, 2 tin nổi bật
	,@_Title NVARCHAR(250) = ''
	,@_Categories VARCHAR(200)
	,@_Status TINYINT = 99
	,@_TagId INT = -1
	,@_OrderType INT = 1 -- 1:sortorder, 2:publish date, 3:UpdateDate, 4:view count
	,@_CurrPage INT = 1
	,@_RecordPerPage INT = 10
	,@_TotalRecord INT = 0 OUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @_OrderType = ISNULL(@_OrderType, 1)
	SET @_CurrPage = ISNULL(@_CurrPage, 1)
	SET @_RecordPerPage = ISNULL(@_RecordPerPage, 10)
	SET @_TotalRecord = 0
	DECLARE @_Start INT = (((@_CurrPage-1) * @_RecordPerPage)+1)
	DECLARE @_End INT =   @_Start + @_RecordPerPage-1
	DECLARE @_TableCategories TABLE (CategoryID INT);
	INSERT INTO @_TableCategories SELECT [Value] FROM [dbo].FN_Parameters_Split(@_Categories,',') WHERE ISNULL([Value],'') <> '';
	SELECT * INTO #Temp 
	FROM (
		SELECT ROW_NUMBER() OVER(PARTITION BY AC.CateId ORDER BY (CASE WHEN @_OrderType = 1 THEN SortOrder END),
				(CASE WHEN @_OrderType = 2 THEN PublishDate
					WHEN @_OrderType = 3 THEN UpdateDate
					ELSE ViewCount END) DESC) AS STT, A.Id, A.Alias, A.MainCateID, A.[Type], ISNULL(AD.LanguageID,@_LanguageID) LanguageID, ISNULL(AD.Title,A.Alias) Title, AD.Description, 
				ISNULL(AD.[Status],0) [Status], AD.ImageUrl, AD.Tags, AD.UpdatedUser, ISNULL(AD.UpdateDate, A.CreatedDate) UpdateDate, 
				ISNULL(AD.PublishDate, A.CreatedDate) PublishDate, AD.Content Content, A.ViewCount,AC.SortOrder,AC.CateId
		FROM tbl_Articles A LEFT OUTER JOIN NewsTag NT ON A.Id = NT.[NewId]
		LEFT OUTER JOIN tbl_Articles2Cate AC ON A.Id = AC.ArticleId 
		LEFT OUTER JOIN tbl_ArticleDetail AD ON A.Id = AD.ArticleId
		WHERE (ISNULL(@_TagId, -1) = -1 OR (NT.TagId = @_TagId))
			AND AD.LanguageID = @_LanguageID
			AND (ISNULL(@_Categories,'')='' OR AC.CateId in (SELECT CategoryID FROM @_TableCategories))
			AND (ISNULL(@_Status,99) = 99 OR ISNULL(AD.[Status],0) = @_Status)
			AND (ISNULL(@_Type,-1) = -1 OR  A.[Type] = @_Type)
			AND (ISNULL(@_Title,'') = '' OR Title LIKE N'%'+@_Title+N'%')
		GROUP BY A.Id, A.Alias, A.MainCateID, A.[Type], AD.LanguageID, AD.Title, AD.Description,AD.[Status], AD.ImageUrl, AD.Tags, AD.UpdatedUser,
		 AD.UpdateDate, A.CreatedDate, AD.PublishDate, Content, A.ViewCount,AC.SortOrder,AC.CateId
	) a
	SELECT @_TotalRecord = (SELECT COUNT(STT) FROM #Temp) 

	SELECT * From #Temp WHERE STT BETWEEN @_Start AND @_End
	
END





GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_GetTop]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Articles_GetTop]
	@_SystemID INT = 0
	,@_LanguageID INT
	,@_Categories VARCHAR(200)
	,@_Status TINYINT = 99
	,@_Top INT = 0
	,@_Type INT = 0 -- 0 tin thường , 1 tin mới , 2 tin nổi bật
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @_TableCategories TABLE (CategoryID INT);
	INSERT INTO @_TableCategories SELECT [Value] FROM [dbo].FN_Parameters_Split(@_Categories,',') WHERE ISNULL([Value],'') <> '';

	IF (ISNULL(@_SystemID,0) <> 0 AND (SELECT COUNT(*) FROM @_TableCategories WHERE CategoryID > 0) = 0)
	BEGIN		
		INSERT INTO @_TableCategories
		SELECT Id FROM tbl_Category WHERE SystemID = @_SystemID
		SET @_Categories = '0';
	END

	SELECT TOP(@_Top) * INTO #Temp
	  FROM (SELECT ROW_NUMBER() OVER(ORDER BY A.Id DESC) AS STT,
		 A.Id, A.Alias, A.Type, ISNULL(AD.Title,A.Alias) Title, AD.[Description], AD.ImageUrl, AD.Tags, ISNULL(AD.[Status],0) [Status], 
		 A.CreatedDate, ISNULL(AD.PublishDate, A.CreatedDate) PublishDate, ISNULL(AD.UpdateDate, A.CreatedDate) UpdateDate, 
		 AD.UpdatedUser, ISNULL(AD.LanguageID,@_LanguageID) LanguageID,A.ViewCount
	FROM tbl_Articles A LEFT OUTER JOIN tbl_ArticleDetail AD
	ON A.Id = AD.ArticleID 
	AND AD.LanguageID = @_LanguageID
		WHERE (ISNULL(@_Status,99) = 99 OR ISNULL(AD.[Status],0) = @_Status)
			
			AND (ISNULL(@_Categories,'') = '' OR A.Id IN (SELECT ArticleId FROM tbl_Articles2Cate WHERE CateId IN
																					(SELECT CategoryID FROM @_TableCategories)))			
	) As Tmp

	SELECT * From #Temp WHERE (ISNULL(@_Type, -1)) = -1 OR ([Type] = @_Type)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_InsertTracking]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		cuongbx
-- Create date: 11/23/2016
-- Description:	<Ghi log truy cập xem tin tức - thống kê>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Articles_InsertTracking]
	@_ArticleId INT 
	,@_AccountID INT = 0
	,@_AccountName VARCHAR(50) = ''
	,@_ReferURL VARCHAR(350)
	,@_ReferSite VARCHAR(350)
	,@_DeviceType INT -- 1 web , 2 mobile
	,@_Browser VARCHAR(20) -- trình duyệt
	,@_Operation VARCHAR(20) -- Hệ điều hành 
	,@_ClientIP VARCHAR(30)
	,@_ResponseCode INT OUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;
	DECLARE @_ERR_NOTEXISTS_ARTICLE INT = -50, -- TIN Ghi Nhận ko tồn tại
		    @_ERR_NOTEXISTS_REFERURL INT = -51

	DECLARE @_GetDate			DATETIME = GETDATE()
			,@_CreatedDateInt	INT
			,@_CreatedHour		TINYINT
	SET @_CreatedDateInt	= [dbo].[FN_DateToInt] (@_GetDate)	
	SET @_CreatedHour		= DATEPART(HOUR, @_GetDate) 	
		
	IF(NOT EXISTS (SELECT TOP 1 * FROM [dbo].[tbl_ArticleDetail] WHERE [ArticleID] = @_ArticleId))	
	BEGIN
		SET @_ResponseCode = @_ERR_NOTEXISTS_ARTICLE
		RETURN
	END			
	
	--Kiem tra dau vao 

	BEGIN TRANSACTION
	BEGIN TRY		
			BEGIN
				INSERT INTO [dbo].[tbl_ArticleLog](
					[ArticleId]
					,[AccountId]
					,[AccountName]
					,[ReferURL]
					,[ReferSite]
					,[DeviceType]
					,[ClientIP]
					,[CreatedTime]
					,[CreatedDateInt]
					,[CreatedHour]
					,[Browser]	
					,[Operating]		
				)
				VALUES
				(
					@_ArticleId
					,@_AccountId
					,@_AccountName
			   		,@_ReferURL					   
					,@_ReferSite 
					,@_DeviceType
	 				,@_ClientIP	
					,@_GetDate
					,@_CreatedDateInt
					,@_CreatedHour 
					,@_Browser
					,@_Operation
				)
				SET @_ResponseCode = @@IDENTITY

			END
		COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			SET @_ResponseCode = -99;
			IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
			-- Insert Log
			EXEC	[dbo].[SP_LogError]
					@ErrorCode = @_ResponseCode OUTPUT
		END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_InsertUpdate]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Articles_InsertUpdate]
	@_Id			int = NULL,
	@_LanguageID	int = 1,
	@_Title			nvarchar(250) = '',
	@_Alias			VARCHAR(250) = '',
	@_Description	nvarchar(2000) = '',
	@_Content		nvarchar(MAX) = '',
	@_ContentSMS    varchar(200) = '',
	@_ImageUrl		nvarchar(250) = '',
	@_Status			BIT = NULL,
	@_PublicDate		datetime = NULL,
	@_Username   varchar(50) = '',
	@_Type			tinyint = NULL,
	@_Tags Nvarchar(250) = '',
	@_MainCateID int = 0,
	@_Categories VARCHAR(100) = '', -- categoryID list: 1,2,3,4...
	@_ResponseStatus INT OUT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @_SYSTEM_ERROR INT = -99,
			@_RESPONSE_SUCCESS INT = 1,
			@_RESPONSE_EXISTED_ARTICLE INT = -2,
			@_RESPONSE_NOT_EXISTS_ARTICLE INT = -3,
			@_RESPONSE_PARAM_INVALID INT = -600
	SET @_ResponseStatus = @_SYSTEM_ERROR
	
	--Kiem tra dau vao 

	BEGIN TRY
		BEGIN  TRANSACTION; 
		--Id = 0 -> Insert <> UPDATE
		IF (ISNULL(@_Id,0) = 0) -- Insert
		BEGIN
			IF(ISNULL(@_Title,'') = '' OR ISNULL(@_Content,'') = '')
			BEGIN 
				SET @_ResponseStatus = @_RESPONSE_PARAM_INVALID;
				RETURN;
			END
			IF(EXISTS(SELECT 1 FROM dbo.tbl_Articles WHERE Alias = @_Alias)
				OR EXISTS(SELECT 1 FROM dbo.tbl_ArticleDetail WHERE Title = @_Title AND LanguageID = @_LanguageID)
			)
			BEGIN
				SET @_ResponseStatus = @_RESPONSE_EXISTED_ARTICLE;
				RETURN;
			END

			SET @_LanguageID  = 1; -- 'vi'
			INSERT INTO	dbo.tbl_Articles	(
				Alias,
				ViewCount,
				[CreatedDate],
				[CreatedUser],
				[Type],
				NumLike,
				NumComment,
				MainCateID
			)
			VALUES	(
				@_Alias,
				0,
				getdate(),
				@_Username,
				ISNULL(@_Type,0),
				0,
				0,
				@_MainCateID
			)

			SET @_Id = @@IDENTITY
			INSERT INTO [dbo].[tbl_ArticleDetail]
			(
				ArticleID
				,[LanguageID]
				,[Title]
				,[Description]
				,[ImageUrl]
				,[Content]
				,[ContentSMS]
				,[Tags]
				,[Status]
				,[UpdatedUser]
				,[UpdateDate]
				,[PublishDate]
			)
			VALUES(
				@_Id
			   ,@_LanguageID
			   ,@_Title
			   ,@_Description
			   ,@_ImageUrl
			   ,@_Content
			   ,@_ContentSMS
			   ,@_Tags
			   ,0
			   ,@_Username
			   ,GETDATE()
			   ,GETDATE())

			-- insert news category and set order
			INSERT INTO [dbo].[tbl_Articles2Cate]
			   ([ArticleId]
			   ,CateId
			   ,[SortOrder])
			SELECT  @_Id
				   ,CONVERT(INT, [Value])
				   ,-@_Id * 10
			FROM [dbo].[FN_Parameters_Split](@_Categories, ',')

			-- insert Tag.
			INSERT INTO Newstag (NewID, TagID)
			SELECT @_Id , TagID 
			FROM Tag 
			WHERE TagName IN (
				(SELECT [Value1] FROM [dbo].[FN_Parameters_SplitTable] (
					   @_Tags
					  ,';'
					  ,',')))

		END
		ELSE BEGIN
			--Check 
			IF(NOT EXISTS(SELECT 1 FROM dbo.tbl_Articles WHERE Id = @_Id))
			BEGIN
				SET @_ResponseStatus = @_RESPONSE_NOT_EXISTS_ARTICLE;
				RETURN;
			END

			IF((ISNULL(@_Alias,'') <> '' AND (EXISTS(SELECT 1 FROM dbo.tbl_Articles WHERE Alias = @_Alias AND Id <> @_Id)))
				OR (ISNULL(@_Title,'') <> '' AND (EXISTS(SELECT 1 FROM dbo.tbl_ArticleDetail WHERE Title = @_Title AND LanguageID = @_LanguageID AND ArticleID <> @_Id))))
			BEGIN
				SET @_ResponseStatus = @_RESPONSE_EXISTED_ARTICLE;
				RETURN;
			END
			UPDATE	dbo.tbl_Articles
			SET	Alias		=	ISNULL(@_Alias, Alias),
				[Type]		=	ISNULL(@_Type, [Type]),
				MainCateID = @_MainCateID
			WHERE
				Id			=	@_Id	

			IF(NOT EXISTS(SELECT * FROM dbo.tbl_ArticleDetail WHERE ArticleID = @_Id AND LanguageID = @_LanguageID))
			BEGIN 
				INSERT INTO [dbo].tbl_ArticleDetail
				   (ArticleID
				   ,[LanguageID]
				   ,[Title]
				   ,[Description]
				   ,[ImageUrl]
				   ,[Content]
				   ,[ContentSMS]
				   ,[Tags]
				   ,[Status]
				   ,[UpdatedUser]
				   ,[UpdateDate]
				   ,[PublishDate])
				 VALUES(
					@_Id
					,@_LanguageID
					,@_Title
					,@_Description
					,@_ImageUrl
					,@_Content
					,@_ContentSMS
					,@_Tags
					,0
					,@_Username
					,GETDATE()
					,GETDATE()
				)
			END
			ELSE BEGIN
				UPDATE tbl_ArticleDetail
				SET [Title] = ISNULL(@_Title, [Title])
				   ,[Description] = ISNULL(@_Description, [Description])
				   ,Content = ISNULL(@_Content, Content)
				   ,ContentSMS = ISNULL(@_ContentSMS, ContentSMS)
				   ,[ImageUrl] = ISNULL(@_ImageUrl, [ImageUrl])
				   ,[Tags] = ISNULL(@_Tags, [Tags])
				   ,[UpdatedUser] = @_Username
				   ,[UpdateDate] = GETDATE()
				   ,[PublishDate] = ISNULL(@_PublicDate, PublishDate)
				WHERE ArticleID = @_Id AND LanguageID = @_LanguageID
			END

			-- cap nhat danh muc chua bai viet
				--Xoa danh muc hien tai
				DELETE FROM [dbo].[tbl_Articles2Cate]
				WHERE ArticleId = @_Id 
				  AND CateId NOT IN (SELECT CONVERT(INT, [Value]) FROM [dbo].[FN_Parameters_Split](@_Categories, ','))
				END
			-- insert categoryids in update list
			INSERT INTO [dbo].[tbl_Articles2Cate]
				   ([ArticleId]
				   ,[CateID]
				   ,[SortOrder])
			SELECT  @_Id
				   ,CONVERT(INT, [Value])
				   ,-@_Id * 10
			FROM [dbo].[FN_Parameters_Split](@_Categories, ',')
			WHERE CONVERT(INT, [Value]) NOT IN (SELECT CateId FROM [tbl_Articles2Cate] WHERE ArticleId = @_Id)
			-- #
		
			-- delete old Tag
			Delete From Newstag where [NewID] = @_Id
			-- insert Tag.
			INSERT INTO Newstag ([NewID], TagID)
			SELECT @_Id , TagID 
			FROM Tag 
			WHERE TagName IN (
				(SELECT [Value1] FROM [dbo].[FN_Parameters_SplitTable] (
					   @_Tags
					  ,';'
					  ,',')))

		SET @_ResponseStatus = @_Id	
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0) BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = -99
			EXECUTE [dbo].[SP_LogError];
		END
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_Update_PublishDate]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Articles_Update_PublishDate]
	@_PublishDate Datetime
   ,@_Id int
   ,@_LanguageID int
   ,@_ResponseCode int OUT
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT * FROM dbo.tbl_ArticleDetail WHERE ArticleID = @_Id AND LanguageID = @_LanguageID)
	BEGIN
		SET @_ResponseCode = -1; 
		RETURN;
	END 
	BEGIN TRY 	
		BEGIN TRANSACTION
		
			UPDATE dbo.tbl_ArticleDetail
			SET PublishDate = @_PublishDate
			WHERE ArticleID = @_Id AND LanguageID = @_LanguageID
			SET @_ResponseCode = @_Id 
			
			COMMIT TRANSACTION
	END TRY
	BEGIN CATCH	
		ROLLBACK TRANSACTION;
		SET @_ResponseCode=-99;
		EXEC	[dbo].[sp_LogError]	@_ResponseCode;
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Articles_UpdateStatus]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Articles_UpdateStatus]
	@_Id			int,
	@_LanguageID INT,
	@_Status			tinyint = NULL,
	@_Username   varchar(50) = '',
	@_ResponseStatus INT OUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON
	DECLARE @_SYSTEM_ERROR INT = -99,
			@_RESPONSE_SUCCESS INT = 1,
			@_RESPONSE_EXISTED_ARTICLE INT = -2,
			@_RESPONSE_NOT_EXISTS_ARTICLE INT = -3,
			@_RESPONSE_PARAM_INVALID INT = -600
	SET @_ResponseStatus = @_SYSTEM_ERROR
	
	IF(NOT EXISTS(select 1 from [dbo].[tbl_Articles] Where Id = @_Id))
	BEGIN
		SET @_ResponseStatus = @_RESPONSE_NOT_EXISTS_ARTICLE
		RETURN;
	END
	BEGIN TRY
		BEGIN  TRANSACTION; 
		
			UPDATE	dbo.tbl_ArticleDetail
			SET	
				[UpdateDate]	=	getdate(),
				[UpdatedUser]	=	@_Username,
				[Status]	=	ISNULL(@_Status, [Status])
			WHERE
				ArticleID=	@_Id AND LanguageID = @_LanguageID

		SET @_ResponseStatus = @_Id	
		
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0) BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = -99
			EXECUTE [dbo].[SP_LogError];
		END
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Articles2Cate_DeleteByCondition]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Articles2Cate_DeleteByCondition]
	@_CateId int = NULL,
	@_Article bigint = NULL
AS
BEGIN
	SET NOCOUNT ON
	DELETE FROM [dbo].[tbl_Articles2Cate]
	WHERE (ISNULL(@_CateId, 0) = 0 OR CateId = @_CateId) 
	AND (ISNULL(@_Article,0) = 0 OR ArticleId = @_Article)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Articles2Cate_GetByCondition]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Articles2Cate_GetByCondition]
	@_CateId int = NULL,
	@_Article bigint = NULL
AS
BEGIN
	SET NOCOUNT ON
	SELECT *
	FROM [dbo].[tbl_Articles2Cate]
	WHERE (ISNULL(@_CateId, 0) = 0 OR CateId = @_CateId) 
	AND (ISNULL(@_Article,0) = 0 OR ArticleId = @_Article)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Articles2Cate_Insert]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Articles2Cate_Insert]
	@_CateId int,
	@_ArticleId bigint,
	@_ResponseStatus INT
AS
BEGIN
	SET NOCOUNT ON
	SET @_ResponseStatus = -99
	IF NOT EXISTS(SELECT CateId FROM [dbo].[tbl_Articles2Cate] WHERE CateId = @_CateId AND ArticleId = @_ArticleId)
	BEGIN
		SET @_ResponseStatus = -101
		RETURN
	END


	BEGIN TRY
		BEGIN  TRANSACTION; 
			INSERT INTO [dbo].[tbl_Articles2Cate] (
				CateId,
				ArticleId
			) VALUES (
				@_CateId,
				@_ArticleId
			)
			
			SET @_ResponseStatus = @@ROWCOUNT				
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0) BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = -99
			EXECUTE [dbo].[SP_LogError];
		END
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Articles2Cate_UpdateSortOrder]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Articles2Cate_UpdateSortOrder]
	@_CateId int,
	@_ArticleId bigint,
	@_OrderType TINYINT, -- 0: top; 1:up; 2: down
	@_ResponseStatus INT OUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON
	DECLARE @NearNewsID INT = 0;
	DECLARE @NearOrder INT = -1;
	DECLARE @CurrentOrder INT;
	SET @_ResponseStatus = -99
	SELECT @CurrentOrder = SortOrder FROM tbl_Articles2Cate 
	WHERE CateId = @_CateId AND ArticleId = @_ArticleId

	IF NOT EXISTS(SELECT CateId FROM [dbo].[tbl_Articles2Cate] WHERE ArticleId = @_ArticleId)
	BEGIN
		SET @_ResponseStatus = -101
		RETURN
	END
	
	IF (ISNULL(@_OrderType, 0) = 1) -- up sort order
	BEGIN
		SELECT   TOP 1 
				 @NearNewsID = ArticleId 
				,@NearOrder = SortOrder
		FROM tbl_Articles2Cate
		WHERE SortOrder < @CurrentOrder AND CateId = @_CateId
		ORDER BY SortOrder DESC		
	END
	ELSE IF (ISNULL(@_OrderType, 0) = 2)
	BEGIN
		SELECT   TOP 1 
				 @NearNewsID = ArticleId 
				,@NearOrder = SortOrder
		FROM tbl_Articles2Cate
		WHERE SortOrder > @CurrentOrder AND CateId = @_CateId
		ORDER BY SortOrder
	END
	ELSE IF (ISNULL(@_OrderType, 0) = 0)
	BEGIN
		SELECT   TOP 1 
				 @NearNewsID = ArticleId 
				,@NearOrder = SortOrder
		FROM tbl_Articles2Cate
		WHERE CateId = @_CateId
		ORDER BY SortOrder
	END
	IF (@NearNewsID = 0 OR @NearNewsID = @_ArticleId) 
	BEGIN
		SET @_ResponseStatus = 1
		RETURN;	
	END
	BEGIN TRY
		BEGIN  TRANSACTION; 
				
		-- up/down
		IF (@_OrderType IN (1,2))
		BEGIN
			UPDATE tbl_Articles2Cate
			SET SortOrder = @NearOrder
			WHERE ArticleId = @_ArticleId AND CateId = @_CateId
		
			UPDATE tbl_Articles2Cate
			SET SortOrder = @CurrentOrder
			WHERE ArticleId = @NearNewsID AND CateId = @_CateId
		END
		ELSE IF (@_OrderType = 0) -- top
		BEGIN
			UPDATE tbl_Articles2Cate
			SET SortOrder = @NearOrder - 1
			WHERE ArticleId = @_ArticleId AND CateId = @_CateId
		END
			
		SET @_ResponseStatus = 1				
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0) BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = -99
			EXECUTE [dbo].[SP_LogError];
		END
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_BankAccountConfig_Delete]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_BankAccountConfig_Delete]
	@_Id INT = 0,
	@_BankCode VARCHAR(20) = '',
	@_ResponseStatus INT OUTPUT
AS
BEGIN
	SET NOCOUNT,XACT_ABORT ON ;
	DECLARE @_SUCCESSFUL  INT = 1;
	DECLARE @_ERR_NOT_EXIST_BANK  INT = -2;
	DECLARE @_ERR_INVALID_PARAM INT = -600;
	DECLARE @_ERR_UNKNOW INT = -99;

	SET @_ResponseStatus = @_ERR_UNKNOW

	IF(ISNULL(@_Id,0) = 0 AND ISNULL(@_BankCode,'') = '')
	BEGIN
		SET @_ResponseStatus = @_ERR_INVALID_PARAM
		RETURN
	END

	IF(NOT EXISTS(SELECT 1 FROM [dbo].[BankAccountConfig] WHERE (ISNULL(@_Id,0) = 0 OR Id = @_Id) AND (ISNULL(@_BankCode,'') = '' OR BankCode = @_BankCode)))
	BEGIN 
		SET @_ResponseStatus = @_ERR_NOT_EXIST_BANK
		RETURN;
	END
	BEGIN TRANSACTION
	BEGIN TRY 
		DELETE dbo.BankAccountConfig 
		WHERE (ISNULL(@_Id,0) = 0 OR Id = @_Id) AND (ISNULL(@_BankCode,'') = '' OR BankCode = @_BankCode)

		SET @_ResponseStatus = 1
	COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) = -1 
		BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = @_ERR_UNKNOW;
			EXECUTE [dbo].[SP_LogError];
			RETURN;
		END
		IF (XACT_STATE()) = 1 COMMIT TRANSACTION;		
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_BankAccountConfig_Get]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_BankAccountConfig_Get]
	@_Id INT = 0,
	@_BankCode VARCHAR(20) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [dbo].[BankAccountConfig]
	WHERE (ISNULL(@_Id,0) = 0 OR Id = @_Id) AND (ISNULL(@_BankCode,'') = '' OR BankCode = @_BankCode)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_BankAccountConfig_InsertUpdate]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_BankAccountConfig_InsertUpdate]
	@_Id INT = 0,
	@_BankCode VARCHAR(20) = '',
	@_BankName NVARCHAR(50) = '',
	@_Description NVARCHAR(150) = '',
	@_BrandName NVARCHAR(100) = '',
	@_BankNumber VARCHAR(50) = '',
	@_BankAccountHolder VARCHAR(50) = '',
	@_ResponseStatus INT OUTPUT
AS
BEGIN
	SET NOCOUNT,XACT_ABORT ON ;
	DECLARE @_SUCCESSFUL  INT = 1;
	DECLARE @_ERR_EXIST_BANK  INT = -1;
	DECLARE @_ERR_NOT_EXIST_BANK  INT = -2;
	DECLARE @_ERR_INVALID_PARAM INT = -600;
	DECLARE @_ERR_UNKNOW INT = -99;

	SET @_BankCode = ISNULL(@_BankCode,'')
	SET @_BankName = ISNULL(@_BankName,'')
	SET @_Description = ISNULL(@_Description,'')
	SET @_BrandName = ISNULL(@_BrandName,'')
	SET @_BankNumber = ISNULL(@_BankNumber,'')
	SET @_BankAccountHolder = ISNULL(@_BankAccountHolder, 99)

	SET @_ResponseStatus = @_ERR_UNKNOW

	IF(@_Id = 0)
	BEGIN
		IF(@_BankCode = '' OR @_BankName = '' OR @_BrandName = '' OR @_BankNumber = '' OR @_BankAccountHolder = '')
		BEGIN
			SET @_ResponseStatus = @_ERR_INVALID_PARAM
			RETURN;
		END

		IF(EXISTS(SELECT 1 FROM [dbo].[BankAccountConfig] WHERE BankCode = @_BankCode))
		BEGIN
			SET @_ResponseStatus = @_ERR_EXIST_BANK
			RETURN;
		END
	END
	ELSE BEGIN
		IF(NOT EXISTS(SELECT 1 FROM [dbo].[BankAccountConfig] WHERE Id = @_Id))
		BEGIN
			SET @_ResponseStatus = @_ERR_NOT_EXIST_BANK;
			RETURN;
		END
		IF(@_BankCode <> '' AND EXISTS(SELECT 1 FROM [dbo].[BankAccountConfig] WHERE BankCode = @_BankCode))
		BEGIN
			SET @_ResponseStatus = @_ERR_EXIST_BANK;
			RETURN;
		END
	END

	BEGIN TRANSACTION
	BEGIN TRY 
		IF @_Id = 0
		BEGIN
			
				INSERT INTO [dbo].[BankAccountConfig]
					(BankCode
					,BankName
					,Description
					,BrandName
					,BankNumber
					,BankAccountHolder)
				VALUES
					(@_BankCode
					,@_BankName
					,@_Description
					,@_BrandName
					,@_BankNumber
					,@_BankAccountHolder)
				SET @_ResponseStatus = @@IDENTITY	
		END
		ELSE BEGIN 	
			UPDATE [dbo].[BankAccountConfig]
				SET BankCode = CASE WHEN @_BankCode = '' THEN BankCode ELSE @_BankCode END
					,BankName = CASE WHEN @_BankName = '' THEN BankName ELSE @_BankName END
					,Description = CASE WHEN @_Description = '' THEN Description ELSE @_Description END
					,BrandName = CASE WHEN @_BrandName  = '' THEN BrandName ELSE @_BrandName  END
					,BankNumber = CASE WHEN @_BankNumber  = '' THEN BankNumber ELSE @_BankNumber  END
					,BankAccountHolder = CASE WHEN @_BankAccountHolder  = '' THEN BankAccountHolder ELSE @_BankAccountHolder  END
				WHERE Id = @_Id
							
			SET @_ResponseStatus = @_Id	
		END		
	COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) = -1 
		BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = @_ERR_UNKNOW;
			EXECUTE [dbo].[SP_LogError];
			RETURN;
		END
		IF (XACT_STATE()) = 1 COMMIT TRANSACTION;		
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Banner_Delete]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Banner_Delete]
	 @_Id INT
	,@_ResponseStatus INT OUTPUT
AS
BEGIN
    SET NOCOUNT,XACT_ABORT ON ;
	DECLARE @_SUCCESSFUL  INT = 1;
	DECLARE @_ERR_NOT_EXIST_BANNER  INT = -1;
	DECLARE @_ERR_INVALID_PARAM INT = -600;
	DECLARE @_ERR_UNKNOW INT = -99;


	IF(@_Id = 0) 
	BEGIN
		SET @_ResponseStatus = @_ERR_INVALID_PARAM
		RETURN;
	END
	IF (NOT EXISTS(SELECT 1 FROM [dbo].[Banner] WHERE [Id] = @_Id))
	BEGIN
		SET @_ResponseStatus = @_ERR_NOT_EXIST_BANNER;
		RETURN;
	END
	BEGIN TRANSACTION
	BEGIN TRY 
			DELETE [dbo].[Banner] WHERE Id = @_Id
							
			SET @_ResponseStatus = @_Id		
	COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) = -1 
		BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = @_ERR_UNKNOW;
			EXECUTE [dbo].[SP_LogError];
			RETURN;
		END
		IF (XACT_STATE()) = 1 COMMIT TRANSACTION;		
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Banner_GetByCondition]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Banner_GetByCondition]
	 @_Id INT = 0
	,@_Name NVARCHAR(250) = ''
	,@_Status INT = 99 -- 99 : all , 1 : active  , 0 : inactive
	,@_Type INT = 99 -- 99 : all , 1 home, 2 new 
	,@_Top INT = 0
AS
BEGIN
    SELECT TOP(ISNULL(@_Top,1000)) A.Id, A.Name, A.NewsId,A.BannerOrder, A.TimeCreate, A.ImageLink,A.ConnectLink, A.[Status], A.Creator,A.[Type], AD.Title AS ArticlesTitle
	FROM [dbo].[Banner] A LEFT JOIN  [dbo].[tbl_ArticleDetail] AD
	ON A.NewsId = AD.[ArticleID]
	WHERE (ISNULL(@_Id,0) = 0 OR A.[Id] = @_Id)
	AND (ISNULL(@_Status,99) = 99 OR A.[Status] = @_Status)
	AND (ISNULL(@_Name,'') = '' OR A.Name = @_Name)
	AND (ISNULL(@_Type,99) = 99 OR A.[Type] = @_Type) 
	ORDER BY A.BannerOrder, A.TimeCreate DESC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Banner_InsertUpdate]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Banner_InsertUpdate]
	 @_Id INT = 0
	,@_Name NVARCHAR(50) = ''
	,@_ArticleId INT = 0
	,@_BannerOrder INT = 0
	,@_ImageLink NVARCHAR(150) = ''
	,@_ConnectLink NVARCHAR(150) = ''	
	,@_Status	INT = 99
	,@_Creator NVARCHAR(150) = ''
	,@_Type INT = 0
	,@_ResponseStatus INT OUTPUT
AS
BEGIN
    SET NOCOUNT,XACT_ABORT ON ;
	DECLARE @_SUCCESSFUL  INT = 1;
	DECLARE @_ERR_EXIST_BANNER  INT = -1;
	DECLARE @_ERR_NOT_EXIST_BANNER  INT = -2;
	DECLARE @_ERR_INVALID_PARAM INT = -600;
	DECLARE @_ERR_UNKNOW INT = -99;

	SET @_Name = ISNULL(@_Name,'')
	SET @_ArticleId = ISNULL(@_ArticleId,0)
	SET @_ImageLink = ISNULL(@_ImageLink,'')
	SET @_ConnectLink = ISNULL(@_ConnectLink,'')
	SET @_Creator = ISNULL(@_Creator,'')
	SET @_Status = ISNULL(@_Status, 99)

	IF(@_Id = 0 AND @_Name = '') 
		OR (@_Id = 0 AND @_ArticleId = 0 AND @_ConnectLink = 0)
	BEGIN
		SET @_ResponseStatus = @_ERR_INVALID_PARAM
		RETURN;
	END

	BEGIN TRANSACTION
	BEGIN TRY 
		IF @_Id = 0
		BEGIN
			IF (EXISTS(SELECT 1 FROM [dbo].[Banner] WHERE [Name] = @_Name))
			BEGIN
				SET @_ResponseStatus = @_ERR_EXIST_BANNER;
				RETURN;
			END
		
			ELSE BEGIN
				INSERT INTO [dbo].[Banner]
					([Name]
					,[NewsId]
					,[TimeCreate]
					,[BannerOrder]
					,[ImageLink]
					,[ConnectLink]
					,[Status]
					,[Creator]
					,[Type])
				VALUES
					(@_Name
					,@_ArticleId
					,GETDATE()
					,@_BannerOrder
					,@_ImageLink 
					,@_ConnectLink 		
					,@_Status	
					,@_Creator
					,@_Type)
				SET @_ResponseStatus = @@IDENTITY	
			END	
		END
		ELSE BEGIN 		
			IF (NOT EXISTS(SELECT 1 FROM [dbo].[Banner] WHERE Id = @_Id))
			BEGIN
				SET @_ResponseStatus = @_ERR_NOT_EXIST_BANNER;
				RETURN;
			END	
			UPDATE [dbo].[Banner]
				SET [Name] = CASE WHEN @_Name = '' THEN [Name] ELSE @_Name END
					,[NewsId] = CASE WHEN @_ArticleId = 0 THEN NewsId ELSE @_ArticleId END
					,[BannerOrder] = CASE WHEN @_BannerOrder = 0 THEN [BannerOrder] ELSE @_BannerOrder END
					,[ImageLink] = CASE WHEN @_ImageLink  = '' THEN [ImageLink] ELSE @_ImageLink  END
					,[ConnectLink] = CASE WHEN @_ConnectLink  = '' THEN [ConnectLink] ELSE @_ConnectLink  END
					,[Status] = CASE WHEN @_Status  = 99 THEN [Status] ELSE @_Status  END
					,[Creator] = CASE WHEN @_Creator  = '' THEN [Creator] ELSE @_Creator   END
					,[Type] = CASE WHEN @_Type = 0 THEN [Type] ELSE @_Type   END
				WHERE Id = @_Id
							
			SET @_ResponseStatus = @_Id	
		END		
	COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) = -1 
		BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = @_ERR_UNKNOW;
			EXECUTE [dbo].[SP_LogError];
			RETURN;
		END
		IF (XACT_STATE()) = 1 COMMIT TRANSACTION;		
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Banner_UpdateActive]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Banner_UpdateActive]
	-- Add the parameters for the stored procedure here
	@_Id INT,
	@_ResponseStatus INT OUT
AS

BEGIN
	SET NOCOUNT ON;
	
	DECLARE @_ERR_UNKNOWN INT; SET @_ERR_UNKNOWN = -99;
 	DECLARE @_ERR_DATA_INVALID INT; SET @_ERR_DATA_INVALID = -600
 	DECLARE @_ERR_BANNER_NOT_EXISTED INT; SET @_ERR_BANNER_NOT_EXISTED = -1; 	

	DECLARE  @_Status INT;
	SET @_ResponseStatus = @_ERR_UNKNOWN
	SET @_Id = ISNULL(@_Id, 0)

	IF(@_Id = 0)
	BEGIN
		SET @_ResponseStatus = @_ERR_DATA_INVALID
		RETURN;
	END

	SELECT @_Status = [Status]
	FROM [dbo].[Banner]
	WHERE [ID] = @_Id

	IF(@_Status IS NULL)
	BEGIN
		SET @_ResponseStatus = @_ERR_BANNER_NOT_EXISTED
		RETURN;
	END 
	BEGIN TRY

		BEGIN TRANSACTION
			IF (@_Status = 0)
				BEGIN
					UPDATE [dbo].[Banner]
					SET [Status] = 1
					WHERE [ID] = @_Id
				END
			ELSE

			UPDATE [dbo].[Banner]
			SET [Status] = 0
			WHERE [ID] = @_Id
			SET @_ResponseStatus = 1

		COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) = -1 
		BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = -99;
			EXECUTE [dbo].[SP_LogError];
			RETURN;
		END
		IF (XACT_STATE()) = 1 COMMIT TRANSACTION;			
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Banner_UpdateSortOrder]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Banner_UpdateSortOrder]
	 @_Id INT
	,@_UpOrder BIT = 0 -- 0 : down, 1 : Up
	,@_ResponseStatus INT OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;
	DECLARE @_ERR_UNKNOWN INT; SET @_ERR_UNKNOWN = -99;
 	DECLARE @_ERR_DATA_INVALID INT; SET @_ERR_DATA_INVALID = -600
 	DECLARE @_ERR_BANNER_NOT_EXISTED INT; SET @_ERR_BANNER_NOT_EXISTED = -1; 		
	SET @_ResponseStatus = @_ERR_UNKNOWN;
	DECLARE @NearBannerID INT = 0;
	DECLARE @NearOrder INT = 1;
	DECLARE @CurrentOrder INT;
	
	SET @_Id = ISNULL(@_Id, 0)

	IF(@_Id = 0 OR @_UpOrder IS NULL)
	BEGIN
		SET @_ResponseStatus = @_ERR_DATA_INVALID
		RETURN;
	END

	SELECT @CurrentOrder = BannerOrder
	FROM [dbo].[Banner] WHERE Id = @_Id
	
	IF (@_UpOrder = 1) -- up sort order
	BEGIN
		SELECT   TOP 1 
				 @NearBannerID = Id 
				,@NearOrder = BannerOrder
		FROM [dbo].[Banner]
		WHERE BannerOrder > @CurrentOrder
		ORDER BY BannerOrder
	END
	ELSE BEGIN
		SELECT   TOP 1 
				 @NearBannerID = Id 
				,@NearOrder = BannerOrder
		FROM [dbo].[Banner]
		WHERE BannerOrder < @CurrentOrder
		ORDER BY BannerOrder DESC
	END
	
	BEGIN TRY
		BEGIN TRANSACTION
			
			UPDATE [dbo].[Banner]
			SET BannerOrder = @NearOrder
			WHERE Id = @_Id
			
			UPDATE [dbo].[Banner]
			SET BannerOrder = @CurrentOrder
			WHERE Id = @NearBannerID
			
		SET @_ResponseStatus = 1
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH	
		IF (XACT_STATE()=-1)
		BEGIN
			ROLLBACK TRANSACTION;
			EXECUTE SP_LogError 0;
			RETURN;
		END
		ELSE IF (XACT_STATE()=0)
		BEGIN
			EXECUTE SP_LogError 0;
			RETURN;
		END
		ELSE COMMIT TRANSACTION;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Category_Delete]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Category_Delete]
	@_Id INT,
	@_ResponseStatus int output
AS
BEGIN
	SET NOCOUNT ON;
	SET NOCOUNT, XACT_ABORT ON;
   DECLARE @_ERR_CATEGORY_INACTIVE INT = -24,
			@_ERR_CATEGORY_NOT_EXIST INT = -25,
			@_IsActive INT = 0,
			@_Id_In INT = 0
	SELECT @_Id_In = Id,
			@_IsActive = [Status]
	FROM [dbo].[tbl_Category]
	WHERE Id = @_Id

	SET @_Id_In = ISNULL(@_Id_In, 0)
	IF (@_Id_In = 0)
	BEGIN
		SET @_ResponseStatus = @_ERR_CATEGORY_NOT_EXIST
		RETURN;
	END

	IF(@_IsActive = 1)
	BEGIN
		SET @_ResponseStatus = @_ERR_CATEGORY_INACTIVE
		RETURN;
	END
	BEGIN TRANSACTION
	BEGIN TRY
		EXEC [dbo].[SP_Articles2Cate_DeleteByCondition] @_CateId = @_Id

		--cap nhat danh muc con thuoc danh muc xoa
		UPDATE [dbo].[tbl_Category]
		SET ParentID = 0
		WHERE ParentID = @_Id

		DELETE FROM [dbo].[tbl_Category]  WHERE Id  = @_Id 

		SET @_ResponseStatus = 1

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @_ResponseStatus = -99;
		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
		-- Insert Log
		EXEC	[dbo].[sp_LogError]				
	END CATCH;
END




GO
/****** Object:  StoredProcedure [dbo].[SP_Category_GetByCategoryID]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Category_GetByCategoryID]
	@_CategoryID INT,
	@_LanguageID INT = 1
AS
BEGIN
	SET NOCOUNT ON

	SELECT C.*, CC.CategoryName, CC.Tags, CC.LanguageID, CC.CategoryContent,
	(SELECT COUNT([Id]) FROM [dbo].[tbl_Category] WHERE [ParentID] = c.[Id]) AS [NextChild]
	FROM tbl_Category C, tbl_CategoryContent CC
	WHERE C.Id = CC.CategoryID
	 AND ([CategoryID] = @_CategoryID ) AND (@_LanguageID = [LanguageID])
	ORDER BY OrderNo
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Category_GetPage]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quocphong.tran
-- Create date: 07/31/2015
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Category_GetPage]
	@_SystemID INT
	,@_LanguageID INT = 1
	,@_ParentID INT = -1
	,@_Keyword NVARCHAR(250) = ''
	,@_Status BIT = NULL
	,@_CurrPage INT = 1
	,@_RecordPerPage INT = 30
	,@_TotalRecord INT OUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @_CurrPage = ISNULL(@_CurrPage, 1)
	SET @_RecordPerPage = ISNULL(@_RecordPerPage, 10)
	SET @_TotalRecord = 0
	DECLARE @_Start INT = (((@_CurrPage-1) * @_RecordPerPage)+1)
	DECLARE @_End INT =   @_Start + @_RecordPerPage-1

	SELECT * INTO #Temp
	  FROM (
		SELECT ROW_NUMBER() OVER(ORDER BY Id DESC) AS STT,
		C.*, CC.CategoryName, CC.Tags, CC.LanguageID, CC.CategoryContent,
		(SELECT COUNT([Id]) FROM [dbo].[tbl_Category] WHERE [ParentID] = c.[Id]) AS [NextChild]
		FROM tbl_Category C, tbl_CategoryContent CC
		WHERE C.Id = CC.CategoryID
		  AND (ISNULL(@_SystemID,0) = 0 OR C.SystemID = @_SystemID)
		  AND (ISNULL(@_ParentID,0) = 0 OR ParentID = @_ParentID)
		  AND (ISNULL(@_LanguageID,0) = 0 OR ISNULL(LanguageID, 1) = @_LanguageID)
		  AND (ISNULL(@_Keyword,'') = '' OR CC.CategoryName Like '%' + @_Keyword + '%')
		  AND (@_Status IS NULL OR [Status] = @_Status)
	) As Tmp

	SELECT @_TotalRecord = (SELECT COUNT(STT) FROM #Temp) 

	SELECT * From #Temp 
	WHERE STT BETWEEN @_Start AND @_End
	ORDER BY OrderNo
END




GO
/****** Object:  StoredProcedure [dbo].[SP_Category_GetRow]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Category_GetRow]
	@_SystemID INT = 0
	,@_LanguageID INT = 1
	,@_ParentID INT = 0
	,@_CategoryID INT = 0
	,@_Status BIT = NULL
AS
BEGIN
	SET NOCOUNT ON

	SELECT C.*, CC.CategoryName, CC.Tags, CC.LanguageID, CC.CategoryContent,
	(SELECT COUNT([Id]) FROM [dbo].[tbl_Category] WHERE [ParentID] = c.[Id]) AS [NextChild]
	FROM tbl_Category C, tbl_CategoryContent CC
	WHERE C.Id = CC.CategoryID
	  AND (ISNULL(@_SystemID,0) = 0 OR C.SystemID = @_SystemID)
	  AND (ISNULL(@_CategoryID,0) = 0 OR C.Id = @_CategoryID)
	  AND (ISNULL(@_ParentID,0) = 0 OR ParentID = @_ParentID)
	  AND (ISNULL(@_LanguageID,0) = 0 OR LanguageID = @_LanguageID)
	  AND (@_Status IS NULL OR [Status] = @_Status)
	ORDER BY OrderNo, Id
END

SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [dbo].[SP_Category_GetTree]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Category_GetTree]
	@_SystemID Varchar(50) = ''
	,@_LanguageID INT = 1
	,@_ParentID INT = 0
	,@_Status BIT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	WITH MenuCTE 
	AS
	(
		-- Anchor member
		SELECT Id, ParentID, Alias, OrderNo, Status, ImageUrl, 
		SystemID, 0 AS TreeLevel, CAST(OrderNo AS VARCHAR(255)) AS TreePath
		FROM [dbo].[tbl_Category]
		WHERE (ISNULL(@_ParentID, 0) = 0 OR [ParentID] = @_ParentID)
		AND (ISNULL(@_SystemID,'') = '' OR SystemID in (Select Value FROM [dbo].[FN_Parameters_Split](@_SystemID,',')))
		AND (@_Status IS NULL OR [Status] = @_Status)
		UNION ALL

		-- Recursive member
		SELECT m.Id, m.[ParentID],  m.Alias, m.OrderNo, m.Status, m.ImageUrl,
		m.SystemID, TreeLevel + 1 AS TreeLevel, CAST(TreePath + '.' + CAST(m.OrderNo AS VARCHAR(255)) AS VARCHAR(255)) AS TreePath
		FROM [dbo].[tbl_Category] AS m
		INNER JOIN MenuCTE AS mc ON CAST(m.[ParentID] AS INT) = mc.Id
		WHERE (ISNULL(@_SystemID,'') = '' OR m.SystemID in (Select Value FROM [dbo].[FN_Parameters_Split](@_SystemID,',')))
		AND (@_Status IS NULL OR m.[Status] = @_Status)
	)
	SELECT Id, [ParentID], cc.CategoryName, Alias, OrderNo, [Status],CC.Tags, CC.LanguageID, ImageUrl, SystemID, cc.CategoryContent,
	Replicate('.', TreeLevel * 4)+ cc.CategoryName Tree, TreeLevel, TreePath
	FROM MenuCTE c
		INNER JOIN [dbo].tbl_CategoryContent AS cc ON c.Id = cc.CategoryID
		WHERE (ISNULL(@_LanguageID,0) = 0 OR LanguageID = @_LanguageID)
		ORDER BY TreePath, OrderNo;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Category_InsertUpdate]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Category_InsertUpdate]
	@_SystemID		INT
	,@_ParentID		INT = 0
	,@_CategoryID	INT
	,@_Alias NVARCHAR(250) = ''
	,@_CategoryNameVi NVARCHAR(50)
	,@_CategoryNameEn NVARCHAR(50)
	,@_CategoryContentVi NVARCHAR(500) = ''
	,@_CategoryContentEn NVARCHAR(500) = ''
	,@_ImageUrl varchar(250) = ''
	,@_Status BIT = 1
	,@_CreatedUser VARCHAR(50) = NULL
	,@_ModifyUser Varchar(50) = NULL
	,@_ResponseStatus INT OUT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @_SYSTEM_ERROR INT = -99,
			@_RESPONSE_SUCCESS INT = 1,
			@_RESPONSE_EXISTED_CATE INT = -2,
			@_RESPONSE_NOT_EXISTS_CATE INT = -3,
			@_RESPONSE_PARAM_INVALID INT = -600
	SET @_ResponseStatus = @_SYSTEM_ERROR
	
	BEGIN TRY
		BEGIN  TRANSACTION; 
		--Id = 0 -> Insert <> UPDATE
		IF (ISNULL(@_CategoryID,0) = 0) -- Insert
		BEGIN
			DECLARE @_nHotOrder int;

			SELECT @_nHotOrder = MAX(OrderNo) 
			FROM [dbo].[tbl_Category] 
			WHERE [ParentID]=@_ParentId

			SET @_nHotOrder = ISNULL(@_nHotOrder, 0)
				INSERT INTO	dbo.[tbl_Category]	(
					[ParentID],
					[Alias],
					[OrderNo],
					[Status],
					[CreatedDate],
					[CreatedUser],
					SystemID,
					ImageUrl
				)
				VALUES	(
					ISNULL(@_ParentID, 0),
					@_Alias,
					@_nHotOrder+1,
					@_Status,
					GETDATE(),
					@_CreatedUser,
					@_SystemID,
					@_ImageUrl

				)

				SET @_CategoryID = @@Identity
				INSERT INTO tbl_CategoryContent
						(CategoryID
						,CategoryName
						,CategoryContent
						,LanguageID)
				VALUES  (@_CategoryID
						,@_CategoryNameVi
						,@_CategoryContentVi
						,1)
				INSERT INTO tbl_CategoryContent
						(CategoryID
						,CategoryName
						,CategoryContent
						,LanguageID)
				VALUES  (@_CategoryID
						,@_CategoryNameEn
						,@_CategoryContentEn
						,2)
			END
		ELSE BEGIN
			IF(NOT EXISTS(SELECT 1 FROM dbo.[tbl_Category] WHERE Id = @_CategoryID))
			BEGIN
				SET @_ResponseStatus =	@_RESPONSE_NOT_EXISTS_CATE
				RETURN;
			END
			ELSE BEGIN
				UPDATE	dbo.[tbl_Category]
				SET	[ParentID]		=	ISNULL(@_ParentID, [ParentID]),
					[Alias]		=	ISNULL(@_Alias, [Alias]),
					[ImageUrl]	=	ISNULL(@_ImageUrl,[ImageUrl]),
					[Status]	=	ISNULL(@_Status, [Status]),
					[ModifyUser] = @_CreatedUser,
					[ModifyDate] = getdate(),
					SystemID = ISNULL(@_SystemID,SystemID)
				WHERE
					Id			=	@_CategoryID

				IF EXISTS(SELECT * FROM tbl_CategoryContent WHERE CategoryID = @_CategoryID AND LanguageID = 1)
				BEGIN
					UPDATE tbl_CategoryContent
					SET  CategoryName = @_CategoryNameVi,
						 CategoryContent = @_CategoryContentVi
					WHERE CategoryID = @_CategoryID
					  AND LanguageID = 1
				END
				IF EXISTS(SELECT * FROM tbl_CategoryContent WHERE CategoryID = @_CategoryID AND LanguageID = 2)
				BEGIN
					UPDATE tbl_CategoryContent
					SET  CategoryName = @_CategoryNameEn,
						 CategoryContent = @_CategoryContentEn
					WHERE CategoryID = @_CategoryID
					  AND LanguageID = 2
				END
			END
		END

		SET @_ResponseStatus = @_CategoryID	
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0) BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = -99
			EXECUTE [dbo].[SP_LogError];
		END
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Category_UpdateSortOrder]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[SP_Category_UpdateSortOrder]
	 @_CategoryID INT
	,@_UpOrder BIT
AS
BEGIN
	DECLARE @NearCategoryID INT = 0;
	DECLARE @NearOrder INT = 1;
	DECLARE @CurrentOrder INT;
	DECLARE @ParentID INT;
	
	SELECT @CurrentOrder = OrderNo, @ParentID = ParentID 
	FROM tbl_Category WHERE Id = @_CategoryID
	
	IF (ISNULL(@_UpOrder, 0) = 1) -- up sort order
	BEGIN
		SELECT   TOP 1 
				 @NearCategoryID = Id 
				,@NearOrder = OrderNo
		FROM tbl_Category
		WHERE OrderNo > @CurrentOrder AND ParentID = @ParentID
	END
	ELSE BEGIN
		SELECT   TOP 1 
				 @NearCategoryID = Id 
				,@NearOrder = OrderNo
		FROM tbl_Category
		WHERE OrderNo < @CurrentOrder AND ParentID = @ParentID
		ORDER BY OrderNo DESC
	END
	
	BEGIN TRY
		BEGIN TRANSACTION
			
			UPDATE tbl_Category
			SET OrderNo = @NearOrder
			WHERE Id = @_CategoryID
			
			UPDATE tbl_Category
			SET OrderNo = @CurrentOrder
			WHERE Id = @NearCategoryID
			
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH	
		ROLLBACK TRANSACTION;
		EXEC	[dbo].[sp_LogError];
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Category_UpdateStatus]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Category_UpdateStatus]
	@_Id int,
	@_ResponseStatus INT OUT
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @_SYSTEM_ERROR INT = -99,
			@_RESPONSE_SUCCESS INT = 1,
			@_RESPONSE_EXISTED_CATE INT = -2,
			@_RESPONSE_NOT_EXISTS_CATE INT = -3,
			@_RESPONSE_PARAM_INVALID INT = -600
	SET @_ResponseStatus = @_SYSTEM_ERROR
	DECLARE @_Status int;
	
	IF(NOT EXISTS(select 1 from [dbo].[tbl_Category] Where Id = @_Id))
	BEGIN
		SET @_ResponseStatus = @_RESPONSE_NOT_EXISTS_CATE
		RETURN;
	END

	SELECT @_Status = [Status] FROM [dbo].[tbl_Category] WHERE [Id] = @_Id;
	IF(@_Status = 1)
		SET @_Status = 0;
	ELSE
		SET @_Status = 1;

	BEGIN TRY
		BEGIN  TRANSACTION; 

		UPDATE [dbo].[tbl_Category] 
		SET [Status] = @_Status
		WHERE [Id] = @_Id

		SET @_ResponseStatus = @_Id	
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0) BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = -99
			EXECUTE [dbo].[SP_LogError];
		END
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ErrorLog_Delete]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ErrorLog_Delete]
	 @FromDate DateTime =null
	,@ToDate DateTime =null
	,@ErrorCode	int OUTPUT
AS
BEGIN
	SET NOCOUNT, XACT_ABORT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DELETE FROM ErrorLog 
		WHERE 
			(@FromDate IS NULL OR ErrorTime>=@FromDate )
			AND
			(@ToDate IS NULL OR ErrorTime <= @ToDate)
		SET @ErrorCode = 0
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @ErrorCode = -99;
		IF XACT_STATE() = -1 
			BEGIN
				-- Rollback
				ROLLBACK TRANSACTION;
				-- Insert Log
				EXEC	[dbo].[SP_LogError] 
						@ErrorCode = @ErrorCode OUTPUT
			END
		IF (XACT_STATE() = 1) COMMIT TRANSACTION;
	END CATCH
END







GO
/****** Object:  StoredProcedure [dbo].[SP_ErrorLog_GetPage]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_ErrorLog_GetPage]
	-- ADD THE PARAMETERS FOR THE STORED PROCEDURE HERE
		 @FromDate DATETIME =NULL
		,@ToDate DATETIME =NULL
		,@PageNumber INT
		,@PaSize INT
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @CONDITION NVARCHAR(MAX)
	DECLARE @START INT, @END INT
	BEGIN TRANSACTION GETDATASET
		SET @CONDITION=''
		SET @SQL=''
		SET @START = (((@PageNumber - 1) * @PaSize) + 1)
		SET @END = (@START + @PaSize - 1)
		SET @SQL = ' DECLARE  @TEMPORARYTABLE TABLE (
			ID INT IDENTITY(1,1) PRIMARY KEY,
			[ErrorLogID] INT,
			[ErrorTime] DATETIME,
			[UserName] NVARCHAR(50),
			[HostName] NVARCHAR (100),
			[ErrorNumber] INT,
			[ErrorCode] INT,
			[ErrorSeverity] INT ,
			[ErrorState] INT,
			[ErrorProcedure] NVARCHAR (100),
			[ErrorLine] INT,
			[ErrorMessage] NVARCHAR(1000) )		
			DECLARE @COUNTER INT'
		SET @SQL=@SQL+' INSERT INTO @TEMPORARYTABLE
						SELECT ErrorLogID
							  ,ErrorTime
							  ,UserName
							  ,HostName
							  ,ErrorNumber
							  ,ErrorCode
							  ,ErrorSeverity
							  ,ErrorState
							  ,ErrorProcedure
							  ,ErrorLine
							  ,	ErrorMessage			 
						FROM ErrorLog WHERE ERRORLOGID >= 0 '
		IF(@FROMDATE IS NOT NULL)
					SET @CONDITION=@CONDITION +' AND ErrorTime>= '''  +   CONVERT(NVARCHAR,  @FROMDATE, 0)  + '''' 
		           			 
				IF(@TODATE IS NOT NULL)
					SET @CONDITION=@CONDITION +' AND  ErrorTime<= '''  +   CONVERT(NVARCHAR,  @TODATE, 0)  + '''' 
					
				SET @CONDITION=@CONDITION + 'ORDER BY ErrorLogID DESC'
		
		SET @SQL=@SQL+@CONDITION
		SET @SQL= @SQL +' SELECT @COUNTER = COUNT(*) FROM @TEMPORARYTABLE  	
						  SELECT TOP ('+CAST(@PaSize AS VARCHAR(10)) +') 
							  ErrorLogID
							  ,ErrorTime
							  ,UserName
							  ,HostName
							  ,ErrorNumber
							  ,ErrorCode
							  ,ErrorSeverity
							  ,ErrorState
							  ,ErrorProcedure
							  ,ErrorLine
							  ,ErrorMessage
							  ,@COUNTER AS Counter
						  FROM @TEMPORARYTABLE
						  WHERE (ID >='+CAST(@START AS VARCHAR(10))+') AND (ID <= '+CAST(@END AS VARCHAR(10))+')
						  DELETE FROM @TEMPORARYTABLE'
			--PRINT (@SQL)
			EXEC SP_EXECUTESQL @SQL
			IF @@ERROR <> 0
				GOTO ERRORHANDLER	
			COMMIT TRANSACTION GETDATASET
		RETURN 0
		ERRORHANDLER:
		ROLLBACK TRANSACTION GETDATASET
	RETURN @@ERROR
END



	--SELECT * FROM ERRORLOG 
	--WHERE (@FROMDATE IS NULL OR ERRORTIME>=@FROMDATE )AND(@TODATE IS NULL OR ERRORTIME <= @TODATE)
	--ORDER BY ERRORTIME ASC
	--END









GO
/****** Object:  StoredProcedure [dbo].[sp_get_version_info]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_version_info]
	-- Add the parameters for the stored procedure here
	@_os varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT id, os, link_store, version, last_version, is_maintain, message_maintain, version_display
	FROM [dbo].[VersionMobile]
	WHERE os = @_os

END
GO
/****** Object:  StoredProcedure [dbo].[SP_GetFAQ_ByCate]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetFAQ_ByCate]
	-- Add the parameters for the stored procedure here
	@_CateId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM [dbo].[FAQ_Mobile_Sub] WHERE category_id = @_CateId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LogError]    Script Date: 7/23/2020 3:13:57 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_LogErrorPrint]    Script Date: 7/23/2020 3:13:57 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_NewsTag_DeleteByNewsId]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_NewsTag_DeleteByNewsId]
	-- Add the parameters for the stored procedure here
	@_NewsId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [dbo].[NewsTag]
      WHERE [NewId] = @_NewsId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_NewsTag_Insert]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_NewsTag_Insert]
	-- Add the parameters for the stored procedure here
	@_TagId int = 0,
	@_TagContent NVARCHAR(MAX) = NULL,
	@_NewsId int,
    @_ResponseCode INT OUTPUT          
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY 	
		BEGIN TRANSACTION
    -- Insert statements for procedure here
		IF NOT EXISTS (SELECT * FROM NewsTag WHERE [NewId] = @_NewsId AND TagId = @_TagId)
		BEGIN
			INSERT INTO [dbo].[NewsTag]
			   ([NewId]
			   ,[TagId]
			   ,TagContent)
			VALUES
			   (@_NewsId
			    ,@_TagId			   
			   ,@_TagContent
			  )
			SET @_ResponseCode = @@IDENTITY;
		END
		ELSE BEGIN
			SET @_ResponseCode = -9;
		END
		COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH	
		ROLLBACK TRANSACTION;
		SET @_ResponseCode=-99;
		EXEC	[dbo].[sp_LogError]	@_ResponseCode;
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SplitToTableWithMultiColumn]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		DungTD
-- Create date:	<04/11/2015>
-- Description: Cat chuoi thanh bang voi nhieu column
-- =============================================
CREATE PROC [dbo].[SP_SplitToTableWithMultiColumn] 
(
	@Split NVARCHAR(max),
	@Delimiter1 VARCHAR(1),
	@Delimiter2 VARCHAR(1)
)
as
SET @Split = RTRIM(LTRIM(@Split));

DECLARE @count INT
DECLARE @tblSplit TABLE(ID INT, Value NVARCHAR(500))
DECLARE @spl NVARCHAR(MAX) = '';

INSERT INTO @tblSplit ( ID, Value )
SELECT [Index], [Value] FROM [dbo].[FN_Parameters_Split](@Split, @Delimiter1)
SET @count = @@ROWCOUNT

WHILE @count > 0
BEGIN
	DECLARE @Value NVARCHAR(500), @ID INT
	SELECT TOP 1 @ID = ID, @Value = Value FROM @tblSplit
	IF @count > 1
		SET @spl = @spl + 'SELECT ' + '''' + REPLACE(@Value, @Delimiter2, '''' + @Delimiter2 + '''') + '''' + ' UNION ALL '
	ELSE
		SET @spl = @spl + 'SELECT ' + '''' + REPLACE(@Value, @Delimiter2, '''' + @Delimiter2 + '''') + ''''
	DELETE FROM @tblSplit WHERE ID = @ID
	SET @count = @count - 1
END

EXEC sp_executesql @spl







GO
/****** Object:  StoredProcedure [dbo].[SP_System_SelectAll]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		cuongbx
-- Create date: 11/09/2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_System_SelectAll]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [dbo].[tbl_System]
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Tag_Delete]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Tag_Delete]
	 @_TagId INT
	,@_ResponseStatus INT OUTPUT
AS
BEGIN
    SET NOCOUNT,XACT_ABORT ON ;
	DECLARE @_SUCCESSFUL  INT = 1;
	DECLARE @_ERR_NOT_EXIST_TAG  INT = -1;
	DECLARE @_ERR_INVALID_PARAM INT = -600;
	DECLARE @_ERR_UNKNOW INT = -99;


	IF(@_TagId = 0) 
	BEGIN
		SET @_ResponseStatus = @_ERR_INVALID_PARAM
		RETURN;
	END
	IF (NOT EXISTS(SELECT 1 FROM [dbo].[Tag] WHERE [TagId] = @_TagId))
	BEGIN
		SET @_ResponseStatus = @_ERR_NOT_EXIST_TAG;
		RETURN;
	END
	BEGIN TRANSACTION
	BEGIN TRY 
			DELETE [dbo].[Tag] WHERE [TagId] = @_TagId
							
			SET @_ResponseStatus = @_SUCCESSFUL		
	COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH
		IF (XACT_STATE()) = -1 
		BEGIN
			ROLLBACK TRANSACTION;
			SET @_ResponseStatus = @_ERR_UNKNOW;
			EXECUTE [dbo].[SP_LogError];
			RETURN;
		END
		IF (XACT_STATE()) = 1 COMMIT TRANSACTION;		
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Tag_GetById]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Tag_GetById] 
	-- Add the parameters for the stored procedure here
	@_TagId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from Tag where TagId = @_TagId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Tag_GetListByCondition]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Tag_GetListByCondition]
	-- Add the parameters for the stored procedure here
	@_SystemID INT = 0
	,@_TagKey nvarchar(250) = ''
	,@_TagName nvarchar(250) = ''
	,@_TagId INT = 0
	,@_Status BIT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT * FROM Tag 
	WHERE (ISNULL(@_SystemID,0) = 0 OR SystemID = @_SystemID)
	AND (ISNULL(@_TagId,0) = 0 OR TagId = @_TagId)
	AND (ISNULL(@_TagKey,'') = '' OR TagKey = @_TagKey)
	AND (ISNULL(@_TagName,'') = '' OR TagName like N'%' + @_TagName + N'%')
	AND (@_Status IS NULL OR [Status] = @_Status)
	ORDER BY TagId, CreatedDate desc
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Tag_GetListByNewId]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Tag_GetListByNewId]
	-- Add the parameters for the stored procedure here
	@_NewsId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Tag.*,
		NewsTag.[NewId]
	FROM NewsTag
	INNER JOIN Tag ON NewsTag.TagId = Tag.TagId
	WHERE NewsTag.[NewId] = @_NewsId
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Tag_GetPage]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Tag_GetPage]
	-- Add the parameters for the stored procedure here
	@_SystemID INT = 0
	,@_TagKey nvarchar(250) = ''
	,@_TagName nvarchar(250) = ''
	,@_TagId INT = 0
	,@_Status BIT = NULL
	,@_CurrPage INT = 1
	,@_RecordPerPage INT = 10
	,@_TotalRecord INT = 0 OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @_CurrPage = ISNULL(@_CurrPage, 1)
	SET @_RecordPerPage = ISNULL(@_RecordPerPage, 10)
	SET @_TotalRecord = 0
	DECLARE @_Start INT = (((@_CurrPage-1) * @_RecordPerPage)+1)
	DECLARE @_End INT =   @_Start + @_RecordPerPage-1
    SELECT * INTO #Temp
	  FROM (
		SELECT ROW_NUMBER() OVER(ORDER BY TagId DESC) AS STT,
		* FROM Tag
		WHERE (ISNULL(@_SystemID,0) = 0 OR SystemID = @_SystemID)
			AND (ISNULL(@_TagId,0) = 0 OR TagId = @_TagId)
			AND (ISNULL(@_TagKey,'') = '' OR TagKey = @_TagKey)
			AND (ISNULL(@_TagName,'') = '' OR TagName like N'%' + @_TagName + N'%')
			AND (@_Status IS NULL OR [Status] = @_Status)		
	) As Tmp


	SELECT @_TotalRecord = (SELECT COUNT(STT) FROM #Temp) 

	SELECT * From #Temp 
	WHERE STT BETWEEN @_Start AND @_End
	ORDER BY TagId, CreatedDate desc
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Tag_InsertUpdate]    Script Date: 7/23/2020 3:13:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Tag_InsertUpdate]
	-- Add the parameters for the stored procedure here
	@_TagId int = 0,
	@_TagName nvarchar(250),
	@_TagKey nvarchar(250),
	@_SysTemId int = 0,
    @_CreatedUser varchar(40),
    @_Status int,
    @_ResponseCode INT OUTPUT    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @_ResponseCode = -99;
	IF(ISNULL(@_TagID,0) = 0)
	BEGIN
		IF EXISTS (SELECT * FROM Tag WHERE TagName = @_TagName AND SystemID = @_SysTemId)
		BEGIN
			SET @_ResponseCode = -9; --EXISTS TAGNAME
			RETURN;
		END
		IF EXISTS (SELECT * FROM Tag WHERE TagKey = @_TagKey AND SystemID = @_SysTemId)
		BEGIN
			SET @_ResponseCode = -8; --EXISTS TAGKEY
			RETURN;
		END
	END
	ELSE BEGIN
		IF EXISTS (SELECT * FROM Tag WHERE TagName = @_TagName AND TagId <> @_TagId)
		BEGIN
			SET @_ResponseCode = -9; --EXISTS TAGNAME
			RETURN;
		END
	END
	BEGIN TRY 	
		BEGIN TRANSACTION
    -- Insert statements for procedure here
		IF(ISNULL(@_TagID,0) = 0)
		BEGIN
			IF NOT EXISTS (SELECT * FROM Tag WHERE TagName = @_TagName AND TagKey = @_TagKey AND SystemID = @_SysTemId)
			BEGIN
				INSERT INTO [dbo].[Tag]
					   ([SystemID]
					   ,[TagName]
					   ,[TagKey]
					   ,[Status]
					   ,[CreatedUser]
					   ,[CreatedDate])
				 VALUES
					   (@_SysTemId
					   ,@_TagName
					   ,@_TagKey
					   ,@_Status
					   ,@_CreatedUser
					   ,GETDATE())
				SET @_ResponseCode = @@IDENTITY;
			END
		END
		ELSE BEGIN
			IF NOT EXISTS (SELECT * FROM Tag WHERE TagName = @_TagName AND TagId <> @_TagId)
			BEGIN
				UPDATE [dbo].[Tag]
				   SET [TagName] = ISNULL(@_TagName, TagName)
					  ,[TagKey] = ISNULL(@_TagKey, TagKey)
					  ,[Status] = @_Status
					  ,[CreatedUser] = @_CreatedUser
				WHERE TagId = @_TagId
				SET @_ResponseCode = @_TagId;
			END
		END

		COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH	
		ROLLBACK TRANSACTION;
		SET @_ResponseCode=-99;
		EXEC	[dbo].[sp_LogError]	@_ResponseCode;
	END CATCH; 
END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'--0:thuong, 1: mới, 2: hot, 3:feature(nổi bật)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbl_Articles', @level2type=N'COLUMN',@level2name=N'Type'
GO
USE [master]
GO
ALTER DATABASE [wUtility.Content] SET  READ_WRITE 
GO
```