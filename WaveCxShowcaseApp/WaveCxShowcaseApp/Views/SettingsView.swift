import SwiftUI
import WaveCxSdk

struct SettingsView: View {
    @EnvironmentObject var waveCxViewModel: WaveCxViewModel
    @State private var showAnalytics = false
    @State private var debugModeEnabled = true

    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section("Profile") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(waveCxViewModel.currentUserId ?? "Guest")
                                .font(.headline)
                            Text("Member since 2023")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Account Settings
                Section("Account Settings") {
                    NavigationLink(destination: Text("Security Settings")) {
                        Label("Security & Privacy", systemImage: "lock.fill")
                    }

                    NavigationLink(destination: Text("Notifications")) {
                        Label("Notifications", systemImage: "bell.fill")
                    }

                    NavigationLink(destination: Text("Linked Accounts")) {
                        Label("Linked Accounts", systemImage: "link")
                    }
                }

                // SDK Configuration
                Section("SDK Configuration") {
                    Toggle("Debug Mode", isOn: $debugModeEnabled)
                        .onChange(of: debugModeEnabled) { newValue in
                            WaveCx.shared.debugMode = newValue
                        }

                    HStack {
                        Text("Mock Mode")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Enabled")
                            .foregroundColor(.green)
                    }

                    HStack {
                        Text("Organization")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("demo-org")
                            .foregroundColor(.primary)
                    }
                }

                // Analytics
                Section("Analytics & Events") {
                    Button(action: {
                        showAnalytics = true
                    }) {
                        HStack {
                            Label("View Event Log", systemImage: "chart.bar.fill")
                            Spacer()
                            Text("\(waveCxViewModel.analyticsEvents.count)")
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }

                    Button(action: {
                        waveCxViewModel.clearAnalytics()
                    }) {
                        Label("Clear Event Log", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }

                // Banking Features
                Section("Banking Services") {
                    NavigationLink(destination: Text("Statements & Documents")) {
                        Label("Statements & Documents", systemImage: "doc.text.fill")
                    }

                    NavigationLink(destination: Text("Bill Pay")) {
                        Label("Bill Pay", systemImage: "dollarsign.circle.fill")
                    }

                    NavigationLink(destination: Text("ATM & Branch Locations")) {
                        Label("ATM & Branch Locations", systemImage: "mappin.circle.fill")
                    }
                }

                // Actions
                Section {
                    Button(action: {
                        waveCxViewModel.endSession()
                    }) {
                        HStack {
                            Spacer()
                            Label("Sign Out", systemImage: "arrow.right.square")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showAnalytics) {
                AnalyticsView()
            }
            .onAppear {
                debugModeEnabled = WaveCx.shared.debugMode
            }
        }
    }
}

struct AnalyticsView: View {
    @EnvironmentObject var waveCxViewModel: WaveCxViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                if waveCxViewModel.analyticsEvents.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No events yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Events will appear as you interact with the app")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else {
                    ForEach(waveCxViewModel.analyticsEvents) { event in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(event.type)
                                    .font(.headline)
                                Spacer()
                                Text(event.timestamp, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Text(event.details)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Event Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(WaveCxViewModel())
}
