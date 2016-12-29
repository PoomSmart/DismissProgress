GO_EASY_ON_ME = 1
TARGET = iphone:latest:8.0
ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DismissProgress
DismissProgress_FILES = Tweak.xm
DismissProgress_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
