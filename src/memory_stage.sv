`include "common.sv"
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
    input [31:0] memory_data,

    output logic [31:0] memory_bypass,
    output logic [31:0] memory_output,
    output control_type control_out,
    output logic [4:0] rd_out,
    output logic [31:0] pc_out
);

  data_memory data_memory (
      .clk(clk),
      .rst(rst),
      .byte_address(alu_result),  //From alu result
      .write_data(memory_data),  //From alu bypass
      .MemWrite(MemWrite),
      .MemRead(MemRead),
      .output_data(memory_output)
  );

  always_comb begin
    memory_bypass = alu_result;
    rd_out = rd_in;
    control_out = control_in;
    pc_out = pc;

    if (control_in.encoding_type == B_TYPE) begin
      case (instruction_type.funct3)
        FUNCT3_BEQ: begin
          if (!alu_result) begin
            // We want to branch
          end
        end
        FUNCT3_BNE: begin
          if (alu_result != 0) begin
            pc_out = 1;
          end
        end
        FUNCT3_BLT: begin

        end
        FUNCT3_BGE: begin

        end
        FUNCT3_BLTU: begin

        end
        FUNCT3_BGEU: begin

        end
        default: ;
      endcase
    end
  end

  // Save to memory: To be implemented

endmodule
