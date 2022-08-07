import CombineSchedulers
import ComposableStoreKit
import PremiumFeature

public struct AppEnvironment {
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    public var storeKit: StoreKitClient

    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        storeKit: StoreKitClient
    ) {
        self.mainQueue = mainQueue
        self.storeKit = storeKit
    }
}

extension AppEnvironment {
    var premium: PremiumEnvironment {
        .init(
            mainQueue: mainQueue,
            storeKit: storeKit
        )
    }
}
