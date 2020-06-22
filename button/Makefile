FILES = $(shell ls -1 *.lua *.json)
CHANGED_FILES = $(FILES:%=.changed/%)

FIRMWARE=../../thirdparty/esp8266/nodemcu-1.5.4.1-final-11-modules-2019-11-21-18-38-26-adc-cjson-file-gpio-http-net-node-tmr-uart-wifi-ws2812integer.bin
FIRMWARE=../../thirdparty/esp8266/nodemcu-1.5.4.1-final-13-modules-2019-10-07-23-17-09-integer.bin
FIRMWARE=../../thirdparty/esp8266/nodemcu-1.5.4.1-final-18-modules-2019-10-19-18-12-12-integer.bin
FIRMWARE=../../thirdparty/esp8266/nodemcu-1.5.4.1-final-18-modules-2019-10-30-10-15-36-adc-cjson-enduser_setup-file-gpio-http-i2c-mqtt-net-node-ow-rotary-spi-tmr-uart-wifi-ws2812-integer.bin
# FIRMWARE=../../thirdparty/esp8266/nodemcu-master-19-modules-2019-10-19-17-44-45-integer.bin
FIRMWARE=../../thirdparty/esp8266/latest.int.bin

dev: upload terminal

upload: lua-promise.lua $(CHANGED_FILES)

.changed/%.lua: %.lua
	nodemcu-tool upload -m $<
	touch $@

.changed/%.json: %.json
	nodemcu-tool upload $<
	touch $@

lua-promise.lua:
	curl -o $@ https://raw.githubusercontent.com/hjmmc/lua-promise/master/lua-promise.lua

clean:
	rm -fv .changed/*
	nodemcu-tool mkfs

terminal:
	rlwrap -a 'password:' -t dumb nodemcu-tool terminal

# wifi:
#	cd ../wifi; make refresh

flash: do_flash terminal

do_flash:
	esptool.py --port $$(jq -r .port .nodemcutool) write_flash 0x00 $(FIRMWARE)

id:
	esptool.py --port $$(jq -r .port .nodemcutool) flash_id

# nodemcu-1.5.4.1-final-13-modules-2019-10-07-23-17-09-integer.bin
