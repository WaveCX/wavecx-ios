# WaveCX iOS SDK

The WaveCx iOS SDK provides tools to integrate targeted content and user-triggered modals into your iOS applications.

## Features

- Start a user session with attributes.
- Trigger content based on specific trigger points.
- Display user-triggered content modals.

## Installation

To integrate the WaveCx iOS SDK into your project, add the SDK to your dependencies and ensure it is properly linked in your Xcode project.

### CocoaPods
Add the WaveCX pod into your Podfile and run pod install.

    target :YourTargetName do
      pod 'WaveCxSdk'
    end

## Usage

### 1. Configure the SDK

Before using the SDK, configure it with your organization's code and API base URL:

```swift
WaveCx.configureShared(
    organizationCode: "your-organization-code",
)
```

### 2. Start a User Session
To start a user session, call the startUserSession method with the user's ID and optional attributes:

```swift
do {
    try await WaveCx.shared.startUserSession(
        userId: "userId",
        userAttributes: [
            // optional user attributes
            "your-attribute": "attribute-value",
        ]
    )
} catch {
    print("Failed to start user session: \(error)")
}
```

3. Trigger Content
You can trigger content based on specific trigger points. For example:

```swift
WaveCx.shared.triggerPoint(
    triggerPointCode: "account-page"
)
```

4. Check for User-Triggered Content
After triggering a point, you can check if there is user-triggered content available:

```swift
let hasContent = WaveCx.shared.hasUserTriggeredContent()
if hasContent {
    WaveCx.shared.showUserTriggeredContent()
}
```

Example Integration
Below is an example of how the SDK is used in a SwiftUI ContentView:

```swift
struct ContentView: View {
    @State var showUserTriggered = false

    var body: some View {
        VStack {
            Button("Sign In") {
                Task {
                    await signIn()
                }
            }
            Button("Account Page") {
                WaveCx.shared.triggerPoint(
                    triggerPointCode: "account-page"
                )
                showUserTriggered = WaveCx.shared.hasUserTriggeredContent()
            }
            if showUserTriggered {
                Button("User-Triggered") {
                    WaveCx.shared.showUserTriggeredContent()
                }
            }
        }
    }
}

func signIn() async {
    WaveCx.configureShared(
        organizationCode: "your-organization-code",
    )
    do {
        try await WaveCx.shared.startUserSession(
            userId: "userId",
            userAttributes: [
                // optional user attributes
                "your-attribute": "attribute-value",
            ]
        )
    } catch {
        print("Error starting WaveCX session")
    }
}
```

## Requirements
- iOS 13.0+
- Swift 5.0+

## License
This project is licensed under the Apache License 2.0. See the LICENSE file for details.
