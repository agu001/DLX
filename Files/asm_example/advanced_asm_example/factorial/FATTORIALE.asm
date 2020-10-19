jal begin

fact:
slei r3,r1,0
bnez r3,putone
subi r17,r1,1
addi r29, r29, 4
sw 0(r29), r31
jal fact
lw r31, 0(r29)
subi r29, r29, 4
mult r1,r17,r1
j end

putone:
addi r1,r0,1

end:
jal r31

begin:
addi r1,r0,4
jal fact

finish:
j finish
