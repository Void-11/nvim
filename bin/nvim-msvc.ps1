<#
Cross-terminal launcher to set up MSVC environment and start Neovim with this config
Works from PowerShell, WezTerm, Warp (Windows), etc.
Usage:
  pwsh -File "E:\Neovim Config\bin\nvim-msvc.ps1" [additional nvim args]
#>
param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Args
)

$ErrorActionPreference = 'Stop'

# Detect VS 2022 Build Tools
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
if (Test-Path $vswhere) {
  $vsInstall = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2>$null
  if ($vsInstall -and (Test-Path $vsInstall)) {
    $vcvars = Join-Path $vsInstall 'VC/Auxiliary/Build/vcvarsall.bat'
    if (Test-Path $vcvars) {
      # Initialize MSVC env for current process
      $cmd = "`"$vcvars`" x64 & set"
      $vars = cmd /c $cmd | Out-String
      foreach ($line in $vars -split "`r?`n") {
        if ($line -match '^(\w+)=(.*)$') {
          [Environment]::SetEnvironmentVariable($matches[1], $matches[2])
        }
      }
    }
  }
}

# Ensure Neovim on PATH for this process
$neovimbin = 'C:\Program Files\Neovim\bin'
if (Test-Path $neovimbin) {
  $env:Path = "$neovimbin;$env:Path"
}

# Launch Neovim with this config
$init = 'E:\Neovim Config\init.lua'
$nvim = Join-Path $neovimbin 'nvim.exe'
if (-not (Test-Path $nvim)) { $nvim = 'nvim' }
& $nvim -u $init @Args

