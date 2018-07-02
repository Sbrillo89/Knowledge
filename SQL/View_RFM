------------------------------------------------------------------------------------------------------------
-- VISTE CREAZIONE RFM

CREATE VIEW [ml].[vCCBehaviour_M]
as
select 
	f.customerid   as CustomerID 
	   --mam 17/11/2016: azzero la monetary di clienti che ComproRendo e hanno monetary minuscola a causa dei tassi di cambio
	   ,case
			when sum(f.SalesNetValueTotalNoTAXLCY) = 0 then 0
			else sum(f.SalesNetValueTotalNoTAX)
		end as Monetary
from [dbo].[FactSales] f

left outer join [dbo].[DimCustomer] c
	on f.customerid = c.customerId
where
	--FILTRI USATI NEI REPORT 061
		f.[SalesRowTypeCode] = 'RS'
	--FILTRI USATI NEI REPORT 435
		AND f.SalesCausalGroup in ('Bargain','Normal','Event Sale')
		AND f.customerid <> 0
		AND c.customerTypeCode = '01'
group by f.customerid

CREATE VIEW [ml].[vCCBehaviour_R]
as
select 
		f.customerid   as CustomerID 
		,max(salesdate) as LastPurchaseDate
		,datediff(mm,max(salesdate),getdate())+1 as Recency
from [dbo].[FactSales] f

left outer join [dbo].[DimCustomer] c
	on f.customerid = c.customerId

where
	--FILTRI USATI NEI REPORT 061
		f.[SalesRowTypeCode] = 'RS'
	--FILTRI USATI NEI REPORT 435
		AND f.SalesCausalGroup in ('Bargain','Normal','Event Sale')
		AND f.customerid <> 0
		AND c.customerTypeCode = '01'
	--ESCLUSIONE DEI RESI--
	    AND f.SalesNetValueTotalNoTAX > 0 
group by f.customerid

CREATE VIEW [ml].[vCCBehaviour_F]
as
Select 

n.customerid
,n.Numeratore
,d.Denominatore
,cast((cast(n.Numeratore as float) / cast( d.Denominatore as Float)) as numeric(18,4)) as Frequency

from 
(
--NUMERATORE
select a.customerid
,count(*) as Numeratore

from(

select    
	f.customerid as CustomerID
	,f.storeid
	,f.salesdate

from [dbo].[FactSales] f
left outer join [dbo].[DimCustomer] c
	on f.customerid = c.customerId

where 
		--FILTRI USATI NEI REPORT 061
		 f.[SalesRowTypeCode] = 'RS'
		--FILTRI USATI NEI REPORT 435
		AND f.SalesCausalGroup in ('Bargain','Normal','Event Sale')
		AND f.customerid <> 0
		AND c.customerTypeCode = '01'
        AND f.SalesNetValueTotalNoTAX >0 --Escludiamo transazioni di solo reso
group by f.customerid
        ,f.storeid
	    ,f.salesdate
) a

group by a.customerid
)n

left outer join 
(
--DENOMINATORE
select 
		f.customerid   as CustomerID 
		,min(salesdate) as FirstPurchaseDate
		,datediff(mm,min(salesdate),getdate())+1 as Denominatore
from [dbo].[FactSales] f

left outer join [dbo].[DimCustomer] c
	on f.customerid = c.customerId

where
	--FILTRI USATI NEI REPORT 061
		f.[SalesRowTypeCode] = 'RS'
	--FILTRI USATI NEI REPORT 435
		AND f.SalesCausalGroup in ('Bargain','Normal','Event Sale')
		AND f.customerid <> 0
		AND c.customerTypeCode = '01'
	--ESCLUSIONE DEI RESI--
	    AND f.SalesNetValueTotalNoTAX > 0 
group by f.customerid
) d

on n.CustomerID = d.CustomerID

CREATE view [ml].[vCCBehaviour_RFM]
as
select

m.customerid

,r.Recency
,f.Frequency
,case 
		when m.Monetary < 10 then 0
		else m.Monetary 
	end as Monetary

--,f.Denominatore


from [ml].[vCCBehaviour_M] m

left outer join [ml].[vCCBehaviour_R] r
	on m.customerid = r.customerid

left outer join [ml].[vCCBehaviour_F] f
	on m.customerid = f.customerid

where r.recency is not NULL
