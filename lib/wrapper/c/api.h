#ifndef __API_H__
#define __API_H__

#include "stm32f30x.h"

struct __FILE { int handle; /* Add whatever you need here */ };
typedef struct __FILE C_FILE;

#define API_GetOSVersion_Index 		0
#define fwrite_Index				1
#define fread_Index					2
//#define malloc_Init_Index			3
//#define malloc_Index				4
//#define free_Index				5
#define Delay_Index					6

#define GLCD_Clear_Index			7
#define GLCD_SetTextColor_Index 	8
#define GLCD_SetBackColor_Index 	9
#define GLCD_PutPixel_Index 		10
#define GLCD_DrawChar_Index 		11
#define GLCD_DrawADAString_Index 	12
#define GLCD_DrawLine_Index 		13
#define GLCD_DrawRectangle_Index 	14
#define GLCD_DrawFillRectangle_Index 		15
#define GLCD_DrawCircle_Index 		16
#define GLCD_DrawFillCircle_Index 	17
#define GLCD_DrawImage_Index 		18

#define GUI_ProgressBar_Index 		19
#define GUI_CenterBar_Index 		20

#define KEYS_GetState_Index 		21
#define POT_GetValue_Index 			22
#define LED_Set_Index 				23
#define RNG_GetValue_Index 			24

#define AUDIO_Start_Index 			25
#define AUDIO_Stop_Index 			26
#define AUDIO_FillBuffer_Index 		27
#define AUDIO_SetEventCallback_Index 		28

#define L3GD20_GetGyroscopicValues_Index 	29
#define LSM303DLHC_GetMagneticValues_Index 	30
#define LSM303DLHC_GetAccelerometerValues_Index 31

#define SRAM_ReadByte_Index             32
#define	SRAM_WriteByte_Index            33
#define	SRAM_ReadBuffer_Index           34
#define	SRAM_WriteBuffer_Index          35

#define	TIMER_Start_Index               36
#define	TIMER_Stop_Index                37
#define	TIMER_SetEventCallback_Index    38

#define	GLCD_DrawImagefromSRAM_Index    39
#define	GLCD_LayerScrollMode_Index      40
#define	GLCD_SetScrollWindow_Index      41
#define	GLCD_ScrollVertical_Index       42
#define	GLCD_ScrollHorizontal_Index     43
#define	GLCD_LayerDisplayMode_Index           44
#define	GLCD_LayerTransparency_Index          45
#define	GLCD_SetLayer_Index                   46
#define	GLCD_BTESetSource_Index               47
#define	GLCD_BTESetDestination_Index          48
#define	GLCD_BTESetSize_Index                 49
#define	GLCD_BTESetBackgroundColor_Index      50
#define	GLCD_BTESetForegroundColor_Index      51
#define	GLCD_BTESetPatternNumber_Index        52
#define	GLCD_SetTransparentColor_Index        53
#define	GLCD_BTEStart_Index                   54
#define GLCD_BTEStartAndFillFromSRAM_Index    55

#define SYNTH_Start_Index		      56
#define SYNTH_Stop_Index		      57
#define SYNTH_SetMainVolume_Index	  58
#define SYNTH_SetVolume_Index		  59
#define SYNTH_SetInstrument_Index	  60
#define SYNTH_NoteOn_Index		      61
#define SYNTH_NoteOff_Index		      62
#define MELODY_Start_Index		      63
#define MELODY_Stop_Index		      64
#define MELODY_GetPosition_Index	  65

#define Black           0x00      /*   0,   0,   0 */
#define Navy            0x01      /*   0,   0, 1 */
#define DarkGreen       0x0C      /*   0, 3,   0 */
#define DarkCyan        0x0D      /*   0, 3, 1 */
#define Maroon          0x60      /* 3,   0,   0 */
#define Purple          0x61      /* 3,   0, 1 */
#define Olive           0x6C      /* 3, 3,   0 */
#define LightGrey       0xB5      /* 5, 5, 2 */
#define DarkGrey        0x6D      /* 3, 3, 1 */
#define Blue            0x03      /*   0,   0, 3 */
#define Green           0x1C      /*   0, 7,   0 */
#define Cyan            0x1F      /*   0, 7, 3 */
#define Red             0xE0      /* 7,   0,   0 */
#define Magenta         0xE3      /* 7,   0, 3 */
#define Yellow          0xFC      /* 7, 7, 0   */
#define White           0xFF      /* 7, 7, 3 */

typedef uint8_t COLOR;

// Return code
#define INVALID_ABI	0xDEAD0001

enum LED_STATE_ENUM
{
	LED_OFF=0,
	LED_ON
};

typedef enum LED_STATE_ENUM LED_STATE;
typedef void (*AUDIO_EventCallback)(int buffer_nbr);
typedef void (*TIMER_EventCallback)(void);

typedef enum MELODY_Status_ST {
	MELODY_SUCCESS=0,
	MELODY_ERROR
} MELODY_Status;

typedef enum SYNTH_Status_ST {
	SYNTH_SUCCESS=0,
	SYNTH_ERROR,
	SYNTH_INVALID_CHANNEL
} SYNTH_Status;

void API_GetOSVersion(int* major, int* minor);
void API_EmergencyExit(int errcode);
//int C_fputc(int c, C_FILE *f);
//int C_fgetc(C_FILE *f);
int C_write(int fd, char *ptr, int len);
int C_read(int fd, char *ptr, int len);
//void C_malloc_Init(uint32_t lowerAddr);
//void *C_malloc(int size);
//void C_free(void* ptr);
void C_Delay(uint32_t duration);

void GLCD_SetTextColor(COLOR color);
void GLCD_SetBackColor(COLOR color);
void GLCD_Clear(COLOR color);
void GLCD_DrawADAString(uint32_t x, uint32_t y, uint32_t len, const char *str);
void GLCD_DrawLine(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2);
void GLCD_DrawRectangle(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2);
void GLCD_DrawFillRectangle(uint32_t x1, uint32_t y1, uint32_t x2, uint32_t y2);
void GLCD_PutPixel(uint32_t x, uint32_t y, COLOR color);
void GLCD_DrawImage(COLOR* data, uint32_t x, uint32_t y, uint32_t w, int32_t h);

int KEYS_GetState(int key_id);
uint8_t POT_GetValue(int pot_id);
void GUI_ProgressBar(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint8_t val, uint8_t maxval);
void GUI_CenterBar(uint16_t x, uint16_t y, uint16_t w, uint16_t h, int val, uint32_t maxval);

void LED_Set(LED_STATE state);
uint16_t RNG_GetValue(void);

void AUDIO_Start(void);
void AUDIO_Stop(void);
void AUDIO_FillBuffer(int buffer_nbr, uint8_t* buffer);
void AUDIO_SetEventCallback(AUDIO_EventCallback callback);

float* L3GD20_GetGyroscopicValues (void);
float* LSM303DLHC_GetMagneticValues (void);
float* LSM303DLHC_GetAccelerometerValues(void);

uint8_t SRAM_ReadByte(uint32_t addr);
void SRAM_WriteByte(uint32_t addr, uint8_t data);
void SRAM_ReadBuffer(uint32_t addr, uint8_t *buffer, int length);
void SRAM_WriteBuffer(uint32_t addr, uint8_t *buffer, int length);

int TIMER_Start(void);
void TIMER_Stop(void);
void TIMER_SetEventCallback(TIMER_EventCallback callback);

void GLCD_DrawImagefromSRAM (uint32_t SRAM_Ptr, uint32_t x, uint32_t y, uint32_t w, int32_t h);
void GLCD_SetScrollWindow (uint32_t x, uint32_t y, uint32_t w, uint32_t h);
void GLCD_ScrollVertical (uint32_t dy);
void GLCD_ScrollHorizontal (uint32_t dy);
void GLCD_LayerScrollMode(uint8_t mode);
void GLCD_LayerDisplayMode(uint8_t mode);
void GLCD_LayerTransparency(uint8_t layer1_trans, uint8_t layer2_trans);
void GLCD_SetLayer(uint8_t layerNbr);
void GLCD_BTESetSource(uint32_t X, uint32_t Y, uint8_t layer);
void GLCD_BTESetDestination(uint32_t X, uint32_t Y, uint8_t layer);
void GLCD_BTESetSize(uint32_t width, uint32_t height);
void GLCD_BTESetBackgroundColor(uint32_t red, uint32_t green, uint32_t blue);
void GLCD_BTESetForegroundColor(uint32_t red, uint32_t green, uint32_t blue);
void GLCD_BTESetPatternNumber(uint8_t pattern);
void GLCD_SetTransparentColor(COLOR color);
void GLCD_BTEStart(uint8_t source_mode, uint8_t dest_mode, uint8_t ROP, uint8_t operation);

SYNTH_Status SYNTH_Start(void);
SYNTH_Status SYNTH_Stop(void);

SYNTH_Status SYNTH_SetMainVolume(int volume);
SYNTH_Status SYNTH_SetVolume(int channel, int volume);
SYNTH_Status SYNTH_SetInstrument(int channel, void *instrument);
SYNTH_Status SYNTH_NoteOn(int channel, uint32_t note);
SYNTH_Status SYNTH_NoteOff(int channel);

MELODY_Status MELODY_Start(void *music, uint32_t length);
MELODY_Status MELODY_Stop(void);
MELODY_Status MELODY_GetPosition(uint8_t *pos);

#endif /* __API_H__ */
