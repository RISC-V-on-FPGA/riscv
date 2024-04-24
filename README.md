# RISC-V on FPGA

32-bit 5-stage RISC-V processor for FPGA implementation based on the book Computer Organization and Design: (https://www.amazon.se/-/en/David-Patterson/dp/0128122757)

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
-[x] C.LW
-[ ] C.SW
## Arithmetic
-[x] C.ADD
-[x] C.ADDI
-[ ] C.SUB
-[ ] C.AND
-[ ] C.ANDI
-[ ] C.OR
-[ ] C.XOR
-[ ] C.MV
-[ ] C.LI
-[ ] C.LUI
## Shifts
-[ ] C.SLLI
-[ ] C.SRAI
-[ ] C.SRLI
## Branches
-[ ] C.BEQZ
-[ ] C.BNEZ

# Short term plan
- [x] Make ADDI work
- [x] Make ADD work
- [x] Implement Forwarding
- [x] Implement register file forwarding (If we have data hazard after 3 cycles, it does not work)
- [x] Make SUB work
- [x] Make SHIFTS work
- [x] Make logic work
- [x] Make LUI work
- [x] Add so PC carries through all stages to make debugging easier
- [x] Implement program memory - Benjamin
- [x] Make LD work - Benjamin
- [x] Implement Hazard Detection Unit - Benjamin (Sakke)
- [x] Draw new forwarding unit for branches in architecture with muxes before decode equality test
- [x] Add hazard detection for branches
- [x] Make compare work (needs to be tested) - Benjamin
- [x] Make branch work - Sakke (Add Flush, through hazard detection)
- [x] Add forwarding for branches and muxes before decode equality test - Sakke
- [x] Implement support for compressed instructions - Sakke
- [x] UART - Benjamin
- [x] UART Testbench - Benjamin
- [ ] Make sure branches work with compresses instructions
- [ ] Test Test Test!
- [ ] Check for latches