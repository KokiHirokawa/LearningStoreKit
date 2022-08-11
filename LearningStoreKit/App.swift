import AppFeature
import ComposableArchitecture
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(initialState: .init(), reducer: appReducer, environment: .live)
    lazy var viewStore = ViewStore(self.store.scope(state: { _ in () }))

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        self.viewStore.send(.appDelegate(.didFinishLaunching))
        return true
    }
}

@main
struct LearningStoreKitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(store: self.appDelegate.store)
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
