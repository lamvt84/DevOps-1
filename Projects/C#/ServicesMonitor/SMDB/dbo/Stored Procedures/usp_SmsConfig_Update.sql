
CREATE PROCEDURE dbo.usp_SmsConfig_Update @Id       INT,
                                            @AlertConfigId INT,
                                            @AccountName   VARCHAR(30), 
                                            @Mobile   VARCHAR(30), 
                                            @Message  NVARCHAR(130),
                                            @ServiceId INT,
                                            @DataSign VARCHAR(100)
AS
    BEGIN
        UPDATE [dbo].[SmsConfig]
        SET [AccountName] = @AccountName
            ,[AlertConfigId] = @AlertConfigId
            ,[Mobile] = @Mobile
            ,[Message] = @Message
            ,[ServiceId] = @ServiceId
            ,[DataSign] = @DataSign          
            ,[UpdatedTime] = SYSDATETIMEOFFSET()
        WHERE Id = @Id;
    END;