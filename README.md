# SwiftGoogleCloudTTS
<p align="left">
  <a href="https://swift.org">
    <img src="http://img.shields.io/badge/swift-5.0-brightgreen.svg" alt="Swift 5.0">
  </a>
  <a href="LICENSE">
    <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
</p>
  
### Before you begin ⚠️

1.  [Select or create a Cloud Platform project][projects].
1.  [Enable billing for your project][billing].
1.  [Enable the Google Cloud Text-to-Speech API][enable_api].
1.  [Set up authentication with a service account][auth] so you can access the
    API from your local workstation.
    
### Installation 📦

To include it in your package, add the following to your `Package.swift` file.

```swift
let package = Package(
    name: "Project",
    dependencies: [
        ...
        .package(url: "https://github.com/barisatamer/SwiftGoogleCloudTTS.git", from: "0.0.5"),
        ],
        targets: [
            .target(name: "App", dependencies: ["SwiftGoogleCloudTTS", ... ])
        ]
    )
```

### Setting the environment variable 

```bash
export GOOGLE_APPLICATION_CREDENTIALS="[PATH]"
```

### Usage 🚀
```swift
import SwiftGoogleCloudTTS

let synthesizeSpeechRequest = Google_Cloud_Texttospeech_V1_SynthesizeSpeechRequest.with {
    $0.input = Google_Cloud_Texttospeech_V1_SynthesisInput.with {
        $0.text = "Text to speech testing"
    }
    $0.voice = Google_Cloud_Texttospeech_V1_VoiceSelectionParams.with {
        $0.name = "en-US-Wavenet-A"
        $0.languageCode = "en-US"
    }
    $0.audioConfig = Google_Cloud_Texttospeech_V1_AudioConfig.with {
        $0.audioEncoding = Google_Cloud_Texttospeech_V1_AudioEncoding.mp3
    }
}
do {
    let response = try client.synthesizeSpeech(request: synthesizeSpeechRequest).wait()
    // .. 
} catch {
    print(error)
}

```




[client-docs]: https://googleapis.dev/nodejs/text-to-speech/latest
[product-docs]: https://cloud.google.com/text-to-speech
[shell_img]: https://gstatic.com/cloudssh/images/open-btn.png
[projects]: https://console.cloud.google.com/project
[billing]: https://support.google.com/cloud/answer/6293499#enable-billing
[enable_api]: https://console.cloud.google.com/flows/enableapi?apiid=texttospeech.googleapis.com
[auth]: https://cloud.google.com/docs/authentication/getting-started
