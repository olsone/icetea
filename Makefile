
VERILOG_FILES = \
	chip.v \
	blink.v \
	pll_32768.v \
	shift_ctrl.v \
	shift_ser_in.v \
	sn76489.v \
	i2s.v \
	memory_interface.v  \
	cru_interface.v

ROM_FILES = \
	waves/wave_sine.mem \
	waves/wave_square.mem \
	waves/wave_saw.mem \
	waves/wave_violin.mem \
	waves/wave_cello.mem \
	waves/samples.mem

# Mac OS X
# Use /dev/cu.usbmodem not /dev/tty.usbmodem
# MacBookPro Left side USB port
DEVICE = /dev/cu.usbmodem1411
# MacBookPro Right side USB port
#DEVICE = /dev/cu.usbmodem1421

PCF_FILE = icetea.pcf

include blackice.mk
