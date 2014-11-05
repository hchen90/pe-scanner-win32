;;;

lpOldEditControlEntry:
								dd	?

_Do16EditProc	proc	uses esi edi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	.if			uMsg == WM_CHAR
		mov			eax,wParam
		.if			eax == 08H || eax == 7FH
			jmp			_16EditDefaultDo
		.endif
		invoke	SendMessage,hWnd,WM_GETTEXTLENGTH,0,0
		cmp			eax,7
		jg			_16EditLimitLength
		mov			eax,wParam
		mov			ecx,019H
		jmp     @F
		db      '0123456789abcdefABCDEF',7FH,08H,0
		@@:
		mov     edi,offset @B - 25
		cld
		repnz		scasb
		.if			ZERO?
			.if		al>'9'
				and		al,not 20H
			.endif
			mov			wParam,eax
			jmp			_16EditDefaultDo
		.else
			_16EditLimitLength:
			invoke	MessageBeep,-1
		.endif
	.else
		_16EditDefaultDo:
		mov			eax,offset lpOldEditControlEntry
		mov			eax,DWORD PTR [eax]
		invoke	CallWindowProc,eax,hWnd,uMsg,wParam,lParam
		ret
	.endif
	xor			eax,eax
	ret
_Do16EditProc	endp

_Init16EditControl	proc _hInstance:DWORD,_lpClsName:DWORD
	LOCAL		@stWC:WNDCLASSEX
	jmp     @F
	db      'EDIT',0
	@@:
	.if			!_hInstance
		jmp			@F
	.endif
	invoke	GetClassInfoEx,0,offset @B - 5,addr @stWC
	or			eax,eax
	jz			@F
	mov			@stWC.cbSize,sizeof WNDCLASSEX
	push		_hInstance
	pop			@stWC.hInstance
	push		@stWC.lpfnWndProc
	mov			eax,offset lpOldEditControlEntry
	pop			DWORD PTR [eax]
	mov			@stWC.lpfnWndProc,offset _Do16EditProc
	push		_lpClsName
	pop			@stWC.lpszClassName
	invoke	RegisterClassEx,addr @stWC
	or			eax,eax
	jz			@F
	ret
	@@:
	xor			eax,eax
	ret
_Init16EditControl	endp

