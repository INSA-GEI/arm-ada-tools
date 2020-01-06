LIBRARY_NAME = libadainsa

TARGET = $(LIBRARY_NAME).a
DEP_ADA = insa-graphics.o insa-sensors.o insa-graphics-ui.o\
          insa-graphics-images.o insa-graphics-advanced.o insa-timer.o\
          insa-keys.o insa-led.o insa-random_number.o insa-audio.o\
          insa-memory.o insa.o insa-audio-synthetiser.o
DEP_ALI = 
DEP_ASM = 
DEP_C = 

OPTIONS = -gdwarf-2 -O3 --function-sections --data-sections 

.PHONY: all clean 

all: $(TARGET)
	ar r $(TARGET) *.o

# Say how to compile Ada programs.
.SUFFIXES: .ada .adb .ads .asm .S .ali

.ads.ali:
	gcc $(OPTIONS) -I. -c $<

.adb.o:
	gcc $(OPTIONS) -I. -c $<

.S.o:
	gcc -c $<

.c.o:
	gcc $(OPTIONS) -D STM32F30X_MD -I. -Ic/CMSIS -Ic -c $<

$(TARGET): $(DEP_ADA) $(DEP_ALI) $(DEP_ASM) $(DEP_C) 

clean:
	rm -f *.o *.ali *.o $(TARGET) 
