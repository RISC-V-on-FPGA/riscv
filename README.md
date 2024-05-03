# RISC-V on FPGA

32-bit 5-stage RISC-V processor for FPGA implementation based on the book Computer Organization and Design: (https://www.amazon.se/-/en/David-Patterson/dp/0128122757).

Assembler used: [ripes.me](https://ripes.me/). Then the script `ripes_to_bytes.py` converts into mem file. 

![alt text](image.png)

# Implemented Instructions
| Category   | Name                    | RV32I Base        |
| ---------- | ----------------------- | ----------------- |
| Shifts     | Shift Left Logical      | SLL  rd,rs1,rs2   |
|            | Shift Left Log. Imm.    | SLLI rd,rs1,shamt |
|            | Shift Right Logical     | SRL rd,rs1,rs2    |
|            | Shift Right Log. Imm.   | SRLI rd,rs1,shamt |
|            | Shift Right Arithmetic  | SRA rd,rs1,rs2    |
|            | Shift Right Arith. Imm. | SRAI rd,rs1,shamt |
| Arithmetic | ADD                     | ADD rd,rs1,rs2    |
|            | ADD Imm.                | ADDI rd,rs1,rs2   |
|            | SUBtract                | SUB rd,rs1,rs2    |
|            | Load Upper imm.         | LUI rd, imm       |
| Logical    | XOR                     | XOR rd,rs1,rs2    |
|            | XOR imm.                | XORI rd,rs1,imm   |
|            | OR                      | OR rd,rs1,rs2     |
|            | OR imm.                 | ORI rd,rs1,imm    |
|            | AND                     | AND rd,rs1,rs2    |
|            | AND imm.                | ANDI rd,rs1,imm   |
| Compare    | Set <                   | SLT rd,rs1,rs2    |
|            | Set < imm.              | SLTI rd,rs1,imm   |
|            | Set < unsigned          | SLTU rd,rs1,rs2   |
|            | Set < imm. unsigned     | SLTIU rd,rs1,imm  |
| Branches   | Branch =                | BEQ rs1,rs2,imm   |
|            | Branch $\neq$           | BNE rs1,rs2,imm   |
|            | Branch <                | BLT rs1,rs2,imm   |
|            | Branch $\ge$            | BGE rs1,rs2,imm   |
|            | Branch < unsigned       | BLTU rs1,rs2,imm  |
|            | Branch $\ge$ unsigned   | BGEU rs1,rs2,imm  |
| Loads      | Load Word               | LW rd,rs1,imm     |
| Stores     | Store Word              | SW rs1,rs2,imm    |

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
- [x] Make sure every register is reset on rst
- [ ] Create Testcases for every Category of instructions
  - [ ] Arithmetic
  - [ ] Compare
  - [ ] Logical
  - [ ] Shifts
  - [ ] Branches
  - [x] Load
  - [x] Store
- [ ] Create testcases for implemented improvements
  - [ ] Forwarding: From EX/MEM, MEM/WB and register file forwarding
  - [ ] Hazard on loads (bubble from hazard detection unit)
  - [ ] Hazard on branch (bubble from hazard detection unit)
- [ ] Create Branch for sim (MAIN FPGA)
