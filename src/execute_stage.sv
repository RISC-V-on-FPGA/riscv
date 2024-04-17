`include "common.sv"
import common::*;

module execute_stage (
    input                     clk,
    input              [31:0] pc,
    //input              rst, Might not be needed due to execute stage being comb
    input control_type        control_in,
    input logic        [31:0] data1,
    input logic        [31:0] data2,
    input logic        [31:0] immediate_data,
    input              [ 4:0] rd_in,
    input              [ 4:0] rs1,
    input              [ 4:0] rs2,
    input              [ 4:0] ex_mem_rd,
    input              [ 4:0] mem_wb_rd,
    input                     ex_mem_RegWrite,
    input                     mem_wb_RegWrite,
    input              [31:0] forward_ex_mem,   // Value forwarded from mem stage, better name?
    input              [31:0] forward_mem_wb,   // Value from write back stage

    output control_type control_out,
    output logic ZeroFlag,
    output [31:0] alu_data,
    output [31:0] memory_data,
    output logic [4:0] rd_out,
    output [31:0] pc_out
);

  logic [31:0] right_operand;
  logic [31:0] left_operand;

  mux_control_type mux_ctrl_left;
  mux_control_type mux_ctrl_right;

  alu alu (
      .control(control_in.ALUOp),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .ZeroFlag(ZeroFlag),
      .result(alu_data)
  );

  forwarding_unit forwarding_unit (
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd_in),
      .ex_mem_rd(ex_mem_rd),
      .mem_wb_rd(mem_wb_rd),
      .mem_wb_RegWrite(mem_wb_RegWrite),
      .ex_mem_RegWrite(ex_mem_RegWrite),
      .mux_ctrl_left(mux_ctrl_left),
      .mux_ctrl_right(mux_ctrl_right)
  );

  always_comb begin : operand_selector
    // Deafult
    left_operand  = data1;
    right_operand = data2;

    // Forwarding left operand (A)
    case (mux_ctrl_left)
      Forward_ex_mem: left_operand = forward_ex_mem;
      Forward_mem_wb: left_operand = forward_mem_wb;
      default: ;
    endcase

    // Forwarding right operand (B)
    case (mux_ctrl_right)
      Forward_ex_mem: right_operand = forward_ex_mem;
      Forward_mem_wb: right_operand = forward_mem_wb;
      default: ;
    endcase

    // Loading immidiate value
    if (control_in.ALUSrc) begin
      right_operand = immediate_data;
    end
  end

  if (control_in.encoding_type == B_TYPE) begin
    case (instruction_type.funct3)
      FUNCT3_BEQ: begin
        if (!alu_result) begin
          // We want to branch
        end
      end
      FUNCT3_BNE: begin
        if (alu_result != 0) begin

        end
      end
      FUNCT3_BLT: begin

      end
      FUNCT3_BGE: begin

      end
      FUNCT3_BLTU: begin

      end
      FUNCT3_BGEU: begin

      end
      default: ;
    endcase
  end

  assign control_out = control_in;
  assign memory_data = data2;
  assign rd_out = rd_in;
  assign pc_out = pc;

endmodule
