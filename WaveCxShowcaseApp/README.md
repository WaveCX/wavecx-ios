# WaveCX Showcase App

A comprehensive demonstration app showcasing the WaveCX iOS SDK capabilities and best practices.

## Overview

This example application demonstrates how to integrate and use the WaveCX SDK in a real-world iOS app. It showcases:

- ✅ SDK configuration and initialization
- ✅ User session management (login/logout)
- ✅ Trigger points at various app locations
- ✅ Automatic popup content delivery
- ✅ User-triggered (button-based) content
- ✅ Custom delegate implementation for analytics
- ✅ Mock mode for testing without API calls
- ✅ Debug logging
- ✅ SwiftUI best practices
- ✅ User attributes for content targeting

## Features

### 🔐 Authentication Flow
- **Login View** with demo user profiles
- User session management with WaveCX SDK
- User attributes for content targeting (userType, platform)
- Clean logout with session cleanup

### 🏠 Multiple Views with Trigger Points
- **Home View**: Dynamically shows only trigger points with available content
- **Products View**: Product catalog with promotional content
- **Settings View**: Configuration and analytics dashboard

### 📊 Analytics & Tracking
- Real-time event logging via custom delegate
- Track all SDK lifecycle events:
  - Session start/end
  - Content fetching
  - Content display/dismissal
  - Trigger point activations
  - Errors
- View event history in Settings

### 🎯 Trigger Point Examples
The app demonstrates various trigger points with dynamic visibility:
- `home-screen` - Triggered when home view loads
- `feature-announcement` - Manual trigger for announcements
- `help-support` - Manual trigger for help content
- `promo-offer` - Manual trigger for promotional offers
- `products-screen` - Triggered when products view loads
- `special-offer` - Manual trigger in products view
- `product-selected` - Triggered when user selects a product
- `settings-screen` - Triggered when settings view loads
- `account-settings` - Manual trigger in settings
- `preferences` - Manual trigger in settings

**Dynamic Content Checking:**
The Home view only displays trigger buttons when **unseen popup content** is available for them. This demonstrates the `hasContent(for:presentationType:)` SDK method with presentation type filtering, allowing you to conditionally show/hide UI elements based on specific content types (popup vs. button-triggered). The view automatically updates when content is displayed/dismissed via the `onContentChanged()` delegate method.

### 🔔 User-Triggered Content
- Dynamic button appears when content is available
- Polls SDK for content availability
- Smooth animations and transitions
- Shows at bottom of screen across all tabs

### 🛠 Development Features
- **Mock Mode**: Test without API calls, auto-generated content
- **Debug Mode**: Detailed console logging
- **Network Delay Simulation**: Realistic testing conditions
- **Toggle Debug Mode**: Runtime control in Settings

## Project Structure

```
WaveCxShowcaseApp/
├── WaveCxShowcaseApp/
│   ├── WaveCxShowcaseAppApp.swift    # App entry point
│   ├── AppDelegate.swift             # SDK configuration
│   ├── Views/
│   │   ├── ContentView.swift         # Root view with tab navigation
│   │   ├── LoginView.swift           # Authentication UI
│   │   ├── HomeView.swift            # Home screen with triggers
│   │   ├── ProductsView.swift        # Products catalog
│   │   └── SettingsView.swift        # Settings and analytics
│   ├── ViewModels/
│   │   └── WaveCxViewModel.swift     # SDK state management
│   ├── Assets.xcassets/
│   └── Preview Content/
└── README.md
```

## Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 15.0 or later
- Swift 5.0 or later

### Installation

1. **Open the project:**
   ```bash
   cd WaveCxShowcaseApp
   open WaveCxShowcaseApp.xcodeproj
   ```

2. **Build and run:**
   - Select a simulator or device
   - Press `Cmd + R` to build and run

### Configuration

The app is pre-configured with mock mode for demonstration. To use with a real WaveCX organization:

1. Open `AppDelegate.swift`
2. Update the configuration:
   ```swift
   WaveCx.configureShared(
       organizationCode: "your-org-code",  // Replace with your org code
       debugMode: true
   )
   // Remove or disable mockModeConfig for production use
   ```

## How to Use

### 1. Login
- Choose a demo user (John Doe, Jane Smith, or Alex Johnson)
- Or enter a custom user ID
- Each user has different attributes for content targeting

### 2. Explore Trigger Points
- **Home Tab**: Tap trigger buttons to simulate different app events
- **Products Tab**: Browse products, tap special offers
- **Settings Tab**: Configure SDK, view analytics

### 3. View Analytics
- Go to Settings → View Event Log
- See all SDK events in real-time
- Track content delivery and user interactions

### 4. User-Triggered Content
- If button-triggered content is available, a small blue button appears in the top right
- The button says "User-Triggered Content"
- Tap the button to view the content
- Content availability is checked continuously

## Code Highlights

### SDK Configuration (AppDelegate.swift:9)
```swift
import WaveCxSdk

let mockConfig = MockModeConfig(
    enabled: true,
    networkDelay: 0.5,
    contentStrategy: .allTriggerPoints
)

WaveCx.configureShared(
    organizationCode: "demo-org",
    debugMode: true,
    mockModeConfig: mockConfig
)
```

### Starting a Session (WaveCxViewModel.swift:33)
```swift
try await WaveCx.shared.startUserSession(
    userId: userId,
    userAttributes: userAttributes
)
```

### Triggering Content (HomeView.swift:141)
```swift
waveCxViewModel.triggerPoint("home-screen")
```

### Checking Content Availability (HomeView.swift:58)
```swift
// Only show trigger button if popup content is available
if waveCxViewModel.triggerPointsWithContent.contains("feature-announcement") {
    TriggerButton(
        title: "Feature Announcement",
        icon: "megaphone.fill",
        color: .orange,
        triggerCode: "feature-announcement"
    )
}

// Use the SDK method directly to check for any content
if WaveCx.shared.hasContent(for: "promo-offer") {
    Button("View Promotion") {
        WaveCx.shared.triggerPoint(triggerPointCode: "promo-offer")
    }
}

// Check for popup content only
if WaveCx.shared.hasContent(for: "home-screen", presentationType: "popup") {
    // This trigger has automatic popup content
}

// Check for button-triggered content only
if WaveCx.shared.hasContent(for: "help", presentationType: "button-triggered") {
    // This trigger has user-triggered content
}
```

### Custom Delegate (WaveCxViewModel.swift:110)
```swift
class WaveCxAnalyticsDelegate: WaveCxDelegate {
    func waveCx(_ waveCx: WaveCx, didDisplay content: Content) {
        // Track analytics event
    }
    // ... other delegate methods
}
```

## Best Practices Demonstrated

### ✅ Architecture
- **MVVM Pattern**: View models manage SDK state
- **Observable Objects**: SwiftUI state management
- **Environment Objects**: Share view model across views
- **Delegate Pattern**: Track SDK events for analytics

### ✅ Session Management
- Start session on login with user attributes
- End session on logout
- Async/await for session operations
- Error handling with user feedback

### ✅ Trigger Points
- Trigger on view appearance for context
- Manual triggers for user actions
- Descriptive trigger codes
- Multiple trigger points per screen

### ✅ User Experience
- Smooth animations for content availability
- Non-intrusive user-triggered content
- Loading states during operations
- Clear visual feedback

### ✅ Testing & Development
- Mock mode for offline testing
- Debug logging for troubleshooting
- Analytics tracking for insights
- Toggle features at runtime

## Troubleshooting

### No content appearing?
- Check that mock mode is enabled in `AppDelegate.swift`
- Verify debug logging in console
- Ensure you've started a user session (logged in)

### Build errors?
- Make sure the WaveCx package is properly linked
- Clean build folder (`Cmd + Shift + K`)
- Verify Xcode version is 15.0 or later

### Can't see analytics?
- Go to Settings tab
- Tap "View Event Log"
- Events appear as you interact with the app

## Learn More

- [WaveCX SDK Documentation](../README.md)
- [Getting Started Guide](../WaveCx.docc/GettingStarted.md)
- [SwiftUI Integration Guide](../WaveCx.docc/SwiftUIIntegration.md)
- [UIKit Integration Guide](../WaveCx.docc/UIKitIntegration.md)

## License

This example app is part of the WaveCX iOS SDK and is subject to the same license terms.

---

**Need help?** Check the main SDK documentation or review the code comments for detailed explanations.
