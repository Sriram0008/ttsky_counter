import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge

@cocotb.test()
async def test_counter(dut):
    dut._log.info("Starting Counter Test")

    # 100MHz clock (10ns period)
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # Initialize / Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    
    assert int(dut.uo_out.value) == 0, "Reset failed"
    
    dut.rst_n.value = 1
    dut._log.info("Reset released")

    # Test increments
    for i in range(1, 11):
        await ClockCycles(dut.clk, 1)
        # We wait for the FallingEdge to ensure the RisingEdge logic 
        # has finished propagating through the simulator.
        await FallingEdge(dut.clk) 
        
        current_val = int(dut.uo_out.value)
        dut._log.info(f"Cycle {i}: Expected {i}, Got {current_val}")
        assert current_val == i
        
    dut._log.info("Counter sequence verified successfully!")
