/*******************************************************************************
 * File: startup_sam4s.s
 * Purpose: startup file for Cortex-M4 devices. Should use with
 *   GCC for ARM Embedded Processors
 * Version: V1.3
 * Date: 08 Feb 2012
 *
 * Copyright (c) 2012, ARM Limited
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
 *
 *******************************************************************************
 * History:
 *
 * 23.01.2013  mifi  Expand for SAM4S16.
 *                   Added external interrupts.
 *                   Added clearing of BSS segment.
 ******************************************************************************/

    .syntax unified
    .arch armv7-m

    .section .stack
    .align 3
#ifdef __STACK_SIZE
    .equ    Stack_Size, __STACK_SIZE
#else                          
    .equ    Stack_Size, 0x00000800
#endif
    .globl    __StackTop
    .globl    __StackLimit
__StackLimit:
    .space    Stack_Size
    .size __StackLimit, . - __StackLimit
__StackTop:
    .size __StackTop, . - __StackTop

    .section .heap
    .align 3
#ifdef __HEAP_SIZE
    .equ    Heap_Size, __HEAP_SIZE
#else
    .equ    Heap_Size, 0x00000800
#endif
    .globl    __HeapBase
    .globl    __HeapLimit
__HeapBase:
    .space    Heap_Size
    .size __HeapBase, . - __HeapBase
__HeapLimit:
    .size __HeapLimit, . - __HeapLimit

    .section .isr_vector
    .align 2
    .globl __isr_vector
__isr_vector:
    .long    __StackTop                      /* Top of Stack */
    .long    ResetHandler                    /* Reset Handler */
    .long    NMI_Handler                     /* NMI Handler */
    .long    HardFault_Handler               /* Hard Fault Handler */
    .long    MemManage_Handler               /* MPU Fault Handler */
    .long    BusFault_Handler                /* Bus Fault Handler */
    .long    UsageFault_Handler              /* Usage Fault Handler */
    .long    0                               /* Reserved */
    .long    0                               /* Reserved */
    .long    0                               /* Reserved */
    .long    0                               /* Reserved */
    .long    SVC_Handler                     /* SVCall Handler */
    .long    DebugMon_Handler                /* Debug Monitor Handler */
    .long    0                               /* Reserved */
    .long    PendSV_Handler                  /* PendSV Handler */
    .long    SysTick_Handler                 /* SysTick Handler */

    /* External interrupts */
	.long    SUPC_Handler                    /* 0  Supply Controller */
	.long    RSTC_Handler                    /* 1  Reset Controller */
	.long    RTC_Handler                     /* 2  Real Time Clock */
	.long    RTT_Handler                     /* 3  Real Time Timer */
	.long    WDT_Handler                     /* 4  Watchdog Timer */
	.long    PMC_Handler                     /* 5  PMC */
	.long    EFC0_Handler                    /* 6  EFC0 */
	.long    EFC1_Handler                    /* 7  EFC1 */
	.long    UART0_Handler                   /* 8  UART0 */
	.long    UART1_Handler                   /* 9  UART1 */
	.long    SMC_Handler                     /* 10 SMC */
	.long    PIOA_Handler                    /* 11 Parallel IO Controller A */
	.long    PIOB_Handler                    /* 12 Parallel IO Controller B */
	.long    PIOC_Handler                    /* 13 Parallel IO Controller C */
	.long    USART0_Handler                  /* 14 USART 0 */
	.long    USART1_Handler                  /* 15 USART 1 */
	.long    0                               /* 16 Reserved */
	.long    0                               /* 17 Reserved */
	.long    HSMCI_Handler                   /* 18 HSMCI */
	.long    TWI0_Handler                    /* 19 TWI 0 */
	.long    TWI1_Handler                    /* 20 TWI 1 */
	.long    SPI_Handler                     /* 21 SPI */
	.long    SSC_Handler                     /* 22 SSC */
	.long    TC0_Handler                     /* 23 Timer Counter 0 */
	.long    TC1_Handler                     /* 24 Timer Counter 1 */
	.long    TC2_Handler                     /* 25 Timer Counter 2 */
	.long    TC3_Handler                     /* 26 Timer Counter 3 */
	.long    TC4_Handler                     /* 27 Timer Counter 4 */
	.long    TC5_Handler                     /* 28 Timer Counter 5 */
	.long    ADC_Handler                     /* 29 ADC controller */
	.long    DACC_Handler                    /* 30 DACC controller */
	.long    PWM_Handler                     /* 31 PWM */
	.long    CRCCU_Handler                   /* 32 CRC Calculation Unit */
	.long    ACC_Handler                     /* 33 Analog Comparator */
	.long    UDP_Handler                     /* 34 USB Device Port */

    .size    __isr_vector, . - __isr_vector

    .text
    .thumb
    .thumb_func
    .align 2
    .globl   ResetHandler
    .type    ResetHandler, %function
ResetHandler:
/*     Loop to copy data from read only memory to RAM. The ranges
 *      of copy from/to are specified by following symbols evaluated in
 *      linker script.
 *      __etext: End of code section, i.e., begin of data sections to copy from.
 *      __data_start__/__data_end__: RAM address range that data should be
 *      copied to. Both must be aligned to 4 bytes boundary.  */

    ldr    r1, =__etext
    ldr    r2, =__data_start__
    ldr    r3, =__data_end__

#if 0
/* Here are two copies of loop implemenations. First one favors code size
 * and the second one favors performance. Default uses the first one. 
 * Change to "#if 0" to use the second one */
.flash_to_ram_loop:
    cmp     r2, r3
    ittt    lt
    ldrlt   r0, [r1], #4
    strlt   r0, [r2], #4
    blt    .flash_to_ram_loop
#else
    subs    r3, r2
    ble    .flash_to_ram_loop_end    
.flash_to_ram_loop:
    subs    r3, #4
    ldr    r0, [r1, r3]
    str    r0, [r2, r3]
    bgt    .flash_to_ram_loop
.flash_to_ram_loop_end:
#endif

#ifndef __NO_SYSTEM_INIT
    ldr    r0, =SystemInit
    blx    r0
#endif

/* Clear the BSS segment */
    ldr    r0, =0
    ldr    r1, =__bss_start__
    ldr    r2, =__bss_end__

clear_bss_loop:
    cmp    r1, r2
    beq    clear_bss_loop_end
    str    r0, [r1], #4
    b      clear_bss_loop
clear_bss_loop_end:
   
    ldr    r0, =main
    bx     r0
    .pool
    .size ResetHandler, . - ResetHandler

/* Exception Handlers */

    .weak   NMI_Handler
    .type   NMI_Handler, %function
NMI_Handler:
    B       .
    .size   NMI_Handler, . - NMI_Handler

    .weak   HardFault_Handler
    .type   HardFault_Handler, %function
HardFault_Handler:
    B       .
    .size   HardFault_Handler, . - HardFault_Handler

    .weak   MemManage_Handler
    .type   MemManage_Handler, %function
MemManage_Handler:
    B       .
    .size   MemManage_Handler, . - MemManage_Handler

    .weak   BusFault_Handler
    .type   BusFault_Handler, %function
BusFault_Handler:
    B       .
    .size   BusFault_Handler, . - BusFault_Handler

    .weak   UsageFault_Handler
    .type   UsageFault_Handler, %function
UsageFault_Handler:
    B       .
    .size   UsageFault_Handler, . - UsageFault_Handler

    .weak   SVC_Handler
    .type   SVC_Handler, %function
SVC_Handler:
    B       .
    .size   SVC_Handler, . - SVC_Handler

    .weak   DebugMon_Handler
    .type   DebugMon_Handler, %function
DebugMon_Handler:
    B       .
    .size   DebugMon_Handler, . - DebugMon_Handler

    .weak   PendSV_Handler
    .type   PendSV_Handler, %function
PendSV_Handler:
    B       .
    .size   PendSV_Handler, . - PendSV_Handler

    .weak   SysTick_Handler
    .type   SysTick_Handler, %function
SysTick_Handler:
    B       .
    .size   SysTick_Handler, . - SysTick_Handler

    
/*    Macro to define default handlers. Default handler
 *    will be weak symbol and just dead loops. They can be
 *    overwritten by other handlers */
    .macro    def_irq_handler    handler_name
    .align 1
    .thumb_func
    .weak    \handler_name
    .type    \handler_name, %function
\handler_name :
    b    .
    .size    \handler_name, . - \handler_name


    .endm


/* IRQ Handlers */

    def_irq_handler   SUPC_Handler                    /* 0  Supply Controller */
    def_irq_handler   RSTC_Handler                    /* 1  Reset Controller */
    def_irq_handler   RTC_Handler                     /* 2  Real Time Clock */
    def_irq_handler   RTT_Handler                     /* 3  Real Time Timer */
    def_irq_handler   WDT_Handler                     /* 4  Watchdog Timer */
    def_irq_handler   PMC_Handler                     /* 5  PMC */
    def_irq_handler   EFC0_Handler                    /* 6  EFC0 */
    def_irq_handler   EFC1_Handler                    /* 7  EFC1 */
    def_irq_handler   UART0_Handler                   /* 8  UART0 */
    def_irq_handler   UART1_Handler                   /* 9  UART1 */
    def_irq_handler   SMC_Handler                     /* 10 SMC */
    def_irq_handler   PIOA_Handler                    /* 11 Parallel IO Controller A */
    def_irq_handler   PIOB_Handler                    /* 12 Parallel IO Controller B */
    def_irq_handler   PIOC_Handler                    /* 13 Parallel IO Controller C */
    def_irq_handler   USART0_Handler                  /* 14 USART 0 */
    def_irq_handler   USART1_Handler                  /* 15 USART 1 */
                                                      /* 16 Reserved */
                                                      /* 17 Reserved */
    def_irq_handler   HSMCI_Handler                   /* 18 HSMCI */
    def_irq_handler   TWI0_Handler                    /* 19 TWI 0 */
    def_irq_handler   TWI1_Handler                    /* 20 TWI 1 */
    def_irq_handler   SPI_Handler                     /* 21 SPI */
    def_irq_handler   SSC_Handler                     /* 22 SSC */
    def_irq_handler   TC0_Handler                     /* 23 Timer Counter 0 */
    def_irq_handler   TC1_Handler                     /* 24 Timer Counter 1 */
    def_irq_handler   TC2_Handler                     /* 25 Timer Counter 2 */
    def_irq_handler   TC3_Handler                     /* 26 Timer Counter 3 */
    def_irq_handler   TC4_Handler                     /* 27 Timer Counter 4 */
    def_irq_handler   TC5_Handler                     /* 28 Timer Counter 5 */
    def_irq_handler   ADC_Handler                     /* 29 ADC controller */
    def_irq_handler   DACC_Handler                    /* 30 DACC controller */
    def_irq_handler   PWM_Handler                     /* 31 PWM */
    def_irq_handler   CRCCU_Handler                   /* 32 CRC Calculation Unit */
    def_irq_handler   ACC_Handler                     /* 33 Analog Comparator */
    def_irq_handler   UDP_Handler                     /* 34 USB Device Port */

    .end

/*** EOF ***/
