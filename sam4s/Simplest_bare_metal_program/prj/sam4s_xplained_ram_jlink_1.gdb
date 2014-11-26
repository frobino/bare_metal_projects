# connect to the J-Link gdb server
target remote localhost:2331

# Set gdb server to little endian
monitor endian little

# Set JTAG speed to 30 kHz
monitor speed 30

# Reset the target
monitor reset
monitor sleep 100

# Set JTAG speed in khz
monitor speed 8000

# Reset peripheral  (RSTC_CR)
monitor writeu32 0x400e1400 = 0xA5000004
