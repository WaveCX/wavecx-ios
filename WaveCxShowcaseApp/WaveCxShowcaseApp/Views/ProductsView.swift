import SwiftUI

struct ProductsView: View {
    @EnvironmentObject var waveCxViewModel: WaveCxViewModel
    @State private var hasInvestmentPromotion = false

    private let products = [
        Product(name: "Premium Checking", price: "No monthly fees", icon: "checkmark.circle.fill", color: .blue),
        Product(name: "High-Yield Savings", price: "4.5% APY", icon: "chart.line.uptrend.xyaxis", color: .green),
        Product(name: "Credit Card", price: "0% intro APR", icon: "creditcard.fill", color: .purple),
        Product(name: "Personal Loan", price: "From 5.99%", icon: "dollarsign.circle.fill", color: .orange)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        Text("Banking Products")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Explore our financial services")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)

                    // Products Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(products) { product in
                            ProductCard(product: product)
                        }
                    }
                    .padding(.horizontal)

                    // Special Offer Section - only show if SDK has content
                    if hasInvestmentPromotion {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "gift.fill")
                                    .foregroundColor(.yellow)
                                Text("Limited Time Offers")
                                    .font(.headline)
                            }

                            Button(action: {
                                waveCxViewModel.triggerPoint("investment-promotion")
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("New Investment Accounts")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("Get $200 bonus when you open an account")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                    Spacer()
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                }
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.green, .blue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    Spacer()
                }
            }
            .navigationTitle("Services")
            .onAppear {
                // Only trigger content if session is active
                guard waveCxViewModel.isSessionActive else { return }

                // Check if investment promotion content is available
                hasInvestmentPromotion = waveCxViewModel.hasContent(for: "investment-promotion", presentationType: "popup")

                // Set up automatic content refresh for investment promotion
                waveCxViewModel.setupContentRefresh(for: ["investment-promotion"], presentationType: "popup")

                // Trigger when services view appears
                waveCxViewModel.triggerPoint("banking-services")
            }
            .onReceive(waveCxViewModel.$triggerPointsWithContent) { triggerPoints in
                // Update visibility when content changes
                withAnimation {
                    hasInvestmentPromotion = triggerPoints.contains("investment-promotion")
                }
            }
        }
    }
}

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let icon: String
    let color: Color
}

struct ProductCard: View {
    @EnvironmentObject var waveCxViewModel: WaveCxViewModel
    let product: Product

    var body: some View {
        Button(action: {
            // Product selected - no trigger point
        }) {
            VStack(spacing: 15) {
                Image(systemName: product.icon)
                    .font(.system(size: 40))
                    .foregroundColor(product.color)

                VStack(spacing: 5) {
                    Text(product.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)

                    Text(product.price)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text("Learn More")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProductsView()
        .environmentObject(WaveCxViewModel())
}
