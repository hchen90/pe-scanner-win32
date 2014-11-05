;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;			Code of Disassembler operation
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_Disassembler	proc	uses esi edi ebx,lParam:DWORD,iData:DWORD
	LOCAL		@szBuf[260]:BYTE
	LOCAL		@stlvc:LV_COLUMN
	LOCAL		@stlvi:LV_ITEM
	LOCAL		@dwEP:DWORD
	LOCAL		@dwVA:POINT
	LOCAL		@dwGotBytes:DWORD
	LOCAL		@dwTotalBytes:DWORD
	LOCAL		@nMaxTimes:DWORD
	mov			@nMaxTimes,500
	push		ebp
	push		offset @@@Exit
	push		offset _HandlerProc
	push		fs:[0]
	mov			fs:[0],esp
	mov			@dwVA.x,0
	mov			@dwVA.y,0
	mov			@stlvi.imask,LVIF_TEXT
	mov			@stlvi.iItem,0
	mov			@stlvi.iSubItem,0
	mov			@stlvi.cchTextMax,260
	mov			@stlvc.imask,LVCF_FMT or LVCF_TEXT or LVCF_SUBITEM or LVCF_WIDTH
	mov			@stlvc.fmt,LVCFMT_CENTER
	mov			@stlvc.lx,150
	mov			@stlvc.pszText,offset szDisasmAsm
	mov			@stlvc.cchTextMax,64
	mov			@stlvc.iSubItem,0
	;invoke	SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stlvc
	;inc			@stlvc.iSubItem
	;mov			@stlvc.lx,120
	mov			@stlvc.pszText,offset szDisasmData
	invoke	SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stlvc
	inc			@stlvc.iSubItem
	mov			@stlvc.pszText,offset szDisasmAddr
	invoke	SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stlvc
	
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	
	sub			stFile.lpMem,0
	jnz			@F
	invoke	_OpenFile,offset stFile.szFile
	or			eax,eax
	jz			@@@Exit
	mov			stFile.lpMem,eax
	@@:
	sub			stFile.lpMem,0
	jnz			@F
	mov			DWORD PTR [eax],eax
	@@:
	
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

	mov			esi,stFile.lpMem
	.if			WORD PTR [esi] != 'ZM'
		jmp			@F
	.endif
	add			esi,[esi+3CH]
	.if			WORD PTR [esi] != 'EP'
		@@:
		.if			iData
			jmp			@F
		.else
			jmp			@@@Exit
		.endif
	.endif
	assume	esi:PTR IMAGE_NT_HEADERS
	push		[esi].OptionalHeader.SizeOfCode
	pop			@dwTotalBytes
	push		[esi].OptionalHeader.AddressOfEntryPoint
	pop			@dwEP ;; Entry Point.
	.if			stFile.dwReserve == 64
		push		[esi].OptionalHeader.BaseOfData
		pop			@dwVA.y
		push		[esi].OptionalHeader.ImageBase
		pop			@dwVA.x
	.else
		push		[esi].OptionalHeader.ImageBase
		pop			@dwVA.y
	.endif
	mov			eax,@dwEP
	add			@dwVA.y,eax
	@@:
	assume	esi:nothing
	
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

	.if			iData
		mov			edi,iData
		mov			eax,DWORD PTR [edi]
		push		DWORD PTR [edi+4]
		pop			@dwTotalBytes
		push		eax
		invoke	_Offset2Rva,stFile.lpMem,eax
		and			@dwVA.y,0FFFF0000H
		add			@dwVA.y,eax
		pop			eax
		mov			esi,stFile.lpMem
		add			esi,eax
	.else
		mov			eax,@dwEP
		invoke	_RVAToRAW,stFile.lpMem,eax ;; This function is compatible with 64bit version.
		add			eax,stFile.lpMem
		mov			esi,eax
	.endif
	
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	
	@@StartLoop:
	.if			stFile.dwReserve == 64
		push		64
	.else
		push		0
	.endif
	push		esi
	call		LDE		;;	calling disassembler engine.
	or			eax,eax
	jbe			@@@Exit
	dec			@nMaxTimes
	sub			@nMaxTimes,0
	jz			@@@Exit
	mov			@dwGotBytes,eax
	sub			@dwTotalBytes,eax
	
	.if			stFile.dwReserve == 64
		invoke	wsprintf,addr @szBuf,offset szFmt16,@dwVA.x,@dwVA.y
	.else
		invoke	wsprintf,addr @szBuf,offset szFmt8,@dwVA.y
	.endif
	mov			@stlvi.iSubItem,0
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendMessage,lParam,LVM_INSERTITEM,0,addr @stlvi
	mov			eax,@dwGotBytes
	add			@dwVA.y,eax	;;	for next loop.
	
	;;
;	push		esi
;	mov			ecx,@dwGotBytes
;	@@:
;	push		ecx
	
;	pop			ecx
;	loop		@B
;	mov			@stlvi.iSubItem,2
;	lea			eax,@szBuf
;	mov			@stlvi.pszText,eax
;	invoke	SendMessage,lParam,LVM_SETITEM,0,addr @stlvi
;	pop			esi
	;;
	
	lea			edi,@szBuf
	@@:
	xor			eax,eax
	cld
	lodsb
	invoke	wsprintf,edi,offset szFmt2,eax
	add			edi,eax ;; add buffer offset 
	dec			@dwGotBytes
	cmp			@dwGotBytes,0
	jg			@B
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	mov			@stlvi.iSubItem,1
	invoke	SendMessage,lParam,LVM_SETITEM,0,addr @stlvi
	inc			@stlvi.iItem
	
	cmp			@dwTotalBytes,0
	jle			@@@Exit
	jmp			@@StartLoop
	
	
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	
	@@@Exit:
	pop			fs:[0]
	add			esp,12
	ret
_Disassembler	endp

_DisasmProc	proc	uses esi edi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@stRc:RECT
	.if			uMsg == WM_INITDIALOG
		cmp			stFile.lpMem,0
		jz			@F
		mov     esi,stFile.lpMem
		cmp     (IMAGE_DOS_HEADER ptr [esi]).e_magic,IMAGE_DOS_SIGNATURE
		jnz     @F
		add     esi,(IMAGE_DOS_HEADER ptr [esi]).e_lfanew
		cmp     (IMAGE_NT_HEADERS ptr [esi]).Signature,IMAGE_NT_SIGNATURE
		jnz     @F
		invoke	SendMessage,hWnd,WM_SETTEXT,0,offset szTitleDisassmbler
		mov     eax, LVS_EX_FULLROWSELECT or LVS_EX_HEADERDRAGDROP or\
          	LVS_EX_SUBITEMIMAGES or LVS_EX_GRIDLINES
		invoke	SendDlgItemMessage, hWnd, 1, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, eax
		invoke	GetDlgItem,hWnd,1
		mov     edi,eax
		invoke  ShowWindow,edi,SW_SHOW
		invoke	_Disassembler,edi,lParam
	.elseif uMsg == WM_SIZE
		invoke	GetClientRect,hWnd,addr @stRc
		invoke	GetDlgItem,hWnd,1
		invoke	MoveWindow,eax,@stRc.left,@stRc.top,@stRc.right,@stRc.bottom,1
	.elseif	uMsg == WM_CLOSE
		@@:
		invoke	EndDialog,hWnd,0
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_DisasmProc	endp
