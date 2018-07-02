/*
  Estrae la lista di tabelle in lock
*/

SELECT *  
FROM sys.dm_exec_requests 
WHERE
		DB_NAME(database_id) = 'DB_NAME'  -- Sostituire con il nome del DB
		AND blocking_session_id <> 0
		
