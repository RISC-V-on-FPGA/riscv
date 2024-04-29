module uart_interface #(
    // CLKS_PER_BIT = (Frequency of clk)/(Frequency of UART)
    parameter CLKS_PER_BIT = 434  // For 83.333333 MHz and 115200 Baud rate.
) (
    input              clk,
    input              input_serial,
    output logic       byte_received,
    output logic [7:0] output_byte 
);

  typedef enum logic [2:0] {
    IDLE,
    RX_START_BIT,
    RX_DATA_BITS,
    RX_STOP_BIT,
    CLEANUP
  } state_type;

  logic             rx_data_temp;
  logic             rx_data;

  logic      [31:0] clock_count;
  logic      [ 2:0] bit_index;  //8 bits total
  logic      [ 7:0] rx_byte;
  logic             rx_dv;
  state_type        state;

  always_ff @(posedge clk) begin
    rx_data_temp <= input_serial;
    rx_data <= rx_data_temp;
  end

  // Purpose: Control RX state machine
  always_ff @(posedge clk) begin

    case (state)
      IDLE: begin
        rx_dv       <= 1'b0;
        clock_count <= 0;
        bit_index   <= 0;

        if (rx_data == 1'b0)  // Start bit detected
          state <= RX_START_BIT;
        else state <= IDLE;
      end

      // Check middle of start bit to make sure it's still low
      RX_START_BIT: begin
        if (clock_count == (CLKS_PER_BIT - 1) / 2) begin
          if (rx_data == 1'b0) begin
            clock_count <= 0;  // reset counter, found the middle
            state       <= RX_DATA_BITS;
          end else state <= IDLE;
        end else begin
          clock_count <= clock_count + 1;
          state       <= RX_START_BIT;
        end
      end  // case: RX_START_BIT


      // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
      RX_DATA_BITS: begin
        if (clock_count < CLKS_PER_BIT - 1) begin
          clock_count <= clock_count + 1;
          state       <= RX_DATA_BITS;
        end else begin
          clock_count        <= 0;
          rx_byte[bit_index] <= rx_data;

          // Check if we have received all bits
          if (bit_index < 7) begin
            bit_index <= bit_index + 1;
            state <= RX_DATA_BITS;
          end else begin
            bit_index <= 0;
            state <= RX_STOP_BIT;
          end
        end
      end  // case: RX_DATA_BITS


      // Receive Stop bit.  Stop bit = 1
      RX_STOP_BIT: begin
        // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
        if (clock_count < CLKS_PER_BIT - 1) begin
          clock_count <= clock_count + 1;
          state       <= RX_STOP_BIT;
        end else begin
          rx_dv       <= 1'b1;
          clock_count <= 0;
          state       <= CLEANUP;
        end
      end  // case: RX_STOP_BIT


      // Stay here 1 clock
      CLEANUP: begin
        state <= IDLE;
        rx_dv <= 1'b0;
      end


      default: state <= IDLE;

    endcase
  end

  always_comb begin
    output_byte   = rx_byte;
    byte_received = rx_dv;
  end


endmodule
