module register_file (
    input clk,
    input rst,
    input write_en,
    input [4:0] read1_id,
    input [4:0] read2_id,
    input [4:0] write_id,
    input [31:0] write_data,
    output logic [31:0] read1_data,
    output logic [31:0] read2_data
);

  logic [31:0] registers[0:31];

  always_ff @(posedge clk) begin : Seq

    if (write_en) begin
      registers[write_id] <= write_data;
    end
  end

  always_comb begin : Comb
    // x0 is always zero
    read1_data = read1_id == 0 ? 0 : registers[read1_id];
    // x0 is always zero
    read2_data = read2_id == 0 ? 0 : registers[read2_id];
  end

endmodule
