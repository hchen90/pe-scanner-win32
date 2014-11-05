// copyright(c)2014 Hsiang Chen

#include <windows.h>
#include <commctrl.h>

/* external functions  */

DWORD WINAPI  _RVAToRAW(DWORD ,DWORD );
DWORD WINAPI  _GetAppObjInfo(DWORD );

#define APPOBJ_HINSTANCE  1
#define APPOBJ_HIMAGELIST 2
#define APPOBJ_HMENU      4
#define APPOBJ_HICON      8
#define APPOBJ_SZFILE     16
#define APPOBJ_HTOOLTIP   32
#define APPOBJ_HFONT      64
#define APPOBJ_HWINMAIN   128

#ifndef IMAGE_FILE_MACHINE_AMD64
  #define IMAGE_FILE_MACHINE_AMD64  0x8664
#endif

#ifndef TTS_BALLOON
  #define TTS_BALLOON 0x40
#endif

#ifndef LVS_EX_DOUBLEBUFFER
  #define LVS_EX_DOUBLEBUFFER 0x10000
#endif
/* global variables */
static HWND tooltip = 0;

/* common functions */

/* this function is called in WM_INITDIALOG message */
int WINAPI  _InitCharDlgProtBt(HWND hWnd,LPVOID lpMem) 
{
  if(lpMem){
    IMAGE_DOS_HEADER* pDos = (IMAGE_DOS_HEADER*)lpMem;
    if(pDos->e_magic == IMAGE_DOS_SIGNATURE){
      IMAGE_NT_HEADERS32* pNt = (IMAGE_NT_HEADERS32*)((TCHAR*)lpMem + pDos->e_lfanew);
      if(pNt->Signature == IMAGE_NT_SIGNATURE){
        if(pNt->FileHeader.Machine == IMAGE_FILE_MACHINE_I386){ // PC x86
          int i = 0;
          for(i;i < 16;i++){
            ShowWindow(GetDlgItem(hWnd,(3000 + i)),((pNt->OptionalHeader.DataDirectory[i].VirtualAddress || pNt->OptionalHeader.DataDirectory[i].Size) ? SW_SHOW : SW_HIDE));
            ShowWindow(GetDlgItem(hWnd,(4000 + i)),((pNt->OptionalHeader.DataDirectory[i].VirtualAddress || pNt->OptionalHeader.DataDirectory[i].Size) ? SW_SHOW : SW_HIDE));
          }
        } else if(pNt->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64){ // PC x86_64
          IMAGE_NT_HEADERS64* pNt = (IMAGE_NT_HEADERS64*)((TCHAR*)lpMem + pDos->e_lfanew);
          int i = 0;
          for(i;i < 16;i++){
            ShowWindow(GetDlgItem(hWnd,(3000 + i)),((pNt->OptionalHeader.DataDirectory[i].VirtualAddress || pNt->OptionalHeader.DataDirectory[i].Size) ? SW_SHOW : SW_HIDE));
            ShowWindow(GetDlgItem(hWnd,(4000 + i)),((pNt->OptionalHeader.DataDirectory[i].VirtualAddress || pNt->OptionalHeader.DataDirectory[i].Size) ? SW_SHOW : SW_HIDE));
          }
        }
        { // set tooltips
          int i = 0;
          HINSTANCE inst = (HINSTANCE)_GetAppObjInfo(APPOBJ_HINSTANCE);
          if(! tooltip){
            tooltip = CreateWindowEx(0,TOOLTIPS_CLASS,TEXT(""),WS_POPUP | TTS_ALWAYSTIP | TTS_BALLOON,\
                      0,0,0,0,hWnd,0,inst,0);
          }
          if(tooltip && inst){
            for(i;i < 16;i++){
              TOOLINFO  ti = {0};
              ti.cbSize = sizeof(ti);
              ti.uFlags = TTF_SUBCLASS | TTF_IDISHWND;
              ti.hwnd = hWnd;
              ti.uId = (UINT_PTR)GetDlgItem(hWnd,3000 + i);
              ti.hinst = inst;
              ti.lpszText = TEXT("Click here to load a table-data and override current image.");
              SendMessage(tooltip,TTM_ADDTOOL,0,(LPARAM)&ti);
              ti.uId = (UINT_PTR)GetDlgItem(hWnd,4000 + i);
              ti.lpszText = TEXT("Click here to save current table-data into file.");
              SendMessage(tooltip,TTM_ADDTOOL,0,(LPARAM)&ti);
            }
          }
        }
      }
    }
  }
  return 0;
}

HWND  WINAPI  _DestroyEdpeDlgTooltip()
{
  if(tooltip)DestroyWindow(tooltip);
  tooltip = 0;
  return tooltip;
}

/* this function is called in WM_COMMAND message */
int WINAPI  _CmdCharDlgProtBt(HWND hWnd,WPARAM wParam,LPARAM lParam) 
{
  if((LOWORD(wParam) >= 3000) && (LOWORD(wParam) < (3000 + 16))){
    /* open file and override to image */
    OPENFILENAME of = {0};
    HINSTANCE inst = 0;
    TCHAR filename[MAX_PATH] = {0};
    inst = (HINSTANCE)_GetAppObjInfo(APPOBJ_HINSTANCE);
    of.lStructSize = sizeof(of);
    of.hwndOwner = hWnd;
    of.hInstance = inst;
    of.lpstrFilter = TEXT("Table Data(*.dat)\0*.dat\0All Files(*.*)\0*.*\0");
    of.lpstrFile = filename;
    of.nMaxFile = sizeof(filename);
    of.Flags = OFN_EXPLORER;
    if(GetOpenFileName(&of)){
      HANDLE hFile = INVALID_HANDLE_VALUE,hFileS = INVALID_HANDLE_VALUE;
      HANDLE hFileMap = 0,hFileMapS = 0;
      LPVOID pMem = 0,pMemS = 0;
      TCHAR* wtfilename = (TCHAR*)_GetAppObjInfo(APPOBJ_SZFILE);
      if( ((hFile = CreateFile(wtfilename,GENERIC_READ | GENERIC_WRITE,0,0,OPEN_EXISTING,0,0)) != INVALID_HANDLE_VALUE) && \
          ((hFileS = CreateFile(filename,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,0,0)) != INVALID_HANDLE_VALUE) && \
          (hFileMap = CreateFileMapping(hFile,0,PAGE_READWRITE,0,0,0)) && \
          (hFileMapS = CreateFileMapping(hFileS,0,PAGE_READONLY,0,0,0)) && \
          (pMem = MapViewOfFile(hFileMap,FILE_MAP_READ | FILE_MAP_WRITE,0,0,0)) && \
          (pMemS = MapViewOfFile(hFileMapS,FILE_MAP_READ,0,0,0)) ){
        IMAGE_DOS_HEADER* pDos = (IMAGE_DOS_HEADER*)pMem; // for writing
        if(pDos->e_magic == IMAGE_DOS_SIGNATURE){
          IMAGE_NT_HEADERS32* pNt = (IMAGE_NT_HEADERS32*)((TCHAR*)pMem + pDos->e_lfanew);
          if(pNt->Signature == IMAGE_NT_SIGNATURE){
            if(pNt->FileHeader.Machine == IMAGE_FILE_MACHINE_I386){
              CopyMemory((LPVOID)(_RVAToRAW((DWORD)pMem,pNt->OptionalHeader.DataDirectory[(LOWORD(wParam) - 3000)].VirtualAddress) + (TCHAR*)pMem),pMemS,pNt->OptionalHeader.DataDirectory[(LOWORD(wParam) - 3000)].Size);
            } else if(pNt->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64){
              IMAGE_NT_HEADERS64* pNt64 = (IMAGE_NT_HEADERS64*)(TCHAR*)pNt;
              CopyMemory((LPVOID)(_RVAToRAW((DWORD)pMem,pNt64->OptionalHeader.DataDirectory[(LOWORD(wParam) - 3000)].VirtualAddress) + (TCHAR*)pMem),pMemS,pNt64->OptionalHeader.DataDirectory[(LOWORD(wParam) - 3000)].Size);
            }
          }
        }
      }
      if(pMem)UnmapViewOfFile(pMem);
      if(pMemS)UnmapViewOfFile(pMemS);
      if(hFileMap)CloseHandle(hFileMap);
      if(hFileMapS)CloseHandle(hFileMapS);
      if(hFile != INVALID_HANDLE_VALUE)CloseHandle(hFile);
      if(hFileS != INVALID_HANDLE_VALUE)CloseHandle(hFileS);
    }
  } else if((LOWORD(wParam) >= 4000) && (LOWORD(wParam) <(4000 + 16))){
    /* save data to file */
    OPENFILENAME of = {0};
    HINSTANCE inst = 0;
    TCHAR filename[MAX_PATH] = {0};
    inst = (HINSTANCE)_GetAppObjInfo(APPOBJ_HINSTANCE);
    of.lStructSize = sizeof(of);
    of.hwndOwner = hWnd;
    of.hInstance = inst;
    of.lpstrFilter = TEXT("Table Data(*.dat)\0*.dat\0");
    of.lpstrFile = filename;
    of.nMaxFile = sizeof(filename);
    of.Flags = OFN_EXPLORER;
    if(GetSaveFileName(&of)){
      HANDLE hFile = INVALID_HANDLE_VALUE;
      HANDLE hFileMap = 0;
      LPVOID pMem = 0;
      TCHAR* rdfilename = (TCHAR*)_GetAppObjInfo(APPOBJ_SZFILE);
      if( ((hFile = CreateFile(rdfilename,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,0,0)) != INVALID_HANDLE_VALUE) && \
          (hFileMap = CreateFileMapping(hFile,0,PAGE_READONLY,0,0,0)) && \
          (pMem = MapViewOfFile(hFileMap,FILE_MAP_READ,0,0,0)) ){
        IMAGE_DOS_HEADER* pDos = (IMAGE_DOS_HEADER*)pMem;
        if(pDos->e_magic == IMAGE_DOS_SIGNATURE){
          IMAGE_NT_HEADERS32* pNt = (IMAGE_NT_HEADERS32*)((TCHAR*)pMem + pDos->e_lfanew);
          if(pNt->Signature == IMAGE_NT_SIGNATURE){
            if(pNt->FileHeader.Machine == IMAGE_FILE_MACHINE_I386){ // x86
              DWORD offset = (DWORD)_RVAToRAW((DWORD)pMem,pNt->OptionalHeader.DataDirectory[(LOWORD(wParam) - 4000)].VirtualAddress);
              DWORD size = (DWORD)pNt->OptionalHeader.DataDirectory[(LOWORD(wParam) - 4000)].Size;
              {
                HANDLE hOut = CreateFile(filename,GENERIC_WRITE,0,0,CREATE_ALWAYS,0,0);
                if(hOut != INVALID_HANDLE_VALUE){
                  int nwt = 0;
                  WriteFile(hOut,((TCHAR*)pMem + offset),size,&nwt,0);
                  CloseHandle(hOut);
                }
              }
            } else if(pNt->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64){ // x86_64
              IMAGE_NT_HEADERS64* pNt64 = (IMAGE_NT_HEADERS64*)(TCHAR*)pNt;
              {
                DWORD offset = (DWORD)_RVAToRAW((DWORD)pMem,pNt64->OptionalHeader.DataDirectory[(LOWORD(wParam) - 4000)].VirtualAddress);
                DWORD size = (DWORD)pNt64->OptionalHeader.DataDirectory[(LOWORD(wParam) - 4000)].Size;
                {
                  HANDLE hOut = CreateFile(filename,GENERIC_WRITE,0,0,CREATE_ALWAYS,0,0);
                  if(hOut != INVALID_HANDLE_VALUE){
                    int nwt = 0;
                    WriteFile(hOut,((TCHAR*)pMem + offset),size,&nwt,0);
                    CloseHandle(hOut);
                  }
                }
              }
            }
          }
        }
      }
      if(pMem)UnmapViewOfFile(pMem);
      if(hFileMap)CloseHandle(hFileMap);
      if(hFile != INVALID_HANDLE_VALUE)CloseHandle(hFile);
    }
  }
  return 0;
}

/* external dialog callback routine */

/* function for listview opration */
int _ListView_AddItem(HWND l,int i,int j,DWORD s,DWORD d,TCHAR* str,int op)
{
  LVITEM lvi = {0}; 
  TCHAR suf[MAX_PATH] = {0};
  lvi.mask = LVIF_TEXT;
  lvi.iItem = i;
  lvi.iSubItem = j;
  if(j){ /* set item */
    wsprintf(suf,TEXT("%08X"),s);
    lvi.pszText = suf;
    ListView_SetItem(l,&lvi);
    lvi.iSubItem ++;
    wsprintf(suf,TEXT("%08X"),d);
    lvi.pszText = suf;
    ListView_SetItem(l,&lvi);
  } else { /* insert item */
    lvi.mask |= LVIF_IMAGE;
    if(!op){
      lvi.iImage = ((s == d)? 0 : 1);
    } else {
      lvi.iImage = 2;
    }
    lvi.pszText = str;
    ListView_InsertItem(l,&lvi);
  }
  return 0;
}

#define _ADDITEM(s,d,str) { \
  _ListView_AddItem(hCtrl,i  ,0,s,d,str,0); \
  _ListView_AddItem(hCtrl,i++,1,s,d,0,0); \
}

#define _ADDITEMX(s,d,str,o,p) { \
  if(o && p){ \
    _ADDITEM(s,d,str); \
  } else if((!o) && p){ \
    _ADDITEM(0,d,str); \
  } else if(o && (!p)){ \
    _ADDITEM(s,0,str); \
  } \
}

/* Comparison dialog */
BOOL WINAPI _ComparisonDlgProc(HWND hWnd,UINT uMsg,WPARAM wParam,LPARAM lParam)
{
  switch(uMsg){
  case  WM_INITDIALOG:
    {
      {
        SendMessage(hWnd,WM_SETTEXT,0,(LPARAM)TEXT("[ Comparision ] "));
      }
      {
        OPENFILENAME  of = {0};
        TCHAR buf[MAX_PATH] = {0},* src_filename = 0;
        of.lStructSize = sizeof(of);
        of.hwndOwner = hWnd;
        of.lpstrFilter = TEXT("EXE File(*.exe)\0*.exe\0DLL File(*.dll)\0*.dll\0All Files(*.*)\0*.*\0");
        of.lpstrFile = buf;
        of.nMaxFile = sizeof(buf);
        of.Flags = OFN_EXPLORER;
        if(GetOpenFileName(&of) == IDOK){
          HANDLE hFile = INVALID_HANDLE_VALUE, hFileS = INVALID_HANDLE_VALUE;
          src_filename = (TCHAR*)_GetAppObjInfo(APPOBJ_SZFILE);
          hFile = CreateFile(buf,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,0,0);
          hFileS = CreateFile(src_filename,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,0,0);
          if((hFile != INVALID_HANDLE_VALUE) && (hFileS != INVALID_HANDLE_VALUE)){
            HANDLE hFileMap = CreateFileMapping(hFile,0,PAGE_READONLY,0,0,0);
            HANDLE hFileMapS = CreateFileMapping(hFileS,0,PAGE_READONLY,0,0,0);
            if(hFileMap && hFileMapS){
              LPVOID pMem = MapViewOfFile(hFileMap,FILE_MAP_READ,0,0,0);
              LPVOID pMemS = MapViewOfFile(hFileMapS,FILE_MAP_READ,0,0,0);
              if(pMem && pMem){
                TCHAR   file[MAX_PATH] = {0},* filename = 0;
                HWND    hCtrl = GetDlgItem(hWnd,1);
                DWORD   dwSize[2] = {0};
                ShowWindow(hCtrl,SW_SHOW);
                ListView_SetExtendedListViewStyle(hCtrl,LVS_EX_DOUBLEBUFFER | LVS_EX_GRIDLINES | LVS_EX_FULLROWSELECT | LVS_EX_HEADERDRAGDROP);
                {
                  dwSize[0] = GetFileSize(hFileS,0);
                  dwSize[1] = GetFileSize(hFile ,0);
                }
                {
                  int i = 0,j = 0;
                  lstrcpyn(file,src_filename,MAX_PATH);
                  j = lstrlen(file);
                  for(i;i < j;i++)if(file[i] == '\\')file[i] = 0;
                  for(i--;i > 0;i--)if(file[i] == 0){ i++; break; }
                  filename = &file[i];
                }
                { /* set imagelist */
                  if((!ListView_GetImageList(hCtrl,LVSIL_SMALL)) && (!ListView_GetImageList(hCtrl,LVSIL_NORMAL))){
                    HIMAGELIST imglst = (HIMAGELIST)_GetAppObjInfo(APPOBJ_HIMAGELIST);
                    if(imglst){
                      ListView_SetImageList(hCtrl,imglst,LVSIL_SMALL);
                      ListView_SetImageList(hCtrl,imglst,LVSIL_NORMAL);
                    }
                  }
                }
                { /* insert columnes */
                  LVCOLUMN  lvc = {0};
                  lvc.mask = LVCF_FMT | LVCF_TEXT | LVCF_WIDTH;
                  lvc.fmt = LVCFMT_CENTER;
                  lvc.cx = 120;
                  lvc.pszText = TEXT("Items to compare");
                  ListView_InsertColumn(hCtrl,0,&lvc);
                  lvc.cx = 80;
                  lvc.pszText = &buf[of.nFileOffset];
                  ListView_InsertColumn(hCtrl,1,&lvc);
                  lvc.pszText = filename;
                  ListView_InsertColumn(hCtrl,2,&lvc);
                }
                { /* comparision */
                  IMAGE_DOS_HEADER* pDos1 = (IMAGE_DOS_HEADER*)pMemS, \
                                  * pDos2 = (IMAGE_DOS_HEADER*)pMem;
                  int i = 0;
                  _ADDITEM(dwSize[0],dwSize[1],TEXT("FileSize"));
                  _ListView_AddItem(hCtrl,i++,0,0,0,TEXT("DOS Header"),1);
                  _ADDITEM(pDos1->e_magic,    pDos2->e_magic,   TEXT("e_magic"));
                  _ADDITEM(pDos1->e_cblp,     pDos2->e_cblp,    TEXT("e_cblp"));
                  _ADDITEM(pDos1->e_cp,       pDos2->e_cp,      TEXT("e_cp"));
                  _ADDITEM(pDos1->e_crlc,     pDos2->e_crlc,    TEXT("e_crlc"));
                  _ADDITEM(pDos1->e_cparhdr,  pDos2->e_cparhdr, TEXT("e_cparhdr"));
                  _ADDITEM(pDos1->e_minalloc, pDos2->e_minalloc,TEXT("e_minalloc"));
                  _ADDITEM(pDos1->e_maxalloc, pDos2->e_maxalloc,TEXT("e_maxalloc"));
                  _ADDITEM(pDos1->e_ss,       pDos2->e_ss,      TEXT("e_ss"));
                  _ADDITEM(pDos1->e_sp,       pDos2->e_sp,      TEXT("e_sp"));
                  _ADDITEM(pDos1->e_csum,     pDos2->e_csum,    TEXT("e_csum"));
                  _ADDITEM(pDos1->e_ip,       pDos2->e_ip,      TEXT("e_ip"));
                  _ADDITEM(pDos1->e_cs,       pDos2->e_cs,      TEXT("e_cs"));
                  _ADDITEM(pDos1->e_lfarlc,   pDos2->e_lfarlc,  TEXT("e_lfarlc"));
                  _ADDITEM(pDos1->e_ovno,     pDos2->e_ovno,    TEXT("e_ovno"));
                  _ADDITEM(pDos1->e_oemid,    pDos2->e_oemid,   TEXT("e_oemid"));
                  _ADDITEM(pDos1->e_oeminfo,  pDos2->e_oeminfo, TEXT("e_oeminfo"));
                  _ADDITEM(pDos1->e_lfanew,   pDos2->e_lfanew,  TEXT("e_lfanew"));
                  {
                    IMAGE_NT_HEADERS* pNt1 = (IMAGE_NT_HEADERS*)((TCHAR*)pMemS + pDos1->e_lfanew), \
                                    * pNt2 = (IMAGE_NT_HEADERS*)((TCHAR*)pMem + pDos2->e_lfanew);
                    _ListView_AddItem(hCtrl,i++,0,0,0,TEXT("NT Headers"),1);
                    _ADDITEM(pNt1->Signature,pNt2->Signature,TEXT("Signature"));
                    _ListView_AddItem(hCtrl,i++,0,0,0,TEXT("File Header"),1);
                    _ADDITEM(pNt1->FileHeader.Machine,              pNt2->FileHeader.Machine,             TEXT("Machine"));
                    _ADDITEM(pNt1->FileHeader.NumberOfSections,     pNt2->FileHeader.NumberOfSections,    TEXT("NumberOfSections"));
                    _ADDITEM(pNt1->FileHeader.TimeDateStamp,        pNt2->FileHeader.TimeDateStamp,       TEXT("TimeDateStamp"));
                    _ADDITEM(pNt1->FileHeader.PointerToSymbolTable, pNt2->FileHeader.PointerToSymbolTable,TEXT("PointerToSymbolTable"));
                    _ADDITEM(pNt1->FileHeader.NumberOfSymbols,      pNt2->FileHeader.NumberOfSymbols,     TEXT("NumberOfSymbols"));
                    _ADDITEM(pNt1->FileHeader.SizeOfOptionalHeader, pNt2->FileHeader.SizeOfOptionalHeader,TEXT("SizeOfOptionalHeader"));
                    _ADDITEM(pNt1->FileHeader.Characteristics,      pNt2->FileHeader.Characteristics,     TEXT("Characteristics"));
                    _ListView_AddItem(hCtrl,i++,0,0,0,TEXT("Optional Header"),1);
                    _ADDITEM(pNt1->OptionalHeader.Magic,                        pNt2->OptionalHeader.Magic,                       TEXT("Magic"));
                    _ADDITEM(pNt1->OptionalHeader.MajorLinkerVersion,           pNt2->OptionalHeader.MajorLinkerVersion,          TEXT("MajorLinkerVersion"));
                    _ADDITEM(pNt1->OptionalHeader.MinorLinkerVersion,           pNt2->OptionalHeader.MinorLinkerVersion,          TEXT("MinorLinkerVersion"));
                    _ADDITEM(pNt1->OptionalHeader.SizeOfCode,                   pNt2->OptionalHeader.SizeOfCode,                  TEXT("SizeOfCode"));
                    _ADDITEM(pNt1->OptionalHeader.SizeOfInitializedData,        pNt2->OptionalHeader.SizeOfInitializedData,       TEXT("SizeOfInitializedData"));
                    _ADDITEM(pNt1->OptionalHeader.SizeOfUninitializedData,      pNt2->OptionalHeader.SizeOfUninitializedData,     TEXT("SizeOfUninitializedData"));
                    _ADDITEM(pNt1->OptionalHeader.AddressOfEntryPoint,          pNt2->OptionalHeader.AddressOfEntryPoint,         TEXT("AddressOfEntryPoint"));
                    _ADDITEM(pNt1->OptionalHeader.BaseOfCode,                   pNt2->OptionalHeader.BaseOfCode,                  TEXT("BaseOfCode"));
                    _ADDITEM(pNt1->OptionalHeader.BaseOfData,                   pNt2->OptionalHeader.BaseOfData,                  TEXT("BaseOfData"));
                    _ADDITEM(pNt1->OptionalHeader.ImageBase,                    pNt2->OptionalHeader.ImageBase,                   TEXT("ImageBase"));
                    _ADDITEM(pNt1->OptionalHeader.SectionAlignment,             pNt2->OptionalHeader.SectionAlignment,            TEXT("SectionAlignment"));
                    _ADDITEM(pNt1->OptionalHeader.FileAlignment,                pNt2->OptionalHeader.FileAlignment,               TEXT("FileAlignment"));
                    _ADDITEM(pNt1->OptionalHeader.MajorOperatingSystemVersion,  pNt2->OptionalHeader.MajorOperatingSystemVersion, TEXT("MajorOperatingSystemVersion"));
                    _ADDITEM(pNt1->OptionalHeader.MinorOperatingSystemVersion,  pNt2->OptionalHeader.MinorOperatingSystemVersion, TEXT("MinorOperatingSystemVersion"));
                    _ADDITEM(pNt1->OptionalHeader.MajorImageVersion,            pNt2->OptionalHeader.MajorImageVersion,           TEXT("MajorImageVersion"));
                    _ADDITEM(pNt1->OptionalHeader.MinorImageVersion,            pNt2->OptionalHeader.MinorImageVersion,           TEXT("MinorImageVersion"));
                    _ADDITEM(pNt1->OptionalHeader.MajorSubsystemVersion,        pNt2->OptionalHeader.MajorSubsystemVersion,       TEXT("MajorSubsystemVersion"));
                    _ADDITEM(pNt1->OptionalHeader.MinorSubsystemVersion,        pNt2->OptionalHeader.MinorSubsystemVersion,       TEXT("MinorSubsystemVersion"));
                    _ADDITEM(pNt1->OptionalHeader.Win32VersionValue,            pNt2->OptionalHeader.Win32VersionValue,           TEXT("Win32VersionValue"));
                    _ADDITEM(pNt1->OptionalHeader.SizeOfImage,                  pNt2->OptionalHeader.SizeOfImage,                 TEXT("SizeOfImage"));
                    _ADDITEM(pNt1->OptionalHeader.SizeOfHeaders,                pNt2->OptionalHeader.SizeOfHeaders,               TEXT("SizeOfHeader"));
                    _ADDITEM(pNt1->OptionalHeader.CheckSum,                     pNt2->OptionalHeader.CheckSum,                    TEXT("CheckSum"));
                    _ADDITEM(pNt1->OptionalHeader.Subsystem,                    pNt2->OptionalHeader.Subsystem,                   TEXT("Subsystem"));
                    _ADDITEM(pNt1->OptionalHeader.DllCharacteristics,           pNt2->OptionalHeader.DllCharacteristics,          TEXT("DllCharacteristics"));
                    _ADDITEM(pNt1->OptionalHeader.SizeOfStackReserve,           pNt2->OptionalHeader.SizeOfStackReserve,          TEXT("SizeOfStackReserve"));
                    _ADDITEM(pNt1->OptionalHeader.SizeOfStackCommit,            pNt2->OptionalHeader.SizeOfStackCommit,           TEXT("SizeOfStackCommit"));
                    _ADDITEM(pNt1->OptionalHeader.SizeOfHeapReserve,            pNt2->OptionalHeader.SizeOfHeapReserve,           TEXT("SizeOfHeapReserve"));
                    _ADDITEM(pNt1->OptionalHeader.SizeOfHeapCommit,             pNt2->OptionalHeader.SizeOfHeapCommit,            TEXT("SizeOfHeapCommit"));
                    _ADDITEM(pNt1->OptionalHeader.LoaderFlags,                  pNt2->OptionalHeader.LoaderFlags,                 TEXT("LoaderFlags"));
                    _ADDITEM(pNt1->OptionalHeader.NumberOfRvaAndSizes,          pNt2->OptionalHeader.NumberOfRvaAndSizes,         TEXT("NumberOfRvaAndSizes"));
                    {
                      int ix = 0;
                      TCHAR buf[64] = {0};
                      for(ix;ix < 16;ix++){  
                        wsprintf(buf,TEXT("DataDirectory[%d]"),ix);
                        _ListView_AddItem(hCtrl,i++,0,0,0,buf,1);
                        _ADDITEM(pNt1->OptionalHeader.DataDirectory[ix].VirtualAddress,  pNt2->OptionalHeader.DataDirectory[ix].VirtualAddress, TEXT("VirtualAddress"));
                        _ADDITEM(pNt1->OptionalHeader.DataDirectory[ix].Size,            pNt2->OptionalHeader.DataDirectory[ix].Size,           TEXT("Size"));
                      }
                    }
                    _ListView_AddItem(hCtrl,i++,0,0,0,TEXT("Section Headers"),1);
                    { /* image sections */
                      int m = pNt1->FileHeader.NumberOfSections, \
                          n = pNt2->FileHeader.NumberOfSections,j,j_max;
                      IMAGE_SECTION_HEADER* pSec1 = (IMAGE_SECTION_HEADER*)((TCHAR*)pNt1 + pNt1->FileHeader.SizeOfOptionalHeader + sizeof(IMAGE_FILE_HEADER) + 4), \
                                          * pSec2 = (IMAGE_SECTION_HEADER*)((TCHAR*)pNt2 + pNt2->FileHeader.SizeOfOptionalHeader + sizeof(IMAGE_FILE_HEADER) + 4);
                      if(m > n)
                        j_max = m;
                      else
                        j_max = n;
                      for(j = 0;j < j_max;j++){
                        { /* Name */
                          int __tmp = 0;
                          LVITEM  __lvi = {0};
                          TCHAR sbuf[16] = {0};
                          if(lstrcmp(pSec1->Name,pSec2->Name))__tmp = 1;
                          __lvi.mask = LVIF_TEXT | LVIF_IMAGE;
                          __lvi.iItem = i;
                          __lvi.iSubItem = 0;
                          __lvi.pszText = TEXT("Name");
                          __lvi.iImage = __tmp;
                          ListView_InsertItem(hCtrl,&__lvi);
                          __lvi.mask = LVIF_TEXT;
                          lstrcpyn(sbuf,pSec1->Name,8);
                          __lvi.pszText = sbuf;
                          __lvi.iSubItem ++;
                          if(m)
                            ListView_SetItem(hCtrl,&__lvi);
                          lstrcpyn(sbuf,pSec2->Name,8);
                          __lvi.pszText = sbuf;
                          __lvi.iSubItem ++;
                          if(n)
                            ListView_SetItem(hCtrl,&__lvi);
                          i ++;
                        }
                        _ADDITEMX(pSec1->Misc.VirtualSize,     pSec2->Misc.VirtualSize,    TEXT("VirtualSize")          ,m,n);
                        _ADDITEMX(pSec1->VirtualAddress,       pSec2->VirtualAddress,      TEXT("VirtualAddress")       ,m,n);
                        _ADDITEMX(pSec1->SizeOfRawData,        pSec2->SizeOfRawData,       TEXT("SizeOfRawData")        ,m,n);
                        _ADDITEMX(pSec1->PointerToRawData,     pSec2->PointerToRawData,    TEXT("PointerToRawData")     ,m,n);
                        _ADDITEMX(pSec1->PointerToRelocations, pSec2->PointerToRelocations,TEXT("PointerToRelocations") ,m,n);
                        _ADDITEMX(pSec1->PointerToLinenumbers, pSec2->PointerToLinenumbers,TEXT("PointerToLinenumbers") ,m,n);
                        _ADDITEMX(pSec1->NumberOfRelocations,  pSec2->NumberOfRelocations, TEXT("NumberOfRelocations")  ,m,n);
                        _ADDITEMX(pSec1->NumberOfLinenumbers,  pSec2->NumberOfLinenumbers, TEXT("NumberOfLinenumbers")  ,m,n);
                        _ADDITEMX(pSec1->Characteristics,      pSec2->Characteristics,     TEXT("Characteristics")      ,m,n);
                        pSec1 = (IMAGE_SECTION_HEADER*)((TCHAR*)pSec1 + sizeof(IMAGE_SECTION_HEADER));
                        pSec2 = (IMAGE_SECTION_HEADER*)((TCHAR*)pSec2 + sizeof(IMAGE_SECTION_HEADER));
                        if(m > 0)m--;
                        if(n > 0)n--;
                      }
                    }
                  }
                }
                // pMem && pMemS
              }
              if(pMem)UnmapViewOfFile(pMem);
              if(pMemS)UnmapViewOfFile(pMemS);
            } // hFileMap && hFileMapS
            if(hFileMap)CloseHandle(hFileMap);
            if(hFileMapS)CloseHandle(hFileMapS);
          } // hFile && hFileS
          if(hFile != INVALID_HANDLE_VALUE)CloseHandle(hFile);
          if(hFileS != INVALID_HANDLE_VALUE)CloseHandle(hFileS);
        } else {
          EndDialog(hWnd,0);
        }
      }
    }
    break;
  case  WM_SIZE:
    {
      RECT rc = {0};
      if(GetClientRect(hWnd,&rc)){
        MoveWindow(GetDlgItem(hWnd,1),rc.left,rc.top,rc.right - rc.left,rc.bottom - rc.top,1);
      }
    }
    break;
  case  WM_CLOSE:
    {
      EndDialog(hWnd,0);
    }
    break;
  default:
    return 0;
  }
  return 1;
}
