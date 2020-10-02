CREATE PROCEDURE [dbo].[usp_Groups_Update] @Id          INT, 
                                           @Tag         VARCHAR(10),
                                           @Name        VARCHAR(100), 
                                           @Description VARCHAR(500)
AS
     UPDATE dbo.Groups
       SET 
           Name = @Name, 
           Description = @Description, 
           Tag = @Tag,
           UpdatedTime = SYSDATETIMEOFFSET()
     WHERE Id = @Id;