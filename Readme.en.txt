% An Introduction to PE Scanner:

----------------------------------------------------------------

The tool,PE Scanner,is programmed for hacking Microsoft Portable
Executable File. It'll output plenty of detailed information of 
PE-file after processed. And support Modification on PE-file.
The latest version have already supportted x86_64 flatform 
PE-file. 

% How to build this software:

----------------------------------------------------------------

You have to install two SDKs, if you want to build all sources.
The first one is MS-SDK, you can get it from Microsoft Website.
This MS-SDK is mainly to compileing the source based on C.
Standard MS-SDK not only support high level language, but also 
include the tools, such as ML.EXE, LINK.EXE, LIB.EXE, for 
compileing and linking source based on assembly language. 
Unfortunately, it not include the header file, based on assembly
language. MASM32(http://www.masm32.com/) include the ASM-header .
We only need the files on the directory,"include", in MASM32 SDK. 
(if your MS-SDK not include the ASM-tools,ML.EXE,you need bound 
the directory,"bin",in MASM32 SDK, to your environment variable,
PATH)
We can compile source through MS-SDK bounded command line after 
add the ASM-header or ASM-include to environment variable,INCLUDE.

After all source(include ASM and C) compiled into objectives.
Using MS-SDK to link all objectives into Executable, if you don't
want see some errors, like " ...unknown symbol ...".
Entering command line. Using "set" command to bound 
some variables based on command line, such as INCLUDE, LIB.
Then running my makefile, "Makefile.mak"
(nmake -nologo -f Makefile.mak all).


