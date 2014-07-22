include theos/makefiles/common.mk

APPLICATION_NAME = BundleIDs
BundleIDs_FILES = main.m BundleIDsApplication.mm RootViewController.mm
BundleIDs_FRAMEWORKS = UIKit CoreGraphics
BundleIDs_LIBRARIES = applist

after-install::
	install.exec "killall -9 BundleIDs"

include $(THEOS_MAKE_PATH)/application.mk
