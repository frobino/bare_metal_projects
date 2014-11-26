all: test.elf

test.elf: test.o startup.o test.ld
	arm-none-eabi-ld -T test.ld test.o startup.o -o test.elf

test.o: test.c
	arm-none-eabi-gcc -c -mthumb -mcpu=cortex-m4 -g test.c -o test.o

startup.o: startup.s
	arm-none-eabi-gcc -c -mcpu=cortex-m4 -g startup.s -o startup.o
	# For asm, the mthumb directive does not work from command line.
	# It must be inserted in the .s file (.thumb and .syntax unified)

debug: 
	arm-none-eabi-gdb -x prj/sam4s_xplained_ram_jlink_1.gdb test.elf

clean:
	rm -rf *.o *.elf
