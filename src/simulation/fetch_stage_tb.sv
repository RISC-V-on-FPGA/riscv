`timescale 1ps / 1ps

module fetch_stage_tb;

  logic clk, rst;
  logic PCSrc, PCWrite;
  logic [31:0] pc_branch;
  wire  [31:0] pc;

  fetch_stage uut (
      .clk(clk),
      .rst(rst),
      .pc_branch(pc_branch),
      .PCSrc(PCSrc),
      .PCWrite(PCWrite),
      .pc(pc)
  );

  parameter period = 1;

  always #(period / 2) clk = ~clk;

  initial begin
    rst = 0;
    pc_branch = 20;
    PCSrc = 0;
    PCWrite = 1;
    #(4*period);

  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, top_tb);
    clk = 0;

    $finish();
  end

endmodule
