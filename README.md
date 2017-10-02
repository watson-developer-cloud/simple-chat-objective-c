# Watson Developer Cloud Swift SDK: Chat App Example

This repository contains an example application to demonstrate how the Swift-based [Watson Developer Cloud Swift SDK](https://github.com/watson-developer-cloud/swift-sdk) can be consumed from an Objective-C application.

This example modifies the [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) demo application to add Watson services, including Speech to Text, Conversation, and Text to Speech.

### Requirements

- iOS 8.0+
- Xcode 9.0+
- Swift 4.0+

### Getting Started

1. Clone the repository: `git clone https://github.com/watson-developer-cloud/simple-chat-objective-c.git`
2. Install [Carthage](https://github.com/Carthage/Carthage) using [Homebrew](http://brew.sh/): `brew install carthage`
3. Build the dependencies: `carthage update --platform iOS`
4. Open `ChatApp.xcworkspace`
5. Copy `CredentialsExample.swift` to `Credentials.swift`.
6. Update your service credentials in `Credentials.swift`
7. Build and run the app!
