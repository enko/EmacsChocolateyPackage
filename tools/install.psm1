$packageName = 'emacs'

$majorVersion = '26'
$minorVersion = '1'

$emacsNameVersion = "$($packageName)-$($majorVersion).$($minorVersion)"
$installDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition) + '/' + $packageName

$FullPackageArgs = @{
    packageName    = $packageName
    unzipLocation  = $installDir
    url            = "https://ftp.gnu.org/pub/gnu/emacs/windows/emacs-$($majorVersion)/$($emacsNameVersion)-i686.zip"
    url64bit       = "https://ftp.gnu.org/pub/gnu/emacs/windows/emacs-$($majorVersion)/$($emacsNameVersion)-x86_64.zip"
    checksum       = '77df3aa8edfcc248caf0ef8726460d08ad3feb8e21295183222981feb722be34'
    checksumType   = 'sha256'
    checksum64     = '4cf4c41c77d3893a62ec8b88031680f63574b15b8658e614bcfc20ce0ef1ef1e'
    checksumType64 = 'sha256'
}

$NoDepsPackageArgs = @{
    packageName    = $packageName
    unzipLocation  = $installDir
    url            = "https://ftp.gnu.org/pub/gnu/emacs/windows/emacs-$($majorVersion)/$($emacsNameVersion)-i686-no-deps.zip"
    url64bit       = "https://ftp.gnu.org/pub/gnu/emacs/windows/emacs-$($majorVersion)/$($emacsNameVersion)-x86_64-no-deps.zip"
    checksum       = '88d24adf0fa5e8bb72f3f7f15cb8b7f3f3bee541a0b194a6c3b9db172b8dbaba'
    checksumType   = 'sha256'
    checksum64     = '12d4d80a9c37baeacf8d6d808cde3173d6ca570ca684e69f0adf6ca66fa88bf6'
    checksumType64 = 'sha256'
}

$emacsDepsVersion = "emacs-$($majorVersion)"

$DepsPackageArgs = @{
  packageName    = $packageName
  unzipLocation  = $installDir
  url            = "https://ftp.gnu.org/pub/gnu/emacs/windows/emacs-$($majorVersion)/$($emacsDepsVersion)-i686-deps.zip"
  url64bit       = "https://ftp.gnu.org/pub/gnu/emacs/windows/emacs-$($majorVersion)/$($emacsDepsVersion)-x86_64-deps.zip"
  checksum       = '4ff9057d4407f2d1149f158a2920acd09c31eff12a09ba25dc1776a3978f41ad'
  checksumType   = 'sha256'
  checksum64     = '3501e0c7f31cbf98ef7ac5cbbc8bae04ef4a72f52b00898965a8d702c4a5fae7'
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
