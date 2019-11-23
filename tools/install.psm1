$packageName = 'emacs'

$majorVersion = '24'
$minorVersion = '5'

$emacsNameVersion = "$($packageName)-$($majorVersion).$($minorVersion)"
$installDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition) + '/' + $packageName

$PackageArgs = @{
    packageName    = $packageName
    unzipLocation  = $installDir
    url            = "https://ftp.gnu.org/pub/gnu/emacs/windows/emacs-$($majorVersion)/$($emacsNameVersion)-bin-i686-mingw32.zip"
    checksum       = 'b7bd6668fd17e5809f83567b4d9e87217a31dfcc7ef12c27a935823b6991ffd9'
    checksumType   = 'sha256'
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

Export-ModuleMember -Variable 'PackageArgs'
Export-ModuleMember -Function 'New-ShimHintFiles'
