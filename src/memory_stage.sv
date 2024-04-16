import common::*;

module memory_stage (
    input clk,
    input rst,
    input [31:0] alu_result,
    input MemWrite,
    input MemRead,
    input control_type control_in,
    input [4:0] rd_in,
    input [31:0] pc,

    output logic [31:0] memory_bypass,
    output logic [31:0] memory_output,
    output control_type control_out,
    output logic [4:0] rd_out,
    output logic [31:0] pc_out
);

  always_comb begin
    memory_bypass = alu_result;
    rd_out = rd_in;
    control_out = control_in;
    pc_out = pc;
  end

  // Save to memory: To be implemented

endmodule
