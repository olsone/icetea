chip.bin: $(VERILOG_FILES) ${PCF_FILE}
	yosys -q -p "synth_ice40 -blif chip.blif" $(VERILOG_FILES)
	arachne-pnr -d 8k -P tq144:4k -p ${PCF_FILE} chip.blif -o chip.txt
	icepack chip.txt chip.bin

# the stty doesn't seem to prepare the device.
# try stty on the command line too if you get "rbits failed"

.PHONY: upload
upload: chip.bin
	stty -f ${DEVICE} raw
	cat chip.bin > ${DEVICE} 

.PHONY: clean
clean:
	$(RM) -f chip.blif chip.txt chip.bin

tty: 
	stty -f ${DEVICE} raw
	cat < ${DEVICE} 
