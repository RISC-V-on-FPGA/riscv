`timescale 1ps / 1ps

import common::*;

module alu (
    input wire [3:0] control,
    input wire [31:0] left_operand,
    input wire [31:0] right_operand,
    output logic ZeroFlag,
    output logic [31:0] result
);

  always_comb begin
    case (control)
      // Shifts (To be added)

      // Arithmetic
      ALU_ADD: result = left_operand + right_operand;
      ALU_SUB: result = left_operand - right_operand;

      // Logical
      ALU_AND: result = left_operand & right_operand;
      ALU_OR:  result = left_operand | right_operand;
      ALU_XOR: result = left_operand ^ right_operand;

      // Compare (To be added)

      default: result = left_operand + right_operand;

    endcase
  end

endmodule
