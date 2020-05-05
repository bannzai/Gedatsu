
.PHONY: sourcery
sourcery: 
	sourcery --sources ./Sources/Gedatsu --templates ./templates/sourcery/mockable.stencil  --output ./Tests/Mock.generated.swift 
