/*
  Fornito il nome dello schema come parametro
  Restituisce una tabella con il conteggio di righe di ciascuna tabella
*/

CREATE procedure [dbo].[spCountRows_TableBySchema]
(
	@SchemaName as varchar(10)
)
as
	declare @query_count nvarchar(2000)
	declare @tmp_table_name varchar(1000)
	declare @tab_risultati table(NomeTabella varchar(300), NumRighe bigint)
	declare @NumRighe bigint

	declare cur cursor for
	SELECT TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME as tabella
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_schema=@SchemaName

	Open cur     
	Fetch Next From cur Into @tmp_table_name
 
	While (@@FETCH_STATUS = 0)
	begin
		set @query_count = 'select @x = count(*) from ' + @tmp_table_name
		execute sp_executesql  @query_count, N'@x bigint out', @NumRighe out
		insert into @tab_risultati values ( @tmp_table_name , @NumRighe)
		Fetch Next From cur Into @tmp_table_name
	end 

	Close cur
	Deallocate cur
	select * from @tab_risultati
GO

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

/*
  Call Stored Procedure Example:
  
  [dbo].[spCountRows_TableBySchema] 'Person'
*/



