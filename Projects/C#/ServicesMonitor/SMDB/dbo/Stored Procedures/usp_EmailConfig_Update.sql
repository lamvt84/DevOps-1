
CREATE PROCEDURE dbo.usp_EmailConfig_Update @Id         INT, 
                                            @SenderName VARCHAR(30), 
                                            @ToMail     VARCHAR(50), 
                                            @CCMail     VARCHAR(500), 
                                            @Subject    NVARCHAR(250), 
                                            @Message    NVARCHAR(MAX), 
                                            @ServiceId INT,
                                            @DataSign   VARCHAR(100)
AS
    BEGIN
        UPDATE [dbo].[EmailConfig]
          SET 
              [SenderName] = @SenderName, 
              [ToMail] = @ToMail, 
              [CCMail] = @CCMail, 
              [Subject] = @Subject, 
              [Message] = @Message, 
              [ServiceId] = @ServiceId,
              [DataSign] = @DataSign, 
              [UpdatedTime] = SYSDATETIMEOFFSET()
        WHERE Id = @Id;
    END;