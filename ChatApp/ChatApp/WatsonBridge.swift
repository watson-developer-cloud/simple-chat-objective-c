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
import AVFoundation
import TextToSpeechV1
import ConversationV1
import SpeechToTextV1

class TextToSpeechBridge: NSObject {
    
    private var audioPlayer: AVAudioPlayer?
    private let textToSpeech = TextToSpeech(
        username: Credentials.TextToSpeechUsername,
        password: Credentials.TextToSpeechPassword
    )
    
    func synthesize(text: String) {
        let failure = { (error: Error) in print(error) }
        textToSpeech.synthesize(text, voice: SynthesisVoice.us_Michael.rawValue, audioFormat: .wav, failure: failure) { data in
            self.audioPlayer = try! AVAudioPlayer(data: data)
            self.audioPlayer!.prepareToPlay()
            self.audioPlayer!.play()
        }
    }
}

class ConversationBridge: NSObject {
    
    private var context: Context?
    private let workspaceID = Credentials.ConversationWorkspace
    private let conversation = Conversation(
        username: Credentials.ConversationUsername,
        password: Credentials.ConversationPassword,
        version: "2016-11-02"
    )
    
    func startConversation(success: @escaping ((String) -> Void)) {
        context = nil // clear context to start a new conversation
        let failure = { (error: Error) in print(error) }
        conversation.message(withWorkspace: workspaceID, failure: failure) { response in
            self.context = response.context // save context to continue conversation
            let text = response.output.text.joined(separator: "")
            success(text)
        }
    }
    
    func continueConversation(text: String, success: @escaping ((String) -> Void)) {
        let failure = { (error: Error) in print(error) }
        let request = MessageRequest(text: text, context: context)
        conversation.message(withWorkspace: workspaceID, request: request, failure: failure) { response in
            self.context = response.context // save context to continue conversation
            let text = response.output.text.joined(separator: "")
            success(text)
        }
    }
}

class SpeechToTextBridge: NSObject {
    
    private let session = SpeechToTextSession(
        username: Credentials.SpeechToTextUsername,
        password: Credentials.SpeechToTextPassword
    )
    
    func prepare(onResults: @escaping ((String) -> Void)) {
        session.onConnect = { print("Speech to Text: Connected") }
        session.onDisconnect = { print("Speech to Text: Disconnected") }
        session.onError = { error in print("Speech to Text: \(error)") }
        session.onPowerData = { decibels in print("Microphone Volume: \(decibels)") }
        session.onResults = { results in onResults(results.bestTranscript) }
    }
    
    func connect() {
        session.connect()
    }
    
    func startRequest() {
        var settings = RecognitionSettings(contentType: .opus)
        settings.interimResults = true
        session.startRequest(settings: settings)
    }
    
    func startMicrophone() {
        session.startMicrophone()
    }
    
    func stopMicrophone() {
        session.stopMicrophone()
    }
    
    func stopRequest() {
        session.stopRequest()
    }
    
    func disconnect() {
        session.disconnect()
    }
}
