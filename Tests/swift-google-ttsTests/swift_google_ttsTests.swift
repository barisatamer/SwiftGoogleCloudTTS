import XCTest
@testable import swift_google_tts

final class swift_google_ttsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_google_tts().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
