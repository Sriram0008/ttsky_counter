import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge

@cocotb.test()
async def test_counter(dut):
    # 1. Start Clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # 2. Reset Sequence (Crucial for GL tests!)
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.rst_n.value = 0  # Assert reset
    await Timer(50, units="ns")
    dut.rst_n.value = 1  # De-assert reset
    await RisingEdge(dut.clk)
    
    # 3. Now run your test
    dut.ui_in.value = 1  # Count Up
    await RisingEdge(dut.clk)
    # Check if uo_out is now a real number (0 or 1) instead of X
    dut._log.info(f"Value after 1 cycle: {dut.uo_out.value}")
