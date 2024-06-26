// `include "common.sv"

import common::*;

module imm_gen (
  input instruction_type instruction,
  input control_type control,

  output logic [31:0] imm_gen_output
);

always_comb begin
  case (control.encoding)
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
      imm_gen_output[4:1] = instruction[11:8];
      imm_gen_output[0] = 0;
      if (instruction[31] == 0) begin
        imm_gen_output[31:13] = 0;
      end else begin
        imm_gen_output [31:13] = {20{1'b1}};
      end
    end

    default: begin
      imm_gen_output[31:0] = instruction;
    end

  endcase
end

endmodule
