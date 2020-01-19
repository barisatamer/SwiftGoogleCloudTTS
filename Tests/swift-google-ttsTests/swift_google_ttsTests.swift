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
    
    func testSynthesizeSpeech() {
        let synthesizeSpeechRequest = Google_Cloud_Texttospeech_V1_SynthesizeSpeechRequest.with {
            $0.input = Google_Cloud_Texttospeech_V1_SynthesisInput.with {
                $0.text = "Ich bin"
            }
            $0.voice = Google_Cloud_Texttospeech_V1_VoiceSelectionParams.with {
                $0.name = "de-DE-Wavenet-B"
                $0.languageCode = "de-DE"
            }
            $0.audioConfig = Google_Cloud_Texttospeech_V1_AudioConfig.with {
                $0.audioEncoding = Google_Cloud_Texttospeech_V1_AudioEncoding.mp3
            }
        }
        do {
            let response = try client.synthesizeSpeech(request: synthesizeSpeechRequest).wait()
            XCTAssert(
                response.audioContent.base64EncodedString() == base64String,
                "base64EncodedString response does not match!"
            )
        } catch {
            XCTFail()
        }
    }

    static var allTests = [
        ("testListVoices", testListVoices),
    ]
}


let base64String = """
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
"""
