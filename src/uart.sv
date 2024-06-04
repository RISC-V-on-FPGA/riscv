module uart (
    input logic clk,
    input logic rst,
    input logic io_rx,
    output logic io_data_valid,
    output logic [7:0] io_data_packet
);

  parameter BAUD = 4800;
  localparam FREQUENCY_IN_HZ = 80_000_000;
  localparam BAUD_COUNT_CHECK = FREQUENCY_IN_HZ / BAUD;
  localparam NUM_DATA_BITS = 8;

  typedef enum {
    standby,
    wait_half_start_bit,
    wait_full_data_bit,
    capture_data_bit,
    wait_full_last_bit
  } uart_state_type;
  uart_state_type uart_state, uart_state_next;

  integer uart_counter_reg, uart_counter_next;
  integer data_bit_count_reg, data_bit_count_next;

  logic [7:0] data_packet_reg, data_packet_next;

  logic data_valid_next;

  always_ff @(posedge clk) begin
    if (rst == 1) begin
      uart_state <= standby;
      uart_counter_reg <= 0;
      data_bit_count_reg <= 0;
      io_data_valid <= 0;
      data_packet_reg <= 0;
    end else begin
      uart_state <= uart_state_next;
      uart_counter_reg <= uart_counter_next;
      data_bit_count_reg <= data_bit_count_next;
      io_data_valid <= data_valid_next;
      data_packet_reg <= data_packet_next;
    end
  end


  always_comb begin
    uart_state_next <= uart_state;
    uart_counter_next <= uart_counter_reg;
    data_packet_next <= data_packet_reg;
    data_bit_count_next <= data_bit_count_reg;
    data_valid_next <= 0;

    case (uart_state)
      standby:
      if (io_rx == 0) begin
        uart_state_next <= wait_half_start_bit;
      end

      wait_half_start_bit: begin
        uart_counter_next <= uart_counter_reg + 1;
        if (uart_counter_reg == BAUD_COUNT_CHECK / 2) begin
          uart_counter_next <= 0;
          uart_state_next   <= wait_full_data_bit;
        end
      end

      wait_full_data_bit: begin
        uart_counter_next <= uart_counter_reg + 1;
        if (uart_counter_reg == BAUD_COUNT_CHECK) begin
          uart_counter_next <= 0;
          uart_state_next   <= capture_data_bit;
        end
      end

      capture_data_bit: begin
        data_packet_next <= {io_rx, data_packet_reg[NUM_DATA_BITS-1:1]};
        data_bit_count_next <= data_bit_count_reg + 1;
        uart_state_next <= (data_bit_count_reg == NUM_DATA_BITS-1) ? wait_full_last_bit : wait_full_data_bit;
      end

      wait_full_last_bit: begin
        uart_counter_next <= uart_counter_reg + 1;
        if (uart_counter_reg == BAUD_COUNT_CHECK) begin
          uart_state_next <= standby;
          data_bit_count_next <= 0;
          uart_counter_next <= 0;
          data_valid_next <= 1;
        end
      end
    endcase
  end


  assign io_data_packet = data_packet_reg;

endmodule
