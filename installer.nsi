!include "WinMessages.nsh"

Name "PE Scanner Installer"
OutFile "pes-win32-installer.exe"
Icon "ico101.ico"
UninstallIcon "ico102.ico"
Caption "PE Scanner Installer"

CRCCheck on
SetCompressor lzma
SetDatablockOptimize on
SetDateSave on
XPStyle on

InstallDir "$PROGRAMFILES\PE Scanner"
LicenseData "COPYING"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"

RequestExecutionLevel admin

;;#########################################################

Page  license
Page  components
Page  directory
Page  instfiles
UninstPage  uninstConfirm
UninstPage  instfiles

;;#########################################################

SectionGroup "PE Scanner Binary Files"
  Section "!PE Scanner (required)"
    SectionIn RO
    SetOutPath "$INSTDIR"
    File "PES.exe"
	File "16Edit.DLL"
	File "ChangeLog.txt"
	File "check.dll"
	File "Readme.cn.txt"
	File "Readme.en.txt"
	File "UserDB.TXT"
	File "COPYING"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PE Scanner" "DisplayName" "Microsoft Portable Executable File Scanner"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PE Scanner" "DisplayIcon" "$INSTDIR\uninstaller.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PE Scanner" "DisplayVersion" "1.0.1.0"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PE Scanner" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PE Scanner" "NoRepair" 1
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PE Scanner" "Publisher" "Hsiang Chen"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PE Scanner" "UninstallString" "$INSTDIR\uninstaller.exe"
    WriteUninstaller "$INSTDIR\uninstaller.exe"
  SectionEnd
  Section "Plugins"
    SetOutPath "$INSTDIR\Plugins"
	File "plugins\*.*"
	File "plugins\peid_plugins\*.*"
  SectionEnd
SectionGroupEnd

SectionGroup "PE Scanner Documents"
  Section "SDK Examples"
    SetOutPath "$INSTDIR\Examples"
	File "check.c"
	File "check.def"
	File "misc\Makefile.mak"
	File "misc\rsrc.rc"
	File "misc\timec.c"
	File "misc\unpecompact2.c"
	File "misc\unpecompact2.def"
	File "misc\unpecompact2.h"
  SectionEnd
SectionGroupEnd

Section "Add Start Menu Shortcuts"
  CreateDirectory "$SMPROGRAMS\PE Scanner"
  CreateShortCut "$SMPROGRAMS\PE Scanner\Uninstall.lnk" "$INSTDIR\uninstaller.exe" "" "$INSTDIR\uninstaller.exe" 0
  CreateShortCut "$SMPROGRAMS\PE Scanner\PE Scanner.lnk" "$INSTDIR\PES.exe" "" "$INSTDIR\PES.exe" 0
SectionEnd

Section "Add [Send To] Menu Shortcut"
  CreateShortCut "$SENDTO\PE Scanner.lnk" "$INSTDIR\PES.exe" "" "$INSTDIR\PES.exe" 0
SectionEnd

Section "Add Desktop Shortcut"
  CreateShortCut "$DESKTOP\PE Scanner.lnk" "$INSTDIR\PES.exe" "" "$INSTDIR\PES.exe" 0
SectionEnd

Section "Uninstall"
  Delete "$SENDTO\PE Scanner.lnk"
  Delete "$DESKTOP\PE Scanner.lnk"
  Delete "$SMPROGRAMS\PE Scanner\*.*"
  RMDir /r "$SMPROGRAMS\PE Scanner"
  Delete "$INSTDIR\*.*"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PE Scanner"
  RMDir /r "$INSTDIR"
SectionEnd

;;#########################################################

Function  .onInit
  Banner::show "Calculating ..."
  Banner::getWindow
  Pop $1
  _again:
    IntOp $0 $0 + 1
    Sleep 5
    StrCmp $0 100 0 _again
  Banner::destroy
FunctionEnd

Function  .onUserAbort
  MessageBox MB_YESNO|MB_ICONEXCLAMATION  "Are you sure abort the installation?" IDYES _skip
    Abort
  _skip:
FunctionEnd

;;#########################################################

VIProductVersion "1.0.0.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "PE Scanner Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "PE Scanner Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Hsiang Chen"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "PE Scanner is a trademark of Hsiang Chen"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "Copytight(C)2014 Hsiang Chen"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "PE Scanner Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "1.0.0.0"

