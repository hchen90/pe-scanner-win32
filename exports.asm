.386
.model	flat,stdcall
option	casemap:none

;###############################################################################
Include 	code.inc
;###############################################################################

.data
szExportFunOrdinals					db	'FunctionOrdinal',0
szExportFunNamesRva					db	'FunctionEntryRVA',0
szExportFunNamesOffset			db	'FunctionOffset',0
szExportFunNames						db	'FunctionName',0
szFmt4											db	'%04X',0
szFmt8											db	'%08X',0
szFmt												db	'%s',0
lpMemE											dd	?
szFileE											db	260	dup(?)
dwLEI                       dd  ?

.code
_ScanExports	proc	uses esi edi,lParam:DWORD
	LOCAL		@szBuf[260]:BYTE
	LOCAL		@stlvc:LV_COLUMN
	LOCAL		@stlvi:LV_ITEM
	LOCAL		@nIndex:DWORD
	LOCAL		@lpNameOd:DWORD
	LOCAL		@dwNameRVA:DWORD
	assume	fs:nothing
	push		ebp
	push		offset _@@Exit
	push		offset _HandlerProc
	push		fs:[0]
	mov			fs:[0],esp
	
	.if     dwLEI
	  push		'-'
	  mov			eax,esp
	  invoke	_AddText,eax,00H
	  add			esp,4
	.endif
	
	;**********************************************************
	mov			@stlvc.imask,LVCF_FMT or LVCF_SUBITEM or LVCF_TEXT or LVCF_WIDTH
	mov			@stlvc.fmt,LVCFMT_CENTER
	mov			@stlvc.lx,180
	mov			@stlvc.iSubItem,0
	mov			@stlvc.cchTextMax,64
	mov			@stlvi.imask,LVIF_TEXT
	mov			@stlvi.iItem,0
	mov			@stlvi.iSubItem,0
	mov			@stlvi.cchTextMax,260
	mov			@stlvc.pszText,offset szExportFunNames
	invoke	SendDlgItemMessage,lParam,1050,LVM_INSERTCOLUMN,0,addr @stlvc
	inc			@stlvc.iSubItem
	mov			@stlvc.lx,120
	mov			@stlvc.pszText,offset szExportFunNamesOffset
	invoke	SendDlgItemMessage,lParam,1050,LVM_INSERTCOLUMN,0,addr @stlvc
	inc			@stlvc.iSubItem
	mov			@stlvc.pszText,offset szExportFunNamesRva
	invoke	SendDlgItemMessage,lParam,1050,LVM_INSERTCOLUMN,0,addr @stlvc
	inc			@stlvc.iSubItem
	mov			@stlvc.pszText,offset szExportFunOrdinals
	invoke	SendDlgItemMessage,lParam,1050,LVM_INSERTCOLUMN,0,addr @stlvc
	;**********************************************************
	cmp			lpMemE,0
	jne			@F
	invoke	_OpenFile,offset szFileE
	or			eax,eax
	jz			_@@Exit
	mov			lpMemE,eax
	@@:

	;**********************************************************
	mov			esi,lpMemE
	xor			eax,eax
	mov			ax,WORD PTR [esi]
	cmp			eax,'ZM'
	jne			_@@Exit
	add			esi,[esi+3CH]
	xor			eax,eax
	mov			ax,WORD PTR [esi]
	cmp			eax,'EP'
	jne			_@@Exit
	;;
	movzx		eax,[esi+IMAGE_NT_HEADERS.OptionalHeader.Magic]
	.if			eax == 010BH
		add			esi,24+92+4
	.elseif eax == 020BH
		add			esi,24+108+4
	.endif
	mov			eax,DWORD PTR [esi]
	invoke	_RVAToRAW,lpMemE,eax
	add			eax,lpMemE
	mov			edi,eax
	;;
	assume	edi:PTR IMAGE_EXPORT_DIRECTORY
	invoke	wsprintf,addr @szBuf,offset szFmt8,[edi].Characteristics
	invoke	SendDlgItemMessage,lParam,1051,WM_SETTEXT,0,addr @szBuf
	invoke	wsprintf,addr @szBuf,offset szFmt8,[edi].TimeDateStamp
	invoke	SendDlgItemMessage,lParam,1052,WM_SETTEXT,0,addr @szBuf
	lea			ecx,@szBuf
	xor			eax,eax
	mov			ax,[edi].MajorVersion
	push		ecx
	invoke	wsprintf,ecx,offset szFmt4,eax
	pop			ecx
	add			ecx,eax
	mov			BYTE PTR [ecx],'.'
	inc			ecx
	xor			eax,eax
	mov			ax,[edi].MinorVersion
	invoke	wsprintf,ecx,offset szFmt4,eax
	invoke	SendDlgItemMessage,lParam,1053,WM_SETTEXT,0,addr @szBuf
	invoke	wsprintf,addr @szBuf,offset szFmt8,[edi].nName
	invoke	SendDlgItemMessage,lParam,1054,WM_SETTEXT,0,addr @szBuf
	invoke	wsprintf,addr @szBuf,offset szFmt8,[edi].nBase
	invoke	SendDlgItemMessage,lParam,1055,WM_SETTEXT,0,addr @szBuf
	invoke	wsprintf,addr @szBuf,offset szFmt8,[edi].NumberOfFunctions
	invoke	SendDlgItemMessage,lParam,1056,WM_SETTEXT,0,addr @szBuf
	invoke	wsprintf,addr @szBuf,offset szFmt8,[edi].NumberOfNames
	invoke	SendDlgItemMessage,lParam,1057,WM_SETTEXT,0,addr @szBuf
	invoke	wsprintf,addr @szBuf,offset szFmt8,[edi].AddressOfFunctions
	invoke	SendDlgItemMessage,lParam,1058,WM_SETTEXT,0,addr @szBuf
	invoke	wsprintf,addr @szBuf,offset szFmt8,[edi].AddressOfNames
	invoke	SendDlgItemMessage,lParam,1059,WM_SETTEXT,0,addr @szBuf
	invoke	wsprintf,addr @szBuf,offset szFmt8,[edi].AddressOfNameOrdinals
	invoke	SendDlgItemMessage,lParam,1060,WM_SETTEXT,0,addr @szBuf
	invoke	_RVAToRAW,lpMemE,[edi].nName
	add			eax,lpMemE
	.if     dwLEI
	  invoke	_AddText,eax,00H
	.endif
	invoke	wsprintf,addr @szBuf,offset szFmt,eax
	invoke	SendDlgItemMessage,lParam,1061,WM_SETTEXT,0,addr @szBuf
	;;
	invoke	_RVAToRAW,lpMemE,[edi].AddressOfNameOrdinals
	add			eax,lpMemE
	mov			@lpNameOd,eax
	invoke	_RVAToRAW,lpMemE,[edi].AddressOfNames
	add			eax,lpMemE
	mov			@dwNameRVA,eax
	mov			@nIndex,0
	
	invoke	_RVAToRAW,lpMemE,[edi].AddressOfFunctions
	add			eax,lpMemE
	mov			esi,eax
	
	.if     dwLEI
  	push		'-'
  	mov			ecx,esp
  	invoke	_AddText,ecx,00H
  	add			esp,4
	.endif
	
	mov			ecx,[edi].NumberOfFunctions
	@@:
	.if			!DWORD PTR [esi]
		dec			ecx
		or			ecx,ecx
		jz			@F
		inc			@nIndex
		add			esi,4
		jmp			@B
	.endif
	push		ecx
	mov			eax,@nIndex
	add			eax,[edi].nBase
	invoke	wsprintf,addr @szBuf,offset szFmt8,eax
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	mov			@stlvi.iSubItem,0
	invoke	SendDlgItemMessage,lParam,1050,LVM_INSERTITEM,0,addr @stlvi	
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi]
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	inc			@stlvi.iSubItem
	invoke	SendDlgItemMessage,lParam,1050,LVM_SETITEM,0,addr @stlvi
	invoke	_RVAToRAW,lpMemE,DWORD PTR [esi]
	invoke	wsprintf,addr @szBuf,offset szFmt8,eax
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	inc			@stlvi.iSubItem
	invoke	SendDlgItemMessage,lParam,1050,LVM_SETITEM,0,addr @stlvi
	
	pushad
	mov			ecx,[edi].NumberOfNames
	mov			edi,@lpNameOd
	mov			eax,@nIndex
	cld
	repnz		scasw
	.if			ZERO?
		mov			eax,@dwNameRVA
		invoke	_RVAToRAW,lpMemE,DWORD PTR [eax]
		add			eax,lpMemE
		.if     dwLEI
		  invoke	_AddText,eax,00H
		.endif
		mov			@stlvi.pszText,eax
		inc			@stlvi.iSubItem
		invoke	SendDlgItemMessage,lParam,1050,LVM_SETITEM,0,addr @stlvi
		add			@lpNameOd,2
		add			@dwNameRVA,4
	.endif
	popad

	add			esi,4
	inc			@stlvi.iItem
	inc			@nIndex
	pop			ecx
	dec			ecx
	or			ecx,ecx
	jnz			@B
	@@:

	assume	edi:nothing
	;**********************************************************
	
	_@@Exit:
	pop			fs:[0]
	add			esp,12
	ret
_ScanExports	endp

szStr00001  db  'Misc',0
szStr00002  db  'log_exports_imports_enable',0

_ExportDlg	proc	hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@stRc:RECT
		LOCAL   @szBuf[MAX_PATH]:DWORD
	.if			uMsg == WM_INITDIALOG
	  invoke  _GetProfilePath,addr @szBuf
	  invoke  GetPrivateProfileInt,offset szStr00001,offset szStr00002,0,addr @szBuf
	  mov     dwLEI,eax
		invoke	SendDlgItemMessage, hWnd, 1050, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT
		push		ecx
		invoke	CreateThread,0,0,offset _ScanExports,hWnd,0,esp
		pop			ecx
		invoke	CloseHandle,eax
	.elseif	uMsg == WM_SIZE
		invoke	GetClientRect,hWnd,addr @stRc
		shr			@stRc.bottom,1
		invoke	GetDlgItem,hWnd,1050
		invoke	MoveWindow,eax,@stRc.left,@stRc.bottom,@stRc.right,@stRc.bottom,1
	.elseif	uMsg == WM_CLOSE
		invoke	EndDialog,hWnd,0
	.elseif uMsg == WM_LBUTTONDOWN
		invoke	SendMessage,hWnd,WM_NCLBUTTONDOWN,HTCAPTION,0
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_ExportDlg	endp

GetExportInfo	proc	_lpMem:DWORD,_hInstance:DWORD,_dwDlgID:DWORD,_hWinMain:DWORD,_lpFile:DWORD
	.if			! _lpMem && ! _lpFile
		xor			eax,eax
		ret
	.endif
	invoke	lstrcpy,offset szFileE,_lpFile
	.if			!	_lpMem
		invoke	_OpenFile,offset szFileE
		.if			!eax
			invoke	MessageBox,0,esp,0,MB_ICONSTOP
			xor			eax,eax
			ret
		.endif
		mov			lpMemE,eax
	.else
		push		_lpMem
		pop			lpMemE
	.endif
	invoke	DialogBoxParam,_hInstance,_dwDlgID,_hWinMain,offset _ExportDlg,0
	.if			! _lpMem
		invoke	VirtualFree,lpMemE,0,MEM_RELEASE
	.endif
	mov			eax,1
	ret
GetExportInfo	endp

End
