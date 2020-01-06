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
 
#include <stdio.h>
#include <time.h>
#include <string.h>
#include "api.h"

//char *sbrk_buffer;
//char *sbrk_UpperBound=(char*)0x20009000;
//char sprintf_buf[128];

//char write_buffer[1000];
//struct ST_MY_FILE { int handler};
//typedef struct ST_MY_FILE MY_FILE;

/* int _write(int file, char *ptr, int len) */
/* { */
/* C_FILE File_handler; */
/* int i; */

/* 	File_handler.handle = file; */

/* 	/\*for (i=0; i<len; i++) */
/* 	{ */
/* 	    C_fputc((int)ptr[i], &File_handler); */
/* 	    }*\/ */

/* 	C_fputc((int)ptr[0], &File_handler); */
/* /\*	static char *current_ptr; */
/* 	int i; */
	
/* 	if (current_ptr==0) */
/* 	{ */
/* 		current_ptr = write_buffer; */
/* 	} */
	
/* 	for (i=0; i<len; i++) */
/* 	{ */
/* 		*current_ptr=ptr[i]; */
/* 		current_ptr++; */
/* 	} */
	
/* 	return len;*\/ */
/* } */

/* int _read(int file, char *ptr, int len) */
/* { */
/* C_FILE File_handler; */
/* int i; */

/* 	File_handler.handle = file; */

/* 	for (i=0; i<len; i++) */
/* 	{ */
/* 		ptr[i]=(int)C_fgetc(&File_handler); */
/* 	} */
/* } */

/* void _exit(int exit_code) */
/* { */
/* //	while (1); */
/* 	API_EmergencyExit(exit_code); */
	
/* 	while (1); */
/* } */

/* void _free(void* ptr) */
/* { */
/* 	C_free(ptr); */
/* } */

/* caddr_t _sbrk(int incr)  */
/* { */
/*   //void *ptr; */
/*   int i; */
  
/* 	static char *heap_end; */
/* 	char *prev_heap_end; */
/* 	sprintf(sprintf_buf, "Request %i byte(s)\n", incr); */

/* 	for (i=0; i<strlen(sprintf_buf); i++) */
/* 	{ */
/* 	  _write(1, &sprintf_buf[i], 1); */
/* 	} */
	
/* 	if (heap_end == 0)  */
/* 	{ */
/* 		heap_end = sbrk_buffer; */
/* 	} */

/* 	prev_heap_end = heap_end; */

/* 	if (heap_end + incr > sbrk_UpperBound)  */
/* 	{ */
/* 		_write (1, "Heap exhausted\n", 15); */
/* 		_exit(1); */
/* 	} */

/* 	heap_end += incr; */
/* 	return (caddr_t) prev_heap_end; */
	
/* 	/\* ptr=C_malloc(incr); *\/ */
/* 	/\* if (ptr ==0x0) *\/ */
/* 	/\* { *\/ */
/* 	/\* 	_write (1, "Heap exhausted\n", 15); *\/ */
/* 	/\* 	_exit(1); *\/ */
/* 	/\* } *\/ */
	
/* 	/\* return (caddr_t) ptr; *\/ */
/* } */

/* void abort (void) */
/* { */
/* 	_exit(-1); */
/* } */

/* int nanosleep(const struct timespec *req, struct timespec *rem) */
/* { */
/* 	C_Delay(req->tv_sec); */
/* 	return 0; */
/* } */
