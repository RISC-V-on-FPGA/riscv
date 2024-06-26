# RISC-V on FPGA

32-bit 5-stage RISC-V processor for FPGA implementation based on the book Computer Organization and Design: (https://www.amazon.se/-/en/David-Patterson/dp/0128122757).

Assembler: [ripes.me](https://ripes.me/) or [AssembleRisc](https://github.com/masoud-ata/AssembleRisc).  
The scripts `*_to_bytes.py` converts into mem file. Then `send_uart.py` can be used to upload to program memory on the cpu via uart.

![alt text](image.png)

# Implemented Instructions
| Category   | Name                    | RV32I Base        | RV32C Compressed     |
| ---------- | ----------------------- | ----------------- | -------------------- |
| Shifts     | Shift Left Logical      | SLL  rd,rs1,rs2   |                      |
|            | Shift Left Log. Imm.    | SLLI rd,rs1,shamt | C.SLLI rd,imm.       |
|            | Shift Right Logical     | SRL rd,rs1,rs2    |                      |
|            | Shift Right Log. Imm.   | SRLI rd,rs1,shamt | C.SRLI rd,imm.       |
|            | Shift Right Arithmetic  | SRA rd,rs1,rs2    |                      |
|            | Shift Right Arith. Imm. | SRAI rd,rs1,shamt | C.SRAI rd,imm.       |
| Arithmetic | ADD                     | ADD rd,rs1,rs2    | C.ADD rd,rs1         |
|            | ADD Imm.                | ADDI rd,rs1,rs2   | C.ADDI rd, imm       |
|            | SUBtract                | SUB rd,rs1,rs2    | C.SUB rd,rs1         |
|            | Load Upper imm.         | LUI rd, imm       | C.LUI rd,imm.        |
|            | MoVe                    |                   | C.MV rd,rs1          |
|            | Load imm.               |                   | C.LI rd,imm.         |
| Logical    | XOR                     | XOR rd,rs1,rs2    | C.XOR rd,rs1         |
|            | XOR imm.                | XORI rd,rs1,imm   |                      |
|            | OR                      | OR rd,rs1,rs2     | C.OR rd,rs1          |
|            | OR imm.                 | ORI rd,rs1,imm    |                      |
|            | AND                     | AND rd,rs1,rs2    | C.AND rd,rs1         |
|            | AND imm.                | ANDI rd,rs1,imm   | C.ANDI rd,imm.       |
| Compare    | Set <                   | SLT rd,rs1,rs2    |                      |
|            | Set < imm.              | SLTI rd,rs1,imm   |                      |
|            | Set < unsigned          | SLTU rd,rs1,rs2   |                      |
|            | Set < imm. unsigned     | SLTIU rd,rs1,imm  |                      |
| Branches   | Branch =                | BEQ rs1,rs2,imm   |                      |
|            | Branch $\neq$           | BNE rs1,rs2,imm   |                      |
|            | Branch <                | BLT rs1,rs2,imm   |                      |
|            | Branch $\ge$            | BGE rs1,rs2,imm   |                      |
|            | Branch < unsigned       | BLTU rs1,rs2,imm  |                      |
|            | Branch $\ge$ unsigned   | BGEU rs1,rs2,imm  |                      |
|            | Branch = 0              |                   | C.BEQZ rs1',imm.     |
|            | Branch $\ne$ 0          |                   | C.BNEZ rs1',imm.     |
| Loads      | Load Word               | LW rd,rs1,imm     | C.LW rd',rs1',imm.   |
| Stores     | Store Word              | SW rs1,rs2,imm    | C.SW rs1',rs2', imm. |
