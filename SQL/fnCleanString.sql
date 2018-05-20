/*
    Unicode & ASCII are the same from 1 to 255
    Only Unicode goes beyond 255
    0 to 31 are non-printable characters
*/

CREATE FUNCTION RemoveNonASCII
(
    @nstring nvarchar(255)
)
RETURNS varchar(255)
AS
BEGIN

    DECLARE @Result varchar(255)
    DECLARE @position int
    DECLARE @nchar nvarchar(1)

    SET @Result = ''
    SET @position = 1
    
    WHILE @position <= LEN(@nstring)
    BEGIN

      SET @nchar = SUBSTRING(@nstring, @position, 1)
      IF UNICODE(@nchar) between 32 and 255
          SET @Result = @Result + @nchar

      SET @position = @position + 1
    END

RETURN @Result
END

GO

---------------------------------------------------


CREATE FUNCTION [dbo].[udfTrim] 
(
	@StringToClean as nvarchar(MAX)
)
RETURNS nvarchar(MAX)
AS
BEGIN	
	--Replace all non printing whitespace characers with Characer 32 whitespace
	--SPACE
	Set @StringToClean = Replace(@StringToClean,CHAR(32),CHAR(32));
	--NULL
	Set @StringToClean = Replace(@StringToClean,CHAR(0),CHAR(32));
	--Back Space
	Set @StringToClean = Replace(@StringToClean,CHAR(8),CHAR(32));
	--Horizontal Tab
	Set @StringToClean = Replace(@StringToClean,CHAR(9),CHAR(32));
	--Line Feed
	Set @StringToClean = Replace(@StringToClean,CHAR(10),CHAR(32));
	--Vertical Tab
	Set @StringToClean = Replace(@StringToClean,CHAR(11),CHAR(32));
	--Form Feed
	Set @StringToClean = Replace(@StringToClean,CHAR(12),CHAR(32));
	--Carriage Return
	Set @StringToClean = Replace(@StringToClean,CHAR(13),CHAR(32));
	--Column Break
	Set @StringToClean = Replace(@StringToClean,CHAR(14),CHAR(32));
	--Non-breaking space
	Set @StringToClean = Replace(@StringToClean,CHAR(160),CHAR(32));
	
 
	Set @StringToClean = LTRIM(RTRIM(@StringToClean));
	Return @StringToClean
END



