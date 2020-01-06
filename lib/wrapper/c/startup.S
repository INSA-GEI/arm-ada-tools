/* File: startup.S
 * Purpose: startup file for Cortex-M3 devices. Should use with 
 *   GCC for ARM Embedded Processors
 * Version: V1.2
 * Date: 15 Nov 2011
 * 
 * Copyright (c) 2011, ARM Limited
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the ARM Limited nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL ARM LIMITED BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
	.syntax unified
	.arch 	armv7-m
	.cpu 	cortex-m4
	.fpu 	softvfp
	.equ    ABI_VER,7  //Vesion d'abi: Penser a changer aussi la constante dans api.c
	
	.section .stack
	.align 	3
#ifdef __STACK_SIZE
	.equ    Stack_Size, __STACK_SIZE
#else
	.equ    Stack_Size, 0x2000
#endif
	.globl  __StackTop
	.globl  __StackLimit
__StackLimit:
	.space  Stack_Size
	.size 	__StackLimit, . - __StackLimit
__StackTop:
	.size 	__StackTop, . - __StackTop

	.section .heap
	.align 3
#ifdef __HEAP_SIZE
	.equ    Heap_Size, __HEAP_SIZE
#else
	.equ    Heap_Size, 0x4
#endif
	.globl  __HeapBase
	.globl  __HeapLimit
__HeapBase:
	.space  Heap_Size
	.size 	__HeapBase, . - __HeapBase
__HeapLimit:
	.size	__HeapLimit, . - __HeapLimit
    
	.section .isr_vector
	.align 	2
	.globl	__isr_vector
__isr_vector:
	.ascii	"INSA"
	.long	ABI_VER
	.long   Reset_Handler         /* Reset Handler */	
	.size   __isr_vector, . - __isr_vector

	.text
	.thumb
	.thumb_func
	.align 	2
	.globl  Reset_Handler
	.type   Reset_Handler, %function
Reset_Handler:

/* Sauvegarde des registres sur la pile */
	PUSH 	{R1-R12,LR}
	
	LDR	R0,=__bss_end__
	LDR 	R0,[R0]
	
	ldr     r1, =__etext
	ldr     r2, =__data_start__
	ldr     r3, =__data_end__

.flash_to_ram_loop:
	cmp     r2, r3
	ittt    lt
	ldrlt   r0, [r1], #4
	strlt   r0, [r2], #4
	blt     .flash_to_ram_loop

	eor     r0, r0
	ldr     r2, =__bss_start__
	ldr     r3, =__bss_end__

.flash_to_ram_bss_loop:
	cmp     r2, r3
	itt     lt
	strlt   r0, [r2], #4
	blt    .flash_to_ram_bss_loop
	
	LDR	R0,=Saved_SP
	STR	SP,[R0]
/*
 * Init api table
 */
	LDR     R0, =API_Init
	BLX     R0
				
/*
 * Check return value of R0
 * if 1, ABI version is invalid, else everything is fine
 */
	CMP 	R0, #0
	BEQ	Call_main
	POP	{R1-R12,PC}
/*
 * Finaly, jump to main function (void main (void))
 */
Call_main:   
    
	LDR     R0, =main
	BLX     R0
				
	POP	{R1-R12,PC}
	
	.pool
	.size 	Reset_Handler, . - Reset_Handler

	.thumb
	.thumb_func
	.align 	2
	.weak   _fini
	.globl  _fini
	.type   _fini, %function
_fini:

	bx 	lr
	.pool
	.size 	_fini, . - _fini
	
	.thumb
	.thumb_func
	.align 	2
	.weak   _emergency_exit
	.globl  _emergency_exit
	.type   _emergency_exit, %function
_emergency_exit:

	LDR	R1,=Saved_SP
	LDR	SP,[R1]
	POP	{R1-R12,PC}
	.pool
	.size 	_emergency_exit, . - _emergency_exit
	
