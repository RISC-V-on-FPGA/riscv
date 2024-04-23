`timescale 1ns / 1ps

module uart_interface_tb ();

  // Testbench uses a 100 MHz clock
  // Want to interface to 115200 baud UART
  // 100000000 / 115200 = 868 Clocks Per Bit.

  // 10ns
  parameter integer CLK_PERIOD = 10;
  parameter integer CLKS_PER_BIT = 868;
  parameter integer BIT_PERIOD = 8600;

  logic clk = 0;
  logic input_serial = 1;

  wire [7:0] output_byte;
  wire byte_received;


  // Takes in input byte and serializes it
  task static UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer ii;
    begin

      // Send Start Bit
      input_serial <= 1'b0;
      #(BIT_PERIOD);
      #1000;

      // Send Data Byte
      for (ii = 0; ii < 8; ii = ii + 1) begin
        input_serial <= i_Data[ii];
        #(BIT_PERIOD);
      end

      // Send Stop Bit
      input_serial <= 1'b1;
      #(BIT_PERIOD);
    end
  endtask  // UART_WRITE_BYTE


  uart_interface uut (
      .clk(clk),
      .input_serial(input_serial),
      .output_byte(output_byte),
      .byte_received(byte_received)
  );


  always #(CLK_PERIOD / 2) clk <= !clk;


  // Main Testing:
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, uart_interface_tb);
    $display("Done!");


    // Send a command to the UART (exercise Rx)
    @(posedge clk);
    UART_WRITE_BYTE(8'h3F);
    @(posedge clk);

    // Check that the correct command was received
    if (output_byte == 8'h3F) $display("Test Passed - Correct Byte Received");
    else $display("Test Failed - Incorrect Byte Received");

    #(CLK_PERIOD * 10);

    // Send a command to the UART (exercise Rx)
    @(posedge clk);
    UART_WRITE_BYTE(8'hFF);
    @(posedge clk);

    // Check that the correct command was received
    if (output_byte == 8'hFF) $display("Test Passed - Correct Byte Received");
    else $display("Test Failed - Incorrect Byte Received");


    $finish();

  end

endmodule