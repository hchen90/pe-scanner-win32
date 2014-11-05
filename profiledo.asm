;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;			Code of Profile operation
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_WriteProfile	proc	uses edi esi
	LOCAL		@szFile[260]:BYTE
	LOCAL		@stRc:RECT
	LOCAL		@szBuf[64]:BYTE
	invoke	_GetProfilePath,addr @szFile
	invoke	GetWindowRect,stFile.hWinMain,addr @stRc
	mov			eax,@stRc.left
	sub			@stRc.right,eax
	mov			eax,@stRc.top
	sub			@stRc.bottom,eax
	invoke	wsprintf,addr @szBuf,offset szFmtL,@stRc.left
	invoke	WritePrivateProfileString,offset szApp_,offset szProfileX,addr @szBuf,addr @szFile
	invoke	wsprintf,addr @szBuf,offset szFmtL,@stRc.top
	invoke	WritePrivateProfileString,offset szApp_,offset szProfileY,addr @szBuf,addr @szFile
	invoke	wsprintf,addr @szBuf,offset szFmtL,@stRc.right
	invoke	WritePrivateProfileString,offset szApp_,offset szProfileW,addr @szBuf,addr @szFile
	invoke	wsprintf,addr @szBuf,offset szFmtL,@stRc.bottom
	invoke	WritePrivateProfileString,offset szApp_,offset szProfileB,addr @szBuf,addr @szFile
	ret
_WriteProfile	endp

_InitProc	proc	lParam:DWORD
	LOCAL		@szFile[260]:BYTE
	LOCAL		@stRc:RECT
	LOCAL		@szBuf[64]:BYTE
	pushad
	invoke	_GetProfilePath,addr @szFile
	invoke	GetMenu,stFile.hWinMain
	.if			eax
		invoke	DestroyMenu,stFile.hWinMain
	.endif
	invoke	LoadMenu,stFile.hInstance,100 ;; default menu
	.if			eax
	  mov     stFile.hMenu,eax
    invoke	SetMenu,stFile.hWinMain,eax
	.endif
	invoke	GetPrivateProfileInt,offset szApp_,offset szProfileX,0,addr @szFile
	or			eax,eax
	jnz			@F
	ret
	@@:
	mov			@stRc.left,eax
	invoke	GetPrivateProfileInt,offset szApp_,offset szProfileY,0,addr @szFile
	or			eax,eax
	jnz			@F
	ret
	@@:
	mov			@stRc.top,eax
	invoke	GetPrivateProfileInt,offset szApp_,offset szProfileW,0,addr @szFile
	or			eax,eax
	jnz			@F
	ret
	@@:
	mov			@stRc.right,eax
	invoke	GetPrivateProfileInt,offset szApp_,offset szProfileB,0,addr @szFile
	or			eax,eax
	jnz			@F
	ret
	@@:
	mov			@stRc.bottom,eax
	invoke	GetPrivateProfileInt,offset szApp1,offset szProfileTopmost,0,addr @szFile
	.if			eax
		invoke	CheckDlgButton,stFile.hWinMain,106,BST_CHECKED
		mov			eax,HWND_TOPMOST
	.else
		mov			eax,HWND_NOTOPMOST
	.endif
	invoke	SetWindowPos,stFile.hWinMain,eax,@stRc.left,@stRc.top,@stRc.right,@stRc.bottom,SWP_SHOWWINDOW
	popad
	ret
_InitProc	endp
