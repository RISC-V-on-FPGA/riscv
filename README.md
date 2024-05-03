# RISC-V on FPGA

32-bit 5-stage RISC-V processor for FPGA implementation based on the book Computer Organization and Design: (https://www.amazon.se/-/en/David-Patterson/dp/0128122757).

Assembler: [ripes.me](https://ripes.me/)

![alt text](image.png)

# Implemented Instructions
## Shifts
- SLL
- SLLI
- SRL
- SRLI
- SRA
- SRAI
## Arithmetic
- ADD
- ADDI
- SUB
- LUI
## Logical
- XOR
- XORI
- OR
- ORI
- AND
- ANDI
## Compare
- SLT
- SLTI
- SLTU
- SLTIU
## Branches
- BEQ
- BNE
- BLT
- BGE
- BLTU
- BGEU
## Loads and Stores
- LW
- SW
### Compressed (16-bit) Instruction Extension
## Loads and Stores
- C.LW
- C.SW - does not work in ripes assembler
## Arithmetic
- C.ADD
- C.ADDI
- C.SUB
- C.AND
- C.ANDI
- C.OR
- C.XOR
- C.MV
- C.LI
- C.LUI - does not work in ripes assembler
## Shifts
- C.SLLI
- C.SRAI
- C.SRLI
## Branches
- C.BEQZ
- C.BNEZ

# Short term plan
- [x] Check for latches
- [x] Synth
  - [ ] Make sure every register is reset on rst
- [ ] Integrate logic analyzer IP for the FPGA to view registers
- [ ] Verify a program with memory file
- [ ] Verify a program flashed with uart