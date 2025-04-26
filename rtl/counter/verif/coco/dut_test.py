import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

#@cocotb.test()
async def wait_cycles(dut, num_cycles):
    for _ in range(num_cycles):
        await RisingEdge(dut.clk)


@cocotb.test()
async def hello_word(dut):
    pass


async def reset_block(dut):

    #cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    hndl_rst_n = dut.rst_n
    hndl_rst_n.value = 1

    for _ in range(2):
        await RisingEdge(dut.clk)

    hndl_rst_n.value = 0
    
    for _ in range(2):
        await RisingEdge(dut.clk)
    hndl_rst_n.value = 1


@cocotb.test()
async def check_counter(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    cocotb.start_soon(reset_block(dut))    
    

    await RisingEdge(dut.rst_n)

    for _ in range(100):
        await RisingEdge(dut.clk)

    pass
