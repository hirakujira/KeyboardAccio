TWEAK_NAME = KeyboardAccio
KeyboardAccio_FILES = ../Tweak.xm
KeyboardAccio_FRAMEWORKS = UIKit
KeyboardAccio_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices -fobjc-arc

TARGET = simulator:clang
SDKVERSION = 10.3
SYSROOT = /opt/theos/sdks/iPhoneSimulator10.3.sdk

GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

sync: stage
	cp .theos/_/Library/MobileSubstrate/DynamicLibraries/KeyboardAccio.dylib /opt/simject/KeyboardAccio.dylib
	cp .theos/_/Library/MobileSubstrate/DynamicLibraries/KeyboardAccio.plist /opt/simject/KeyboardAccio.plist
	ldid -S /opt/simject/KeyboardAccio.dylib
	resim