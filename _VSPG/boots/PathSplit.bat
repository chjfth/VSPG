
:PathSplit
REM Usage: 
REM call PathSplit.bat "c:\program files\d2\d3.txt" dname fname
REM Output dname=c:\program files\d2
REM Output fname=d3.txt
REM
REM Note: The output dname will always be a absolute path, due to %%~dp .
REM To avoid this behavior, use PathSplitKeepRela.bat instead.
  
  setlocal
  REM setlocal ensures setting `path` does not overwrite caller env's PATH.
  set path=%~1
  For %%A in ("%path%") do (
    set Folder=%%~dpA
    set Name=%%~nxA
  )
  endlocal & (
    set "%~2=%Folder:~0,-1%"
    set "%~3=%Name%"
  )
exit /b %ERRORLEVEL%
