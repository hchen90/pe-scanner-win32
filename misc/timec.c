#include <time.h>
#include <stdio.h>
#include <windows.h>

#pragma	comment(lib,"kernel32.lib")
#pragma	comment(lib,"user32.lib")

char* __stdcall Time_Decode2Str(const time_t* time_do)
{
	return asctime(gmtime(time_do));
}

time_t __stdcall Time_Decode2Stamp(struct tm* time_do)
{
	return	mktime(time_do);
}

int main(int argc,char* argv[])
{
	time_t var=time(0);
	struct tm time_do;
	
	if(argc==3){
		if(*argv[1]++=='-'){
			switch(*argv[1]++){
				case	's':
					memset(&time_do,0,sizeof(struct tm));
					sscanf(argv[2],"%lu/%lu/%lu/%02lu:%02lu:%02lu",&time_do.tm_mon,&time_do.tm_mday,&time_do.tm_year,&time_do.tm_hour,&time_do.tm_min,&time_do.tm_sec);
					time_do.tm_isdst=1;
					time_do.tm_year-=1900;
					time_do.tm_mon--;
					time_do.tm_hour+=8;
					printf("%08X",Time_Decode2Stamp(&time_do));
					break;
				case	't':
					sscanf(argv[2],"%08X",&var);
					printf("%s",Time_Decode2Str(&var));
					break;
			}
		}
	} else printf("TimeDateStamp Calculator\nCopyright (c) 2013 chenxiang\n\nUsage:\n\ttimec [-t]\\[-s] [TimeDateStamp]\\[[month]/[day]/[year]/[hour]:[minutes]:[second]]\n\nExample:\n\ttimec -t %08X\n\ttimec -s 4/5/2011/0:12:45\n\n",var);
	
	return 0;
}
