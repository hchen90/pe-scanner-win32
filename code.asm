.486
.model	flat,stdcall
option	casemap:none

;#######################################

Include			code.inc

;#######################################

.data
include			crt_tm.inc

APPOBJ	STRUCT
	szFile									db	260 dup(?) 	;; File name
	lpMem										dd	?						;; Image memory
	cbMem										dd	?						;; Image memory size
	hInstance								dd	?						;; Handler of Instance
	hWinMain								dd	?						;; Handler of Window
	hIcon										dd	?						;; Handler of Icon
	hFont										dd	?						;; Handler of Font
	dwReserve								dd	4		dup(?) 	;; 64 bit or 32 bit or reserved
	hHeap										dd	?
	hImageList              dd  ?
	dwReserve1              dd  4   dup(?)
	hMenu                   dd  ?           ;; handler of menu
	hTooltip                dd  ?           ;; tooltip
APPOBJ	ENDS

PLUGIN	STRUCT
	dwID					DWORD				?
	dwIndirect		DWORD				?
	lpfnProc			DWORD				?
	lpNext				DWORD				?
	dwReserve			DWORD				?
PLUGIN	ENDS

HE_DATA_INFO	STRUCT
	lpBuffer			DWORD				?
	dwSize				DWORD				?
	dwIsReadOnly	DWORD				?
HE_DATA_INFO	ENDS

HE_POS	STRUCT
	dwOffset 			DWORD				?
	bHiword				DWORD				?
	bTxtSection		DWORD				?
HE_POS	ENDS

HE_WIN_POS	STRUCT
	iState				DWORD				?
	dwPos					RECT				<>
HE_WIN_POS	ENDS

HE_SETTINGS	STRUCT
	dwMask					DWORD				?
	pHandler				DWORD				?
	posCaret				HE_POS			<>
	dwSelStart			DWORD				?
	dwSelEnd				DWORD				?
	hParent					DWORD				?
	UNION	
		lpFile				DWORD					?
		diMem					HE_DATA_INFO	<>
	ENDS
	wpUser					HE_WIN_POS	<>
HE_SETTINGS	ENDS

;#######################################

hAccelerator						dd	?
hTree										dd	?
hStatus									dd	?
hEditRpt								dd	?
hChild1									dd	?
hChild2									dd	?
hChild3									dd	?
hChild4									dd	?
hList										dd	?
hListBox								dd	?
hButton1								dd	?
hButton2								dd	?
hButton3								dd	?
hButton4								dd	?
hButton5								dd	?
hEdit										dd	?
hEdit1									dd	?
hEdit2									dd	?
hMenuPlg								dd	?
hMenuTrack              dd  ?
hImgList								dd	?
hEvent									dd	?

lpCommand								dd	?
lpPEDetectEntry					dd	?
lpOldListView						dd	?

stFile									APPOBJ	<>

szFaceName							db	'MS Shell Dlg',0
szClsButton							db	'BUTTON',0
szClsEdit								db	'EDIT',0
szRichDll								db	'RichEd20.DLL',0
szClsRichEdit						db	'RichEdit20A',0
szClsStatic							db	'STATIC',0
szClsListBox						db	'LISTBOX',0
szClsTree								db	'SysTreeView32',0
szClsListV							db	'SysListView32',0
szClsTooltip            db  'tooltips_class32',0
szApp										db	'About ..#'
szClsName								db	'Microsoft Portable Executable File Scanner',0
szOtherStuff						db	'Copyright(C)2014 Hsiang Chen',0
szOpen									db	'&Open',0
szOpenTooltip           db  'Click this button to open a file.',0
szHideWindow						db	'&PE Scanner',0
szPlugins								db	'>',0
sz16Edit								db	'16Edit.DLL',0
szExport								db	'&Export(fn)',0
szImport								db	'&Import(fn)',0
szSecName								db	'Name',0
szSecVirSize						db	'Vir. Size',0
szSecVirAddr						db	'Vir. Address',0
szSecRawSize						db	'Raw Size',0
szSecRawOffset					db	'Raw Offset',0
szSecRelocations				db	'p.Relocations',0
szSecLinenumbers				db	'p.Linenumbers',0
szSecNReloc							db	'n.Relocations',0
szSecNLinenum						db	'n.Linenumbers',0
szCharacteristics				db	'Characteristics',0
szImgDosHeader					db	'MS-DOS 2.0 Compatible Header',0
szImgFileHeader					db	'COFF File Header',0
szImgOptionalHeader			db	'Optional Header',0
szImgDataDirectory			db	'Data Directory',0
szImgData								db	'Misc.',0
szScanDone							db	'Scan Done !',0
szFilter								db	'ExE/DLL File(*.exe;*.dll)',0,'*.exe;*dll',0,'Object/Exports Library Files(*.obj;*.exp)',0,'*.obj;*exp',0,'All Files(*.*)',0,'*.*',0,0
szObjName								db  'PE Scanner File Object [modify enabled].',0
szEventName							db	'PE Scanner Event.',0
szFailOpen							db	'Fail open file !',0
szFailMap								db	'Fail map file !',0
szFailVAlloc						db	'Fail allocate virtual memory.',0
szNoDos									db	'Not a valid DOS Header !',0
szNoPE									db	'Not a valid PE Header !',0
szFmt2									db	'%02X ',0
szFmt4									db	'%04X ',0
szFmt8									db	'%08X',0
szFmt16									db	'%08X %08X ',0
szFmt										db	'%s',0
szFmtL									db	'%lu',0
szFmtMisc								db	'Virtual Address :%08X ; Offset :%08X ; isize :%08X',0
szFmtTime1							db	'CR:%lu/%lu/%lu %02lu:%02lu:%02lu',0
szFmtTime2							db	'LA:%lu/%lu/%lu %02lu:%02lu:%02lu',0
szFmtTime3							db	'LW:%lu/%lu/%lu %02lu:%02lu:%02lu',0
szFmtTime								db	'%lu/%lu/%lu %02lu:%02lu:%02lu',0
szBytes									db	'bytes',0
szObjDect								db	'Objective file detected.',0
szEditTooltip1          db  'This edit show you PEiD-like information.',0
szEditTooltip2          db  'This edit show you Log information.',0
szListBoxTooltip        db  'Double click an item to open a Data Directory (Need 16Edit.DLL and file is NOT readonly).',0
szPluginBtTooltip       db  'Click this button to view plugins.',0

;;DOS Header

sze_magic								db	'e_magic :',0
sze_cblp								db	'e_cblp :',0
sze_cp									db	'e_cp :',0
sze_crlc								db	'e_crlc :',0
sze_cparhdr							db	'e_cparhdr :',0
sze_minalloc						db	'e_minalloc :',0
sze_maxalloc						db	'e_maxalloc :',0
sze_ss									db	'e_ss :',0
sze_sp									db	'e_sp :',0
sze_csum								db	'e_csum :',0
sze_ip									db	'e_ip :',0
sze_cs									db	'e_cs :',0
sze_lfarlc							db	'e_lfarlc :',0
sze_ovno								db	'e_ovno :',0
sze_res									db	'e_res :',0
sze_oemid								db	'e_oemid :',0
sze_oeminfo							db	'e_oeminfo :',0
sze_res2								db	'e_res2 :',0
sze_lfanew							db	'e_lfanew :',0

;;NT Headers

szSignature									db	'Signature :',0

szFHMachine									db	'Machine : ',0
szFHNumberOfSections				db	'Nnmber Of Sections : ',0
szFHTimeDateStamp						db	'Time Date Stamp : ',0
szFHPointerToSymbolTable		db	'Pointer To Symbol Table : ',0
szFHNumberOfSymbols					db	'Number Of Symbols : ',0
szFHSizeOfOptionalHeader		db	'Size Of Optional Header : ',0
szFHCharacteristics					db	'Characteristics : ',0
szImgNtHeaders							db	'Microsoft NT Headers',0
szImgSecHeader							db	'Section Headers',0


szOHMagic										db	'Magic :',0
szOHMajorLinkerVersion			db	'Major Linker Version :',0
szOHMinorLinkerVersion			db	'Minor Linker Version :',0
szOHSizeOfCode							db	'Size Of Code :',0
szOHSizeOfInitializedData		db	'Size Of Initialized Data :',0
szOHSizeOfUninitializedData	db	'Size Of Uninitialized Data :',0
szOHAddressOfEntryPoint			db	'Address Of Entry Point :',0
szOHBaseOfCode							db	'Base Of Code :',0
szOHBaseOfData							db	'Base Of Data :',0
szOHImageBase								db	'Image Base :',0
szOHSectionAlignment				db	'Section	Alignment :',0
szOHFileAlignment						db	'File Alignment :',0
szOHMajorOperatingSystemVersion	db	'Major Operating System Version :',0
szOHMinorOperatingSystemVersion	db	'Minor Operating System Version :',0
szOHMajorImageVersion				db	'Major Image Version :',0
szOHMinorImageVersion				db	'Minor Image Version :',0
szOHMajorSubsystemVersion		db	'Major Subsystem Version :',0
szOHMinorSubsystemVersion		db	'Minor Subsystem Version :',0
szOHWin32VersionValue				db	'Win32 Version Value :',0
szOHSizeOfImage							db	'Size Of Image :',0
szOHSizeOfHeaders						db	'Size Of Headers :',0
szOHCheckSum								db	'CheckSum :',0
szOHSubsystem								db	'Subsystem :',0
szOHDllCharacteristics			db	'Dll Characteristics :',0
szOHSizeOfStackReserve			db	'Size Of Stack Reserve :',0
szOHSizeOfStackCommit				db	'Size Of Stack Commit :',0
szOHSizeOfHeapReserve				db	'Size Of Heap	Reserve :',0
szOHSizeOfHeapCommit				db	'Size Of Heap Commit :',0
szOHLoaderFlags							db	'Loader Flags :',0
szOHNumberOfRvaAndSizes			db	'Number Of Rva And Sizes :',0

;;Directory

szOHD												db	'Virtual Address :%08X ; Image Size :%08X',0

szOHD1											db	'Entry Export :',0
szOHD2											db	'Entry Import :',0
szOHD3											db	'Entry Resource :',0
szOHD4											db	'Entry Exception :',0
szOHD5											db	'Entry Security :',0
szOHD6											db	'Entry Base Relocation :',0
szOHD7											db	'Entry Debug :',0
szOHD8											db	'Entry Architecture :',0
szOHD9											db	'Entry Global Ptr :',0
szOHD10											db	'Entry TLS :',0
szOHD11											db	'Entry Load Configure :',0
szOHD12											db	'Entry Bound Import :',0
szOHD13											db	'Entry IAT :',0
szOHD14											db	'Entry Delay Import :',0
szOHD15											db	'Entry COM Descriptor :',0

;;Misc

szSecName1									db	'Section''s Name :',0
szErrorLeak									db	'PE Scanner detect application not running correctly!',0DH,0AH,'Need CLOSE NOW!!',0
szEditEP										db	'EP[RVA]:',20H,0
szEditEP1										db	'EP[Offset]:',20H,0
szCheckBox									db	'&Stay On Top',0
sz16EditMissed							db	'"16Edit.DLL" not found !',0
szFindFilter								db	'*.*',0
szLoadDll										db	'LoadDll',0
szDoMyJob										db	'DoMyJob',0
szDoMyJobIndirect						db	'DoMyJobIndirect',0

szSubsystemNative						db	'Device drivers and native Windows processes',0
szSubsystemWinGUI						db	'The Windows graphical user interface (GUI) subsystem',0
szSubsystemWinCUI						db	'The Windows character subsystem',0
szSubsystemOS2CUI						db	'OS/2 CUI',0
szSubsystemPOSIXCUI					db	'The Posix character subsystem',0
szSubsystemNativeWin				db	'Windows Native',0
szSubsystemWinCE						db	'Windows CE GUI',0
szSubsystemUnknown					db	'An unknown subsystem',0
szSubsystemEFIApp						db	'An Extensible Firmware Interface (EFI) application',0
szSubsystemEFIBoot					db	'An EFI driver with boot services',0
szSubsystemEFIRunt					db	'An EFI driver with run-time services',0
szSubsystemEFIRom						db	'An EFI ROM image',0
szSubsystemXbox							db	'XBOX',0

szSubsystemIs								db	'Subsystem is "%s"',0

szEExport										db	'[0]Export_Entry',0
szEImport										db	'[1]Import_Entry',0
szEResource									db	'[2]Resource_Entry',0
szEException								db	'[3]Exception_Entry',0
szESecurity									db	'[4]Security_Entry',0
szEBaseReloc								db	'[5]BaseReloc_Entry',0
szEDebug										db	'[6]Debug_Entry',0
szEArchitecture							db	'[7]Architecture_Entry',0
szEGlobalptr								db	'[8]GlobalPtr_Entry',0
szETLS											db	'[9]TLS_Entry',0
szELoadConfig								db	'[A]LoadConfig_Entry',0
szEBoundImport							db	'[B]BoundImport_Entry',0
szEIAT											db	'[C]IAT_Entry',0
szEDelayImport							db	'[D]DelayImport_Entry',0
szEComDescriptor						db	'[E]COMDescriptor_Entry',0
szHEEnterWindowLoop					db	'HEEnterWindowLoop',0
szHESpecifySettings					db	'HESpecifySettings',0
szTitleDisassmbler					db	'[ PE Disassembler(32Bit & 64Bit,LDE engine) ]',0
szTitleR2O									db	'[ File Location Calculator ]',0
szCalculate									db	'&Calculate',0
szTimeCvtStatic1						db	'FileTime',0
szTimeCvtStatic2						db	'LocalTime',0
szProfile										db	'\cfg.ini',0
szProfileDir                db  '\PES',0
szApp_											db	'Pos',0
szProfileX									db	'left',0
szProfileY									db	'top',0
szProfileW									db	'width',0
szProfileB									db	'height',0
szApp1											db	'Misc',0
szProfileTopmost						db	'topmost',0
szProfilePlgEnabled					db	'plugins_enable',0
szProfileRecents     				db	'recent_files_enable',0
szProfileLEI                db  'log_exports_imports_enable',0
szMsgDelCfgFiles            db  'Are you sure about deleting configure files in this computer?',0
szProgressTitle             db  'Deleting files ...',0
szMsgCloseWindow            db  'Quit now?',0

dwCMDID											dd	4000

szDisasmAddr								db	'Address',0
szDisasmData								db	'Hex Bytes',0
szDisasmAsm									db	'Assembler',0

sz16EditCls									db	'16EditControl',0
szPEDetectDll								db	'check.dll',0
szPEDetect									db	'GetInfo',0

szMachineIs									db	'Machine type is "%s"',0

szMachine00									db	'Unknown Machine',0
szMachine1d3								db	'Matsushita AM33',0
szMachine8664								db	'x64',0
szMachine1c0								db	'ARM little endian',0
szMachine1c4								db	'ARMv7 (or higher) Thumb mode only',0
szMachineaa64								db	'ARMv8 in 64-bit mode',0
szMachineebc								db	'EFI byte code',0
szMachine14c								db	'Intel 386 or later processors and compatible processors',0
szMachine200								db	'Intel Itanium processor family',0
szMachine9041								db	'Mitsubishi M32R little endian',0
szMachine266								db	'MIPS16',0
szMachine366								db	'MIPS with FPU',0
szMachine466								db	'MIPS16 with FPU',0
szMachine1f0								db	'Power PC little endian',0
szMachine1f1								db	'Power PC with floating point support',0
szMachine166								db	'MIPS little endian',0
szMachine1a2								db	'Hitachi SH3',0
szMachine1a3								db	'Hitachi SH3 DSP',0
szMachine1a6								db	'Hitachi SH4',0
szMachine1a8								db	'Hitachi SH5',0
szMachine1c2								db	'ARM or Thumb ("interworking")',0
szMachine169								db	'MIPS little-endian WCE v2',0

szEPName										db	'Entry Point located on section,"%s"',0
szCheckSum									db	'The CheckSum of File is "%08X"',0
szMD5												db	'The MD5 of File is "%08X:%08X:%08X:%08X"',0
szLinkerVersionIs						db	'The Version of Linker is "%lu .%lu"',0
szFirstBytes								db	'The Pattern of Entry Point is "%s"',0
szDiv												db	260 dup('-')
szRet												db	0DH,0AH,0
szFileTimeStamp							db	'FileTimeStamp:',0
szSystemTime								db	'Output:',0
szTimeCal										db	'[ TimeDateStamp Calculator ]',0
szCrc32Fmt									db	'The CRC32 of File is "%08X"',0

@hImgList										equ	hImgList

;#######################################

.code

;#######################################
Include		Rva2Offset.asm
Include		Offset2Rva.asm
Include		SEH.ASM
Include		OpenFile.asm
Include   LDE64.ASM
;#######################################

_GetRVAName	proc	uses esi edi edx ecx ebx,_lpMem:DWORD,_dwRva:DWORD
		LOCAL		@nSec:DWORD
		
		xor			eax,eax
		mov			esi,_lpMem
		mov			edi,_dwRva
		.if			WORD PTR [esi] != 'ZM'
			jmp			_OutProc
		.endif
		add			esi,[esi+3CH]
		.if			WORD PTR [esi] != 'EP'
			jmp			_OutProc
		.endif
		mov			ecx,esi
		add			ecx,06H
		mov			ax,WORD PTR [ecx]
		mov			@nSec,eax
		movzx		eax,[esi+IMAGE_NT_HEADERS.OptionalHeader.Magic]
		.if			eax == 010BH
			add			esi,24+216+8
		.elseif eax == 020BH
			add			esi,24+232+8
		.endif
		.while	@nSec
			mov			ecx,esi
			add			ecx,08H
			add			ecx,04H
			mov			edx,DWORD PTR [ecx]	;; VirtualAddress
			add			ecx,04H
			mov			eax,DWORD PTR [ecx] ;; SizeOfRawData
			add			eax,edx
			.if		 ( edi >= edx && edi <= eax ) || edi < DWORD PTR [ecx+4]
				jmp			_GetNameHereAndDo
			.endif
			add			esi,sizeof IMAGE_SECTION_HEADER
			dec			@nSec
		.endw
		_GetNameHereAndDo:
		mov			@nSec,esi
		invoke	GlobalAlloc,GPTR,9
		.if			eax
			mov			edi,eax
			mov			esi,@nSec
			mov			ecx,8
			cld
			rep			movsb
		.endif
		_OutProc:
		ret
_GetRVAName	endp

_GetProfilePath	proc	_lpBuffer:DWORD ;;  get profile pathname here
    jmp     @F
    db      'APPDATA',0
    @@:
    invoke  GetEnvironmentVariable,offset @B - 8,_lpBuffer,260
    invoke  lstrcat,_lpBuffer,offset szProfileDir
    invoke  CreateDirectory,_lpBuffer,0
		invoke	lstrcat,_lpBuffer,offset szProfile
		ret
_GetProfilePath	endp

;#######################################

_HexViewProc	proc	uses esi edi ecx edx ebx,lParam:DWORD
	LOCAL		@hFile:DWORD
	LOCAL		@hFileMap:DWORD
	LOCAL		@hLib:DWORD
	LOCAL		@lpHEEnterWindowLoop:DWORD
	LOCAL		@lpHESpecifySettings:DWORD
	LOCAL		@lpMem:DWORD
	LOCAL		@dwSize:DWORD
	LOCAL		@stHE:HE_SETTINGS
	MOV			@hLib,0
	mov			@hFile,0
	mov			@hFileMap,0
	mov			@lpMem,0
	invoke	CreateFile,offset stFile.szFile,GENERIC_READ or GENERIC_WRITE,FILE_SHARE_READ,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	cmp			eax,-1
	je			_OutHex
	mov			@hFile,eax
	invoke	GetFileSize,@hFile,0
	cmp			eax,-1
	je			_OutHex
	mov			@dwSize,eax
	invoke	CreateFileMapping,@hFile,0,PAGE_READWRITE,0,0,offset szObjName
	or			eax,eax
	jz			_OutHex
	mov			@hFileMap,eax
	invoke	MapViewOfFile,@hFileMap,FILE_MAP_READ or FILE_MAP_WRITE,0,0,0
	or			eax,eax
	jz			_OutHex
	mov			@lpMem,eax

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov			esi,eax
	add			esi,[esi+3CH]
	movzx		eax,[esi+IMAGE_NT_HEADERS.OptionalHeader.Magic]
	.if			eax == 010BH
		add			esi,24+92+4
	.elseif eax == 020BH
		add			esi,24+108+4
	.endif
	
	mov			eax,lParam
	.if			eax == '0'
	.elseif	eax == '1'
		add			esi,8
	.elseif	eax == '2'
		add			esi,16
	.elseif eax == '3'
		add			esi,24
	.elseif eax == '4'
		add			esi,32
	.elseif eax == '5'
		add			esi,40
	.elseif eax == '6'
		add			esi,48
	.elseif eax == '7'
		add			esi,56
	.elseif eax == '8'
		add			esi,64
	.elseif eax == '9'
		add			esi,72
	.elseif eax == 'A'
		add			esi,80
	.elseif eax == 'B'
		add			esi,88
	.elseif eax == 'C'
		add			esi,96
	.elseif eax == 'D'
		add			esi,104
	.else
		add			esi,112
	.endif
	mov			eax,DWORD PTR [esi]
	mov			ecx,DWORD PTR [esi+4]
	invoke	_RVAToRAW,@lpMem,eax
	add			ecx,eax
	;; EAX - ECX
	pushad
	invoke	LoadLibrary,offset sz16Edit
	.if			!eax
		invoke	SendMessage,hEdit1,WM_SETTEXT,0,offset sz16EditMissed
		popad
		jmp			_OutHex
	.endif
	mov			@hLib,eax
	invoke	GetProcAddress,@hLib,offset szHESpecifySettings
	.if			!eax
		popad
		jmp			_OutHex
	.endif
	mov			@lpHESpecifySettings,eax
	invoke	GetProcAddress,@hLib,offset szHEEnterWindowLoop
	.if			!eax
		popad
		jmp			_OutHex
	.endif
	mov			@lpHEEnterWindowLoop,eax
	xor			eax,eax
	mov			ecx,sizeof @stHE
	lea			edi,@stHE
	cld
	rep			stosb
	popad
	mov			@stHE.dwMask,08H or 100H or 40H or 80H
	mov			@stHE.dwSelStart,eax
	dec			ecx
	mov			@stHE.dwSelEnd,ecx
	push		stFile.hWinMain
	pop			@stHE.hParent
	mov			eax,@lpMem
	mov			@stHE.diMem.lpBuffer,eax
	mov			ecx,@dwSize
	mov			@stHE.diMem.dwSize,ecx
	mov			@stHE.diMem.dwIsReadOnly,0
	lea			eax,@stHE
	push		eax
	call		@lpHESpecifySettings
	call		@lpHEEnterWindowLoop
	_OutHex:
	.if			@hLib
		invoke	FreeLibrary,@hLib
	.endif
	.if			@lpMem
		invoke	UnmapViewOfFile,@lpMem
	.endif
	.if			@hFileMap
		invoke	CloseHandle,@hFileMap
	.endif
	.if			@hFile
		invoke	CloseHandle,@hFile
	.endif
	ret
_HexViewProc	endp

_TrackPopupMenu	proc lParam:DWORD
	LOCAL		@stRc:RECT
	invoke	GetWindowRect,lParam,addr @stRc
	invoke	TrackPopupMenu,hMenuPlg,TPM_LEFTALIGN,@stRc.right,@stRc.top,0,stFile.hWinMain,0
	ret	
_TrackPopupMenu	endp

_InitSecDlg	proc	lParam:DWORD
	LOCAL			@stLVC:LV_COLUMN
	invoke		SetEvent,hEvent
	invoke		WaitForSingleObject,hEvent,INFINITE
	invoke		SendMessage,lParam,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT
	mov				@stLVC.imask,LVCF_FMT or LVCF_SUBITEM or LVCF_TEXT or LVCF_WIDTH
	mov				@stLVC.fmt,LVCFMT_CENTER
	mov				@stLVC.lx,76
	mov				@stLVC.iSubItem,0
	mov				@stLVC.pszText,offset szCharacteristics
	mov				@stLVC.cchTextMax,sizeof szCharacteristics
	invoke		SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stLVC
	inc				@stLVC.iSubItem
	mov				@stLVC.pszText,offset szSecNLinenum
	mov				@stLVC.cchTextMax,sizeof szSecNLinenum
	invoke		SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stLVC
	inc				@stLVC.iSubItem
	mov				@stLVC.pszText,offset szSecNReloc
	mov				@stLVC.cchTextMax,sizeof szSecNReloc
	invoke		SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stLVC
	inc				@stLVC.iSubItem
	mov				@stLVC.pszText,offset szSecLinenumbers
	mov				@stLVC.cchTextMax,sizeof szSecLinenumbers
	invoke		SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stLVC
	inc				@stLVC.iSubItem
	mov				@stLVC.pszText,offset szSecRelocations
	mov				@stLVC.cchTextMax,sizeof szSecRelocations
	invoke		SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stLVC
	inc				@stLVC.iSubItem
	mov				@stLVC.pszText,offset szSecRawOffset
	mov				@stLVC.cchTextMax,sizeof szSecRawOffset
	invoke		SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stLVC
	inc				@stLVC.iSubItem
	mov				@stLVC.pszText,offset szSecRawSize
	mov				@stLVC.cchTextMax,sizeof szSecRawSize
	invoke		SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stLVC
	inc				@stLVC.iSubItem
	mov				@stLVC.pszText,offset szSecVirAddr
	mov				@stLVC.cchTextMax,sizeof szSecVirAddr
	invoke		SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stLVC
	inc				@stLVC.iSubItem
	mov				@stLVC.pszText,offset szSecVirSize
	mov				@stLVC.cchTextMax,sizeof szSecVirSize
	invoke		SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stLVC
	inc				@stLVC.iSubItem
	mov				@stLVC.pszText,offset szSecName
	mov				@stLVC.cchTextMax,sizeof szSecName
	invoke		SendMessage,lParam,LVM_INSERTCOLUMN,0,addr @stLVC
	invoke		ResetEvent,hEvent
	ret
_InitSecDlg	endp

_ScanSecDlg	proc	uses esi edi,lParam:DWORD
	LOCAL		@stlvi:LV_ITEM
	LOCAL		@nSec:DWORD
	LOCAL		@szBuf[260]:BYTE
	mov			@stlvi.imask,LVIF_TEXT
	mov			@stlvi.iItem,0
	mov			@stlvi.cchTextMax,260
	;invoke	SendMessage,lParam,LVM_INSERTITEM,0,addr @stlvi
	assume	fs:nothing
	push		ebp
	push		offset	@@Exit
	push		offset _HandlerProc
	push		fs:[0]
	mov			fs:[0],esp
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp			stFile.lpMem,0
	jne			@F
	invoke	_OpenFile,offset stFile.szFile
	or			eax,eax
	jz			@@Exit
	mov			stFile.lpMem,eax
	@@:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov			esi,stFile.lpMem
	add			esi,[esi+3CH]
	mov			ax,WORD PTR [esi]
	cmp			ax,'EP'
	je			@F
	jmp			@@Exit
	@@:
	mov			edi,esi
	add			edi,06H
	xor			ecx,ecx
	mov			cx,WORD PTR [edi]
	mov			@nSec,ecx
	add			esi,sizeof IMAGE_NT_HEADERS
	@@:
	mov			edi,esi
	mov			@stlvi.pszText,edi
	mov			@stlvi.iSubItem,0
	pushad
	invoke	SendMessage,lParam,LVM_INSERTITEM,0,addr @stlvi
	popad
	add			edi,8
	mov			ecx,6
	_MiniLoop:
	pushad
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [edi]
	inc			@stlvi.iSubItem
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendMessage,lParam,LVM_SETITEM,0,addr @stlvi
	popad
	add			edi,4
	loop		_MiniLoop
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [edi]
	inc			@stlvi.iSubItem
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendMessage,lParam,LVM_SETITEM,0,addr @stlvi
	add			edi,2
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [edi]
	inc			@stlvi.iSubItem
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendMessage,lParam,LVM_SETITEM,0,addr @stlvi
	add			edi,2
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [edi]
	inc			@stlvi.iSubItem
	lea			eax,@szBuf
	mov			@stlvi.pszText,eax
	invoke	SendMessage,lParam,LVM_SETITEM,0,addr @stlvi
	dec			@nSec
	cmp			@nSec,0
	jle			@@Exit
	add			esi,sizeof IMAGE_SECTION_HEADER
	inc			@stlvi.iItem
	mov			@stlvi.iSubItem,0
	jmp			@B
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	@@Exit:
	pop			fs:[0]
	add			esp,12
	ret
_ScanSecDlg	endp

_CleanOutEd	proc	_hWnd:DWORD
	pushad
	xor			eax,eax
	push		eax
	mov			esi,esp
	invoke	SendDlgItemMessage,_hWnd,1060,WM_SETTEXT,0,esi
	invoke	SendDlgItemMessage,_hWnd,1056,WM_SETTEXT,0,esi
	invoke	SendDlgItemMessage,_hWnd,1014,WM_SETTEXT,0,esi
	invoke	SendDlgItemMessage,_hWnd,1015,WM_SETTEXT,0,esi
	invoke	SendDlgItemMessage,_hWnd,1088,WM_SETTEXT,0,esi
	invoke	SendDlgItemMessage,_hWnd,1057,WM_SETTEXT,0,esi
	add			esp,4
	invoke	GetDlgItem,_hWnd,1058
	.if			eax
		invoke	EnableWindow,eax,0
	.endif
	popad
	ret
_CleanOutEd	endp

_R2OProc	proc	uses esi edi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@szBuf[260]:BYTE
		LOCAL		@imgbase[2]:DWORD
		LOCAL		@stHE:HE_SETTINGS
	.if			uMsg == WM_INITDIALOG
		invoke	SendMessage,hWnd,WM_SETTEXT,0,offset szTitleR2O
		cmp			stFile.lpMem,0
		jz			@F
		invoke	CheckDlgButton,hWnd,1054,BST_CHECKED
		invoke	GetDlgItem,hWnd,1014
		.if			eax
			invoke	EnableWindow,eax,1
		.endif
		invoke	GetDlgItem,hWnd,1056
		.if			eax
			invoke	EnableWindow,eax,0
		.endif
		invoke	GetDlgItem,hWnd,1015
		.if			eax
			invoke	EnableWindow,eax,0
		.endif
		invoke	GetDlgItem,hWnd,1060
		.if			eax
			invoke	EnableWindow,eax,0
		.endif
	.elseif	uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0FFFFH
		.if			eax == 1052
			xor			eax,eax
			lea			edi,@szBuf
			mov			ecx,sizeof @szBuf
			cld
			rep			stosb
			push		ebp
			push		offset @@check
			push		offset _HandlerProc
			assume	fs:nothing
			push		fs:[0]
			mov			fs:[0],esp
			mov			esi,stFile.lpMem
			assume	esi:PTR IMAGE_DOS_HEADER
			.if			[esi].e_magic == IMAGE_DOS_SIGNATURE
				add			esi,[esi].e_lfanew
				assume	esi:PTR IMAGE_NT_HEADERS
				.if			[esi].Signature == IMAGE_NT_SIGNATURE
					.if			[esi].OptionalHeader.Magic == 020BH		;; 64 bit
						push		[esi].OptionalHeader.BaseOfData
						pop			@imgbase[0]
						push		[esi].OptionalHeader.ImageBase
						pop			@imgbase[4]
					.else								 ;; 32 bit
						push		[esi].OptionalHeader.ImageBase
						pop			@imgbase[0]
						mov			@imgbase[4],0
					.endif
				.endif
			.endif
			@@check:
			assume	esi:nothing
			pop			fs:[0]
			add			esp,12
			invoke	IsDlgButtonChecked,hWnd,1053
			.if			eax == BST_CHECKED
				invoke	SendDlgItemMessage,hWnd,1056,WM_GETTEXT,sizeof @szBuf,addr @szBuf
				.if			eax
					invoke	_Ascii2Dword16,addr @szBuf
					sub			eax,@imgbase
					mov			edi,eax
					invoke	wsprintf,addr @szBuf,offset szFmt8,eax
					invoke	SendDlgItemMessage,hWnd,1014,WM_SETTEXT,0,addr @szBuf
					invoke	_GetRVAName,stFile.lpMem,edi
					.if			eax
						push		eax
						invoke	SendDlgItemMessage,hWnd,1088,WM_SETTEXT,0,eax
						pop			eax
						invoke	GlobalFree,eax
					.endif
					invoke	_RVAToRAW,stFile.lpMem,edi
					.if			eax
						push		eax
						mov			esi,eax
						add			esi,stFile.lpMem
						lea			edi,@szBuf
						mov			ecx,16
						___loop_1:
						push		ecx
						xor			eax,eax
						cld
						lodsb
						invoke	wsprintf,edi,offset szFmt2,eax
						add			edi,eax
						pop			ecx
						loop		___loop_1
						xor			eax,eax
						cld
						stosb
						invoke	SendDlgItemMessage,hWnd,1057,WM_SETTEXT,0,addr @szBuf
						invoke	GetDlgItem,hWnd,1058
						.if			eax
							invoke	EnableWindow,eax,1
						.endif
						pop			eax
						invoke	wsprintf,addr @szBuf,offset szFmt8,eax
						invoke	SendDlgItemMessage,hWnd,1015,WM_SETTEXT,0,addr @szBuf
						mov			@imgbase,0
					.endif
				.endif
			.else
				invoke	IsDlgButtonChecked,hWnd,1054
				.if			eax == BST_CHECKED
					.if			stFile.dwReserve == 64
						invoke	wsprintf,addr @szBuf,offset szFmt8,@imgbase[4]
						invoke	SendDlgItemMessage,hWnd,1060,WM_SETTEXT,0,addr @szBuf
					.endif
					invoke	SendDlgItemMessage,hWnd,1014,WM_GETTEXT,sizeof @szBuf,addr @szBuf
					.if			eax
						invoke	_Ascii2Dword16,addr @szBuf
						push		eax
						add			eax,@imgbase
						invoke	wsprintf,addr @szBuf,offset szFmt8,eax
						invoke	SendDlgItemMessage,hWnd,1056,WM_SETTEXT,0,addr @szBuf
						pop			eax
						push		eax
						invoke	_GetRVAName,stFile.lpMem,eax
						.if			eax
							push		eax
							invoke	SendDlgItemMessage,hWnd,1088,WM_SETTEXT,0,eax
							pop			eax
							invoke	GlobalFree,eax
						.endif
						pop			eax
						invoke	_RVAToRAW,stFile.lpMem,eax
						.if			eax
							push		eax
							mov			esi,eax
							add			esi,stFile.lpMem
							lea			edi,@szBuf
							mov			ecx,16
							___loop_2:
							push		ecx
							xor			eax,eax
							cld
							lodsb
							invoke	wsprintf,edi,offset szFmt2,eax
							add			edi,eax
							pop			ecx
							loop		___loop_2
							xor			eax,eax
							cld
							stosb
							invoke	SendDlgItemMessage,hWnd,1057,WM_SETTEXT,0,addr @szBuf
							invoke	GetDlgItem,hWnd,1058
							.if			eax
								invoke	EnableWindow,eax,1
							.endif
							pop			eax
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1015,WM_SETTEXT,0,addr @szBuf
							mov			@imgbase,0
						.endif
					.endif
				.else
					invoke	SendDlgItemMessage,hWnd,1015,WM_GETTEXT,sizeof @szBuf,addr @szBuf
					.if			eax
						invoke	_Ascii2Dword16,addr @szBuf
						push		eax
						mov			esi,eax
						add			esi,stFile.lpMem
						lea			edi,@szBuf
						mov			ecx,16
						___loop_3:
						push		ecx
						xor			eax,eax
						cld
						lodsb
						invoke	wsprintf,edi,offset szFmt2,eax
						add			edi,eax
						pop			ecx
						loop		___loop_3
						xor			eax,eax
						cld
						stosb
						invoke	SendDlgItemMessage,hWnd,1057,WM_SETTEXT,0,addr @szBuf
						invoke	GetDlgItem,hWnd,1058
						.if			eax
							invoke	EnableWindow,eax,1
						.endif
						pop			eax
						invoke	_Offset2Rva,stFile.lpMem,eax
						.if			eax
							push		eax
							invoke	_GetRVAName,stFile.lpMem,eax
							.if			eax
								push		eax
								invoke	SendDlgItemMessage,hWnd,1088,WM_SETTEXT,0,eax
								pop			eax
								invoke	GlobalFree,eax
							.endif
							pop			eax
							push		eax
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1014,WM_SETTEXT,0,addr @szBuf
							pop			eax
							add			@imgbase,eax
							invoke	wsprintf,addr @szBuf,offset szFmt8,@imgbase
							invoke	SendDlgItemMessage,hWnd,1056,WM_SETTEXT,0,addr @szBuf
							.if			stFile.dwReserve == 64
								invoke	wsprintf,addr @szBuf,offset szFmt8,@imgbase[4]
								invoke	SendDlgItemMessage,hWnd,1060,WM_SETTEXT,0,addr @szBuf
							.endif
							mov			@imgbase,0
						.endif
					.endif
				.endif
			.endif
			.if			@imgbase
				invoke	_CleanOutEd,hWnd
			.endif
		.elseif eax == 1058
			invoke	LoadLibrary,offset sz16Edit
			.if			eax
				mov			@imgbase,eax
				invoke	GetProcAddress,@imgbase,offset szHESpecifySettings
				.if			eax
					mov			esi,eax
					xor			eax,eax
					mov			ecx,sizeof @stHE
					lea			edi,@stHE
					cld
					rep			stosb
					invoke	SendDlgItemMessage,hWnd,1015,WM_GETTEXT,sizeof @szBuf,addr @szBuf
					invoke	_Ascii2Dword16,addr @szBuf
					mov			@stHE.dwMask,04H or 100H or 80H or 40H
					mov			@stHE.posCaret.dwOffset,eax
					push		hWnd
					pop			@stHE.hParent
					push		stFile.lpMem
					pop			@stHE.diMem.lpBuffer
					push		stFile.cbMem
					pop			@stHE.diMem.dwSize
					mov			@stHE.diMem.dwIsReadOnly,1
					lea			eax,@stHE
					push		eax
					call		esi
					invoke	GetProcAddress,@imgbase,offset szHEEnterWindowLoop
					.if			eax
						call		eax
					.endif
				.endif
				invoke	FreeLibrary,eax
			.else
				invoke	EnableWindow,lParam,0
			.endif
		.elseif eax == 1059
			jmp			@F
		.elseif eax == 1053
			invoke	_CleanOutEd,hWnd
			invoke	GetDlgItem,hWnd,1056
			.if			eax
				invoke	EnableWindow,eax,1
			.endif
			.if			stFile.dwReserve == 64
				invoke	GetDlgItem,hWnd,1060
				.if			eax
					invoke	EnableWindow,eax,1
				.endif
			.endif
			invoke	GetDlgItem,hWnd,1014
			.if			eax
				invoke	EnableWindow,eax,0
			.endif
			invoke	GetDlgItem,hWnd,1015
			.if			eax
				invoke	EnableWindow,eax,0
			.endif
		.elseif eax == 1054
			invoke	_CleanOutEd,hWnd
			invoke	GetDlgItem,hWnd,1056
			.if			eax
				invoke	EnableWindow,eax,0
			.endif
			invoke	GetDlgItem,hWnd,1014
			.if			eax
				invoke	EnableWindow,eax,1
			.endif
			invoke	GetDlgItem,hWnd,1015
			.if			eax
				invoke	EnableWindow,eax,0
			.endif
			invoke	GetDlgItem,hWnd,1060
			.if			eax
				invoke	EnableWindow,eax,0
			.endif
		.elseif eax == 1055
			invoke	_CleanOutEd,hWnd
			invoke	GetDlgItem,hWnd,1056
			.if			eax
				invoke	EnableWindow,eax,0
			.endif
			invoke	GetDlgItem,hWnd,1014
			.if			eax
				invoke	EnableWindow,eax,0
			.endif
			invoke	GetDlgItem,hWnd,1015
			.if			eax
				invoke	EnableWindow,eax,1
			.endif
			invoke	GetDlgItem,hWnd,1060
			.if			eax
				invoke	EnableWindow,eax,0
			.endif
		.endif
	.elseif	uMsg == WM_LBUTTONDOWN
		invoke	SendMessage,hWnd,WM_NCLBUTTONDOWN,HTCAPTION,0
	.elseif	uMsg == WM_CLOSE
		@@:
		invoke	EndDialog,hWnd,0
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_R2OProc	endp

_TimeCal	proc uses esi edi	hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@stRc:RECT
		LOCAL		@szBuf[120]:BYTE
		LOCAL		@dwTimeStamp:DWORD
		LOCAL		@stTm:crt_tm
		LOCAL		@stSt:SYSTEMTIME
		LOCAL   @stTt:SYSTEMTIME
	.if			uMsg == WM_CLOSE
		invoke	EndDialog,hWnd,0
	.elseif uMsg == WM_INITDIALOG
		invoke	SendMessage,hWnd,WM_SETTEXT,0,offset szTimeCal
		invoke	SendDlgItemMessage,hWnd,1000,WM_SETTEXT,0,offset szFileTimeStamp
		invoke	SendDlgItemMessage,hWnd,1001,WM_SETTEXT,0,offset szSystemTime
	.elseif uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0ffffh
		.if			eax == 1
			push		eax
			invoke	SendDlgItemMessage,hWnd,2,WM_GETTEXT,4,esp
			pop			eax
			.if			al == '+'
				invoke	SendDlgItemMessage,hWnd,200,WM_GETTEXT,120,addr @szBuf
				.if			eax
					sub			esp,64
					mov			edi,esp
					invoke	lstrcpy,edi,addr @szBuf
					invoke	_Ascii2Dword16,eax
					mov			@dwTimeStamp,eax
					add			esp,64
					invoke	crt_gmtime,addr @dwTimeStamp
					.if			eax
						push		[eax+crt_tm.tm_sec]
						pop			@stTm.tm_sec
						push		[eax+crt_tm.tm_min]
						pop			@stTm.tm_min
						push		[eax+crt_tm.tm_hour]
						pop			@stTm.tm_hour
						push		[eax+crt_tm.tm_mday]
						pop			@stTm.tm_mday
						push		[eax+crt_tm.tm_mon]
						pop			@stTm.tm_mon
						inc			@stTm.tm_mon
						push		[eax+crt_tm.tm_year]
						pop			@stTm.tm_year
						add			@stTm.tm_year,1900
						invoke	wsprintf,addr @szBuf,offset szFmtTime,@stTm.tm_mon,@stTm.tm_mday,@stTm.tm_year,@stTm.tm_hour,@stTm.tm_min,@stTm.tm_sec
						push		'-'
						mov			eax,esp
						invoke	_AddText,eax,00H
						add			esp,4
						invoke	_AddText,addr @szBuf,00H
						invoke	SendDlgItemMessage,hWnd,201,WM_SETTEXT,0,addr @szBuf
					.endif
				.endif
			.else	
				invoke	SendDlgItemMessage,hWnd,202,DTM_GETSYSTEMTIME,0,addr @stSt
				.if			eax == GDT_VALID
					movzx		eax,@stSt.wMonth
					mov			@stTm.tm_mon,eax
					movzx		eax,@stSt.wDay
					mov			@stTm.tm_mday,eax
					movzx		eax,@stSt.wYear
					mov			@stTm.tm_year,eax
					invoke	SendDlgItemMessage,hWnd,203,DTM_GETSYSTEMTIME,0,addr @stSt
					.if			eax == GDT_VALID
						movzx		eax,@stSt.wHour
						mov			@stTm.tm_hour,eax
						movzx		eax,@stSt.wMinute
						mov			@stTm.tm_min,eax
						movzx		eax,@stSt.wSecond
						mov			@stTm.tm_sec,eax
						invoke  GetSystemTime,addr @stTt ;; UTC time
						movzx   eax,@stTt.wHour
						push    eax
						invoke  GetLocalTime,addr @stTt ;; Local time
						pop     eax
						sub     @stTt.wHour,ax
						movzx   eax,@stTt.wHour ;; Local Time Zone
						add			@stTm.tm_hour,eax
						sub			@stTm.tm_year,1900
						dec			@stTm.tm_mon
						mov			@stTm.tm_isdst,1
						invoke	crt_mktime,addr @stTm ;; UTC~ timestamp
						.if			eax != -1
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							push		'-'
							mov			eax,esp
							invoke	_AddText,eax,00H
							add			esp,4
							invoke	_AddText,addr @szBuf,00H
							invoke	SendDlgItemMessage,hWnd,201,WM_SETTEXT,0,addr @szBuf
						.endif
					.endif
				.endif
			.endif
		.elseif eax == 2
			invoke	GetWindowRect,hWnd,addr @stRc
			.if			eax
				mov			eax,@stRc.left
				sub			@stRc.right,eax
				mov			eax,@stRc.top
				sub			@stRc.bottom,eax
				push		eax
				invoke	SendMessage,lParam,WM_GETTEXT,4,esp
				pop			eax
				.if			al == '+'
  				mov			eax,@stRc.bottom
  				add			eax,40
  				invoke	SetWindowPos,hWnd,HWND_TOP,@stRc.left,@stRc.top,@stRc.right,eax,SWP_NOMOVE
  				mov			eax,'-'
  				push		eax
  				invoke	SendMessage,lParam,WM_SETTEXT,0,esp
  				add			esp,4
  				invoke	SendDlgItemMessage,hWnd,200,EM_SETREADONLY,1,0
				.else
					mov			eax,@stRc.bottom
					sub			eax,40
					invoke	SetWindowPos,hWnd,HWND_TOP,@stRc.left,@stRc.top,@stRc.right,eax,SWP_NOMOVE
					mov			eax,'+'
					push		eax
					invoke	SendMessage,lParam,WM_SETTEXT,0,esp
					add			esp,4
					invoke	SendDlgItemMessage,hWnd,200,EM_SETREADONLY,0,0
				.endif
			.endif
		.endif
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_TimeCal	endp

_IsObjFile	proc	
	invoke	_OpenFile,offset stFile.szFile
	.if			eax
		mov			stFile.lpMem,eax
		movzx		eax,WORD PTR [eax]
		.if			eax != 014CH
			mov			eax,1
			ret
		.endif
		
		invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szObjDect
		invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szRet
	
		invoke	_ScanObj,stFile.lpMem,stFile.hWinMain,1,2
		xor			eax,eax
	.endif
	ret
_IsObjFile	endp

_PE_DETECT	proc
	pushad
	sub			lpPEDetectEntry,0
	jz			@@quit_detect
	assume	fs:nothing
	push		ebp
	push		offset @F
	push		offset _HandlerProc
	push		offset fs:[0]
	mov			fs:[0],esp
	push		hEdit1
	push		stFile.lpMem
	call		lpPEDetectEntry
	@@:
	pop			fs:[0]
	add			esp,12
	@@quit_detect:
	popad
	ret
_PE_DETECT	endp

_ScanPE		proc	uses esi edi,lParam:DWORD
	LOCAL		@lpVMem:DWORD
	LOCAL		@dwCount:DWORD
	LOCAL		@stLVI:LV_ITEM
	LOCAL		@szBuf[260]:BYTE
	LOCAL		@szBf[260]:BYTE
	LOCAL		@stTVIS:TV_INSERTSTRUCT
	LOCAL		@nSec:DWORD
	
	invoke	SetEvent,hEvent
	invoke	WaitForSingleObject,hEvent,INFINITE
	.if     lParam
	  invoke  lstrcpyn,offset stFile.szFile,lParam,sizeof stFile.szFile
	.endif
	push    0
	invoke	SendMessage,hEdit,WM_SETTEXT,0,esp
	invoke	SendMessage,hEdit1,WM_SETTEXT,0,esp
	invoke	SendMessage,hEdit2,WM_SETTEXT,0,esp
	add     esp,4
	invoke	EnableWindow,hButton4,0
	invoke	EnableWindow,hButton5,0
	invoke	SendMessage,hTree,TVM_DELETEITEM,0,TVI_ROOT
	invoke	SendMessage,hList,LVM_DELETEALLITEMS,0,0
	invoke	SendMessage,hListBox,LB_RESETCONTENT,0,0
	call		_IsObjFile
	or			eax,eax
	jz			_Exit
	
	assume	fs:nothing
	push		ebp
	push		offset _Exit
	push		offset _HandlerProc
	push		fs:[0]
	mov			fs:[0],esp
	
	xor			eax,eax
	lea			esi,stFile.szFile
	cld
	lodsb
	cmp			eax,0
	jne			@F
	ret
	@@:
	
	call		_TVProc
	
	mov			@lpVMem,0
	mov			@hImgList,0
	xor			eax,eax
	lea			edi,@stLVI
	mov			ecx,sizeof LV_ITEM
	cld
	rep			stosb
	mov			@stLVI.imask,LVIF_TEXT
	
	lea				edi,@stTVIS
	xor				eax,eax
	mov				ecx,sizeof TV_INSERTSTRUCT
	cld
	rep				stosb
	invoke		ImageList_Create,16,16,ILC_COLOR16 or ILC_MASK,2,4
	.if				eax
		mov				@hImgList,eax
		mov       stFile.hImageList,eax
		invoke		LoadBitmap,stFile.hInstance,100
		invoke		ImageList_AddMasked,@hImgList,eax,00808080H
	.endif
	mov				@stTVIS.hInsertAfter,TVI_LAST
	mov				@stTVIS.item.imask,TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
	mov				@stTVIS.item.iImage,0
	mov				@stTVIS.item.iSelectedImage,1
	mov				@stTVIS.item.cchTextMax,260
	
	invoke		_SetStatusBar
	
	cmp			stFile.lpMem,0
	je			@F
	invoke	_OpenFile,0
	@@:
	invoke	_OpenFile,offset stFile.szFile
	or			eax,eax
	jz			_Exit
	mov			stFile.lpMem,eax
	mov			esi,stFile.lpMem
	assume	esi:PTR IMAGE_DOS_HEADER
	.if			WORD PTR [esi].e_magic != 'ZM'
		invoke	SendMessage,hEdit1,WM_SETTEXT,0,offset szNoDos
		jmp			_Exit
	.endif
	invoke	lstrcpy,addr @szBf,offset sze_magic
	movzx		eax,WORD PTR [esi]
	push		eax
	invoke	lstrcat,addr @szBf,esp
	add			esp,4
	mov			@stTVIS.item.pszText,eax
	push		hChild1
	pop			@stTVIS.hParent
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_cblp
	invoke	lstrcpy,addr @szBf,offset sze_cblp
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_cp
	invoke	lstrcpy,addr @szBf,offset sze_cp
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_crlc
	invoke	lstrcpy,addr @szBf,offset sze_crlc
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_cparhdr
	invoke	lstrcpy,addr @szBf,offset sze_cparhdr
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_minalloc
	invoke	lstrcpy,addr @szBf,offset sze_minalloc
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_maxalloc
	invoke	lstrcpy,addr @szBf,offset sze_maxalloc
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_ss
	invoke	lstrcpy,addr @szBf,offset sze_ss
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_sp
	invoke	lstrcpy,addr @szBf,offset sze_sp
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_csum
	invoke	lstrcpy,addr @szBf,offset sze_csum
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_ip
	invoke	lstrcpy,addr @szBf,offset sze_ip
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_cs
	invoke	lstrcpy,addr @szBf,offset sze_cs
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_lfarlc
	invoke	lstrcpy,addr @szBf,offset sze_lfarlc
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_ovno
	invoke	lstrcpy,addr @szBf,offset sze_ovno
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	mov			edi,esi
	add			edi,28
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [edi]
	invoke	lstrcpy,addr @szBf,offset sze_res
	invoke	lstrcat,addr @szBf,addr @szBuf
	mov			@dwCount,3
	.while	@dwCount
		add			edi,2
		invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [edi]
		invoke	lstrcat,addr @szBf,addr @szBuf
		dec			@dwCount
	.endw
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_oemid
	invoke	lstrcpy,addr @szBf,offset sze_oemid
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_oeminfo
	invoke	lstrcpy,addr @szBf,offset sze_oeminfo
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	mov			edi,esi
	add			edi,40
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [edi]
	invoke	lstrcpy,addr @szBf,offset sze_res2
	invoke	lstrcat,addr @szBf,addr @szBuf
	mov			@dwCount,9
	.while	@dwCount
		add			edi,2
		invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [edi]
		invoke	lstrcat,addr @szBf,addr @szBuf
		dec			@dwCount
	.endw
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].e_lfanew
	invoke	lstrcpy,addr @szBf,offset sze_lfanew
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	add			esi,[esi].e_lfanew
	assume	esi:PTR IMAGE_NT_HEADERS
	.if			WORD PTR [esi].Signature != 'EP'
		invoke	SendMessage,hEdit1,WM_SETTEXT,0,offset szNoPE
		jmp			_Exit
	.endif
	
	invoke	lstrcpy,addr @szBf,offset szSignature
	mov			eax,DWORD PTR [esi]
	push		eax
	invoke	lstrcat,addr @szBf,esp
	add			esp,4
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	push		hChild2
	pop			@stTVIS.hParent
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	mov			@stTVIS.item.pszText,offset szImgFileHeader
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	push		eax
	pop			@stTVIS.hParent
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].FileHeader.Machine
	invoke	lstrcpy,addr @szBf,offset szFHMachine
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].FileHeader.NumberOfSections
	movzx		eax,WORD PTR [esi].FileHeader.NumberOfSections
	mov			@nSec,eax
	invoke	lstrcpy,addr @szBf,offset szFHNumberOfSections
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].FileHeader.TimeDateStamp
	invoke	lstrcpy,addr @szBf,offset szFHTimeDateStamp
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].FileHeader.PointerToSymbolTable
	invoke	lstrcpy,addr @szBf,offset szFHPointerToSymbolTable
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].FileHeader.NumberOfSymbols
	invoke	lstrcpy,addr @szBf,offset szFHNumberOfSymbols
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].FileHeader.SizeOfOptionalHeader
	invoke	lstrcpy,addr @szBf,offset szFHSizeOfOptionalHeader
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].FileHeader.Characteristics
	invoke	lstrcpy,addr @szBf,offset szFHCharacteristics
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	push		hChild2
	pop			@stTVIS.hParent
	mov			@stTVIS.item.pszText,offset szImgOptionalHeader
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	push		eax
	pop			@stTVIS.hParent
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].OptionalHeader.Magic
	invoke	lstrcpy,addr @szBf,offset szOHMagic
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt2,BYTE PTR [esi].OptionalHeader.MajorLinkerVersion
	invoke	lstrcpy,addr @szBf,offset szOHMajorLinkerVersion
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt2,BYTE PTR [esi].OptionalHeader.MinorLinkerVersion
	invoke	lstrcpy,addr @szBf,offset szOHMinorLinkerVersion
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.SizeOfCode
	invoke	lstrcpy,addr @szBf,offset szOHSizeOfCode
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.SizeOfInitializedData
	invoke	lstrcpy,addr @szBf,offset szOHSizeOfInitializedData
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.SizeOfUninitializedData
	invoke	lstrcpy,addr @szBf,offset szOHSizeOfUninitializedData
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.AddressOfEntryPoint
	invoke	lstrcpy,addr @szBf,offset szOHAddressOfEntryPoint
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.AddressOfEntryPoint
	invoke	lstrcpy,addr @szBf,offset szEditEP
	invoke	lstrcat,addr @szBf,addr @szBuf
	invoke	SendMessage,hEdit,WM_SETTEXT,0,addr @szBf
	mov			eax,[esi].OptionalHeader.AddressOfEntryPoint
	invoke	_RVAToRAW,stFile.lpMem,eax
	invoke	wsprintf,addr @szBuf,offset szFmt8,eax
	invoke	lstrcpy,addr @szBf,offset szEditEP1
	invoke	lstrcat,addr @szBf,addr @szBuf
	invoke	SendMessage,hEdit2,WM_SETTEXT,0,addr @szBf
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.BaseOfCode
	invoke	lstrcpy,addr @szBf,offset szOHBaseOfCode
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	.if			stFile.dwReserve == 32
		invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.BaseOfData
  	invoke	lstrcpy,addr @szBf,offset szOHBaseOfData
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	.endif
	.if			stFile.dwReserve == 64
		mov			eax,[esi].OptionalHeader.BaseOfData
		mov			ecx,[esi].OptionalHeader.ImageBase
		invoke	wsprintf,addr @szBuf,offset szFmt16,ecx,eax
  	invoke	lstrcpy,addr @szBf,offset szOHImageBase
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	.else	
		invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.ImageBase
  	invoke	lstrcpy,addr @szBf,offset szOHImageBase
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	.endif
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.SectionAlignment
	invoke	lstrcpy,addr @szBf,offset szOHSectionAlignment
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.FileAlignment
	invoke	lstrcpy,addr @szBf,offset szOHFileAlignment
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].OptionalHeader.MajorOperatingSystemVersion
	invoke	lstrcpy,addr @szBf,offset szOHMajorOperatingSystemVersion
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].OptionalHeader.MinorOperatingSystemVersion
	invoke	lstrcpy,addr @szBf,offset szOHMinorOperatingSystemVersion
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].OptionalHeader.MajorImageVersion
	invoke	lstrcpy,addr @szBf,offset szOHMajorImageVersion
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].OptionalHeader.MinorImageVersion
	invoke	lstrcpy,addr @szBf,offset szOHMinorImageVersion
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].OptionalHeader.MajorSubsystemVersion
	invoke	lstrcpy,addr @szBf,offset szOHMajorSubsystemVersion
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].OptionalHeader.MinorSubsystemVersion
	invoke	lstrcpy,addr @szBf,offset szOHMinorSubsystemVersion
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.Win32VersionValue
	invoke	lstrcpy,addr @szBf,offset szOHWin32VersionValue
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.SizeOfImage
	invoke	lstrcpy,addr @szBf,offset szOHSizeOfImage
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.SizeOfHeaders
	invoke	lstrcpy,addr @szBf,offset szOHSizeOfHeaders
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.CheckSum
	invoke	lstrcpy,addr @szBf,offset szOHCheckSum
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].OptionalHeader.Subsystem
	invoke	lstrcpy,addr @szBf,offset szOHSubsystem
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt4,WORD PTR [esi].OptionalHeader.DllCharacteristics
	invoke	lstrcpy,addr @szBf,offset szOHDllCharacteristics
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	.if			stFile.dwReserve == 64
		mov			eax,[esi].OptionalHeader.SizeOfStackReserve
		mov			ecx,[esi].OptionalHeader.SizeOfStackCommit
		invoke	wsprintf,addr @szBuf,offset szFmt16,ecx,eax
  	invoke	lstrcpy,addr @szBf,offset szOHSizeOfStackReserve
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
  	add			esi,4
  	assume	esi:PTR IMAGE_NT_HEADERS
	.else	
		invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.SizeOfStackReserve
  	invoke	lstrcpy,addr @szBf,offset szOHSizeOfStackReserve
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	.endif
	.if			stFile.dwReserve == 64
		mov			eax,[esi].OptionalHeader.SizeOfStackCommit
		mov			ecx,[esi].OptionalHeader.SizeOfHeapReserve
		invoke	wsprintf,addr @szBuf,offset szFmt16,ecx,eax
  	invoke	lstrcpy,addr @szBf,offset szOHSizeOfStackCommit
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
  	add			esi,4
  	assume	esi:PTR IMAGE_NT_HEADERS
	.else
		invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.SizeOfStackCommit
  	invoke	lstrcpy,addr @szBf,offset szOHSizeOfStackCommit
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	.endif
	.if			stFile.dwReserve == 64
		mov			eax,[esi].OptionalHeader.SizeOfHeapReserve
		mov			ecx,[esi].OptionalHeader.SizeOfHeapCommit
		invoke	wsprintf,addr @szBuf,offset szFmt16,ecx,eax
  	invoke	lstrcpy,addr @szBf,offset szOHSizeOfHeapReserve
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
  	add			esi,4
  	assume	esi:PTR IMAGE_NT_HEADERS
	.else
		invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.SizeOfHeapReserve
  	invoke	lstrcpy,addr @szBf,offset szOHSizeOfHeapReserve
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	.endif
	.if			stFile.dwReserve == 64
		mov			eax,[esi].OptionalHeader.SizeOfHeapCommit
		mov			ecx,[esi].OptionalHeader.LoaderFlags
		invoke	wsprintf,addr @szBuf,offset szFmt16,ecx,eax
  	invoke	lstrcpy,addr @szBf,offset szOHSizeOfHeapCommit
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
  	add			esi,4
  	assume	esi:PTR IMAGE_NT_HEADERS
	.else
		invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.SizeOfHeapCommit
  	invoke	lstrcpy,addr @szBf,offset szOHSizeOfHeapCommit
  	invoke	lstrcat,addr @szBf,addr @szBuf
  	lea			eax,@szBf
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	.endif
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.LoaderFlags
	invoke	lstrcpy,addr @szBf,offset szOHLoaderFlags
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	invoke	wsprintf,addr @szBuf,offset szFmt8,DWORD PTR [esi].OptionalHeader.NumberOfRvaAndSizes
	invoke	lstrcpy,addr @szBf,offset szOHNumberOfRvaAndSizes
	invoke	lstrcat,addr @szBf,addr @szBuf
	lea			eax,@szBf
	mov			@stTVIS.item.pszText,eax
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	mov			@stTVIS.item.pszText,offset szImgDataDirectory
	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	push		eax
	pop			@stTVIS.hParent
	
	push		esi
	invoke	VirtualAlloc,0,120,MEM_COMMIT or MEM_RESERVE,PAGE_READWRITE
	.if			!eax
		invoke	SendMessage,hEdit,WM_SETTEXT,0,offset szFailVAlloc
		jmp			_Exit
	.endif
	mov			@lpVMem,eax
	mov			edi,eax
	add			esi,78H
	mov			ecx,120
	cld
	rep			movsb
	pop			esi
	
	mov			edi,esi
	add			edi,78H
	mov			@dwCount,1
	.while	@dwCount < 16
		.if			@dwCount == 1
			.if			DWORD PTR [edi]
				invoke	EnableWindow,hButton4,1
			.endif
			lea			eax,szOHD1
		.elseif	@dwCount == 2
			.if			DWORD PTR [edi]
				invoke	EnableWindow,hButton5,1
			.endif
			lea			eax,szOHD2
		.elseif @dwCount == 3
			lea			eax,szOHD3
		.elseif @dwCount == 4
			lea			eax,szOHD4
		.elseif	@dwCount == 5
			lea			eax,szOHD5
		.elseif	@dwCount == 6
			lea			eax,szOHD6
		.elseif	@dwCount == 7
			lea			eax,szOHD7
		.elseif	@dwCount == 8
			lea			eax,szOHD8
		.elseif	@dwCount == 9
			lea			eax,szOHD9
		.elseif @dwCount == 10
			lea			eax,szOHD10
		.elseif @dwCount == 11
			lea			eax,szOHD11
		.elseif @dwCount == 12
			lea			eax,szOHD12
		.elseif	@dwCount == 13
			lea			eax,szOHD13
		.elseif @dwCount == 14
			lea			eax,szOHD14
		.else
			lea			eax,szOHD15
		.endif
		
		invoke	lstrcpy,addr @szBf,eax
		mov			eax,edi
		add			eax,4
		invoke	wsprintf,addr @szBuf,offset szOHD,DWORD PTR [edi],DWORD PTR [eax]
		invoke	lstrcat,addr @szBf,addr @szBuf
		lea			eax,@szBf
		mov			@stTVIS.item.pszText,eax
		invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
		inc			@dwCount
		add			edi,8
	.endw
	
	push		hChild3
	pop			@stTVIS.hParent
	add			esi,sizeof IMAGE_NT_HEADERS
	assume	esi:PTR IMAGE_SECTION_HEADER
	
	mov			@dwCount,0
	@@:
	mov			eax,@dwCount
	cmp			eax,@nSec
	jge			@F
		invoke	lstrcpyn,addr @szBf,esi,8
		invoke	lstrcpy,addr @szBuf,offset szSecName1
		invoke	lstrcat,addr @szBuf,addr @szBf
  	lea			eax,@szBf	
  	mov			@stTVIS.item.pszText,eax
  	invoke	SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
  	push		@dwCount
  	pop			@stLVI.iItem
  	lea			eax,@szBf
  	mov			@stLVI.pszText,eax
  	mov			@stLVI.cchTextMax,260
  	invoke	SendMessage,hList,LVM_INSERTITEM,0,addr @stLVI
  	invoke	wsprintf,addr @szBf,offset szFmt8,[esi].Misc.VirtualSize
  	lea			eax,@szBf
  	mov			@stLVI.pszText,eax
  	inc			@stLVI.iSubItem
  	invoke	SendMessage,hList,LVM_SETITEM,0,addr @stLVI
  	invoke	wsprintf,addr @szBf,offset szFmt8,[esi].VirtualAddress
  	lea			eax,@szBf
  	mov			@stLVI.pszText,eax
  	inc			@stLVI.iSubItem
  	invoke	SendMessage,hList,LVM_SETITEM,0,addr @stLVI
  	invoke	wsprintf,addr @szBf,offset szFmt8,[esi].SizeOfRawData
  	lea			eax,@szBf
  	mov			@stLVI.pszText,eax
  	inc			@stLVI.iSubItem
  	invoke	SendMessage,hList,LVM_SETITEM,0,addr @stLVI
  	invoke	wsprintf,addr @szBf,offset szFmt8,[esi].PointerToRawData
  	lea			eax,@szBf
  	mov			@stLVI.pszText,eax
  	inc			@stLVI.iSubItem
  	invoke	SendMessage,hList,LVM_SETITEM,0,addr @stLVI
  	invoke	wsprintf,addr @szBf,offset szFmt8,[esi].PointerToRelocations
  	lea			eax,@szBf
  	mov			@stLVI.pszText,eax
  	inc			@stLVI.iSubItem
  	invoke	SendMessage,hList,LVM_SETITEM,0,addr @stLVI
  	invoke	wsprintf,addr @szBf,offset szFmt8,[esi].PointerToLinenumbers
  	lea			eax,@szBf
  	mov			@stLVI.pszText,eax
  	inc			@stLVI.iSubItem
  	invoke	SendMessage,hList,LVM_SETITEM,0,addr @stLVI
  	invoke	wsprintf,addr @szBf,offset szFmt4,[esi].NumberOfRelocations
  	lea			eax,@szBf
  	mov			@stLVI.pszText,eax
  	inc			@stLVI.iSubItem
  	invoke	SendMessage,hList,LVM_SETITEM,0,addr @stLVI
  	invoke	wsprintf,addr @szBf,offset szFmt4,[esi].NumberOfLinenumbers
  	lea			eax,@szBf
  	mov			@stLVI.pszText,eax
  	inc			@stLVI.iSubItem
  	invoke	SendMessage,hList,LVM_SETITEM,0,addr @stLVI
  	invoke	wsprintf,addr @szBf,offset szFmt8,[esi].Characteristics
  	lea			eax,@szBf
  	mov			@stLVI.pszText,eax
  	inc			@stLVI.iSubItem
  	invoke	SendMessage,hList,LVM_SETITEM,0,addr @stLVI
  	mov			@stLVI.iSubItem,0
  	add			esi,sizeof IMAGE_SECTION_HEADER
  	inc			@dwCount
  	mov			eax,@dwCount
  	jmp			@B
	@@:
	
	assume		esi:nothing
	
	invoke		SendMessage,hListBox,LB_RESETCONTENT,0,0
	
	push			hChild4
	pop				@stTVIS.hParent
	mov				esi,@lpVMem
	mov				@dwCount,0
	.while		@dwCount < 15
		.if				DWORD PTR [esi]
			mov				eax,DWORD PTR [esi]
			invoke		_RVAToRAW,stFile.lpMem,eax
			mov				ecx,esi
			add				ecx,4
			invoke		wsprintf,addr @szBuf,offset szFmtMisc,DWORD PTR [esi],eax,DWORD PTR [ecx]
			lea				eax,@szBuf
			mov				@stTVIS.item.pszText,eax
			invoke		SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
			mov				ecx,esi
			add				ecx,4
			mov				ecx,DWORD PTR [ecx]
			mov				eax,DWORD PTR [esi]
			invoke		_RVAToRAW,stFile.lpMem,eax
			add				ecx,eax
			.if				@dwCount == 0
					invoke	wsprintf,addr @szBuf,offset szEExport,eax,ecx
			.elseif		@dwCount == 1
					invoke	wsprintf,addr @szBuf,offset szEImport,eax,ecx
			.elseif		@dwCount == 2
					invoke	wsprintf,addr @szBuf,offset szEResource,eax,ecx
			.elseif		@dwCount == 3
					invoke	wsprintf,addr @szBuf,offset szEException,eax,ecx
			.elseif		@dwCount == 4
					invoke	wsprintf,addr @szBuf,offset szESecurity,eax,ecx
			.elseif		@dwCount == 5
					invoke	wsprintf,addr @szBuf,offset szEBaseReloc,eax,ecx
			.elseif		@dwCount == 6
					invoke	wsprintf,addr @szBuf,offset szEDebug,eax,ecx
			.elseif		@dwCount == 7
					invoke	wsprintf,addr @szBuf,offset szEArchitecture,eax,ecx
			.elseif 	@dwCount == 8
					invoke	wsprintf,addr @szBuf,offset szEGlobalptr,eax,ecx
			.elseif   @dwCount == 9
					invoke	wsprintf,addr @szBuf,offset szETLS,eax,ecx
			.elseif		@dwCount == 10
					invoke	wsprintf,addr @szBuf,offset szELoadConfig,eax,ecx
			.elseif		@dwCount == 11
					invoke	wsprintf,addr @szBuf,offset szEBoundImport,eax,ecx
			.elseif   @dwCount == 12
					invoke	wsprintf,addr @szBuf,offset szEIAT,eax,ecx
			.elseif		@dwCount == 13
					invoke	wsprintf,addr @szBuf,offset szEDelayImport,eax,ecx
			.else
					invoke	wsprintf,addr @szBuf,offset szEComDescriptor,eax,ecx
			.endif
			invoke	SendMessage,hListBox,LB_ADDSTRING,0,addr @szBuf
		.endif
		inc				@dwCount
		add				esi,8
	.endw
	
	invoke	_SetRptEdit,0
	invoke	_PE_DETECT
	invoke	_AddText,offset szScanDone,0FF00H
	invoke	MessageBeep,40H
	_Exit:
	.if				@lpVMem
		invoke	VirtualFree,@lpVMem,0,MEM_RELEASE
	.endif
	.if				@hImgList
		invoke		SendMessage,hTree,TVM_SETIMAGELIST,0,@hImgList
	.endif
	pop			fs:[0]
	add			esp,0CH
	invoke	ResetEvent,hEvent
	ret
_ScanPE		endp

_TVProc		proc	uses edi,lParam:DWORD
	LOCAL			@stTVIS:TV_INSERTSTRUCT
	
	lea				edi,@stTVIS
	xor				eax,eax
	mov				ecx,sizeof TV_INSERTSTRUCT
	cld
	rep				stosb
	invoke		SendMessage,hTree,TVM_DELETEITEM,0,TVI_ROOT
	mov				@stTVIS.hParent,0
	mov				@stTVIS.hInsertAfter,TVI_ROOT
	mov				@stTVIS.item.imask,TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
	mov				@stTVIS.item.pszText,offset szImgDosHeader
	mov				@stTVIS.item.iImage,0
	mov				@stTVIS.item.iSelectedImage,1
	mov				@stTVIS.item.cchTextMax,260
	invoke		SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	mov				hChild1,eax
	mov				@stTVIS.item.pszText,offset szImgNtHeaders
	invoke		SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	mov				hChild2,eax
	mov				@stTVIS.item.pszText,offset szImgSecHeader
	invoke		SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	mov				hChild3,eax
	mov				@stTVIS.item.pszText,offset szImgData
	invoke		SendMessage,hTree,TVM_INSERTITEM,0,addr @stTVIS
	mov				hChild4,eax
	ret
_TVProc		endp

_WinMain	proc	uses esi edi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@hIcon:DWORD
		LOCAL		@stLF:LOGFONT
		LOCAL		@stOF:OPENFILENAME
		LOCAL		@szBuf[260]:BYTE
		LOCAL		@szFile[260]:BYTE
		LOCAL		@stPos:POINT
		LOCAL		@iParts[6]:DWORD
		LOCAL   @stTI:TOOLINFO
		LOCAL   @stTTHI:TTHITTESTINFO
	.if			uMsg == WM_CREATE
		push		hWnd
		pop			stFile.hWinMain
		invoke	CreateEvent,0,1,0,offset szEventName
		.if			eax
			mov			hEvent,eax
		.endif
		;;
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsTree,0,WS_VISIBLE or WS_CHILD or WS_BORDER or WS_HSCROLL or WS_VSCROLL or TVS_LINESATROOT or WS_CLIPSIBLINGS or TVS_HASLINES or TVS_HASBUTTONS,\
						0,0,0,0,hWnd,1,stFile.hInstance,0
		.if			eax
			mov			hTree,eax
			invoke  SendMessage,hTree,TVM_SETBKCOLOR,0,0FFFFF2H
			invoke  SendMessage,hTree,TVM_SETEXTENDEDSTYLE,0,TVS_EX_DOUBLEBUFFER
		.endif
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsListV,0,LVS_NOSORTHEADER or WS_VISIBLE or WS_CHILD or WS_HSCROLL or WS_VSCROLL or WS_BORDER or LVS_REPORT or WS_CLIPSIBLINGS,\
						0,0,0,0,hWnd,2,stFile.hInstance,0
		.if			eax
			mov			hList,eax
			invoke  _InitSecDlg,hList
			invoke  SendMessage,hList,LVM_SETBKCOLOR,0,0FFFFF2H
      invoke  SendMessage,hList,LVM_SETTEXTBKCOLOR,0,0FFFFF2H
      invoke	SendMessage,hList,LVM_SETEXTENDEDLISTVIEWSTYLE,0,LVS_EX_FULLROWSELECT or LVS_EX_DOUBLEBUFFER
      invoke	SetWindowLong,hList,GWL_WNDPROC,offset _ListViewProc
      .if			eax
      	mov			lpOldListView,eax
      .endif
		.endif
		invoke	CreateStatusWindow,WS_VISIBLE or WS_CHILD or CCS_BOTTOM or SBARS_SIZEGRIP,0,hWnd,5100
		.if			eax
			mov			hStatus,eax
			mov			@iParts[0],400
			mov			@iParts[4],500
			mov			@iParts[8],630
			mov			@iParts[12],760
			mov			@iParts[16],890
			mov			@iParts[20],-1
			invoke	SendMessage,hStatus,SB_SETPARTS,5,addr @iParts
		.endif
		lea			edi,@stLF
		xor			eax,eax
		mov			ecx,sizeof LOGFONT
		cld
		rep			stosb
		mov			@stLF.lfHeight,-12
		mov			@stLF.lfWeight,500
		invoke	lstrcpy,addr @stLF.lfFaceName,offset szFaceName
		invoke	CreateFontIndirect,addr @stLF
		.if			eax
			mov			stFile.hFont,eax
		.endif
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsButton,offset szOpen,WS_CHILD or WS_VISIBLE or BS_PUSHLIKE,\
						0,0,0,0,hWnd,100,stFile.hInstance,0
		.if			eax
			mov			hButton1,eax
			invoke	SendMessage,eax,WM_SETFONT,stFile.hFont,1
		.endif
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsButton,offset szPlugins,WS_CHILD or WS_VISIBLE or BS_PUSHLIKE,\
						0,0,0,0,hWnd,103,stFile.hInstance,0
		.if			eax
			mov			hButton2,eax
			invoke	SendMessage,eax,WM_SETFONT,stFile.hFont,1
		.endif
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsRichEdit,0,WS_CHILD or WS_VISIBLE or ES_AUTOVSCROLL or ES_AUTOHSCROLL or ES_MULTILINE or WS_HSCROLL or WS_VSCROLL or ES_NOHIDESEL or ES_READONLY,\
						0,0,0,0,hWnd,700,stFile.hInstance,0
		.if			eax
			mov			hEditRpt,eax
			invoke	SendMessage,hEditRpt,WM_SETFONT,stFile.hFont,1
		.endif
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsEdit,0,WS_CHILD or WS_VISIBLE or ES_READONLY or ES_AUTOHSCROLL,\
						0,0,0,0,hWnd,104,stFile.hInstance,0
		.if			eax
			mov			hEdit,eax
			invoke	SendMessage,hEdit,WM_SETFONT,stFile.hFont,1
		.endif
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsEdit,0,WS_CHILD or WS_VISIBLE or ES_READONLY or ES_AUTOHSCROLL,\
						0,0,0,0,hWnd,1001,stFile.hInstance,0
		.if			eax
			mov			hEdit1,eax
			invoke	SendMessage,hEdit1,WM_SETFONT,stFile.hFont,1
		.endif
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsEdit,0,WS_CHILD or WS_VISIBLE or ES_READONLY or ES_AUTOHSCROLL,\
						0,0,0,0,hWnd,105,stFile.hInstance,0
		.if			eax
			mov			hEdit2,eax
			invoke	SendMessage,hEdit2,WM_SETFONT,stFile.hFont,1
		.endif
		invoke	CreateWindowEx,0,offset szClsButton,offset szCheckBox,WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or BS_PUSHBUTTON,\
						0,0,0,0,hWnd,106,stFile.hInstance,0
		.if			eax
			mov			hButton3,eax
			invoke	SendMessage,hButton3,WM_SETFONT,stFile.hFont,1
		.endif
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsButton,offset szExport,WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,\
						0,0,0,0,hWnd,107,stFile.hInstance,0
		.if			eax
			mov			hButton4,eax
			invoke	SendMessage,hButton4,WM_SETFONT,stFile.hFont,1
			invoke	EnableWindow,hButton4,0
		.endif
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsButton,offset szImport,WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON,\
						0,0,0,0,hWnd,108,stFile.hInstance,0
		.if			eax
			mov			hButton5,eax
			invoke	SendMessage,hButton5,WM_SETFONT,stFile.hFont,1
			invoke	EnableWindow,hButton5,0
		.endif
		invoke	CreateWindowEx,WS_EX_STATICEDGE,offset szClsListBox,0,WS_CHILD or WS_VISIBLE or LBS_NOTIFY or WS_CLIPSIBLINGS or WS_VSCROLL or WS_HSCROLL,\
						0,0,0,0,hWnd,109,stFile.hInstance,0
		.if			eax
			mov			hListBox,eax
			invoke	SendMessage,hListBox,WM_SETFONT,stFile.hFont,1
		.endif
		invoke  CreateWindowEx,0,offset szClsTooltip,0,WS_POPUP or TTS_ALWAYSTIP or TTS_BALLOON,\
		        0,0,0,0,hWnd,0,stFile.hInstance,0
		.if     eax
		  mov     stFile.hTooltip,eax
		  invoke  SendMessage,eax,TTM_ACTIVATE,1,0
		  xor     eax,eax
		  mov     ecx,sizeof @stTI
		  lea     edi,@stTI
		  cld
		  rep     stosb
		  mov     @stTI.cbSize,sizeof @stTI
		  mov     @stTI.uFlags,TTF_SUBCLASS or TTF_IDISHWND
		  push    hWnd
		  pop     @stTI.hWnd
		  push    stFile.hInstance
		  pop     @stTI.hInst
		  mov     @stTI.lpszText,LPSTR_TEXTCALLBACK
		  push    hStatus
		  pop     @stTI.uId
		  invoke  SendMessage,stFile.hTooltip,TTM_ADDTOOL,0,addr @stTI
		  push    hButton1
		  pop     @stTI.uId
		  mov     @stTI.lpszText,offset szOpenTooltip
		  invoke  SendMessage,stFile.hTooltip,TTM_ADDTOOL,0,addr @stTI
		  push    hEdit1
		  pop     @stTI.uId
		  mov     @stTI.lpszText,offset szEditTooltip1
		  invoke  SendMessage,stFile.hTooltip,TTM_ADDTOOL,0,addr @stTI
		  push    hEditRpt
		  pop     @stTI.uId
		  mov     @stTI.lpszText,offset szEditTooltip2
		  invoke  SendMessage,stFile.hTooltip,TTM_ADDTOOL,0,addr @stTI
		  push    hListBox
		  pop     @stTI.uId
		  mov     @stTI.lpszText,offset szListBoxTooltip
		  invoke  SendMessage,stFile.hTooltip,TTM_ADDTOOL,0,addr @stTI
		  push    hButton2
		  pop     @stTI.uId
		  mov     @stTI.lpszText,offset szPluginBtTooltip
		  invoke  SendMessage,stFile.hTooltip,TTM_ADDTOOL,0,addr @stTI
		.endif
		;;
		invoke  _GetProfilePath,addr @szBuf
		invoke	GetPrivateProfileInt,offset szApp1,offset szProfilePlgEnabled,0,addr @szBuf
		.if			eax
			invoke	_LoadPlugins,hMenuPlg
			invoke	ShowWindow,hButton2,SW_SHOW
		.else
			invoke	ShowWindow,hButton2,SW_HIDE
		.endif
		;;
		invoke	DragAcceptFiles,hWnd,1
		lea			esi,stFile.szFile
		lodsb
		and			eax,0FFH
		or			eax,eax
		jz			@F
		invoke  _ScanPE,0 ;; filename is already in stFile.szFile
		@@:
		invoke	_InitProc,0
		invoke  _ConstructRecentsMenu,stFile.hMenu
		
	.elseif uMsg == WM_NOTIFY
	  mov     esi,lParam
	  assume  esi:ptr NMHDR
	  mov     eax,[esi].hwndFrom
	  .if     eax == hStatus
	    .if     [esi].code == NM_CLICK
	      ;; reserved for future use.
	    .endif
	  .elseif eax == stFile.hTooltip
	    .if     [esi].code == TTN_NEEDTEXT or TTN_GETDISPINFO
	      mov     edi,lParam
	      assume  edi:ptr TOOLTIPTEXT
	      mov     [edi].lpszText,offset stFile.szFile
	      assume  edi:nothing
	    .endif
	  .endif
	  assume  esi:nothing
	
	.elseif uMsg == WM_SETTEXT ;; FindWindow()...
		.if			wParam == 1234
  		invoke	lstrcpy,offset stFile.szFile,lParam
  		invoke  _ScanPE,0
		.elseif wParam == 1235
			invoke	ShowWindow,hWnd,SW_RESTORE
			invoke	_NotifyIcon,0
		.endif
	
	.elseif uMsg == WM_USER + 1 ;; Shell_NotifyIcon()...
		.if			lParam == WM_LBUTTONDOWN
			invoke	IsWindowVisible,hWnd
			.if			eax
				invoke	ShowWindow,hWnd,SW_HIDE
				invoke	_NotifyIcon,1
			.else
				invoke	ShowWindow,hWnd,SW_RESTORE
				invoke	_NotifyIcon,0
			.endif
		.elseif lParam == WM_RBUTTONDOWN
		  .if     !hMenuTrack
		    invoke  GetMenu,hWnd
		    .if     eax
		      invoke  GetSubMenu,eax,0
		      .if     eax
		        mov     hMenuTrack,eax
		      .endif
		    .endif
		  .endif
			invoke	GetCursorPos,addr @stPos		
      invoke	TrackPopupMenu,hMenuTrack,TPM_LEFTALIGN,@stPos.x,@stPos.y,0,hWnd,0
		.endif
		
	.elseif	uMsg == WM_CLOSE
		___CloseWindow:
		invoke	_WriteProfile
		invoke  _WriteRecentsMenu
		.if			stFile.lpMem
			invoke	_OpenFile,0
		.endif
		;; 
		;; 实际上，这里可以不用释放堆资源和销毁堆，进程的结束也意味着堆资源被操作系统回收。
		;;
		.while	lpCommand && stFile.hHeap
			mov			esi,lpCommand
			assume	esi:PTR PLUGIN
			mov			esi,[esi].lpNext
			assume	esi:nothing
			invoke	HeapFree,stFile.hHeap,0,lpCommand
			mov			lpCommand,esi	
		.endw
		.if			stFile.hHeap
			invoke	HeapDestroy,stFile.hHeap
		.endif
		;;
		;;
		.if			hImgList
			invoke	ImageList_Destroy,hImgList
		.endif
		.if			hEvent
			invoke	CloseHandle,hEvent
		.endif
		invoke	DestroyWindow,hWnd
		invoke	PostQuitMessage,0
		
	.elseif uMsg == WM_SYSCOMMAND
		mov			eax,wParam
		.if			eax == SC_MINIMIZE
			invoke	ShowWindow,hWnd,SW_HIDE
			invoke	_NotifyIcon,1
		.else
			jmp			___@@@DefWindowProc
		.endif
		
	.elseif uMsg == WM_SIZE
		invoke	_ResizeWindow
		
	.elseif	uMsg == WM_DROPFILES
		invoke	DragQueryFile,wParam,0,offset stFile.szFile,sizeof stFile.szFile
		invoke	DragFinish,wParam
		invoke  _ScanPE,0
		
	.elseif uMsg == WM_INITMENU
		.if			stFile.lpMem
			invoke	EnableMenuItem,wParam,110,MF_ENABLED
			invoke	EnableMenuItem,wParam,111,MF_ENABLED
			invoke	EnableMenuItem,wParam,400,MF_ENABLED
			invoke	EnableMenuItem,wParam,403,MF_ENABLED
			invoke	EnableMenuItem,wParam,404,MF_ENABLED
			invoke	EnableMenuItem,wParam,406,MF_ENABLED
		.else
			invoke	EnableMenuItem,wParam,110,MF_DISABLED or MF_GRAYED
			invoke	EnableMenuItem,wParam,111,MF_DISABLED or MF_GRAYED
			invoke	EnableMenuItem,wParam,400,MF_DISABLED or MF_GRAYED
			invoke	EnableMenuItem,wParam,403,MF_DISABLED or MF_GRAYED
			invoke	EnableMenuItem,wParam,404,MF_DISABLED or MF_GRAYED
			invoke	EnableMenuItem,wParam,406,MF_DISABLED or MF_GRAYED
		.endif
		
	.elseif	uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0FFFFH
		.if				eax == 100
  		lea			edi,@stOF
  		mov			ecx,sizeof OPENFILENAME
  		xor			eax,eax
  		cld
  		rep			stosb
  		mov			@stOF.lStructSize,sizeof OPENFILENAME
  		push		hWnd
  		pop			@stOF.hwndOwner
  		push		stFile.hInstance
  		pop			@stOF.hInstance
  		mov			@stOF.lpstrFilter,offset szFilter
  		mov			@stOF.lpstrFile,offset stFile.szFile
  		mov			@stOF.nMaxFile,sizeof stFile.szFile
  		mov			@stOF.Flags,OFN_EXPLORER
  		invoke	GetOpenFileName,addr @stOF
  		.if			eax
	  		invoke  _ScanPE,0
	  	.endif
		.elseif eax == 101 ;; quit
			jmp			___CloseWindow
		.elseif eax == 102 ;; about
			invoke	ShellAbout,stFile.hWinMain,offset szApp,offset szOtherStuff,stFile.hIcon
		.elseif eax == 103 ;; plugins
			invoke  _TrackPopupMenu,hButton2 
		.elseif eax == 106
  		invoke	_GetProfilePath,addr @szFile
  		invoke	IsDlgButtonChecked,hWnd,106
  		.if			eax == BST_CHECKED
  			invoke	SetWindowPos,hWnd,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE
  			mov			eax,1
  		.else
  			invoke	SetWindowPos,hWnd,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE
  			xor			eax,eax
  		.endif
  		invoke	wsprintf,addr @szBuf,offset szFmtL,eax
  		invoke	WritePrivateProfileString,offset szApp1,offset szProfileTopmost,addr @szBuf,addr @szFile
  	.elseif eax == 107
			;; scan export
			invoke	GetExportInfo,stFile.lpMem,stFile.hInstance,101,hWnd,offset stFile.szFile
		.elseif eax == 108
			;; scan import
			invoke	GetTaskorImportInfo,stFile.lpMem,stFile.hInstance,100,hWnd,offset stFile.szFile,0
		.elseif eax == 110
			invoke	_OpenFile,0
		.elseif eax == 111
			.if			stFile.lpMem
				invoke  _ScanPE,0
			.endif
		.elseif eax == 400
			push		eax
			invoke	CreateThread,0,0,offset _ResourceDump,0,0,esp
			add			esp,4
			invoke	CloseHandle,eax
		.elseif eax == 402
			invoke	GetTaskorImportInfo,1,stFile.hInstance,100,stFile.hWinMain,offset stFile.szFile,1
		.elseif eax == 403
			invoke	DialogBoxParam,stFile.hInstance,104,stFile.hWinMain,offset _DisasmProc,0
		.elseif eax == 404
			invoke	DialogBoxParam,stFile.hInstance,105,stFile.hWinMain,offset _R2OProc,0
		.elseif eax == 405
			invoke	DialogBoxParam,stFile.hInstance,103,stFile.hWinMain,offset _TimeCal,0
		.elseif eax == 406
			push		eax
			invoke	CreateThread,0,0,offset _EdPE,0,0,esp
			add			esp,4
			invoke	CloseHandle,eax
		.elseif eax == 407
			invoke	GetModuleFileName,stFile.hInstance,addr @szBuf,sizeof @szBuf
			.if			eax
				invoke	ShellExecute,hWnd,0,addr @szBuf,0,0,SW_SHOW
			.endif
		.elseif	eax == 800
			invoke	DialogBoxParam,stFile.hInstance,112,hWnd,offset _CfgMainDlg,0
		.elseif eax == 5000
			invoke	IsWindowVisible,hWnd
			.if			eax
				invoke	ShowWindow,hWnd,SW_HIDE
				invoke	_NotifyIcon,1
			.else
				invoke	ShowWindow,hWnd,SW_SHOWNORMAL
				invoke	_NotifyIcon,0
			.endif
		.endif
		
		mov			eax,wParam
		shr			eax,16
		and			eax,0FFFFH
		.if			eax == LBN_DBLCLK
			invoke	SendMessage,lParam,LB_GETCURSEL,0,0
			.if			eax != -1
				lea			ecx,@szBuf
				invoke	SendMessage,lParam,LB_GETTEXT,eax,ecx
				lea			esi,@szBuf
				inc			esi
				xor			eax,eax
				lodsb
				push		ecx
				invoke	CreateThread,0,0,offset _HexViewProc,eax,0,esp
				pop			ecx
				invoke	CloseHandle,eax
			.endif
		.endif
		
		lea			eax,stFile.szFile
		mov			eax,DWORD PTR [eax]
		.if			eax
			invoke	_DefCommandDo,hWnd,wParam,lParam
		.endif
		
    invoke  _RespRecentsMenu,hWnd,wParam,lParam
		
	.else
	___@@@DefWindowProc:
		invoke	DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
		
	.endif
	xor			eax,eax
	ret
_WinMain	endp

_ResizeWindow	proc
	LOCAL		@stRc:RECT
	LOCAL		@dwBorder:DWORD
	LOCAL		@dwhg:DWORD

	pushad
	invoke	MoveWindow,hStatus,0,0,0,0,1
	invoke	GetClientRect,hStatus,addr @stRc
	mov			eax,@stRc.bottom
	sub			eax,@stRc.top
	mov			@dwhg,eax
	invoke	GetClientRect,stFile.hWinMain,addr @stRc
	mov			eax,@stRc.bottom
	shr			eax,2
	mov			ecx,@stRc.bottom
	sub			ecx,eax
	mov			esi,@stRc.right
	shr			esi,2
	mov			edi,@stRc.right
	sub			edi,esi
	mov			esi,ecx
	sub			esi,124
	sub			esi,@dwhg
	invoke	MoveWindow,hTree,@stRc.left,@stRc.top,edi,esi,1
	add			edi,2
	mov			eax,@stRc.right
	sub			eax,edi
	invoke	MoveWindow,hListBox,edi,@stRc.top,eax,esi,1
	mov			@dwBorder,esi
	mov			eax,@stRc.top
	add			@dwBorder,eax
	add			@dwBorder,2
	mov			esi,@stRc.bottom
	shr			esi,2
	sub			esi,35
	add			esi,40
	invoke	MoveWindow,hList,@stRc.left,@dwBorder,@stRc.right,esi,1
	add			@dwBorder,esi
	add			@dwBorder,4
	invoke	MoveWindow,hEditRpt,@stRc.left,@dwBorder,@stRc.right,82,1
	add			@dwBorder,88
	;;
	invoke	MoveWindow,hButton1,4,@dwBorder,60,22,1		;;	open
	invoke	MoveWindow,hEdit,68,@dwBorder,120,22,1		;; 	EP Rva
	invoke	MoveWindow,hEdit2,192,@dwBorder,120,22,1	;;	EP Offset
	invoke	MoveWindow,hEdit1,316,@dwBorder,180,22,1	;; 	(Info Edit)
	invoke	MoveWindow,hButton4,500,@dwBorder,60,22,1 ;; 	exports
	invoke	MoveWindow,hButton5,564,@dwBorder,60,22,1 ;; 	imports
	invoke	MoveWindow,hButton3,628,@dwBorder,90,22,1	;;	stay on top
	sub			@stRc.right,29
	invoke	MoveWindow,hButton2,@stRc.right,@dwBorder,22,22,1	;;	plugins ,">"
	;;
	popad
	ret
_ResizeWindow	endp

_NotifyIcon	proc lParam:DWORD
	LOCAL		@stND:NOTIFYICONDATA
	pushad
	xor			eax,eax
	mov			ecx,sizeof @stND
	lea			edi,@stND
	cld
	rep			stosb
	mov			@stND.cbSize,sizeof NOTIFYICONDATA
	push		stFile.hWinMain
	pop			@stND.hWnd
	mov			@stND.uID,345
	mov			@stND.uFlags,NIF_ICON or NIF_TIP or NIF_MESSAGE
	mov			@stND.uCallbackMessage,WM_USER + 1
	push		stFile.hIcon
	pop			@stND.hIcon
	invoke	lstrcpy,addr @stND.szTip,offset szClsName
	.if			lParam
		invoke	Shell_NotifyIcon,NIM_ADD,addr @stND
	.else
		invoke	Shell_NotifyIcon,NIM_DELETE,addr @stND
	.endif
	popad
	ret
_NotifyIcon	endp

Main:
	sub			esp,sizeof INITCOMMONCONTROLSEX
	mov			(INITCOMMONCONTROLSEX ptr [esp]).dwSize,sizeof INITCOMMONCONTROLSEX
	mov			(INITCOMMONCONTROLSEX ptr [esp]).dwICC,ICC_DATE_CLASSES or ICC_BAR_CLASSES or ICC_LISTVIEW_CLASSES or ICC_TREEVIEW_CLASSES
	invoke	InitCommonControlsEx,esp
	add			esp,sizeof INITCOMMONCONTROLSEX
	invoke	GetModuleHandle,0
	mov			stFile.hInstance,eax

	FAKE_ON::
	call		FakeMain
	push		0
	call		_ScanPE
	db			0FFH,24H
	FAKE_OFF::
	
	invoke	GetCommandLine
	mov			esi,eax
	invoke	_SmallMode,esi
	invoke	_RetriveCmdLine,esi,offset stFile.szFile
	lea			esi,stFile.szFile
	xor			eax,eax
	lodsb
	or			eax,eax
	jz			@F
	invoke	_CheckWindowExist
	@@:
	
	invoke	_Init16EditControl,stFile.hInstance,offset sz16EditCls
	invoke	LoadLibrary,offset szRichDll
	pushad
	sub			esp,sizeof WNDCLASSEX
	mov			edi,esp
	mov			esi,esp
	xor			eax,eax
	mov			ecx,sizeof WNDCLASSEX
	cld
	rep			stosb
	mov			[WNDCLASSEX.cbSize + esi],sizeof WNDCLASSEX
	mov			[WNDCLASSEX.style + esi],CS_VREDRAW or CS_HREDRAW
	mov			[WNDCLASSEX.lpfnWndProc + esi],offset _WinMain
	push		stFile.hInstance
	pop			[WNDCLASSEX.hInstance + esi]
	invoke	LoadIcon,stFile.hInstance,100
	.if			eax
		mov			stFile.hIcon,eax
	.else
	  invoke  LoadIcon,0,IDI_INFORMATION
	  mov     stFile.hIcon,eax
	.endif
	push		stFile.hIcon
	pop			[WNDCLASSEX.hIcon + esi]
	invoke	LoadCursor,0,IDC_ARROW
	mov			[WNDCLASSEX.hCursor + esi],eax
	mov			[WNDCLASSEX.hbrBackground + esi],COLOR_BTNFACE + 1
	mov			[WNDCLASSEX.lpszClassName + esi],offset szClsName
	
	invoke	RegisterClassEx,esi

	invoke	CreatePopupMenu
	.if			eax
		mov			hMenuPlg,eax
	.endif
	
	invoke	LoadAccelerators,stFile.hInstance,100
	.if			!eax
		jmp			@@@APP_QUIT
	.endif
	mov			hAccelerator,eax
	
	invoke	CreateWindowEx,0,offset szClsName,offset szClsName,WS_OVERLAPPEDWINDOW,\
					80000000H,80000000H,80000000H,80000000H,0,0,stFile.hInstance,0
	.if			!eax
		jmp			@@@APP_QUIT
	.endif
	mov			stFile.hWinMain,eax
	
	invoke	ShowWindow,stFile.hWinMain,SW_SHOWNORMAL
	invoke	UpdateWindow,stFile.hWinMain
	
	@@:
	invoke	GetMessage,esi,0,0,0
	or			eax,eax
	jz			@@@APP_QUIT
	invoke	TranslateAccelerator,stFile.hWinMain,hAccelerator,esi
	or			eax,eax
	jnz			@B
	invoke	TranslateMessage,esi
	invoke	DispatchMessage,esi
	jmp			@B
	@@@APP_QUIT:
	
	add			esp,sizeof WNDCLASSEX
	popad
	invoke	FreeLibrary,eax
	invoke	ExitProcess,0
	
FakeMain	proc
	pushad
	lea			edi,FAKE_ON
	xor			eax,eax
	mov			al,90H
	lea			ecx,FAKE_OFF
	sub			ecx,edi
	cld
	rep			stosb
	popad
	ret
FakeMain	endp

_SetStatusBar	proc
	LOCAL		@hFile:DWORD
	LOCAL		@buf[260]:BYTE
	LOCAL		@ftC:FILETIME
	LOCAL		@ftA:FILETIME
	LOCAL		@ftW:FILETIME
	LOCAL		@time:SYSTEMTIME
	pushad
	invoke	SendMessage,hStatus,SB_SETTEXT,0,offset stFile.szFile
	invoke	CreateFile,offset stFile.szFile,GENERIC_READ,FILE_SHARE_DELETE,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	.if			eax != -1
		mov			@hFile,eax
		invoke	GetFileSize,@hFile,0
		.if			eax != -1
			invoke	wsprintf,addr @buf,offset szFmtL,eax
			invoke	lstrcat,addr @buf,offset szBytes
			invoke	SendMessage,hStatus,SB_SETTEXT,1,addr @buf
		.endif
		invoke	GetFileTime,@hFile,addr @ftC,addr @ftA,addr @ftW
		.if			eax
			invoke	FileTimeToSystemTime,addr @ftC,addr @time
			.if			eax
				movzx		eax,@time.wMonth
				movzx		ebx,@time.wDay
				movzx		ecx,@time.wYear
				movzx		edx,@time.wHour
				movzx		esi,@time.wMinute
				movzx		edi,@time.wSecond
				invoke	wsprintf,addr @buf,offset szFmtTime1,eax,ebx,ecx,edx,esi,edi
				invoke	SendMessage,hStatus,SB_SETTEXT,2,addr @buf
			.endif
			invoke	FileTimeToSystemTime,addr @ftA,addr @time
			.if			eax
				movzx		eax,@time.wMonth
				movzx		ebx,@time.wDay
				movzx		ecx,@time.wYear
				movzx		edx,@time.wHour
				movzx		esi,@time.wMinute
				movzx		edi,@time.wSecond
				invoke	wsprintf,addr @buf,offset szFmtTime2,eax,ebx,ecx,edx,esi,edi
				invoke	SendMessage,hStatus,SB_SETTEXT,3,addr @buf
			.endif
			invoke	FileTimeToSystemTime,addr @ftW,addr @time
			.if			eax
				movzx		eax,@time.wMonth
				movzx		ebx,@time.wDay
				movzx		ecx,@time.wYear
				movzx		edx,@time.wHour
				movzx		esi,@time.wMinute
				movzx 	edi,@time.wSecond
				invoke	wsprintf,addr @buf,offset szFmtTime3,eax,ebx,ecx,edx,esi,edi
				invoke	SendMessage,hStatus,SB_SETTEXT,4,addr @buf
			.endif
		.endif
		invoke	CloseHandle,@hFile
	.endif
	popad
	ret
_SetStatusBar	endp

_SetRptEdit	proc _lpStr:DWORD
	LOCAL		@buf[260]:BYTE
	LOCAL		@checksum:DWORD
	LOCAL		@md5[16]:BYTE
	LOCAL		@stCf1:CHARFORMAT
	LOCAL		@stCf2:CHARFORMAT
	mov			@stCf1.cbSize,sizeof CHARFORMAT
	mov			@stCf2.cbSize,sizeof CHARFORMAT
	mov			@stCf2.dwMask,CFM_COLOR or CFM_BOLD
	mov			@stCf2.dwEffects,CFE_BOLD
	invoke	SendMessage,hEditRpt,EM_GETCHARFORMAT,0,addr @stCf1
	invoke	SendMessage,hEditRpt,EM_SETSEL,-1,-1
	invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szRet
	.if			_lpStr
		invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,_lpStr
		xor			eax,eax
		ret
	.endif
	.if			!stFile.lpMem
		ret
	.endif
	pushad
	xor			eax,eax
	mov			ecx,260
	lea			edi,@buf
	cld
	rep			stosb
	invoke	_AddText,addr stFile.szFile,00H
	invoke	CheckSumMappedFile,stFile.lpMem,stFile.cbMem,addr @buf,addr @checksum
	.if			eax
		invoke	wsprintf,addr @buf,offset szCheckSum,@checksum
		invoke	_AddText,addr @buf,00H
	.endif
	lea			ecx,@md5
	invoke	MD5_GetCode,stFile.lpMem,stFile.cbMem,ecx
	lea			eax,@md5
	invoke	wsprintf,addr @buf,offset szMD5,DWORD PTR [eax],DWORD PTR [eax+4],DWORD PTR [eax+8],DWORD PTR [eax+12]
	invoke	_AddText,addr @buf,00H
	invoke	GlobalAlloc,GPTR,256*4
	.if			eax
		push		eax
		mov			esi,eax
		invoke	_CreateCrc32Table,esi
		invoke	_GenerateCrc32Value,stFile.lpMem,esi,stFile.cbMem
		invoke	wsprintf,addr @buf,offset szCrc32Fmt,eax
		invoke	_AddText,addr @buf,00H
		pop			eax
		invoke	GlobalFree,eax
	.endif
	mov			esi,stFile.lpMem
	assume	esi:PTR IMAGE_DOS_HEADER
	.if			[esi].e_magic == 'ZM'
		add			esi,[esi].e_lfanew
		assume	esi:PTR IMAGE_NT_HEADERS
		.if			[esi].Signature == 'EP'
			movzx		eax,[esi].FileHeader.Machine
			.IF			eax == 1D3H
				mov			eax,offset szMachine1d3
			.elseif	eax == 8664H
				mov			eax,offset szMachine8664
			.elseif eax == 1C0H
				mov			eax,offset szMachine1c0
			.elseif eax == 1C4H
				mov			eax,offset szMachine1c4
			.ELSEIF EAX == 0AA64H
				mov			eax,offset szMachineaa64
			.ELSEIF EAX == 0EBCH
				mov			eax,offset szMachineebc
			.ELSEIF EAX == 14CH
				mov			eax,offset szMachine14c
			.ELSEIF EAX == 200H
				mov			eax,offset szMachine200
			.ELSEIF EAX == 9041H
				mov			eax,offset szMachine9041
			.ELSEIF EAX == 266H
				mov			eax,offset szMachine266
			.ELSEIF EAX == 366H
				mov			eax,offset szMachine366
			.ELSEIF EAX == 466H
				mov			eax,offset szMachine466
			.ELSEIF EAX == 1F0H
				mov			eax,offset szMachine1f0
			.ELSEIF EAX == 1F1H
				mov			eax,offset szMachine1f1
			.ELSEIF EAX == 166H
				mov			eax,offset szMachine166
			.ELSEIF EAX == 1A2H
				mov			eax,offset szMachine1a2
			.ELSEIF EAX == 1A3H
				mov			eax,offset szMachine1a3
			.ELSEIF EAX == 1A6H
				mov			eax,offset szMachine1a6
			.ELSEIF EAX == 1A8H
				mov			eax,offset szMachine1a8
			.ELSEIF EAX == 1C2H
				mov			eax,offset szMachine1c2
			.ELSEIF EAX == 169H
				mov			eax,offset szMachine169
			.ELSE
				mov			eax,offset szMachine00
			.ENDIF
			invoke	wsprintf,addr @buf,offset szMachineIs,eax
			invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,addr @buf
			invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szRet
			invoke	_GetRVAName,stFile.lpMem,[esi].OptionalHeader.AddressOfEntryPoint
			.if			eax
				push		eax
				invoke	wsprintf,addr @buf,offset szEPName,eax
				pop			eax
				invoke	GlobalFree,eax
				mov			@stCf2.crTextColor,0FF0000H
				invoke	SendMessage,hEditRpt,EM_SETCHARFORMAT,SCF_SELECTION or SCF_WORD,addr @stCf2
				invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,addr @buf
				invoke	SendMessage,hEditRpt,EM_SETCHARFORMAT,SCF_SELECTION or SCF_WORD,addr @stCf1
				invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szRet
			.endif
			movzx		eax,[esi].OptionalHeader.Subsystem
			.IF 		EAX == 01
				mov			eax,offset szSubsystemNative
			.ELSEIF EAX == 02
				mov			eax,offset szSubsystemWinGUI
			.ELSEIF EAX == 03
				mov			eax,offset szSubsystemWinCUI
			.ELSEIF EAX == 07
				mov			eax,offset szSubsystemPOSIXCUI
			.ELSEIF EAX == 09
				mov			eax,offset szSubsystemWinCE
			.ELSEIF EAX == 10
				mov			eax,offset szSubsystemEFIApp
			.ELSEIF EAX == 11
				mov			eax,offset szSubsystemEFIBoot
			.ELSEIF EAX == 12
				mov			eax,offset szSubsystemEFIRunt
			.ELSEIF EAX == 13
				mov			eax,offset szSubsystemEFIRom
			.ELSEIF EAX == 14
				mov			eax,offset szSubsystemXbox
			.ELSE
				mov			eax,offset szSubsystemUnknown
			.ENDIF
			invoke	wsprintf,addr @buf,offset szSubsystemIs,eax
			invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,addr @buf
			invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szRet
			mov			al,[esi].OptionalHeader.MajorLinkerVersion
			and			eax,0FFH
			mov			cl,[esi].OptionalHeader.MinorLinkerVersion
			and			ecx,0FFH
			invoke	wsprintf,addr @buf,offset szLinkerVersionIs,eax,ecx
			invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,addr @buf
			invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szRet
			mov			eax,[esi].OptionalHeader.AddressOfEntryPoint
			invoke	_RVAToRAW,stFile.lpMem,eax
			.if			eax
				add			eax,stFile.lpMem
				sub			esp,120
  			mov			edi,esp
  			mov			ecx,32
  			push		edi
  			@@:
  			push		eax
  			push		ecx
  			movzx		eax,BYTE PTR [eax]
  			invoke	wsprintf,edi,offset szFmt2,eax
  			add			edi,eax
  			pop			ecx
  			pop			eax
  			inc			eax
  			loop		@B
  			pop			edi
  			invoke	wsprintf,addr @buf,offset szFirstBytes,edi
  			invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,addr @buf
  			invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szRet
  			add			esp,120
			.endif
		.else
			mov			@stCf2.crTextColor,0FFH
			invoke	SendMessage,hEditRpt,EM_SETCHARFORMAT,SCF_SELECTION or SCF_WORD,addr @stCf2
			invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szNoPE
			invoke	SendMessage,hEditRpt,EM_SETCHARFORMAT,SCF_SELECTION or SCF_WORD,addr @stCf1
			invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szRet
		.endif
	.else
		mov			@stCf2.crTextColor,0FFH
		invoke	SendMessage,hEditRpt,EM_SETCHARFORMAT,SCF_SELECTION or SCF_WORD,addr @stCf2
		invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szNoDos
		invoke	SendMessage,hEditRpt,EM_SETCHARFORMAT,SCF_SELECTION or SCF_WORD,addr @stCf1
		invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szRet
	.endif
	invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,offset szDiv
	assume	esi:nothing
	popad
	ret
_SetRptEdit	endp

_CheckWindowExist	proc
	LOCAL		@hWnd:DWORD
	invoke	FindWindow,offset szClsName,offset szClsName
	.if			eax
		mov			@hWnd,eax
		invoke	IsWindowVisible,@hWnd
		.if			!eax
			invoke	SendMessage,@hWnd,WM_SETTEXT,1235,0
		.endif
		invoke	SendMessage,@hWnd,WM_SETTEXT,1234,offset stFile.szFile
		invoke	ExitProcess,0
	.endif
	ret
_CheckWindowExist	endp

_ListViewProc	proc uses edi esi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@stPos:POINT
		LOCAL		@stLi:LV_ITEM
		LOCAL		@szBuf[MAX_PATH]:BYTE
		LOCAL		@stOf:OPENFILENAME
		LOCAL		@hMod:DWORD
		LOCAL		@stHE:HE_SETTINGS
		LOCAL		@lpHESpecifySettings:DWORD
		LOCAL		@lpHEEnterWindowLoop:DWORD
	.if			uMsg == WM_RBUTTONDOWN
	  lea     edi,__TrackPopMenu
	  .if     !DWORD PTR [edi]
		  invoke	CreatePopupMenu
		  .if			eax
  		  mov     DWORD PTR [edi],eax
  			lea			eax,__Txt1
  			invoke	AppendMenu,DWORD PTR [edi],MF_STRING,1000,eax
  			invoke	AppendMenu,DWORD PTR [edi],MF_SEPARATOR,0,0
  			lea			eax,__Txt2
  			invoke	AppendMenu,DWORD PTR [edi],MF_STRING,1001,eax
  			lea			eax,__Txt3
  			invoke	AppendMenu,DWORD PTR [edi],MF_STRING,1002,eax
  		.endif
		.else
		  invoke	SendMessage,hWnd,LVM_GETSELECTEDCOUNT,0,0
			.if			eax
				invoke	GetCursorPos,addr @stPos
				.if			eax
					invoke	TrackPopupMenu,DWORD PTR [edi],TPM_LEFTALIGN,@stPos.x,@stPos.y,0,hWnd,0
				.endif
			.endif
		.endif
		xor			eax,eax
		ret
		__TrackPopMenu:
		dd      0
		__Txt1:
		db			'&Hex',0
		__Txt2:
		db			'&Disassemble',0
		__Txt3:
		db			'&Raw Dump',0
		
	.elseif	uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0FFFFH
		.if 			eax == 1000 || eax == 1001 || eax == 1002
			mov			@stPos.x,0
			mov			@stPos.y,0
			invoke	SendMessage,hWnd,LVM_GETITEMCOUNT,0,0
			.if			eax
				mov			ecx,eax
				@@:
				push		ecx
				dec			ecx
				mov			esi,ecx
				invoke	SendMessage,hWnd,LVM_GETITEMSTATE,esi,LVIS_SELECTED
				.if			eax == LVIS_SELECTED
					mov			@stLi.imask,LVIF_TEXT
					mov			@stLi.iItem,esi
					mov			@stLi.iSubItem,4
					mov			@stLi.cchTextMax,MAX_PATH
					lea			eax,@szBuf
					mov			@stLi.pszText,eax
					__back_get_item:
					invoke	SendMessage,hWnd,LVM_GETITEM,0,addr @stLi
					.if			eax
						invoke	_Ascii2Dword16,addr @szBuf
						.if			!@stPos.x
							mov			@stPos.x,eax
						.else
							mov			@stPos.y,eax
						.endif
						dec			@stLi.iSubItem
						.if			!@stPos.y
							jmp			__back_get_item
						.endif
					.endif
				.endif
				pop			ecx
				loop		@B
				mov			eax,wParam
				and			eax,0FFFFH
				.if			eax == 1000
					mov			@hMod,0
					invoke	LoadLibrary,offset sz16Edit
					.if			!eax
						invoke	SendMessage,hEdit1,WM_SETTEXT,0,offset sz16EditMissed
						jmp			@F
					.endif
					mov			@hMod,eax
					invoke	GetProcAddress,@hMod,offset szHESpecifySettings
					.if			!eax
						jmp			@F
					.endif
					mov			@lpHESpecifySettings,eax
					invoke	GetProcAddress,@hMod,offset szHEEnterWindowLoop
					.if			!eax
						jmp			@F
					.endif
					mov			@lpHEEnterWindowLoop,eax
					xor			eax,eax
					mov			ecx,sizeof @stHE
					lea			edi,@stHE
					cld
					rep			stosb
					mov			@stHE.dwMask,08H or 100H or 80H or 40H
					push		@stPos.x
					pop			@stHE.dwSelStart
					mov			eax,@stPos.x
					add			eax,@stPos.y
					dec			eax
					mov			@stHE.dwSelEnd,eax
					push		stFile.hWinMain
					pop			@stHE.hParent
					push		stFile.lpMem
					pop			@stHE.diMem.lpBuffer
					mov			eax,@stPos.x
					add			eax,@stPos.y
					mov			@stHE.diMem.dwSize,eax
					mov			@stHE.diMem.dwIsReadOnly,1
					lea			eax,@stHE
					push		eax
					call		@lpHESpecifySettings
					call		@lpHEEnterWindowLoop
					@@:
					.if			@hMod
						invoke	FreeLibrary,@hMod
					.endif
				.elseif eax == 1001
					invoke	DialogBoxParam,stFile.hInstance,104,stFile.hWinMain,offset _DisasmProc,addr @stPos
				.elseif eax == 1002
					xor			eax,eax
					lea			edi,@stOf
					mov			ecx,sizeof @stOf
					cld
					rep			stosb
					mov			ecx,MAX_PATH
					lea			edi,@szBuf
					cld
					rep			stosb
					mov			@stOf.lStructSize,sizeof @stOf
					push		hWnd
					pop			@stOf.hwndOwner
					push		stFile.hInstance
					pop			@stOf.hInstance
					mov			@stOf.lpstrFilter,offset szFilter
					lea			eax,@szBuf
					mov			@stOf.lpstrFile,eax
					mov			@stOf.nMaxFile,MAX_PATH
					mov			@stOf.Flags,OFN_EXPLORER
					invoke	GetSaveFileName,addr @stOf
					.if			eax
						invoke	CreateFile,addr @szBuf,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
						.if			eax != -1
							push		eax
							mov			ecx,eax
							mov			esi,stFile.lpMem
							add			esi,@stPos.x
							invoke	WriteFile,ecx,esi,@stPos.y,addr @szBuf,0
							pop			eax
							invoke	CloseHandle,eax
						.endif
					.endif
				.endif
			.endif
		.endif
		jmp			@F
	.else
		@@:
		invoke	CallWindowProc,lpOldListView,hWnd,uMsg,wParam,lParam
		ret
	.endif
	xor			eax,eax
	ret
_ListViewProc	endp

_CfgMainDlg	proc	uses esi edi ebx,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@szBuf[260]:BYTE
		LOCAL   @stSHFOS:SHFILEOPSTRUCT
	.if			uMsg == WM_INITDIALOG
		invoke	SendMessage,hWnd,WM_SETICON,ICON_BIG,stFile.hIcon
		invoke  _GetProfilePath,addr @szBuf
		invoke	GetPrivateProfileInt,offset szApp1,offset szProfilePlgEnabled,0,addr @szBuf
		.if			eax
			mov			eax,BST_CHECKED
		.else
			mov			eax,BST_UNCHECKED
		.endif
		invoke	CheckDlgButton,hWnd,100,eax
		invoke	GetPrivateProfileInt,offset szApp1,offset szProfileLEI,0,addr @szBuf
		.if			eax
			mov			eax,BST_CHECKED
		.else
			mov			eax,BST_UNCHECKED
		.endif
		invoke	CheckDlgButton,hWnd,101,eax
		invoke	GetPrivateProfileInt,offset szApp1,offset szProfileRecents,0,addr @szBuf
		.if			eax
			mov			eax,BST_CHECKED
		.else
			mov			eax,BST_UNCHECKED
		.endif
		invoke	CheckDlgButton,hWnd,102,eax
	.elseif	uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0FFFFH
		.if			eax == 1
			invoke	IsDlgButtonChecked,hWnd,100 ;;  enable plugins
			.if			eax & BST_CHECKED
				push		31H
			.else
				push		30H
			.endif
			invoke  _GetProfilePath,addr @szBuf
			mov			ecx,esp
			invoke	WritePrivateProfileString,offset szApp1,offset szProfilePlgEnabled,ecx,addr @szBuf
			add			esp,4
			invoke	IsDlgButtonChecked,hWnd,101 ;;  enable log exports/imports
			.if			eax & BST_CHECKED
				push    31H
			.else
				push    30H
			.endif
			mov     ecx,esp
		  invoke	WritePrivateProfileString,offset szApp1,offset szProfileLEI,ecx,addr @szBuf
		  add     esp,4
		  invoke  IsDlgButtonChecked,hWnd,102 ;;  enable recent files
		  .if     eax & BST_CHECKED
		    push    31H
		  .else
		    push    30H
		  .endif
		  mov     ecx,esp
		  invoke  WritePrivateProfileString,offset szApp1,offset szProfileRecents,ecx,addr @szBuf
		  add     esp,4
			jmp			@F
		.elseif eax == 2
			jmp			@F
		.elseif eax == 103 ;; delete configure files
		  push    '?KO'
		  mov     ecx,esp
		  invoke  MessageBox,hWnd,offset szMsgDelCfgFiles,ecx,MB_OKCANCEL or 030H
		  add     esp,4
		  .if     eax == IDOK
		    invoke  _GetProfilePath,addr @szBuf
		    pushf
		    invoke  lstrlen,addr @szBuf
		    lea     edi,@szBuf
		    add     edi,eax
		    mov     ecx,eax
		    mov     eax,'\'
		    std
		    repnz   scasb
		    mov     WORD PTR [edi + 1],0 ;; double NULL indicate end of buffer
		    popf
		    mov     ecx,sizeof @stSHFOS
  		  lea     edi,@stSHFOS
  		  xor     eax,eax
  		  cld
  		  rep     stosb
  		  push    hWnd
  		  pop     @stSHFOS.hwnd
  		  mov     @stSHFOS.wFunc,FO_DELETE
  		  lea     eax,@szBuf
  		  mov     @stSHFOS.pFrom,eax
  		  mov     @stSHFOS.fFlags,FOF_ALLOWUNDO or FOF_FILESONLY or FOF_SIMPLEPROGRESS
  		  mov     @stSHFOS.lpszProgressTitle,offset szProgressTitle
  		  invoke  SHFileOperation,addr @stSHFOS
  		  push    '?KO'
  		  mov     ecx,esp
  		  invoke  MessageBox,hWnd,offset szMsgCloseWindow,ecx,MB_OKCANCEL
  		  add     esp,4
  		  .if     eax == IDOK
  		    invoke  ExitProcess,0
  		  .endif
		  .endif
		.endif
	.elseif uMsg == WM_CLOSE
		@@:
		invoke	EndDialog,hWnd,0
	.else
		xor			eax,eax
		ret
	.endif
	or			eax,1
	ret
_CfgMainDlg	endp

_AddText	proc	_lpStr:DWORD,_crColor:DWORD
	LOCAL		@stCf1:CHARFORMAT
	LOCAL		@stCf2:CHARFORMAT
	pushad
	mov			@stCf1.cbSize,sizeof @stCf1
	mov			@stCf2.cbSize,sizeof @stCf2
	invoke	SendMessage,hEditRpt,EM_GETCHARFORMAT,0,addr @stCf2
	invoke	SendMessage,hEditRpt,EM_SETSEL,-1,-1
	mov			@stCf1.dwMask,CFM_COLOR
	push		_crColor
	pop			@stCf1.crTextColor
	invoke	SendMessage,hEditRpt,EM_SETCHARFORMAT,SCF_WORD or SCF_SELECTION,addr @stCf1
	invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,_lpStr
	push		0AH
	invoke	SendMessage,hEditRpt,EM_REPLACESEL,0,esp
	add			esp,4
	invoke	SendMessage,hEditRpt,EM_SETCHARFORMAT,SCF_WORD or SCF_SELECTION,addr @stCf2
	invoke	SendMessage,hEditRpt,EM_SETSEL,-1,-1
	popad
	ret
_AddText	endp

;#######################################

Include			profiledo.asm
Include			loadplugins.asm
Include			objscan.asm
Include			resdump.asm
Include			edpe.asm
Include			crc32.asm
Include			smlmod.asm
Include     16editcontrol.asm
Include     ascii2dword16.asm
Include     retrivecmdln.asm
Include     disasm.asm

Include			exportsfun.asm

;#######################################

_GetAppObjInfo proc  lParam:DWORD
  mov     eax,lParam
  .if     eax == 1
    mov     eax,stFile.hInstance
  .elseif eax == 2
    mov     eax,stFile.hImageList
  .elseif eax == 4
    mov     eax,stFile.hMenu
  .elseif eax == 8
    mov     eax,stFile.hIcon
  .elseif eax == 16
    mov     eax,offset stFile.szFile
  .elseif eax == 32
    mov     eax,stFile.hTooltip
  .elseif eax == 64
    mov     eax,stFile.hFont
  .elseif eax == 128
    mov     eax,stFile.hWinMain
  .endif
  ret
_GetAppObjInfo endp

End	Main

