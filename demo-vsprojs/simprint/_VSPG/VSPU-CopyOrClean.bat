@echo off
setlocal EnableDelayedExpansion
set batfilenam=%~n0%~x0
set batdir=%~dp0
set batdir=%batdir:~0,-1%
set _vspgINDENTS=%_vspgINDENTS%.
call :Echos START from %batdir%


REM ===========================================
REM ====== User write copy commands here ======
REM ===========================================

set filenams_to_copy=%TargetFileNam% "%ProjectDir%\*.ini"
set output_folder=d:\TeamBin\%PlatformName%\%BuildConf%
REM
call "%_vspg_bootsdir%\CopyFilePatterns.bat" ^
	"%ExeDllDir%" ^
	"%output_folder%" ^
	%filenams_to_copy%

if errorlevel 1 exit b 4

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
  call echo %_vspgINDENTS%[%batfilenam%]%~2 %Varname% = %%%Varname%%%
exit /b 0

:SetErrorlevel
  REM Usage example:
  REM call :SetErrorlevel 4
exit /b %1

:GetAbsPath
  REM Get absolute-path from a relative-path(relative to %CD%). 
  REM If already absolute, return as is.
  REM If your input dir is relative to current .bat, use RelaPathToAbs instead.
  REM Param1: Var name to receive output.
  REM Param2: The input path.
  REM
  REM Feature 1: this function removes redundant . and .. from input path.
  REM I
  REM For example:
  REM     call :GetAbsPath outvar C:\abc\.\def\..\123
  REM Returns outvar:
  REM     C:\abc\123
  REM
  REM Feature 2: It's pure string manipulation, so the input path doesn't have to 
  REM actually exist on the file-system.
  REM
  if "%~1"=="" exit /b 4
  if "%~2"=="" exit /b 4
  for %%a in ("%~2") do set "%~1=%%~fa"
exit /b 0
