CREATE PROCEDURE [dbo].[usp_Groups_Add] @Name        VARCHAR(100), 
                                        @Description VARCHAR(500)
AS
     INSERT INTO [dbo].[Groups]
     ([Name], 
      [Description]
     )
     VALUES
     (@Name, 
      @Description
     );