.globl main
main:

addi x1, x0, 1
addi x2, x0, 2
addi x7, x0, 18
c.lui x8, 5
nop
sw x7, 0(x0)
add x9, x0, x0
c.sw x8, 4(x9)
nop
c.addi x4, 10
nop
.end
