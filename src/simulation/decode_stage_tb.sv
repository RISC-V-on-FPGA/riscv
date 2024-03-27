`timescale 1ps / 1ps
import common::*;

module decode_stage_tb;

  logic rst, clk, RegWrite;
  logic [31:0] pc, write_data;
  logic [4:0] write_id;
  wire [31:0] data1;
  wire [31:0] data2;
  wire [31:0] rs1;
  wire [31:0] rs2;
  wire [31:0] pc_branch;
  wire [31:0] imm;
  wire [5:0] rd;
  control_type control;
  instruction_type instruction;

  decode_stage uut (
    // Inputs
      .rst(rst),
      .clk(clk),
      .instruction(instruction),
      .pc(pc),
      .RegWrite(RegWrite),
      .write_data(write_data),
      .write_id(write_id),

    // Outputs
      .data1(data1),
      .data2(data2),
      .imm(imm),
      .rd(rd),
      .rs1(rs1),
      .rs2(rs2),
      .control(control),
      .pc_branch(pc_branch)
  );

  parameter period = 2;

  always #(period / 2) clk = ~clk;

  initial begin
    // Test reset
    rst = 0;
    RegWrite = 0;
    pc = 0;
    write_id = 0;
    #(period);
    rst = 1;
    #(period);
    rst = 0;

    /*
      TEST FOR ADDI
      Instruction: Addi, r2, 3.
    */
    #(period);
    // Set the instruction to match ADDI
    instruction.funct7 = 7'b0000000;
    instruction.rs2 = 5'b00011; // Value 4
    instruction.rs1 = 5'b00010; // Add with register 2
    instruction.funct3 = FUNCT3_ADDI;
    instruction.rd = 5'b00011; // Save to register 3
    instruction.opcode = OPCODE_I_TYPE;

    pc = 0;
    write_data = 0;
    write_id = 0;

  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, decode_stage_tb);
    clk = 1;

    #(100 * period);

    $finish();
  end

endmodule
