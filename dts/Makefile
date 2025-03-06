#
# Copyright (c) 2022 by Christopher R. Bowman. All rights reserved.
# contact: <my initials>@ChrisBowman.com
#

DTC=/usr/bin/dtc

artyz7_gpio_overlay.dtb: artyz7_gpio_overlay.dts
	${DTC} -I dts -O dtb -o artyz7_gpio_overlay.dtb artyz7_gpio_overlay.dts 

# note make sure your .dts file uses /include/ not #include
zynq-artyz7.dtb: zynq-7000.dtsi zynq-artyz7.dts
	${DTC} -@ -i . -I dts -O dtb -o zynq-artyz7.dtb zynq-artyz7.dts

clean:
	rm -rf *.dtb
