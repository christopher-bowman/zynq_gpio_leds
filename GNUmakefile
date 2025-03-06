#
# Copyright (C) 2023 Christopher R. Bowman
# All rights reserved
#
# Simple make file to build the FPGA bit stream
# intended to be used with GNU make since vivado runs under Linux

VIVADO_VERSION?=2024.2
VIVADO_PATH?=/eda/xilinx/$(VIVADO_VERSION)
VIVADO_INSTALL?=$(VIVADO_PATH)/Vivado/$(VIVADO_VERSION)
OS:=$(shell uname)
ARCH:=$(shell uname -p)

# Experimental support for executing Vivado on FreeBSD
# while this works to call Vivado, Vivado doesn't always work
# the same on FreeBSD 
# don't really need to call a shell on Linux but it keeps things
# similar between the two platforms.  On FreeBSD we definitely do
# need to run the shell so that the scripts are executed in Linux
# emulation mode so that when a Vivado binary is finally called
# it's run under Linux emulation

ifeq ($(OS), Linux)
	SHELL=/bin/sh 
else
	SHELL=/compat/linux/bin/sh
endif

zynq_gpio_leds.bit: xdc source/verilog/zynq_gpio_leds_wrapper.v source/constraints/Arty-Z7-20-Master.xdc boards/vivado-boards/new/board_files/arty-z7-20/A.0 scripts/project.tcl
ifeq ($(OS), FreeBSD)
	@echo ""
	@echo "WARNING: running Vivado on FreeBSD is experimental"
	@echo "sometimes it runs and doesn't behave the same as under Linux"
	@echo "run gmake again with EXPERIMENTAL=1 if you want to try this under"
	@echo "FreeBSD but be aware even if Vivado runs it may not hehave properly"
	@echo "otherwise run this on a Linux host"
ifneq ($(EXPERIMENTAL), 1)
	exit 1
endif
endif
	mkdir -p implementation
	(cd implementation ; $(SHELL) -c "source $(VIVADO_INSTALL)/settings64.sh ; vivado -source ../scripts/project.tcl -mode batch -tclargs --generate_bit" )
	cp ./implementation/zynq_gpio_leds/zynq_gpio_leds.runs/impl_1/zynq_gpio_leds_wrapper.bit zynq_gpio_leds.bit

project: xdc source/verilog/zynq_gpio_leds_wrapper.v source/constraints/Arty-Z7-20-Master.xdc boards/vivado-boards/new/board_files/arty-z7-20/A.0 scripts/project.tcl 
ifeq ($(OS), FreeBSD)
	@echo ""
	@echo "WARNING: running Vivado on FreeBSD is experimental"
	@echo "sometimes it runs and doesn't behave the same as under Linux"
	@echo "run gmake again with EXPERIMENTAL=1 if you want to try this under"
	@echo "FreeBSD but be aware even if Vivado runs it may not hehave properly"
	@echo "otherwise run this on a Linux host"
ifneq ($(EXPERIMENTAL), 1)
	exit 1
endif
endif
	mkdir -p implementation
	( cd implementation ; $(SHELL) -c "source $(VIVADO_INSTALL)/settings64.sh ; vivado -source ../scripts/project.tcl -mode tcl" )

boards/vivado-boards/new/board_files/arty-z7-20/A.0:
	echo "fetching Digilent master board files git repo"
	mkdir -p boards
	(cd  boards && git clone https://github.com/Digilent/vivado-boards)

# retrieve the golden XDC from Digilents repo
source/constraints/Arty-Z7-20-Master.xdc: 
	( cd source/constraints ; wget https://raw.githubusercontent.com/Digilent/digilent-xdc/deb00e66689337700b3a18c0e3776dcf4a59655b/Arty-Z7-20-Master.xdc )

# uncomment the lines needed in this project I wish I didn't have to do all
# this but they haven't provided a copyright for the file so it's not clear
# if I can distribute it

xdc: source/constraints/Arty-Z7-20-Master.xdc
	( cd source/constraints ; \
	 mv Arty-Z7-20-Master.xdc Arty-Z7-20-Master.xdc.original ; \
	 sed -e 's/#\(.*\) clk \(.*\)/\1 clk \2/' Arty-Z7-20-Master.xdc.original | sed -e 's/#\(.*\)led\[\(.*\)/\1led\[\2/' > Arty-Z7-20-Master.xdc )

clean:
	rm -rf usage_statistics_webtalk.html usage_statistics_webtalk.xml vivado*.jou vivado*.log implementation .Xil *.bit

realclean: clean
	rm -rf boards source/constraints/Arty-Z7-20-Master.xdc source/constraints/Arty-Z7-20-Master.xdc.original

# source/constraints/Arty-Z7-20-Master.xdc source/constraints/Arty-Z7-20-Master.xdc.original
