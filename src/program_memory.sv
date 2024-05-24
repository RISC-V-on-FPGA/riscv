module program_memory (
    input clk,
    input [31:0] pc,
    input write_enable,
    input [7:0] write_data,
    input [31:0] write_address,
    // input clear_mem,
    output logic [31:0] read_instruction,
    output logic flag_compressed
);

  logic [7:0] ram[1024];
  logic [31:0] instruction_temp;
  logic [9:0] mem_write_address, mem_pc;

  assign mem_write_address = write_address[9:0];
  assign mem_pc = pc[9:0];

  initial begin
    $readmemb("instruction_mem.mem", ram);
  end

  always_ff @(posedge clk) begin
    if (write_enable) begin
      ram[mem_write_address] <= write_data;
    end

    // if (clear_mem) begin
      // for (int i = 0; i < 1024; i++) begin
        // ram[i] <= 0;
      // end
    // end
  end

  always_comb begin : CombMem
    if (ram[mem_pc][1:0] != 2'b11) begin
      // Compressed instruction
      flag_compressed = 1;
      instruction_temp[7:0] = ram[mem_pc];
      instruction_temp[15:8] = ram[mem_pc+1];
      instruction_temp[31:16] = 0;

      read_instruction = instruction_temp;
    end else begin
      flag_compressed = 0;
      instruction_temp[7:0] = ram[mem_pc];
      instruction_temp[15:8] = ram[mem_pc+1];
      instruction_temp[23:16] = ram[mem_pc+2];
      instruction_temp[31:24] = ram[mem_pc+3];

      read_instruction = instruction_temp;
    end

  end

  // logic [31:0] ram[256];
  // logic [7:0] word_address;
  // logic [7:0] word_write_address;

  // assign word_address = pc[9:2];
  // assign word_write_address = write_address[9:2];

  // initial begin
  //   $readmemb("instruction_mem.mem", ram);
  // end

  // always @(posedge clk) begin
  //   if (write_enable) begin
  //     ram[word_write_address] <= write_data;
  //   end
  // end

  // always_comb begin
  //   if (clear_mem) begin
  //     for (int i = 0; i < 256; i++) begin
  //       ram[i] = 0;
  //     end
  //   end
  // end

  // assign read_instruction = ram[word_address];

endmodule
