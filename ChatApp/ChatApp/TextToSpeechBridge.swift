/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import TextToSpeechV1
import AVFoundation

class TextToSpeechBridge: NSObject {
    
    private var audioPlayer: AVAudioPlayer?
    private let textToSpeech = TextToSpeech(
        username: credentials["TextToSpeechUsername"]!,
        password: credentials["TextToSpeechPassword"]!
    )
    
    func synthesize(text: String) {
        let failure = { (error: NSError) in print(error) }
        textToSpeech.synthesize(text, voice: .US_Michael, audioFormat: .WAV, failure: failure) { data in
            self.audioPlayer = try! AVAudioPlayer(data: data)
            self.audioPlayer!.prepareToPlay()
            self.audioPlayer!.play()
        }
    }
}
