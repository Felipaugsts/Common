SHELL = /bin/sh

help:
	echo "Usage: make [command]"
	echo ""
	echo "[Commands]"
	echo "help       Displays this help."
	echo "setup      Installs the required tools."
	echo "install    Runs pod install within SDUIOrchestrator/Examples directory."
	echo "lint       Runs SwiftLint with auto-correction of violations whenever possible."
	echo "build      Builds the project."
	echo "sonar      Runs tests then Sonar analysis."
	echo "open       Opens the project in XCode."

setup:
ifndef XCPRETTY
	gem install xcpretty
endif
ifndef JQ
	brew install jq
endif
ifndef SONAR_SCANNER
	brew install sonar-scanner
endif

install:
	xcodegen generate

open:
	open Example/SDKCommon.xcworkspace