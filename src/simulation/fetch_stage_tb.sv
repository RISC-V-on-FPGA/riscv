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

  parameter period = 2;

  always #(period / 2) clk = ~clk;

  initial begin
    // Reset
    rst = 0;
    pc_branch = 20;
    PCSrc = 0;
    PCWrite = 1;
    #(4*period);
    rst = 1;
    #(period);
    rst = 0;
    assert(pc == 0) else $error("PC is not reset to 0 after first reset");
    #(10*period);
    rst = 1;
    #(period);
    rst = 0;
    assert(pc == 0) else $error("PC is not reset to 0 after any reset");
    // Branch
    #(2*period);
    PCSrc = 1;
    #(period / 2);
    assert(pc == 20) else $error("Branch is not done correctly");
    #(period / 2);
    #(period);
    PCSrc = 0;
    // Stop PC write
    #(10*period);
    PCWrite = 0;
    

  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, fetch_stage_tb);
    clk = 1;

    #(100*period);

    $finish();
  end

endmodule
