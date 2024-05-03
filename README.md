# RISC-V on FPGA

32-bit 5-stage RISC-V processor for FPGA implementation based on the book Computer Organization and Design: (https://www.amazon.se/-/en/David-Patterson/dp/0128122757).

Assembler used: [ripes.me](https://ripes.me/). Then the script `ripes_to_bytes.py` converts into mem file. 

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
- [ ] Make sure every register is reset on rst
- [ ] Create Testcases for every Category of instructions
  - [ ] Arithmetic
  - [ ] Compare
  - [ ] Logical
  - [ ] Shifts
  - [x] Branches
  - [x] Load
  - [x] Store
- [ ] Create testcases for implemented improvements
  - [ ] Forwarding: From EX/MEM, MEM/WB and register file forwarding
  - [ ] Hazard on loads (bubble from hazard detection unit)
  - [ ] Hazard on branch (bubble from hazard detection unit)
- [ ] Create Branch for sim (MAIN FPGA)
