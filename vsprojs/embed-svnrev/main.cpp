#include <stdio.h>
#include <stdlib.h>
#include <tchar.h>
#include <locale.h>

extern int g_svnrev;

int _tmain(int argc, TCHAR* argv[])
{
	setlocale(LC_ALL, "");
	
	_tprintf(_T("Hello, embed-svnrev!\n"));
	_tprintf(_T("Built from svn revision: %d\n"), g_svnrev);
	return 0;
}

