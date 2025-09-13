# Usage: call this .cmd from any terminal (WezTerm, Warp on Windows, PowerShell, cmd)
# It will set up MSVC environment and start Neovim with your config.
@echo off
setlocal

REM Detect VS 2022 Build Tools
set VSWHERE="%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist %VSWHERE% (
  echo vswhere.exe not found. Please install Visual Studio 2022 Build Tools.
  goto :RUNNVIM
)
for /f "usebackq delims=" %%i in (`%VSWHERE% -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set VSINSTALL=%%i
if not defined VSINSTALL (
  echo VS Build Tools not found. Continuing without MSVC env.
  goto :RUNNVIM
)

REM Set MSVC env for x64
call "%VSINSTALL%\VC\Auxiliary\Build\vcvarsall.bat" x64 >nul 2>&1

:RUNNVIM
REM Ensure Neovim is on PATH for this process
set "PATH=C:\Program Files\Neovim\bin;%PATH%"

REM Start Neovim with this config (Option A)
set "NVIM_INIT=E:\Neovim Config\init.lua"
"C:\Program Files\Neovim\bin\nvim.exe" -u "%NVIM_INIT%" %*

endlocal

