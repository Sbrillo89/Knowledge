/*
  Riceve una stringa con i parametri separati da un carattere.
  Restituisce una tabella da mettere in una "IN"
*/

CREATE FUNCTION [dbo].[fnSplit] (@Parameter varchar(MAX), @Delim char(1) = ',')
RETURNS @Values TABLE
       (
             Parameter varchar(MAX)
       )
AS
BEGIN
       DECLARE @Chrind int
       DECLARE @Piece varchar(MAX)

       SELECT @Chrind = 1
       WHILE @Chrind > 0
       BEGIN
             SELECT @Chrind = CHARINDEX(@Delim, @Parameter)
             
             IF @Chrind  > 0
                    SELECT @Piece = LEFT(@Parameter, @Chrind - 1)
             ELSE
                    SELECT @Piece = @Parameter

             INSERT @Values (Parameter)
             VALUES (CAST(@Piece as varchar(MAX)))

             SELECT @Parameter = RIGHT(@Parameter, LEN(@Parameter) - @Chrind)
             
             IF LEN(@Parameter) = 0
                    BREAK
       END
       
RETURN

END
GO
