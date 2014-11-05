BIN		=	unpecompact2.dll
OBJ		=	unpecompact2.obj
EXP		=	unpecompact2.def
RSR		=	rsrc.res
BIN1	=	timec.exe
OBJ1	=	timec.obj

all: $(BIN) $(BIN1)

$(BIN):$(OBJ) $(RSR)
	link /out:"$(BIN)" /nologo /dll /def:"$(EXP)" $(OBJ) $(RSR)
	
$(BIN1):$(OBJ1)
	link /out:"$@" /nologo $(OBJ1)

clean:
	del *.exe *.obj *.res *.dll *.exp *.lib
