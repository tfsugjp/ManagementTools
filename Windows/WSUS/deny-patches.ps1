
$wsus = Get-WsusServer -name localhost -PortNumber 8530
$ia64 = $wsus.GetUpdates() | Where-Object {($_.title.indexof("Itanium") -gt 1 -and $_.title.indexof("x64") -eq -1) -or ($_.title.indexof("ARM") -gt 1) -or ($_.title.indexof("x86") -gt 1) -and $_.ArrivalDate -gt [datetime]::Now.AddDays(-7)}
foreach($patch in $ia64) {
  Get-WsusUpdate -UpdateId $patch.id.updateid | Deny-WsusUpdate
}
# When timeout error in Invoke-WsusServerCleanup, re-index SQL Server.
# see https://gallery.technet.microsoft.com/scriptcenter/6f8cde49-5c52-4abd-9820-f1d270ddea61

$wsus | Invoke-WsusServerCleanup -CompressUpdates
$wsus | Invoke-WsusServerCleanup -CleanupObsoleteUpdates -CleanupUnneededContentFiles -DeclineExpiredUpdates 

