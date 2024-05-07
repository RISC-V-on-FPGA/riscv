// `include "common.sv"
// `include "program_memory.sv"
// `include "decompressor.sv"

import common::*;

module fetch_stage (
    input clk,
    input rst,
    input [31:0] pc_branch,
    input PCSrc,
    input PCWrite,
    input [7:0] uart_data,  // TODO
    input uart_received,
    input flash,
    input IF_Flush,
    output logic [31:0] pc,
    output instruction_type instruction
);

  logic write_enable;
  logic [7:0] write_data;
  logic [31:0] write_address;
  // logic clear_mem;
  instruction_type instruction_temp;
  instruction_type instruction_decompressed;
  logic flag_compressed;
  logic [15:0] instruction_compressed;

  program_memory program_memory (
      .clk(clk),
      .pc(pc),
      .write_enable(write_enable),
      .write_data(write_data),
      .write_address(write_address),
      //.clear_mem(clear_mem),
      .read_instruction(instruction_temp),
      .flag_compressed(flag_compressed)
  );

  decompressor decompressor (
      .input_instruction (instruction_compressed),
      .output_instruction(instruction_decompressed)
  );

  logic [31:0] pc_next;
  logic [31:0] pc_counter_address;
  logic [31:0] pc_instruction;

  always_ff @(posedge clk) begin : ProgMemSeq
    if (flash == 0) begin
      write_enable <= 0;
      write_address <= 0;
      pc_counter_address <= 0;
    end else begin
      if (uart_received == 1) begin
        write_enable <= 1;
        pc_counter_address <= pc_counter_address + 1;
        write_address <= pc_counter_address;
      end else begin
        write_enable <= 0;
      end
    end
  end

  always_comb begin : ProgMemComb
    write_data = uart_data;
  end

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      pc <= 0;
    end else begin
      if (PCWrite == 1 && flash == 0) begin
        pc <= pc_next;
      end
    end
  end

  always_comb begin : Comb
    instruction_compressed = instruction_temp[15:0];

    if (PCSrc == 1) begin
      pc_next = pc_branch;
    end else if (flash == 1) begin
      pc_next = 0;
    end else if (flag_compressed == 0) begin
      pc_next = pc + 4;
    end else begin
      pc_next = pc + 2;
    end

    if (IF_Flush == 1) begin
      instruction = 0;
    end else if (flag_compressed == 0) begin
      instruction = instruction_temp;
    end else begin
      instruction = instruction_decompressed;
    end

  end

endmodule
