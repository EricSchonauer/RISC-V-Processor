# Processor 1
nop # lock
addi t1, zero, 31
addi t2, zero, 200 # address to store word at
sw t1, 0, t2 # stores 31 at address 200
nop #unlock
lw t6, 0, t2 # load value at t2, should be 31
# Processor 2
# without locking the word storing CPU2 does will be ignored
# while CPU1 has locked the RAM

nop
nop
addi t1, zero, 45
sw t1, 200, zero # stores 45 at address 200
0, t2 # stores 45 at address 200
lw t6, 0, t2 # should load back 31