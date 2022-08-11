import Combine
import ComposableArchitecture
import ComposableStoreKit
import SwiftUI

struct EntranceViewState: Equatable {
    public var isLoading: Bool
    public var currentSubscription: StoreKitClient.Product?
    public var subscriptions: [StoreKitClient.Product]

    init(state: EntranceState) {
        self.isLoading = state.isLoading
        self.currentSubscription = state.currentSubscription
        self.subscriptions = state.subscriptions
    }
}

public struct EntranceView: View {

    @ObservedObject var viewStore: ViewStore<EntranceViewState, EntranceAction>

    public init(store: Store<EntranceState, EntranceAction>) {
        self.viewStore = ViewStore(store.scope(state: EntranceViewState.init))
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
                            HStack {
                                Text(subscription.displayName)

                                Spacer()

                                Button {
                                    viewStore.send(.subscribe(subscription))
                                } label: {
                                    Text("Subscribe")
                                }
                            }
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

#if DEBUG
extension EntranceEnvironment {
    static var noop: Self {
        .init(
            mainQueue: .immediate,
            storeKit: .live() // - TODO: Replace with mock
        )
    }
}

enum EntranceView_Previews: PreviewProvider {
    static var previews: some View {
        EntranceView(
            store: .init(
                initialState: .init(),
                reducer: entranceReducer,
                environment: .noop
            )
        )
    }
}
#endif
