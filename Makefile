ARCHS = armv7 arm64
TARGET = iphone:clang::4.2.1

TWEAK_NAME = KeyboardAccio
KeyboardAccio_OBJCC_FILES = Tweak.mm
KeyboardAccio_FRAMEWORKS = UIKit 

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

sync: stage
	rsync -e "ssh -p 2222" -z _/Library/MobileSubstrate/DynamicLibraries/* root@127.0.0.1:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@127.0.0.1 -p 2222 killall MobileNotes
	ssh root@127.0.0.1 -p 2222 open com.apple.mobilenotes