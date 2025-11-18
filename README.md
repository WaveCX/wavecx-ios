# WaveCx iOS SDK

Deliver targeted, contextual content to your iOS users at precisely the right moments in their journey.

## Features

- Start a user session with attributes
- Trigger content based on specific trigger points
- Display user-triggered content modals
- Debug mode for detailed logging
- Mock mode for testing without API calls
- Automatic retry with exponential backoff
- Thread-safe for concurrent access

## Showcase App

A complete example banking application is included in the `WaveCxShowcaseApp` directory. Open `WaveCxShowcaseApp.xcodeproj` to explore:

- User session management
- Trigger point integration
- Content availability checks
- Mock mode configuration
- Debug logging
- Analytics tracking

The showcase app demonstrates practical integration patterns for e-commerce, banking, and SaaS applications.

## Installation

To integrate the WaveCx iOS SDK into your project, add the SDK to your dependencies and ensure it is properly linked in your Xcode project.

### CocoaPods
Add the WaveCx SDK to your Podfile and run `pod install`:

```ruby
target :YourTargetName do
  pod 'WaveCxSdk', '~> 1.0.0'
end
```

## Usage

### 1. Configure the SDK

Before using the SDK, configure it with your organization's code and API base URL:

```swift
WaveCx.configureShared(
    organizationCode: "your-organization-code",
)
```

#### Enable Debug Mode

Enable debug mode to see detailed console logs about SDK operations:

```swift
WaveCx.configureShared(
    organizationCode: "your-organization-code",
    debugMode: true
)
```

#### Enable Mock Mode

Mock mode allows testing the SDK without making actual API calls. Useful for local development, automated testing, and demos.

**Basic Usage:**

```swift
let mockConfig = MockModeConfig(enabled: true)
WaveCx.configureShared(
    organizationCode: "your-organization-code",
    mockModeConfig: mockConfig
)
```

**With Network Delay Simulation:**

```swift
let mockConfig = MockModeConfig(
    enabled: true,
    networkDelay: 1.5  // Simulate 1.5 second network delay
)
WaveCx.configureShared(
    organizationCode: "your-organization-code",
    debugMode: true,
    mockModeConfig: mockConfig
)
```

**Respond to Specific Trigger Points Only:**

```swift
let mockConfig = MockModeConfig(
    enabled: true,
    contentStrategy: .specificTriggerPoints(["home-screen", "checkout", "help"])
)
WaveCx.configureShared(
    organizationCode: "your-organization-code",
    mockModeConfig: mockConfig
)
```

When mock mode is enabled:
- No actual API calls are made
- With `.allTriggerPoints` strategy: Mock content is generated on-demand for any trigger point
- With `.specificTriggerPoints` strategy: Mock content is pre-generated only for specified trigger points
- Network delays can optionally be simulated
- Custom content can override the defaults

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
- iOS 15.6+
- Swift 5.0+
- Xcode 14.0+

## Documentation

- **API Reference**: Open `WaveCxSdk.doccarchive` for complete API documentation
- **Changelog**: See [CHANGELOG.md](CHANGELOG.md) for version history
- **Release Notes**: See [RELEASE_NOTES.md](RELEASE_NOTES.md) for release announcements
- **Showcase App**: Explore `WaveCxShowcaseApp` for complete examples

## Support

- **Issues**: Report bugs at [GitHub Issues](https://github.com/wavecx/wavecx-ios/issues)
- **Contact**: Reach out to your WaveCx representative

## License
This project is licensed under the MIT License. See the LICENSE file for details.
