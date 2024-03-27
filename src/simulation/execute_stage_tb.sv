`timescale 1ps / 1ps
import common::*;

module execute_stage_tb;

  logic clk, rst, ALUSrc, ZeroFlag;
  control_type control_in, control_out;
  logic [31:0] data1, data2, alu_data, memory_data;

  execute_stage  uut(
      .clk(clk),
      .ALUSrc(ALUSrc),
      .control_in(control_in),
      .data1(data1),
      .data2(data2),
      .immediate_data(immediate_data),
      .control_out(control_out),
      .ZeroFlag(ZeroFlag),
      .alu_data(alu_data),
      .memory_data(memory_data)
  );

  parameter period = 2;

  always #(period/2) clk = ~clk;

  initial begin
    // Resets all control signals
    control_in.alu_op = 0;
    control_in.encoding = 0;
    control_in.ALUSrc = 0;
    control_in.MemRead = 0;
    control_in.MemWrite = 0;
    control_in.RegWrite = 0;
    control_in.MemtoReg = 0;
    control_in.is_branch = 0;
    alu_src = 0;
    data1 = 0;
    data2 = 0;
    immediate_data = 0;
    #(2*period);

    assert (alu_data == 0) else $error("");


    #(100*period);

    $finish();
  end

endmodule
