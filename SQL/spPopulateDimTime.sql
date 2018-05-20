
-- Create DimTime Table

CREATE TABLE [dbo].[DimTime]
(
  [idTime] [int] IDENTITY(1,1) NOT NULL,
  [Date] [date] NOT NULL,

  [DayName] [nvarchar](20) NOT NULL,
  [DayWeekNumber] [smallint] NOT NULL,
  [DayMonthNumber] [smallint] NOT NULL,
  [DayYearNumber] [smallint] NOT NULL,

  [WeekNumber] [smallint] NOT NULL,

  [MonthNumber] [smallint] NOT NULL,
  [MonthName] [nvarchar](20) NOT NULL,

  [QuarterNumber] [smallint] NOT NULL,
  [QuarterName] [nvarchar](20) NOT NULL,

  [FourMonthNumber] [smallint] NOT NULL,
  [FourMonthName] [nvarchar](20) NOT NULL,

  [SemesterNumber] [smallint] NOT NULL,
  [SemesterName] [nvarchar](20) NOT NULL,

  [Year] [smallint] NOT NULL,
  [YearMonth] [int] NOT NULL,

CONSTRAINT [PK_DimDate_Date] PRIMARY KEY CLUSTERED
(
[Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Stored Procedure pPopulateDimTime:
-- dbo.pPopolaDimTime 112, 'Italian', 20100101, 20101231

CREATE procedure [dbo].[spPopulateDimTime] (
  @dateFormat as smallint
  ,@language as varchar(50)
  ,@minDate int
  ,@maxDate int
)

AS
BEGIN

--Set the language
  if @language = 'Italian' SET LANGUAGE Italian
  else if @language = 'us_english' SET LANGUAGE us_english
  else if @language = 'French' SET LANGUAGE French
  else if @language = 'Spanish' SET LANGUAGE Spanish
  else if @language = 'German' SET LANGUAGE German

--Set min & max date
  declare @minDateInsert date
  declare @maxDateInsert date

set @minDateInsert = convert(date , cast(@minDate as varchar(8)))
set @maxDateInsert = convert(date , cast(@maxDate as varchar(8)))



--Inserisci se necessario il sid 0
  set identity_insert dbo.DimTime on
  if (select count(*) from dbo.DimTime where idTime = 0) = 0
  insert into dbo.DimTime (
    [idTime]
    ,[Date]

    ,[DayName]
    ,[DayWeekNumber]
    ,[DayMonthNumber]
    ,[DayYearNumber]

    ,[WeekNumber]

    ,[MonthNumber]
    ,[MonthName]

    ,[QuarterNumber]
    ,[QuarterName]

    ,[FourMonthNumber]
    ,[FourMonthName]

    ,[SemesterNumber]
    ,[SemesterName]

    ,[Year]
    ,[YearMonth]
  )
  values
  (
    0               --idTime int
    ,'1900-01-01'   --Date date

    ,'Undefined'    --dayName
    ,0              --dayWeekNumber
    ,0              --dayMonthNumber
    ,0              --dayYearNumber

    ,0              --weekNumber

    ,0              --monthNumber
    ,'Undefined'    --monthName

    ,0              --quarterNumber
    ,'Undefined'    --quarterName

    ,0              --FourMonthNumber
    ,'Undefined'    --FourMonthName

    ,0              --SemesterNumber
    ,'Undefined'    --SemesterName

    ,0              --Year
    ,0              --YearMonth
  )
  set identity_insert dbo.DimTime off

--Check if dates are consistent
  IF @minDateInsert >= @maxDateInsert
  BEGIN
  raiserror ('Mimimum date greater than maximum date!', 16, 1)
  return
  END

--Delete the dates range
  DELETE 
  FROM dbo.DimTime
  WHERE [Date] between @minDateInsert and @maxDateInsert

--Insert the dates range
  WHILE @minDateInsert <= @maxDateInsert

  BEGIN
  insert into dbo.DimTime (
    [Date]

    ,[DayName]
    ,[DayWeekNumber]
    ,[DayMonthNumber]
    ,[DayYearNumber]

    ,[WeekNumber]

    ,[MonthNumber]
    ,[MonthName]

    ,[QuarterNumber]
    ,[QuarterName]

    ,[FourMonthNumber]
    ,[FourMonthName]

    ,[SemesterNumber]
    ,[SemesterName]

    ,[Year]
    ,[YearMonth]
  )

  select
    @minDateInsert                      --Date

    ,datename(dw, @minDateInsert)       --DayName
    ,datepart(dw, @minDateInsert)       --DayWeekNumber
    ,datepart(dd, @minDateInsert)       --DayMonthNumber
    ,datepart(dy, @minDateInsert)       --DayYearNumber

    ,datepart(wk, @minDateInsert)       --weekYearNumber

    ,datepart(mm, @minDateInsert)       --monthNumber
    ,datename(mm, @minDateInsert)       --monthName

    ,datepart(qq, @minDateInsert)       --quarterNumber
    ,datename(qq, @minDateInsert)
      + '° quarter '
      + datename(yyyy, @minDateInsert)  --quarterName

    ,case
        when datepart(mm, @minDateInsert) between 1 and 4 then 1
        when datepart(mm, @minDateInsert) between 5 and 8 then 2
        when datepart(mm, @minDateInsert) between 9 and 12 then 3
        end                             --FourMonthNumber
    ,case
        when datepart(mm, @minDateInsert) between 1 and 4 then '1° four-month ' + datename(yyyy, @minDateInsert)
        when datepart(mm, @minDateInsert) between 5 and 8 then '2° four-month ' + datename(yyyy, @minDateInsert)
        when datepart(mm, @minDateInsert) between 9 and 12 then '3° four-month ' + datename(yyyy, @minDateInsert)
        end                             --FourMonthName

    ,case
        when datepart(mm, @minDateInsert) between 1 and 6 then 1
        when datepart(mm, @minDateInsert) between 7 and 12 then 2
        end                             --SemesterNumber
    ,case
        when datepart(mm, @minDateInsert) between 1 and 6 then '1° semester ' + datename(yyyy, @minDateInsert)
        when datepart(mm, @minDateInsert) between 7 and 12 then '2° semester ' + datename(yyyy, @minDateInsert)
        end                             --SemesterName

    ,datepart(yyyy, @minDateInsert)     --Year
    ,cast(datename(yyyy, @minDateInsert) 
          + right('100' + datepart(mm, @minDateInsert), 2) as int) --YearMonth

  set @minDateInsert = dateadd(dd, 1, @minDateInsert)

  END

END
GO
