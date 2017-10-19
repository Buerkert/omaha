@echo off

set PYTHON="C:\Python24"
set SCONS_DIR="C:\Python24\Lib\site-packages\scons-1.3.1"

::check if GOROOT variable is set
if not defined GOROOT goto :GO_NOT_INSTALLED

::check if the Wix Toolset is installed
if not exist C:\Wix goto :WIX_NOT_INSTALLED

::if Wix is not set but installed then set the WIX variable
if not defined WIX set WIX="C:\Wix"

if not exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC" goto :VS_NOT_INSTALLED

call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"

::everything is fine and we can go on
goto :FINISHED

::ERROR handling
:GO_NOT_INSTALLED
echo The GO programming language is not installed and the GOROOT variable is missing
goto :EXIT_BAT

:WIX_NOT_INSTALLED
echo The Wix Toolset is not installed
goto :EXIT_BAT

:VS_NOT_INSTALLED
echo Visual Studio 2015 Community Update 3 is not installed
goto :EXIT_BAT 

::EXIT with -1
:EXIT_BAT
echo Read the README.txt in the dep directory
exit /B -1

:FINISHED
exit /B 0