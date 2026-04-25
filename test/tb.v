`default_nettype none
`timescale 1ns / 1ps

/*
  This testbench will simulate the tt_um_example counter module.
*/

module tb ();

  // Inputs are defined as regs (we drive them)
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  reg       ena;
  reg       clk;
  reg       rst_n;

  // Outputs are defined as wires (we observe them)
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

  // Clock generation: Toggle clock every 5ns (100MHz)
  always #5 clk = ~clk;

  initial begin
    // Setup waveform dumping (optional, for viewing in GTKWave)
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    // Initialize inputs
    clk = 0;
    rst_n = 0;      // Start in reset
    ui_in = 0;
    uio_in = 0;
    ena = 1;

    // Wait 20ns, then release reset
    #20 rst_n = 1;
    $display("Reset released at %t", $time);

    // Let the counter run for a few cycles
    #100;

    // Check if counter is working (simple debug print)
    $display("Current count: %d", uo_out);

    // Test reset again mid-count
    #50 rst_n = 0;
    #20 rst_n = 1;
    
    // Run for a bit longer to see it start over
    #200;

    $display("Simulation finished at %t", $time);
    $finish;
  end

endmodule
