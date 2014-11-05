// copyright(c)2014 Hsiang Chen

#include <windows.h>

/*
 * -<-------------------
 * |                   |
 * |                   |
 * -----#------------->-
 *      |
 *      rec_pt
 **/

#define NUMMAX      5
#define COMMANDID   3600
#define RECMID      801

typedef struct _RECENTINFO {
  TCHAR szFileName[MAX_PATH];
  DWORD dwCommand;
  DWORD dwReserve;
}RECENTINFO;

static RECENTINFO  rec_queue[NUMMAX] = {0};
static int         rec_pt = 0;
static DWORD       rec_menuid = COMMANDID;

int WINAPI  _GetProfilePath(TCHAR* buf);
int WINAPI  _ScanPE(LPVOID lParam);

int WINAPI  _AddFileToList(TCHAR* filename,HMENU menu)
{
  int i = 0;
  HMENU hSubMenu = 0;
  TCHAR buf[MAX_PATH] = {0};
  _GetProfilePath(buf);
  if(GetPrivateProfileInt(TEXT("Misc"),TEXT("recent_files_enable"),0,buf)){
    if(lstrlen(filename) > 0 && menu){
      for(;i < NUMMAX;i++){
        if(!lstrcmp(filename,rec_queue[i].szFileName))return 1;
      }
      lstrcpyn(rec_queue[rec_pt].szFileName,filename,MAX_PATH);
      rec_queue[rec_pt].dwCommand = rec_menuid;
      EnableMenuItem(menu,RECMID,MF_ENABLED | MF_BYCOMMAND);
      hSubMenu = GetSubMenu(GetSubMenu(menu,0),6);
      if(hSubMenu){
        if(GetMenuItemCount(hSubMenu) + 1 > 7 /* rec_menuid + 1 >= COMMANDID + NUMMAX */ ){
          RemoveMenu(hSubMenu,2,MF_BYPOSITION);
        }
        AppendMenu(hSubMenu,MF_STRING,rec_menuid,filename);
      }
      rec_pt = (rec_pt + 1) % NUMMAX;
      rec_menuid = COMMANDID + ((rec_menuid + 1 - COMMANDID) % NUMMAX);
    } else return 1;
  } else {
    EnableMenuItem(menu,RECMID,MF_DISABLED | MF_GRAYED | MF_BYCOMMAND);
    return 1;
  }
  return 0;
}

int WINAPI  _RespRecentsMenu(HWND hWnd,WPARAM wParam,LPARAM lParam) /* put this function to message callback routine */
{
  if(LOWORD(wParam) >= COMMANDID && LOWORD(wParam) <= COMMANDID + NUMMAX){
    int i = 0;
    for(i;i < NUMMAX;i++){
      if(rec_queue[i].dwCommand == LOWORD(wParam)){
        _ScanPE(rec_queue[i].szFileName);
      }
    }
  }
  return 0;
}

int WINAPI  _WriteRecentsMenu()
{
  TCHAR buf[MAX_PATH] = {0};
  _GetProfilePath(buf);
  if(GetPrivateProfileInt(TEXT("Misc"),TEXT("recent_files_enable"),0,buf)){ // only write recents profile, if it is enabled.
    int i = rec_pt;
    for(i;i < rec_pt + NUMMAX;i++){
      TCHAR tbf[16] = {0};
      wsprintf(tbf,TEXT("%d"),i - rec_pt);
      WritePrivateProfileString(TEXT("Recents"),tbf,rec_queue[i % NUMMAX].szFileName,buf);
    }
  }
  return 0;
}

int WINAPI  _ConstructRecentsMenu(HMENU menu)
{
  TCHAR buf[MAX_PATH] = {0};
  _GetProfilePath(buf);
  if(GetPrivateProfileInt(TEXT("Misc"),TEXT("recent_files_enable"),0,buf)){ // likewise
    EnableMenuItem(menu,RECMID,MF_ENABLED | MF_BYCOMMAND);
    {
      HMENU hSubMenu = GetSubMenu(GetSubMenu(menu,0),6);
      if(hSubMenu){
        int i = 0;
        TCHAR tbf[MAX_PATH] = {0};
        for(i;i < NUMMAX;i++){
          TCHAR nbf[MAX_PATH] = {0};
          wsprintf(nbf,TEXT("%d"),i);
          if(GetPrivateProfileString(TEXT("Recents"),nbf,TEXT(""),tbf,sizeof(tbf),buf)){
            lstrcpyn(rec_queue[rec_pt].szFileName,tbf,MAX_PATH);
            rec_queue[rec_pt].dwCommand = rec_menuid;
            AppendMenu(hSubMenu,MF_STRING,rec_menuid,tbf);
            rec_pt = (rec_pt + 1) % NUMMAX;
            rec_menuid = COMMANDID + ((rec_menuid + 1 - COMMANDID) % NUMMAX);
          }
        }
      }
    }
  }
  return 0;
}
