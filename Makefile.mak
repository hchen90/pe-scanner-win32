# @Makefile.mak
# copyright(c)2014 chenxiang
#

PES_BIN		=PES.EXE
PES_OBJS	=code.obj md5.obj recents.obj chardlgep.obj exports.obj taskandimports.obj rsrc.res
VERSION		=

all:$(PES_BIN)

$(PES_BIN):$(PES_OBJS)
	link /nologo /def:"code.def" /out:"$(PES_BIN)" /subsystem:windows /section:.text,wer $(PES_OBJS)

.asm.obj:
	ml /c /nologo /coff /Fo"$@" $<

clean:
	del *.exe *.obj *.res *.lib *.exp *.pdb

dist:
	zip pe-scanner-bin-v$(VERSION).zip -r .\*.EXE .\*.Dll .\*.TXT .\plugins\*.* -x *.exp -x *.obj -x *.pdb -x *.res -x *.zip
	zip pe-scanner-src-v$(VERSION).zip -r *.* -x *.obj -x *.exp -x *.dll -x *.exe -x *.res -x *.zip

distclean:	clean
	del *.zip