loop:
add x1, a1, a2
c.addi a1, 0x1
c.beqz x8, ll
c.add x1, x1
sub x1, x1, x1
sll x1, x1, x1
slt x1, x1, x1
sltu x1, x1, x1
xor x1, x1, x1
srl x1, x1, x1
sra x1, x1, x1
or x1, x1, x1
and x1, x1, x1
andi x1, x2, 1
xori x1, x2, -1
slli x1, x2, 1
srli x1, x2, 1
srai x1, x2, 1
ll:
c.bnez x8, loop
c.lw x8, 44(x8)
c.sw x9, 0x14(x10)


