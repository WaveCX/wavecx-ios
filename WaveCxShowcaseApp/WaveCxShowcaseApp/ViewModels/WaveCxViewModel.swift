import Foundation
import WaveCxSdk
import Combine

/// Observable view model that manages WaveCX SDK state and delegates
class WaveCxViewModel: ObservableObject {
    @Published var isSessionActive = false
    @Published var currentUserId: String?
    @Published var hasUserTriggeredContent = false
    @Published var analyticsEvents: [AnalyticsEvent] = []
    @Published var triggerPointsWithContent: Set<String> = []
    @Published var userTriggeredContentTriggerPoint: String?

    private var delegate: WaveCxAnalyticsDelegate?
    private var monitoredTriggerPoints: [String] = []
    private var monitoredPresentationType: String?
    private var monitoredButtonTriggerPoint: String?

    struct AnalyticsEvent: Identifiable {
        let id = UUID()
        let timestamp: Date
        let type: String
        let details: String
    }

    init() {
        // Create and set up delegate
        delegate = WaveCxAnalyticsDelegate(
            onEvent: { [weak self] event in
                self?.addAnalyticsEvent(event)
            },
            onContentChanged: { [weak self] in
                self?.handleContentChanged()
            }
        )
        WaveCx.shared.delegate = delegate

    }

    /// Set up automatic content refresh for specific trigger points
    /// When content availability changes, the monitored triggers will be rechecked
    func setupContentRefresh(for triggerPoints: [String], presentationType: String? = nil) {
        monitoredTriggerPoints = triggerPoints
        monitoredPresentationType = presentationType
        // Do initial refresh
        refreshContentAvailability(for: triggerPoints, presentationType: presentationType)
    }

    private func handleContentChanged() {
        // Re-check monitored trigger points when content changes
        if !monitoredTriggerPoints.isEmpty {
            refreshContentAvailability(for: monitoredTriggerPoints, presentationType: monitoredPresentationType)
        }
        // Re-check button-triggered content if monitoring
        if monitoredButtonTriggerPoint != nil {
            checkButtonTriggeredContent()
        }
    }

    /// Start a user session with the WaveCX SDK
    func startSession(userId: String, userAttributes: [String: String]? = nil) async {
        do {
            try await WaveCx.shared.startUserSession(
                userId: userId,
                userAttributes: userAttributes
            )

            await MainActor.run {
                self.isSessionActive = true
                self.currentUserId = userId
                self.addAnalyticsEvent(.init(
                    timestamp: Date(),
                    type: "Session Started",
                    details: "User: \(userId)"
                ))
            }

            print("✅ Session started for user: \(userId)")
        } catch {
            print("❌ Failed to start session: \(error)")
            await MainActor.run {
                self.addAnalyticsEvent(.init(
                    timestamp: Date(),
                    type: "Session Error",
                    details: error.localizedDescription
                ))
            }
        }
    }

    /// End the current user session
    func endSession() {
        WaveCx.shared.endUserSession()
        isSessionActive = false
        currentUserId = nil
        hasUserTriggeredContent = false

        addAnalyticsEvent(.init(
            timestamp: Date(),
            type: "Session Ended",
            details: "User logged out"
        ))

        print("✅ Session ended")
    }

    /// Trigger a specific point in the app
    func triggerPoint(_ code: String) {
        WaveCx.shared.triggerPoint(triggerPointCode: code)

        addAnalyticsEvent(.init(
            timestamp: Date(),
            type: "Trigger Point",
            details: code
        ))
    }

    /// Show user-triggered content if available
    func showUserTriggeredContent(for triggerPointCode: String? = nil) {
        WaveCx.shared.showUserTriggeredContent(for: triggerPointCode)

        addAnalyticsEvent(.init(
            timestamp: Date(),
            type: "Show Content",
            details: "User-triggered content displayed for: \(triggerPointCode ?? "most recent")"
        ))
    }

    /// Set up monitoring for button-triggered content on a specific trigger point
    func setupButtonContentMonitoring(for triggerPoint: String) {
        monitoredButtonTriggerPoint = triggerPoint
        // Do initial check
        checkButtonTriggeredContent()
    }

    private func checkButtonTriggeredContent() {
        guard let triggerPoint = monitoredButtonTriggerPoint else { return }
        let hasContent = WaveCx.shared.hasUserTriggeredContentForTriggerPoint(triggerPointCode: triggerPoint)
        if hasUserTriggeredContent != hasContent {
            hasUserTriggeredContent = hasContent
            userTriggeredContentTriggerPoint = hasContent ? triggerPoint : nil
        }
    }

    /// Clear analytics history
    func clearAnalytics() {
        analyticsEvents.removeAll()
    }

    /// Check if a specific trigger point has content available
    func hasContent(for triggerPointCode: String, presentationType: String? = nil) -> Bool {
        return WaveCx.shared.hasContent(for: triggerPointCode, presentationType: presentationType)
    }

    /// Refresh content availability for trigger points
    func refreshContentAvailability(for triggerPoints: [String], presentationType: String? = nil) {
        var availableTriggerPoints = Set<String>()
        for triggerPoint in triggerPoints {
            if WaveCx.shared.hasContent(for: triggerPoint, presentationType: presentationType) {
                availableTriggerPoints.insert(triggerPoint)
            }
        }
        if triggerPointsWithContent != availableTriggerPoints {
            triggerPointsWithContent = availableTriggerPoints
        }
    }

    private func addAnalyticsEvent(_ event: AnalyticsEvent) {
        analyticsEvents.insert(event, at: 0)
        // Keep only last 50 events
        if analyticsEvents.count > 50 {
            analyticsEvents.removeLast()
        }
    }
}

/// Delegate that tracks WaveCX SDK events for analytics
class WaveCxAnalyticsDelegate: WaveCxDelegate {
    private let onEvent: (WaveCxViewModel.AnalyticsEvent) -> Void
    private let onContentChangedHandler: () -> Void

    init(onEvent: @escaping (WaveCxViewModel.AnalyticsEvent) -> Void, onContentChanged: @escaping () -> Void) {
        self.onEvent = onEvent
        self.onContentChangedHandler = onContentChanged
    }

    func onError(error: Error) {
        onEvent(.init(
            timestamp: Date(),
            type: "Error",
            details: error.localizedDescription
        ))
    }

    func onContentReceived(content: [Content]) {
        onEvent(.init(
            timestamp: Date(),
            type: "Content Received",
            details: "Loaded \(content.count) content item(s)"
        ))
    }

    func onWillShowContent(content: Content, cancel: @escaping () -> Void) {
        onEvent(.init(
            timestamp: Date(),
            type: "Will Display",
            details: "Content is about to be displayed"
        ))
        // Allow display by not calling cancel()
    }

    func onDidShowContent(content: Content) {
        onEvent(.init(
            timestamp: Date(),
            type: "Did Display",
            details: "Content was displayed to user"
        ))
    }

    func onContentDismissed() {
        onEvent(.init(
            timestamp: Date(),
            type: "Content Dismissed",
            details: "User closed the content"
        ))
    }

    func onContentChanged() {
        onEvent(.init(
            timestamp: Date(),
            type: "Content Changed",
            details: "Content availability updated"
        ))
        onContentChangedHandler()
    }
}
