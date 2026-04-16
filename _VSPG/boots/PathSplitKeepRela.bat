:PathSplitKeepRela
REM Usage: 
REM call PathSplitKeepRela.bat "..\foo\bar.txt" dname fname
REM Output dname=..\foo
REM Output fname=bar.txt
REM Code help with ChatGPT.

setlocal EnableDelayedExpansion
set "full=%~1"

REM Extract filename (after last backslash)
for %%A in ("%full%") do set "name=%%~nxA"

REM Copy full path
set "dir=%full%"

REM Strip everything after the last backslash
:loop
if not "!dir!"=="" (
    if "!dir:~-1!"=="\" goto done
    set "dir=!dir:~0,-1!"
    goto loop
)

:done
REM Remove trailing backslash
if defined dir if "!dir:~-1!"=="\" set "dir=!dir:~0,-1!"

endlocal & (
  set "%~2=%dir%"
  set "%~3=%name%"
)
exit /b
