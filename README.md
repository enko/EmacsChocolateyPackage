# EmacsChocolateyPackage

## Installation

Use [Chocolatey](http://chocolatey.org/) to install this package:

```powershell
> choco install emacs
```

## Hacking

If you want to improve upon this package, you can build it yourself this way:

```powershell
> choco pack .\emacs.nuspec
> choco install emacs -source .\ -y
```

If you feel confident, create pull request and I will review the changes.

## Build Status

The deployment is done via azure pipelines:

[![Build Status](https://dev.azure.com/takingstack/Emacs%20Chocolatey%20Package/_apis/build/status/enko.EmacsChocolateyPackage?branchName=stable%2Femacs-27)](https://dev.azure.com/takingstack/Emacs%20Chocolatey%20Package/_build/latest?definitionId=1&branchName=stable%2Femacs-27)
