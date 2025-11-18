import SwiftUI

struct HomeView: View {
    @EnvironmentObject var waveCxViewModel: WaveCxViewModel
    @State private var showWelcomeMessage = false

    // Define the trigger points we want to check
    private let triggerPoints = [
        "account-dashboard",
        "low-balance-alert",
        "savings-promotion",
        "credit-card-offer"
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Account Balance Card
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total Balance")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))

                                Text("$12,483.52")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            Image(systemName: "eye.slash")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.8))
                        }

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Checking")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                Text("$8,234.12")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Savings")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                Text("$4,249.40")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)

                    // Trigger Point Buttons
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Alerts & Notifications")
                            .font(.headline)
                            .padding(.horizontal)

                        if waveCxViewModel.triggerPointsWithContent.contains("account-dashboard") {
                            TriggerButton(
                                title: "Dashboard Updates",
                                icon: "chart.bar.fill",
                                color: .blue,
                                triggerCode: "account-dashboard"
                            )
                        }

                        if waveCxViewModel.triggerPointsWithContent.contains("low-balance-alert") {
                            TriggerButton(
                                title: "Low Balance Alert",
                                icon: "exclamationmark.triangle.fill",
                                color: .orange,
                                triggerCode: "low-balance-alert"
                            )
                        }

                        if waveCxViewModel.triggerPointsWithContent.contains("savings-promotion") {
                            TriggerButton(
                                title: "Savings Account Promotion",
                                icon: "percent",
                                color: .green,
                                triggerCode: "savings-promotion"
                            )
                        }

                        if waveCxViewModel.triggerPointsWithContent.contains("credit-card-offer") {
                            TriggerButton(
                                title: "Credit Card Offer",
                                icon: "creditcard.fill",
                                color: .purple,
                                triggerCode: "credit-card-offer"
                            )
                        }

                        if waveCxViewModel.triggerPointsWithContent.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "tray")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary)
                                Text("No content available")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text("Content will appear here when available for trigger points")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }

                    // Info Section
                    VStack(alignment: .leading, spacing: 10) {
                        Label("About Smart Notifications", systemImage: "info.circle.fill")
                            .font(.headline)

                        Text("WaveBank uses intelligent triggers to show you relevant information at the right time. Only active notifications are displayed above.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("These notifications demonstrate WaveCX SDK features with contextual banking alerts and offers based on your activity.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Accounts")
            .overlay(alignment: .topTrailing) {
                if waveCxViewModel.hasUserTriggeredContent,
                   let triggerPoint = waveCxViewModel.userTriggeredContentTriggerPoint,
                   triggerPoint == "account-dashboard" {
                    Button(action: {
                        waveCxViewModel.showUserTriggeredContent(for: triggerPoint)
                    }) {
                        Text("User-Triggered Content")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(), value: waveCxViewModel.hasUserTriggeredContent)
                }
            }
            .onAppear {
                // Only trigger content if session is active
                guard waveCxViewModel.isSessionActive else { return }

                // Set up automatic content refresh for trigger points (popup content only)
                // This will auto-update when content is displayed/dismissed
                waveCxViewModel.setupContentRefresh(for: triggerPoints, presentationType: "popup")

                // Monitor button-triggered content for account-dashboard
                waveCxViewModel.setupButtonContentMonitoring(for: "account-dashboard")

                // Trigger when home view appears
                waveCxViewModel.triggerPoint("account-dashboard")
                withAnimation {
                    showWelcomeMessage = true
                }
            }
        }
    }
}

struct TriggerButton: View {
    @EnvironmentObject var waveCxViewModel: WaveCxViewModel
    let title: String
    let icon: String
    let color: Color
    let triggerCode: String

    var body: some View {
        Button(action: {
            waveCxViewModel.triggerPoint(triggerCode)
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40)

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Tap to trigger")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
        .environmentObject(WaveCxViewModel())
}
