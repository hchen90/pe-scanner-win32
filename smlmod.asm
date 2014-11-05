;; smlmod.asm

_SmlModDlg	proc	uses esi edi ebx hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@stOf:OPENFILENAME
	.if			uMsg == WM_INITDIALOG
		push		hWnd
		pop			stFile.hWinMain
		.if     !stFile.hIcon
		  invoke  LoadIcon,stFile.hInstance,100
		  mov     stFile.hIcon,eax
		.endif
		invoke	SendMessage,hWnd,WM_SETICON,ICON_BIG,stFile.hIcon
		invoke	SendDlgItemMessage,hWnd,103,WM_SETTEXT,0,offset stFile.szFile
		invoke	CreatePopupMenu
		.if			eax
			mov			hMenuPlg,eax
			invoke	_LoadPlugins,hMenuPlg
		.endif
		lea			esi,stFile.szFile
		cld
		lodsb
		and			eax,0FFH
		.if			eax
			invoke	_OpenFile,offset stFile.szFile
			mov			stFile.lpMem,eax
		.endif
	.elseif uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0FFFFH
		.if			eax == 100	;;	open file
			xor			eax,eax
			lea			edi,@stOf
			mov			ecx,sizeof @stOf
			cld
			rep			stosb
			mov			@stOf.lStructSize,sizeof OPENFILENAME
			push		hWnd
			pop			@stOf.hwndOwner
			push		stFile.hInstance
			pop			@stOf.hInstance
			mov			@stOf.lpstrFilter,offset szFilter
			mov			@stOf.lpstrFile,offset stFile.szFile
			mov			@stOf.nMaxFile,sizeof stFile.szFile
			mov			@stOf.Flags,OFN_EXPLORER
			invoke	GetOpenFileName,addr @stOf
			.if			eax
				invoke	SendDlgItemMessage,hWnd,103,WM_SETTEXT,0,offset stFile.szFile
				invoke	_OpenFile,offset stFile.szFile
				mov			stFile.lpMem,eax
			.endif
		.elseif eax == 101	;;	plugins
			invoke	GetDlgItem,hWnd,101
			.if			eax
				invoke	_TrackPopupMenu,eax
			.endif
		.elseif eax == 102	;;	about
			invoke	ShellAbout,stFile.hWinMain,offset szApp,offset szOtherStuff,stFile.hIcon
		.endif
		.if			stFile.lpMem
			invoke	_DefCommandDo,hWnd,wParam,lParam
		.endif
	.elseif	uMsg == WM_CLOSE
		.if			stFile.lpMem
			invoke	_OpenFile,0
		.endif
		.if			hEvent
			invoke	CloseHandle,hEvent
		.endif
		invoke	EndDialog,hWnd,0
	.else
		xor			eax,eax
		ret
	.endif
	or			eax,1
	ret
_SmlModDlg	endp

_SmallMode	proc	_lpCmdLn:DWORD
	pushad
	invoke	lstrlen,_lpCmdLn
	mov			ecx,eax
	mov			eax,'-'
	mov			edi,_lpCmdLn	;;	".....\\pES.exe" -m test.exe
	cld
	repnz		scasb
	jnz			@F
	mov			al,BYTE PTR [edi]
	inc			edi
	sub			al,'m'
	jnz			@F
	.if     BYTE PTR [edi] != 020H && BYTE PTR [edi] != 000H
	  jmp     @F
	.endif
	mov			esi,edi
	@@@_LOP00:
	xor			eax,eax
	cld
	lodsb
	or			eax,eax
	jz			@@@_LOP01
	cmp			al,20H
	jz			@@@_LOP00
	@@@_LOP01:
	dec			esi
	lea			edi,stFile.szFile
	@@@_LOP02:
	cld
	lodsb
	or			eax,eax
	jz			@@@_LOP03
	cmp			al,20H
	jz			@@@_LOP03
	cld
	stosb
	jmp			@@@_LOP02
	@@@_LOP03:
	invoke	DialogBoxParam,stFile.hInstance,111,0,offset _SmlModDlg,0
	@@@STDOWN:
	invoke	ExitProcess,0
	@@:
	popad
	ret
_SmallMode	endp
