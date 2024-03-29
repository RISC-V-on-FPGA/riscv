`timescale 1ps / 1ps

import common::*;

module execute_stage (
    input              clk,
    //input              rst, Might not be needed due to execute stage being comb
    input              ALUSrc,
    input control_type control_in,
    input logic [31:0] data1,
    input logic [31:0] data2,
    input logic [31:0] immediate_data,

    output control_type control_out,
    output logic  ZeroFlag,
    output [31:0] alu_data,
    output [31:0] memory_data
);

  alu alu (
      .control(ALUControl),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .ZeroFlag(ZeroFlag),
      .result(alu_data)
  );

  logic [31:0] right_operand;
  logic [31:0] left_operand;

  always_comb begin : operand_selector
    left_operand  = data1;
    right_operand = data2;
    if (control_in.alu_src) begin
      right_operand = immediate_data;
    end
  end

  // Forwarding: To be implemented

  assign control_out = control_in;
  assign memory_data = data2;

endmodule
