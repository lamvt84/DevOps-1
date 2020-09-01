CREATE PROCEDURE [dbo].[usp_Users_UpdateStatus] @Id INT
AS
     UPDATE dbo.Users
       SET 
           STATUS = CASE
                        WHEN STATUS = 0
                        THEN 1
                        ELSE 0
                    END, 
           UpdatedTime = SYSDATETIMEOFFSET()
     WHERE Id = @Id;