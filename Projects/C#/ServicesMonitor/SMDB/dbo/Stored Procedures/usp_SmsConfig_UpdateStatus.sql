CREATE PROCEDURE [dbo].[usp_SmsConfig_UpdateStatus] @Id           INT, 
                                                    @ResponseCode INT OUTPUT
AS
     UPDATE dbo.SmsConfig
       SET 
           IsEnable = CASE
                          WHEN IsEnable = 0
                          THEN 1
                          ELSE 0
                      END, 
           @ResponseCode = CASE
                               WHEN IsEnable = 0
                               THEN 1
                               ELSE 0
                           END, 
           UpdatedTime = SYSDATETIMEOFFSET()
     WHERE Id = @Id;