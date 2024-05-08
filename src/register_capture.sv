module register_capture (
    input clk,
    input rst,
    input [31:0] write_data,
    input [4:0] write_id,
    input write_enable,
    input [2:0] led_address,
    output logic [15:0] led_output
);

  logic [2:0] address;
  assign address = write_id[2:0];

  // Capture up to x7
  logic [31:0] reg_1, reg_2, reg_3, reg_4, reg_5, reg_6, reg_7;

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      reg_1 <= 0;
      reg_2 <= 0;
      reg_3 <= 0;
      reg_4 <= 0;
      reg_5 <= 0;
      reg_6 <= 0;
      reg_7 <= 0;
    end else begin
      if (write_enable == 1) begin
        case (write_id)
          3'b001:  reg_1 <= write_data;
          3'b010:  reg_2 <= write_data;
          3'b011:  reg_3 <= write_data;
          3'b100:  reg_4 <= write_data;
          3'b101:  reg_5 <= write_data;
          3'b110:  reg_6 <= write_data;
          3'b111:  reg_7 <= write_data;
          default: ;
        endcase
      end
    end
  end

  always_comb begin : Comb
    case (led_address)
      3'b001:  led_output = reg_1[15:0];
      3'b010:  led_output = reg_2[15:0];
      3'b011:  led_output = reg_3[15:0];
      3'b100:  led_output = reg_4[15:0];
      3'b101:  led_output = reg_5[15:0];
      3'b110:  led_output = reg_6[15:0];
      3'b111:  led_output = reg_7[15:0];
      default: led_output = 0;
    endcase
  end

endmodule
