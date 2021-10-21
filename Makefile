SHELL := /usr/bin/env bash
VERSION := $(shell cat pubspec.yaml | grep "^version: " | cut -c 10- | sed 's/+/\-/')
BUILD_ROOT := ../build-package
BASE_NAME := quickgui-$(VERSION)
BUILD_DIR := $(BUILD_ROOT)/$(BASE_NAME)
BIN_TAR := $(BUILD_ROOT)/$(BASE_NAME).tar
SRC_TAR := $(BUILD_ROOT)/$(BASE_NAME)-src.tar
FLUTTER := /usr/local/bin/flutter

all: version bin

version:
	@echo VERSION is $(VERSION)
	@echo BUILD_ROOT is $(BUILD_ROOT)

distclean:
	$(FLUTTER) clean
	rm -rf $(BUILD_ROOT)

quickgui: distclean
	$(FLUTTER) pub get
	$(FLUTTER) build linux --release

bin: quickgui
	mkdir -p $(BUILD_DIR)
	cp -a build/linux/x64/release/bundle/* $(BUILD_DIR)
	tar -C $(BUILD_ROOT) -c -v -f $(BIN_TAR) $(BASE_NAME)
	xz -z $(BIN_TAR)

src: distclean
	mkdir -p $(BUILD_ROOT)
	tar -C .. -c -v -f $(SRC_TAR) --exclude .git --transform 's/^quickgui/$(BASE_NAME)/' quickgui
	xz -z $(SRC_TAR)
