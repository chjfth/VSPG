@echo off
setlocal EnableDelayedExpansion

: Function: EchoSublines
:
: Echo each parameter's content on its own line. 
: If you have a list of filepaths stored in varname MyPathList,  
: 
:   set MyPathList=c:\abc "d:\def"
:   call :EchoSublines.bat "MyPathList param dump:" %MyPathList%
:
: will print the list, each path on its own line, for easier eye browsing. 
: 
: Param1: The ~title~ line text. Current [batfilenam] will be printed first, then the ~title~.
: Params remain: Each param is printed on their own line, indented with 4 spaces.
:
: Special Note:
: * If a param is protected with surrounding double-quotes(DQpair), the DQpair will be stripped.
: * If a param needs to have DQ as parameter value, a DQ needs to be doubled, and the whole
:   param should be wrapped in an extra protecting DQpair.

REM set batfilenam=%~n0%~x0
REM set _vspgINDENTS=%_vspgINDENTS%.
REM -- This bat does NOT set `batfilenam` or `_vspgINDENTS`, it just use those value from parent
REM    so that these lines look like they are printed from the parent bat.
set batdir=%~dp0
set batdir=%batdir:~0,-1%

call :Echos %~1

:NEXT_PARAM

shift

if "%~1"=="" exit /b 0

call :UnpackDoubleQuotes curparam %1
echo.    %curparam%
goto :NEXT_PARAM

call :Echos [INTERNAL-ERROR] Should not get here! 
exit /b 444


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

:UnpackDoubleQuotes
  if "%~2" == "" (
    set %~1=
    exit /b 0
  )
  setlocal & set allparams=%~2
  set unpacked=%allparams:""="%
  endlocal & (
    set %~1=%unpacked%
  )
exit /b 0

