#include <windows.h>

#pragma	comment(lib,"kernel32.lib")
#pragma	comment(lib,"user32.lib")

int report(const HWND,const char*);

int __stdcall DllMain(HINSTANCE hInst,HINSTANCE hPreInst,LPVOID lpvUnknown)
{
	return 1;
}

int __stdcall GetInfo(const LPVOID lpMem,const HWND hEdit)
{
	int i=0,size32=sizeof(IMAGE_OPTIONAL_HEADER32),size64=sizeof(IMAGE_OPTIONAL_HEADER64);
	float entp=0;
	char buf[MAX_PATH]={0},buf2[MAX_PATH]={0};
	IMAGE_SECTION_HEADER* pSec={0};
	IMAGE_NT_HEADERS* pNt={0};
	IMAGE_DOS_HEADER* pDos=(IMAGE_DOS_HEADER*)lpMem;
	size32+=4+sizeof(IMAGE_FILE_HEADER);
	size64+=4+sizeof(IMAGE_FILE_HEADER);
	if(pDos->e_magic==IMAGE_DOS_SIGNATURE){
		pNt=(IMAGE_NT_HEADERS*)((DWORD)lpMem+pDos->e_lfanew);
		if(pNt->Signature==IMAGE_NT_SIGNATURE){
			if(pNt->OptionalHeader.Magic==0x20b){
				report(hEdit,"This is 64bit App.");
			} else report(hEdit,"This is 32bit App.");
		}
	}
	return 0;
}

int report(const HWND hEdit,const char* text)
{
	char buf[260];
	if(text){
		lstrcpy(buf,text);
	} else wsprintf(buf,"Error! [%d]",GetLastError());
	SendMessage(hEdit,WM_SETTEXT,0,(LPARAM)buf);
	return 0;
}


