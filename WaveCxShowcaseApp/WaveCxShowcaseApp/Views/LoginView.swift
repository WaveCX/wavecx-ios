import SwiftUI

struct LoginView: View {
    @EnvironmentObject var waveCxViewModel: WaveCxViewModel
    @State private var userId = ""
    @State private var isLoading = false

    // Demo user profiles
    private let demoUsers = [
        ("sarah.johnson", "Sarah Johnson", "Premium Member"),
        ("michael.chen", "Michael Chen", "New Customer"),
        ("emily.davis", "Emily Davis", "Business Account")
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)

                    Text("WaveBank")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Your trusted financial partner")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)

                // Quick Login Options
                VStack(alignment: .leading, spacing: 15) {
                    Text("Quick Login")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    ForEach(demoUsers, id: \.0) { user in
                        Button(action: {
                            login(userId: user.0, userType: user.2)
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(user.1)
                                        .font(.headline)
                                    Text(user.2)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)

                // Or Divider
                HStack {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(height: 1)
                    Text("or")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 10)
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(height: 1)
                }
                .padding(.horizontal)

                // Custom User ID
                VStack(spacing: 15) {
                    TextField("Enter User ID", text: $userId)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disabled(isLoading)

                    Button(action: {
                        login(userId: userId, userType: "Custom")
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(isLoading ? "Starting Session..." : "Start Session")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(userId.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(userId.isEmpty || isLoading)
                }
                .padding(.horizontal)

                Spacer()

                // Info Footer
                VStack(spacing: 5) {
                    Text("Demo banking app showcasing WaveCX SDK")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Running in Mock Mode • Not a real bank")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
    }

    private func login(userId: String, userType: String) {
        isLoading = true

        // Add user attributes for targeting
        let attributes = [
            "userType": userType,
            "platform": "iOS"
        ]

        Task {
            await waveCxViewModel.startSession(
                userId: userId,
                userAttributes: attributes
            )
            isLoading = false
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(WaveCxViewModel())
}
