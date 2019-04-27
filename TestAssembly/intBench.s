.text

addi ra, zero, 1 # 1
slti sp, zero, -1 # 0
sltiu gp, zero, -1 # 1
xori tp, ra, 1 # 0
ori t0, zero, 1 # 1
andi t1, ra, 1 # 1
slli t2, ra, 1 # 2
srli s0, t2, 1 # 1

addi s1, zero, -2
srai s1, s1, 1 # -1

add a0, ra, sp # 1
sub a1, ra, gp # 0
sll a2, t1, a0 # 2
slt a3, a0, a2 # 1
sltu a4, a0, s1 # 1
xor a5, sp, gp # 1
srl a6, t2, s0 # 1

addi a7, zero, -2
sra a7, a7, a6 # -1
or s2, sp, gp # 1
and s3, sp, gp # 0


# 13
add s4, ra, sp
add s4, s4, gp 
add s4, s4, tp
add s4, s4, t0
add s4, s4, t1
add s4, s4, t2
add s4, s4, s0
add s4, s4, s1
add s4, s4, a0
add s4, s4, a1
add s4, s4, a2
add s4, s4, a3
add s4, s4, a4
add s4, s4, a5
add s4, s4, a6
add s4, s4, a7
add s4, s4, s2
add s4, s4, s3

add t6, s4, t6





