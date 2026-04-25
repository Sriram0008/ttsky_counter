import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge

@cocotb.test()
async def test_counter(dut):
    dut._log.info("Starting Counter Test")

    # Start a 100MHz clock
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # Initialize inputs
    dut.ena.value = 1
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    
    # Assert reset state
    assert int(dut.uo_out.value) == 0, f"Reset failed: {dut.uo_out.value}"
    
    # Release reset
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    # Verify first 10 cycles
    for i in range(1, 11):
        await FallingEdge(dut.clk) # Wait for state to settle
        current_val = int(dut.uo_out.value)
        dut._log.info(f"Cycle {i}: Value is {current_val}")
        assert current_val == i, f"Expected {i}, got {current_val}"

    dut._log.info("Test Completed Successfully!")
