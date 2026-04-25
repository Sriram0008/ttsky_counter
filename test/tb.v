`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Initial inputs
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  reg       ena;
  reg       clk;
  reg       rst_n;

  // Outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Instantiate the Unit Under Test (UUT)
  tt_um_example uut (
    .ui_in   (ui_in),
    .uo_out  (uo_out),
    .uio_in  (uio_in),
    .uio_out (uio_out),
    .uio_oe  (uio_oe),
    .ena     (ena),
    .clk     (clk),
    .rst_n   (rst_n)
  );

  // We leave clk and rst_n for Cocotb to drive.
  // We just need to dump the waveforms.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

endmodule
