CREATE PROCEDURE [dbo].[usp_EmailConfig_UpdateStatus] @Id           INT, 
                                                      @ResponseCode INT OUTPUT
AS
     UPDATE dbo.EmailConfig
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