/* Configure memory regions */

MEMORY
{
  RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 128K
}

ENTRY(_Reset)
SECTIONS
{
 .text : {
 startup.o (INTERRUPT_VECTOR)
 *(.text)
 } > RAM

 .data : { *(.data) } > RAM
 
 .bss : { *(.bss COMMON) } > RAM
 
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 stack_top = .;

}
