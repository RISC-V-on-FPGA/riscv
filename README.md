# RISC-V on FPGA

32-bit 5-stage RISC-V processor for FPGA implementation based on the book Computer Organization and Design: (https://www.amazon.se/-/en/David-Patterson/dp/0128122757)

![alt text](image.png)

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
- [ ] Make branch work - Sakke (Add Flush, through hazard detection)
- [ ] Add forwarding for branches and muxes before decode equality test - Sakke
- [ ] Implement support for compressed instructions - Sakke
- [ ] UART - Benjamin
- [ ] UART Testbench - Benjamin
- [ ] Check for latches

# Checklist
## Shifts
- [x] SLL
- [x] SLLI
- [x] SRL
- [x] SRLI
- [x] SRA
- [x] SRAI
## Arithmetic
- [x] ADD
- [x] ADDI
- [x] SUB
- [x] LUI
## Logical
- [x] XOR
- [x] XORI
- [x] OR
- [x] ORI
- [x] AND
- [x] ANDI
## Compare
- [x] SLT
- [ ] SLTI (Implemented but not tested, not in Masimulator)
- [x] SLTU
- [ ] SLTIU (Implemeted but not tested, not in Masimulator)
## Branches
- [x] BEQ
- [x] BNE
- [ ] BLT (Not tested)
- [ ] BGE (Not tested)
- [ ] BLTU (Not tested)
- [ ] BGEU (Not tested)
## Loads and Stores
- [x] LW
- [x] SW
### Compressed (16-bit) Instruction Extension
## Loads and Stores
- [ ] C.LW
- [ ] C.SW
## Arithmetic
- [ ] C.ADD
- [ ] C.ADDI
- [ ] C.SUB
- [ ] C.AND
- [ ] C.ANDI
- [ ] C.OR
- [ ] C.XOR
- [ ] C.MV
- [ ] C.LI
- [ ] C.LUI
## Shifts
- [ ] C.SLLI
- [ ] C.SRAI
- [ ] C.SRLI
## Branches
- [ ] C.BEQZ
- [ ] C.BNEZ