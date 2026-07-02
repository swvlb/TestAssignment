.PHONY: generate build test run open clean

PROJECT     = TestAssignment.xcodeproj
SCHEME      = TestAssignment
DESTINATION = platform=iOS Simulator,name=iPhone 15,OS=latest

generate:
	xcodegen generate

build: generate
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination '$(DESTINATION)' build

test: generate
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination '$(DESTINATION)' test

run: generate
	open $(PROJECT)

open: generate
	open $(PROJECT)

clean:
	rm -rf $(PROJECT) build
