#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <windowsx.h>
#include <tchar.h>
#include <stdio.h>
#include "CmnHdr-Jeffrey.h"
#include "resource.h"
#include "mc-src\0804.h" // need msgid macro MSG_DengGuanQueLou

#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\"")

HINSTANCE g_hinstExe;

struct Poem_st
{
	LANGID langid;
	TCHAR content[400];
};

Poem_st g_poems[] =
{
	{0x0804},
	{0x0404},
	{0x0409},
};


void MyRefreshPoem(HWND hdlg, int idx)
{
	SetDlgItemText(hdlg, IDC_EDIT1, g_poems[idx].content);
}

void MyLoadPoem(HWND hdlg)
{
	TCHAR textbuf[200] = {};
	TCHAR tmpbuf[200] = {};

	HWND hlbLang = GetDlgItem(hdlg, IDC_LISTBOX1);

	int i;
	for (i = 0; i < ARRAYSIZE(g_poems); i++)
	{
		Poem_st& poem = g_poems[i];

		GetLocaleInfo(poem.langid, LOCALE_SNATIVELANGUAGENAME, tmpbuf, ARRAYSIZE(tmpbuf));

		_sntprintf_s(textbuf, _TRUNCATE, _T("0x%04X: %s"), poem.langid, tmpbuf);
		ListBox_AddString(hlbLang, textbuf);

		FormatMessage(
			FORMAT_MESSAGE_FROM_HMODULE, // will get message from my own EXE, not from system
			NULL, // message resource from current EXE
			MSG_DengGuanQueLou, // the msgid from 0804.mc 
			poem.langid,
			poem.content,
			ARRAYSIZE(poem.content),
			NULL);
	}

	MyRefreshPoem(hdlg, 0);

}

void Dlg_OnCommand(HWND hdlg, int id, HWND hwndCtl, UINT codeNotify) 
{
	switch (id) 
	{{
	case IDC_LISTBOX1:
	{
		if(codeNotify==LBN_SELCHANGE)
		{
			HWND hlb = GetDlgItem(hdlg, IDC_LISTBOX1);
			int idx = ListBox_GetCurSel(hlb);
			MyRefreshPoem(hdlg, idx);
		}
		break;
	}
	case IDOK:
	case IDCANCEL:
	{
		EndDialog(hdlg, id);
		break;
	}
	}}
}

BOOL Dlg_OnInitDialog(HWND hdlg, HWND hwndFocus, LPARAM lParam) 
{
	chSETDLGICONS(hdlg, IDI_WINMAIN);

	MyLoadPoem(hdlg);
	
	return 0; // Let Dlg-manager respect SetFocus().
}

INT_PTR WINAPI Dlg_Proc(HWND hdlg, UINT uMsg, WPARAM wParam, LPARAM lParam) 
{
	switch (uMsg) 
	{
		chHANDLE_DLGMSG(hdlg, WM_INITDIALOG,    Dlg_OnInitDialog);
		chHANDLE_DLGMSG(hdlg, WM_COMMAND,       Dlg_OnCommand);
	}
	return FALSE;
}


int WINAPI _tWinMain(HINSTANCE hinstExe, HINSTANCE, PTSTR pszCmdLine, int) 
{
	g_hinstExe = hinstExe;

	DialogBoxParam(hinstExe, MAKEINTRESOURCE(IDD_WINMAIN), NULL, Dlg_Proc, NULL);

	return 0;
}
