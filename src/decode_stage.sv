`include "common.sv"
// `include "register_file.sv"
// `include "control.sv"
// `include "imm_gen.sv"

import common::*;

module decode_stage (
    input rst,
    input clk,
    input instruction_type instruction,  // From program_memory
    input encoding_type encoding,
    input [31:0] pc,
    input RegWrite,
    input [31:0] write_data,  // Input from write back stage
    input [4:0] write_id,
    // Register destination input from execute missing, implement later for hazard detection
    output logic [31:0] data1,  // Output from register file
    output logic [31:0] data2,
    output logic [31:0] imm,
    output logic [5:0] rd,
    output logic [31:0] rs1,
    output logic [31:0] rs2,
    output control_type control,  // Implement mux here later for hazard detection
    output logic [31:0] pc_branch
);

  logic [63:0] imm_shifted;

  control controller (
      .clk(clk),
      .rst(rst),
      .instruction(instruction),
      .control(control)
  );

  imm_gen imm_gen (
      .instruction(instruction),
      .encoding(encoding),
      //Imm gen before left shift
      .imm_gen_output(imm)
  );

  logic [4:0] read1_id;
  logic [4:0] read2_id;

  register_file register_file (
      .clk(clk),
      .rst(rst),
      .write_en(RegWrite),
      .read1_id(read1_id),
      .read2_id(read2_id),
      .write_id(write_id),
      .write_data(write_data),
      .read1_data(data1),
      .read2_data(data2)
  );

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      rs1     <= 0;
      rs2     <= 0;
      rd      <= 0;
    end else begin
      rs1 <= instruction.rs1;
      rs2 <= instruction.rs2;
      rd  <= instruction.rd;
    end
  end

  always_comb begin : Comb
    imm_shifted = imm << 1;
    pc_branch = imm_shifted[31:0] + pc;
    read1_id = instruction.rs1;
    read2_id = instruction.rs2;
  end

endmodule
