import UIKit
import WaveCxSdk

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        // Configure WaveCX SDK with mock mode enabled for demonstration
        // In production, you would use your actual organization code
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

        print("✅ WaveCX SDK configured successfully")

        return true
    }
}
