-- luacheck: globals adc node wifi

adc.force_init_mode(adc.INIT_VDD33)

node.restore()
wifi.setmode(wifi.STATION)
wifi.sta.config({ssid="YOUR_SSID", pwd="YOUR_WIFI_PASSWORD"})
