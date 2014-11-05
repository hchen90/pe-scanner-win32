
_Offset2Rva		proc	uses edi esi ecx edx ebx,_lpMem:DWORD,_dwOffset:DWORD
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
		.if			[esi].OptionalHeader.Magic == 010BH
			add			esi,24+216+8
		.elseif [esi].OptionalHeader.Magic == 020BH
			add			esi,24+232+8
		.endif
		
		mov			edi,_dwOffset
		_StartLoop:
		or			ecx,ecx
		jz			_EndLoop
		assume	esi:PTR	IMAGE_SECTION_HEADER
		mov			eax,[esi].PointerToRawData
		add			eax,[esi].SizeOfRawData
		.if			(edi>=[esi].PointerToRawData) && (edi<eax)
				sub		edi,[esi].PointerToRawData
				add		edi,[esi].VirtualAddress			;;;;  edi 
				mov		@dwRet,edi
				jmp		_EndLoop
		.endif
		dec			ecx
		mov			eax,_dwOffset
		.if			eax < [esi].PointerToRawData
			mov			@dwRet,eax
		.endif
		add			esi,sizeof IMAGE_SECTION_HEADER
		jmp			_StartLoop
		_EndLoop:
		
		mov			EAX,@dwRet														;;;;	store value in edi into EAX;this value is an pointer
		
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Exit_:
		assume	esi:nothing
		ret
_Offset2Rva		endp
