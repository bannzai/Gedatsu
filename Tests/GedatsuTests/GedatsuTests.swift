import XCTest
@testable import Gedatsu

final class GedatsuTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Gedatsu().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
