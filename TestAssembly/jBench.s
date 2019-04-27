jal t5, here
addi t4, zero, -1

here:
addi t4, zero, 2

lui t3, 1

jalr t6, t4, 0
addi t5, zero, 2
sub t5, t5, t5