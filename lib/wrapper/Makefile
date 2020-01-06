LIBRARY_NAME = libwrapper

TARGET = $(LIBRARY_NAME).a
DEP_ASM = c/startup.o
DEP_C = c/retarget.o c/api.o

OPTIONS = -gdwarf-2 -O3 --function-sections --data-sections -march=armv7e-m -mthumb -mthumb-interwork -mfloat-abi=hard -mfpu=fpv4-sp-d16

.PHONY: all clean 

all: $(TARGET)
	if [ ! -d lib ]; then \
	mkdir -v lib ;        \
	fi
	
	arm-none-eabi-ar r lib/$(TARGET) *.o
	mv *.o lib

# Say how to compile Ada programs.
.SUFFIXES: .c .asm .S 

.S.o:
	arm-none-eabi-gcc -c $<

.c.o:
	arm-none-eabi-gcc $(OPTIONS) -D STM32F30X_MD -I. -Ic/CMSIS -Ic -c $<

$(TARGET): $(DEP_ASM) $(DEP_C) 

clean:
	rm -f lib/*.s *.o c/*.o .o lib/* lib/$(TARGET) 
