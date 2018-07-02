/*
  Estrazione della data da Anno-Settimana

*/

select
  tab.[Anno]
  ,tab.[Settimana]
  
  ,cast(DATEADD(wk, DATEDIFF(wk, 7, CAST(tab.[Anno] AS NVARCHAR(100))) + (tab.[Settimana]-1), 7) as date) as [Date]

from [dbo].[DimTime] tab
