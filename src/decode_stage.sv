`include "common.sv"
// `include "register_file.sv"
// `include "control.sv"
// `include "imm_gen.sv"

import common::*;

module decode_stage (
    input rst,
    input clk,
    input instruction_type instruction,  // From program_memory
    input [31:0] pc,
    input RegWrite,
    input [31:0] write_data,  // Input from write back stage
    input [4:0] write_id,
    input id_ex_MemRead,
    input [4:0] id_ex_rd,
    input mem_wb_RegWrite,
    input ex_mem_RegWrite,
    // Register destination input from execute missing, implement later for hazard detection
    output logic [31:0] data1,  // Output from register file
    output logic [31:0] data2,
    output logic [31:0] imm,
    output logic [4:0] rd,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output control_type control,  // Implement mux here later for hazard detection
    output logic [31:0] pc_branch,
    output logic [31:0] pc_out,
    output logic PCWrite,
    output logic FetchWrite,
    output logic PCSrc
);

  logic [63:0] imm_shifted;

  logic [31:0] data1_temp;
  logic [31:0] data2_temp;

  logic MakeBubble;
  control_type control_temp;

  control controller (
      .clk(clk),
      .rst(rst),
      .instruction(instruction),
      .control(control_temp)
  );

  imm_gen imm_gen (
      .instruction(instruction),
      .control(control),
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
      .read1_data(data1_temp),
      .read2_data(data2_temp)
  );

  hazard_detection_unit hazard_detection_unit (
      .id_ex_MemRead(id_ex_MemRead),
      .id_ex_rd(id_ex_rd),
      .instruction(instruction),
      .PCWrite(PCWrite),
      .FetchWrite(FetchWrite),
      .MakeBubble(MakeBubble)
  );

  forwarding_unit forwarding_unit (
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .ex_mem_rd(ex_mem_rd),
      .mem_wb_rd(mem_wb_rd),
      .mem_wb_RegWrite(mem_wb_RegWrite),
      .ex_mem_RegWrite(ex_mem_RegWrite),
      .mux_ctrl_left(mux_ctrl_left),
      .mux_ctrl_right(mux_ctrl_right)
  );

  // always_ff @(posedge clk) begin : Seq
  //   if (rst == 1) begin
  //     rs1 <= 0;
  //     rs2 <= 0;
  //     rd  <= 0;
  //   end
  // end

  always_comb begin : Comb
    rs1 = instruction.rs1;
    rs2 = instruction.rs2;
    rd = instruction.rd;

    imm_shifted = imm << 1;
    pc_branch = imm_shifted[31:0] + pc;
    read1_id = instruction.rs1;
    read2_id = instruction.rs2;

    pc_out = pc;

    if (MakeBubble == 1) begin
      control = 0;
    end else begin
      control = control_temp;
    end

    if (RegWrite && (rs1 == write_id)) begin
      data1 = write_data;
    end else begin
      data1 = data1_temp;
    end

    if (RegWrite && (rs2 == write_id)) begin
      data2 = write_data;
    end else begin
      data2 = data2_temp;
    end

    // // Branches
    // if (control.encoding == B_TYPE && control.BranchType == BRANCH_BEQ) begin
    //   if (data1 == data2 ) begin
    //     PCSrc = 1'b1;
    //   end
    // end else begin
    //   PCSrc = 0'b0;
    // end

    // Branches
    if (control.encoding == B_TYPE) begin
      case (control.BranchType)
        BRANCH_BEQ: begin
          if (data1 == data2) begin
            PCSrc = 1'b1;
          end
        end
        BRANCH_BNE: begin
          if (data1 ^ data2 != 0) begin
            PCSrc = 1'b1;
          end
        end
        BRANCH_BLT: begin

        end
        BRANCH_BGE: begin

        end
        BRANCH_BLTU: begin

        end
        BRANCH_BGEU: begin

        end
        default: PCSrc = 1'b0;
      endcase
    end else begin
      PCSrc = 1'b0;
    end


    // data1 = data1_temp;
    // data2 = data2_temp;

  end

endmodule
