
CREATE Procedure [dbo].[spCreateNA]
AS
BEGIN

set identity_insert [dbo].[DimCustomer] on
if (select count(*) from [dbo].[DimCustomer] where [IdCustomer] = 0) = 0
    insert into [dbo].[DimCustomer] ([IdCustomer])
    values (0)
set identity_insert [dbo].[DimCustomer] off

END

