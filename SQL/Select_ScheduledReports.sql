/*
  Estrae dal report server le schedulazioni e il loro stato di esecuzione
*/

SELECT 
   Schedule.ScheduleID 			AS SQLAgent_Job_Name
   ,Subscriptions.Description 		AS sub_desc
   ,Subscriptions.DeliveryExtension 	AS sub_delExt
   ,Subscriptions.LastRunTime
   ,Subscriptions.EventType
   ,Subscriptions.LastStatus
   ,Subscriptions.DeliveryExtension
   ,[Catalog].Name 			AS ReportName

FROM reportserver.dbo.ReportSchedule 

INNER JOIN reportserver.dbo.Schedule
	  ON ReportSchedule.ScheduleID = Schedule.ScheduleID
INNER JOIN reportserver.dbo.Subscriptions
	  ON ReportSchedule.SubscriptionID = Subscriptions.SubscriptionID
INNER JOIN reportserver.dbo.[Catalog]
	  ON ReportSchedule.ReportID = [Catalog].ItemID
	  AND Subscriptions.Report_OID = [Catalog].ItemID
  
