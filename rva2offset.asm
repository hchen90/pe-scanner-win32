
_RVAToRAW		proc	uses edi esi ecx edx ebx,_lpMem:DWORD,_dwRva:DWORD
		LOCAL		@dwRet:DWORD
		mov			@dwRet,0
		mov			esi,_lpMem
		xor			eax,eax
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
		assume	esi:PTR IMAGE_DOS_HEADER
		.if			[esi].e_magic != IMAGE_DOS_SIGNATURE
				jmp		Exit_
		.endif
		;;
		add			esi,[esi].e_lfanew
		assume	esi:PTR	IMAGE_NT_HEADERS
		.if			[esi].Signature != IMAGE_NT_SIGNATURE
				jmp		Exit_
		.endif
		;;
		movzx		ecx,[esi].FileHeader.NumberOfSections
																							;;;;	ecx --> number of sections
		;;			
		mov			edi,_dwRva												;;;;	edi --> RVA
		.if			[esi].OptionalHeader.Magic == 010BH
			add			esi,24+216+8
		.elseif [esi].OptionalHeader.Magic == 020BH
			add			esi,24+232+8
		.endif
		
		_StartLoop:
		cmp			ecx,0
		jle			_EndLoop
		assume	esi:PTR	IMAGE_SECTION_HEADER
		mov			eax,[esi].VirtualAddress
		add			eax,[esi].SizeOfRawData
		.if			(edi>=[esi].VirtualAddress) && (edi<=eax)
				sub		edi,[esi].VirtualAddress
				add		edi,[esi].PointerToRawData			;;;;  edi  --> this is raw offset
				mov		@dwRet,edi
				jmp		_EndLoop
		.endif
		dec			ecx
		mov			eax,_dwRva
		.if			eax < [esi].VirtualAddress
			mov			@dwRet,eax
		.endif
		add			esi,sizeof IMAGE_SECTION_HEADER
		jmp			_StartLoop
		_EndLoop:
		
		mov			EAX,@dwRet													;;;;	store value in edi into EAX;this value is an pointer
		
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Exit_:
		assume	esi:nothing
		ret
_RVAToRAW		endp
