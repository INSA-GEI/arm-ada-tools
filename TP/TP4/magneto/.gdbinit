#
# J-LINK GDB SERVER initialization
#
# This connects to a GDB Server listening
# for commands on localhost at tcp port 2331 target remote localhost:2331
target remote localhost:2331

# monitor flash set_parallelism_mode 2
set pagination off
set host-charset CP1252
set target-charset CP1252

# Reset the chip to get to a known state.
monitor reset

#
# CPU core initialization (to be done by user)
#
# Set the processor mode
set *0xE0042004 = (*0xE0042004) | 0x7 

# Set auto JTAG speed
monitor speed 4000

# Setup GDB FOR FASTER DOWNLOADS
set remote memory-write-packet-size 1024
set remote memory-write-packet-size fixed
