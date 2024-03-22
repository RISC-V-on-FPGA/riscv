package common;

  // Controls signals into ALU, (( not ALUOp ))
  typedef enum logic [3:0] {
    // Shifts
    ALU_SLL  = 4'b0000, // Shift Left Logical (Fill with 0's)
    ALU_SRL  = 4'b0001, // Shift Right Logical (Fill with 0's)
    ALU_SRA  = 4'b0010, // Shift Right Arithmetic (Sign bit preserved)
    // Arithmetic
    ALU_ADD  = 4'b0100,
    ALU_SUB  = 4'b0101,
    ALU_LUI  = 4'b0110, // Not sure if ALU is needed for this, but for reservation
    // Logical
    ALU_XOR  = 4'b1000,
    ALU_OR   = 4'b1001,
    ALU_AND  = 4'b1010,
    // Compare
    ALU_SLT  = 4'b1100, // Set <
    ALU_SLTU = 4'b1101 // Set < Unsigned
  } alu_op_type;

endpackage
