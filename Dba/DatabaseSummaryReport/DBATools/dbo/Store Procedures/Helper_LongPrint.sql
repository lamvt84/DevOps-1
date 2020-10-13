CREATE PROCEDURE [Helper_LongPrint](@string NVARCHAR(MAX))
AS
     SET NOCOUNT ON;
     SET @string = RTRIM(@string);
     DECLARE @cr CHAR(1), @lf CHAR(1);
     SET @cr = CHAR(13);
     SET @lf = CHAR(10);
     DECLARE @len INT, @cr_index INT, @lf_index INT, @crlf_index INT, @has_cr_and_lf BIT, @left NVARCHAR(4000), @reverse NVARCHAR(4000);
     SET @len = 4000;
     WHILE(LEN(@string) > @len)
         BEGIN
             SET @left = LEFT(@string, @len);
             SET @reverse = REVERSE(@left);
             SET @cr_index = @len - CHARINDEX(@cr, @reverse) + 1;
             SET @lf_index = @len - CHARINDEX(@lf, @reverse) + 1;
             SET @crlf_index = CASE
                                   WHEN @cr_index < @lf_index
                                   THEN @cr_index
                                   ELSE @lf_index
                               END;
             SET @has_cr_and_lf = CASE
                                      WHEN @cr_index < @len
                                           AND @lf_index < @len
                                      THEN 1
                                      ELSE 0
                                  END;
             PRINT LEFT(@string, @crlf_index - 1);
             SET @string = RIGHT(@string, LEN(@string) - @crlf_index - @has_cr_and_lf);
         END;
     PRINT @string;