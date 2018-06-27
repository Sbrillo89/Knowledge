
## Ottimizzazione del codice:
___
Application.ScreenUpdating = False  
Application.EnableEvents = False  
Application.DisplayStatusBar = False  
Application.Calculation = xlCalculationManual  
&nbsp; ...  
Application.ScreenUpdating = True  
Application.EnableEvents = True  
Application.DisplayStatusBar = True  
Application.Calculation = xlCalculationAuto  

&nbsp;

**Application.Calculation** turns off auto-calculations.  
This is essential when your workbook has a lot of formulas and you are transferring new data to these cells.  

**Application.ScreenUpdating** turns off screen updating.  
Excel will constantly be updating the screen when you run your procedures unnecessarily. This can be a big hit on performance. It is much more efficient to update the screen once your code is finished.

**Application.DisplayStatusBar** turns off the status bar.  
If you do not need to show users the different statuses while code is running, it is a good idea to just turn this off.  

**Application.DisplayAlerts** turns off messages and alerts when code is running.  
If you are running a process that would normally cause Excel to display an alert to the user, you can set this to false if you do not want the user to see alerts.

**ActiveSheet.DisplayPageBreaks** turns off Excel’s recalculation of page breaks.  
Each time the count of rows or columns is modified Excel recalculate page breaks.
