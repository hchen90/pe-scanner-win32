;;scan obj

_ScanObj	proc	_lpMem:DWORD,_hParent:DWORD,_dwTreeID:DWORD,_dwListViewID:DWORD
	LOCAL		@sttvi:TV_INSERTSTRUCT
	LOCAL		@stlvi:LV_ITEM
	LOCAL		@szBuf[260]:BYTE
	LOCAL		@nSec:DWORD
	LOCAL		@hChild1:DWORD
	LOCAL		@hChild2:DWORD
	pushad
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_DELETEITEM,0,TVI_ROOT
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_DELETEALLITEMS,0,0
	mov			@sttvi.hParent,TVI_ROOT
	mov			@sttvi.hInsertAfter,TVI_LAST
	mov			@sttvi.item.imask,TVIF_TEXT
	mov			@sttvi.item.hItem,0
	mov			@sttvi.item.cchTextMax,260
	mov			@sttvi.item.pszText,offset szImgNtHeaders
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_INSERTITEM,0,addr @sttvi
	mov			@hChild1,eax
	mov			@sttvi.item.pszText,offset szImgSecHeader
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_INSERTITEM,0,addr @sttvi
	mov			@hChild2,eax
	;;
	assume	fs:nothing
	push		ebp
	push		offset 	_ObjQuit
	push		offset	_HandlerProc
	push		fs:[0]
	mov			fs:[0],esp
	;;
	mov			esi,_lpMem
	assume	esi:PTR IMAGE_FILE_HEADER
	
	lea			edi,@szBuf
	invoke	lstrcpy,edi,offset szFHMachine
	add			edi,sizeof szFHMachine - 1
	movzx		eax,[esi].Machine
	invoke	wsprintf,edi,offset szFmt4,eax
	lea			eax,@szBuf
	mov			@sttvi.item.pszText,eax
	push		@hChild1
	pop			@sttvi.hParent
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_INSERTITEM,0,addr @sttvi
	
	lea			edi,@szBuf
	invoke	lstrcpy,edi,offset szFHNumberOfSections
	add			edi,sizeof szFHNumberOfSections - 1
	movzx		eax,[esi].NumberOfSections
	mov			@nSec,eax
	invoke	wsprintf,edi,offset szFmt4,eax
	lea			eax,@szBuf
	mov			@sttvi.item.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_INSERTITEM,0,addr @sttvi
	
	lea			edi,@szBuf
	invoke	lstrcpy,edi,offset szFHTimeDateStamp
	add			edi,sizeof szFHTimeDateStamp - 1 
	mov			eax,[esi].TimeDateStamp
	invoke	wsprintf,edi,offset szFmt8,eax
	lea			eax,@szBuf
	mov			@sttvi.item.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_INSERTITEM,0,addr @sttvi
	
	lea			edi,@szBuf
	invoke	lstrcpy,edi,offset szFHPointerToSymbolTable
	add			edi,sizeof szFHPointerToSymbolTable - 1
	mov			eax,[esi].PointerToSymbolTable
	invoke	wsprintf,edi,offset szFmt8,eax
	lea			eax,@szBuf
	mov			@sttvi.item.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_INSERTITEM,0,addr @sttvi
	
	lea			edi,@szBuf
	invoke	lstrcpy,edi,offset szFHNumberOfSymbols
	add			edi,sizeof szFHNumberOfSymbols - 1
	mov			eax,[esi].NumberOfSymbols
	invoke	wsprintf,edi,offset szFmt8,eax
	lea			eax,@szBuf
	mov			@sttvi.item.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_INSERTITEM,0,addr @sttvi
	
	lea			edi,@szBuf
	invoke	lstrcpy,edi,offset szFHSizeOfOptionalHeader
	add			edi,sizeof szFHSizeOfOptionalHeader - 1
	movzx		eax,[esi].SizeOfOptionalHeader
	invoke	wsprintf,edi,offset szFmt8,eax
	lea			eax,@szBuf
	mov			@sttvi.item.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_INSERTITEM,0,addr @sttvi
	
	lea			edi,@szBuf
	invoke	lstrcpy,edi,offset szFHCharacteristics
	add			edi,sizeof szFHCharacteristics - 1
	movzx		eax,[esi].Characteristics
	invoke	wsprintf,edi,offset szFmt8,eax
	lea			eax,@szBuf
	mov			@sttvi.item.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_INSERTITEM,0,addr @sttvi
	
	add			esi,sizeof IMAGE_FILE_HEADER
	mov			@stlvi.imask,LVIF_TEXT
	mov			@stlvi.iItem,0
	mov			@stlvi.iSubItem,0
	mov			@stlvi.cchTextMax,260
	push		@hChild2
	pop			@sttvi.hParent
	@@:
	assume	esi:PTR IMAGE_SECTION_HEADER
	xor			eax,eax
	mov			ecx,260
	lea			edi,@szBuf
	cld
	rep			stosb
	invoke	lstrcpyn,addr @szBuf,addr [esi].Name1,9
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_INSERTITEM,0,addr @stlvi
	lea			eax,@szBuf
	mov			@sttvi.item.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwTreeID,TVM_INSERTITEM,0,addr @sttvi
	inc			@stlvi.iSubItem
	invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].Misc.VirtualSize
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_SETITEM,0,addr @stlvi
	inc			@stlvi.iSubItem
	invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].VirtualAddress
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_SETITEM,0,addr @stlvi
	inc			@stlvi.iSubItem
	invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].SizeOfRawData
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_SETITEM,0,addr @stlvi
	inc			@stlvi.iSubItem
	invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].PointerToRawData
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_SETITEM,0,addr @stlvi
	inc			@stlvi.iSubItem
	invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].PointerToRelocations
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_SETITEM,0,addr @stlvi
	inc			@stlvi.iSubItem
	invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].PointerToLinenumbers
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_SETITEM,0,addr @stlvi
	inc			@stlvi.iSubItem
	movzx		eax,[esi].NumberOfRelocations
	invoke	wsprintf,addr @szBuf,offset szFmt8,eax
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_SETITEM,0,addr @stlvi
	inc			@stlvi.iSubItem
	movzx		eax,[esi].NumberOfLinenumbers
	invoke	wsprintf,addr @szBuf,offset szFmt8,eax
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_SETITEM,0,addr @stlvi
	inc			@stlvi.iSubItem
	invoke	wsprintf,addr @szBuf,offset szFmt8,[esi].Characteristics
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendDlgItemMessage,_hParent,_dwListViewID,LVM_SETITEM,0,addr @stlvi
	dec			@nSec
	sub			@nSec,0
	jz			_ObjQuit
	mov			@stlvi.iSubItem,0
	inc			@stlvi.iItem
	add			esi,sizeof IMAGE_SECTION_HEADER
	jmp			@B
	
	_ObjQuit:
	assume	esi:nothing
	pop			fs:[0]
	add			esp,0CH
	popad
	ret
_ScanObj	endp
