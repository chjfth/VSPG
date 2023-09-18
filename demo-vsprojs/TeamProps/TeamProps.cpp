#include <stdio.h>
#include <stdlib.h>
#include <tchar.h>
#include <locale.h>

int _tmain(int argc, TCHAR* argv[])
{
	setlocale(LC_ALL, "");
	
	_tprintf(_T("Hello, TeamProps!\n"));
	_tprintf(_T("sizeof(TCHAR)=%d\n"), (int)sizeof(TCHAR));
	return 0;
}

/*

With the customized VSPU.props, Project build output is like follows.
We see that env-var TeamName, ConfigurationType and ProjectGuid is made available for VSPG bat to use.

1>------ Build started: Project: TeamProps, Configuration: Debug Win32 ------
1>Build started 2023-09-18 14:02:14.
1>VSPG_ShowLoaded:
1>  VSPG version 603 loaded from: D:\gitw\VSPG\_VSPG\boots
1>InitializeBuildStatus:
1>  Creating "D:\gitw\VSPG\demo-vsprojs\TeamProps\obj-v100\Win32\Debug\TeamProps.unsuccessfulbuild" because "AlwaysCreate" was specified.
1>ClCompile:
1>  All outputs are up-to-date.
1>Link:
1>  All outputs are up-to-date.
1>  TeamProps.vcxproj -> D:\gitw\VSPG\demo-vsprojs\TeamProps\bin-v100\Win32\Debug\TeamProps.exe
1>VSPG_PostBuild:
1>  ...[VSPU-PostBuild.bat] START from "D:\gitw\VSPG\demo-vsprojs\TeamProps\_VSPG"
1>  ...[VSPU-PostBuild.bat] TeamName = Wanderer
1>  ...[VSPU-PostBuild.bat] ConfigurationType = Application
1>  ...[VSPU-PostBuild.bat] ProjectGuid = {20230918-0000-0000-0000-135200000001}
1>FinalizeBuildStatus:
1>  Deleting file "D:\gitw\VSPG\demo-vsprojs\TeamProps\obj-v100\Win32\Debug\TeamProps.unsuccessfulbuild".
1>  Touching "D:\gitw\VSPG\demo-vsprojs\TeamProps\obj-v100\Win32\Debug\TeamProps.lastbuildstate".
1>
1>Build succeeded.
1>
1>Time Elapsed 00:00:01.14
========== Build: 1 succeeded, 0 failed, 0 up-to-date, 0 skipped ==========

*/