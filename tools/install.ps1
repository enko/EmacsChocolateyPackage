Import-Module "$(Split-Path -parent $MyInvocation.MyCommand.Definition)/install.psm1"

Install-ChocolateyZipPackage @PackageArgs

New-ShimHintFiles
