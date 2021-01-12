CREATE PROCEDURE [dbo].[usp_Users_UpdateStatus] @Id INT
AS
     UPDATE dbo.Users
       SET 
           Status = CASE
                        WHEN Status = 0
                        THEN 1
                        ELSE 0
                    END, 
           UpdatedTime = SYSDATETIMEOFFSET()
     WHERE Id = @Id;