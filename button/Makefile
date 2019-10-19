LUAS = $(shell ls -1 *.lua)
CHANGED_LUAS = $(LUAS:%.lua=.changed/%.lua)

dev: upload terminal

upload: $(CHANGED_LUAS)

.changed/%.lua: %.lua
	nodemcu-tool upload $<
	touch $@

clean:
	rm -fv .changed/*
	nodemcu-tool mkfs

terminal:
	rlwrap -a 'password:' -t dumb nodemcu-tool terminal

wifi:
	nodemcu-tool upload wifi.kittens.lua
	nodemcu-tool run wifi.kittens.lua

flash:
	esptool.py --port /dev/cu.usbserial-1410 write_flash 0x00 ../../thirdparty/esp8266/nodemcu-1.5.4.1-final-18-modules-2019-10-19-18-12-12-float.bin

# nodemcu-1.5.4.1-final-13-modules-2019-10-07-23-17-09-integer.bin
