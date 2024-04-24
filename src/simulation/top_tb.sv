`timescale 1ps / 1ps

module top_tb;

  logic clk, rst, flash;
  logic [7:0] uart_serial;

  top uut (
      .clk(clk),
      .rst(rst),
      .uart_serial(uart_serial),
      .flash(flash)
  );

  parameter period = 2;

  always #(period / 2) clk = ~clk;

  initial begin
    flash = 0;
    uart_serial = 0;
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
