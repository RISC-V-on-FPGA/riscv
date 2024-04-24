`include "common.sv"

import common::*;

module decompressor (
    input [15:0] input_instruction,
    output instruction_type output_instruction
);
  // Loads
  localparam logic [4:0] C_LW = {3'b010, 2'b00};

  // Stores
  localparam logic [4:0] C_SW = {3'b110, 2'b00};

  // Arithmetic
  localparam logic [5:0] C_ADD = {3'b100, 1'b1, 2'b10};
  localparam logic [4:0] C_ADDI = {3'b000, 2'b01};
  localparam logic [9:0] C_SUB = {3'b100, 1'b0, 2'b11, 2'b00, 2'b01};
  localparam logic [9:0] C_AND = {3'b100, 1'b0, 2'b11, 2'b11, 2'b01};
  localparam logic [6:0] C_ANDI = {3'b100, 2'b10, 2'b01};
  localparam logic [9:0] C_OR = {3'b100, 1'b0, 2'b11, 2'b10, 2'b01};
  localparam logic [9:0] C_XOR = {3'b100, 1'b0, 2'b11, 2'b01, 2'b01};
  localparam logic [5:0] C_MV = {3'b100, 1'b0, 2'b10};
  localparam logic [4:0] C_LI = {3'b010, 2'b01};
  localparam logic [4:0] C_LUI = {3'b011, 2'b01};

  // Shifts
  localparam logic [4:0] C_SLLI = {3'b000, 2'b10};
  localparam logic [6:0] C_SRAI = {3'b100, 2'b01, 2'b01};
  localparam logic [6:0] C_SRLI = {3'b100, 2'b00, 2'b01};

  // Branches
  localparam logic [4:0] C_BEQZ = {3'b110, 2'b01};
  localparam logic [4:0] C_BNEZ = {3'b111, 2'b01};

  always_comb begin : blockName

    if ({input_instruction[15:13], input_instruction[12], input_instruction[1:0]} == C_ADD) begin
      //ADD INSTRUCTION
      output_instruction.funct7 = 0;
      output_instruction.rs2 = input_instruction[6:2];
      output_instruction.rs1 = input_instruction[11:7];
      output_instruction.funct3 = 0;
      output_instruction.rd = input_instruction[11:7];
      output_instruction.opcode = 7'b0110011;

    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_ADDI) begin
      //ADDI INSTRUCTION
      output_instruction.rs1 = input_instruction[11:7];
      output_instruction.rd = input_instruction[11:7];
      output_instruction.funct3 = 0;
      output_instruction.opcode = 7'b0010011;

      //Immidiate value
      output_instruction.rs2 = input_instruction[6:2];
      output_instruction.funct7[0] = input_instruction[12];
      output_instruction.funct7[6:1] = 0;

    end else if ({input_instruction[15:13], input_instruction[12], input_instruction[11:10], input_instruction[6:5], input_instruction[1:0]} == C_SUB) begin
      //SUB INSTRUCTION
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rs1[4:3] = 0;
      output_instruction.rd[2:0]  = input_instruction[9:7];
      output_instruction.rd[4:3]  = 0;
      output_instruction.rs2[2:0] = input_instruction[4:2];
      output_instruction.rs2[4:3] = 0;

      output_instruction.funct7   = 7'b0100000;
      output_instruction.funct3   = 0;
      output_instruction.opcode   = 7'b0110011;

    end else if ({input_instruction[15:13], input_instruction[12], input_instruction[11:10], input_instruction[6:5], input_instruction[1:0]} == C_AND) begin
      //AND INSTRUCTION
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rs1[4:3] = 0;
      output_instruction.rd[2:0]  = input_instruction[9:7];
      output_instruction.rd[4:3]  = 0;
      output_instruction.rs2[2:0] = input_instruction[4:2];
      output_instruction.rs2[4:3] = 0;

      output_instruction.funct7   = 7'b0000000;
      output_instruction.funct3   = 3'b111;
      output_instruction.opcode   = 7'b0110011;

    end else if ({input_instruction[15:13], input_instruction[11:10], input_instruction[1:0]} == C_ANDI) begin
      //ANDI INSTRUCTION
      output_instruction.rs1[4:3] = 0;
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rd[4:3] = 0;
      output_instruction.rd[2:0] = input_instruction[9:7];
      output_instruction.funct3 = 3'b111;
      output_instruction.opcode = 7'b0010011;

      //Immidiate value
      output_instruction.rs2 = input_instruction[4:0];
      output_instruction.funct7[0] = input_instruction[12];
      output_instruction.funct7[6:1] = 0;

    end else if ({input_instruction[15:13], input_instruction[12], input_instruction[11:10], input_instruction[6:5], input_instruction[1:0]} == C_OR) begin
      //OR INSTRUCTION
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rs1[4:3] = 0;
      output_instruction.rd[2:0]  = input_instruction[9:7];
      output_instruction.rd[4:3]  = 0;
      output_instruction.rs2[2:0] = input_instruction[4:2];
      output_instruction.rs2[4:3] = 0;

      output_instruction.funct7   = 7'b0000000;
      output_instruction.funct3   = 3'b110;
      output_instruction.opcode   = 7'b0110011;

    end else if ({input_instruction[15:13], input_instruction[12], input_instruction[11:10], input_instruction[6:5], input_instruction[1:0]} == C_XOR) begin
      //XOR INSTRUCTION
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rs1[4:3] = 0;
      output_instruction.rd[2:0]  = input_instruction[9:7];
      output_instruction.rd[4:3]  = 0;
      output_instruction.rs2[2:0] = input_instruction[4:2];
      output_instruction.rs2[4:3] = 0;

      output_instruction.funct7   = 7'b0000000;
      output_instruction.funct3   = 3'b100;
      output_instruction.opcode   = 7'b0110011;

    end else if ({input_instruction[15:13], input_instruction[12], input_instruction[1:0]} == C_MV) begin
      //MV INSTRUCTION
      output_instruction.funct7 = 0;
      output_instruction.rs2 = input_instruction[6:2];
      output_instruction.rs1 = 0;
      output_instruction.funct3 = 0;
      output_instruction.rd = input_instruction[11:7];
      output_instruction.opcode = 7'b0110011;

    end else if ({input_instruction[15:13], input_instruction[11:10], input_instruction[1:0]} == C_BNEZ) begin
      //SRAI INSTRUCTION
      output_instruction.rs1[4:3] = 0;
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rd[4:3] = 0;
      output_instruction.rd[2:0] = input_instruction[9:7];
      output_instruction.funct3 = 3'b101;
      output_instruction.opcode = 7'b0010011;

      //Immidiate value
      output_instruction.rs2 = input_instruction[6:2];
      output_instruction.funct7 = 7'b0100000;

    end else if ({input_instruction[15:13], input_instruction[11:10], input_instruction[1:0]} == C_BNEZ) begin
      //SRLI INSTRUCTION
      output_instruction.rs1[4:3] = 0;
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rd[4:3] = 0;
      output_instruction.rd[2:0] = input_instruction[9:7];
      output_instruction.funct3 = 3'b101;
      output_instruction.opcode = 7'b0010011;

      //Immidiate value
      output_instruction.rs2 = input_instruction[4:0];
      output_instruction.funct7 = 7'b0000000;

    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_LI) begin
      //LI INSTUCTION (ADDI rd, x0, imm)
      output_instruction.rs1 = 0;
      output_instruction.rd[2:0] = input_instruction[11:7];
      output_instruction.rd[4:3] = 0;
      output_instruction.funct3 = 0;
      output_instruction.opcode = 7'b0010011;

      //Immidiate value
      output_instruction.rs2 = input_instruction[6:2];
      output_instruction.funct7[0] = input_instruction[12];
      output_instruction.funct7[6:1] = 0;

    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_LUI) begin
      //LUI INSTRUCTION
      output_instruction.rd = input_instruction[11:7];
      output_instruction.opcode = 7'b0110111;

      //Immidiate value
      output_instruction.funct3 = input_instruction[4:2];
      output_instruction.rs1[1:0] = input_instruction[6:5];
      output_instruction.rs1[2] = input_instruction[12];
      output_instruction.rs1[4:3] = 0;
      output_instruction.rs2 = 0;
      output_instruction.funct7 = 0;

    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_LW) begin
      //LW INSTRUCTION
      output_instruction.rs1[4:3] = 0;
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rd[4:3] = 0;
      output_instruction.rd[2:0] = input_instruction[4:2];
      output_instruction.opcode = 7'b0000011;
      output_instruction.funct3 = 3'b010;

      output_instruction.rs2[4:3] = input_instruction[11:10];
      output_instruction.rs2[2] = input_instruction[6];
      output_instruction.rs2[1:0] = 0;
      output_instruction[6:2] = 0;
      output_instruction.funct7[1] = input_instruction[5];
      output_instruction.funct7[0] = input_instruction[12];

    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_SW) begin
      //SW INSTRUCTION
      output_instruction.rs1[4:3] = 0;
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rs2[4:3] = 0;
      output_instruction.rs2[2:0] = input_instruction[4:2];
      output_instruction.opcode = 7'b0100011;
      output_instruction.funct3 = 3'b010;

      output_instruction.rd[4:3] = input_instruction[11:10];
      output_instruction.rd[2] = input_instruction[6];
      output_instruction.rd[1:0] = 0;
      output_instruction.funct7[6:2] = 0;
      output_instruction.funct7[1] = input_instruction[5];
      output_instruction.funct7[0] = input_instruction[12];

    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_BEQZ) begin
      //BEQZ INSTRUCTION
      output_instruction.rs1[4:3] = 0;
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rs2 = 0;
      output_instruction.funct3 = 0;
      output_instruction.opcode = 7'b1100011;

      //Immidiate Value
      output_instruction.funct7[6:4] = 0;
      output_instruction.funct7[3] = input_instruction[12];
      output_instruction.funct7[2:1] = input_instruction[6:5];
      output_instruction.funct7[0] = input_instruction[2];
      output_instruction.rd[4:3] = input_instruction[11:10];
      output_instruction.rd[2:1] = input_instruction[4:3];
      output_instruction.rd[0] = 0;

    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_BNEZ) begin
      //BNEZ INSTRUCTION
      output_instruction.rs1[4:3] = 0;
      output_instruction.rs1[2:0] = input_instruction[9:7];
      output_instruction.rs2 = 0;
      output_instruction.funct3 = 3'b001;
      output_instruction.opcode = 7'b1100011;

      //Immidiate Value
      output_instruction.funct7[6:4] = 0;
      output_instruction.funct7[3] = input_instruction[12];
      output_instruction.funct7[2:1] = input_instruction[6:5];
      output_instruction.funct7[0] = input_instruction[2];
      output_instruction.rd[4:3] = input_instruction[11:10];
      output_instruction.rd[2:1] = input_instruction[4:3];
      output_instruction.rd[0] = 0;

    end else begin
      output_instruction = input_instruction;
    end
  end

endmodule
