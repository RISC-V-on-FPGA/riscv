`include "common.sv"
import common::*;

module hazard_detection_unit (
    input id_ex_MemRead,
    input [4:0] id_ex_rd,
    input instruction_type instruction,
    output logic PCWrite,
    output logic FetchWrite,
    output logic MakeBubble
);

// if (ID/EX.MemRead and
// ((ID/EX.RegisterRd = IF/ID.RegisterRs1) or
// (ID/EX.RegisterRd = IF/ID.RegisterRs2)))
// stall the pipeline

  always_comb begin : Comb
    if (id_ex_MemRead && ((id_ex_rd == instruction.rs1) || (id_ex_rd == instruction.rs2) )) begin
        PCWrite = 0;
        FetchWrite = 0;
        MakeBubble = 1;
    end else begin
        PCWrite = 1;
        FetchWrite = 1;
        MakeBubble = 0;
    end
  end

endmodule
