`include "common.sv"

module decode_stage (
    input rst,
    input clk,
    input instruction_type instruction, // From program_memory
    input 
);

control control (
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .control(control)
);
    
endmodule