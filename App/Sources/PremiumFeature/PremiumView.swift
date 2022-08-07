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
    public var subscriptions: [StoreKitClient.Product]

    init(state: PremiumState) {
        self.isLoading = state.isLoading
        self.subscriptions = state.subscriptions
    }
}

public struct PremiumState {
    public var isLoading: Bool = false
    public var subscriptions: [StoreKitClient.Product] = []

    public init() {}
}

public enum PremiumAction {
    case onAppear
    case productsResponse(Result<[StoreKitClient.Product], Error>)
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
                    .receive(on: environment.mainQueue)
                    .catchToEffect(PremiumAction.productsResponse)

            case let .productsResponse(.success(products)):
                state.isLoading = false
                state.subscriptions = products
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
