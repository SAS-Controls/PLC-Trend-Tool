@echo off
rem ============================================================
rem  PLC Trend Tool - build every version (x64 and ARM64)
rem  Keep this file in the folder that holds the
rem  "Source Code v... (x64)" and "Source Code v... (ARM64)" folders.
rem  Each folder's own build.cmd does the work.
rem ============================================================
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
set "COUNT=0"
for /d %%D in ("Source Code v*") do call :build_one "%%~fD"

echo.
echo ============================================================
echo   SUMMARY
echo ============================================================
if "%COUNT%"=="0" echo   No "Source Code v..." folders with a build.cmd were found next to this file.
for /l %%I in (1,1,%COUNT%) do echo   !R%%I!
echo.
pause
endlocal
exit /b 0

:build_one
if not exist "%~1\build.cmd" exit /b 0
set /a COUNT+=1
set "NAME=%~nx1"
call "%~1\build.cmd" nopause
if errorlevel 1 goto one_failed
set "R!COUNT!=OK      !NAME!\dist\PLC_Trend_Tool.exe"
exit /b 0

:one_failed
set "R!COUNT!=FAILED  !NAME!"
exit /b 0
