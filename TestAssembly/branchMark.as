addi t0, zero, 1
addi t1, zero, 5
addi t2, zero, -1

beq t0, t0, a
addi t5, zero, 1 # skipped

a:
beq t0, zero, a
bne t0, zero, b
addi t5, zero, 1 # skipped

b:
bne zero, zero, b # 9
blt t2, t1, c
addi t5, zero, 1 # skipped

c:
blt t1, t2, c # 12
bge t1, t2, d
addi t5, zero, 1 # skipped

d:
bge t2, zero, d # 15
bltu t0, t2, e
addi t6, zero, 1 # skipped

e:
addi t6, zero, 2 # 18
bltu zero, zero, e
bgeu t2, t1, f
addi t5, zero, 1 # skipped

f:
addi t5, t5, 1 # previous all skipped so t5 is 1
