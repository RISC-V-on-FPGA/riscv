import common::*;

module fetch_stage #(
    // Parameters here
) (
    input clk,
    input rst,
    input pc_branch,
    input PCSrc,
    input PCWrite,
    input [31:0] uart_data, // TODO
    output logic [31:0] pc
);

  logic [31:0] pc, pc_next;

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      pc <= 0;
      pc_next <= 0;
    end else begin
      if (PCWrite == 1) begin
        pc <= pc_next;
      end
    end
  end

  always_comb begin : Comb
    if (PCSrc == 1) begin
      pc_next = pc_branch;
    end else begin
      pc_next = pc + 4;
    end
  end

endmodule
