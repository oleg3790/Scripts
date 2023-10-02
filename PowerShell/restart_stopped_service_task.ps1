param (
  [parameter(Mandatory=$true)]
  [string]$ServiceName
)

# $ServiceName="AdobeUpdateService"

$action = New-ScheduledTaskAction -Execute "powershell" -Argument ('Invoke-Command -ScriptBlock {if ((Get-Service ' + $ServiceName + ').Status -ne \"Running\") { Start-Service ' + $ServiceName + ' }}')
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -RunLevel Highest
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal

Register-ScheduledTask -TaskName AA_Test_Service -InputObject $task