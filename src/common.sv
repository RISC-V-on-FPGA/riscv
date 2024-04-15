package common;

  // Controls signals into ALU, (( not ALUOp ))
  typedef enum logic [3:0] {
    // Shifts
    ALU_SLL  = 4'b0000,  // Shift Left Logical (Fill with 0's)
    ALU_SRL  = 4'b0001,  // Shift Right Logical (Fill with 0's)
    ALU_SRA  = 4'b0010,  // Shift Right Arithmetic (Sign bit preserved)
    // Arithmetic
    ALU_ADD  = 4'b0100,
    ALU_SUB  = 4'b0101,
    ALU_LUI  = 4'b0110,  // Not sure if ALU is needed for this, but for reservation
    // Logical
    ALU_XOR  = 4'b1000,
    ALU_OR   = 4'b1001,
    ALU_AND  = 4'b1010,
    // Compare
    ALU_SLT  = 4'b1100,  // Set <
    ALU_SLTU = 4'b1101   // Set < Unsigned
  } alu_op_type;

  typedef enum logic [1:0] {
    Forward_def = 2'b00,    // The first ALU operand comes from the register file
    Forward_ex_mem = 2'b10,    // The first ALU operand is forwarded from the prior ALU result
    Forward_mem_wb = 2'b01    // The first ALU operand is forwarded from data memory or earlier ALU result
  } mux_control_type;

  typedef enum logic [2:0] {
    FUNCT3_ADDI = 3'b000
  } funct3_type;

  typedef enum logic [6:0] {
    OPCODE_I_TYPE = 7'b0010011
  } opcode_type;

  typedef enum logic [2:0]
    {
        R_TYPE,
        I_TYPE,
        S_TYPE,
        B_TYPE,
        U_TYPE,
        J_TYPE
    } encoding_type;

  typedef struct packed {
        alu_op_type ALUOp;
        encoding_type encoding;
        logic ALUSrc;
        logic MemRead;
        logic MemWrite;
        logic RegWrite;
        logic MemtoReg;
        logic is_branch; // What is this?
  } control_type;

  typedef struct packed {
    logic [6:0] funct7;
    logic [4:0] rs2;
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [4:0] rd;
    logic [6:0] opcode;
  } instruction_type;


endpackage
