;crc32.asm
;


_CreateCrc32Table	proc	_lpMem:DWORD
	LOCAL		@dwCRC:DWORD
	pushad
	mov			edi,_lpMem
	mov			ecx,256
	__LOP0:
	push		ecx
	mov			eax,256
	sub			eax,ecx
	mov			@dwCRC,eax
	mov			ecx,8
	__LOP1:
	test		@dwCRC,1
	jz			@F
	shr			@dwCRC,1
	xor			@dwCRC,0EDB88320H
	jmp			@@@CRCL
	@@:
	shr			@dwCRC,1
	@@@CRCL:
	loop		__LOP1
	mov			eax,@dwCRC
	cld
	stosd
	pop			ecx
	loop		__LOP0
	popad
	ret
_CreateCrc32Table	endp

_GenerateCrc32Value	proc	_lpMem:DWORD,_lpTable:DWORD,_cbSize:DWORD
	LOCAL		@dwRet:DWORD
	pushad
	mov			@dwRet,0FFFFFFFFH
	mov			ecx,_cbSize
	mov			esi,_lpMem
	@@:
	push		ecx
	mov			ebx,@dwRet
	xor			eax,eax
	cld
	lodsb
	xor			eax,ebx
	and			eax,0FFH
	mov			ebx,_lpTable
	mov			eax,DWORD PTR [ebx+eax*4]
	mov			ebx,@dwRet
	shr			ebx,8
	xor			eax,ebx
	mov			@dwRet,eax
	pop			ecx
	loop		@B
	popad
	not			@dwRet
	mov			eax,@dwRet
	ret
_GenerateCrc32Value	endp

