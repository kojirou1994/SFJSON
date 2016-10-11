import XCTest
@testable import SFJSON

class SFJSONTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		let jsonStr = "{\"string\": \"value\", \"number\": 5, \"null\": null}"
		let json = try! SFJSON(jsonString: jsonStr)
		XCTAssertEqual(json["string"].string, "value")
		XCTAssertEqual(json["number"].int, 5)
		
    }


    static var allTests : [(String, (SFJSONTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
