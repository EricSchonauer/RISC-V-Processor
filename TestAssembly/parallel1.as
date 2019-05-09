# Processor 1
nop # lock
addi t1, zero, 31
addi t2, zero, 200 # address to store word at
sw t1, 0, t2 # stores 31 at address 200
nop #unlock
lw t6, 0, t2 # load value at t2, should be 31 as CPU2 hasn't 
# stored word yet

# Processor 2
nop # lock
addi t1, zero, 45
addi t2, zero, 200 # address to store word at
sw t1, 0, t2 # stores 45 at address 200
nop #unlock
lw t6, 0, t2 # should load back 45