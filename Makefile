
VERILOG_FILES = \
	chip.v \
	blink.v \
	pll_32768.v \
	shift_ctrl.v \
	shift_ser_in.v \
	sn76489.v \
	i2s.v \
	memory_interface.v 

# Mac OS X
DEVICE = /dev/cu.usbmodem1411

PCF_FILE = icetea.pcf

include blackice.mk
