FILES = $(shell ls -1 *.lua *.json)
CHANGED_FILES = $(FILES:%=.changed/%)

dev: upload terminal

upload: deferred.lua $(CHANGED_FILES)

.changed/%.lua: %.lua
	nodemcu-tool upload -m $<
	touch $@

.changed/%.json: %.json
	nodemcu-tool upload $<
	touch $@

deferred.lua:
	curl -o $@ https://raw.githubusercontent.com/zserge/lua-promises/master/deferred.lua

clean:
	rm -fv .changed/*
	nodemcu-tool mkfs

terminal:
	rlwrap -a 'password:' -t dumb nodemcu-tool terminal

wifi:
	nodemcu-tool upload wifi.kittens.lua
	nodemcu-tool run wifi.kittens.lua

flash:
	esptool.py --port $$(jq -r .port .nodemcutool) write_flash 0x00 ../../thirdparty/esp8266/latest.int.bin

# nodemcu-1.5.4.1-final-13-modules-2019-10-07-23-17-09-integer.bin
