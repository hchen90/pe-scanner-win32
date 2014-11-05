
.data
szstrCursor						db	'[Cursor]',0
szstrBitmap						db	'[Bitmap]',0
szstrIcon							db	'[Icon]',0
szstrMenu							db	'[Menu]',0
szstrDialog						db	'[Dialog]',0
szstrString						db	'[String]',0
szstrFontDir					db	'[FontDir]',0
szstrFont							db	'[Font]',0
szstrAccelerator			db	'[Accelerator]',0
szstrRcData						db	'[Unformatted Resource]',0
szstrMsgTable					db	'[Message Table]',0
szstrGroupCursor			db	'[Group Cursor]',0
szstrGroupIcon				db	'[Group Icon]',0
szstrVersion					db	'[Version]',0
szstrAniCursor				db	'[Animated Cursor]',0
szstrUnknown					db	'[???]',0
szOffset2Data					db	'[!] Offset2Data : %08X',20H
											db	' ;Size	:%08X',0

szFileExt							db	'\%08X.dat',0
szBmpExt							db	'\%08X.bmp',0
szIconExt							db	'\%08X.ico',0
szAniCurExt						db	'\%08X.ani',0
szCurExt							db	'\%08X.cur',0
szBinExt							db	'\%08X.bin',0

szNoResource					db	'Resource NOT found in this file!',0
szBrowseTitle					db	'Select a location for saving dumpped file(s):',0
szResData							db	'Resource Data',0
szPleaseWait					db	'Please wait ...',0
szDumpDlgTitle				db	'[Resource Dumper]',0

_DlgProc							proto	:DWORD,:DWORD,:DWORD,:DWORD
_SeekData							proto	:DWORD,:DWORD
_StoreData						proto	:DWORD,:DWORD
_RealDo								proto	:DWORD
Rva2Offset 						equ		_RVAToRAW

hDlg									dd	?
hPreItem							dd	?

dwIsOver							dd	?
dwReadyWrite					dd	?
dwResType							dd	?

szSavePath						db	260	dup(?)

;##############################

.code
_ResourceDump	proc lParam:DWORD
	.if			stFile.lpMem
  	invoke	DialogBoxParam,stFile.hInstance,800,stFile.hWinMain,offset _DlgProc,0
	.endif
	ret
_ResourceDump	endp

_DlgProc	proc	uses esi edi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@szBuf[260]:BYTE
		LOCAL		@stBi:BROWSEINFO
	.if			uMsg == WM_INITDIALOG
		push		hWnd
		pop			hDlg
		mov			dwReadyWrite,0
		invoke  _RealDo,0
		invoke	SendMessage,hWnd,WM_SETICON,ICON_BIG,stFile.hIcon
		invoke	SendDlgItemMessage,hDlg,1,TVM_SETIMAGELIST,TVSIL_NORMAL,stFile.hImageList ;; hImageList --> global variable
	.elseif uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0FFFFH
		.if			eax == 1000 ;; dump resource.
			invoke	CoInitialize,0
			.if			eax == S_OK
				xor			eax,eax
				mov			ecx,sizeof BROWSEINFO
				lea			edi,@stBi
				cld
				rep			stosb
				push		hWnd
				pop			@stBi.hwndOwner
				lea			eax,@szBuf
				mov			@stBi.pszDisplayName,eax
				mov			@stBi.lpszTitle,offset szBrowseTitle
				mov			@stBi.ulFlags,BIF_RETURNONLYFSDIRS or BIF_STATUSTEXT	or BIF_USENEWUI
				invoke	SHBrowseForFolder,addr @stBi
				.if			eax
					invoke	SHGetPathFromIDList,eax,offset szSavePath
					.if			eax
						mov			dwReadyWrite,1
						invoke	SendMessage,hWnd,WM_SETTEXT,0,offset szPleaseWait
						invoke	_RealDo,0
						invoke	SendMessage,hWnd,WM_SETTEXT,0,offset szDumpDlgTitle
					.endif
				.endif
				invoke	CoUninitialize
			.endif
		.elseif	eax == 1001
			jmp			___@@@QuitDumpResource
		.endif
	.elseif	uMsg == WM_CLOSE
		___@@@QuitDumpResource:
		invoke	EndDialog,hWnd,0
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_DlgProc	endp

_AddItem	proc	uses esi edi hIndex:DWORD,lpStr:DWORD,dwImg:DWORD ;; dwImg --> NOT use anymore
	LOCAL		@stTvi:TV_INSERTSTRUCT
	.if			lpStr
		xor			eax,eax
		mov			ecx,sizeof TV_INSERTSTRUCT
		lea			edi,@stTvi
		cld
		rep			stosb
		.if			hIndex
			push		hIndex
		.else
			push		TVI_ROOT
		.endif
		pop			@stTvi.hParent
		mov			@stTvi.hInsertAfter,TVI_LAST
		mov			@stTvi.item.imask,TVIF_IMAGE or TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
		mov			@stTvi.item.iImage,0
		mov			@stTvi.item.iSelectedImage,1
		mov			@stTvi.item.cchTextMax,260
		push		lpStr
		pop			@stTvi.item.pszText
		invoke	SendDlgItemMessage,hDlg,1,TVM_INSERTITEM,0,addr @stTvi
	.endif
	ret
_AddItem	endp

_RealDo	proc	uses esi edi,lParam:DWORD
		LOCAL		@szBuf[260]:BYTE
	
		invoke	SendDlgItemMessage,hDlg,1,TVM_DELETEITEM,0,TVI_ROOT
	
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PART	1
		mov			esi,stFile.lpMem
		.if			WORD PTR [esi] != 'ZM'
			invoke	_AddItem,0,offset szNoDos,1
			ret
		.endif
		add			esi,[esi+3CH]
		.if			WORD PTR [esi] != 'EP'
			invoke	_AddItem,0,offset szNoPE,1
			ret
		.endif
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PART	2
		movzx		eax,[esi+IMAGE_NT_HEADERS.OptionalHeader.Magic]
  	.if			eax == 010BH
  		add			esi,24+92+4
  	.elseif eax == 020BH
  		add			esi,24+108+4
  	.endif
		;;IMAGE_DATA_DIRECTORY
		add			esi,10H
		mov			ecx,esi
		add			ecx,04H
		pushad
		.if			DWORD PTR [esi]	== 00H
			popad
			invoke	_AddItem,0,offset szNoResource,1
			invoke	GetDlgItem,hDlg,1000
			.if			eax
				invoke	ShowWindow,eax,SW_HIDE
			.endif
			ret
		.endif
		popad
		
		invoke	Rva2Offset,stFile.lpMem,DWORD PTR [esi]
		mov			esi,eax
		add			esi,stFile.lpMem
			
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PART	3
		
		mov			edi,eax
		
		invoke	_AddItem,0,offset szResData,1
		push		eax
		pop			hChild1
		mov			hPreItem,eax
		
		;;call ()... to add data items.
		invoke	_SeekData,esi,esi
		
		ret
_RealDo	endp

_SeekData	proc	uses esi edi ebx,lpFirstRes:DWORD,lpLastPos:DWORD
	LOCAL		@dwCount:DWORD
	LOCAL		@szBuf[260]:BYTE
	mov			esi,lpLastPos
	assume	esi:PTR IMAGE_RESOURCE_DIRECTORY
	xor			eax,eax
	movzx		eax,[esi].NumberOfNamedEntries
	xor			ecx,ecx
	movzx		ecx,[esi].NumberOfIdEntries
	mov			@dwCount,eax
	add			@dwCount,ecx
	;;
	add			esi,sizeof IMAGE_RESOURCE_DIRECTORY
	.while	@dwCount
  	assume	esi:PTR IMAGE_RESOURCE_DIRECTORY_ENTRY
  	mov			eax,[esi].Name1
  	.if			eax & 80000000H
  		and			eax,7FFFFFFFH
  		add			eax,lpFirstRes
  		movzx		ecx,WORD PTR [eax]
  		add			eax,2
  		mov			ebx,eax
  		invoke	WideCharToMultiByte,CP_ACP,WC_COMPOSITECHECK,ebx,\
  						ecx,addr @szBuf,sizeof @szBuf,0,0
  		lea			ecx,@szBuf
  	.else
  		.if			!dwIsOver
  			.if			eax == 1
    			mov			ecx,offset szstrCursor
    			mov			dwResType,100000B
    		.elseif	eax == 2
    			mov			ecx,offset szstrBitmap
    			mov			dwResType,10B
    		.elseif eax == 3
    			mov			ecx,offset szstrIcon
    			mov			dwResType,100B
    		.elseif eax == 4
    			mov			ecx,offset szstrMenu
    			mov			dwResType,0
    		.elseif eax == 5
    			mov			ecx,offset szstrDialog
    			mov			dwResType,0
    		.elseif eax == 6
    			mov			ecx,offset szstrString
    			mov			dwResType,0
    		.elseif eax == 7
    			mov			ecx,offset szstrFontDir
    			mov			dwResType,0
    		.elseif eax == 8
    			mov			ecx,offset szstrFont
    			mov			dwResType,0
    		.elseif eax == 9
    			mov			ecx,offset szstrAccelerator
    			mov			dwResType,0
    		.elseif eax == 10
    			mov			ecx,offset szstrRcData
    			mov			dwResType,10000B
    		.elseif eax == 11
    			mov			ecx,offset szstrMsgTable
    			mov			dwResType,0
    		.elseif eax == 12
    			mov			ecx,offset szstrGroupCursor
    			mov			dwResType,0
    		.elseif eax == 14
    			mov			ecx,offset szstrGroupIcon
    			mov			dwResType,0
    		.elseif eax == 16
    			mov			ecx,offset szstrVersion
    			mov			dwResType,0
    		.elseif eax == 15H
    			mov			ecx,offset szstrAniCursor
    			mov			dwResType,1000B
    		.else
    			mov			ecx,offset szstrUnknown
    			mov			dwResType,0
    		.endif
    		push		hChild1
    		pop			hPreItem
    		invoke	_AddItem,hPreItem,ecx,1
    		push		hPreItem
    		pop			hChild1
    		mov			hPreItem,eax
  		.endif
  	.endif
  	mov			eax,[esi].OffsetToData
  	.if			eax & 80000000H
  		and			eax,7FFFFFFFH
  		add			eax,lpFirstRes
  		inc			dwIsOver
  		invoke	_SeekData,lpFirstRes,eax
  		dec			dwIsOver
  	.else
  		add			eax,lpFirstRes
  		assume	eax:PTR IMAGE_RESOURCE_DATA_ENTRY
  		mov			ebx,[eax].OffsetToData
  		mov			ecx,[eax].Size1
  		assume	eax:nothing
  		invoke	Rva2Offset,stFile.lpMem,ebx
  		pushad
  		invoke	wsprintf,addr @szBuf,offset szOffset2Data,eax,ecx
  		invoke	_AddItem,hPreItem,addr @szBuf,1
  		popad
  		;;get data here!
  		.if			dwReadyWrite
  			invoke	_StoreData,eax,ecx
  		.endif
  	.endif
  	assume	esi:nothing
		add			esi,sizeof IMAGE_RESOURCE_DIRECTORY_ENTRY
		dec			@dwCount
	.endw
	ret
_SeekData	endp


_StoreData	proc	uses esi edi ebx,lpOffset:DWORD,dwSize:DWORD
		LOCAL		@szBuf[260]:BYTE
		LOCAL		@szBuf_[260]:BYTE
		LOCAL		@stBmpHeader:BITMAPFILEHEADER
		LOCAL		@hFile:DWORD
		
		mov			esi,lpOffset
		add			esi,stFile.lpMem
		push		esi
		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		invoke	lstrcpy,addr @szBuf,offset szSavePath
		invoke	Sleep,50
		call		GetTickCount
		mov			ecx,dwResType
		.if			ecx == 10B
			invoke	wsprintf,addr @szBuf_,offset szBmpExt,eax
		.elseif	ecx == 100B
			invoke	wsprintf,addr @szBuf_,offset szIconExt,eax
		.elseif ecx == 1000B
			invoke	wsprintf,addr @szBuf_,offset szAniCurExt,eax
		.elseif ecx == 10000B
			invoke	wsprintf,addr @szBuf_,offset szBinExt,eax
		.elseif ecx == 100000B
			invoke	wsprintf,addr @szBuf_,offset szCurExt,eax
		.else
			invoke	wsprintf,addr @szBuf_,offset szFileExt,eax
		.endif
		invoke	lstrcat,addr @szBuf,addr @szBuf_
		;; @szBuf has stored radomize file name.
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;create file and prepar to write data.
		invoke	CreateFile,addr @szBuf,GENERIC_WRITE,FILE_SHARE_READ,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
		.if			eax == -1
			pop			esi
			ret
		.endif
		mov			@hFile,eax
		
		mov			ecx,dwResType
		.if			ecx == 10B
			lea			edi,@stBmpHeader
			mov			al,'M'
			shl			eax,8
			mov			al,'B'
			cld
			stosw
			mov			eax,dwSize
			add			eax,sizeof BITMAPFILEHEADER	;;	for bmp
			cld
			stosd
			xor			eax,eax
			cld
			stosd
			mov			al,36H
			and			eax,0FFH
			stosd
			push		ecx
			invoke	WriteFile,@hFile,addr @stBmpHeader,sizeof BITMAPFILEHEADER,esp,0
			pop			ecx
		.elseif	ecx == 100B || ecx == 100000B
			.if			ecx == 100B
				mov			ebx,1
			.else
				mov			ebx,2
			.endif
			xor			eax,eax
			mov			ecx,22
			lea			edi,@szBuf
			cld
			rep			stosb
			lea			edi,@szBuf
			xor			eax,eax
			cld
			stosw
			mov			eax,ebx
			cld
			stosw
			mov			eax,1
			cld
			stosw
			add			esi,4
			cld
			lodsd		;;	width
			cld
			stosb
			cld
			lodsd		;;	height
			cld
			stosb
			
			add			edi,2
			
  		cld
  		lodsw		;;	planes
  		.if			ebx == 02
  			xor			eax,eax
  		.endif
			cld
			stosw
			cld
			lodsw		;;	bitcount
			.if			ebx == 02
				xor			eax,eax
			.endif
			cld
			stosw
			
			inc			esi
			
			mov			eax,dwSize		;;	image size
			.if			ebx == 02
				sub			eax,4
			.endif
			cld
			stosd
			mov			eax,16H
			cld
			stosd
			
			push		ebx
			invoke	WriteFile,@hFile,addr @szBuf,22,esp,0
			pop			ebx
		.endif
		
		pop			esi
		.if			ebx == 02
			add			esi,4
		.endif
		invoke	WriteFile,@hFile,esi,dwSize,esp,0
		
		invoke	CloseHandle,@hFile
		ret
_StoreData	endp
