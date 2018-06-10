/*
  Parametro di input: ANNO
  La funzione restituisce il giorno di pasqua di quell'anno
*/

CREATE FUNCTION [dbo].[fnEaster]  
(
  @YearVal int
)
RETURNS datetime
AS
BEGIN

  DECLARE @EasterDate datetime 
  DECLARE @a int,
  @b int,
  @c int,
  @d int,
  @e int,
  @f int,
  @g int,
  @h int,
  @j int,
  @m int,
  @k int,
  @mth int,
  @dy int,
  @easter datetime

  set @a = @yearval - (floor(@yearval/19) * 19)
  set @b = floor(@yearval/100)
  set @c = @yearval - (@b * 100)
  set @d = floor(@b/4)
  set @e = @b - (@d * 4)
  set @f = floor(@c/4)
  set @g = @c - (@f*4)
  set @h = floor(((8 * @b) + 13)/25)
  set @j = ((19 * @a) + (@b - @d - @h) + 15) - (floor(((19 * @a) + (@b - @d - @h) + 15)/30) * 30)
  set @m = floor((@a + 11 * @j)/319)
  set @k = ((2 * @e) + (2 * @f) - @g - @j + @m + 32) - (floor(((2 * @e) + (2 * @f) - @g - @j + @m + 32)/7) * 7)
  set @mth = floor((@j - @m + @k + 90)/25)
  set @dy = (@j - @m + @k + 19 + @mth) - (floor((@j - @m + @k + 19 + @mth) /32) * 32)

  set @easter = convert(datetime, str(@yearval) + '-' + str(@mth) + '-' + str(@dy), 120)

  if datepart(dw, @easter) = 1
    begin
      select @easterdate = @easter
    end
  else
    begin
      select @easterdate = dateadd(d, 8 - datepart(dw, @easter), @easter)
    end
    
RETURN @EasterDate
END
GO

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
/*
Test della funzione:

DECLARE @result nvarchar(20)= NULL;
EXEC @result = dbo.[fnEasterSunday] @YearVal= 2020;
PRINT @result;
*/

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
/*
Per inserire i valori Pasqua + Pasquetta in una tabella dopo aver impostato i parametri: 

insert into dbo.Easter
select
  cast (dbo.[fnEasterSunday] ( 201 ) as Date) as [Data]
  ,'Pasqua' as Giorno

insert into dbo.Easter
select
  DATEADD (day , 1 , cast (dbo.[fnEasterSunday] ( 2019 ) as Date)) as [Data]
  ,'Pasquetta' as Giorno
*/
