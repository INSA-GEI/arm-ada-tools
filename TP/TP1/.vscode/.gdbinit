fuck !
 set pagination off
set host-charset CP1252
set target-charset CP1252

file application.elf
target remote localhost:61234

monitor halt
monitor reset
set *0xE0042004 = (*0xE0042004) | 0x7 

set remote memory-write-packet-size 1024
set remote memory-write-packet-size fixed
load application.elf
tbreak _ada_missionsimon

continue
