CREATE PROCEDURE [dbo].[usp_Groups_Update] @Id          INT, 
                                           @Name        VARCHAR(100), 
                                           @Description VARCHAR(500)
AS
     UPDATE dbo.Groups
       SET 
           Name = @Name, 
           Description = @Description, 
           UpdatedTime = SYSDATETIMEOFFSET()
     WHERE Id = @Id;