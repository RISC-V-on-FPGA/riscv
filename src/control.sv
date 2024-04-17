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
  localparam logic [16:0] LUI_INSTRUCTION = {7'b0110111};

  // Shifts
  localparam logic [16:0] SLL_INSTRUCTION = {7'b0000000, 3'b001, 7'b0110011};
  localparam logic [16:0] SLLI_INSTRUCTION = {7'b0000000, 3'b001, 7'b0010011};
  localparam logic [16:0] SRL_INSTRUCTION = {7'b0000000, 3'b101, 7'b0110011};
  localparam logic [16:0] SRLI_INSTRUCTION = {7'b0000000, 3'b101, 7'b0010011};
  localparam logic [16:0] SRA_INSTRUCTION = {7'b0100000, 3'b101, 7'b0110011};
  localparam logic [16:0] SRAI_INSTRUCTION = {7'b0100000, 3'b101, 7'b0010011};

  // Logical
  localparam logic [16:0] XOR_INSTRUCTION = {7'b0000000, 3'b100, 7'b0110011};
  localparam logic [16:0] XORI_INSTRUCTION = {3'b100, 7'b0010011};
  localparam logic [16:0] OR_INSTRUCTION = {7'b0000000, 3'b110, 7'b0110011};
  localparam logic [16:0] ORI_INSTRUCTION = {3'b110, 7'b0010011};
  localparam logic [16:0] AND_INSTRUCTION = {7'b0000000, 3'b111, 7'b0110011};
  localparam logic [16:0] ANDI_INSTRUCTION = {3'b111, 7'b0010011};

  // Compare
  localparam logic [16:0] SLT_INSTRUCTION = {7'b0000000, 3'b010, 7'b0110011};
  localparam logic [16:0] SLTI_INSTRUCTION = {3'b010, 7'b0010011};
  localparam logic [9:0] SLTU_INSTRUCTION = {7'b0000000, 3'b011, 7'b0110011};
  localparam logic [9:0] SLTIU_INSTRUCTION = {3'b011, 7'b0010011};

  // Branches
  localparam logic [9:0] BEQ_INSTRUCTION = {3'b000, 7'b1100011};
  localparam logic [9:0] BNE_INSTRUCTION = {3'b001, 7'b1100011};
  localparam logic [9:0] BLT_INSTRUCTION = {3'b100, 7'b1100011};
  localparam logic [9:0] BGE_INSTRUCTION = {3'b101, 7'b1100011};
  localparam logic [9:0] BLTU_INSTRUCTION = {3'b110, 7'b1100011};
  localparam logic [9:0] BGEU_INSTRUCTION = {3'b111, 7'b1100011};

  // Load and store
  localparam logic [9:0] LW_INSTRUCTION = {3'b010, 7'b0000011};
  localparam logic [9:0] SW_INSTRUCTION = {3'b010, 7'b0100011};

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
      7'b0110111: begin
        control.encoding = U_TYPE;
        control.RegWrite = 1'b1;
        control.ALUSrc   = 1'b0;
      end
      7'b0000011: begin
        control.encoding = I_TYPE;
        control.RegWrite = 1'b1;
        control.ALUSrc = 1'b1;
        control.MemRead = 1'b1;
        control.MemtoReg = 1'b1;
      end
      7'b0100011: begin
        control.encoding = S_TYPE;
        control.RegWrite = 1'b0;
        control.ALUSrc = 1'b1;
        control.MemWrite = 1'b1;
      end
      7'b1100011: begin
        control.encoding = B_TYPE;
        control.RegWrite = 1'b0;
        control.ALUSrc   = 1'b0;
      end
    endcase

    if ({instruction.funct3, instruction.opcode} == ADDI_INSTRUCTION) begin
      control.ALUOp = ALU_ADD;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == ADD_INSTRUCTION) begin
      control.ALUOp = ALU_ADD;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SUB_INSTRUCTION) begin
      control.ALUOp = ALU_SUB;
    end else if (instruction.opcode == LUI_INSTRUCTION) begin
      control.ALUOp = ALU_LUI;
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
      control.ALUOp = ALU_SRA;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == XOR_INSTRUCTION) begin
      control.ALUOp = ALU_XOR;
    end else if ({instruction.funct3, instruction.opcode} == XORI_INSTRUCTION) begin
      control.ALUOp = ALU_XOR;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == OR_INSTRUCTION) begin
      control.ALUOp = ALU_OR;
    end else if ({instruction.funct3, instruction.opcode} == ORI_INSTRUCTION) begin
      control.ALUOp = ALU_OR;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == AND_INSTRUCTION) begin
      control.ALUOp = ALU_AND;
    end else if ({instruction.funct3, instruction.opcode} == ANDI_INSTRUCTION) begin
      control.ALUOp = ALU_AND;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SLT_INSTRUCTION) begin
      control.ALUOp = ALU_SLT;
    end else if ({instruction.funct3, instruction.opcode} == SLTI_INSTRUCTION) begin
      control.ALUOp = ALU_SLT;
    end else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SLTU_INSTRUCTION) begin
      control.ALUOp = ALU_SLTU;
    end else if ({instruction.funct3, instruction.opcode} == SLTIU_INSTRUCTION) begin
      control.ALUOp = ALU_SLTU;
    end else if ({instruction.funct3, instruction.opcode} == SW_INSTRUCTION) begin
      control.ALUOp = ALU_ADD;
    end else if ({instruction.funct3, instruction.opcode} == LW_INSTRUCTION) begin
      control.ALUOp = ALU_ADD;
    end else if ({instruction.funct3, instruction.opcode} == BEQ_INSTRUCTION) begin
      control.ALUOp = ALU_SUB;
    end

  end

endmodule
