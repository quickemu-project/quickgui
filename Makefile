SHELL := /usr/bin/env bash
VERSION := $(shell cat pubspec.yaml | grep "^version: " | cut -c 10- | sed 's/+/\-/')

all: prep quickgui clean

prep:
	@echo VERSION is $(VERSION)
	rm -rf _tmp
	mkdir -p _tmp/quickgui
	rm -f quickgui-$(VERSION).tar
	rm -f quickgui-$(VERSION).tar.xz

quickgui:
	flutter build linux --release
	cp -a build/linux/x64/release/bundle/* _tmp/quickgui
	tar -C _tmp -c -f quickgui-$(VERSION).tar quickgui/
	xz -z quickgui-$(VERSION).tar

clean:
	rm -rf _tmp
