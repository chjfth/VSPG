@echo off
setlocal EnableDelayedExpansion
set batfilenam=%~n0%~x0
set batdir=%~dp0
set batdir=%batdir:~0,-1%
set _vspgINDENTS=%_vspgINDENTS%.
call :Echos START from %batdir%

REM User params:

set svndir=%batdir%
set subparams=

REM =========================================================================
REM This bat examines SubWCRev.csv for SrcVersionFile,DstVersionFile pairs.
REM SubWCRev.exe is called once for each line in SubWCRev.csv, so that
REM $WCREC$ etc is substituted and real cpp file is generated.
REM
REM Customization:
REM * If you want, subparams defines what extra params are passed to SubWCRev.
REM =========================================================================

set csvpath=%batdir%\SubWCRev.csv

if not exist "%csvpath%" (
	call :Echos Cannot find %csvpath%
	exit /b 4
)

call :SetErrorlevel 4

for /f "usebackq tokens=1-2 delims=," %%a in ("%csvpath%") do (
	call :EchoAndExec SubWCRev.exe "%svndir%" "%svndir%\%%a" "%svndir%\%%b" %subparams%
	if errorlevel 1 exit /b 4
)

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

:SetErrorlevel
  REM Usage example:
  REM call :SetErrorlevel 4
exit /b %1
