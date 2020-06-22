-- luacheck: globals gpio

gpio.mode(3, gpio.INPUT) -- GPIO0 - pull low if you get in a boot loop
gpio.mode(4, gpio.OUTPUT) -- GPIO2
gpio.write(4, gpio.HIGH)

print("Starting ark's SmartButton")

if gpio.read(3) == 1 then
    require("run").run()
end
