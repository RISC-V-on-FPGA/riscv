`timescale 1ps / 1ps

module data_memory_tb;

  logic clk, rst, MemWrite, MemRead;
  logic [31:0] byte_address, write_data, output_data;

  data_memory uut (
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
    rst = 0;
    MemWrite = 0;
    MemRead = 0;
    byte_address = 0;
    write_data = 0;
    #period;
    rst = 1;
    #period;
    rst = 0;
    MemWrite = 1;
    for (int i = 0; i < 256; i++) begin
      byte_address = i*4;
      write_data = i + 1;
      #period;
    end
    MemWrite = 0;
    MemRead = 1;
    for (int i = 0; i < 256; i++) begin
      byte_address = i*4;
      #period;
      assert (output_data == i + 1) else $error("Wrong Value Read: %d", output_data);
    end
  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, data_memory_tb);
    clk = 1;

    #(1000 * period);

    $finish();
  end

endmodule
