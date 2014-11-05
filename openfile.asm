_OpenFile	proc uses esi,_lpFile:DWORD
		LOCAL		@hFile:DWORD
		LOCAL		@dwSize:DWORD
		LOCAL		@lpMem:DWORD
		LOCAL		@dwTmp:DWORD
		sub			stFile.lpMem,0
		jz			@F
		invoke	VirtualFree,stFile.lpMem,0,MEM_RELEASE
		mov			stFile.lpMem,0
		mov			stFile.cbMem,0
		@@:
		mov			@hFile,0
		sub			_lpFile,0
		jz			@F
		pushad
		invoke  _AddFileToList,_lpFile,stFile.hMenu
		popad
		invoke	CreateFile,_lpFile,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
  	cmp			eax,-1
  	je			@F
  	mov			@hFile,eax
  	invoke	GetFileSize,@hFile,0
  	cmp			eax,-1
  	je			@F
  	mov			@dwSize,eax
  	mov			stFile.cbMem,eax
  	invoke	VirtualAlloc,0,@dwSize,MEM_COMMIT or MEM_RESERVE,PAGE_READWRITE
  	or			eax,eax
  	jz			@F
  	mov			@lpMem,eax
  	invoke	ReadFile,@hFile,@lpMem,@dwSize,addr @dwTmp,0
  	invoke	CloseHandle,@hFile
	push	PAGE_READWRITE
  	invoke	VirtualProtect,@lpMem,@dwSize,PAGE_READONLY,esp
	add		esp,4
  	mov			esi,@lpMem
  	push		eax
  	push		ebp
		push		offset @@@check
		push		offset _HandlerProc
		assume	fs:nothing
		push		fs:[0]
		mov			fs:[0],esp
		assume	esi:PTR IMAGE_DOS_HEADER
		.if			[esi].e_magic == IMAGE_DOS_SIGNATURE
			add			esi,[esi].e_lfanew
			assume	esi:PTR IMAGE_NT_HEADERS
			.if			[esi].Signature == IMAGE_NT_SIGNATURE
			movzx		eax,[esi].OptionalHeader.Magic
			movzx		ecx,[esi].FileHeader.Machine
				.if		eax	 == 020BH && ecx == 8664H
					mov			stFile.dwReserve,64
				.else
					mov			stFile.dwReserve,32
				.endif
				mov			stFile.dwReserve[04],0
				mov			stFile.dwReserve[08],0
				mov			stFile.dwReserve[12],0
			.endif
		.endif
		@@@check:
		assume	esi:nothing
		pop			fs:[0]
		add			esp,12
		mov			eax,@lpMem
  	ret
  	@@:
  	cmp			@hFile,0
  	je			@F
  	invoke	CloseHandle,@hFile
  	@@:
  	xor			eax,eax
		ret
_OpenFile	endp
