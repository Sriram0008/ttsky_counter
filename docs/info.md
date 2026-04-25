# 8-bit Binary Counter

## How it works
The design implements a standard 8-bit synchronous up-counter. On every rising edge of the clock, the internal 8-bit register increments by one. The count is then visible on the 8 dedicated output pins.

## How to test
1. Provide a clock signal to the `clk` pin.
2. Pulse the `rst_n` pin low to reset the counter to zero.
3. Observe the binary sequence on the output pins `uo[7:0]`.
