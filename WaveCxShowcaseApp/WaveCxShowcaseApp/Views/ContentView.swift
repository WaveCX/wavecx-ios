import SwiftUI
import WaveCxSdk

struct ContentView: View {
    @EnvironmentObject var waveCxViewModel: WaveCxViewModel

    var body: some View {
        Group {
            if waveCxViewModel.isSessionActive {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var waveCxViewModel: WaveCxViewModel

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Accounts", systemImage: "dollarsign.circle.fill")
                }

            ProductsView()
                .tabItem {
                    Label("Services", systemImage: "building.columns.fill")
                }

            SettingsView()
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WaveCxViewModel())
}
