`timescale 1ps / 1ps

import common::*;

module memory_stage (
  input clk,
  input rst,
  input [31:0] alu_result,
  input MemWrite,
  input MemRead,

  output memory_bypass,
  output memory_output
);

always_comb begin
  memory_output = alu_result;
end

// Save to memory: To be implemented

endmodule
