# Internet enabled es8266 button

Based on [IFTTT Smart Button](https://www.hackster.io/noelportugal/ifttt-smart-button-e11841).

It's controlled by a `config.json` file that has one or more items in an actions array.
see [config.example.json](config.example.json) for an example

Each action has a `type` which will determine which `action_*.lua` is run. It also has a `config` which are the options for that action and documented at the top of each action file.

API keys and passwords are stored in a file called `secrets.json`. This allows me to check in my config files without exposing secrets.

An action can add more actions to be executed once it exits by calling `require("run").add(action_name, action_config)`. See examples in [action-nagging.lua](action-nagging.lua).

The Makefile has some magic which you might like.

You'll need [esptool.py](https://github.com/espressif/esptool),  [nodemcu-tool](https://www.npmjs.com/package/nodemcu-tool) and [a build](https://nodemcu-build.com/) with at least adc, cjson, file, gpio, http, net, node, tmr, uart and wifi.

## TODO

* Make it OTA wifi configurable if GPIO0 is pulled low for a long time
* provide a web ui to configure it if GPIO0 is pulled low for a short time
* MQTT action?
* other actions

## Blog Posts

* https://blog.wtwf.com/2019/10/esp8266-internet-button-mailbox.html
