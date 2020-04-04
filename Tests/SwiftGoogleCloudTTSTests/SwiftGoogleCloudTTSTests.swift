import XCTest
@testable import SwiftGoogleCloudTTS

final class SwiftGoogleCloudTTSTests: XCTestCase {
    
    var client: GoogleTTSClient = GoogleTTSClient()
    
    override func setUp() {}

    override func tearDown() {}
    
    func testListVoices() {
        let request = Google_Cloud_Texttospeech_V1beta1_ListVoicesRequest.with {
            $0.languageCode = "en-US"
        }
        do {
            let response = try client.listVoices(request: request).wait()
            XCTAssert(response.voices.count > 0, "Voice count must be greater than 0!")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSynthesizeSpeech() {
        let synthesizeSpeechRequest = Google_Cloud_Texttospeech_V1beta1_SynthesizeSpeechRequest.with {
            $0.input = Google_Cloud_Texttospeech_V1beta1_SynthesisInput.with {
                $0.text = "Ich bin"
            }
            $0.voice = Google_Cloud_Texttospeech_V1beta1_VoiceSelectionParams.with {
                $0.name = "de-DE-Wavenet-B"
                $0.languageCode = "de-DE"
            }
            $0.audioConfig = Google_Cloud_Texttospeech_V1beta1_AudioConfig.with {
                $0.audioEncoding = Google_Cloud_Texttospeech_V1beta1_AudioEncoding.mp3
            }
        }
        do {
            let response = try client.synthesizeSpeech(request: synthesizeSpeechRequest).wait()
            XCTAssert(response.audioContent.count > 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    static var allTests = [
        ("testListVoices", testListVoices),
    ]
}
