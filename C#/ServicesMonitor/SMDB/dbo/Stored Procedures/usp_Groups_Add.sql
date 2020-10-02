CREATE PROCEDURE [dbo].[usp_Groups_Add] @Tag           VARCHAR(10),
                                        @Name        VARCHAR(100), 
                                        @Description VARCHAR(500)
AS
     INSERT INTO [dbo].[Groups]
     ([Tag], 
      [Name], 
      [Description]
     )
     VALUES
     (@Tag, 
      @Name, 
      @Description
     );