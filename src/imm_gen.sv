`timescale 1ps / 1ps

import common::*;

module imm_gen (
  input instruction_type instruction,

  output [31:0] imm_gen_output
);

always_comb begin
  case (encoding_type)
    I_TYPE: begin
      imm_gen_output[11:0] = instruction[31:20];
      if (instruction[31] == 0) begin
        imm_gen_output[31:12] = 0;
      end else begin
        imm_gen_output [31:12] = {20{1'b1}};
      end
    end

    U_TYPE: begin
      imm_gen_output[11:0] = 0;
      imm_gen_output[31:12] = instruction [31:12];
    end

    S_TYPE: begin
      imm_gen_output[11:5] = instruction[31:25];
      imm_gen_output[4:0] = instruction[12:7];
      if (instruction[31] == 0) begin
        imm_gen_output[31:12] = 0;
      end else begin
        imm_gen_output [31:12] = {20{1'b1}};
      end
    end

    B_TYPE: begin
      imm_gen_output[12] = instruction[31];
      imm_gen_output[11] = instruction[7];
      imm_gen_output[10:5] = instruction[30:25];
      imm_gen_output[4:0] = instruction[11:8];
    end

    default: begin
      imm_gen_output[31:0] = instruction;
    end

  endcase
end

endmodule
