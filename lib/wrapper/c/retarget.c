/*----------------------------------------------------------------------------
 * Name:    retarget.c
 * Purpose: Redirection des E/S et autres fonctions OS
 * Version: V1.00
 *----------------------------------------------------------------------------
 * This file is part of the uVision/ARM development tools.
 * This software may only be used under the terms of a valid, current,
 * end user licence from KEIL for a compatible version of KEIL software
 * development tools. Nothing else gives you the right to use this software.
 *
 * Copyright (c) 2005-2007 Keil Software. All rights reserved.
 *---------------------------------------------------------------------------*/
 
#include <stm32f30x.h>
#include <stdio.h>
#include <time.h>
#include <string.h>
#include "api.h"

char *sbrk_buffer;
char *sbrk_UpperBound=(char*)0xC0000000 + 0x400000;
char sprintf_buf[128];

//char write_buffer[1000];
//struct ST_MY_FILE { int handler};
//typedef struct ST_MY_FILE MY_FILE;

int _write(int file, char *ptr, int len)
{
	return C_write(file, ptr, len);
}

int _read(int file, char *ptr, int len)
{
	return C_read(file, ptr, len); 
}

void _exit(int exit_code)
{
	API_EmergencyExit(exit_code);
	
	while (1);
}

/*void _free(void* ptr)
{
	C_free(ptr);
}*/

caddr_t _sbrk(int incr) 
{
  int i;
  
	static char *heap_end;
	char *prev_heap_end;
	sprintf(sprintf_buf, "Request %i byte(s)\n", incr);

	for (i=0; i<strlen(sprintf_buf); i++)
	{
	  _write(1, &sprintf_buf[i], 1);
	}
	
	if (heap_end == 0) 
	{
		heap_end = sbrk_buffer;
	}

	prev_heap_end = heap_end;

	if (heap_end + incr > sbrk_UpperBound) 
	{
		_write (1, "Heap exhausted\n", 15);
		return (caddr_t) -1;
	}

	heap_end += incr;
	return (caddr_t) prev_heap_end;
}

void abort (void)
{
	_exit(-1);
}

int nanosleep(const struct timespec *req, struct timespec *rem)
{
	C_Delay(req->tv_sec);
	return 0;
}
