module data_memory (
    input clk,
    input rst,
    input [31:0] byte_address,  //From alu result
    input [31:0] write_data,  //From alu bypass
    input MemWrite,
    input MemRead,
    output logic [31:0] output_data
);

  logic [31:0] ram[256];
  logic [7:0] word_address;

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      for (int i = 0; i < 256; i++) begin
        ram[i] <= 0;
      end
    end else begin
      if (MemWrite) begin
        ram[word_address] <= write_data;
      end
    end
  end

  assign word_address = byte_address[9:2];

  always_comb begin : Comb
    output_data = ram[word_address];
  end

endmodule
