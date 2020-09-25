CREATE PROCEDURE [dbo].[usp_Groups_Add] @GroupTypeId    INT, 
                                        @Name        VARCHAR(100), 
                                        @Description VARCHAR(500)
AS
     INSERT INTO [dbo].[Groups]
     (GroupTypeId, 
      [Name], 
      [Description]
     )
     VALUES
     (@GroupTypeId, 
      @Name, 
      @Description
     );