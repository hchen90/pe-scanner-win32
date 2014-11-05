;exportsfun.asm

AddTextToOutputWindow	proc	_lpStr:DWORD,_crClr:DWORD
	pushad
	.if			_lpStr
		invoke	_AddText,_lpStr,_crClr
	.endif
	popad
	ret
AddTextToOutputWindow	endp

ResizeMainWindowFrame	proc
	pushad
	invoke	_ResizeWindow
	popad
	ret
ResizeMainWindowFrame	endp

IsThisFileDll	proc	_lpFile:DWORD
	pushad
	.if			_lpFile
		invoke	_IsDll,_lpFile
	.endif
	popad
	ret
IsThisFileDll	endp

OffsetToRva	proc	_lpMem:DWORD,_dwOffset:DWORD
	pushad
	.if			_lpMem && _dwOffset
		invoke	_Offset2Rva,_lpMem,_dwOffset
	.endif
	popad
	ret
OffsetToRva	endp

RvaToOffset	proc	_lpMem:DWORD,_dwRva:DWORD
	pushad
	.if			_lpMem && _dwRva
		invoke	_RVAToRAW,_lpMem,_dwRva
	.endif
	popad
	ret
RvaToOffset	endp

MD5GetCode	proc	_pSrc:DWORD,_nSize:DWORD,_pDes:DWORD
	pushad
	.if			_pSrc && _nSize && _pDes
		invoke	MD5_GetCode,_pSrc,_nSize,_pDes
	.endif
	popad
	ret
MD5GetCode	endp

CreateCRC32Table	proc	_lpMem:DWORD
	pushad
	.if			_lpMem
		invoke	_CreateCrc32Table,_lpMem
	.endif
	popad
	ret
CreateCRC32Table	endp

GenerateCRC32Value	proc	_lpMem:DWORD,_lpTable:DWORD,_nSize:DWORD
	pushad
	.if			_lpMem && _lpTable && _nSize
		invoke	_GenerateCrc32Value,_lpMem,_lpTable,_nSize
	.endif
	popad
	ret
GenerateCRC32Value	endp
