// `include "common.sv"
// `include "register_file.sv"
// `include "control.sv"
// `include "imm_gen.sv"
// `include "forwarding_unit.sv"
// `include "hazard_detection_unit.sv"

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
    input [4:0] ex_mem_rd,
    input [4:0] mem_wb_rd,
    input [31:0] forward_ex_mem,
    input [31:0] forward_mem_wb,
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
    output logic PCSrc,
    output logic IF_Flush
);
  logic [4:0] read1_id;
  logic [4:0] read2_id;
  logic [31:0] right_operand;
  logic [31:0] left_operand;
  logic [63:0] imm_shifted;
  logic [31:0] data1_temp;
  logic [31:0] data2_temp;

  mux_control_type mux_ctrl_left;
  mux_control_type mux_ctrl_right;

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
      .MakeBubble(MakeBubble),
      .control(control_temp)
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

  always_comb begin : Comb
    rs1 = instruction.rs1;
    rs2 = instruction.rs2;
    rd = instruction.rd;

    imm_shifted = imm; // TOP 10 code lines
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

    // Branches
    left_operand  = data1;
    right_operand = data2;

    case (mux_ctrl_left)
      Forward_ex_mem: begin
        left_operand = forward_ex_mem;
      end
      Forward_mem_wb: begin
        left_operand = forward_mem_wb;
      end
      default: ;
    endcase

    case (mux_ctrl_right)
      Forward_ex_mem: begin
        right_operand = forward_ex_mem;
      end
      Forward_mem_wb: begin
        right_operand = forward_mem_wb;
      end
      default: ;
    endcase

    IF_Flush = 0;
    if (control.encoding == B_TYPE) begin
      case (control.BranchType)
        BRANCH_BEQ: begin
          if (left_operand == right_operand) begin
            PCSrc = 1'b1;
            IF_Flush = 1'b1;
          end
        end
        BRANCH_BNE: begin
          if (right_operand ^ left_operand != 0) begin
            PCSrc = 1'b1;
            IF_Flush = 1'b1;
          end
        end
        BRANCH_BLT: begin
          if (left_operand[31] == 1 && right_operand[31] == 1) begin
            if(((~left_operand) + 1) > ((~right_operand) + 1)) begin
              PCSrc = 1'b1;
              IF_Flush = 1'b1;
            end else begin
              PCSrc = 1'b0;
              IF_Flush = 1'b0;
            end
          end else if (left_operand[31] == 1 && right_operand[31] == 0) begin
            PCSrc = 1'b1;
            IF_Flush = 1'b1;
          end else if (left_operand[31] == 0 && right_operand[31] == 1) begin
            PCSrc = 1'b0;
            IF_Flush = 1'b0;
          end else begin
            if (left_operand < right_operand) begin
              PCSrc = 1'b1;
              IF_Flush = 1'b1;
            end else begin
              PCSrc = 1'b0;
              IF_Flush = 1'b0;
            end
          end
        end
        BRANCH_BGE: begin
          if (left_operand[31] == 1 && right_operand[31] == 1) begin
            if(((~left_operand) + 1) < ((~right_operand) + 1)) begin
              PCSrc = 1'b1;
              IF_Flush = 1'b1;
            end else begin
              PCSrc = 1'b0;
              IF_Flush = 1'b0;
            end
          end else if (left_operand[31] == 1 && right_operand[31] == 0) begin
            PCSrc = 1'b0;
            IF_Flush = 1'b0;
          end else if (left_operand[31] == 0 && right_operand[31] == 1) begin
            PCSrc = 1'b1;
            IF_Flush = 1'b1;
          end else begin
            if (left_operand > right_operand) begin
              PCSrc = 1'b1;
              IF_Flush = 1'b1;
            end else begin
              PCSrc = 1'b0;
              IF_Flush = 1'b0;
            end
          end
        end
        BRANCH_BLTU: begin
          if (right_operand < left_operand) begin
            PCSrc = 1'b1;
            IF_Flush = 1'b1;
          end
        end
        BRANCH_BGEU: begin
          if (right_operand <= left_operand) begin
            PCSrc = 1'b1;
            IF_Flush = 1'b1;
          end
        end
        default: begin
          PCSrc = 1'b0;
          IF_Flush = 1'b0;
        end
      endcase
    end else begin
      PCSrc = 1'b0;
      IF_Flush = 1'b0;
    end
  end

endmodule
