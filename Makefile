
VERILOG_FILES = \
	chip.v \
	blink.v \
	pll_ntsc.v \
	shift_ctrl.v \
	shift_ser_in.v \
	sn76489.v \
	memory_interface.v 

# Mac OS X
DEVICE = /dev/cu.usbmodem1411

PCF_FILE = icetea.pcf

include blackice.mk
