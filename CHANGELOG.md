# Changelog

All notable changes to the WaveCx iOS SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-17

### Added

Complete solution for delivering targeted, contextual content to iOS users at precisely the right moments in their journey.

### Core Features

**User Session Management**
- Start user sessions with organization and user identification
- Optional user ID verification for enhanced security
- Thread-safe session state management
- Automatic session persistence

**Content Delivery**
- Trigger point system for location-based content display
- Automatic popup content (displayed immediately when triggered)
- User-triggered content (requires user interaction to display)
- Smart content caching for offline availability
- Queue system for trigger points during content fetch

**Modal Presentation**
- Beautiful WebKit-based content display
- Multiple modal styles: pageSheet, fullScreen, formSheet
- Customizable header colors and titles
- Flexible close button options (text or X icon)
- Loading spinner with proper webview transparency
- Polished error UI for content loading failures
- Back navigation support within modal webviews
- Smart external link handling (mailto, tel, cross-domain)

**Network & Reliability**
- Automatic retry with configurable retry policy
- Exponential backoff for failed requests (1-32 second range)
- Smart retry logic (retries 5xx errors, skips 4xx)
- Default 3 attempts for both API calls and webview content
- Thread-safe with serial dispatch queue and barrier synchronization

**Developer Tools**
- **Debug Mode**: Detailed SDK logging for integration troubleshooting
- **Mock Mode**: Full SDK testing without live API connections
  - Auto-generate mock content for rapid prototyping
  - Target specific trigger points for focused testing
  - Provide custom mock content for realistic scenarios
  - Simulate network delays to test loading states
  - Branded mock content for clear SDK identification
- Public version constant for runtime version detection

**Documentation**
- Complete DocC documentation for all public APIs
- Extensive code examples
- Quick start guides
- Integration best practices

**Quality & Safety**
- Thread-safe for concurrent access from multiple threads
- Comprehensive test suite
- Production-ready error handling
- Memory-safe with proper cleanup

### Installation

**CocoaPods**
```ruby
pod 'WaveCxSdk', '~> 1.0.0'
```

**Swift Package Manager**
```swift
dependencies: [
    .package(url: "https://github.com/wavecx/wavecx-ios-distribution.git", from: "1.0.0")
]
```

### Quick Start

```swift
import WaveCxSdk

// Configure SDK at app launch
WaveCx.configureShared(
    organizationCode: "your-org",
    debugMode: true  // Optional: enable debug logging
)

// Start user session
await WaveCx.shared.startUserSession(userId: "user123")

// Trigger content at key points
WaveCx.shared.triggerPoint("home-screen-load")

// Check for user-triggered content
if WaveCx.shared.hasContent(for: "help-button", presentationType: "button-triggered") {
    // Show help button
}
```

### Technical Details

- **Minimum iOS Version**: 15.6
- **Language**: Swift 5.0+
- **Architecture**: arm64 (device) + arm64/x86_64 (simulator)
- **Dependencies**: None (WebKit is iOS system framework)
- **Distribution**: XCFramework (universal binary)
- **Documentation**: DocC archive included

### What's Included

- `WaveCxSdk.xcframework` - Universal binary framework
- `WaveCxSdk.doccarchive` - Complete API documentation (double-click to open in Xcode)

---

## Getting Help

- **Documentation**: Open `WaveCxSdk.doccarchive` for complete API reference
- **Issues**: Report bugs at [GitHub Issues](https://github.com/wavecx/wavecx-ios/issues)
- **Support**: Contact your WaveCx representative

[1.0.0]: https://github.com/wavecx/wavecx-ios-distribution/releases/tag/v1.0.0
