#FIRMWARE=../../thirdparty/esp8266/nodemcu-1.5.4.1-final-11-modules-2019-11-21-18-38-26-adc-cjson-file-gpio-http-net-node-tmr-uart-wifi-ws2812integer.bin
# FIRMWARE=../../thirdparty/esp8266/nodemcu-1.5.4.1-final-13-modules-2019-10-07-23-17-09-integer.bin
FIRMWARE=../../thirdparty/esp8266/nodemcu-1.5.4.1-final-18-modules-2019-10-30-10-15-36-adc-cjson-enduser_setup-file-gpio-http-i2c-mqtt-net-node-ow-rotary-spi-tmr-uart-wifi-ws2812-float.bin

FILES = $(shell ls -1 *.lua) color.lua
CHANGED_FILES = $(FILES:%=.changed/%)

dev: upload terminal

upload: $(CHANGED_FILES)

.changed/%.lua: %.lua
	nodemcu-tool upload -m $<
	mkdir -p .changed
	touch $@

.changed/%.json: %.json
	nodemcu-tool upload $<
	touch $@

clean:
	rm -fv .changed/*
	nodemcu-tool mkfs

terminal:
	rlwrap -a 'password:' -t dumb nodemcu-tool terminal

wifi:
	nodemcu-tool upload ../wifi/wifi.*.lua
	nodemcu-tool run wifi.kittens.lua

flash:
	esptool.py --port $$(jq -r .port .nodemcutool) write_flash 0x00 $(FIRMWARE)

# nodemcu-1.5.4.1-final-13-modules-2019-10-07-23-17-09-integer.bin

color.lua:
	curl https://raw.githubusercontent.com/EmmanuelOga/columns/master/utils/color.lua >$@
