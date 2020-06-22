FILES = $(shell ls -1 *.lua)
CHANGED_FILES = $(FILES:%=.changed/%)


upload: .changed $(CHANGED_FILES)

clean:
	rm .changed/*

refresh: clean upload

.changed/%.lua: %.lua
	nodemcu-tool upload -m $<
	touch $@

.changed:
	mkdir -p .changed
