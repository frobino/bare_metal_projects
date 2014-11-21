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

- Would be good to understand more acout crt0.s & co.
