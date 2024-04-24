`include "common.sv"
`include "program_memory.sv"

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
  logic clear_mem;
  instruction_type instruction_temp;
  instruction_type instruction_decompressed;
  logic flag_compressed;

  program_memory program_memory (
      .clk(clk),
      .pc(pc),
      .write_enable(write_enable),
      .write_data(write_data),
      .write_address(write_address),
      .clear_mem(clear_mem),
      .read_instruction(instruction_temp),
      .flag_compressed(flag_compressed)
  );

  decompressor decompressor(
    .input_instruction(instruction_temp),
    .output_instruction(instruction_decompressed)
  );

  logic [31:0] pc_next;
  logic [31:0] pc_counter_address;
  logic [31:0] pc_instruction;

  typedef enum logic [3:0] {
    FLASH_CLEAR,  //Clear program memory
    FLASH_WRITE   //Write to memory
  } state_type;

  state_type state;

  always_ff @(posedge clk) begin : ProgMemSeq
    if (flash == 1) begin
      clear_mem <= 0;
      write_enable <= 0;

      case (state)

        FLASH_CLEAR: begin
          clear_mem <= 1;
          state <= FLASH_WRITE;
        end

        FLASH_WRITE: begin
          if (uart_received == 1) begin
            write_enable <= 1;
            pc_counter_address <= pc_counter_address + 1;
            write_address <= pc_counter_address;
          end else begin
            write_enable <= 0;
          end
        end
        default: begin

        end
      endcase
    end
  end

  always_comb begin : ProgMemComb
    if (flash == 1) begin
      write_data = uart_data;
    end
  end

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      pc <= 0;
      pc_counter_address <= 0;
      clear_mem <= 0;
      write_enable <= 0;
      write_address <= 0;
      write_data <= 0;
      state <= FLASH_CLEAR;
      flag_compressed <= 0;
    end else if (flash == 1) begin
      pc <= 0;
    end else begin
      if (PCWrite == 1) begin
        pc <= pc_next;
      end
    end
  end

  always_comb begin : Comb
    if (PCSrc == 1) begin
      pc_next = pc_branch;
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
