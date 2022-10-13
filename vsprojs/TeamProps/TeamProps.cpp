#include <stdio.h>
#include <stdlib.h>
#include <tchar.h>
#include <locale.h>

int _tmain(int argc, TCHAR* argv[])
{
	setlocale(LC_ALL, "");
	
	_tprintf(_T("Hello, TeamProps!\n"));
	_tprintf(_T("sizeof(TCHAR)=%d\n"), sizeof(TCHAR));
	return 0;
}

/*
 * With VSPG.Team.props and Team-Postbuild.bat Build,
 * Project build output is like follows.
 * We see that env-var TeamName,ConfigurationType and ProjectGuid is made available for VSGP bat to use.

1>------ Build started: Project: TeamProps, Configuration: Debug Win32 ------
1>Build started 2022-10-13 9:39:49 PM.
1>InitializeBuildStatus:
1>  Creating "D:\gitw\VSPG\vsprojs\TeamProps\obj-v100\Win32\Debug\TeamProps.unsuccessfulbuild" because "AlwaysCreate" was specified.
1>ClCompile:
1>  All outputs are up-to-date.
1>Link:
1>  All outputs are up-to-date.
1>  TeamProps.vcxproj -> D:\gitw\VSPG\vsprojs\TeamProps\bin-v100\Win32\Debug\TeamProps.exe
1>VSPG_PostBuild:
1>  ...[Team-Postbuild.bat] START from "D:\gitw\VSPG\vsprojs\TeamProps"
1>  ...[Team-Postbuild.bat] TeamName = Wanderer
1>  ...[Team-Postbuild.bat] ConfigurationType = Application
1>  ...[Team-Postbuild.bat] ProjectGuid = {20221012-0000-0000-0000-132030000002}
1>FinalizeBuildStatus:
1>  Deleting file "D:\gitw\VSPG\vsprojs\TeamProps\obj-v100\Win32\Debug\TeamProps.unsuccessfulbuild".
1>  Touching "D:\gitw\VSPG\vsprojs\TeamProps\obj-v100\Win32\Debug\TeamProps.lastbuildstate".
1>
1>Build succeeded.
1>
1>Time Elapsed 00:00:01.20

*/