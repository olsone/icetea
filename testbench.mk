VERILOG_MODULES = shift_ser_in.v shift74ls165.v shift_ctrl.v clockgen.v mem_read_gen.v  mem_write_gen.v

SHIFT_TB_FILES = shift_tb.v $(VERILOG_MODULES)

shift_tb: $(SHIFT_TB_FILES)
	iverilog -o $@ $(SHIFT_TB_FILES)
	vvp shift_tb

# run with vvp shift_tb
CLOCKGEN_TB_FILES = clockgen_tb.v $(VERILOG_MODULES)
READ_GEN_TB_FILES = mem_read_gen_tb.v $(VERILOG_MODULES)

clockgen_tb: $(CLOCKGEN_TB_FILES)
	iverilog -o $@ $(CLOCKGEN_TB_FILES)
	vvp clockgen_tb

mem_read_gen_tb: $(READ_GEN_TB_FILES)
	iverilog -o $@ $(READ_GEN_TB_FILES)
	vvp mem_read_gen_tb


MEMORY_TB_FILES = memory_interface_tb.v memory_interface.v cru_interface.v $(VERILOG_MODULES)
memory_interface_tb: $(MEMORY_TB_FILES)
	iverilog -o $@ $(MEMORY_TB_FILES)
	vvp memory_interface_tb

# run with vvp memory_interface_tb

SHIFT_SER_OUT_FILES = shift_ser_out_tb.v shift_ser_out.v
shift_ser_out_tb: $(SHIFT_SER_OUT_FILES)
	iverilog -o $@ $(SHIFT_SER_OUT_FILES)
	vvp $@
