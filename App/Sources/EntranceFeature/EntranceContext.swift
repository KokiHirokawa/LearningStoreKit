import ComposableArchitecture
import ComposableStoreKit

public struct EntranceState {
    public var isLoading: Bool = false
    public var currentSubscription: StoreKitClient.Product?
    public var subscriptions: [StoreKitClient.Product] = []

    public init() {}
}

public enum EntranceAction {
    case onAppear
    case productsResponse(Result<[StoreKitClient.Product], Error>)
    case fetchCurrentSubscription
    case currentSubscriptionResponse(StoreKitClient.Product?)
    case subscribe(StoreKitClient.Product)
    case subscribeResponse(Result<Void, Error>)
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
                    .catchToEffect(EntranceAction.productsResponse)
                    .merge(with: .init(value: .fetchCurrentSubscription))
                    .eraseToEffect()

            case let .productsResponse(.success(products)):
                state.isLoading = false
                state.subscriptions = products
                return .none

            case .productsResponse(.failure):
                state.isLoading = false
                return .none

            case .fetchCurrentSubscription:
                let subscriptions = state.subscriptions
                return environment.storeKit
                    .fetchPurchasedProductIDs()
                    .map { productIDs in
                        let currentSubscription = subscriptions.first { productIDs.contains($0.id) }
                        return EntranceAction.currentSubscriptionResponse(currentSubscription)
                    }

            case let .currentSubscriptionResponse(subscription):
                state.currentSubscription = subscription
                return .none

            case let .subscribe(product):
                return environment.storeKit.purchase(product)
                    .catchToEffect(EntranceAction.subscribeResponse)

            case .subscribeResponse(.success):
                return .init(value: EntranceAction.fetchCurrentSubscription)

            case .subscribeResponse(.failure):
                // FIXME: Show alert
                return .none
            }
        }
    )
