import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer

@cocotb.test()
async def test_counter(dut):
    dut._log.info("Starting Counter Gate-Level Test")

    # 1. Start the clock
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # 2. Handle Power Pins (Required for Gate Level)
    # This prevents the gates from staying in 'x' state
    if hasattr(dut, "VPWR"):
        dut.VPWR.value = 1
        dut.VGND.value = 0

    # 3. Initialize Control Signals
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0  # Start in Reset

    # 4. Wait for the simulator to settle
    # GL takes longer than RTL to propagate signals through the netlist
    await ClockCycles(dut.clk, 10)

    # 5. Safety Sample: Wait until uo_out is not 'x'
    # This prevents the "LogicArray to int" crash
    for _ in range(5):
        if dut.uo_out.value.is_resolvable:
            break
        await ClockCycles(dut.clk, 1)
    
    # 6. Verify Reset State
    current_val = int(dut.uo_out.value)
    assert current_val == 0, f"Reset failed: expected 0, got {current_val}"
    
    # 7. Release Reset and Test counting
    dut.rst_n.value = 1
    dut._log.info("Reset released, beginning count check")

    for i in range(1, 11):
        await RisingEdge(dut.clk)
        # Small delay to allow gates to switch before sampling
        await Timer(1, units="ns") 
        
        current_val = int(dut.uo_out.value)
        dut._log.info(f"Cycle {i}: Expected {i}, got {current_val}")
        assert current_val == i, f"Count mismatch at cycle {i}"

    dut._log.info("All Gate-Level tests passed!")
