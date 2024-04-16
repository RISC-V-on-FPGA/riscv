`include "common.sv"
import common::*;

module control (
    input clk,
    input rst,
    input instruction_type instruction,
    output control_type control
);
  // Arithemtic
  localparam logic [16:0] ADD_INSTRUCTION = {7'b0000000, 3'b000, 7'b0110011};
  localparam logic [16:0] SUB_INSTRUCTION = {7'b0100000, 3'b000, 7'b0110011};
  localparam logic [9:0] ADDI_INSTRUCTION = {3'b000, 7'b0010011};

  // Shifts
  localparam logic [16:0] SLL_INSTRUCTION = {7'b0000000, 3'b001, 7'b0110011};
  localparam logic [16:0] SLLI_INSTRUCTION = {7'b0000000, 3'b001, 7'b0010011};
  localparam logic [16:0] SRL_INSTRUCTION = {7'b0000000, 3'b101, 7'b0110011};
  localparam logic [16:0] SRLI_INSTRUCTION = {7'b0000000, 3'b101, 7'b0010011};
  localparam logic [16:0] SRA_INSTRUCTION = {7'b0000000, 3'b101, 7'b0110011};
  localparam logic [16:0] SRAI_INSTRUCTION = {7'b0000000, 3'b101, 7'b0010011};

  // Load and store
  localparam logic [9:0] LW_INSTRUCTION = {3'b010, 7'b0000011};
  localparam logic [9:0] SW_INSTRUCTION = {3'b010, 7'b0100011};
  localparam logic [9:0] BEQ_INSTRUCTION = {3'b000, 7'b1100011};

  always_comb begin
    control = 0;

    case (instruction.opcode)
      7'b0010011: begin
        control.encoding = I_TYPE;
        control.RegWrite = 1'b1;
        control.ALUSrc   = 1'b1;
      end
      7'b0110011: begin
        control.encoding = R_TYPE;
        control.RegWrite = 1'b1;
        control.ALUSrc   = 1'b0;
      end
    endcase

    if ({instruction.funct3, instruction.opcode} == ADDI_INSTRUCTION) begin
      control.ALUOp = ALU_ADD;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == ADD_INSTRUCTION) begin
      control.ALUOp = ALU_ADD;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SUB_INSTRUCTION) begin
      control.ALUOp = ALU_SUB;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SLL_INSTRUCTION) begin
      control.ALUOp = ALU_SLL;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SLLI_INSTRUCTION) begin
      control.ALUOp = ALU_SLL;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SRL_INSTRUCTION) begin
      control.ALUOp = ALU_SRL;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SRLI_INSTRUCTION) begin
      control.ALUOp = ALU_SRL;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SRA_INSTRUCTION) begin
      control.ALUOp = ALU_SRA;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SRAI_INSTRUCTION) begin
      control.ALUOp = ALU_SRL;
    end

  end

endmodule
