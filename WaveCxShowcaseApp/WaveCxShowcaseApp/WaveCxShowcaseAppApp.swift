import SwiftUI
import WaveCxSdk

@main
struct WaveCxShowcaseAppApp: App {
    @StateObject private var waveCxViewModel = WaveCxViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(waveCxViewModel)
        }
    }
}
