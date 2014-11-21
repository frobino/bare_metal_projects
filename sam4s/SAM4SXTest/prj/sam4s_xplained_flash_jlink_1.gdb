# connect to the J-Link gdb server
target remote localhost:2331

# Enable flash download and flash breakpoints.
# Flash download and flash breakpoints are features of
# the J-Link software which require separate licenses 
# from SEGGER.

# Select flash device
monitor flash device = AT91SAM4S16C

# Enable FlashDL and FlashBPs
monitor flash download = 1
monitor flash breakpoints = 1

# Clear all pendig breakpoints
monitor clrbp

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
