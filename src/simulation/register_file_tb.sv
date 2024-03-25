`timescale 1ps / 1ps

module register_file_tb;

  logic clk, rst, write_en;
  logic [4:0] read1_id, read2_id, write_id;
  logic [31:0] write_data;
  wire [31:0] read1_data;
  wire [31:0] read2_data;

  register_file uut (
      .clk(clk),
      .rst(rst),
      .write_en(write_en),
      .read1_id(read1_id),
      .read2_id(read2_id),
      .write_id(write_id),
      .write_data(write_data),
      .read1_data(read1_data),
      .read2_data(read2_data)
  );

  parameter period = 2;
  always #(period / 2) clk = ~clk;

  // Should be able to write and read on the same clock cycle!
  initial begin
    // Test reset
    rst = 0;
    write_en = 0;
    read1_id = 0;
    read2_id = 0;
    write_id = 0;
    write_data = 0;
    #(4*period);
    rst = 1;
    #(period);
    rst = 0;
    // Test write and read functionality
    write_en = 1;
    write_data = 17;
    write_id = 1;
    read1_id = 1;
    #(period);
    write_en = 0;
    #(period);
    write_en = 1;
    write_data = 42;
    write_id = 2;
    read2_id = 2;
    #(period);
    write_en = 0;
    #(period);
    // Test two values in a row written
    write_en = 1;
    write_id = 3;
    write_data = 420;
    #(period);
    write_id = 4;
    write_data = 360;
    #(period);
    write_en = 0;
    read1_id = 3;
    read2_id = 4;
    // Test write to x0, should write but not be able to read.
    // Adress 0 always gives back 0
    #(4*period);
    write_en = 1;
    write_id = 0;
    write_data = 666;
    read1_id = 0;
    #(period);
    write_en = 0;
    read2_id = 0;

  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, register_file_tb);
    clk = 1;

    #(100 * period);

    $finish();
  end

endmodule
