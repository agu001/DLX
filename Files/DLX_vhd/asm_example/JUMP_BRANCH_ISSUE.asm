addi r1, r0, 2
xor r2, r2, r2

ciclo:
lw r3, 0(r2)
addi r3, r3, 10
sw 100(r2), r3
subi r1, r1, 1
addi r2, r2, 4
bnez r1, ciclo
ciclo2:
addi r4, r0, 65535
ori r5, r4, 10000
addi r6, r0, #60
jalr r6
addi r6,r2,#30
addi r5,r2,#5
addi r4,r1,#45
end:
seq r1,r3,r4
sge r2,r5,r6
sle r3,r1,r2
add r5,r1,r2
or  r6,r3,r5
add r9, r31, r0
jr r9
fine:
j fine

