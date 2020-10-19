l1:
add r9,r20,r10
addi r1,r2,#-5
and r9,r3,r10
andi r20,r9,#8
lw r19, 64(r8)
nop
ori r5, r3, #342
sge r1,r2,r10
sgei r9,r20,#6
b1:
sle r13,r2,r4
slei r1,r3,#-4
bnez r1, b1
sll r1,r2,r3
slli r4,r1,#5
sne r1,r2,r3
snei r3,r5,#4
srl r5,r7,r8
srli r7,r5,#2
sub r6,r12,r15
b2:
subi r7,r9,#-30
beqz r7, b2
xor r6,r12,r15
xori r6,r12,#1
addu r5,r3,r4
addui r1,r5,#250
lb r1, 50(r0)
lbu r3, 50(r0)
lhi r1,#-40
mult r5,r2,r4
sb 41(r3), r2
sw 52(r3), r1
jal labjal
addi r31, r0, labjr2
jalr r31
labjal:
seq r13,r1,r4
seqi r29,r20,#1
sgeu r9,r20,r10
sgeui r7,r8,#23
jr r31
labjr2:
sgt r1,r2,r3
sgti r4,r1,#15
sgtu r5,r6,r3
sgtui r15,r3,#8
slt r5,r7,r8
slti r9,r10,#30
sltu r17,r13,r14
sltui r5,r7,#13
addi r27, r0, #10

srai r25,r26,#10
subu r13,r2,r4
subui r5,r18,#4
or r5, r3, r4
sleu r13,r2,r9
sleui r22,r30,#30
sra r25, r26, r27 ;new
lhu r1, #10 ;new
sh 10(r3), r2 ;new
lh r3, 50(r0)
j l1
