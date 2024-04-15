module top (
    input clk,
    input rst
);

  //IF_ID Registers
  logic            [31:0] IF_ID_PC;
  instruction_type        IF_ID_INSTRUCTION;

  //ID_EX Registers
  control_type            ID_EX_CONTROL;
  logic            [31:0] ID_EX_DATA1;
  logic            [31:0] ID_EX_DATA2;
  logic            [31:0] ID_EX_IMM;
  logic            [ 4:0] ID_EX_RS1;
  logic            [ 4:0] ID_EX_RS2;
  logic            [ 4:0] ID_EX_RD;

  //EX_MEM Registers
  control_type            EX_MEM_CONTROL;
  logic            [ 4:0] EX_MEM_RD;
  logic            [31:0] EX_MEM_MEMORY_DATA;
  logic            [31:0] EX_MEM_ALU_DATA;
  logic                   EX_MEM_ZERO_FLAG;

  //MEM_WB Registers
  control_type            MEM_WB_CONTROL;
  logic            [31:0] MEM_WB_MEM_OUTPUT;
  logic            [31:0] MEM_WB_MEM_BYPASS;
  logic            [ 4:0] MEM_WB_RD;

  // Signals that does not go through the pipeline registers
  wire             [31:0] pc_branch;
  logic            [31:0] wb_data;
  logic            [31:0] fetch_pc;
  instruction_type        fetch_instruction;
  control_type            decode_control;
  logic            [31:0] decode_data1;
  logic            [31:0] decode_data2;
  logic            [31:0] decode_imm;
  logic            [ 4:0] decode_rs1;
  logic            [ 4:0] decode_rs2;
  logic            [ 4:0] decode_rd;
  control_type            execute_control_out;
  logic            [ 4:0] execute_rd_out;
  logic            [31:0] execute_memory_data;
  logic            [31:0] execute_alu_data;
  logic                   execute_zero_flag;
  control_type            memory_control_out;
  logic            [31:0] memory_memory_output;
  logic            [31:0] memory_bypass_output;
  logic            [ 4:0] memory_rd;


  always_comb begin : Comb
    // TODO: Make this depend on MemToReg control signal
    wb_data = MEM_WB_MEM_BYPASS;
  end

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      IF_ID_PC           <= 0;
      IF_ID_INSTRUCTION  <= 0;

      ID_EX_CONTROL      <= 0;
      ID_EX_DATA1        <= 0;
      ID_EX_DATA2        <= 0;
      ID_EX_IMM          <= 0;
      ID_EX_RS1          <= 0;
      ID_EX_RS2          <= 0;
      ID_EX_RD           <= 0;

      EX_MEM_CONTROL     <= 0;
      EX_MEM_RD          <= 0;
      EX_MEM_MEMORY_DATA <= 0;
      EX_MEM_ALU_DATA    <= 0;
      EX_MEM_ZERO_FLAG   <= 0;

      MEM_WB_CONTROL     <= 0;
      MEM_WB_MEM_OUTPUT  <= 0;
      MEM_WB_MEM_BYPASS  <= 0;
      MEM_WB_RD          <= 0;
    end else begin
      IF_ID_PC           <= fetch_pc;
      IF_ID_INSTRUCTION  <= fetch_instruction;

      ID_EX_CONTROL      <= decode_control;
      ID_EX_DATA1        <= decode_data1;
      ID_EX_DATA2        <= decode_data2;
      ID_EX_IMM          <= decode_imm;
      ID_EX_RS1          <= decode_rs1;
      ID_EX_RS2          <= decode_rs2;
      ID_EX_RD           <= decode_rd;

      EX_MEM_CONTROL     <= execute_control_out;
      EX_MEM_RD          <= execute_rd_out;
      EX_MEM_MEMORY_DATA <= execute_memory_data;
      EX_MEM_ALU_DATA    <= execute_alu_data;
      EX_MEM_ZERO_FLAG   <= execute_zero_flag;

      MEM_WB_CONTROL     <= memory_control_out;
      MEM_WB_MEM_OUTPUT  <= memory_memory_output;
      MEM_WB_MEM_BYPASS  <= memory_bypass_output;
      MEM_WB_RD          <= memory_rd;
    end
  end

  fetch_stage fetch_stage (
      .clk(clk),
      .rst(rst),
      .pc_branch(pc_branch),
      .PCSrc(1'b0),
      .PCWrite(1'b0),
      .uart_data(0),
      .pc(fetch_pc),
      .instruction(fetch_instruction)
  );

  decode_stage decode_stage (
      .rst(rst),
      .clk(clk),
      .instruction(IF_ID_INSTRUCTION),
      .pc(IF_ID_PC),
      .RegWrite(MEM_WB_CONTROL.RegWrite),
      .write_data(wb_data),
      .write_id(MEM_WB_RD),
      .data1(decode_data1),
      .data2(decode_data2),
      .imm(decode_imm),
      .rd(decode_rd),
      .rs1(decode_rs1),
      .rs2(decode_rs2),
      .control(decode_control),
      .pc_branch(pc_branch)
  );

  execute_stage execute_stage (
      .clk(rst),
      .control_in(ID_EX_CONTROL),
      .data1(ID_EX_DATA1),
      .data2(ID_EX_DATA2),
      .immediate_data(ID_EX_IMM),
      .control_out(execute_control_out),
      .ZeroFlag(execute_zero_flag),
      .alu_data(execute_alu_data),
      .forward_ex_mem(forward_ex_mem),
      .forward_mem_wb(forward_mem_wb),
      .mux_ctrl_left(mux_ctrl_left),
      .mux_ctrl_right(mux_ctrl_right),
      .rd_in(ID_EX_RD),
      .rd_out(execute_rd_out),
      .memory_data(execute_memory_data)
  );

  memory_stage memory_stage (
      .clk(clk),
      .rst(rst),
      .alu_result(EX_MEM_ALU_DATA),
      .MemWrite(1'b0),
      .MemRead(1'b0),
      .control_in(EX_MEM_CONTROL),
      .control_out(memory_control_out),
      .memory_bypass(memory_bypass_output),
      .memory_output(memory_memory_output),
      .rd_in(EX_MEM_RD),
      .rd_out(memory_rd)
  );

endmodule
