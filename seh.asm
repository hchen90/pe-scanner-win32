_SEH		equ	_HandlerProc

_HandlerProc	proc	C _lpExceptionRecord:DWORD,_lpSEH:DWORD,_lpContext:DWORD,_lpDispatchContext:DWORD
		
		pusha
		mov				esi,_lpExceptionRecord
		mov				edi,_lpContext
		mov				eax,_lpSEH
		
		assume		esi:PTR EXCEPTION_RECORD,edi:PTR CONTEXT
		push			[eax+8]
		pop				[edi].regEip
		push			[eax+0CH]
		pop				[edi].regEbp
		push			eax
		pop				[edi].regEsp
		assume		esi:nothing,edi:nothing
		popa
		mov				eax,ExceptionContinueExecution
		
		ret
_HandlerProc	endp
