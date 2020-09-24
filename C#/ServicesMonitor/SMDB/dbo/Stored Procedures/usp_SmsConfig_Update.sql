
CREATE PROCEDURE dbo.usp_SmsConfig_Update @Id       INT, 
                                            @AccountName   VARCHAR(30), 
                                            @Mobile   VARCHAR(30), 
                                            @Message  NVARCHAR(130),
                                            @DataSign VARCHAR(100)
AS
    BEGIN
        UPDATE [dbo].[SmsConfig]
        SET [AccountName] = @AccountName
            ,[Mobile] = @Mobile
            ,[Message] = @Message
            ,[DataSign] = @DataSign          
            ,[UpdatedTime] = SYSDATETIMEOFFSET()
        WHERE Id = @Id;
    END;