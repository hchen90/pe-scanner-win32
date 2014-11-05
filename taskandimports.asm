
.386
.model	flat,stdcall
option	casemap:none

;###############################################################################

include code.inc

;###############################################################################

.data
szFileI											db	260 dup(?)
_HandlerProc								proto	C	:DWORD,:DWORD,:DWORD,:DWORD
_RVAToRAW										proto	:DWORD,:DWORD
_AddText										proto	:DWORD,:DWORD
_OpenFile										proto	:DWORD
_Ascii2Dword16							proto	:DWORD
szFmt16											db	'%08X %08X',0
szFmt8											db	'%08X',0
szFmt4											db	'%04X',0
szFmt												db	'%s',0
lpMemI											dd	?
dwTmp												dd	?
szImportCharacteristics			db	'Characteristics/OriginalFirstThunk',0
szImportTimeDateStamp				db	'TimeDateStamp',0
szImportForwarderChain			db	'ForwarderChain',0
szImportName1								db	'Name',0
szImportDllName							db	'NameOfDLL',0
szImportFirstThunk					db	'FirstThunk',0
szImportThunkRva						db	'ThunkRVA',0
szImportThunkOffset					db	'ThunkOffset',0
szImportThunkData						db	'ThunkData',0
szImportThunkHint						db	'Hint',0
szImportThunkName1					db	'FunctionName',0
dwIsTaskView								db	0
szModuleth32ModuleID				db	'th32ModuleID',0
szModulemodBaseAddr					db	'modBaseAddr',0
szModulemodBaseSize					db	'modBaseSize',0
szModulehModule							db	'hModule',0
szModuleszModule						db	'szModule',0
szModuleszExePath						db	'szExePath',0
szAccessDeny								db	'[Access Deny]',0
;;snapshot
szTitleImports							db	'[ Import Function(s) ]',0
szTitleTaskViewer						db	'[ Task Viewer ]',0
szProcessth32ProcessID			db	'th32ProcessID',0
szProcessth32DefaultHeapID	db	'th32DefaultHeapID',0
szProcessth32ModuleID				db	'th32ModuleID',0
szProcesscntThreads					db	'cntThreads',0
szProcesspcPriClassBase			db	'pcPriClassBase',0
szProcessszExeFile					db	'szExeFile',0
szApp1											db	'Misc',0
szProfileLEI                db  'log_exports_imports_enable',0

dwLEI                       dd  ?


.code

_ScanTask		proc	lParam:DWORD
	LOCAL		@hSnap:DWORD
	LOCAL		@stPE:PROCESSENTRY32
	LOCAL		@stlvc:LV_COLUMN
	LOCAL		@stlvi:LV_ITEM
	LOCAL		@szBuf[64]:BYTE
	invoke	SendMessage,lParam,WM_SETTEXT,0,offset szTitleTaskViewer
	;;add scan task code here
	mov			dwIsTaskView,1
	mov			@stlvc.imask,LVCF_FMT or LVCF_TEXT or LVCF_WIDTH
	mov			@stlvc.fmt,LVCFMT_CENTER
	mov			@stlvc.lx,94
	mov			@stlvc.pszText,offset szProcessth32ProcessID
	mov			@stlvc.cchTextMax,sizeof szProcessth32ProcessID
	mov			@stlvc.iSubItem,0
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szProcessth32DefaultHeapID
	mov			@stlvc.cchTextMax,sizeof szProcessth32DefaultHeapID
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szProcessth32ModuleID
	mov			@stlvc.cchTextMax,sizeof szProcessth32ModuleID
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szProcesscntThreads
	mov			@stlvc.cchTextMax,sizeof szProcesscntThreads
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szProcesspcPriClassBase
	mov			@stlvc.cchTextMax,sizeof szProcesspcPriClassBase
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szProcessszExeFile
	mov			@stlvc.cchTextMax,sizeof szProcessszExeFile
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.imask,LVCF_FMT or LVCF_TEXT or LVCF_WIDTH or LVCF_SUBITEM
	mov			@stlvc.fmt,LVCFMT_CENTER
	mov			@stlvc.lx,180
	mov			@stlvc.pszText,offset szModuleszExePath
	mov			@stlvc.cchTextMax,sizeof szModuleszExePath
	mov			@stlvc.iSubItem,0
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szModuleszModule
	mov			@stlvc.cchTextMax,sizeof szModuleszModule
	mov			@stlvc.lx,80
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szModulehModule
	mov			@stlvc.cchTextMax,sizeof szModulehModule
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szModulemodBaseSize
	mov			@stlvc.cchTextMax,sizeof szModulemodBaseSize
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szModulemodBaseAddr
	mov			@stlvc.cchTextMax,sizeof szModulemodBaseAddr
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szModuleth32ModuleID
	mov			@stlvc.cchTextMax,sizeof szModuleth32ModuleID
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	;;do real work
	mov			@stPE.dwSize,sizeof PROCESSENTRY32
	invoke	CreateToolhelp32Snapshot,02H,0
	.if			eax
		mov			@hSnap,eax
		invoke	Process32First,@hSnap,addr @stPE
		.while	eax
			mov			@stlvi.imask,LVIF_TEXT
			mov			@stlvi.iItem,0
			mov			@stlvi.iSubItem,0
			lea			eax,@stPE.szExeFile
			mov			@stlvi.pszText,eax
			mov			@stlvi.cchTextMax,sizeof @stPE.szExeFile
			invoke	SendDlgItemMessage,lParam,1,LVM_INSERTITEM,0,addr @stlvi
			mov			eax,@stPE.pcPriClassBase
			invoke	wsprintf,addr @szBuf,offset szFmt8,eax
			lea			eax,@szBuf
			mov			@stlvi.pszText,eax
			mov			@stlvi.cchTextMax,sizeof @szBuf
			inc			@stlvi.iSubItem
			invoke	SendDlgItemMessage,lParam,1,LVM_SETITEM,0,addr @stlvi
			mov			eax,@stPE.cntThreads
			invoke	wsprintf,addr @szBuf,offset szFmt8,eax
			lea			eax,@szBuf
			mov			@stlvi.pszText,eax
			mov			@stlvi.cchTextMax,sizeof @szBuf
			inc			@stlvi.iSubItem
			invoke	SendDlgItemMessage,lParam,1,LVM_SETITEM,0,addr @stlvi
			mov			eax,@stPE.th32ModuleID
			invoke	wsprintf,addr @szBuf,offset szFmt8,eax
			lea			eax,@szBuf
			mov			@stlvi.pszText,eax
			mov			@stlvi.cchTextMax,sizeof @szBuf
			inc			@stlvi.iSubItem
			invoke	SendDlgItemMessage,lParam,1,LVM_SETITEM,0,addr @stlvi
			mov			eax,@stPE.th32DefaultHeapID
			invoke	wsprintf,addr @szBuf,offset szFmt8,eax
			lea			eax,@szBuf
			mov			@stlvi.pszText,eax
			mov			@stlvi.cchTextMax,sizeof @szBuf
			inc			@stlvi.iSubItem
			invoke	SendDlgItemMessage,lParam,1,LVM_SETITEM,0,addr @stlvi
			mov			eax,@stPE.th32ProcessID
			invoke	wsprintf,addr @szBuf,offset szFmt8,eax
			lea			eax,@szBuf
			mov			@stlvi.pszText,eax
			mov			@stlvi.cchTextMax,sizeof @szBuf
			inc			@stlvi.iSubItem
			invoke	SendDlgItemMessage,lParam,1,LVM_SETITEM,0,addr @stlvi
			mov			@stlvi.iSubItem,0
			invoke	Process32Next,@hSnap,addr @stPE
		.endw
		invoke	CloseHandle,@hSnap
	.endif
	ret
_ScanTask		endp

_ScanImports	proc	uses esi,lParam:DWORD
	LOCAL		@stlvc:LV_COLUMN
	LOCAL		@stlvi:LV_ITEM
	LOCAL		@szBuf[260]:BYTE
	
	assume	fs:nothing
	push		ebp
	push		offset __Exit
	push		offset _HandlerProc
	push		fs:[0]
	mov			fs:[0],esp
	mov			dwIsTaskView,0
	invoke	SendMessage,lParam,WM_SETTEXT,0,offset szTitleImports
	;;
	mov			@stlvi.imask,LVIF_TEXT
	mov			@stlvi.iItem,0
	mov			@stlvi.iSubItem,0
	mov			@stlvc.imask,LVCF_FMT or LVCF_TEXT or LVCF_WIDTH or LVCF_SUBITEM
	mov			@stlvc.fmt,LVCFMT_CENTER
	mov			@stlvc.lx,84
	mov			@stlvc.iSubItem,0
	mov			@stlvc.pszText,offset szImportFirstThunk
	mov			@stlvc.cchTextMax,sizeof szImportFirstThunk
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szImportDllName
	mov			@stlvc.cchTextMax,sizeof szImportDllName
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szImportName1
	mov			@stlvc.cchTextMax,sizeof szImportName1
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szImportForwarderChain
	mov			@stlvc.cchTextMax,sizeof szImportForwarderChain
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szImportTimeDateStamp
	mov			@stlvc.cchTextMax,sizeof szImportTimeDateStamp
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szImportCharacteristics
	mov			@stlvc.cchTextMax,sizeof szImportCharacteristics
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,1,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.imask,LVCF_FMT or LVCF_TEXT or LVCF_SUBITEM or LVCF_WIDTH
	mov			@stlvc.fmt,LVCFMT_CENTER
	mov			@stlvc.lx,140
	mov			@stlvc.iSubItem,0
	mov			@stlvc.pszText,offset szImportThunkName1
	mov			@stlvc.cchTextMax,sizeof szImportThunkName1
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szImportThunkHint
	mov			@stlvc.cchTextMax,sizeof szImportThunkHint
	inc			@stlvc.iSubItem
	mov			@stlvc.lx,60
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szImportThunkData
	mov			@stlvc.cchTextMax,sizeof szImportThunkData
	inc			@stlvc.iSubItem
	mov			@stlvc.lx,140
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szImportThunkOffset
	mov			@stlvc.cchTextMax,sizeof szImportThunkOffset
	inc			@stlvc.iSubItem
	mov			@stlvc.lx,84
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	mov			@stlvc.pszText,offset szImportThunkRva
	mov			@stlvc.cchTextMax,sizeof szImportThunkRva
	inc			@stlvc.iSubItem
	invoke	SendDlgItemMessage,lParam,2,LVM_INSERTCOLUMN,0,addr @stlvc
	;;real work
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp			lpMemI,0
	jne			@F
	invoke	_OpenFile,offset szFileI
	or			eax,eax
	jz			__Exit
	mov			lpMemI,eax
	@@:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov			esi,lpMemI
	add			esi,[esi+3CH]
	.if			WORD PTR [esi] != 'EP'
		jmp			__Exit
	.endif
	movzx		eax,[esi+IMAGE_NT_HEADERS.OptionalHeader.Magic]
	.if			eax == 010BH
		add			esi,24+92+4
	.elseif eax == 020BH
		add			esi,24+108+4
	.endif
	add			esi,8H
	mov			eax,DWORD PTR [esi] ;; virtual address
	mov			ecx,esi
	add			ecx,4
	mov			ecx,DWORD PTR [ecx] ;; isize
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	invoke	_RVAToRAW,lpMemI,eax
	mov			esi,lpMemI
	add			esi,eax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	assume	esi:PTR IMAGE_IMPORT_DESCRIPTOR
	.while	[esi].Characteristics || [esi].TimeDateStamp || [esi].ForwarderChain || [esi].Name1 || [esi].FirstThunk
		push		esi
		;;;;;;;;;;;;;;;;;;;;;
		push		'-'
		mov			ecx,esp
		.if     dwLEI
		  invoke	_AddText,ecx,00H
		.endif
		add			esp,4
		invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].Characteristics
		lea			eax,@szBuf
		mov			@stlvi.pszText,eax
		mov			@stlvi.cchTextMax,sizeof @szBuf
		invoke	SendDlgItemMessage,lParam,1,LVM_INSERTITEM,0,addr @stlvi
		invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].TimeDateStamp
		lea			eax,@szBuf
		mov			@stlvi.pszText,eax
		inc			@stlvi.iSubItem
		invoke	SendDlgItemMessage,lParam,1,LVM_SETITEM,0,addr @stlvi
		invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].ForwarderChain
		lea			eax,@szBuf
		mov			@stlvi.pszText,eax
		inc			@stlvi.iSubItem
		invoke	SendDlgItemMessage,lParam,1,LVM_SETITEM,0,addr @stlvi
		invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].Name1
		lea			eax,@szBuf
		mov			@stlvi.pszText,eax
		inc			@stlvi.iSubItem
		invoke	SendDlgItemMessage,lParam,1,LVM_SETITEM,0,addr @stlvi
		invoke	_RVAToRAW,lpMemI,[esi].Name1
		add			eax,lpMemI
		.if     dwLEI
		  invoke	_AddText,eax,00H
		.endif
		invoke	wsprintf,addr @szBuf,offset szFmt,eax
		lea			eax,@szBuf
		mov			@stlvi.pszText,eax
		inc			@stlvi.iSubItem
		invoke	SendDlgItemMessage,lParam,1,LVM_SETITEM,0,addr @stlvi
		invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].FirstThunk
		lea			eax,@szBuf
		mov			@stlvi.pszText,eax
		inc			@stlvi.iSubItem
		invoke	SendDlgItemMessage,lParam,1,LVM_SETITEM,0,addr @stlvi
		mov			@stlvi.iSubItem,0
		;;;;;;;;;;;;;;;;;;;;;
		pop			esi
		add			esi,sizeof IMAGE_IMPORT_DESCRIPTOR
		assume	esi:PTR IMAGE_IMPORT_DESCRIPTOR
	.endw
	assume	esi:nothing
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	__Exit:
	pop			fs:[0]
	add			esp,12
	ret
_ScanImports	endp	

;###################################################################################################

_ScanModule	proc	lParam:DWORD
	LOCAL		@hSnap:DWORD
	LOCAL		@dwID:DWORD
	LOCAL		@szBuf[260]:BYTE
	LOCAL		@stlvc:LV_COLUMN
	LOCAL		@stlvi:LV_ITEM
	LOCAL		@stPE:PROCESSENTRY32
	LOCAL		@stME:MODULEENTRY32
	mov			@dwID,0
	invoke	lstrcpy,addr @szBuf,lParam
	;;initial work
	invoke	SendMessage,dwTmp,LVM_DELETEALLITEMS,0,0
	;;do real work
	invoke	CreateToolhelp32Snapshot,02H,0
	.if			!eax
		ret
	.endif
	mov			@hSnap,eax
	mov			@stPE.dwSize,sizeof PROCESSENTRY32
	invoke	Process32First,@hSnap,addr @stPE
	.while	eax
		invoke	lstrcmp,addr @stPE.szExeFile,addr @szBuf
		.if			!eax
			push		@stPE.th32ProcessID
			pop			@dwID
			.break
		.endif
		invoke	Process32Next,@hSnap,addr @stPE
	.endw
	invoke	CloseHandle,@hSnap
	.if			!@dwID
		ret
	.endif
	invoke	CreateToolhelp32Snapshot,08H,@dwID
	.if			!eax
		ret
	.endif
	mov			@hSnap,eax
	mov			@stME.dwSize,sizeof MODULEENTRY32
	invoke	Module32First,@hSnap,addr @stME
	.if			!eax
		mov			@stlvi.imask,LVIF_TEXT
		mov			@stlvi.iItem,0
		mov			@stlvi.iSubItem,0
		mov			@stlvi.pszText,offset szAccessDeny
		mov			@stlvi.cchTextMax,sizeof @stPE.szExeFile
		invoke	SendMessage,dwTmp,LVM_INSERTITEM,0,addr @stlvi
		jmp			@F
	.endif
	.while	eax
		mov			@stlvi.imask,LVIF_TEXT
		mov			@stlvi.iItem,0
		mov			@stlvi.iSubItem,0
		mov			eax,@stME.th32ModuleID
		invoke	wsprintf,addr @szBuf,offset szFmt8,eax
		lea			eax,@szBuf
		mov			@stlvi.pszText,eax
		mov			@stlvi.cchTextMax,sizeof @stPE.szExeFile
		invoke	SendMessage,dwTmp,LVM_INSERTITEM,0,addr @stlvi
		mov			eax,@stME.modBaseAddr
		invoke	wsprintf,addr @szBuf,offset szFmt8,eax
		lea			eax,@szBuf
		mov			@stlvi.pszText,eax
		mov			@stlvi.cchTextMax,sizeof @szBuf
		inc			@stlvi.iSubItem
		invoke	SendMessage,dwTmp,LVM_SETITEM,0,addr @stlvi
		mov			eax,@stME.modBaseSize
		invoke	wsprintf,addr @szBuf,offset szFmt8,eax
		lea			eax,@szBuf
		mov			@stlvi.pszText,eax
		mov			@stlvi.cchTextMax,sizeof @szBuf
		inc			@stlvi.iSubItem
		invoke	SendMessage,dwTmp,LVM_SETITEM,0,addr @stlvi
		mov			eax,@stME.hModule
		invoke	wsprintf,addr @szBuf,offset szFmt8,eax
		lea			eax,@szBuf
		mov			@stlvi.pszText,eax
		mov			@stlvi.cchTextMax,sizeof @szBuf
		inc			@stlvi.iSubItem
		invoke	SendMessage,dwTmp,LVM_SETITEM,0,addr @stlvi
		lea			eax,@stME.szModule
		mov			@stlvi.pszText,eax
		mov			@stlvi.cchTextMax,sizeof @szBuf
		inc			@stlvi.iSubItem
		invoke	SendMessage,dwTmp,LVM_SETITEM,0,addr @stlvi
		lea			eax,@stME.szExePath
		mov			@stlvi.pszText,eax
		mov			@stlvi.cchTextMax,sizeof @szBuf
		inc			@stlvi.iSubItem
		invoke	SendMessage,dwTmp,LVM_SETITEM,0,addr @stlvi
		mov			@stlvi.iSubItem,0
		invoke	Module32Next,@hSnap,addr @stME
	.endw
	@@:
	invoke	CloseHandle,@hSnap
	ret
_ScanModule	endp

_ScanFunctions	proc	uses esi edi,lParam:DWORD
	LOCAL		@szBuf[260]:BYTE
	LOCAL		@stlvi:LV_ITEM
	LOCAL		@dwESI:DWORD
	LOCAL		@dwThunkIndex:DWORD
	LOCAL		@dw64:DWORD
	mov			@dw64,0
	invoke	SendMessage,dwTmp,LVM_DELETEALLITEMS,0,0
	
	cmp			lpMemI,0
	jne			@F
	invoke	_OpenFile,offset szFileI
	or			eax,eax
	jz			___Exit
	mov			lpMemI,eax
	@@:
	assume	fs:nothing
	push		ebp
	push		offset ___Exit
	push		offset _HandlerProc
	push		fs:[0]
	mov			fs:[0],esp
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov			esi,lpMemI
	add			esi,[esi+3CH]
	.if			WORD PTR [esi] != 'EP'
		jmp			___Exit
	.endif
	movzx		eax,[esi+IMAGE_NT_HEADERS.OptionalHeader.Magic]
	.if			eax == 010BH
		add			esi,24+92+4
		mov			@dw64,0
	.elseif eax == 020BH
		add			esi,24+108+4
		mov			@dw64,1
	.endif
	add			esi,8H
	mov			eax,DWORD PTR [esi]	;;	virtual address
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	invoke	_RVAToRAW,lpMemI,eax
	mov			esi,lpMemI
	add			esi,eax
	assume	esi:PTR IMAGE_IMPORT_DESCRIPTOR
	.while	[esi].Characteristics || [esi].TimeDateStamp || [esi].ForwarderChain || [esi].Name1 || [esi].FirstThunk
  	push		esi
  	invoke	_Ascii2Dword16,lParam
  	.if			eax == [esi].FirstThunk
  		.if			[esi].OriginalFirstThunk
  			mov			eax,[esi].OriginalFirstThunk
  		.else
  			mov			eax,[esi].FirstThunk
  		.endif
  		mov			@dwESI,eax
  		invoke	_RVAToRAW,lpMemI,eax
  		add			eax,lpMemI
  		mov			@dwThunkIndex,eax

  		mov			@stlvi.imask,LVIF_TEXT
			mov			@stlvi.iSubItem,0
			mov			@stlvi.iItem,0
  		@@:
  		
  		mov			eax,@dwThunkIndex
  		.if			@dw64
  			mov			ecx,DWORD PTR [eax]
  			add			eax,4
  			mov			eax,DWORD PTR [eax]
  		.else
  			mov			eax,DWORD PTR [eax] ;; thunk data
  		.endif
  		
  		.if			@dw64
  			.break  .if !eax && !ecx
  		.else
  			.break	.if	!eax 
  		.endif
  		
  		pushad
  		invoke	wsprintf,addr @szBuf,offset szFmt8,@dwESI
  		lea			eax,@szBuf
			mov			@stlvi.pszText,eax
			mov			@stlvi.cchTextMax,sizeof @szBuf
			mov			@stlvi.iSubItem,0
			invoke	SendMessage,dwTmp,LVM_INSERTITEM,0,addr @stlvi
			invoke	_RVAToRAW,lpMemI,@dwESI
			invoke	wsprintf,addr @szBuf,offset szFmt8,eax
			lea			eax,@szBuf
			mov			@stlvi.pszText,eax
			mov			@stlvi.cchTextMax,sizeof @szBuf
			inc			@stlvi.iSubItem
			invoke	SendMessage,dwTmp,LVM_SETITEM,0,addr @stlvi
			add			@dwESI,4
  		popad
  		
  		pushad
  		.if			@dw64
  			invoke	wsprintf,addr @szBuf,offset szFmt16,eax,ecx
  		.else
  			invoke	wsprintf,addr @szBuf,offset szFmt8,eax
  		.endif
  		lea			eax,@szBuf
  		mov			@stlvi.pszText,eax
  		mov			@stlvi.cchTextMax,sizeof @szBuf
  		inc			@stlvi.iSubItem
  		invoke	SendMessage,dwTmp,LVM_SETITEM,0,addr @stlvi
  		push		'-'
  		mov			eax,esp
  		.if     dwLEI
  		  invoke	_AddText,eax,00H
  		.endif
  		add			esp,4
  		popad
  		
  		.if			eax & 80000000H
  			and			eax,7FFFFFFFH
  			.if			@dw64
  				invoke	wsprintf,addr @szBuf,offset szFmt16,eax,ecx
  			.else
  				invoke	wsprintf,addr @szBuf,offset szFmt8,eax
  			.endif
  			lea			eax,@szBuf
  			.if     dwLEI
  			  invoke	_AddText,eax,00H
  			.endif
  			mov			@stlvi.pszText,eax
  			mov			@stlvi.cchTextMax,sizeof @szBuf
  			add			@stlvi.iSubItem,2
  			invoke	SendMessage,dwTmp,LVM_SETITEM,0,addr @stlvi
  		.else
  			.if			@dw64
  				mov			eax,ecx
  			.endif
  			invoke	_RVAToRAW,lpMemI,eax
  			add			eax,lpMemI
  			mov			ecx,DWORD PTR [eax]
  			and			ecx,0FFFFH
  			push		eax
  			invoke	wsprintf,addr @szBuf,offset szFmt4,ecx
  			lea			eax,@szBuf
  			.if     dwLEI
  			  invoke	_AddText,eax,00H
  			.endif
  			mov			@stlvi.pszText,eax
  			mov			@stlvi.cchTextMax,sizeof @szBuf
  			inc			@stlvi.iSubItem
  			invoke	SendMessage,dwTmp,LVM_SETITEM,0,addr @stlvi
  			pop			eax
  			add			eax,2
  			invoke	wsprintf,addr @szBuf,offset szFmt,eax
  			lea			eax,@szBuf
  			.if     dwLEI
  			  invoke	_AddText,eax,00H
  			.endif
  			mov			@stlvi.pszText,eax
  			mov			@stlvi.cchTextMax,sizeof @szBuf
  			inc			@stlvi.iSubItem
  			invoke	SendMessage,dwTmp,LVM_SETITEM,0,addr @stlvi
  		.endif
  		inc			@stlvi.iItem
  		
  		.if			@dw64
  			add			@dwThunkIndex,8
  		.else
  			add			@dwThunkIndex,4
  		.endif
  		jmp			@B
  		@@:
  		
  	.endif
  	pop			esi
		add			esi,sizeof IMAGE_IMPORT_DESCRIPTOR
		assume	esi:PTR IMAGE_IMPORT_DESCRIPTOR
	.endw
	assume	esi:nothing
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	___Exit:
	pop			fs:[0]
	add			esp,12
	ret
_ScanFunctions	endp

;###################################################################################################

_ImportDlg	proc	hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@szBuf[260]:BYTE
		LOCAL		@stlvi:LV_ITEM
		LOCAL		@stRc:RECT
	.if			uMsg == WM_INITDIALOG
	  invoke  _GetProfilePath,addr @szBuf
	  invoke  GetPrivateProfileInt,offset szApp1,offset szProfileLEI,0,addr @szBuf
	  mov     dwLEI,eax
		invoke	SendDlgItemMessage, hWnd, 1, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT
		invoke	SendDlgItemMessage, hWnd, 2, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT
		cmp			lParam,0
		je			@F
		push		ecx
		invoke	CreateThread,0,0,offset _ScanTask,hWnd,0,esp
		pop			ecx
		invoke	CloseHandle,eax
		ret
		@@:
		push		ecx
		invoke	CreateThread,0,0,offset _ScanImports,hWnd,0,esp
		pop			ecx
		invoke	CloseHandle,eax
	.elseif	uMsg == WM_SIZE
		invoke	GetClientRect,hWnd,addr @stRc
		shr			@stRc.bottom,1
		invoke	GetDlgItem,hWnd,1
		invoke	MoveWindow,eax,@stRc.left,@stRc.top,@stRc.right,@stRc.bottom,1
		add			@stRc.bottom,2
		invoke	GetDlgItem,hWnd,2
		invoke	MoveWindow,eax,@stRc.left,@stRc.bottom,@stRc.right,@stRc.bottom,1
	.elseif uMsg == WM_NOTIFY
		mov			eax,lParam
		add			eax,4
		mov			ecx,DWORD PTR [eax]
		.if			ecx == 1
			add			eax,4
			mov			ecx,DWORD PTR [eax]
			.if			ecx == NM_CLICK
				.if			dwIsTaskView
					;;scan module part
					mov			eax,lParam
  				add			eax,sizeof NMHDR
  				mov			eax,DWORD PTR [eax]
  				mov			@stlvi.iItem,eax
  				mov			@stlvi.imask,LVIF_TEXT
  				lea			eax,@szBuf
  				mov			@stlvi.pszText,eax
  				mov			@stlvi.cchTextMax,sizeof @szBuf
  				mov			@stlvi.iSubItem,0
  				invoke	SendDlgItemMessage,hWnd,1,LVM_GETITEM,0,addr @stlvi
  				or			eax,eax
  				jz			@F
  				invoke	GetDlgItem,hWnd,2
  				mov			dwTmp,eax
  				lea			eax,@szBuf
  				invoke	_ScanModule,eax
  				@@:
				.else
					mov			eax,lParam
  				add			eax,sizeof NMHDR
  				mov			eax,DWORD PTR [eax]
  				mov			@stlvi.iItem,eax
  				mov			@stlvi.imask,LVIF_TEXT
  				lea			eax,@szBuf
  				mov			@stlvi.pszText,eax
  				mov			@stlvi.cchTextMax,sizeof @szBuf
  				mov			@stlvi.iSubItem,5
  				invoke	SendDlgItemMessage,hWnd,1,LVM_GETITEM,0,addr @stlvi
  				or			eax,eax
  				jz			@F
  				invoke	GetDlgItem,hWnd,2
  				mov			dwTmp,eax
  				lea			eax,@szBuf
  				invoke	_ScanFunctions,eax
  				@@:
				.endif
			.endif
		.endif
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
_ImportDlg	endp

GetTaskorImportInfo	proc	_lpMem:DWORD,_hInstance:DWORD,_dwDlgID:DWORD,_hWinMain:DWORD,_lpFile:DWORD,_dwReason:DWORD
	.if			! _lpMem && ! _lpFile
		xor			eax,eax
		ret
	.endif
	invoke	lstrcpy,offset szFileI,_lpFile
	.if			! _lpMem
		invoke	_OpenFile,offset szFileI
		.if			!eax
			invoke	MessageBeep,MB_ICONSTOP
			xor			eax,eax
			ret
		.endif
		mov			lpMemI,eax
	.else
		push		_lpMem
		pop			lpMemI
	.endif
	.if			_dwReason
		invoke	DialogBoxParam,_hInstance,_dwDlgID,_hWinMain,offset _ImportDlg,1
	.else
		invoke	DialogBoxParam,_hInstance,_dwDlgID,_hWinMain,offset _ImportDlg,0
	.endif
	.if			! _lpMem
		invoke	VirtualFree,lpMemI,0,MEM_RELEASE
	.endif
	mov				eax,1
	ret
GetTaskorImportInfo	endp


End
