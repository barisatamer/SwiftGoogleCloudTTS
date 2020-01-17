import XCTest
@testable import swift_google_tts

final class swift_google_ttsTests: XCTestCase {
    
    var client: GoogleTTSClient = GoogleTTSClient()
    
    override func setUp() {}

    override func tearDown() {}
    
    func testListVoices() {
        let request = Google_Cloud_Texttospeech_V1_ListVoicesRequest.with {
            $0.languageCode = "en-US"
        }
        do {
            let response = try client.listVoices(request: request).wait()
            XCTAssert(response.voices.count == 32, "Voice count must be 32!")
        } catch {
            XCTFail()
        }
    }

    static var allTests = [
        ("testListVoices", testListVoices),
    ]
}
