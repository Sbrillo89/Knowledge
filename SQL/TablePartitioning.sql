/*
La tabella partizionata è una tabella logica che mette assieme N tabelle fisiche uguali.
Le tabelle fisiche possono stare su dischi diversi (o filegroup)
Partizionamento:
    -Verticale = seziono per righe
    -Orizzontale = seziono per colonne
    
Se partiziono la tabella su stg, tendenzialmente anche su dwh

Partition Function: specifica su quale colonna e quali valori partizionare
Partition Schema: ogni partizione in quale Datafile la metto. Mettiamo sempre un datafile in più per valori non specificati nella function (partizione tappo)


*/




--1 Partition Function
CREATE PARTITION FUNCTION [pf_Company](nvarchar(4)) AS RANGE LEFT FOR VALUES (N'CRM', N'CZK', N'OTH', N'SER', N'SLO', N'SLV')

--2 Partition Schema
CREATE PARTITION SCHEME [ps_Company] AS PARTITION [pf_Company] TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY])

--3 Partitioned Table
CREATE TABLE  dwh.DimCustomer (CompanyCode int PRIMARY KEY, col2 char(10)) ON ps_Company (CompanyCode) ; 

--4 Partition Code
Select 
$PARTITION.pf_Company (?)  as PartitionCode

--5 Truncate partition
Truncate table dwh.DimCustomer
with (partitions (?))

--Verifica Partizione
SELECT t.name AS TableName, i.name AS IndexName, p.partition_number, p.partition_id, i.data_space_id, f.function_id, f.type_desc, r.boundary_id, r.value AS BoundaryValue   
FROM sys.tables AS t  
JOIN sys.indexes AS i  
    ON t.object_id = i.object_id  
JOIN sys.partitions AS p  
    ON i.object_id = p.object_id AND i.index_id = p.index_id   
JOIN  sys.partition_schemes AS s   
    ON i.data_space_id = s.data_space_id  
JOIN sys.partition_functions AS f   
    ON s.function_id = f.function_id  
LEFT JOIN sys.partition_range_values AS r   
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
WHERE t.name = 'DimProduct' AND i.type <= 1  
ORDER BY p.partition_number;


1--- add partition
ALTER PARTITION SCHEME [ps_Company]   
NEXT USED [PRIMARY];   

2---
ALTER PARTITION FUNCTION [pf_Company] ()   
SPLIT RANGE (‘CompanyCode’);   
