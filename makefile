###############################################
#
# Makefile
#
###############################################

XC = xcodebuild
SF = ios-deploy
SCHEME = SynthMail
UDID = 32120b863a06ac58a5a07d9c87aabe8c40e3f627
XCDEST := platform=iOS,id=${UDID}
XCDIR = /Users/alimovlex/Library/Developer/Xcode/DerivedData
SDK ?= iphoneos

build:
	security unlock-keychain login.keychain
	$(XC) -project ${SCHEME}.xcodeproj -scheme ${SCHEME} -destination "$(XCDEST)" build
	$(SF) --debug --bundle $(XCDIR)/SynthMail-gtyxxpfvmjrmswdlzwqffthmqipu/Build/Products/Debug-iphoneos/$(SCHEME).app

ipa:
	$(XC) -workspace *.xcworkspace -scheme ${SCHEME} -sdk ${SDK} -configuration AdHoc archive -archivePath /Users/alimovlex/Documents/Builds/${SCHEME}.xcarchive
	$(XC) -exportArchive -archivePath /Users/alimovlex/Documents/Builds/${SCHEME}.xcarchive -exportOptionsPlist ExportOptions.plist -exportPath /Users/alimovlex/Documents/Builds/

schemes:
	$(XC) -workspace *.xcworkspace -list
	instruments -s devices 

test:
	security unlock-keychain -p rhonda login.keychain
	$(XC) -workspace *.xcworkspace -scheme ${SCHEME} -destination "$(XCDEST)" test

testbuild:
	security unlock-keychain -p rhonda login.keychain
	$(XC) -workspace *.xcworkspace -scheme ${SCHEME} -destination "$(XCDEST)" build-for-testing | xcpretty


