`timescale 1ps / 1ps
// `include "common.sv"
import common::*;

module fetch_stage_tb;

  logic clk, rst;
  logic PCSrc, PCWrite;
  logic [31:0] pc_branch;
  logic flash;
  logic uart_received;
  logic [7:0] uart_data;
  wire  [31:0] pc;
  wire instruction_type instruction;

  fetch_stage uut (
    .clk(clk),
    .rst(rst),
    .pc_branch(pc_branch),
    .PCSrc(PCSrc),
    .PCWrite(PCWrite),
    .uart_data(uart_data),
    .uart_received(uart_received),
    .flash(flash),
    .pc(pc),
    .instruction(instruction)
  );

  parameter period = 2;

  always #(period / 2) clk = ~clk;

  initial begin
    
    // Reset
    rst = 0;
    pc_branch = 20;
    PCSrc = 0;
    PCWrite = 1;
    flash = 0;
    uart_data = 0;
    uart_received = 0;
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
    #(10*period);
    // Start PC write
    PCWrite = 1;

    // Simulate reflashing
    #(period);
    rst = 1;
    flash = 1;
    #period;
    rst = 0;
    #(10*period);
    // A compressed instructoin (ADD)
    uart_data = 8'b10001010;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    uart_data = 8'b10010000;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    // A 32 bit instruction
    uart_data = 8'b10010011;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    uart_data = 8'b00000000;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    uart_data = 8'b10100000;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    uart_data = 8'b00000000;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    // A compressed instrcution (ADD)
    uart_data = 8'b10001010;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    uart_data = 8'b10010000;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    // A 32 bit instruction
    uart_data = 8'b10010011;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    uart_data = 8'b00000000;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    uart_data = 8'b10100000;
    uart_received = 1;
    #(period);
    uart_received = 0;
    #(10*period);
    uart_data = 8'b00000000;
    uart_received = 1;
    #(period);
    uart_received = 0;
    // Stop flashing
    #(10*period);
    flash = 0;
    // Go back to normal mode

  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, fetch_stage_tb);
    clk = 1;

    #(15000*period);

    $finish();
  end

endmodule
