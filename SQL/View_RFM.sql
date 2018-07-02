/*
Viste per calcolare le variabili RFM per ciascun cliente.
Input per modello di clusterizzazione.

[ml].[vCCBehaviour_M]:
	Questa vista calcola la variabile Monetary (M)
	(M): 

[ml].[vCCBehaviour_R]:
	Questa vista calcola la variabile Recency (R)
	(R):

[ml].[vCCBehaviour_F]:
	Questa vista calcola la variabile Frequency (F)
	(F):
	
[ml].[vCCBehaviour_RFM]:
	Questa vista aggrega le 3 precedenti.

*/

CREATE VIEW [ml].[vCCBehaviour_M]
as
select 
	f.customerid    			as CustomerID
	,sum(f.SalesNetValueTotalNoTAXLCY)	as Monetary
		
from [dbo].[FactSales] f

left outer join [dbo].[DimCustomer] c
	on f.customerid = c.customerId
where
	1=1
group by 
	f.customerid

-----------------------------------------------------------------------------------------------------

CREATE VIEW [ml].[vCCBehaviour_R]
as
select 
	f.customerid   					as CustomerID 
	,max(salesdate) 				as LastPurchaseDate
	,datediff(mm,max(salesdate),getdate())+1 	as Recency
		  
from [dbo].[FactSales] f

left outer join [dbo].[DimCustomer] c
	on f.customerid = c.customerId

where
	1=1
group by 
	f.customerid

-----------------------------------------------------------------------------------------------------
		  
CREATE VIEW [ml].[vCCBehaviour_F]
as
Select 

n.customerid	as CustomerID 
,n.Numeratore
,d.Denominatore
,cast((cast(n.Numeratore as float) / cast(d.Denominatore as Float)) as numeric(18,4)) as Frequency

from (	--NUMERATORE: Conteggio delle visite dei clienti
	select a.customerid
	,count(*) as Numeratore

	from(
		select    --Seleziono tutte le combinazioni (chiavi) che definiscono la "visita" dei clienti
		f.customerid as CustomerID
		,f.storeid
		,f.salesdate

		from [dbo].[FactSales] f
		left outer join [dbo].[DimCustomer] c
			on f.customerid = c.customerId
		where 
			1=1
		group by 
			f.customerid
			,f.storeid
			,f.salesdate
		) a
	group by a.customerid
	)n

left outer join (  --DENOMINATORE: Numero di mesi trascorsi tra oggi e data del primo acquisto
	select 
		f.customerid   				 as CustomerID 
		,min(salesdate) 			 as FirstPurchaseDate
		,datediff(mm,min(salesdate),getdate())+1 as Denominatore
	from [dbo].[FactSales] f

	left outer join [dbo].[DimCustomer] c
		on f.customerid = c.customerId

	where
		1=1
	group by 
		f.customerid
) d
on n.CustomerID = d.CustomerID

	
-----------------------------------------------------------------------------------------------------
	
CREATE view [ml].[vCCBehaviour_RFM]
as
select
	m.CustomerID			as CustomerID
	,r.Recency			as Recency
	,f.Frequency			as Frequency
	,case
		when m.Monetary < 10 then 0
		else m.Monetary 
		end 			as Monetary

from [ml].[vCCBehaviour_M] m

left outer join [ml].[vCCBehaviour_R] r
	on m.CustomerID = r.CustomerID

left outer join [ml].[vCCBehaviour_F] f
	on m.CustomerID = f.CustomerID

where r.recency is not NULL
