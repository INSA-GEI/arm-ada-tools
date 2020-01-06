LIBRARY_NAME = libadainsa

TARGET = $(LIBRARY_NAME).a
DEP_ADA = insa-graphics.o insa-sensors.o insa-graphics-ui.o\
          insa-graphics-images.o insa-graphics-advanced.o insa-timer.o\
          insa-keys.o insa-led.o insa-random_number.o insa-audio.o\
          insa-memory.o insa.o insa-audio-synthesizer.o
DEP_ALI = 
DEP_ASM = 
DEP_C = 

OPTIONS = -gdwarf-2 -O3 --function-sections --data-sections -march=armv7e-m -mthumb -mthumb-interwork -mfloat-abi=hard -mfpu=fpv4-sp-d16

.PHONY: all clean 

all: $(TARGET)
	arm-none-eabi-ar r $(TARGET) *.o

# Say how to compile Ada programs.
.SUFFIXES: .ada .adb .ads .asm .S .ali

.ads.ali:
	arm-none-eabi-gcc $(OPTIONS) -I. -c $<

.adb.o:
	arm-none-eabi-gcc $(OPTIONS) -I. -c $<

.S.o:
	arm-none-eabi-gcc -c $<

.c.o:
	arm-none-eabi-gcc $(OPTIONS) -D STM32F30X_MD -I. -Ic/CMSIS -Ic -c $<

$(TARGET): $(DEP_ADA) $(DEP_ALI) $(DEP_ASM) $(DEP_C) 

clean:
	rm -f *.o *.ali *.o $(TARGET) 
