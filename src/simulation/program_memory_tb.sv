`timescale 1ps / 1ps

module program_memory_tb;

  logic clk, write_enable, clear_mem;
  logic [31:0] pc, write_data, write_address;
  wire [31:0] read_instruction;

  program_memory uut (
      .clk(clk),
      .pc(pc),
      .write_enable(write_enable),
      .write_data(write_data),
      .write_address(write_address),
      .clear_mem(clear_mem),
      .read_instruction(read_instruction)
  );

  parameter period = 2;
  always #(period / 2) clk = ~clk;

  initial begin
    pc = 0;
    #(period);
    pc = 4;
    #period;
    pc = 8;
  end

  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, program_memory_tb);
    clk = 1;

    #(1000 * period);

    $finish();
  end

endmodule
