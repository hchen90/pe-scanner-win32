;;
;

_RetriveCmdLine	proc	_lpSrc:DWORD,_lpDes:DWORD
	pushad
	mov			ecx,260
	xor			eax,eax
	mov			esi,_lpSrc
	mov			edi,_lpDes
	cld
	lodsb
	.if			eax == '"'
		.while	1
			xor			eax,eax
			cld
			lodsb
			.break  .if !eax
			.if			eax == '"'
				jmp			@F
			.endif
		.endw
	.endif
	popad
	ret
	@@:
	xor			eax,eax
	cld
	lodsb
	.if			eax == 20H
		.while	eax
			xor			eax,eax
			cld
			lodsb
			.if			eax == '"'
				cld
				lodsb
			.endif
			.break  .if !eax
			cld
			stosb
		.endw
	.endif
	xor			eax,eax
	cld
	stosb
	popad
	ret
_RetriveCmdLine	endp
