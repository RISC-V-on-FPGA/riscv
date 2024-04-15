import common::*;

module execute_stage (
    input              clk,
    //input              rst, Might not be needed due to execute stage being comb
    input control_type control_in,
    input logic [31:0] data1,
    input logic [31:0] data2,
    input logic [31:0] immediate_data,
    input [4:0] rd_in,
    input [31:0] forward_ex_mem, // Value forwarded from mem stage, better name?
    input [31:0] forward_mem_wb,  // Value from write back stage
    input [1:0] mux_ctrl_left,
    input [1:0] mux_ctrl_right,

    output control_type control_out,
    output logic  ZeroFlag,
    output [31:0] alu_data,
    output [31:0] memory_data,
    output logic [4:0] rd_out
);

  logic [31:0] right_operand;
  logic [31:0] left_operand;

  alu alu (
      .control(control_in.ALUOp),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .ZeroFlag(ZeroFlag),
      .result(alu_data)
  );

  always_comb begin : operand_selector
    // Deafult
    left_operand  = data1;
    right_operand = data2;

    // Loading immidiate value
    if (control_in.ALUSrc) begin
      right_operand = immediate_data;
    end

    // Forwarding left operand (A)
    case (mux_ctrl_left)
      mux_control_type.Forward_ex_mem: left_operand = forward_mem;
      mux_control_type.Forward_mem_wb: left_operand = forward_wb;
      default: left_operand = data2; // Ta bort?
    endcase

    // Forwarding right operand (B)
    case (mux_ctrl_right)
      mux_control_type.Forward_mem: right_operand = forward_mem;
      mux_control_type.Forward_wb: right_operand = forward_wb;
      default: right_operand = data1; // Ta bort?
    endcase
  end

  // Forwarding: To be implemented

  assign control_out = control_in;
  assign memory_data = data2;
  assign rd_out = rd_in;

endmodule
