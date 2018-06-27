
## Ottimizzazione del codice:
___
Nella macro del bottone che esegue i comandi, a monte di tutto:  
  Application.ScreenUpdating = False
  Application.EnableEvents = False
  Application.DisplayStatusBar = False
  Application.Calculation = xlCalculationManual
    ...
  Application.ScreenUpdating = True
  Application.EnableEvents = True
  Application.DisplayStatusBar = True
  Application.Calculation = xlCalculationAuto
  

Application.Calculation = xlCalculationManual 
turns off auto-calculations. 
This is essential when your workbook has a lot of formulas and you are transferring new data to these cells.

Application.ScreenUpdating = False 
turns off screen updating. 
Excel will constantly be updating the screen when you run your procedures unnecessarily. This can be a big hit on performance. It is much more efficient to update the screen once your code is finished.

Application.DisplayStatusBar = False 
turns off the status bar. 
If you do not need to show users the different statuses while code is running, it is a good idea to just turn this off.

Application.DisplayAlerts = False turns off messages and alerts when code is running.
If you are running a process that would normally cause Excel to display an alert to the user,
you can set this to false if you do not want the user to see alerts.

ActiveSheet.DisplayPageBreaks = False 
turns off Excel’s recalculation of page breaks each time the count of rows or columns is modified.









--Cancella righe da una tabella:

'Remove any values in the cells where we want to put our Stored Procedure's results.
    'Set rngRange = Range(Cells(mRow, mCol), Cells(Rows.Count, 1)).EntireRow
    'rngRange.ClearContents
      Dim tbl As ListObject
    Set tbl = ActiveSheet.ListObjects(TableName)
    'Delete all table rows except first row
      With tbl.DataBodyRange
        If .Rows.Count > 1 Then
          .Offset(1, 0).Resize(.Rows.Count - 1, .Columns.Count).Rows.Delete
        End If
      End With
    'Clear out data from first table row
    tbl.DataBodyRange.Rows(1).ClearContents


--Yes/No Question

    If (OptionButton_NewBudget.Value = True) Then
        messageReturn = MsgBox(vbCrLf & "Warning!" & vbCrLf & vbCrLf & "The current budget session will be lost." & vbCrLf & vbCrLf & "Continue?", vbYesNo + vbExclamation, "New Budget Session")
        If messageReturn <> vbYes Then
        Exit Sub
        End If
