;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

_IsDll	proc uses esi lpFile:DWORD
	LOCAL		@hFile:DWORD
	LOCAL		@hFileMap:DWORD
	LOCAL		@lpMem:DWORD
	LOCAL		@dwRet:DWORD
	mov			@dwRet,0
	invoke	CreateFile,lpFile,GENERIC_READ,FILE_SHARE_DELETE,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	.if			eax != -1
		mov			@hFile,eax
		invoke	CreateFileMapping,@hFile,0,PAGE_READONLY,0,0,0
		.if			eax
			mov			@hFileMap,eax
			invoke	MapViewOfFile,@hFileMap,FILE_MAP_READ,0,0,0
			.if			eax
				mov			@lpMem,eax
				mov			esi,@lpMem
				assume	esi:PTR IMAGE_DOS_HEADER
				.if			[esi].e_magic == 'ZM'	
					add			esi,[esi].e_lfanew
					assume	esi:PTR IMAGE_NT_HEADERS
					.if			[esi].Signature == 'EP'
						movzx		eax,[esi].FileHeader.Characteristics
						and			eax,2000H
						mov			@dwRet,eax
					.endif
				.endif
				assume	esi:nothing
				invoke	UnmapViewOfFile,@lpMem
			.endif
			invoke	CloseHandle,@hFileMap
		.endif
		invoke	CloseHandle,@hFile
	.endif
	mov			eax,@dwRet
	ret
_IsDll	endp

_ProcessFile	proc	uses edi,lpFileName:DWORD
	LOCAL		@hMenu:DWORD
	LOCAL		@lpStr:DWORD
	LOCAL		@lpfnEntry:DWORD
	LOCAL		@lpfnDect:DWORD
	LOCAL		@hMod:DWORD
	invoke	_IsDll,lpFileName
	.if			eax
		invoke	LoadLibrary,lpFileName
  	.if			eax
  		mov			@hMod,eax
  		invoke	GetProcAddress,@hMod,offset szLoadDll
  		.if			eax
  			push		ebp
  			push		offset __@@SafePos1
  			push		offset _HandlerProc
  			push		fs:[0]
  			mov			fs:[0],esp
  			call		eax
  			mov			@lpStr,eax
  			invoke	GetProcAddress,@hMod,offset szDoMyJob
  			.if			eax
  				mov			@lpfnEntry,eax
  				.if			hMenuPlg
    				invoke	AppendMenu,hMenuPlg,0,dwCMDID,@lpStr
    				;;
    				mov			edi,lpCommand
    				assume	edi:PTR PLUGIN
    				push		dwCMDID
    				pop			[edi].dwID
    				push		@lpfnEntry
    				pop			[edi].lpfnProc
    				mov			[edi].dwIndirect,0
    				invoke	HeapAlloc,stFile.hHeap,HEAP_ZERO_MEMORY or HEAP_GENERATE_EXCEPTIONS,sizeof PLUGIN
    				mov			[edi].lpNext,eax
    				assume	edi:nothing
    				mov			esi,eax
    				push		[edi+PLUGIN.dwReserve]
    				pop			[esi+PLUGIN.dwReserve]
    				mov			[esi+PLUGIN.dwID],0
    				mov			[esi+PLUGIN.lpNext],0
    				mov			[esi+PLUGIN.lpfnProc],0
    				;;
    				pushad
    				invoke	_SetRptEdit,@lpStr
    				popad
    				;;
    				mov			lpCommand,eax
    				inc			dwCMDID
    			.endif
  			.else
  				invoke	GetProcAddress,@hMod,offset szDoMyJobIndirect
  				.if			eax
  					mov			@lpfnEntry,eax
    				.if			hMenuPlg
      				invoke	AppendMenu,hMenuPlg,0,dwCMDID,@lpStr
      				;;
      				mov			edi,lpCommand
      				assume	edi:PTR PLUGIN
      				push		dwCMDID
      				pop			[edi].dwID
      				push		@lpfnEntry
      				pop			[edi].lpfnProc
      				mov			[edi].dwIndirect,1
      				invoke	HeapAlloc,stFile.hHeap,HEAP_ZERO_MEMORY or HEAP_GENERATE_EXCEPTIONS,sizeof PLUGIN
      				mov			[edi].lpNext,eax
      				assume	edi:nothing
      				mov			esi,eax
      				push		[edi+PLUGIN.dwReserve]
      				pop			[esi+PLUGIN.dwReserve]
      				mov			[esi+PLUGIN.dwID],0
      				mov			[esi+PLUGIN.lpNext],0
      				mov			[esi+PLUGIN.lpfnProc],0
      				;;
      				pushad
      				invoke	_SetRptEdit,@lpStr
      				popad
      				;;
      				mov			lpCommand,eax
      				inc			dwCMDID
      			.endif
  				.endif
  			.endif
  			__@@SafePos1:
  			pop			fs:[0]
  			add			esp,12
  		.endif
  	.endif
	.endif
	ret
_ProcessFile	endp

_FindFile	proc	_lpszPath:DWORD
		local	@stFindFile:WIN32_FIND_DATA
		local	@hFindFile
		local	@szPath[MAX_PATH]:byte		
		local	@szSearch[MAX_PATH]:byte	
		local	@szFindFile[MAX_PATH]:byte	

		pushad
		invoke	lstrcpy,addr @szPath,_lpszPath
;********************************************************************
		@@:
		invoke	lstrlen,addr @szPath
		lea	esi,@szPath
		add	esi,eax
		xor	eax,eax
		mov	al,'\'
		.if	byte ptr [esi-1] != al
			mov	word ptr [esi],ax
		.endif
		invoke	lstrcpy,addr @szSearch,addr @szPath
		invoke	lstrcat,addr @szSearch,addr szFindFilter
;********************************************************************
		invoke	FindFirstFile,addr @szSearch,addr @stFindFile
		.if	eax !=	INVALID_HANDLE_VALUE
			mov	@hFindFile,eax
			.repeat
				invoke	lstrcpy,addr @szFindFile,addr @szPath
				invoke	lstrcat,addr @szFindFile,addr @stFindFile.cFileName
				.if	@stFindFile.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY
					.if	@stFindFile.cFileName != '.'
						invoke	_FindFile,addr @szFindFile
					.endif
				.else
					invoke	_ProcessFile,addr @szFindFile
				.endif
				invoke	FindNextFile,@hFindFile,addr @stFindFile
			.until	!eax
			invoke	FindClose,@hFindFile
		.endif
		popad
		ret
_FindFile	endp

_LoadPlugins	proc	lParam:DWORD ;;hMenuPlg
	LOCAL		@szBuf[260]:BYTE
	LOCAL   @szDirs[260]:BYTE
	pushad
	invoke	SetEvent,hEvent
	invoke	WaitForSingleObject,hEvent,INFINITE
  jmp     @F
  db      'plugins',0
  @@:
  invoke  GetModuleFileName,stFile.hInstance,addr @szDirs,sizeof @szDirs
  or      eax,eax
  jz      @F
  pushf
  invoke  lstrlen,addr @szDirs
  lea     edi,@szDirs
  add     edi,eax
  mov     eax,'\'
  std
  repnz   scasb
  mov     BYTE PTR [edi + 2],0
  popf
  invoke  lstrcpy,addr @szBuf,addr @szDirs
  invoke  lstrcat,addr @szBuf,offset @B - 8
  invoke	HeapCreate,HEAP_GENERATE_EXCEPTIONS,0,0
  or			eax,eax
  jz			@F
  mov			stFile.hHeap,eax
  invoke	HeapAlloc,eax,HEAP_ZERO_MEMORY or HEAP_GENERATE_EXCEPTIONS,sizeof PLUGIN
  or			eax,eax
  jz			@F
  mov			lpCommand,eax
  mov			[eax+PLUGIN.dwReserve],eax
  mov			[eax+PLUGIN.dwID],0
  mov			[eax+PLUGIN.lpNext],0
  mov			[eax+PLUGIN.lpfnProc],0
	invoke	_FindFile,addr @szBuf
	mov			eax,lpCommand
	push		[eax+PLUGIN.dwReserve]
	pop			lpCommand
	@@:
	invoke	lstrcpy,addr @szBuf,addr @szDirs
	invoke	lstrcat,addr @szBuf,offset szPEDetectDll
	invoke	LoadLibrary,addr @szBuf
	.if			eax
		invoke	GetProcAddress,eax,offset szPEDetect
		.if			eax
			mov			lpPEDetectEntry,eax
		.endif
	.endif
	invoke	ResetEvent,hEvent
	popad
	ret
_LoadPlugins	endp

_DefCommandDo	proc	hWnd:DWORD,wParam:DWORD,lParam:DWORD
	.if			!lpCommand || !stFile.lpMem
		ret
	.endif
	pushad
	mov			esi,lpCommand
	xor			eax,eax
	cld
	lodsd
	.if			eax
		mov			eax,wParam
		and			eax,0ffffh
		mov			esi,lpCommand
  	.while	1
  		.break	.if eax == [esi+PLUGIN.dwID]
  		.break	.if	![esi+PLUGIN.dwID] && ![esi+PLUGIN.lpfnProc]
  		mov			esi,[esi+PLUGIN.lpNext]
  	.endw
  	.if			eax == [esi+PLUGIN.dwID]
  		push		ebp
  		push		offset __@@SafePos
  		push		offset _HandlerProc
  		push		fs:[0]
  		mov			fs:[0],esp
  		mov			eax,'PEiD'
  		mov			edi,[esi+PLUGIN.lpfnProc] ;;DoMyJob(xx,xx,xx,xx) or  DoMyJobIndirect(xx).
  		.if			[esi+PLUGIN.dwIndirect]
  			push		offset stFile
  			call		edi
  			add			esp,4  ;; C Calling Convention.
  		.else		
	  		push		0
	  		push		eax
	  		push		offset stFile.szFile
	  		push		stFile.hWinMain
	  		call		edi
	  		add			esp,16 ;; C Calling Convention.
  		.endif
  		__@@SafePos:
  		pop			fs:[0]
  		add			esp,12
  	.endif
  .endif
	popad
	ret
_DefCommandDo	endp
