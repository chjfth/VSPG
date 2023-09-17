@echo off
setlocal EnableDelayedExpansion
REM Usage: This .bat is to be called from Visual Studio VSPG_PreBuild/VSPG_PostBuild target,
REM so that we can write complex batch programs in this .bat or its subbat-s. 
REM This replaces the pre-year-2000 old way of jamming all .bat statements into VC's stock 
REM Prebuild/Postbuild events.

REM set batfilenam to .bat filename(no directory prefix)
set batfilenam=%~n0%~x0
set bootsdir=%~dp0
set bootsdir=%bootsdir:~0,-1%
REM Use PathSplit to get parent directory of bootsdir.
call :GetAbsPath VSPG_StartDir "%bootsdir%\.."
set _vspgINDENTS=%_vspgINDENTS%.
REM
set SubworkBatfile=%~1
set SubworkBatpath=%bootsdir%\%SubworkBatfile%


if defined vspg_DO_SHOW_VERBOSE (
  call :EchoVar SubworkBatpath
)


if not exist "%SubworkBatpath%" (
  call :Echos [INTERNAL-ERROR] SubworkBatpath NOT found: "%SubworkBatpath%"
  call :SetErrorlevel 4
  exit /b 4
)

REM ==== Prepare directory search list for VSPU-StartEnv.bat.

call :GetAbsPath ProjectDir_up   "%ProjectDir%\.."
call :GetAbsPath ProjectDir_upup "%ProjectDir%\..\.."

set StartEnvSearchDirs=^
  "%VSPG_StartDir%"^
  "%ProjectDir_upup%"^
  "%ProjectDir_up%"^
  "%ProjectDir%"^
  "%ProjectDir%\_VSPG"^

REM ======== Loading User Env-vars ======== 

REM This is a greedy search, bcz user may want to accumulate env-vars from outer env.
REM But if user does not like some env-var from outer env, he can override it(or clear it) 
REM from inner env explicitly.
REM In one word, the search order is from wide to narrow.
REM Gist of wide-to-narrow is Greedy: All directories in the list is search and all matched files are called.

call "%bootsdir%\SearchAndExecSubbat.bat" Greedy1 VSPU-StartEnv.bat "" %StartEnvSearchDirs% 
if errorlevel 1 exit /b 4

REM ==== Prepare directory search list for other .bat-s.

REM From VSPU-StartEnv.bat, user can append new search dirs in vspg_USER_BAT_SEARCH_DIRS, so that they will be searched.
REM Gist of narrow-to-wide is non-Greedy: Once a file is matched, VSPG stops the search. If user wants to 
REM resume the search(to get accumulating effect), user bat should manually call those wider bats.

set SubbatSearchDirsNarrowToWide=^
  %vspg_USER_BAT_SEARCH_DIRS%^
  "%ProjectDir%\_VSPG"^
  "%ProjectDir%"^
  "%VSPG_StartDir%"

rem Remove *duplicate items* in SubbatSearchDirsNarrowToWide, so that %vspg_USER_BAT_SEARCH_DIRS%
rem has the ability to *completely* override the default search folders order.
call :RemoveDuplicateInVarname SubbatSearchDirsNarrowToWide


rem Copy SubbatSearchDirsNarrowToWide into SubbatSearchDirsWideToNarrow, but in reverse order:
call :ReverseParams SubbatSearchDirsWideToNarrow %SubbatSearchDirsNarrowToWide%


REM ======== call VSPG-Prebuild.bat or VSPG-Postbuild.bat ======== 
REM ===== which one to call is determined by SubworkBatfile ======

call "%bootsdir%\%SubworkBatfile%"
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

:EchosV1
  REM echo %* only when vspg_DO_SHOW_VERBOSE=1 .
  setlocal & set LastError=%ERRORLEVEL%
  if not defined vspg_DO_SHOW_VERBOSE goto :_EchosV1_done
  echo %_vspgINDENTS%[%batfilenam%]# %*
:_EchosV1_done
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

:Touch
	REM Touch updates a file's modification time to current.
	REM NOTE: No way to check for success/fail here. So, call it only when 
	REM you have decided to fail the whole bat.
	
	copy /b "%~1"+,, "%~1" >NUL 2>&1
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


:IsParamExisted
  REM Check whether a "needle word" exists in the list of parameters.
  REM (using case insensitive string compare)
  REM Usage:
  REM   call :IsParamExisted "needle word" param1 param2 "param 3" ...
  REM 
  REM Example:
  REM 
  REM   call :IsParamExisted  "foo word" param2 "foo word" param3
  REM --the result is ERRORLEVEL 1, which means "foo word" exists in the params.
  REM 
  REM For 
  REM   call :IsParamExisted  "foo word" param2 foo word param3
  REM --the result is ERRORLEVEL 0, which means "foo word" NOT existed in the params.
  REM 
  setlocal
  set needle=%~1
:_IsParamExisted_check1param
  shift
  if "%~1" == "" exit /b 0
  if /i "%~1" == "%needle%" exit /b 1
  goto :_IsParamExisted_check1param


:RemoveDuplicateParams
  REM Usage: 
  REM   call :RemoveDuplicateParams OutVar param1 param2 "param 3" ...
  REM
  REM Example:
  REM 
  REM   call :RemoveDuplicateParams MyVar abc 123 Abc "One word" "123"
  REM
  REM Output:
  REM   MyVar= "abc" "123" "One word"
  REM 
  REM Yes, it has side-effects, the OutVar's content will have each param surrounded 
  REM by double-quotes. The good news is, we can still use 
  REM   for %%i in (%MyVar%) do (
  REM      echo param=[%%~i]
  REM   )
  REM to split and process the params one-by-one.
  REM
  REM Limitation: Caller must not place a empty param ("") in the list,
  REM because the empty param will mark the end of the whole param list.
  REM
  setlocal
  set outvarName=%~1
  set outputValue=
:_RemoveDuplicateParams_check1param
  shift
  if "%~1" == "" goto :_RemoveDuplicateParams_end
  
  set param=%~1
  call :IsParamExisted "%param%" %outputValue%
  if not errorlevel 1 ( 
    REM Not existed yet, so append the new param to outputValue.
    set outputValue=%outputValue% "%param%"
  )
  goto :_RemoveDuplicateParams_check1param

:_RemoveDuplicateParams_end
  endlocal & (
    set "%outvarName%=%outputValue%"
  )
exit /b 0


:RemoveDuplicateInVarname
  REM Example:
  REM 
  REM   call :RemoveDuplicateInVarname MyVar
  REM 
  REM Check for contents in MyVar, as if MyVar's content is a series of params that would
  REM be passed to some new command. If some param has appeared before in the param list,
  REM remove it from the list, so that MyVar contains no duplicate items. 
  REM On return, MyVar's value is updated.
  REM 
  REM This function internally calls :RemoveDuplicateParams to do the core work.
  REM 
  setlocal
  set UserVarname=%~1
  set UserVarval=!%UserVarname%!
  call :RemoveDuplicateParams OutputVal %UserVarval%
  
  endlocal & (
    set "%UserVarname%=%OutputVal%"
  )
exit /b 0


:ReverseParams
  REM Usage: 
  REM   call :ReverseParams OutVar param1 param2 "param 3" ...
  REM
  REM Example:
  REM 
  REM   call :ReverseParams MyVar 123 456 "one word"
  REM 
  REM will result in:
  REM   MyVar="one word" "456" "123" 
  REM 
  REM Limitation: Caller must not place a empty param ("") in the list,
  REM because the empty param will mark the end of the whole param list.
  REM
  setlocal
  set outvarName=%~1
  set outputValue=
:_ReverseParams_nextword
  shift
  if "%~1" == "" goto :_ReverseParams_end

  set param=%~1
  set outputValue="%param%" %outputValue%
  goto :_ReverseParams_nextword

:_ReverseParams_end
  endlocal & (
    set "%outvarName%=%outputValue%"
  )
exit /b 0


:ReverseInVarName
  REM Example:
  REM 
  REM   set MyVar=123 456 "one word"
  REM   call :ReverseInVarName MyVar
  REM 
  REM will result in:
  REM   MyVar="one word" "456" "123"
  REM 
  REM This function internally calls :ReverseParams to do the core work.
  REM
  setlocal
  set UserVarname=%~1
  set UserVarval=!%UserVarname%!
  call :ReverseParams OutputVal %UserVarval%
  
  endlocal & (
    set "%UserVarname%=%OutputVal%"
  )
exit /b 0

