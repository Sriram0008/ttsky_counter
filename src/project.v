/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Internal 8-bit register for the counter
  reg [7:0] count_reg;

  // Assign the internal register to the output pins
  assign uo_out  = count_reg;

  // Set all bidirectional pins as inputs (oe=0) and drive 0 on the output path
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // Synchronous Counter Logic
  always @(posedge clk) begin
    if (!rst_n) begin
      // Synchronous reset: set count to zero
      count_reg <= 8'h00;
    end else begin
      // Increment count on every clock edge
      count_reg <= count_reg + 1'b1;
    end
  end

  // Tie off unused input signals to prevent synthesis warnings
  wire _unused = &{ui_in, uio_in, ena, 1'b0};

endmodule
