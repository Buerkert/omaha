@echo off
:: Copyright 2010 Google Inc.
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::      http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.
:: ========================================================================

:: set additional environment variables which are needed to build Buerkert udpate
call setVars.bat

::check if setVars exit with success
if %ERRORLEVEL%==-1 goto error_set_vars

:: Hammer does not need this variable but the unit
:: tests do.
set OMAHA_PSEXEC_DIR=%ProgramFiles(x86)%

setlocal

rem -- Set all environment variables used by Hammer and Omaha. --

:: VS2003/VC71 is 1310 (not supported by the current build).
:: VS2005/VC80 is 1400 (not supported by the current build).
:: VS2008/VC90 is 1500 (not supported by the current build).
:: VS2010/VC10 is 1600 (not supported by the current build).
:: VS2012/VC11 is 1700 (not supported by the current build).
:: VS2013/VC12 is 1800.
:: VS2015/VC14 is 1900.

if "%VisualStudioVersion%"=="" goto error_no_vc
if "%VisualStudioVersion%"=="12.0" goto vc120
if "%VisualStudioVersion%"=="14.0" goto vc140
goto error_vc_not_supported

:vc120
set OMAHA_MSC_VER=1800
goto set_env_variables

:vc140
set OMAHA_MSC_VER=1900
goto set_env_variables

:set_env_variables
::set GOROOT=%ProgramFiles(x86)%\go\files
set OMAHA_ATL_SERVER_DIR=c:\atl
set OMAHA_NET_DIR=%WINDIR%\Microsoft.NET\Framework\v2.0.50727
set OMAHA_NETFX_TOOLS_DIR=%WindowsSDK_ExecutablePath_x86%
set OMAHA_PYTHON_DIR=C:\Python24
set OMAHA_WIX_DIR=C:\Program Files (x86)\WiX Toolset v3.10\bin
set OMAHA_WTL_DIR=C:\wtl
set OMAHA_PLATFORM_SDK_DIR=%WindowsSdkDir%\
set OMAHA_WINDOWS_SDK_10_0_VERSION=%WindowsSDKVersion:~0,-1%
set OMAHA_SIGNTOOL_SDK_DIR=%WindowsSdkDir%\bin\x86
set PYTHONPATH=%OMAHA_PYTHON_DIR%
set SCONS_DIR=C:\Python24\Lib\site-packages\scons-1.3.1
set SCT_DIR=C:\swtoolkit\trunk

set PROXY_CLSID_TARGET=%~dp0proxy_clsids.txt
set CUSTOMIZATION_UT_TARGET=%~dp0common\omaha_customization_proxy_clsid.h

rem Force Hammer to use Python 2.4.  (The default of Python 2.6 exposes some
rem bugs in Scons 1.2, which we currently use.)
set PYTHON_TO_USE=python_24
call "%SCT_DIR%\hammer.bat" %*

if /i {%1} == {-c} (
  del /q /f "%PROXY_CLSID_TARGET%" 2> NUL
  del /q /f "%CUSTOMIZATION_UT_TARGET%" 2> NUL
)

goto end

:error_no_vc
echo VisualStudioVersion variable is not set. Have you run vcvarsall.bat before running this script?
goto end

:error_vc_not_supported
echo Visual Studio version %VisualStudioVersion% is not supported.
goto end

:error_set_vars
echo env variables are not set correctly. SetVars.bat failed with error code -1.
echo maybe you have to run configure.bat from the dep directory
goto end

:end
