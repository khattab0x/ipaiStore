TARGET := iphone:clang:latest:13.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ipaiStoreCredit
ipaiStoreCredit_FILES = Tweak.x
ipaiStoreCredit_CFLAGS = -fobjc-arc
ipaiStoreCredit_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
