;;
;

_Ascii2Dword16	proc	_lpStr:DWORD
	LOCAL		@dwRet:DWORD
	LOCAL		@szBuf[260]:BYTE
	pushad
	mov			@dwRet,0
	xor			eax,eax
	mov			ecx,260
	lea			edi,@szBuf
	cld
	rep			stosb
	mov			esi,_lpStr
	.while	1
  	xor			eax,eax
  	cld
  	lodsb
  	.break	.if	!eax
  	.if			eax > 60H && eax < 67H
  		and			eax,not 20H
  	.endif
  	.if			eax	> 40H && eax < 47H
  		sub			eax,37H
  	.elseif eax > 2FH && eax < 3AH
			sub			eax,30H
  	.else
  		xor			eax,eax
  	.endif
  	add			@dwRet,eax
  	xor			eax,eax
  	cld
  	lodsb
  	.break	.if	!eax
  	dec			esi
  	mov			eax,@dwRet
  	mov			ecx,10H
  	xor			edx,edx
  	mul			ecx
  	mov			@dwRet,eax
  .endw
  popad
  mov			eax,@dwRet
	ret
_Ascii2Dword16	endp
