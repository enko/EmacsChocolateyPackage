$packageName = 'emacs'

$majorVersion = '26'
$minorVersion = '1'

$emacsNameVersion = "$($packageName)-$($majorVersion).$($minorVersion)"
$installDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition) + '/' + $packageName

$packageArgs = @{
    packageName    = $packageName
    unzipLocation  = $installDir
    url            = "http://ftp.gnu.org/pub/gnu/emacs/windows/emacs-$($majorVersion)/$($emacsNameVersion)-i686.zip"
    url64bit       = "http://ftp.gnu.org/pub/gnu/emacs/windows/emacs-$($majorVersion)/$($emacsNameVersion)-x86_64.zip"
    checksum       = '8aa09a1cc7714045fc92f3f21b738e4356481670c7a0546c7edccf92b41df0b3'
    checksumType   = 'sha256'
    checksum64     = 'e73febe3f3ce5918c871fa4195e2561599c425635f2100ddd1327eeb052a0d7d'
    checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

# Exclude executables from getting shim
$guiExes = @("emacs.exe", "emacsclientw.exe")
$shimExes = @("runemacs.exe", "emacsclient.exe")

$guiFilter = "^" + $($guiExes -join "$|^") + "$"
$shimFilter = "^" + $($shimExes -join "$|^") + "$"

$files = Get-Childitem $installDir -include *.exe -recurse

foreach ($file in $files) {
    if ($file.Name -match $guiFilter) {
        #generate an gui file
        New-Item "$file.gui" -type file -force | Out-Null
    }
    elseif (-not ($file.Name -match $shimFilter)) {
        #generate an ignore file
        New-Item "$file.ignore" -type file -force | Out-Null
    }
}