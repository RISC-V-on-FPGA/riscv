`timescale 1ps / 1ps

module top_tb;

  logic clk, rst;

  top uut (
      .clk(clk),
      .rst(rst)
  );

  parameter period = 2;

  always #(period / 2) clk = ~clk;

  initial begin
    rst = 1;
    #(period);
    rst = 0;
  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, top_tb);
    clk = 1;

    #(100 * period);

    $finish();
  end

endmodule
