SIM ?= icarus
TOPLEVEL_LANG ?= verilog # verilog for Verilog or SV files
VERILOG_SOURCES += $(PWD)/../../rtl/counter.sv 

counter:
	$(MAKE) sim MODULE=dut_test TOPLEVEL=counter
include $(shell cocotb-config --makefiles)/Makefile.sim 
# above include is always added at the end of a makefile
