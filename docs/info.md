## How it works
This project is a synchronous 8-bit binary counter. It uses a single 8-bit register that increments on every rising edge of the clock (`clk`). The counter value is output to the dedicated output pins (`uo_out`). When the active-low reset signal (`rst_n`) is pulled low, the counter resets to 0.

## How to test
After power-on, ensure `ena` is high and `rst_n` is pulled low to initialize the counter. Once `rst_n` is released (set to high), provide a clock signal to the `clk` pin. You can observe the binary count increasing on the output pins `uo[0]` through `uo[7]`.
