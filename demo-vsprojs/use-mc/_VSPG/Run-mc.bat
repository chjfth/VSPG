@REM This sample applies to all of 
@REM Team-Prebuild.bat, Team-Postbuild.bat, Personal-Prebuild.bat, Personal-Postbuild.bat

@echo off
setlocal EnableDelayedExpansion

set batfilenam=%~n0%~x0
set batdir=%~dp0
set batdir=%batdir:~0,-1%
set _vspgINDENTS=%_vspgINDENTS%.
call :Echos START from "%batdir%"

REM ==== User commands below:

call :Echos Compiling .mc files to .rc files...

call :EchoAndExec pushd %batdir%\..\mc-src
if errorlevel 1 exit /b 4

call :EchoAndExec mc.exe -cp utf-8 0409.mc
if errorlevel 1 exit /b 4

call :EchoAndExec mc.exe -cp utf-8 0804.mc
if errorlevel 1 exit /b 4

call :EchoAndExec mc.exe -cp utf-8 0404.mc
if errorlevel 1 exit /b 4

exit /b 0



REM =============================
REM ====== Functions Below ======
REM =============================

:Echos
  REM This function preserves %ERRORLEVEL% for the caller,
  REM and, LastError does NOT pollute the caller.
  setlocal & set LastError=%ERRORLEVEL%
  echo %_vspgINDENTS%[%batfilenam%] %*
exit /b %LastError%

:EchoAndExec
  echo %_vspgINDENTS%[%batfilenam%] EXEC: %*
  %*
exit /b %ERRORLEVEL%

:EchoVar
  setlocal & set Varname=%~1
  call echo %_vspgINDENTS%[%batfilenam%] %Varname% = %%%Varname%%%
exit /b 0

:SetErrorlevel
  REM Usage example:
  REM call :SetErrorlevel 4
exit /b %1

