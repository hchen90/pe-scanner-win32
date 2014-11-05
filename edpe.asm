_CharacteristicsDlg	proc	uses esi edi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@szBuf[260]:BYTE
	.if			uMsg == WM_INITDIALOG
		sub			stFile.lpMem,0
		jz			@F
		invoke	SetWindowLong,hWnd,GWL_USERDATA,lParam
		invoke	wsprintf,addr @szBuf,offset szFmt4,lParam
		invoke	SendDlgItemMessage,hWnd,1022,WM_SETTEXT,0,addr @szBuf
		mov			edi,lParam
		.if			edi & 01H
			invoke	CheckDlgButton,hWnd,1000,BST_CHECKED
		.endif
		.if			edi & 02H
			invoke	CheckDlgButton,hWnd,1001,BST_CHECKED
		.endif
		.if			edi & 04H
			invoke	CheckDlgButton,hWnd,1002,BST_CHECKED
		.endif
		.if			edi & 08H
			invoke	CheckDlgButton,hWnd,1003,BST_CHECKED
		.endif
		.if			edi & 010H
			invoke	CheckDlgButton,hWnd,1004,BST_CHECKED
		.endif
		.if			edi & 020H
			invoke	CheckDlgButton,hWnd,1006,BST_CHECKED
		.endif
		.if			edi & 040H
			invoke	CheckDlgButton,hWnd,1007,BST_CHECKED
		.endif
		.if			edi & 080H
			invoke	CheckDlgButton,hWnd,1005,BST_CHECKED
		.endif
		.if			edi & 0100H
			invoke	CheckDlgButton,hWnd,1013,BST_CHECKED
		.endif
		.if			edi & 0200H
			invoke	CheckDlgButton,hWnd,1008,BST_CHECKED
		.endif
		.if			edi & 0400H
			invoke	CheckDlgButton,hWnd,1009,BST_CHECKED
		.endif
		.if			edi & 0800H
			invoke	CheckDlgButton,hWnd,1014,BST_CHECKED
		.endif
		.if			edi & 01000H
			invoke	CheckDlgButton,hWnd,1010,BST_CHECKED
		.endif
		.if			edi & 02000H
			invoke	CheckDlgButton,hWnd,1011,BST_CHECKED
		.endif
		.if			edi & 04000H
			invoke	CheckDlgButton,hWnd,1012,BST_CHECKED
		.endif
		.if			edi & 08000H
			invoke	CheckDlgButton,hWnd,1015,BST_CHECKED
		.endif
	.elseif	uMsg == WM_CLOSE
		mov			eax,-1
		@@:
		invoke	EndDialog,hWnd,eax
	.elseif uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0ffffh
		.if			eax == 1020
			invoke	GetWindowLong,hWnd,GWL_USERDATA
			jmp			@B
		.elseif eax == 1021
			mov			eax,-1
			jmp			@B
		.elseif eax > 999 && eax < 1016
			.if			eax == 1000
				mov			edi,01h
			.elseif eax == 1001
				mov			edi,02H
			.elseif eax == 1002
				mov			edi,04H
			.elseif eax == 1003
				mov			edi,08H
			.elseif eax == 1004
				mov			edi,010H
			.elseif eax == 1005
				mov			edi,080H
			.elseif eax == 1006
				mov			edi,020H
			.elseif eax == 1007
				mov			edi,040H
			.elseif eax == 1008
				mov			edi,0200H
			.elseif eax == 1009
				mov			edi,0400H
			.elseif eax == 1010
				mov			edi,01000H
			.elseif eax == 1011
				mov			edi,02000H
			.elseif eax == 1012
				mov			edi,04000H
			.elseif eax == 1013
				mov			edi,0100H
			.elseif eax == 1014
				mov			edi,0800H
			.elseif eax == 1015
				mov			edi,08000H
			.endif
			mov			esi,eax
			invoke	GetWindowLong,hWnd,GWL_USERDATA
			push		eax
			invoke	IsDlgButtonChecked,hWnd,esi
			mov			esi,eax
			pop			eax
			.if			esi == BST_CHECKED
				add			eax,edi
			.else
				sub			eax,edi
			.endif
			mov			esi,eax
			invoke	SetWindowLong,hWnd,GWL_USERDATA,eax
			invoke	wsprintf,addr @szBuf,offset szFmt4,esi
			invoke	SendDlgItemMessage,hWnd,1022,WM_SETTEXT,0,addr @szBuf
		.endif
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_CharacteristicsDlg	endp

_DllCharacteristicsDlg	proc	uses edi esi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@szBuf[260]:BYTE
	.if			uMsg == WM_INITDIALOG
		sub			stFile.lpMem,0
		jz			@F
		invoke	SetWindowLong,hWnd,GWL_USERDATA,lParam
		invoke	wsprintf,addr @szBuf,offset szFmt4,lParam
		invoke	SendDlgItemMessage,hWnd,1002,WM_SETTEXT,0,addr @szBuf
		mov			edi,lParam
		.if			edi & 01H
			invoke	CheckDlgButton,hWnd,1149,BST_CHECKED
		.endif
		.if			edi & 02H
			invoke	CheckDlgButton,hWnd,1150,BST_CHECKED
		.endif
		.if			edi & 04H
			invoke	CheckDlgButton,hWnd,1151,BST_CHECKED
		.endif
		.if			edi & 08H
			invoke	CheckDlgButton,hWnd,1152,BST_CHECKED
		.endif
		.if			edi & 040H
			invoke	CheckDlgButton,hWnd,1153,BST_CHECKED
		.endif
		.if			edi & 080H
			invoke	CheckDlgButton,hWnd,1154,BST_CHECKED
		.endif
		.if			edi & 0100H
			invoke	CheckDlgButton,hWnd,1155,BST_CHECKED
		.endif
		.if			edi & 0200H
			invoke	CheckDlgButton,hWnd,1156,BST_CHECKED
		.endif
		.if			edi & 0400H
			invoke	CheckDlgButton,hWnd,1157,BST_CHECKED
		.endif
		.if			edi & 0800H
			invoke	CheckDlgButton,hWnd,1158,BST_CHECKED
		.endif
		.if			edi & 01000H
			invoke	CheckDlgButton,hWnd,1159,BST_CHECKED
		.endif
		.if			edi & 02000H
			invoke	CheckDlgButton,hWnd,1160,BST_CHECKED
		.endif
		.if			edi & 08000H
			invoke	CheckDlgButton,hWnd,1161,BST_CHECKED
		.endif
	.elseif	uMsg == WM_CLOSE
		mov			eax,-1
		@@:
		invoke	EndDialog,hWnd,eax
	.elseif uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0ffffh
		.if			eax == 1000
			invoke	GetWindowLong,hWnd,GWL_USERDATA
			jmp			@B
		.elseif eax == 1001
			mov			eax,-1
			jmp			@B
		.elseif	eax > 1148 && eax < 1162
			.if			eax == 1149
				mov			edi,01h
			.elseif	eax == 1150
				mov			edi,02h
			.elseif eax == 1151
				mov			edi,04h
			.elseif eax == 1152
				mov			edi,08h
			.elseif eax == 1153
				mov			edi,040h
			.elseif eax == 1154
				mov			edi,080h
			.elseif eax == 1155
				mov			edi,0100h
			.elseif eax == 1156
				mov			edi,0200h
			.elseif eax == 1157
				mov			edi,0400h
			.elseif eax == 1158
				mov			edi,0800h
			.elseif eax == 1159
				mov			edi,01000h
			.elseif eax == 1160
				mov			edi,02000h
			.elseif eax == 1161
				mov			edi,08000h
			.endif
			mov			esi,eax
			invoke	GetWindowLong,hWnd,GWL_USERDATA
			push		eax
			invoke	IsDlgButtonChecked,hWnd,esi
			mov			esi,eax
			pop			eax
			.if			esi == BST_CHECKED
				add			eax,edi
			.else
				sub			eax,edi
			.endif
			mov			esi,eax
			invoke	SetWindowLong,hWnd,GWL_USERDATA,eax
			invoke	wsprintf,addr @szBuf,offset szFmt4,esi
			invoke	SendDlgItemMessage,hWnd,1002,WM_SETTEXT,0,addr @szBuf
		.endif
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_DllCharacteristicsDlg	endp

_MachineTypeDlg	proc	uses esi edi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@szBuf[260]:BYTE
	.if			uMsg == WM_INITDIALOG
		invoke	SetWindowLong,hWnd,GWL_USERDATA,lParam
		invoke	wsprintf,addr @szBuf,offset szFmt4,lParam
		invoke	SendDlgItemMessage,hWnd,1000,WM_SETTEXT,0,addr @szBuf
		invoke	GetDlgItem,hWnd,1001
		.if			eax
			mov			edi,eax
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine00
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine1d3
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine8664
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine1c0
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine1c4
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachineaa64
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachineebc
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine14c
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine200
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine9041
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine266
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine366
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine466
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine1f0
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine1f1
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine166
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine1a2
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine1a3
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine1a6
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine1a8
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine1c2
			invoke	SendMessage,edi,LB_INSERTSTRING,-1,offset szMachine169
		.endif
	.elseif	uMsg == WM_CLOSE
		mov			eax,-1
		@@:
		invoke	EndDialog,hWnd,eax
	.elseif uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0ffffh
		.if			eax == IDOK
			invoke	GetWindowLong,hWnd,GWL_USERDATA
			jmp			@B
		.elseif eax == IDCANCEL
			mov			eax,-1
			jmp			@B
		.elseif eax == 1001
			invoke	SendMessage,lParam,LB_GETCURSEL,0,0
			.if			eax != -1
				.if			eax == 1
					mov			eax,01D3H
				.elseif eax == 2
					mov			eax,8664H
				.elseif	eax == 3
					mov			eax,01C0H
				.elseif eax == 4
					mov			eax,01C4H
				.elseif eax == 5
					mov			eax,0AA64H
				.elseif eax == 6
					mov			eax,0EBCH
				.elseif eax == 7
					mov			eax,014CH
				.elseif eax == 8
					mov			eax,0200H
				.elseif eax == 9
					mov			eax,9041H
				.elseif eax == 10
					mov			eax,266H
				.elseif eax == 11
					mov			eax,366H
				.elseif eax == 12
					mov			eax,466H
				.elseif eax == 13
					mov			eax,01F0H
				.elseif eax == 14
					mov			eax,01F1H
				.elseif eax == 15
					mov			eax,166H
				.elseif eax == 16
					mov			eax,1A2H
				.elseif eax == 17
					mov			eax,1A3H
				.elseif eax == 18
					mov			eax,1A6H
				.elseif eax == 19
					mov			eax,1A8H
				.elseif eax == 20
					mov			eax,1C2H
				.elseif eax == 21
					mov			eax,0169H
				.else
					xor			eax,eax
				.endif
				push		eax
				invoke	wsprintf,addr @szBuf,offset szFmt4,eax
				invoke	SendDlgItemMessage,hWnd,1000,WM_SETTEXT,0,addr @szBuf
				pop			eax
				invoke	SetWindowLong,hWnd,GWL_USERDATA,eax
			.endif
		.endif
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_MachineTypeDlg	endp

_SubsystemDlg	proc	uses esi edi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	LOCAL		@szBuf[260]:BYTE
	.if			uMsg == WM_INITDIALOG
		sub			stFile.lpMem,0
		jz			@F
		invoke	SetWindowLong,hWnd,GWL_USERDATA,lParam
		invoke	wsprintf,addr @szBuf,offset szFmt4,lParam
		invoke	SendDlgItemMessage,hWnd,1132,WM_SETTEXT,0,addr @szBuf
	.elseif uMsg == WM_CLOSE
		mov			eax,-1
		@@:
		invoke	EndDialog,hWnd,eax
	.elseif uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0ffffh
		.if			eax == 1131
			mov			eax,-1
			jmp			@B
		.elseif	eax == 1130
			invoke	GetWindowLong,hWnd,GWL_USERDATA
			jmp			@B
		.elseif eax > 1133 && eax < 1138
			sub			eax,1134
			invoke	SetWindowLong,hWnd,GWL_USERDATA,eax
		.elseif eax == 1138
			invoke	SetWindowLong,hWnd,GWL_USERDATA,7
		.elseif eax > 1138 && eax < 1145
			sub			eax,1139
			add			eax,9
			invoke	SetWindowLong,hWnd,GWL_USERDATA,eax
		.endif
		invoke	GetWindowLong,hWnd,GWL_USERDATA
		invoke	wsprintf,addr @szBuf,offset szFmt4,eax
		invoke	SendDlgItemMessage,hWnd,1132,WM_SETTEXT,0,addr @szBuf
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_SubsystemDlg	endp

_DirectoriesDlg	proc	uses esi edi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
		LOCAL		@szBuf[MAX_PATH]:BYTE
		LOCAL		@hFile:DWORD
		LOCAL		@hFileMap:DWORD
		LOCAL		@lpMem:DWORD
	.if			uMsg == WM_INITDIALOG
		push		ebp
		push		offset @F
		push		offset _SEH
		push		fs:[0]
		mov			fs:[0],esp
		mov			esi,stFile.lpMem
		mov			ax,WORD PTR [esi]
		sub			ax,'ZM'
		jnz			@F
		add			esi,[esi+3CH]
		mov			eax,DWORD PTR [esi]
		sub			eax,'EP'
		jnz			@F
		add			esi,4
		add			esi,sizeof IMAGE_FILE_HEADER
		mov			ax,WORD PTR [esi]
		.if			ax == 020BH
			add			esi,112
		.else
			add			esi,96
		.endif
		mov			edi,2800
		mov			ecx,32
		___dir_loop:
		push		ecx
		xor			eax,eax
		cld
		lodsd
		push		eax
		invoke	wsprintf,addr @szBuf,offset szFmt8,eax
		invoke	SendDlgItemMessage,hWnd,edi,WM_SETTEXT,0,addr @szBuf
		invoke	GetDlgItem,hWnd,edi
		pop			ecx
		invoke	SetWindowLong,eax,GWL_USERDATA,ecx
		pop			ecx
		inc			edi
		loop		___dir_loop
		@@:
		pop			fs:[0]
		add			esp,12
		invoke  _InitCharDlgProtBt,hWnd,stFile.lpMem
		
	.elseif uMsg == WM_COMMAND
		mov			eax,wParam
		and			eax,0FFFFH
		.if			eax == 1043
			mov			@hFile,0
			mov			@hFileMap,0
			mov			@lpMem,0
			push		ebp
			push		offset @F
			push		offset _SEH
			push		fs:[0]
			mov			fs:[0],esp
			invoke	CreateFile,offset stFile.szFile,GENERIC_READ or GENERIC_WRITE,0,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
			cmp			eax,-1
			jz			@F
			mov			@hFile,eax
			invoke	CreateFileMapping,@hFile,0,PAGE_READWRITE,0,0,0
			or			eax,eax
			jz			@F
			mov			@hFileMap,eax
			invoke	MapViewOfFile,@hFileMap,FILE_MAP_READ or FILE_MAP_WRITE or FILE_MAP_COPY,0,0,0
			or			eax,eax
			jz			@F
			mov			@lpMem,eax
			mov			edi,eax
			mov			ax,WORD PTR [edi]
			.if			ax == 'ZM'
				add			edi,[edi+3CH]
				mov			eax,DWORD PTR [edi]
				.if			eax == 'EP'
					add			edi,4
					add			edi,sizeof IMAGE_FILE_HEADER
					mov			ax,WORD PTR [edi]
					.if			ax == 020BH
						add			edi,112
					.else
						add			edi,96
					.endif
					mov			ecx,32
					mov			esi,2800
					___dir_lop:
					push		ecx
					invoke	SendDlgItemMessage,hWnd,esi,WM_GETTEXT,sizeof @szBuf,addr @szBuf
					invoke	_Ascii2Dword16,addr @szBuf
					cld
					stosd
					pop			ecx
					inc			esi
					loop		___dir_lop
				.endif
			.endif
			@@:
			sub			@lpMem,0
			jz			@F
			invoke	UnmapViewOfFile,@lpMem
			@@:
			sub			@hFileMap,0
			jz			@F
			invoke	CloseHandle,@hFileMap
			@@:
			sub			@hFile,0
			jz			@F
			invoke	CloseHandle,@hFile
			@@:
			pop			fs:[0]
			add			esp,12
		.elseif eax == 1042
			jmp			@F
		.else
		  invoke  _CmdCharDlgProtBt,hWnd,wParam,lParam
		.endif
	.elseif	uMsg == WM_CLOSE
		@@:
		invoke  _DestroyEdpeDlgTooltip
		invoke	EndDialog,hWnd,0
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_DirectoriesDlg	endp

szAccessDeny 	db 	'Permission denied!',0
szAccesDeny		db	'This file is protected by system or other process, cannot open in write-enabled mode.',0

_FillItemData	proc	hWnd:DWORD,lParam:DWORD
	LOCAL		@hFile:DWORD
	LOCAL		@hFileMap:DWORD
	LOCAL		@lpMem:DWORD
	LOCAL		@szBuf[260]:BYTE
	LOCAL		@szFmt4[64]:BYTE
	LOCAL		@szFmt2[64]:BYTE
	pushad
	invoke	lstrcpyn,addr @szFmt4,offset szFmt4,sizeof szFmt4-1
	invoke	lstrcpyn,addr @szFmt2,offset szFmt2,sizeof szFmt2-1
	invoke	CreateFile,offset stFile.szFile,GENERIC_READ or GENERIC_WRITE,0,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
	.if			eax
		mov			@hFile,eax
		invoke	CreateFileMapping,@hFile,0,PAGE_READWRITE,0,0,0
		.if			eax
			mov			@hFileMap,eax
			invoke	MapViewOfFile,@hFileMap,FILE_MAP_READ or FILE_MAP_WRITE,0,0,0
			.if			eax
				mov			@lpMem,eax
				mov			esi,@lpMem	;; need been changged.
				assume	fs:nothing
				push		ebp
				push		offset _fill_item_quit
				push		offset _HandlerProc
				push		fs:[0]
				mov			fs:[0],esp
				assume	esi:PTR IMAGE_DOS_HEADER
				.if			[esi].e_magic == IMAGE_DOS_SIGNATURE
					add			esi,[esi].e_lfanew
					assume	esi:PTR IMAGE_NT_HEADERS
					.if			[esi].Signature == IMAGE_NT_SIGNATURE
						.if			lParam ;; save image
							invoke	SendDlgItemMessage,hWnd,7,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].FileHeader.Machine,ax
							invoke	SendDlgItemMessage,hWnd,1017,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].FileHeader.NumberOfSections,ax
							invoke	SendDlgItemMessage,hWnd,1018,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].FileHeader.TimeDateStamp,eax
							invoke	SendDlgItemMessage,hWnd,1026,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].FileHeader.SizeOfOptionalHeader,ax
							invoke	SendDlgItemMessage,hWnd,1019,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].FileHeader.Characteristics,ax
							invoke	SendDlgItemMessage,hWnd,1032,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.Magic,ax
							invoke	SendDlgItemMessage,hWnd,3,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.MajorLinkerVersion,al
							invoke	SendDlgItemMessage,hWnd,4,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.MinorLinkerVersion,al
							invoke	SendDlgItemMessage,hWnd,2,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.SizeOfCode,eax
							invoke	SendDlgItemMessage,hWnd,1008,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.AddressOfEntryPoint,eax
							invoke	SendDlgItemMessage,hWnd,1011,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.BaseOfCode,eax
							.if			stFile.dwReserve == 64
								invoke	SendDlgItemMessage,hWnd,1009,WM_GETTEXT,sizeof @szBuf,addr @szBuf
								invoke	_Ascii2Dword16,addr @szBuf
								mov			[esi].OptionalHeader.BaseOfData,eax
								invoke	SendDlgItemMessage,hWnd,1,WM_GETTEXT,sizeof @szBuf,addr @szBuf
								invoke	_Ascii2Dword16,addr @szBuf
								mov			[esi].OptionalHeader.ImageBase,eax
							.else
								invoke	SendDlgItemMessage,hWnd,1012,WM_GETTEXT,sizeof @szBuf,addr @szBuf
								invoke	_Ascii2Dword16,addr @szBuf
								mov			[esi].OptionalHeader.BaseOfData,eax
								invoke	SendDlgItemMessage,hWnd,1009,WM_GETTEXT,sizeof @szBuf,addr @szBuf
								invoke	_Ascii2Dword16,addr @szBuf
								mov			[esi].OptionalHeader.ImageBase,eax
							.endif
							invoke	SendDlgItemMessage,hWnd,1014,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.SectionAlignment,eax
							invoke	SendDlgItemMessage,hWnd,1015,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.FileAlignment,eax
							invoke	SendDlgItemMessage,hWnd,1010,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.SizeOfImage,eax
							invoke	SendDlgItemMessage,hWnd,1013,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.SizeOfHeaders,eax
							invoke	SendDlgItemMessage,hWnd,1024,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.CheckSum,eax
							invoke	SendDlgItemMessage,hWnd,1016,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.Subsystem,ax
							invoke	SendDlgItemMessage,hWnd,5,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							mov			[esi].OptionalHeader.DllCharacteristics,ax
							invoke	SendDlgItemMessage,hWnd,1033,WM_GETTEXT,sizeof @szBuf,addr @szBuf
							invoke	_Ascii2Dword16,addr @szBuf
							.if			stFile.dwReserve == 64
								lea			ebx,[esi].OptionalHeader.NumberOfRvaAndSizes
								add			ebx,10H
								mov			DWORD PTR [ebx],eax
							.else
								mov			[esi].OptionalHeader.NumberOfRvaAndSizes,eax
							.endif
						.else
							movzx		eax,[esi].FileHeader.Machine
							invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
							invoke	SendDlgItemMessage,hWnd,7,WM_SETTEXT,0,addr @szBuf
							movzx		eax,[esi].FileHeader.NumberOfSections
							invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
							invoke	SendDlgItemMessage,hWnd,1017,WM_SETTEXT,0,addr @szBuf
							mov			eax,[esi].FileHeader.TimeDateStamp
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1018,WM_SETTEXT,0,addr @szBuf
							movzx		eax,[esi].FileHeader.SizeOfOptionalHeader
							invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
							invoke	SendDlgItemMessage,hWnd,1026,WM_SETTEXT,0,addr @szBuf
							movzx		eax,[esi].FileHeader.Characteristics
							invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
							invoke	SendDlgItemMessage,hWnd,1019,WM_SETTEXT,0,addr @szBuf
							movzx		eax,[esi].OptionalHeader.Magic
							invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
							invoke	SendDlgItemMessage,hWnd,1032,WM_SETTEXT,0,addr @szBuf
							movzx		eax,[esi].OptionalHeader.MajorLinkerVersion
							invoke	wsprintf,addr @szBuf,addr @szFmt2,eax
							invoke	SendDlgItemMessage,hWnd,3,WM_SETTEXT,0,addr @szBuf
							movzx		eax,[esi].OptionalHeader.MinorLinkerVersion
							invoke	wsprintf,addr @szBuf,addr @szFmt2,eax
							invoke	SendDlgItemMessage,hWnd,4,WM_SETTEXT,0,addr @szBuf
							mov			eax,[esi].OptionalHeader.SizeOfCode
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,2,WM_SETTEXT,0,addr @szBuf
							mov			eax,[esi].OptionalHeader.AddressOfEntryPoint
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1008,WM_SETTEXT,0,addr @szBuf
							mov			eax,[esi].OptionalHeader.BaseOfCode
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1011,WM_SETTEXT,0,addr @szBuf
							.if			stFile.dwReserve == 64
								mov			eax,[esi].OptionalHeader.BaseOfData
								invoke	wsprintf,addr @szBuf,offset szFmt8,eax
								invoke	SendDlgItemMessage,hWnd,1009,WM_SETTEXT,0,addr @szBuf
								mov			eax,[esi].OptionalHeader.ImageBase
								invoke	wsprintf,addr @szBuf,offset szFmt8,eax
								invoke	SendDlgItemMessage,hWnd,1,WM_SETTEXT,0,addr @szBuf
								invoke	GetDlgItem,hWnd,1012
								.if			eax
									invoke	EnableWindow,eax,0
								.endif
							.else ;; 32 bit
								invoke	GetDlgItem,hWnd,1
								.if			eax
									invoke	EnableWindow,eax,0
								.endif
								mov			eax,[esi].OptionalHeader.BaseOfData
								invoke	wsprintf,addr @szBuf,offset szFmt8,eax
								invoke	SendDlgItemMessage,hWnd,1012,WM_SETTEXT,0,addr @szBuf
								mov			eax,[esi].OptionalHeader.ImageBase
								invoke	wsprintf,addr @szBuf,offset szFmt8,eax
								invoke	SendDlgItemMessage,hWnd,1009,WM_SETTEXT,0,addr @szBuf
							.endif
							mov			eax,[esi].OptionalHeader.SectionAlignment
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1014,WM_SETTEXT,0,addr @szBuf
							mov			eax,[esi].OptionalHeader.FileAlignment
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1015,WM_SETTEXT,0,addr @szBuf
							mov			eax,[esi].OptionalHeader.SizeOfImage
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1010,WM_SETTEXT,0,addr @szBuf
							mov			eax,[esi].OptionalHeader.SizeOfHeaders
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1013,WM_SETTEXT,0,addr @szBuf
							mov			eax,[esi].OptionalHeader.CheckSum
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1024,WM_SETTEXT,0,addr @szBuf
							movzx		eax,[esi].OptionalHeader.Subsystem
							invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
							invoke	SendDlgItemMessage,hWnd,1016,WM_SETTEXT,0,addr @szBuf
							movzx		eax,[esi].OptionalHeader.DllCharacteristics
							invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
							invoke	SendDlgItemMessage,hWnd,5,WM_SETTEXT,0,addr @szBuf
							.if			stFile.dwReserve == 64
								lea			eax,[esi].OptionalHeader.NumberOfRvaAndSizes
								add			eax,10H
								mov			eax,DWORD PTR [eax]
							.else
								mov			eax,[esi].OptionalHeader.NumberOfRvaAndSizes
							.endif
							invoke	wsprintf,addr @szBuf,offset szFmt8,eax
							invoke	SendDlgItemMessage,hWnd,1033,WM_SETTEXT,0,addr @szBuf
						.endif
					.endif
				.endif
				_fill_item_quit:
				assume	esi:nothing
				pop			fs:[0]
				add			esp,12
				invoke	UnmapViewOfFile,@lpMem
			.else
				jmp			@F
			.endif
			invoke	CloseHandle,@hFileMap
		.else
			jmp		@F
		.endif
		invoke	CloseHandle,@hFile
	.else
		@@:
		invoke	SendMessage,hWnd,WM_SETTEXT,0,offset szAccessDeny
		invoke	MessageBox,hWnd,offset szAccesDeny,offset szAccessDeny,10H
		push		'-'
		mov			esi,esp
		invoke	_AddText,esi,00H
		invoke	_AddText,offset szAccesDeny,0FFH
		invoke	_AddText,offset szAccessDeny,00H
		add			esp,4
		invoke	SendMessage,hWnd,WM_CLOSE,0,0
	.endif
	popad
	ret
_FillItemData	endp

_ProcessEPCmd	proc	hWnd:DWORD,wParam:DWORD,lParam:DWORD
	LOCAL		@szBuf[260]:BYTE
	LOCAL		@szFmt4[64]:BYTE
	mov			eax,wParam
	and			eax,0ffffh
	.if			eax == 1006
		invoke	_FillItemData,hWnd,1
	.elseif eax == 6 ;; dll characteristics
		invoke	lstrcpyn,addr @szFmt4,offset szFmt4,sizeof szFmt4-1
		invoke	SendDlgItemMessage,hWnd,5,WM_GETTEXT,sizeof @szBuf,addr @szBuf
		.if			eax
			invoke	_Ascii2Dword16,addr @szBuf
			invoke	DialogBoxParam,stFile.hInstance,109,hWnd,offset _DllCharacteristicsDlg,eax
			.if			eax != -1
				invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
				invoke	SendDlgItemMessage,hWnd,5,WM_SETTEXT,0,addr @szBuf
			.endif
		.endif
	.elseif eax == 8 ;; machine type
		invoke	lstrcpyn,addr @szFmt4,offset szFmt4,sizeof szFmt4-1
		invoke	SendDlgItemMessage,hWnd,7,WM_GETTEXT,sizeof @szBuf,addr @szBuf
		.if			eax
			invoke	_Ascii2Dword16,addr @szBuf
			invoke	DialogBoxParam,stFile.hInstance,108,hWnd,offset _MachineTypeDlg,eax
			.if			eax != -1
				invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
				invoke	SendDlgItemMessage,hWnd,7,WM_SETTEXT,0,addr @szBuf
			.endif
		.endif
	.elseif eax == 9 ;; directories
		invoke	DialogBoxParam,stFile.hInstance,110,hWnd,offset _DirectoriesDlg,0
	.elseif	eax == 1007
		xor			eax,eax
		ret
	.elseif eax == 1021
		invoke	DialogBoxParam,stFile.hInstance,105,hWnd,offset _R2OProc,0
	.elseif eax == 1023
		invoke	lstrcpyn,addr @szFmt4,offset szFmt4,sizeof szFmt4-1
		invoke	SendDlgItemMessage,hWnd,1019,WM_GETTEXT,sizeof @szBuf,addr @szBuf
		.if			eax
			invoke	_Ascii2Dword16,addr @szBuf
			invoke	DialogBoxParam,stFile.hInstance,106,hWnd,offset _CharacteristicsDlg,eax
			.if			eax != -1
				invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
				invoke	SendDlgItemMessage,hWnd,1019,WM_SETTEXT,0,addr @szBuf
			.endif
		.endif
	.elseif eax == 1025 ;; checksum --> "?"
		sub			esp,8
		mov			esi,esp
		mov			edi,esp
		add			edi,4
		invoke	MapFileAndCheckSumA,offset stFile.szFile,esi,edi
		.if			eax == CHECKSUM_SUCCESS
			mov			eax,DWORD PTR [edi]
			invoke	wsprintf,addr @szBuf,offset szFmt8,eax
			invoke	SendDlgItemMessage,hWnd,1024,WM_SETTEXT,0,addr @szBuf
		.endif
		add			esp,8
	.elseif eax == 1027 ;; PE comparison.
		invoke	DialogBoxParam,stFile.hInstance,104,hWnd,offset _ComparisonDlgProc,0
	.elseif eax == 1028 ;; sizeofheaders --> "+"
		invoke	SendDlgItemMessage,hWnd,1013,WM_GETTEXT,sizeof @szBuf,addr @szBuf
		.if			eax < 0ffffffffh
			invoke	_Ascii2Dword16,addr @szBuf
			add			eax,200H
			.if			eax
				invoke	wsprintf,addr @szBuf,offset szFmt8,eax
				invoke	SendDlgItemMessage,hWnd,1013,WM_SETTEXT,0,addr @szBuf
			.else
				invoke	MessageBeep,-1
			.endif
		.endif
	.elseif eax == 1029 ;; subsystem
		invoke	SendDlgItemMessage,hWnd,1016,WM_GETTEXT,sizeof @szBuf,addr @szBuf
		.if			eax
			invoke	_Ascii2Dword16,addr @szBuf
			invoke	DialogBoxParam,stFile.hInstance,107,hWnd,offset _SubsystemDlg,eax
			cmp			eax,-1
			jz			@F
			push		eax
			invoke	lstrcpyn,addr @szFmt4,offset szFmt4,sizeof szFmt4-1
			pop			eax
			invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
			invoke	SendDlgItemMessage,hWnd,1016,WM_SETTEXT,0,addr @szBuf
			@@:
		.endif
	.elseif eax == 1030
		invoke	DialogBoxParam,stFile.hInstance,103,hWnd,offset _TimeCal,0
	.elseif eax == 1031 ;; sizeofheaders --> "?"
		sub			esp,8
		mov			esi,esp
		mov			edi,esp
		add			edi,4
		invoke	MapFileAndCheckSumA,offset stFile.szFile,esi,edi
		.if			eax == CHECKSUM_SUCCESS
			mov			eax,DWORD PTR [edi]
			push		eax
			invoke	CheckSumMappedFile,stFile.lpMem,stFile.cbMem,esi,edi
			xor			ecx,ecx
			.if			eax
				mov			ecx,DWORD PTR [edi]
			.endif
			pop			eax
			.if			eax != ecx
				jmp			@F
				_edpe_txxxx:
				db		'Memory checksum not equal to file checksum.',0AH,'Would you like reopen file?',0
				@@:
				invoke	MessageBox,hWnd,offset _edpe_txxxx,0,MB_ICONQUESTION or MB_OKCANCEL
				.if			eax == IDOK
					invoke	_OpenFile,offset stFile.szFile
				.endif
			.endif
			mov			esi,stFile.lpMem
			push		ebp
			push		offset _edpe_toxxx
			push		offset _HandlerProc
			assume	fs:nothing
			push		fs:[0]
			mov			fs:[0],esp
			add			esi,[esi+3CH]
			add			esi,4
			movzx		ecx,WORD PTR [esi+2]
			add			esi,sizeof IMAGE_FILE_HEADER
			mov			edx,DWORD PTR [esi+36]
			push		edx
			movzx		eax,WORD PTR [esi]
			.if			eax == 020BH ;; 64bit
				add			esi,232
			.else
				add			esi,216
			.endif
			add			esi,8 ;; skip last directory
			mov			eax,sizeof IMAGE_SECTION_HEADER
			xor			edx,edx
			mul			ecx
			add			esi,eax
			sub			esi,stFile.lpMem
			;;
			pop			ecx
			mov			eax,esi
			mov			esi,ecx
			xor			edx,edx
			div			ecx
			inc			eax
			mov			ecx,eax
			mov			eax,esi
			xor			edx,edx
			mul			ecx
			invoke	wsprintf,addr @szBuf,offset szFmt8,eax
			invoke	SendDlgItemMessage,hWnd,1013,WM_SETTEXT,0,addr @szBuf
			pop			fs:[0]
			add			esp,12
			_edpe_toxxx:
		.endif
		add			esp,8
	.elseif eax == 1034
		invoke	lstrcpyn,addr @szFmt4,offset szFmt4,sizeof szFmt4-1
		invoke	SendDlgItemMessage,hWnd,1033,WM_GETTEXT,sizeof @szBuf,addr @szBuf
		.if			eax
			invoke	_Ascii2Dword16,addr @szBuf
			add			eax,8
			.if			eax < 0ffffffffh
				invoke	wsprintf,addr @szBuf,offset szFmt8,eax
				invoke	SendDlgItemMessage,hWnd,1033,WM_SETTEXT,0,addr @szBuf
				invoke	SendDlgItemMessage,hWnd,1026,WM_GETTEXT,sizeof @szBuf,addr @szBuf
				.if			eax
					invoke	_Ascii2Dword16,addr @szBuf
					add			eax,8
					invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
					invoke	SendDlgItemMessage,hWnd,1026,WM_SETTEXT,0,addr @szBuf
				.endif
			.else
				invoke	MessageBeep,-1
			.endif
		.endif
	.elseif	eax == 1035
		invoke	lstrcpyn,addr @szFmt4,offset szFmt4,sizeof szFmt4-1
		invoke	SendDlgItemMessage,hWnd,1033,WM_GETTEXT,sizeof @szBuf,addr @szBuf
		.if			eax
			invoke	_Ascii2Dword16,addr @szBuf
			.if			eax 
				sub			eax,8
				invoke	wsprintf,addr @szBuf,offset szFmt8,eax
				invoke	SendDlgItemMessage,hWnd,1033,WM_SETTEXT,0,addr @szBuf
				invoke	SendDlgItemMessage,hWnd,1026,WM_GETTEXT,sizeof @szBuf,addr @szBuf
				.if			eax
					invoke	_Ascii2Dword16,addr @szBuf
					sub			eax,8
					invoke	wsprintf,addr @szBuf,addr @szFmt4,eax
					invoke	SendDlgItemMessage,hWnd,1026,WM_SETTEXT,0,addr @szBuf
				.endif
			.else
				invoke	MessageBeep,-1
			.endif
		.endif
	.endif
	mov			eax,1
	ret
_ProcessEPCmd	endp

_EdPEProc	proc	uses esi,hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	.if			uMsg == WM_INITDIALOG
		sub			stFile.lpMem,0
		jz			@F
		invoke	SendMessage,hWnd,WM_SETICON,ICON_BIG,stFile.hIcon
		mov     esi,stFile.lpMem
		cmp     (IMAGE_DOS_HEADER ptr [esi]).e_magic,IMAGE_DOS_SIGNATURE
		jnz     @F
		add     esi,(IMAGE_DOS_HEADER ptr [esi]).e_lfanew
		cmp     (IMAGE_NT_HEADERS ptr [esi]).Signature,IMAGE_NT_SIGNATURE
		jnz     @F
		invoke	_FillItemData,hWnd,0
	.elseif uMsg == WM_COMMAND
		invoke	_ProcessEPCmd,hWnd,wParam,lParam
		or			eax,eax
		jz			@F
	.elseif	uMsg == WM_CLOSE
		@@:
		invoke	EndDialog,hWnd,0
	.else
		xor			eax,eax
		ret
	.endif
	mov			eax,1
	ret
_EdPEProc	endp

_EdPE	proc	lParam:DWORD
	pushad
	invoke	DialogBoxParam,stFile.hInstance,102,stFile.hWinMain,offset _EdPEProc,0
	popad
	xor			eax,eax
	ret
_EdPE	endp
