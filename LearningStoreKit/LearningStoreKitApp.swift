import App
import SwiftUI

@main
struct LearningStoreKitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(
                    initialState: .init(),
                    reducer: appReducer,
                    environment: .live
                )
            )
        }
    }
}

extension AppEnvironment {
    static var live: Self {
        .init()
    }
}
