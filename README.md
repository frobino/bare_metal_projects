bare_metal_projects
===================

Bare metal projects for different boards. 

The goal of this project is to learn the flow of running bare-metal 
applications on different boards. I will follow an approach similar 
to the one described in:
http://www.valvers.com/open-software/raspberry-pi/step01-bare-metal-programming-in-cpt1/

I will try to follow a similar approach for different boards. 
Each folder in this repo contains experiments on a specific board. 
Please refer to the README in each of the folders. 

Typical flow
===================

1) Be able to connect through gdb to the board. 
This should be achieved using openocd (http://openocd.sourceforge.net) and/or 
a Debug Adapter Hardware (a.k.a. Dongle): a small adapter that attaches 
to your computer via USB, and enables the instantiation of a gdb server 
on the target platform. In this way, using a tool such as arm-none-eabi-gdb, 
I can connect to the target from the host (my PC). 

2) Be able to write C code, linker scripts, etc, so that I can run and 
debug a C program on the target device. 

3) Download and run the debugged C code on some (removable) memory, so 
that the board runs the bare metal program immediately after the 
preloader/bootloader.

Notes on the steps
===================

Step 1) 
	- Looks like openocd requires however dongles to be installed.
	E.g. for sam4sXplained board, which contains a JLink debugger on board, 
	I had to install the dongler "J-Link software & documentation pack for Linux" 
	from the Segger webpage (https://www.segger.com/jlink-software.html) 
	to be able to create a gdb server on the target. 

General notes
===================

- Would be good to understand more about crt0.s & co. (e.g. code sections)
  Here is what I understood up to now (taken from valvers.com tutorial):

  Code/memory sections:

  * The .text section contains the actual machine instructions which make up your program.
    We can also refer to .text section as a portion of an object file that contains the executable 
    instructions.

  * The .data section contains static data which was defined in your code.

  * The .bss section contains uninitialized global or static variables.

  
  The LINKER: 

  The linker’s job is to link object files into an executable file. 
  The linker requires a linker script. The linker script tells the linker 
  how to organise the various object files. The linker will resolve symbols to addresses 
  when it has arranged all the objects according to the rules in the linker script.

  However, the object files we get from our source code are not sufficient to successfully link. 
  For example, some variables need to be initialised to certain values, 
  and some variables need to be initialised to 0. This is all taken care of by an 
  object file which is usually implicitly linked in by the linker because the linker script 
  will include a reference to it. The object file is called crt0.o (C Run-Time 0).
  For example, for the arm-none-eabi-gcc, it is contained in 
  /usr/lib/gcc/arm-none-eabi/4.8.2/armvXXX/crti.o
  while the linker scripts are in 
  /usr/lib/arm-none-eabi/ldscripts/

  When we compile for a target that executes from an image in Flash and uses RAM for variables, 
  we need a copy of the initial values for the variables from Flash so that every time 
  the system is started the variables can be initialised to their initial value, 
  and we need the code in Flash to copy these values into the variables *before* main() is called.
  This is one of the jobs of the C-Runtime code (CRT). This is a code object that is normally 
  linked in automagically by your tool-chain. This is usually not the only object to get linked 
  to your code behind your back – usually the Interrupt Vector Table gets linked in too, 
  and a Linker Script tells the linker how to organise these additional pieces of code in 
  your memory layout.
  
