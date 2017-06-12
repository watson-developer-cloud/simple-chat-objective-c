# Watson Developer Cloud Swift SDK: Chat App Example

This repository contains an example application to demonstrate how the Swift-based [Watson Developer Cloud Swift SDK](https://github.com/watson-developer-cloud/ios-sdk) can be consumed from an Objective-C application.

This example modifies the [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) demo application to add Watson services, including Speech to Text, Conversation, and Text to Speech.

_Please note that this project is still a work-in-progress!_

### Requirements

- Xcode 7.3+
- iOS 8.0+

### Dependency Management

This project uses both [Carthage](https://github.com/Carthage/Carthage) and [CocoaPods](https://cocoapods.org/) to manage dependencies.

- Install Carthage using [Homebrew](http://brew.sh/): `brew install carthage`
- Install CocoaPods: `sudo gem install cocoapods`

### Getting Started

1. Clone the repository: `git clone https://github.com/watson-developer-cloud/simple-chat-objective-c.git`
2. Build the dependencies: `carthage update --platform iOS`
3. Open `ChatApp.xcworkspace`
4. Copy `CredentialsExample.swift` to `Credentials.swift`.
5. Update your service credentials in `Credentials.swift`
6. Build and run the app!
