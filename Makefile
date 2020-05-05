.PHONY: install
install:
	swift package generate-xcodeproj

.PHONY: build
build:
	# See also: https://github.com/apple/swift/blob/master/utils/build-script-impl#L504
	swift build -Xswiftc "-sdk" -Xswiftc "`xcrun --sdk iphonesimulator --show-sdk-path`" -Xswiftc "-target" -Xswiftc "x86_64-apple-ios13.0-simulator"
	xcodebuild -workspace GedatsuExample/GedatsuExample.xcworkspace -scheme GedatsuExample -destination 'platform=iOS Simulator,name=iPhone SE (2nd generation)'

.PHONY: sourcery
sourcery: 
	sourcery --sources ./Sources/Gedatsu --templates ./templates/sourcery/mockable.stencil  --output ./Tests/Mock.generated.swift 


