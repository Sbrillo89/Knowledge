/*
	più compatta
*/

SELECT 
	  DataareaId as DataAreaCod
	, ItemId as ProductCod
	, CAST(InventDate as date) as StartInventDate
	, LEAD(DATEADD(dd, -1, CAST(InventDate as date)), 1, '99991231') OVER (PARTITION BY DataareaId, ItemId ORDER BY DataAreaId, ItemId, InventDate) as EndInventDate
	, CAST(AverageCost as money) as AverageCost
FROM [stg].[AX01_bi_inventvalueitem]





/*
Logica per creare le colonne DateFrom - DateTo

[bi].[vExchangeRate_step1]:
	Dalla tabella di partenza aggiungo una colonna con il RowNumber

[bi].[vExchangeRate]:
	Metto in join la Step1 con se stessa, scalando di 1 il rownumber
*/

CREATE view [dbo].[vExchangeRate_step1]
as
Select
	[cod_divisa]			as Currency
	,[cod_divisa_inc]		as CurrencyTo
	,[data_cambio]			as ExchangeRateDate
	,[coeff_cambio] 		as ExchangeRate
	,row_number() over(partition by [cod_divisa] ,[cod_divisa_inc] order by [data_cambio]) as RN
	
from [dbo].[SourceTableName]
where cod_divisa = 'EUR'
GO


CREATE view [dbo].[vExchangeRate]
as
Select
	s1.Currency
	,s1.CurrencyTo
	,s1.ExchangeRate
	,s1.ExchangeRateDate 								as DateFrom
	,DATEADD (day, -1, isnull(s2.ExchangeRateDate,dateadd(dd, +1, getdate()))) 	as DateTo
								  
from [bi].[vExchangeRate_step1] s1
							  
left outer join [bi].[vExchangeRate_step1] s2
	on s1.Currency = s2.Currency
	and s1.CurrencyTo = s2.CurrencyTo					  
	and s1.RN = s2.RN-1
