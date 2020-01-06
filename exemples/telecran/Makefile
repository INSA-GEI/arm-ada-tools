PROJECT_NAME = telecran

TARGET = $(PROJECT_NAME).elf
DEP_ADA = $(PROJECT_NAME).o 
DEP_ALI = 
DEP_ASM = 
DEP_C =

RESSOURCES_NAME = 

#############################################################################################################################
## Ne rien modifier sous cette ligne
##
## Do not modify anything under this line
#############################################################################################################################

ARM_ADA_COMPILER_PATH = /usr/local/insa/arm-ada
ARM_ADA_PATH = $(HOME)/arm-ada

LIBGNAT_PATH = $(ARM_ADA_COMPILER_PATH)/compilateur/gcc-arm-none-eabi/lib/gcc/arm-none-eabi/6.3.1/thumb/v7e-m/fpv4-sp/hard/adalib
LIBWRAPPER_PATH = $(ARM_ADA_PATH)/lib/wrapper/lib
LIBINSA_PATH =  $(ARM_ADA_PATH)/lib/lib-ada

OPTIONS = -gdwarf-2 -O0 --function-sections -march=armv7e-m -mthumb -mthumb-interwork -mfloat-abi=hard -mfpu=fpv4-sp-d16

.PHONY: all clean install ressources

all: $(TARGET)
	arm-none-eabi-objcopy -O ihex $(TARGET) $(PROJECT_NAME).hex
	arm-none-eabi-size $(TARGET)

# Say how to compile Ada programs.
.SUFFIXES: .ada .adb .ads .asm .S .ali

.ads.ali:
	arm-none-eabi-gcc $(OPTIONS) -I$(LIBINSA_PATH) -I$(LIBWRAPPER_PATH) -c $<

.adb.o:
	arm-none-eabi-gcc $(OPTIONS) -I$(LIBINSA_PATH) -I$(LIBWRAPPER_PATH) -c $<

.S.o:
	arm-none-eabi-gcc -c $<

.c.o:
	arm-none-eabi-gcc $(OPTIONS) -D STM32F30X_MD -I. -I$(LIBWRAPPER_PATH)/../c/CMSIS -I$(LIBWRAPPER_PATH)/../c -c $<

$(TARGET): $(DEP_ADA) $(DEP_ALI) $(DEP_ASM) $(DEP_C) $(ARM_ADA_PATH)/lib/linker-script-insa.ld 
	arm-none-eabi-gnatbind -I$(LIBINSA_PATH) -x $(PROJECT_NAME).ali
	arm-none-eabi-gcc -gdwarf-2 $(OPTIONS) -I$(LIBINSA_PATH) -I$(LIBWRAPPER_PATH) -o b~$(PROJECT_NAME).o -c b~$(PROJECT_NAME).adb
	arm-none-eabi-gcc -gdwarf-2 -march=armv7e-m -mthumb -mthumb-interwork -mfloat-abi=hard -mfpu=fpv4-sp-d16 -Wl,-Map="ada-program.map" -Wl,--gc-sections -Wl,--gc-section -T $(ARM_ADA_PATH)/lib/linker-script-insa.ld -o $(TARGET) *.o $(LIBWRAPPER_PATH)/retarget.o -nostartfiles -nodefaultlibs -L $(LIBWRAPPER_PATH) -L $(LIBINSA_PATH) -L $(LIBGNAT_PATH) -lgnat -lc -ladainsa -lwrapper

clean:
	rm -f *.s $(RESSOURCES_NAME).o $(RESSOURCES_NAME).ali $(PROJECT_NAME).o b~*.* $(TARGET) $(PROJECT_NAME).hex *.o *.ali ada-program.map

install:
	flashprog $(PROJECT_NAME).hex

ressources:
ifdef RESSOURCES_NAME
	rca $(RESSOURCES_NAME).job
	arm-none-eabi-gcc $(OPTIONS) -I$(LIBINSA_PATH) -I$(LIBWRAPPER_PATH) -c $(RESSOURCES_NAME).ads
endif
