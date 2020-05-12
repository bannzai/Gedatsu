PLATFORM?=iOS Simulator
DEVICE?=iPhone SE (2nd generation)
SDK?=$(shell xcrun --sdk iphonesimulator --show-sdk-path)

.PHONY: install
install:
	swift package generate-xcodeproj

.PHONY: build
build: schema
	# See also: https://github.com/apple/swift/blob/master/utils/build-script-impl#L504
	swift build -Xswiftc "-sdk" -Xswiftc $(SDK) -Xswiftc "-target" -Xswiftc "x86_64-apple-ios13.0-simulator"
	xcodebuild -workspace GedatsuExample/GedatsuExample.xcworkspace -scheme GedatsuExample -destination 'platform=$(PLATFORM),name=$(DEVICE)'

.PHONY: sourcery
sourcery: 
	sourcery --sources ./Sources/Gedatsu --templates ./templates/sourcery/mockable.stencil  --output ./Tests/GedatsuTests/Mock.generated.swift 

.PHONY: test
test: schema sourcery
	xcodebuild test -scheme Gedatsu -configuration Debug -sdk $(SDK) -destination "platform=$(PLATFORM),name=$(DEVICE)" 

.PHONY: schema
schema: install
	mv Gedatsu.xcodeproj/xcshareddata/xcschemes/Gedatsu-Package.xcscheme Gedatsu.xcodeproj/xcshareddata/xcschemes/Gedatsu.xcscheme

.PHONY: release
release:
	$(eval CURRENT=$(shell git describe --tags --abbrev=0))
	$(eval NEXT=$(shell git describe --tags --abbrev=0 | awk -F. '{$$NF+=1; OFS="."; print $0}'))
	sed -i '' -e 's/$(CURRENT)/$(NEXT)/g' Gedatsu.podspec
	git tag $(NEXT)
	git push origin --tags
	pod trunk push Gedatsu.podspec --allow-warnings
