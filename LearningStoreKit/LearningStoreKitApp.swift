import AppFeature
import SwiftUI

@main
struct LearningStoreKitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(
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
        .init(
            mainQueue: .main,
            storeKit: .live()
        )
    }
}
