import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer

@cocotb.test()
async def test_counter(dut):
    dut._log.info("Starting Counter Gate-Level Test")

    # 1. Start the clock
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # 2. Handle Power Pins for Gate Level
    if hasattr(dut, "VPWR"):
        dut.VPWR.value = 1
        dut.VGND.value = 0

    # 3. Initialize signals
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0 # Keep in reset initially

    # 4. Wait for the simulation to stabilize
    # GL simulation takes longer to propagate through gates
    await ClockCycles(dut.clk, 10)

    # 5. Check reset safely
    # Instead of int(), we check the string or use is_resolvable
    val = dut.uo_out.value
    if not val.is_resolvable:
        dut._log.warning(f"Output is still unknown: {val}")
        # Wait a bit longer if it's 'x'
        await ClockCycles(dut.clk, 5)
    
    assert int(dut.uo_out.value) == 0, f"Reset failed, got {dut.uo_out.value}"
    
    # 6. Release reset and test increments
    dut.rst_n.value = 1
    dut._log.info("Reset released")

    for i in range(1, 11):
        await RisingEdge(dut.clk)
        # Small delay for gate-level propagation delay
        await Timer(1, units="ns") 
        
        current_val = int(dut.uo_out.value)
        dut._log.info(f"Cycle {i}: Expected {i}, got {current_val}")
        assert current_val == i
