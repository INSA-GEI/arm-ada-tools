LIBRARY_NAME = libwrapper

TARGET = $(LIBRARY_NAME).a
DEP_ADA = 
DEP_ALI =  
DEP_ASM = 
DEP_C = c/retarget.o c/api.o

OPTIONS = -gdwarf-2 -O3 --function-sections --data-sections

.PHONY: all clean 

all: $(TARGET)
	ar r lib/$(TARGET) *.o
	mv *.o lib

# Say how to compile Ada programs.
.SUFFIXES: .ada .adb .ads .asm .S .ali

.ads.ali:
	gcc $(OPTIONS) -Ic -c $<

.adb.o:
	gcc $(OPTIONS) -Ic -c $<

.S.o:
	gcc -c $<

.c.o:
	gcc $(OPTIONS) -I. -Ic -c $<

$(TARGET): $(DEP_ADA) $(DEP_ALI) $(DEP_ASM) $(DEP_C) 

clean:
	rm -f lib/*.s *.o c/*.o .o lib/* lib/$(TARGET) 
