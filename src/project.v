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

  // Internal 8-bit register
  reg [7:0] count_reg;

  // Drive outputs
  assign uo_out  = count_reg;
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // Synchronous Counter Logic
  always @(posedge clk) begin
    if (!rst_n) begin
      count_reg <= 8'h00;
    end else begin
      count_reg <= count_reg + 1'b1;
    end
  end

  // Tie off unused signals to avoid warnings
  wire _unused = &{ui_in, uio_in, ena, 1'b0};

endmodule
