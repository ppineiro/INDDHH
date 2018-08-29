strComputer = "." 
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2") 
Set colItems = objWMIService.ExecQuery( _
    "SELECT * FROM Win32_PerfFormattedData_PerfOS_Processor where Name='_Total'",,48) 
For Each objItem in colItems 
    Wscript.Echo objItem.PercentProcessorTime
Next

Set colItems = objWMIService.ExecQuery( _
    "SELECT * FROM Win32_PerfFormattedData_PerfOS_Memory",,48) 
For Each objItem in colItems 
    Wscript.Echo objItem.AvailableBytes
    Wscript.Echo objItem.CommitLimit
    Wscript.Echo objItem.CommittedBytes
    Wscript.Echo objItem.PagesPersec
Next