import common::*;

module fetch #(
    // Parameters here
) (
    input clk,
    input rst,
    input pc_branch,
    input PCSrc,
    input PCWrite,
    output logic [31:0] pc
);

  logic [31:0] pc, pc_next;

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      pc <= 0;
    end else begin
      if (PCWrite == 1) begin
        pc <= pc_next + 4;
      end
    end
  end

  always_comb begin : Comb
    if (PCSrc == 1) begin
      pc_next = pc_branch;
    end
  end

endmodule
