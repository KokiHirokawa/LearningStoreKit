import UIKit
import StoreKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        SKPaymentQueue.default().add(InAppPurchaseObserver.shared)
        return true
    }
}
