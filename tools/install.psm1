$packageName = 'emacs'

$majorVersion = '27'
$minorVersion = '2'

$emacsNameVersion = "$($packageName)-$($majorVersion).$($minorVersion)"
$installDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition) + '/' + $packageName
$baseUrl = "https://ftp.gnu.org/pub/gnu/emacs/windows"

$FullPackageArgs = @{
    packageName    = $packageName
    unzipLocation  = $installDir
    url            = "$($baseUrl)/emacs-$($majorVersion)/$($emacsNameVersion)-i686.zip"
    url64bit       = "$($baseUrl)/emacs-$($majorVersion)/$($emacsNameVersion)-x86_64.zip"
    checksum       = '626792EA6C4C5347E1F17960072440AF1CB05CB6767389FC8195A744A0B428CA'
    checksumType   = 'sha256'
    checksum64     = '5396AA4239C9AC2F65A6B084CCF588D01BDD6DDB701419B7FDA5B97B45846093'
    checksumType64 = 'sha256'
}

$NoDepsPackageArgs = @{
    packageName    = $packageName
    unzipLocation  = $installDir
    url            = "$($baseUrl)/emacs-$($majorVersion)/$($emacsNameVersion)-i686-no-deps.zip"
    url64bit       = "$($baseUrl)/emacs-$($majorVersion)/$($emacsNameVersion)-x86_64-no-deps.zip"
    checksum       = '5758d2baa6c78364042b44ab15b7a78b172eed51fa9863416e17e123788e5094'
    checksumType   = 'sha256'
    checksum64     = 'ccdaa194d80b6d5c7d087267e2e57211eb98012fa135c917f1ba714d09e7f641'
    checksumType64 = 'sha256'
}

$emacsDepsVersion = "emacs-$($majorVersion)"

$DepsPackageArgs = @{
  packageName    = $packageName
  unzipLocation  = $installDir
  url            = "$($baseUrl)/emacs-$($majorVersion)/$($emacsDepsVersion)-i686-deps.zip"
  url64bit       = "$($baseUrl)/emacs-$($majorVersion)/$($emacsDepsVersion)-x86_64-deps.zip"
  checksum       = '1F28BEA4A14E86817B730C7ED71905407436B98B5ABCC1BDFE32513B74311C7C'
  checksumType   = 'sha256'
  checksum64     = '9597cccaf3eb8a26eb5504327a042354d11760b7aae5e83c75ce793491d2de1d'
  checksumType64 = 'sha256'
}

function New-ShimHintFiles() {
    # Exclude executables from getting shimmed
    $guiExes = @("runemacs.exe", "emacsclientw.exe")
    $shimExes = @("emacs.exe", "emacsclient.exe")

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
}

Export-ModuleMember -Variable 'FullPackageArgs'
Export-ModuleMember -Variable 'NoDepsPackageArgs'
Export-ModuleMember -Variable 'DepsPackageArgs'
Export-ModuleMember -Function 'New-ShimHintFiles'
