
/*
  Elimina i duplicati
  
  Identificare la chiave della tabella con le colonne Col1, Col2, Col3.

*/

DELETE 
FROM MyTable
LEFT OUTER JOIN (
				SELECT MIN(RowId) as RowId, Col1, Col2, Col3
				FROM MyTable
				GROUP BY Col1, Col2, Col3
				) as KeepRows
ON MyTable.RowId = KeepRows.RowId

WHERE
	KeepRows.RowId IS NULL


