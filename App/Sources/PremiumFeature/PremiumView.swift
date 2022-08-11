import Combine
import ComposableArchitecture
import ComposableStoreKit
import SwiftUI

public struct PremiumView: View {

    @ObservedObject var viewStore: ViewStore<PremiumViewState, PremiumAction>

    public init(store: Store<PremiumState, PremiumAction>) {
        self.viewStore = ViewStore(store.scope(state: PremiumViewState.init))
    }

    public var body: some View {
        VStack {
            if viewStore.isLoading {
                ProgressView()
            } else {
                List {
                    if let currentSubscription = viewStore.currentSubscription {
                        Section("My Subscription") {
                            Text(currentSubscription.displayName)
                                .foregroundColor(.orange)
                        }
                    }

                    Section("Navigation: Auto-Renewable Subscription") {
                        ForEach(viewStore.subscriptions) { subscription in
                            Text(subscription.displayName)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
    }
}

struct PremiumViewState: Equatable {
    public var isLoading: Bool
    public var currentSubscription: StoreKitClient.Product?
    public var subscriptions: [StoreKitClient.Product]

    init(state: PremiumState) {
        self.isLoading = state.isLoading
        self.currentSubscription = state.currentSubscription
        self.subscriptions = state.subscriptions
    }
}

public struct PremiumState {
    public var isLoading: Bool = false
    public var currentSubscription: StoreKitClient.Product?
    public var subscriptions: [StoreKitClient.Product] = []

    public init() {}
}

public enum PremiumAction {
    case onAppear
    case productsResponse(Result<[StoreKitClient.Product], Error>)
    case fetchCurrentSubscription
    case currentSubscriptionResponse(StoreKitClient.Product?)
    case subscribe
}

public struct PremiumEnvironment {
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

public let premiumReducer = Reducer<PremiumState, PremiumAction, PremiumEnvironment>
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
                    .catchToEffect(PremiumAction.productsResponse)
                    .merge(with: .init(value: .fetchCurrentSubscription))
                    .eraseToEffect()

            case let .productsResponse(.success(products)):
                state.isLoading = false
                state.subscriptions = products
                return .none

            case .fetchCurrentSubscription:
                let subscriptions = state.subscriptions
                return environment.storeKit
                    .fetchPurchasedProductIDs()
                    .map { productIDs in
                        let currentSubscription = subscriptions.first { productIDs.contains($0.id) }
                        return PremiumAction.currentSubscriptionResponse(currentSubscription)
                    }

            case let .currentSubscriptionResponse(subscription):
                state.currentSubscription = subscription
                return .none

            case .productsResponse(.failure):
                state.isLoading = false
                return .none

            case .subscribe:
                return .none
            }
        }
    )


#if DEBUG
extension PremiumEnvironment {
    static var noop: Self {
        .init(
            mainQueue: .immediate,
            storeKit: .live() // - TODO: Replace with mock
        )
    }
}

enum PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView(
            store: .init(
                initialState: .init(),
                reducer: premiumReducer,
                environment: .noop
            )
        )
    }
}
#endif
