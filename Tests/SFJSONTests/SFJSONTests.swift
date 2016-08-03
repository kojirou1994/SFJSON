import XCTest
@testable import SFJSON

class SFJSONTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(SFJSON().text, "Hello, World!")
    }


    static var allTests : [(String, (SFJSONTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
