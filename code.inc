;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IFNDEF												_CODE_INC_
_CODE_INC_										equ	1

Include												windows.inc

Include												kernel32.inc
Include                       user32.inc
Include                       shell32.inc
Include                       gdi32.inc
Include                       comctl32.inc
Include                       comdlg32.inc
Include                       imagehlp.inc
Include												ole32.inc
Include												msvcrt.inc

Includelib										kernel32.lib
Includelib										user32.lib
Includelib										shell32.lib
Includelib										gdi32.lib
Includelib										comctl32.lib
Includelib										comdlg32.lib
Includelib										imagehlp.lib
Includelib										ole32.lib
Includelib										msvcrt.lib

ENDIF

.const
Include                       funcs.inc


;; these functions is compiled in C
;; md5.c
MD5_GetCode PROTO  pSrc:DWORD,nSize:DWORD,pDest:DWORD
;; recents.c
_AddFileToList proto filename:DWORD,menu:DWORD
_RespRecentsMenu proto hWnd:DWORD,wParam:DWORD,lParam:DWORD
_WriteRecentsMenu proto
_ConstructRecentsMenu proto hMenu:DWORD
;; chardlgep.c
_InitCharDlgProtBt  proto hWnd:DWORD,lpMem:DWORD
_CmdCharDlgProtBt proto hWnd:DWORD,wParam:DWORD,lParam:DWORD
_ComparisonDlgProc  proto hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
_DestroyEdpeDlgTooltip proto
