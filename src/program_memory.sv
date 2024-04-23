module program_memory (
    input clk,
    input [31:0] pc,
    input write_enable,
    input [31:0] write_data,
    input [31:0] write_address,
    input clear_mem,
    output logic [31:0] read_instruction
);

  logic [31:0] ram[256];
  logic [7:0] word_address;
  logic [7:0] word_write_address;

  assign word_address = pc[9:2];
  assign word_write_address = write_address[9:2];

  initial begin
    $readmemb("instruction_mem.mem", ram);
  end

  always @(posedge clk) begin
    if (write_enable) begin
      ram[word_write_address] <= write_data;
    end
  end

  always_comb begin
    if (clear_mem) begin
      for (int i = 0; i < 256; i++) begin
        ram[i] = 0;
      end
    end
  end

  assign read_instruction = ram[word_address];

endmodule
