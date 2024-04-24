`include "common.sv"

import common::*;

module decompressor (
    input logic [15:0] input_instruction,
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
  localparam logic [9:0] C_AND = {3'b100, 1'b0, 2'b11, 2'b00, 2'b01};
  localparam logic [6:0] C_ANDI = {3'b100, 2'b10, 2'b01};
  localparam logic [9:0] C_OR = {3'b100, 1'b0, 2'b11, 2'b10, 2'b01};
  localparam logic [9:0] C_XOR = {3'b100, 1'b0, 2'b11, 2'b01, 2'b01};
  localparam logic [5:0] C_MV = {3'b100, 1'b0, 2'b10};
  localparam logic [4:0] C_LI = {3'b010, 2'b01};
  localparam logic [4:0] C_LUI = {3'b011, 2'b01};  //FEL

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
    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_ADDI) begin
      //ADDI INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[12], input_instruction[11:10], input_instruction[6:5], input_instruction[1:0]} == C_SUB) begin
      //SUB INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[12], input_instruction[11:10], input_instruction[6:5], input_instruction[1:0]} == C_AND) begin
      //AND INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[11:10], input_instruction[1:0]} == C_ANDI) begin
      //ANDI INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[12], input_instruction[11:10], input_instruction[6:5], input_instruction[1:0]} == C_OR) begin
      //OR INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[12], input_instruction[11:10], input_instruction[6:5], input_instruction[1:0]} == C_XOR) begin
      //XOR INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[12], input_instruction[1:0]} == C_MV) begin
      //MV INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[11:10], input_instruction[1:0]} == C_BNEZ) begin
      //SRAI INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[11:10], input_instruction[1:0]} == C_BNEZ) begin
      //SRLI INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_LI) begin
      //LI INSTUCTION
    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_LUI) begin
      //LU INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_LW) begin
      //LW INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_SW) begin
      //SW INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_BEQZ) begin
      //BEQZ INSTRUCTION
    end else if ({input_instruction[15:13], input_instruction[1:0]} == C_BNEZ) begin
      //BNEZ INSTRUCTION
    end else begin
      output_instruction = input_instruction;
    end

  end

endmodule
