CREATE PROCEDURE [dbo].[usp_Groups_Update] @Id          INT, 
                                           @GroupTypeId    INT,
                                           @Name        VARCHAR(100), 
                                           @Description VARCHAR(500)
AS
     UPDATE dbo.Groups
       SET 
           Name = @Name, 
           Description = @Description, 
           GroupTypeId = @GroupTypeId,
           UpdatedTime = SYSDATETIMEOFFSET()
     WHERE Id = @Id;