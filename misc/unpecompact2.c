
#include "unpecompact2.h"

/*/////////////////////////////
// Unpekomp2 
// 
// Version : 1.0 Public
//
// Date :  May, 15, 2006
//
// Target : Exe Files packed with Pecompact 2.x.
//          Should work on most pec2exed files (since i tested with an "unknow 2.x"
//             and the last retail 2.78a of March 2oo6)
//  
// Coder : MadMickael / TEAM FFF 2oo6
// 
// Loaders supported : pec2ldr_default.dll, pec2ldr_antidebug.dll :-),
//			 pec2ldr_debug.dll, pec2ldr_default.dll and pec2ldr_reduced.dll
//           
// Codec supported : Maybe all, since the program decompress itself !
//                   pec2codec_messagebox.dll : You must click the msgbox.
//                   pec2codec_password.dll : You must give it the good password .
//
// Features : Bypass IsDebuggerPresent (4 antidebug loader) 
//		& ReBuild FirstThunks from OriginalFistThunks
//
// Know Issues : * Since this program don't decrypt anything, resource section
//               is not repaired. But who cares?
//				 * Maybe some files won't be unpacked, who knows?
//
// Thks: All People who support us, who like us, and friends in ICU, FRET, CiM, 
//       & #FFF. 

///////////////////////////////*/


/*


	PEiD Plugin Coded By chenxiang.
	Release Time: 6/13/2013 8:09:24 PM


*/

HINSTANCE	hInstance=0;
char exefilename[260]={0};
int __stdcall Unpack(const char*);

int __stdcall DllEntryPoint(HINSTANCE hInst,HINSTANCE hPreInst,LPVOID lpvUnknown){hInstance=hInst;return 1;}

LPSTR	LoadDll()
{
	return "UnPECompact2";
}

DWORD DoMyJob(const HWND hDlg,const char* lpFile,const DWORD dwReserve,const LPVOID lParam)
{
	int i=lstrlen(lpFile);
	if((*(lpFile+(--i))=='E')||(*(lpFile+i)=='e'))Unpack(lpFile);
	else MessageBox(hDlg,"UnPECompact not supportted this file.",0,0x30);
	return 1;
}

int __stdcall Unpack(const char* lpFile)
{


BYTE BP = 0xCC;
WORD CRLF = 0x0A0D;
DWORD CALLEDI = 0x8589D7FF;
DWORD Movecxesiplus34 = 0x85344E8B;               
//00350B30                    8B4E 34                  MOV     ECX, DWORD PTR DS:[ESI+34]
//00350B33                    85C9                     TEST    ECX, ECX

char EXE[MAX_PATH] ="";
char lpDirectory[MAX_PATH] = "";

//Notre code Anti-IsDebuggerPresent ?injecter
//Fout le PEB_Isdebugged ?0 ;)
BYTE AntiIsDebug[14]  ={0x64,0xA1,0x18,0x00,0x00,0x00,        //  MOV     EAX, DWORD PTR FS:[18]
	                    0x8B,0x40,0x30,                        //  MOV     EAX, DWORD PTR DS:[EAX+30]
                        0xC6,0x40,0x02,0x00,0xCC};             //  MOV     BYTE PTR DS:[EAX+2], 0



int Bpcount = 0;
OPENFILENAME ofn;
DWORD addr = 0;
DWORD Bwrite = 0;
DWORD _PILE = 0;
DWORD SEH = 0;
DWORD BYTES_AT_OEPPLUS14 = 0;
FARPROC API = 0;

BOOL savefile = FALSE;
BOOL notpacked = FALSE;
HANDLE fmapfile = 0;
HANDLE fmapview = 0;
HANDLE ByteHnd =0;
HANDLE hndAlloc = 0;
DWORD AllocZone =0;

DWORD IMGBASE = 0;
DWORD SIZEOFIMAGE = 0;
DWORD SIZEOFHEADERS = 0;
DWORD tmp = 0;
DWORD PEMark= 0;
DWORD SECTIONTABLE =0 ;
DWORD SECTIONNUM = 0;

DWORD OEP = 0;
DWORD IMPORTRVA = 0;
DWORD ORIGFTHUNK = 0;
DWORD FTHUNK = 0;
DWORD CURRENTTHUNK = 0;


HANDLE FileHandle = 0;


	
	DWORD dwStatus = DBG_EXCEPTION_NOT_HANDLED;
	Bpcount= 0;


	ofn.lStructSize			= sizeof(OPENFILENAME);
	ofn.hwndOwner			= 0;
	ofn.lpstrFilter			= "Exe file (*.exe)\0*.exe\00";
	ofn.lpstrCustomFilter	= NULL;
	ofn.nFilterIndex		= 1;
	ofn.lpstrFile			= EXE;
	ofn.nMaxFile			= sizeof EXE;
	ofn.lpstrFileTitle		= NULL;
	ofn.nMaxFileTitle		= 0;
	ofn.lpstrInitialDir		= NULL;
	ofn.lpstrTitle			= 0;
	ofn.Flags				= OFN_EXPLORER | OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST | OFN_HIDEREADONLY | OFN_ENABLESIZING;
	ofn.lpstrDefExt			= NULL;
	ofn.lpstrTitle			= 0;

if (lpFile )
{
	lstrcpy(EXE,lpFile);
	
     __asm
	  {
		pushad
		lea esi, EXE
		push esi
		push esi
		call dword ptr lstrlen
		add esi, eax
		pop eax
		dec esi
	redo:
		cmp byte ptr [esi], 0x5C
		je ok
		dec esi
		jmp redo
	ok:
        SUB     ESI, EAX
        MOV     ECX, ESI
		inc ecx
		lea edi, lpDirectory
		lea esi, EXE
		rep movsb
		xor eax,eax
		stosb
		popad
	  }

	SetCurrentDirectory(lpDirectory);



	GetStartupInfo (&lpSi);
	CreateProcess (EXE,NULL,NULL,NULL,FALSE,DEBUG_ONLY_THIS_PROCESS + DEBUG_PROCESS,
		NULL,lpDirectory, &lpSi, &lpPi);

	//entering main debug loop
	for (;;)
	{
		WaitForDebugEvent (&DebEv,INFINITE);
		

		switch (DebEv.dwDebugEventCode)
		{
		case CREATE_PROCESS_DEBUG_EVENT:
			dwStatus = DBG_EXCEPTION_NOT_HANDLED;

			IMGBASE = (DWORD)DebEv.u.CreateProcessInfo.lpBaseOfImage;
			//PE Browsing

			//reading"PE"
			tmp=IMGBASE+ 0x3c;
	    	ZeroMemory(BuffPile, 4);
			ReadProcessMemory(lpPi.hProcess,(LPVOID)tmp,&PEMark,4,NULL);
			tmp = IMGBASE + PEMark+ 0x50;
			ZeroMemory(BuffPile, 4);
			ReadProcessMemory(lpPi.hProcess,(LPVOID)tmp,&SIZEOFIMAGE,4,NULL);
			
			ZeroMemory(BuffPile, 4);
			tmp = IMGBASE + PEMark+ 0x54;
			ReadProcessMemory(lpPi.hProcess,(LPVOID)tmp,&SIZEOFHEADERS,4,NULL);

			ZeroMemory(BuffPile, 4);
			tmp = IMGBASE + PEMark+ 0x28;
			ReadProcessMemory(lpPi.hProcess,(LPVOID)tmp,&OEP,4,NULL);
			OEP=OEP+IMGBASE;

			/*tmp = (DWORD)OEP + 0x14;
			ReadProcessMemory(lpPi.hProcess,(LPVOID)tmp,&BYTES_AT_OEPPLUS14,4,NULL);

				if   (BYTES_AT_OEPPLUS14 != 0x0889C033)                                    
				{
				   //removed because of the "pec2ldrdebug" which dont use SEH !
					notpacked = TRUE;
					MessageBox(0,"Not Packed by Pecompact 2 !", "Hey dude !",MB_ICONINFORMATION);
					goto Exit;
				}*/

			//Write our Anti-Isdebugger Code at OEP
			tmp = (DWORD)OEP;
			ReadProcessMemory(lpPi.hProcess,(LPVOID)tmp,BytesEP,14,NULL);
			WriteProcessMemory(lpPi.hProcess,(LPVOID)tmp,&AntiIsDebug,14,NULL);
			FlushInstructionCache(lpPi.hProcess,(LPCVOID)tmp,20);


  		break;

		case EXIT_PROCESS_DEBUG_EVENT:
			goto Exit;

		
		case EXCEPTION_DEBUG_EVENT:
		switch (DebEv.u.Exception.ExceptionRecord.ExceptionCode)
			{
 			case EXCEPTION_BREAKPOINT:
					
					dwStatus = DBG_CONTINUE;
					switch (Bpcount)
					{
					case 0:
						wsprintf (TempBuff,"Breakpoint Sur ntdll.DbgBreak(c normal) : %08lX", DebEv.u.Exception.ExceptionRecord.ExceptionAddress);
						Bpcount++;
					break;


					case 1:
						//our bp at OEP+13 (AntiIsDebuggerCode Passed ! :>)
						//Restore old EP bytes
						lstrcpy(TempBuff , "Break at EP 1... ");
						lpContext.ContextFlags = CONTEXT_FULL;
						GetThreadContext(lpPi.hThread,&lpContext);
						lpContext.Eip = OEP;
						SetThreadContext(lpPi.hThread,&lpContext);
						WriteProcessMemory(lpPi.hProcess,(LPVOID)OEP,BytesEP,14,NULL);

						//put BP at EP and set the address to EP
						ReadProcessMemory(lpPi.hProcess,(LPVOID)OEP,BuffCreate,1,NULL);
						WriteProcessMemory(lpPi.hProcess,(LPVOID)OEP,&BP,1,NULL);
						FlushInstructionCache(lpPi.hProcess,(LPCVOID)OEP,20);
						Bpcount++;


					break;

					case 2:
							//Break on EP_restored
							addr = (DWORD)DebEv.u.Exception.ExceptionRecord.ExceptionAddress;
							WriteProcessMemory(lpPi.hProcess,(LPVOID)addr,(LPVOID) BuffCreate,1,NULL);
							lpContext.ContextFlags = CONTEXT_FULL;
							GetThreadContext(lpPi.hThread,&lpContext);
					
							lpContext.Eip--;
							SetThreadContext(lpPi.hThread,&lpContext);


						//read SEH addr
							addr = lpContext.Eip + 1;
							ReadProcessMemory(lpPi.hProcess,(LPVOID)addr,BuffPile,4, NULL);
							SEH = * (DWORD * ) BuffPile;

						//BP on SEH
						 ReadProcessMemory(lpPi.hProcess,(LPVOID)SEH,BuffCreate,1,NULL);
					 	WriteProcessMemory(lpPi.hProcess,(LPVOID)SEH,&BP,1,NULL);


						Bpcount++;
					break;
					
					case 3:
						strcpy(TempBuff , "Break on SEH");
						addr = (DWORD)DebEv.u.Exception.ExceptionRecord.ExceptionAddress;
						WriteProcessMemory(lpPi.hProcess,(LPVOID)addr,(LPVOID) BuffCreate,1,NULL);
						lpContext.ContextFlags = CONTEXT_FULL | CONTEXT_DEBUG_REGISTERS;
						GetThreadContext(lpPi.hThread,&lpContext);
						lpContext.Eip--;
						SetThreadContext(lpPi.hThread,&lpContext);

						//SEEK THE "Magik call"	
						ReadProcessMemory(lpPi.hProcess,(LPVOID)addr,BuffFindOEP, 300,NULL);
						_asm
						{
							pushad
							lea eax, BuffFindOEP
							mov ebx, eax
							mov esi, dword ptr CALLEDI
						seekjmpoep:	
							cmp dword ptr [eax], esi
							je jmpeaxfund
							inc eax
							jmp seekjmpoep
						jmpeaxfund: 
							sub eax, ebx
							//add eax, 2
							add addr, eax
							popad
						}

						ReadProcessMemory(lpPi.hProcess,(LPVOID)addr,BuffCreate, 1, NULL);
						WriteProcessMemory(lpPi.hProcess,(LPVOID)addr,&BP,1,NULL);
						Bpcount++;
					break;


				    case 4:
							//Break CALL EDI
							addr = (DWORD)DebEv.u.Exception.ExceptionRecord.ExceptionAddress;
							WriteProcessMemory(lpPi.hProcess,(LPVOID)addr,(LPVOID) BuffCreate,1,NULL);
							lpContext.ContextFlags = CONTEXT_FULL;
						
							GetThreadContext(lpPi.hThread,&lpContext);
							lpContext.Eip--;
							SetThreadContext(lpPi.hThread,&lpContext);


							ofn.lpstrFile = "UnPacked.exe";
							ofn.lpstrTitle = "Core By MadMickael(for pec2 only). Plugin By chenxiang.";
							ofn.lpstrInitialDir = lpDirectory;
							if (GetSaveFileName(&ofn))
							{
								savefile = TRUE;

								//[ESI+0x34]=ImportRVA
								addr = lpContext.Esi + 0x34;//0x;
								ReadProcessMemory(lpPi.hProcess,(LPVOID)addr,&IMPORTRVA,4,NULL);

								//[ESI+0xC]=OEP
								addr = lpContext.Esi + 0xc;//0x;
								ReadProcessMemory(lpPi.hProcess,(LPVOID)addr,&OEP,4,NULL);

								addr = lpContext.Edi;

								//le MOV ECX, DWORD PTR [ESI+34] (ESI+34 = RVA ImportTable!) 
								ReadProcessMemory(lpPi.hProcess,(LPVOID)addr,&BuffFindOEP,300,NULL);

								//SEEK "Nice Mov"
									_asm
								{
									pushad
									lea eax, BuffFindOEP
									mov ebx, eax
									mov esi, dword ptr Movecxesiplus34
								seekmovecx:	
									cmp dword ptr [eax], esi
									je movecxfund
									inc eax
									jmp seekmovecx
								movecxfund: 
									sub eax, ebx
									//add eax, 2
									add addr, eax
									popad
								}
									WriteProcessMemory(lpPi.hProcess,(LPVOID)addr,&BP,1,NULL);
						
							}

							Bpcount++;
						break;

					case 5:	
							//Dumpit!
							hndAlloc = GlobalAlloc(GHND,SIZEOFIMAGE);// + SIZEOFHEADERS)
							AllocZone = (DWORD)GlobalLock(hndAlloc);
							ReadProcessMemory(lpPi.hProcess,(LPVOID)IMGBASE,(LPVOID)AllocZone,SIZEOFIMAGE,NULL);
							ByteHnd=CreateFile(ofn.lpstrFile,GENERIC_READ + GENERIC_WRITE,FILE_SHARE_WRITE,0,CREATE_ALWAYS,0,0);
							WriteFile(ByteHnd,(LPCVOID)AllocZone,SIZEOFIMAGE,&Bwrite,NULL);
							CloseHandle(ByteHnd);
							GlobalUnlock(hndAlloc);
							GlobalFree((LPVOID)AllocZone);
							TerminateProcess(lpPi.hProcess,0);
							Bpcount++;
						break;


					}
				break;


		 case EXCEPTION_ACCESS_VIOLATION: //don't care about THE SEH !

				dwStatus = DBG_EXCEPTION_NOT_HANDLED;

			   break;


		default:
		dwStatus = DBG_CONTINUE;
		break;

			}
		
		}


		ContinueDebugEvent (DebEv.dwProcessId,DebEv.dwThreadId,dwStatus);
		 
	}

Exit:
	
	if (savefile == TRUE)
{
	///OPEN FILE FOR :
	// 1. FIX OEP
	// 2. FIX RVA IMPORT TABLE
	// 3. REBUILD FIRSTHUNK

	FileHandle=CreateFile(ofn.lpstrFile,GENERIC_READ + GENERIC_WRITE,FILE_SHARE_WRITE,0,OPEN_EXISTING,0,0);
    fmapfile = CreateFileMapping(FileHandle,NULL,PAGE_READWRITE,0,0,NULL);
	fmapview = MapViewOfFile(fmapfile,FILE_MAP_WRITE,0,0,0);

    PEMark += (DWORD)fmapview;

	//
	__asm
	{
		pushad
		mov eax, PEMark

		//Nombre de Sections
		movsx ebx, word ptr [eax+6]
		mov SECTIONNUM, ebx

		//Table des sections
		movsx ebx, word ptr [eax+0x14]
	    lea eax, [eax+EBX+0x18]
		mov SECTIONTABLE,eax

		//Correction de la SizeOfHeaders
		mov ebx, dword ptr [eax+0xc]
		mov ecx, PEMark
		mov dword ptr [ecx+0x54], ebx


		// Correction des sections
	   mov eax, SECTIONTABLE
		mov ecx, SECTIONNUM
	yop:

		mov ebx, dword ptr [eax+8]  //VSIZE
		mov dword ptr [eax+0x10], ebx

		mov ebx, dword ptr [eax+0xC]  //RSIZE
		mov dword ptr [eax+0x14], ebx

		add eax, 0x28
		dec ecx
		cmp ecx, 0
		jne yop


//Correction de l'entrypoint
   mov eax, PEMark
   mov ebx, OEP
   //sub ebx, IMGBASE
   mov dword ptr [eax+0x28], ebx

//Correction de RVAIMPORTTABLE
	mov ebx, IMPORTRVA
	mov dword ptr [eax+0x80], ebx

   test ebx, ebx
   je noimports

   // Reconstruction des FirstThunk
   mov eax, fmapview
   add eax, ebx

   push eax
   pop ORIGFTHUNK


yapu:
   mov eax, ORIGFTHUNK

   mov ecx, [eax]
   cmp ecx, 0
   je firsthunkdone
   mov edx, [eax+16]

   push edx
   pop FTHUNK
 
   push ecx
   pop CURRENTTHUNK
 

   add ecx, fmapview
   add edx, fmapview

yoplait:
   mov eax, CURRENTTHUNK 
   test eax, 0x80000000
   jne ordinal

   add eax, fmapview

ordinal:
   MOV edx, FTHUNK
   add edx, fmapview

   mov ebx,[eax]  //EBX == LA BONNE VALEUR
   cmp ebx, 0
   je nextdll

   mov dword ptr [edx], ebx

nexthunk:
   mov eax,CURRENTTHUNK
   add eax, 4
   mov CURRENTTHUNK, eax 
   mov eax, FTHUNK 
   add eax, 4
   mov FTHUNK, eax
   jmp yoplait

nextdll:
   add ORIGFTHUNK, 0x14
   jmp yapu

firsthunkdone:

noimports:
popad

}
    
	UnmapViewOfFile(fmapview);
	CloseHandle(fmapfile);
	CloseHandle(FileHandle);
	ZeroMemory(TempBuff, sizeof(TempBuff));
	ZeroMemory(TempBuff2, sizeof(TempBuff2));
	lstrcpy(TempBuff, "File Unpacked !\nOEP : %08lX\nImport Table Rva : %08lX");

    wsprintf(TempBuff2,TempBuff, OEP,IMPORTRVA);

	MessageBox(0,TempBuff2,"hey Dude !",MB_ICONINFORMATION);

} else if ((notpacked)!= TRUE)
	{
		MessageBox(0,"Can't save file...","hey Dude !",0x30);
	}
    




;}

fin:

	return TRUE;
}
