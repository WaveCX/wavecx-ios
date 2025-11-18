# WaveCx iOS SDK v1.0.0 - Release Notes

**Release Date**: November 17, 2025

## Welcome to WaveCx iOS SDK 1.0

Deliver targeted, contextual content to your iOS users at precisely the right moments in their journey.

## ✨ What's New

### Complete Feature Set

Everything you need to integrate WaveCx into your iOS application:

- ✅ User session management with secure authentication
- ✅ Location-based content triggering system
- ✅ Beautiful modal content presentation
- ✅ Automatic and user-triggered content modes
- ✅ Smart caching and offline support
- ✅ Automatic retry with exponential backoff
- ✅ Thread-safe for concurrent access
- ✅ Debug and mock modes for development
- ✅ Complete DocC documentation

### Key Highlights

**Easy Integration**
Get started quickly with a straightforward configuration API:

```swift
WaveCx.configureShared(organizationCode: "your-org")
await WaveCx.shared.startUserSession(userId: "user123")
WaveCx.shared.triggerPoint("checkout-complete")
```

**Production Ready**
Built for reliability:
- Thread-safe architecture for concurrent use
- Automatic retry with exponential backoff
- Comprehensive error handling
- Memory-safe with proper cleanup
- Extensively tested

**Polished Presentation**
Flexible modal display options:
- Multiple modal types (pageSheet, fullScreen, formSheet)
- Customizable colors and branding
- Loading states and error handling
- Smart external link handling
- In-modal navigation support

**Developer Tools**
Streamlined development workflow:
- Debug mode with detailed logging
- Mock mode for offline development
- Custom mock content support
- Network delay simulation

**Complete Documentation**
Every public API is fully documented:
- Comprehensive DocC documentation
- Practical code examples
- Integration best practices

## 📦 What's Included

- **WaveCxSdk.xcframework** - Universal binary framework (device + simulator)
- **WaveCxSdk.doccarchive** - Complete API documentation (double-click to open)
- **LICENSE** - MIT License
- **CHANGELOG.md** - Detailed version history
- **README.md** - Installation and usage guide

## 🔧 Installation

### CocoaPods

```ruby
pod 'WaveCxSdk', '~> 1.0.0'
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/wavecx/wavecx-ios-distribution.git", from: "1.0.0")
]
```

### Manual Integration

1. Download `WaveCxSdk.xcframework` from this release
2. Drag it into your Xcode project
3. In target settings → General → Frameworks, Libraries, and Embedded Content, ensure it's set to "Embed & Sign"

## 📖 Quick Start

```swift
import WaveCxSdk

// 1. Configure at app launch (in AppDelegate or App struct)
WaveCx.configureShared(
    organizationCode: "your-org",
    debugMode: true  // Enable detailed logging during development
)

// 2. Start a user session
await WaveCx.shared.startUserSession(userId: "user123")

// 3. Trigger content at key moments
WaveCx.shared.triggerPoint("home-screen-load")
WaveCx.shared.triggerPoint("checkout-complete")
WaveCx.shared.triggerPoint("profile-view")

// 4. Check for user-triggered content
if WaveCx.shared.hasContent(for: "help-button", presentationType: "button-triggered") {
    // Show help button in your UI
    Button("Help") {
        WaveCx.shared.triggerPoint("help-button")
    }
}

// 5. End session on logout
WaveCx.shared.endSession()
```

## 🧪 Testing with Mock Mode

Mock mode lets you test your integration without API calls:

```swift
let mockConfig = MockModeConfig(
    enabled: true,
    networkDelay: 1.0,  // Simulate 1-second API call
    contentStrategy: .allTriggerPoints
)

WaveCx.configureShared(
    organizationCode: "demo-org",
    debugMode: true,
    mockModeConfig: mockConfig
)
```

## 🎯 Common Use Cases

### E-commerce
- Welcome popups for new users
- Product recommendations at checkout
- Cart abandonment recovery
- Post-purchase surveys

### Banking
- Feature announcements on login
- Investment promotions
- Educational content
- Support resources

### SaaS
- Onboarding tours
- Feature discovery
- Upgrade prompts
- Help documentation

## ⚙️ Requirements

- **iOS**: 15.6 or later
- **Xcode**: 14.0 or later
- **Swift**: 5.0 or later
- **Dependencies**: None

## 📱 Supported Platforms

- ✅ iPhone (arm64)
- ✅ iPhone Simulator (arm64, x86_64)
- ✅ iPad (arm64)
- ✅ iPad Simulator (arm64, x86_64)

## Support

- **Documentation**: Open `WaveCxSdk.doccarchive` for complete API reference
- **Sample Code**: Explore the included WaveCxShowcaseApp for integration examples
- **Issues**: Report bugs at [GitHub Issues](https://github.com/wavecx/wavecx-ios/issues)
- **Contact**: Reach out to your WaveCx representative

---

**Full Changelog**: See [CHANGELOG.md](CHANGELOG.md) for detailed version history
