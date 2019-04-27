addi s5, zero, -42 # for b
addi s6, zero, -43 # for h
addi s7, zero, 90 # for w

sb s5, 230, zero
sh s6, 231, zero
sw s7, 233, zero

lb s8, 230, zero
lh s9, 231, zero
lw t0, 233, zero

# expected result?
lbu t1, 230, zero
lhu t2, 231, zero

add t6, s8, s9
add t6, t6, t0 # t6 is 90 -43 -42 = 5

add t5, t1, t2
srai t5, t5, 9 2