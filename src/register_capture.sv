module register_capture (
    input clk,
    input rst,
    input [31:0] write_data,
    input [4:0] write_id,
    input write_enable,
    input [4:0] led_address,
    input led_upper,
    output logic [15:0] led_output
);

  //  logic [4:0] address;
  //  assign address = write_id;

  logic [31:0]
      reg_1,
      reg_2,
      reg_3,
      reg_4,
      reg_5,
      reg_6,
      reg_7;
      // reg_8,
      // reg_9,
      // reg_10;
      // reg_11,
      // reg_12,
      // reg_13,
      // reg_14,
      // reg_15,
      // reg_16,
      // reg_17,
      // reg_18,
      // reg_19,
      // reg_20,
      // reg_21,
      // reg_22,
      // reg_23,
      // reg_24,
      // reg_25,
      // reg_26,
      // reg_27,
      // reg_28,
      // reg_29,
      // reg_30,
      // reg_31;

  always_ff @(posedge clk) begin : Seq
    if (rst == 1) begin
      reg_1  <= 0;
      reg_2  <= 0;
      reg_3  <= 0;
      reg_4  <= 0;
      reg_5  <= 0;
      reg_6  <= 0;
      reg_7  <= 0;
      // reg_8  <= 0;
      // reg_9  <= 0;
      // reg_10 <= 0;
      // reg_11 <= 0;
      // reg_12 <= 0;
      // reg_13 <= 0;
      // reg_14 <= 0;
      // reg_15 <= 0;
      // reg_16 <= 0;
      // reg_17 <= 0;
      // reg_18 <= 0;
      // reg_19 <= 0;
      // reg_20 <= 0;
      // reg_21 <= 0;
      // reg_22 <= 0;
      // reg_23 <= 0;
      // reg_24 <= 0;
      // reg_25 <= 0;
      // reg_26 <= 0;
      // reg_27 <= 0;
      // reg_28 <= 0;
      // reg_29 <= 0;
      // reg_30 <= 0;
      // reg_31 <= 0;
    end else begin
      if (write_enable == 1) begin
        case (write_id)
          5'b00001: reg_1 <= write_data;
          5'b00010: reg_2 <= write_data;
          5'b00011: reg_3 <= write_data;
          5'b00100: reg_4 <= write_data;
          5'b00101: reg_5 <= write_data;
          5'b00110: reg_6 <= write_data;
          5'b00111: reg_7 <= write_data;
          // 5'b01000: reg_8 <= write_data;
          // 5'b01001: reg_9 <= write_data;
          // 5'b01010: reg_10 <= write_data;
          // 5'b01011: reg_11 <= write_data;
          // 5'b01100: reg_12 <= write_data;
          // 5'b01101: reg_13 <= write_data;
          // 5'b01110: reg_14 <= write_data;
          // 5'b01111: reg_15 <= write_data;
          // 5'b10000: reg_16 <= write_data;
          // 5'b10001: reg_17 <= write_data;
          // 5'b10010: reg_18 <= write_data;
          // 5'b10011: reg_19 <= write_data;
          // 5'b10100: reg_20 <= write_data;
          // 5'b10101: reg_21 <= write_data;
          // 5'b10110: reg_22 <= write_data;
          // 5'b10111: reg_23 <= write_data;
          // 5'b11000: reg_24 <= write_data;
          // 5'b11001: reg_25 <= write_data;
          // 5'b11010: reg_26 <= write_data;
          // 5'b11011: reg_27 <= write_data;
          // 5'b11100: reg_28 <= write_data;
          // 5'b11101: reg_29 <= write_data;
          // 5'b11110: reg_30 <= write_data;
          // 5'b11111: reg_31 <= write_data;
          default:  ;
        endcase
      end
    end
  end

  always_comb begin : Comb
    case (led_address)
      6'b000001: led_output = (led_upper) ? reg_1[31:16] : reg_1[15:0];
      6'b000010: led_output = (led_upper) ? reg_2[31:16] : reg_2[15:0];
      6'b000011: led_output = (led_upper) ? reg_3[31:16] : reg_3[15:0];
      6'b000100: led_output = (led_upper) ? reg_4[31:16] : reg_4[15:0];
      6'b000101: led_output = (led_upper) ? reg_5[31:16] : reg_5[15:0];
      6'b000110: led_output = (led_upper) ? reg_6[31:16] : reg_6[15:0];
      6'b000111: led_output = (led_upper) ? reg_7[31:16] : reg_7[15:0];
      // 6'b001000: led_output = (led_upper) ? reg_8[31:16] : reg_8[15:0];
      // 6'b001001: led_output = (led_upper) ? reg_9[31:16] : reg_9[15:0];
      // 6'b001010: led_output = (led_upper) ? reg_10[31:16] : reg_10[15:0];
      // 6'b001011: led_output = (led_upper) ? reg_11[31:16] : reg_11[15:0];
      // 6'b001100: led_output = (led_upper) ? reg_12[31:16] : reg_12[15:0];
      // 6'b001101: led_output = (led_upper) ? reg_13[31:16] : reg_13[15:0];
      // 6'b001110: led_output = (led_upper) ? reg_14[31:16] : reg_14[15:0];
      // 6'b001111: led_output = (led_upper) ? reg_15[31:16] : reg_15[15:0];
      // 6'b010000: led_output = (led_upper) ? reg_16[31:16] : reg_16[15:0];
      // 6'b010001: led_output = (led_upper) ? reg_17[31:16] : reg_17[15:0];
      // 6'b010010: led_output = (led_upper) ? reg_18[31:16] : reg_18[15:0];
      // 6'b010011: led_output = (led_upper) ? reg_19[31:16] : reg_19[15:0];
      // 6'b010100: led_output = (led_upper) ? reg_20[31:16] : reg_20[15:0];
      // 6'b010101: led_output = (led_upper) ? reg_21[31:16] : reg_21[15:0];
      // 6'b010110: led_output = (led_upper) ? reg_22[31:16] : reg_22[15:0];
      // 6'b010111: led_output = (led_upper) ? reg_23[31:16] : reg_23[15:0];
      // 6'b011000: led_output = (led_upper) ? reg_24[31:16] : reg_24[15:0];
      // 6'b011001: led_output = (led_upper) ? reg_25[31:16] : reg_25[15:0];
      // 6'b011010: led_output = (led_upper) ? reg_26[31:16] : reg_26[15:0];
      // 6'b011011: led_output = (led_upper) ? reg_27[31:16] : reg_27[15:0];
      // 6'b011100: led_output = (led_upper) ? reg_28[31:16] : reg_28[15:0];
      // 6'b011101: led_output = (led_upper) ? reg_29[31:16] : reg_29[15:0];
      // 6'b011110: led_output = (led_upper) ? reg_30[31:16] : reg_30[15:0];
      // 6'b011111: led_output = (led_upper) ? reg_31[31:16] : reg_31[15:0];
      default:   led_output = 0;
    endcase
  end

endmodule
