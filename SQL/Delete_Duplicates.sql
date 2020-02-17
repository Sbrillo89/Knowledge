/*
  Elimina i duplicati
  Identificare la chiave della tabella con le colonne Col1, Col2.
*/

WITH cte AS (
  SELECT Col1, Col2,
     ROW_NUMBER() OVER(PARTITION BY Col1, Col2 order by Col1) AS [rn]
  FROM [dbo].[Table]
)
--Delete
select *
from cte 
WHERE [rn] > 1
