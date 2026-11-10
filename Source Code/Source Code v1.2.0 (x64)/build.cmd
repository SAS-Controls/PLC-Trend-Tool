@echo off
rem ============================================================
rem  PLC Trend Tool - build the Windows .exe for THIS folder
rem  Double-click to run. Works from the x64 or the ARM64 folder:
rem  the folder name decides which Python (x64 or ARM64) is used.
rem  Output: dist\PLC_Trend_Tool.exe
rem ============================================================
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

rem -- Which build is this folder? --
set "TARGET=win-amd64"
set "LABEL=x64"
echo "%~dp0" | find /i "ARM64" >nul
if not errorlevel 1 set "TARGET=win-arm64"
if not errorlevel 1 set "LABEL=ARM64"
title PLC Trend Tool - %LABEL% build

echo.
echo ============================================================
echo   PLC Trend Tool - %LABEL% build
echo ============================================================
echo.

rem -- Find an installed Python of the matching architecture --
set "PY="
where py >nul 2>nul
if errorlevel 1 goto try_path_python
for /f "tokens=1" %%T in ('py -0 2^>nul') do call :try_tag %%T
if defined PY goto have_python

:try_path_python
where python >nul 2>nul
if errorlevel 1 goto no_python
for /f "delims=" %%P in ('python -c "import sysconfig;print(sysconfig.get_platform())" 2^>nul') do if /i "%%P"=="%TARGET%" set "PY=python"
if defined PY goto have_python

:no_python
echo ERROR: No %LABEL% Python was found on this computer.
echo.
echo   Install the %LABEL% build of Python 3.10 or newer from python.org
echo   (leave "py launcher" checked), then run this file again.
echo.
echo   Pythons the launcher can see:
py -0p 2>nul
goto failed

:have_python
echo Using: %PY%
%PY% -c "import sys,sysconfig;print('  Python', sys.version.split()[0], '-', sysconfig.get_platform())"
echo.

echo [1/2] Installing / updating build dependencies...
%PY% -m pip install --disable-pip-version-check -r requirements.txt pycomm3
if errorlevel 1 goto pip_failed
echo.

echo [2/2] Building the executable...
if exist "dist\PLC_Trend_Tool.exe" del /q "dist\PLC_Trend_Tool.exe"
%PY% build.py
if errorlevel 1 goto build_failed
if not exist "dist\PLC_Trend_Tool.exe" goto build_failed

echo.
echo ============================================================
echo   %LABEL% BUILD DONE
echo   !CD!\dist\PLC_Trend_Tool.exe
echo ============================================================
if /i not "%~1"=="nopause" start "" explorer "!CD!\dist"
if /i not "%~1"=="nopause" pause
endlocal
exit /b 0

:pip_failed
echo.
echo ERROR: Installing the dependencies failed (see the messages above).
goto failed

:build_failed
echo.
echo ERROR: The %LABEL% build failed (see the messages above).
goto failed

:failed
echo.
if /i not "%~1"=="nopause" pause
endlocal
exit /b 1

rem -- %1 = a launcher tag such as -V:3.12 or -V:3.12-arm64 --
:try_tag
if defined PY exit /b 0
set "TAG=%~1"
if not "!TAG:~0,1!"=="-" exit /b 0
for /f "delims=" %%P in ('py !TAG! -c "import sysconfig;print(sysconfig.get_platform())" 2^>nul') do if /i "%%P"=="%TARGET%" set "PY=py !TAG!"
exit /b 0
