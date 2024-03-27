`include "common.sv"
`include "program_memory.sv"

import common::*;

module fetch_stage (
    input clk,
    input rst,
    input [31:0] pc_branch,
    input PCSrc,
    input PCWrite,
    input [31:0] uart_data,  // TODO
    output logic [31:0] pc,
    output instruction_type instruction
);

  logic write_enable;
  logic [31:0] write_data;

  program_memory program_memory (
      .clk(clk),
      .pc(pc),
      .write_enable(write_enable),
      .write_data(write_data),
      .read_instruction(instruction)
  );

  logic [31:0] pc_next;

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      pc <= 0;
      // pc_next <= 0;
    end else begin
      if (PCWrite == 1) begin
        pc <= pc_next;
      end
    end
  end

  always_comb begin : Comb
    if (PCSrc == 1) begin
      pc_next = pc_branch;
    end else begin
      pc_next = pc + 4;
    end

    // Change this later when we implement writing to program memory
    write_enable = 0;
    write_data = 0;

  end

endmodule
