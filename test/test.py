# SPDX-FileCopyrightText: © 2024 Your Name
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_counter(dut):
    dut._log.info("Starting Counter Test")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # --- Reset Phase ---
    dut._log.info("Apply Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    
    # Wait 10 cycles to ensure reset is captured
    await ClockCycles(dut.clk, 10)
    
    # Check that output is 0 after reset
    assert dut.uo_out.value == 0, f"Expected 0 after reset, got {dut.uo_out.value}"
    
    dut.rst_n.value = 1
    dut._log.info("Reset Released")

    # --- Testing Increment Logic ---
    dut._log.info("Verifying increments")
    
    # Let's check the first 10 increments
    for i in range(1, 11):
        await ClockCycles(dut.clk, 1)
        current_count = int(dut.uo_out.value)
        dut._log.info(f"Cycle {i}: Count is {current_count}")
        assert current_count == i, f"Counter error: Expected {i}, got {current_count}"

    # --- Testing Overflow/Wrap-around ---
    dut._log.info("Fast-forwarding to test wrap-around")
    
    # We are currently at 10. To get to 255, we need 245 more cycles.
    await ClockCycles(dut.clk, 245)
    assert dut.uo_out.value == 255
    
    # One more cycle should wrap it back to 0
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0
    dut._log.info("Counter successfully wrapped around to 0")

    dut._log.info("All tests passed!")
