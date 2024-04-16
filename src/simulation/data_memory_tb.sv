`timescale 1ps / 1ps

module data_memory_tb;

  logic clk, rst, MemWrite, MemRead;
  logic [31:0] byte_address, write_data, output_data;

  data_memory_tb uut (
      .clk(clk),
      .rst(rst),
      .byte_address(byte_address),  //From alu result
      .write_data(write_data),  //From alu bypass
      .MemWrite(MemWrite),
      .MemRead(MemRead),
      .output_data(output_data)
  );

  parameter period = 2;
  always #(period / 2) clk = ~clk;

  initial begin
    
  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, data_memory_tb);
    clk = 1;

    #(100 * period);

    $finish();
  end

endmodule
