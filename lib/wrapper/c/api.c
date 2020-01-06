#include "stm32f30x.h"
#include "api.h"

/* Penser a changer aussi la constante dans startup.S !!!!*/
#define ABI_VERSION 7

struct ABI_Table_ST
{
	char magic_str[4];
	unsigned int version;
	void *ptr;
};

typedef struct ABI_Table_ST ABI_Table_Type;

void** API_Ptr_Table;
uint32_t* IT_Ptr;
ABI_Table_Type* ABI_Table;
void _emergency_exit(int code);
void *Saved_SP;
extern void* __bss_end__;
extern char* sbrk_buffer;

__attribute__( ( always_inline ) ) __STATIC_INLINE uint32_t __get_bss_end(void)
{
 uint32_t result;

  __ASM volatile ("LDR %0, =__bss_end__" : "=r" (result) );
  return(result);
}

int API_Init(void)
{
volatile uint32_t result;

	IT_Ptr=(void*)(0x8040000-4);
	ABI_Table = (ABI_Table_Type*)(*IT_Ptr);
	API_Ptr_Table = (void*)(ABI_Table->ptr);

	/* Si le system a une version d'ABI inferieur à notre appli, elle ne peut pas s'executer -> mise a jour du system necessaire */
	if (ABI_Table->version<ABI_VERSION) return INVALID_ABI;
	
	if (ABI_Table->version<0xF0) {
		/* Resize heap */
		result = __get_bss_end();
		//C_malloc_Init(result);
		sbrk_buffer=(char*)result;
	}
	else
	{
		sbrk_buffer=(char*)(0xC0000000+0x300000);
	}
	return 0;
}

void API_EmergencyExit(int errcode)
{
	_emergency_exit(errcode);
}

/* Basic OS services */
void API_GetOSVersion(int* major, int* minor)
{
void (*ptrFunc)(int* major, int* minor);

	ptrFunc = (void (*)(int* major, int* minor))API_Ptr_Table[API_GetOSVersion_Index];
	ptrFunc(major, minor);
}

void C_Delay(uint32_t duration)
{
void (*ptrFunc)(uint32_t duration);

	ptrFunc = (void (*)(uint32_t duration))API_Ptr_Table[Delay_Index];
	ptrFunc(duration);
}

/*int C_fputc(int c, C_FILE *f)
{
int (*ptrFunc)(int c, C_FILE *f);

	ptrFunc = (int (*)(int c, C_FILE *f))API_Ptr_Table[fputc_Index];
	return (ptrFunc(c, f));
}

int C_fgetc(C_FILE *f)
{
int (*ptrFunc)(C_FILE *f);

	ptrFunc = (int (*)(C_FILE *f))API_Ptr_Table[fgetc_Index];
	return (ptrFunc(f));
}*/

int C_write(int fd, char *ptr, int len)
{
int (*ptrFunc)(int fd, char *ptr, int len);

	ptrFunc = (int (*)(int fd, char *ptr, int len))API_Ptr_Table[fwrite_Index];
	return (ptrFunc(fd, ptr, len));
}

int C_read(int fd, char *ptr, int len)
{
int (*ptrFunc)(int fd, char *ptr, int len);

	ptrFunc = (int (*)(int fd, char *ptr, int len))API_Ptr_Table[fread_Index];
	return (ptrFunc(fd,ptr,len));
}

/*
void *C_malloc(int size)
{
void* (*ptrFunc)(int size);

	ptrFunc = (void* (*)(int size))API_Ptr_Table[malloc_Index];
	return (ptrFunc(size));
}

void C_malloc_Init(uint32_t lowerAddr)
{
void (*ptrFunc)(uint32_t lowerAddr);

	ptrFunc = (void (*)(uint32_t lowerAddr))API_Ptr_Table[malloc_Init_Index];
	ptrFunc(lowerAddr);
}

void C_free(void* ptr)
{
void (*ptrFunc)(void* ptr);

	ptrFunc = (void (*)(void* ptr))API_Ptr_Table[free_Index];
	ptrFunc(ptr);
}
*/

void GLCD_SetTextColor(COLOR color)
{
void (*ptrFunc)(uint16_t color);

	ptrFunc = (void (*)(uint16_t color))API_Ptr_Table[GLCD_SetTextColor_Index];
	ptrFunc(color);
}

void GLCD_SetBackColor(COLOR color)
{
void (*ptrFunc)(uint16_t color);

	ptrFunc = (void (*)(uint16_t color))API_Ptr_Table[GLCD_SetBackColor_Index];
	ptrFunc(color);
}

void GLCD_Clear(COLOR color)
{
void (*ptrFunc)(uint16_t color);

	ptrFunc = (void (*)(uint16_t color))API_Ptr_Table[GLCD_Clear_Index];
	ptrFunc(color);
}

void GLCD_DrawADAString(uint32_t x, uint32_t y, uint32_t len, const char *str)
{
void (*ptrFunc)(uint32_t x, uint32_t y, uint32_t len, const char *str);

	ptrFunc = (void (*)(uint32_t x, uint32_t y, uint32_t len, const char *str))API_Ptr_Table[GLCD_DrawADAString_Index];
	ptrFunc(x, y, len, str);
}

void GLCD_DrawLine(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2)
{
void (*ptrFunc)(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2);

	ptrFunc = (void (*)(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2))API_Ptr_Table[GLCD_DrawLine_Index];
	ptrFunc(x1, y1, x2, y2);
}

void GLCD_DrawRectangle(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2)
{
void (*ptrFunc)(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2);

	ptrFunc = (void (*)(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2))API_Ptr_Table[GLCD_DrawRectangle_Index];
	ptrFunc(x1, y1, x2, y2);
}

void GLCD_DrawFillRectangle(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2)
{
void (*ptrFunc)(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2);

	ptrFunc = (void (*)(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2))API_Ptr_Table[GLCD_DrawFillRectangle_Index];
	ptrFunc(x1, y1, x2, y2);
}

void GLCD_DrawCircle(uint32_t x1, uint32_t y1, uint32_t radius)
{
void (*ptrFunc)(uint32_t x1, uint32_t y1, uint32_t radius);

	ptrFunc = (void (*)(uint32_t x1, uint32_t y1, uint32_t radius))API_Ptr_Table[GLCD_DrawCircle_Index];
	ptrFunc(x1, y1, radius);
}

void GLCD_DrawFillCircle(uint32_t x1, uint32_t y1, uint32_t radius)
{
void (*ptrFunc)(uint32_t x1, uint32_t y1, uint32_t radius);

	ptrFunc = (void (*)(uint32_t x1, uint32_t y1, uint32_t radius))API_Ptr_Table[GLCD_DrawFillCircle_Index];
	ptrFunc(x1, y1, radius);
}

void GLCD_PutPixel(uint32_t x, uint32_t y, COLOR color)
{
void (*ptrFunc)(uint32_t x, uint32_t y, uint16_t color);

	ptrFunc = (void (*)(uint32_t x, uint32_t y, uint16_t color))API_Ptr_Table[GLCD_PutPixel_Index];
	ptrFunc(x, y, color);
}

void GLCD_DrawImage(COLOR* data, uint32_t x, uint32_t y, uint32_t w, int32_t h)
{
void (*ptrFunc)(COLOR* data, uint32_t x, uint32_t y, uint32_t w, int32_t h);

	ptrFunc = (void (*)(COLOR* data, uint32_t x, uint32_t y, uint32_t w, int32_t h))API_Ptr_Table[GLCD_DrawImage_Index];
	ptrFunc(data, x, y, w, h);
}

int KEYS_GetState(int key_id)
{
int (*ptrFunc)(int key_id);

	ptrFunc = (int (*)(int key_id))API_Ptr_Table[KEYS_GetState_Index];
	return(ptrFunc(key_id));
}

uint8_t POT_GetValue(int pot_id)
{
uint8_t (*ptrFunc)(int pot_id);

	ptrFunc = (uint8_t (*)(int pot_id))API_Ptr_Table[POT_GetValue_Index];
	return(ptrFunc(pot_id));
}

void GUI_ProgressBar(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint8_t val, uint8_t maxval)
{
void (*ptrFunc)(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint8_t val, uint8_t maxval);

	ptrFunc = (void (*)(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint8_t val, uint8_t maxval))API_Ptr_Table[GUI_ProgressBar_Index ];
	ptrFunc(x,y,w,h,val,maxval);
}

void GUI_CenterBar(uint16_t x, uint16_t y, uint16_t w, uint16_t h, int val, uint32_t maxval)
{
void (*ptrFunc)(uint16_t x, uint16_t y, uint16_t w, uint16_t h, int val, uint32_t maxval);

	ptrFunc = (void (*)(uint16_t x, uint16_t y, uint16_t w, uint16_t h, int val, uint32_t maxval))API_Ptr_Table[GUI_CenterBar_Index ];
	ptrFunc(x,y,w,h,val,maxval);
}

void LED_Set(LED_STATE state)
{
void (*ptrFunc)(LED_STATE state);

	ptrFunc = (void (*)(LED_STATE state))API_Ptr_Table[LED_Set_Index];
	ptrFunc(state);
}

uint16_t RNG_GetValue(void)
{
uint16_t (*ptrFunc)(void);

	ptrFunc = (uint16_t (*)(void))API_Ptr_Table[RNG_GetValue_Index];
	return(ptrFunc());
}

void AUDIO_Start(void)
{
void (*ptrFunc)(void);

	ptrFunc = (void (*)(void))API_Ptr_Table[AUDIO_Start_Index];
	ptrFunc();
}

void AUDIO_Stop(void)
{
void (*ptrFunc)(void);

	ptrFunc = (void (*)(void))API_Ptr_Table[AUDIO_Stop_Index];
	ptrFunc();
}

void AUDIO_FillBuffer(int buffer_nbr, uint8_t* buffer)
{
void (*ptrFunc)(int buffer_nbr, uint8_t* buffer);

	ptrFunc = (void (*)(int buffer_nbr, uint8_t* buffer))API_Ptr_Table[AUDIO_FillBuffer_Index];
	ptrFunc(buffer_nbr, buffer);
}

void AUDIO_SetEventCallback(AUDIO_EventCallback callback)
{
void (*ptrFunc)(AUDIO_EventCallback callback);

	ptrFunc = (void (*)(AUDIO_EventCallback callback))API_Ptr_Table[AUDIO_SetEventCallback_Index];
	ptrFunc(callback);
}

float* L3GD20_GetGyroscopicValues (void)
{
float* (*ptrFunc)(void);

	ptrFunc = (float* (*)(void))API_Ptr_Table[L3GD20_GetGyroscopicValues_Index];
	return(ptrFunc());
}

float* LSM303DLHC_GetMagneticValues (void)
{
float* (*ptrFunc)(void);

	ptrFunc = (float* (*)(void))API_Ptr_Table[LSM303DLHC_GetMagneticValues_Index];
	return(ptrFunc());
}

float* LSM303DLHC_GetAccelerometerValues(void)
{
float* (*ptrFunc)(void);

	ptrFunc = (float* (*)(void))API_Ptr_Table[LSM303DLHC_GetAccelerometerValues_Index];
	return(ptrFunc());
}

uint8_t SRAM_ReadByte(uint32_t addr)
{
uint8_t (*ptrFunc)(uint32_t addr);

        ptrFunc = (uint8_t (*)(uint32_t addr))API_Ptr_Table[SRAM_ReadByte_Index];
	return(ptrFunc(addr));
}

void SRAM_WriteByte(uint32_t addr, uint8_t data)
{
void (*ptrFunc)(uint32_t addr, uint8_t data);

	ptrFunc = (void (*)(uint32_t addr, uint8_t data))API_Ptr_Table[SRAM_WriteByte_Index];
	ptrFunc(addr, data);
}

void SRAM_ReadBuffer(uint32_t addr, uint8_t *buffer, int length)
{
void (*ptrFunc)(uint32_t addr, uint8_t *buffer, int length);

	ptrFunc = (void (*)(uint32_t addr, uint8_t *buffer, int length))API_Ptr_Table[SRAM_ReadBuffer_Index];
	ptrFunc(addr, buffer, length);
}

void SRAM_WriteBuffer(uint32_t addr, uint8_t *buffer, int length)
{
void (*ptrFunc)(uint32_t addr, uint8_t *buffer, int length);

	ptrFunc = (void (*)(uint32_t addr, uint8_t *buffer, int length))API_Ptr_Table[SRAM_WriteBuffer_Index];
	ptrFunc(addr, buffer, length);
}

int TIMER_Start(void)
{
int (*ptrFunc)(void);

	ptrFunc = (int (*)(void))API_Ptr_Table[TIMER_Start_Index];
	return(ptrFunc());
}

void TIMER_Stop(void)
{
void (*ptrFunc)(void);

	ptrFunc = (void (*)(void))API_Ptr_Table[TIMER_Stop_Index];
	ptrFunc();
}

void TIMER_SetEventCallback(TIMER_EventCallback callback)
{
void (*ptrFunc)(TIMER_EventCallback callback);

	ptrFunc = (void (*)(TIMER_EventCallback callback))API_Ptr_Table[TIMER_SetEventCallback_Index];
	ptrFunc(callback);
}

void GLCD_DrawImagefromSRAM (uint32_t SRAM_Ptr, uint32_t x, uint32_t y, uint32_t w, int32_t h)
{
void (*ptrFunc)(uint32_t SRAM_Ptr, uint32_t x, uint32_t y, uint32_t w, int32_t h);

	ptrFunc = (void (*)(uint32_t SRAM_Ptr, uint32_t x, uint32_t y, uint32_t w, int32_t h))API_Ptr_Table[GLCD_DrawImagefromSRAM_Index];
	ptrFunc(SRAM_Ptr, x, y, w, h);
}

void GLCD_SetScrollWindow (uint32_t x, uint32_t y, uint32_t w, uint32_t h)
{
void (*ptrFunc)(uint32_t x, uint32_t y, uint32_t w, uint32_t h);

	ptrFunc = (void (*)(uint32_t x, uint32_t y, uint32_t w, uint32_t h))API_Ptr_Table[GLCD_SetScrollWindow_Index];
	ptrFunc(x, y, w, h);
}

void GLCD_ScrollVertical (uint32_t dy)
{
void (*ptrFunc)(uint32_t dy);

	ptrFunc = (void (*)(uint32_t dy))API_Ptr_Table[GLCD_ScrollVertical_Index];
	ptrFunc(dy);
}

void GLCD_ScrollHorizontal (uint32_t dy)
{
void (*ptrFunc)(uint32_t dy);

	ptrFunc = (void (*)(uint32_t dy))API_Ptr_Table[GLCD_ScrollHorizontal_Index];
	ptrFunc(dy);
}

void GLCD_LayerScrollMode(uint8_t mode)
{
void (*ptrFunc)(uint8_t mode);

	ptrFunc = (void (*)(uint8_t mode))API_Ptr_Table[GLCD_LayerScrollMode_Index];
	ptrFunc(mode);
}

void GLCD_LayerDisplayMode(uint8_t mode)
{
void (*ptrFunc)(uint8_t mode);

	ptrFunc = (void (*)(uint8_t mode))API_Ptr_Table[GLCD_LayerDisplayMode_Index];
	ptrFunc(mode);
}

void GLCD_LayerTransparency(uint8_t layer1_trans, uint8_t layer2_trans)
{
void (*ptrFunc)(uint8_t layer1_trans, uint8_t layer2_trans);

	ptrFunc = (void (*)(uint8_t layer1_trans, uint8_t layer2_trans))API_Ptr_Table[GLCD_LayerTransparency_Index];
	ptrFunc(layer1_trans, layer2_trans);
}

void GLCD_SetLayer(uint8_t layerNbr)
{
void (*ptrFunc)(uint8_t layerNbr);

	ptrFunc = (void (*)(uint8_t layerNbr))API_Ptr_Table[GLCD_SetLayer_Index];
	ptrFunc(layerNbr);
}

void GLCD_BTESetSource(uint32_t X, uint32_t Y, uint8_t layer)
{
void (*ptrFunc)(uint32_t X, uint32_t Y, uint8_t layer);

	ptrFunc = (void (*)(uint32_t X, uint32_t Y, uint8_t layer))API_Ptr_Table[GLCD_BTESetSource_Index];
	ptrFunc(X, Y, layer);
}

void GLCD_BTESetDestination(uint32_t X, uint32_t Y, uint8_t layer)
{
void (*ptrFunc)(uint32_t X, uint32_t Y, uint8_t layer);

	ptrFunc = (void (*)(uint32_t X, uint32_t Y, uint8_t layer))API_Ptr_Table[GLCD_BTESetDestination_Index];
	ptrFunc(X, Y, layer);
}

void GLCD_BTESetSize(uint32_t width, uint32_t height)
{
void (*ptrFunc)(uint32_t width, uint32_t height);

	ptrFunc = (void (*)(uint32_t width, uint32_t height))API_Ptr_Table[GLCD_BTESetSize_Index];
	ptrFunc(width, height);
}

void GLCD_BTESetBackgroundColor(uint32_t red, uint32_t green, uint32_t blue)
{
void (*ptrFunc)(uint32_t red, uint32_t green, uint32_t blue);

	ptrFunc = (void (*)(uint32_t red, uint32_t green, uint32_t blue))API_Ptr_Table[GLCD_BTESetBackgroundColor_Index];
	ptrFunc(red, green, blue);
}

void GLCD_BTESetForegroundColor(uint32_t red, uint32_t green, uint32_t blue)
{
void (*ptrFunc)(uint32_t red, uint32_t green, uint32_t blue);

	ptrFunc = (void (*)(uint32_t red, uint32_t green, uint32_t blue))API_Ptr_Table[GLCD_BTESetForegroundColor_Index];
	ptrFunc(red, green, blue);
}

void GLCD_BTESetPatternNumber(uint8_t pattern)
{
void (*ptrFunc)(uint8_t pattern);

	ptrFunc = (void (*)(uint8_t pattern))API_Ptr_Table[GLCD_BTESetPatternNumber_Index];
	ptrFunc(pattern);
}

void GLCD_SetTransparentColor(COLOR color)
{
void (*ptrFunc)(COLOR color);

	ptrFunc = (void (*)(COLOR color))API_Ptr_Table[GLCD_SetTransparentColor_Index];
	ptrFunc(color);
}

void GLCD_BTEStart(uint8_t source_mode, uint8_t dest_mode, uint8_t ROP, uint8_t operation)
{
void (*ptrFunc)(uint8_t source_mode, uint8_t dest_mode, uint8_t ROP, uint8_t operation);

	ptrFunc = (void (*)(uint8_t source_mode, uint8_t dest_mode, uint8_t ROP, uint8_t operation))API_Ptr_Table[GLCD_BTEStart_Index];
	ptrFunc(source_mode, dest_mode, ROP, operation);
}

void GLCD_BTEStartAndFillFromSRAM(uint8_t dest_mode, uint8_t ROP, uint8_t operation, uint32_t SRAM_Ptr, uint32_t size)
{
void (*ptrFunc)(uint8_t dest_mode, uint8_t ROP, uint8_t operation, uint32_t SRAM_Ptr, uint32_t size);

	ptrFunc = (void (*)(uint8_t dest_mode, uint8_t ROP, uint8_t operation, uint32_t SRAM_Ptr, uint32_t size))API_Ptr_Table[GLCD_BTEStartAndFillFromSRAM_Index];
	ptrFunc(dest_mode, ROP, operation, SRAM_Ptr, size);
}

SYNTH_Status SYNTH_Start(void)
{
SYNTH_Status (*ptrFunc)(void);

	ptrFunc = (SYNTH_Status (*)(void))API_Ptr_Table[SYNTH_Start_Index];
	return (ptrFunc());
}

SYNTH_Status SYNTH_Stop(void)
{
SYNTH_Status (*ptrFunc)(void);

	ptrFunc = (SYNTH_Status (*)(void))API_Ptr_Table[SYNTH_Stop_Index];
	return (ptrFunc());
}

SYNTH_Status SYNTH_SetMainVolume(int volume)
{
SYNTH_Status (*ptrFunc)(int volume);

	ptrFunc = (SYNTH_Status (*)(int volume))API_Ptr_Table[SYNTH_SetMainVolume_Index];
	return (ptrFunc(volume));
}

SYNTH_Status SYNTH_SetVolume(int channel, int volume)
{
SYNTH_Status (*ptrFunc)(int channel, int volume);

	ptrFunc = (SYNTH_Status (*)(int channel, int volume))API_Ptr_Table[SYNTH_SetVolume_Index];
	return (ptrFunc(channel, volume));
}

SYNTH_Status SYNTH_SetInstrument(int channel, void *instrument)
{
SYNTH_Status (*ptrFunc)(int channel, void *instrument);

	ptrFunc = (SYNTH_Status (*)(int channel, void *instrument))API_Ptr_Table[SYNTH_SetInstrument_Index];
	return (ptrFunc(channel, instrument));
}

SYNTH_Status SYNTH_NoteOn(int channel, uint32_t note)
{
SYNTH_Status (*ptrFunc)(int channel, uint32_t note);

	ptrFunc = (SYNTH_Status (*)(int channel, uint32_t note))API_Ptr_Table[SYNTH_NoteOn_Index];
	return (ptrFunc(channel, note));
}

SYNTH_Status SYNTH_NoteOff(int channel)
{
SYNTH_Status (*ptrFunc)(int channel);

	ptrFunc = (SYNTH_Status (*)(int channel))API_Ptr_Table[SYNTH_NoteOff_Index];
	return (ptrFunc(channel));
}

MELODY_Status MELODY_Start(void *music, uint32_t length)
{
MELODY_Status (*ptrFunc)(void *music, uint32_t length);

	ptrFunc = (MELODY_Status (*)(void *music, uint32_t length))API_Ptr_Table[MELODY_Start_Index];
	return (ptrFunc(music,length));
}

MELODY_Status MELODY_Stop(void)
{
MELODY_Status (*ptrFunc)(void);

	ptrFunc = (MELODY_Status (*)(void))API_Ptr_Table[MELODY_Stop_Index];
	return (ptrFunc());
}

MELODY_Status MELODY_GetPosition(uint8_t *pos)
{
MELODY_Status (*ptrFunc)(uint8_t *pos);

	ptrFunc = (MELODY_Status (*)(uint8_t *pos))API_Ptr_Table[MELODY_GetPosition_Index];
	return (ptrFunc(pos));
}

