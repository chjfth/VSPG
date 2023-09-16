@echo off
setlocal EnableDelayedExpansion

set batfilenam=%~n0%~x0
set bootsdir=%~dp0
set bootsdir=%bootsdir:~0,-1%
set _vspgINDENTS=%_vspgINDENTS%.

REM Note: The clean order is SubbatSearchDirsWideToNarrow, which is reverse of SubbatSearchDirsNarrowToWide.

set vspg_COPYORCLEAN_DO_CLEAN=1

call "%bootsdir%\SearchAndExecSubbat.bat" Greedy1 VSPU-CleanProject.bat "" %SubbatSearchDirsWideToNarrow%
if errorlevel 1 exit /b 4

call "%bootsdir%\SearchAndExecSubbat.bat" Greedy1 VSPU-CopyOrClean.bat "" %SubbatSearchDirsWideToNarrow%
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
  call %*
exit /b %ERRORLEVEL%

:EchoVar
  setlocal & set Varname=%~1
  call echo %_vspgINDENTS%[%batfilenam%] %Varname% = %%%Varname%%%
exit /b 0

:SetErrorlevel
  REM Usage example:
  REM call :SetErrorlevel 4
exit /b %1

