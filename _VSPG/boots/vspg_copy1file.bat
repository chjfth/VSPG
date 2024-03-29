@echo off
setlocal EnableDelayedExpansion
set batfilenam=%~n0%~x0
set batdir=%~dp0
set batdir=%batdir:~0,-1%
set _vspgINDENTS=%_vspgINDENTS%.

: This is a function.
: Just like CMD's internal `copy`, but it does one extra thing:
: Check file modification time first, if source-time equals dest-time, the copy is 
: considered success already.
:
: Usage scenario: When building a whole VSIDE solution with PostBuild-CopyOutput4.bat 
: in each vcxproj, two parallel build threads can copy the same source file to the 
: same destination and one thread will fail the copy. We know that is NOT a true fail,
: if the final timestamps are the same.
: So calling this .bat wrapped inside LoopExecUntilSucc.bat is a good workaround.

:vspg_copy1file
REM Usage: 
REM call vspg_copy1file.bat sourcefile destfile
REM
REM Note: The passed-in destfile MUST be a filepath, not a dirpath,
REM       bcz, this .bat need to know the exact filepath so to check its timestamp.

set srcfile=%~1
set dstfile=%~2

if not exist "%srcfile%" (
	call :Echos [ERROR] File not exist: "%srcfile%"
	exit /b 4
)

call :GetAbsPath dstdir "%dstfile%\.."
if not exist "%dstdir%" (
	call :EchoAndExec mkdir "%dstdir%"
	if errorlevel 1 exit /b 4
)

for %%A in ("%srcfile%") do set filesize=%%~zA

if "%filesize%" LEQ "64000" (
	REM [2022-10-12] Currently, IsFiletimeSame.bat is quite time consuming, human eye aware.
	REM So for small file less-than or equal to 64000 bytes, we copy it blindly.
	goto :SKIPPED_CHECK_SAME_TIME
)

call "%batdir%\IsFiletimeSame.bat" "%srcfile%" "%dstfile%"

if not errorlevel 1 (
	if defined vspg_DO_SHOW_VERBOSE (
		call :Echos Already same: "%srcfile%" and "%dstfile%"
	)
	exit /b 0
)

:SKIPPED_CHECK_SAME_TIME

call copy "%srcfile%" "%dstfile%"

exit /b %ERRORLEVEL%


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
