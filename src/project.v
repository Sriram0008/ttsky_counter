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
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Internal register to hold the count value
  reg [7:0] count_reg;

  // Assign the register value to the dedicated output pins
  assign uo_out = count_reg;

  // Set unused bidirectional IOs to 0 and set them as inputs (oe=0)
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // Counter Logic
always @(posedge clk) begin
    if (!rst_n) begin
      count_reg <= 8'b0;
    end else begin
      count_reg <= count_reg + 1'b1;
    end
  end

  // List all unused inputs to prevent linter warnings
  // ui_in, uio_in, and ena are not used in this specific counter logic
  wire _unused = &{ui_in, uio_in, ena, 1'b0};

endmodule
