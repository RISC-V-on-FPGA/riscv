`include "common.sv"
import common::*;

module forwarding_unit (
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [4:0] ex_mem_rd,
    input [4:0] mem_wb_rd,
    input mem_wb_RegWrite,
    input ex_mem_RegWrite,
    output logic [1:0] mux_ctrl_left,
    output logic [1:0] mux_ctrl_right
);

  always_comb begin : Combinational
    // if (MEM/WB.RegWrite
    // and (MEM/WB.RegisterRd ≠ 0)
    // and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ≠ 0)
    //      and (EX/MEM.RegisterRd = ID/EX.RegisterRs1))
    // and (MEM/WB.RegisterRd = ID/EX.RegisterRs1)) ForwardA = 01
    if (mem_wb_RegWrite
        && (mem_wb_rd != 0)
        // Added line for writing to same registers multiple times
        && !(ex_mem_RegWrite && (ex_mem_rd != 0) && ex_mem_rd == rs1)
        && (mem_wb_rd == rs1)) begin
      mux_ctrl_left = Forward_mem_wb;
    end

    // if (MEM/WB.RegWrite
    // and (MEM/WB.RegisterRd ≠ 0)
    // and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ≠ 0)
    //      and (EX/MEM.RegisterRd = ID/EX.RegisterRs2))
    // and (MEM/WB.RegisterRd = ID/EX.RegisterRs2)) ForwardB = 01
    if (mem_wb_RegWrite
        && (mem_wb_rd != 0)
        // Added line for writing to same registers multiple times
        && !(ex_mem_RegWrite && (ex_mem_rd != 0) && ex_mem_rd == rs2)
        && (mem_wb_rd == rs2)) begin
      mux_ctrl_right = Forward_mem_wb;
    end

    // if (EX/MEM.RegWrite
    // and (EX/MEM.RegisterRd ≠ 0)
    // and (EX/MEM.RegisterRd = ID/EX.RegisterRs1)) ForwardA = 10
    if (ex_mem_RegWrite
        && (ex_mem_rd != 0)
        && (ex_mem_rd == rs1)) begin
            mux_ctrl_left = Forward_ex_mem;
        end

    // if (EX/MEM.RegWrite
    // and (EX/MEM.RegisterRd ≠ 0)
    // and (EX/MEM.RegisterRd = ID/EX.RegisterRs2)) ForwardB = 10
    if (ex_mem_RegWrite
        && (ex_mem_rd != 0)
        && (ex_mem_rd == rs2)) begin
            mux_ctrl_right = Forward_ex_mem;
        end

  end

endmodule
