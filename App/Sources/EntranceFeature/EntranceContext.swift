import ComposableArchitecture
import ComposableStoreKit

public struct EntranceState {
    public var isLoading = false
    public var isSubscribeButtonEnabled = false
    public var subscriptions: [StoreKitClient.Product] = []

    public init() {}
}

public enum EntranceAction {
    case onAppear
    case subscriptionsResponse(Result<[StoreKitClient.Product], Error>)
    case subscribe(StoreKitClient.Product)
    case succeededSubscribe
    case failedSubscribe(Error)
}

public struct EntranceEnvironment {
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

public let entranceReducer = Reducer<EntranceState, EntranceAction, EntranceEnvironment>
    .combine(
        .init { state, action, environment in
            switch action {
            case .onAppear:
                state.isLoading = true

                return environment.storeKit
                    .fetchProducts([
                        "learning.premium.month",
                        "learning.premium.year"
                    ])
                    .catchToEffect(EntranceAction.subscriptionsResponse)

            case let .subscriptionsResponse(.success(subscriptions)):
                state.isLoading = false
                state.subscriptions = subscriptions
                return .none

            case .subscriptionsResponse(.failure):
                state.isLoading = false
                return .none

            case let .subscribe(product):
                return environment.storeKit.purchase(product)
                    .catchToEffect {
                        switch $0 {
                        case .success:
                            return EntranceAction.succeededSubscribe
                        case let .failure(error):
                            return EntranceAction.failedSubscribe(error)
                        }
                    }

            case .succeededSubscribe:
                return .none

            case .failedSubscribe:
                // FIXME: Show alert
                return .none
            }
        }
    )
