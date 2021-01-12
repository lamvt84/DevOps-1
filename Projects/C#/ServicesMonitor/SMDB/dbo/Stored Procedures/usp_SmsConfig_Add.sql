CREATE PROCEDURE [dbo].[usp_SmsConfig_Add] @AlertConfigId      INT, 
                                          @AccountName         VARCHAR(30), 
                                          @Mobile  VARCHAR(30), 
                                          @Message          VARCHAR(130), 
                                          @ServiceId INT,
                                          @DataSign       VARCHAR(100)                                         
AS
     INSERT INTO [dbo].[SmsConfig]
           ([AlertConfigId]
           ,[AccountName]
           ,[Mobile]
           ,[Message]
           ,[IsResend]
           ,[ServiceId]
           ,[SmsEmailId]
           ,[LangId]
           ,[DataSign]
           ,[IsEnable])
     VALUES
           (@AlertConfigId
           ,@AccountName
           ,@Mobile
           ,@Message
           ,0
           ,@ServiceId
           ,0
           ,0
           ,@DataSign
           ,1)