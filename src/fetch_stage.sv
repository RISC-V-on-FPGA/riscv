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
    output logic [31:0] pc,
    output instruction_type instruction
);

  logic write_enable;
  logic [31:0] write_data;
  logic [31:0] write_address;
  logic clear_mem;

  program_memory program_memory (
      .clk(clk),
      .pc(pc),
      .write_enable(write_enable),
      .write_data(write_data),
      .write_address(write_address),
      .clear_mem(clear_mem),
      .read_instruction(instruction)
  );

  logic [31:0] pc_next;
  logic [31:0] pc_counter_address;
  logic [31:0] pc_counter_instruction;
  logic [31:0] pc_instruction;

  typedef enum logic [3:0] {
    FLASH_CLEAR,  //Clear program memory
    FLASH_SHIFT,  //Shift bytes to make a 32 bit instruction (4 bytes)
    FLASH_WRITE   //Write 32 bits to program memory
  } state_type;

  state_type state;

  always_ff @(posedge clk) begin : ProgMemSeq
    if (flash == 1) begin
      clear_mem <= 0;
      write_enable <= 0;

      case (state)

        FLASH_CLEAR: begin
          clear_mem <= 1;
          state <= FLASH_SHIFT;
        end

        FLASH_SHIFT: begin
          if (uart_received == 1) begin
            pc_counter_instruction <= pc_counter_instruction + 1;
            pc_instruction <= (pc_instruction << 8) | uart_data;
            if (pc_counter_instruction >= 3) begin
              state <= FLASH_WRITE;
            end
          end
        end

        FLASH_WRITE: begin
          pc_counter_instruction <= 0;
          pc_counter_address <= pc_counter_address + 4;
          write_address <= pc_counter_address;
          write_enable <= 1;
          state <= FLASH_SHIFT;
        end
        default: begin

        end
      endcase
    end
  end

  always_comb begin : ProgMemComb
    if (flash == 1) begin
      write_data = pc_instruction;
    end
  end

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      pc <= 0;
      pc_counter_address <= 0;
      pc_counter_instruction <= 0;
      clear_mem <= 0;
      pc_instruction <= 0;
      write_enable <= 0;
      write_data <= 0;
      state <= FLASH_CLEAR;
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
    end else begin
      pc_next = pc + 4;
    end
  end

endmodule
