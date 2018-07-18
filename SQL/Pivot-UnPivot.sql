-----------------------
-- KNOWN VALUES PIVOT--
-----------------------

select *
from 
(
  select store, week, xCount
  from yt
) src
pivot
(
  sum(xcount)
  for week in ([1], [2], [3])
) piv;

-------------------------
-- DYNAMIC VALUES PIVOT--
-------------------------
DECLARE @cols AS NVARCHAR(MAX),
        @query AS NVARCHAR(MAX)

select @cols = STUFF((SELECT ',' + QUOTENAME(Week) 
                    from yt
                    group by Week
                    order by Week
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

set @query = 'SELECT store,' + @cols + ' from 
             (
                select store, week, xCount
                from yt
            ) x
            pivot 
            (
                sum(xCount)
                for week in (' + @cols + ')
            ) p '

execute(@query);

-----------
--UNPIVOT--
-----------

select u.name, u.subject, u.marks
from student s
unpivot
(
  marks
  for subject in (Maths, Science, English)
) u;
