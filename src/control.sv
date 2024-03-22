`include "common.sv"

module control (
    input clk,
    input rst,
    input instruction_type instruction,
    output control_type control
);

  localparam logic [16:0] ADD_INSTRUCTION = {7'b0000000, 3'b000, 7'b0110011};
  localparam logic [16:0] SUB_INSTRUCTION = {7'b0100000, 3'b000, 7'b0110011};
  localparam logic [9:0] ADDI_INSTRUCTION = {3'b000, 7'b0010011};
  localparam logic [9:0] LW_INSTRUCTION = {3'b010, 7'b0000011};
  localparam logic [9:0] SW_INSTRUCTION = {3'b010, 7'b0100011};
  localparam logic [9:0] BEQ_INSTRUCTION = {3'b000, 7'b1100011};

  always_comb begin

  end

endmodule
