------------------------------------------------------------------------------------------------------------
-- VISTE CREAZIONE DATE RANGE

create view [bi].[vExchangeRateDbwin_step1]
as
select
	[cod_divisa]
	,[cod_divisa_inc]
	,[data_cambio]
	,[coeff_cambio] as ExchangeRate
	,row_number() over (partition by [cod_divisa],[cod_divisa_inc] 
						order by [data_cambio] ) as RN
from [DbWin_dw].[vicini].[wl0_tbdivcambi]
where cod_divisa = 'EUR'
GO


CREATE view [bi].[vExchangeRateDbwin]
as
select --calcolo del range di validità DateFrom-DateTo 
		s1.cod_divisa
		,s1.cod_divisa_inc
		,s1.ExchangeRate
		,s1.data_cambio as DateFrom
		,DATEADD (day , -1 ,isnull(s2.data_cambio,dateadd(dd, +1, getdate()))) as DateTo
from [bi].[vExchangeRateDbwin_step1] s1
left outer join [bi].[vExchangeRateDbwin_step1] s2
	on s1.cod_divisa = s2.cod_divisa
	and s1.cod_divisa_inc = s2.cod_divisa_inc
and s1.RN = s2.RN-1
