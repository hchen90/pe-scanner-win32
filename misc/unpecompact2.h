#pragma comment (compiler)
//#pragma comment (exestr, "FFFROX!") //mattez le PE header :)

#pragma	comment(lib,"kernel32.lib")
#pragma comment(lib,"user32.lib")
#pragma	comment(lib,"comdlg32.lib")

#pragma once
#define WIN32_LEAN_AND_MEAN

// Win Header Files:
#include <windows.h>
#include <winnt.h>
#include <commdlg.h>
// program headers

static	STARTUPINFO lpSi;
static PROCESS_INFORMATION lpPi;
static DEBUG_EVENT DebEv;
static CONTEXT lpContext;//= {CONTEXT_ALL};
static char TempBuff [100]=""; //buffer wsprintf
static char TempBuff2 [150]=""; //buffer wsprintf
static char BuffCreate [1]="";//buffer des opcodes lus sur le processus
static char BytesEP[14]="";
static char BuffPile[4] ="";
static char BuffFindOEP[300] = "";




