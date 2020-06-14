import-module WebAdministration
$iisroot = 'IIS:\Sites\'
$sites = get-itemproperty $iisroot
foreach($site in $sites.children) {
  foreach($webroot in $sites.Children.Keys) {
    $WebSite = join-path  $iisroot  $webroot
    $logpath = get-itemproperty $WebSite  -name logfile.directory.value
    if($logpath -ne $null) {
      $logpath = [environment]::ExpandEnvironmentVariables($logpath)
      $files = get-childitem $logpath -include "*.log" -recurse
 
      foreach($file in $files) {
        if($file.lastwritetime.adddays(7) -lt [Datetime]::Now) {
          remove-item $file.fullname
        }
      }
    }
  }
}
