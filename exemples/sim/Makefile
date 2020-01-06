PROJECT_NAME = hello

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

ARM_ADA_PATH = /usr/local/arm-ada
LIBGNAT_PATH = /usr/lib/gcc/x86_64-linux-gnu/6/adalib/
LIBWRAPPER_PATH = ./wrapper/lib
LIBINSA_PATH =  ./lib-appli

OPTIONS = -gdwarf-2 -O3 --function-sections --data-sections 

.PHONY: all clean install ressources

all: $(TARGET)
	objcopy -O ihex $(TARGET) $(PROJECT_NAME).hex
	size $(TARGET)

# Say how to compile Ada programs.
.SUFFIXES: .ada .adb .ads .asm .S .ali

.ads.ali:
	gcc $(OPTIONS) -I$(LIBINSA_PATH) -I$(LIBWRAPPER_PATH) -c $<

.adb.o:
	gcc $(OPTIONS) -I$(LIBINSA_PATH) -I$(LIBWRAPPER_PATH) -c $<

.S.o:
	gcc -c $<

.c.o:
	gcc $(OPTIONS) -D STM32F30X_MD -I. -I$(LIBWRAPPER_PATH)/../c/CMSIS -I$(LIBWRAPPER_PATH)/../c -c $<

$(TARGET): $(DEP_ADA) $(DEP_ALI) $(DEP_ASM) $(DEP_C)
	gnatbind -I$(LIBINSA_PATH) -x $(PROJECT_NAME).ali
	gcc -gdwarf-2 $(OPTIONS) -I$(LIBINSA_PATH) -I$(LIBWRAPPER_PATH) -o b~$(PROJECT_NAME).o -c b~$(PROJECT_NAME).adb
	gcc -gdwarf-2 -Wl,-Map="ada-program.map" -Wl,--gc-sections -Wl,--gc-section -o $(TARGET) *.o $(LIBWRAPPER_PATH)/retarget.o ./lib-appli/*.o -L $(LIBWRAPPER_PATH)  -L $(LIBGNAT_PATH) -lgnat -lc -lwrapper

clean:
	rm -f *.s $(RESSOURCES_NAME).o $(RESSOURCES_NAME).ali $(PROJECT_NAME).o b~*.* $(TARGET) $(PROJECT_NAME).hex *.o *.ali ada-program.map

install:
	flashprog $(PROJECT_NAME).hex

ressources:
ifdef RESSOURCES_NAME
	rca $(RESSOURCES_NAME).job
	arm-none-eabi-gcc $(OPTIONS) -I$(LIBINSA_PATH) -I$(LIBWRAPPER_PATH) -c $(RESSOURCES_NAME).ads
endif
